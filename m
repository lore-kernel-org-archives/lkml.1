Return-Path: <linux-kernel-owner+w=401wt.eu-S1757256AbXHUFcU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757256AbXHUFcU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2007 01:32:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752261AbXHUFcI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Aug 2007 01:32:08 -0400
Received: from sovereign.computergmbh.de ([85.214.69.204]:42100 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751949AbXHUFcH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2007 01:32:07 -0400
Date: Tue, 21 Aug 2007 07:32:06 +0200 (CEST)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: Xin Zhao <uszhaoxin@gmail.com>
cc: linux-kernel <linux-kernel@vger.kernel.org>,
       linux-fsdevel <linux-fsdevel@vger.kernel.org>
Subject: Re: How Linux /proc filesystem convert a fd to the actual pathname?
In-Reply-To: <4ae3c140708201958x3c88b317o2ba9be64177978f5@mail.gmail.com>
Message-ID: <Pine.LNX.4.64.0708210730070.5333@fbirervta.pbzchgretzou.qr>
References: <4ae3c140708201958x3c88b317o2ba9be64177978f5@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


>In the Linux proc filesystem,  /proc/[pid]/fd is a link to the
>actually the actual pathname of the opened file.
>
>I am curious how Linux convert an fd to the pathname?  Does it
>recursively walk back from current dentry to the root?

AFAICS the fd has a pointer to the vma of the file (don't ask me why), 
which in turn has a 'struct file' pointer, which in turn has the 
required 'struct dentry' in it.


	Jan
-- 
