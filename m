Return-Path: <linux-kernel-owner+w=401wt.eu-S938368AbXHLU43@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S938368AbXHLU43 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Aug 2007 16:56:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S938328AbXHLUz7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 12 Aug 2007 16:55:59 -0400
Received: from sovereign.computergmbh.de ([85.214.69.204]:39853 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S938281AbXHLUz5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Aug 2007 16:55:57 -0400
Date: Sun, 12 Aug 2007 22:55:56 +0200 (CEST)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: Al Viro <viro@ftp.linux.org.uk>
cc: Mark Cannon <random.bits@rogers.com>, "H. Peter Anvin" <hpa@zytor.com>,
       linux-kernel@vger.kernel.org
Subject: Re: Use of directories to hold root?
In-Reply-To: <20070812202320.GE21089@ftp.linux.org.uk>
Message-ID: <Pine.LNX.4.64.0708122253360.28963@fbirervta.pbzchgretzou.qr>
References: <200708101724.26724.random.bits@rogers.com> <46BCFE01.2040703@zytor.com>
 <Pine.LNX.4.64.0708111753510.3101@fbirervta.pbzchgretzou.qr>
 <200708121539.48332.random.bits@rogers.com>
 <Pine.LNX.4.64.0708122147440.28963@fbirervta.pbzchgretzou.qr>
 <20070812202320.GE21089@ftp.linux.org.uk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Aug 12 2007 21:23, Al Viro wrote:
>> 
>> pivot_root is atomic afaict, for `mount --move` (which I think Al meant 
>> which MS_MOVE - or some C program using mount(2) of your own), you'd 
>> need multiple calls to mount.
>
>Move itself is done by a single syscall anyway...
>
Yes, but you need needed 2 mounts, 1 chdir and one chroot. Plus, you 
have not freed the data in the rootfs. (Well, neither does 
pivot_root, but run-init from klibc will.)


	Jan
-- 
