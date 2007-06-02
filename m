Return-Path: <linux-kernel-owner+w=401wt.eu-S1762415AbXFBVfi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762415AbXFBVfi (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Jun 2007 17:35:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757953AbXFBVfb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 Jun 2007 17:35:31 -0400
Received: from enterprise.noxa.de ([212.60.197.71]:41914 "EHLO
	enterprise.noxa.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757053AbXFBVfb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Jun 2007 17:35:31 -0400
Date: Sat, 2 Jun 2007 23:34:35 +0200
From: Jonathan Schleifer <js@h3c.de>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: aeb@cwi.nl, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Ignore partition table on device
Message-ID: <20070602233435.4c432bc5@localhost>
In-Reply-To: <4661D32B.2040706@zytor.com>
References: <20070602205513.0312ebe0@localhost>
	<4661D32B.2040706@zytor.com>
X-Mailer: Sylpheed-Claws 2.5.2 (GTK+ 2.10.12; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

"H. Peter Anvin" <hpa@zytor.com> wrote:

> This seems broken.  If nothing else, there should be ways to enable or
> disable this at runtime.

What exactly do you consider broken?
I don't really see a way to change that at runtime since hard disk
partition tables are read at bootup. Or did you mean to change the
device where the partition table should be ignored at runtime, so one
could enable/disable it and reattach the device under the condition
that it's a removable device?

-- 
Jonathan
