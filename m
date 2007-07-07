Return-Path: <linux-kernel-owner+w=401wt.eu-S1756049AbXGGVU0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756049AbXGGVU0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Jul 2007 17:20:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751966AbXGGVUR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Jul 2007 17:20:17 -0400
Received: from moutng.kundenserver.de ([212.227.126.188]:59215 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751817AbXGGVUQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Jul 2007 17:20:16 -0400
Date: Sat, 7 Jul 2007 23:18:59 +0200 (CEST)
From: Bodo Eggert <7eggert@gmx.de>
To: Jan Engelhardt <jengelh@computergmbh.de>
cc: "H. Peter Anvin" <hpa@zytor.com>, Bodo Eggert <7eggert@gmx.de>,
       linux-kernel@vger.kernel.org
Subject: Re: [RFC][Patch] Allow not mounting a root fs
In-Reply-To: <Pine.LNX.4.64.0707072030230.1536@fbirervta.pbzchgretzou.qr>
Message-ID: <Pine.LNX.4.58.0707072255260.3562@be1.lrz>
References: <Pine.LNX.4.58.0707060318160.26869@be1.lrz> <468DA42D.7050309@zytor.com>
 <Pine.LNX.4.64.0707072030230.1536@fbirervta.pbzchgretzou.qr>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-be10.7eggert.dyndns.org-MailScanner-Information: See www.mailscanner.info for information
X-be10.7eggert.dyndns.org-MailScanner: Found to be clean
X-be10.7eggert.dyndns.org-MailScanner-From: 7eggert@gmx.de
X-Provags-ID: V01U2FsdGVkX1/pO87ROlKaTboN52zNJ/116FVxIDviMM1DwFO
 etgxfEZANv+Ezczvpk9MMr5cGrNTC7jRt8qpgecyNvORdsH7QP
 tCOc0vcC/XhYqoCmA+0Eg==
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 7 Jul 2007, Jan Engelhardt wrote:
> On Jul 5 2007 19:08, H. Peter Anvin wrote:

> >> BTW: Is it possible to mount a tmpfs on / before extracting the cpio?
> >
> >Not in the stock kernel.  There have been some patches floating around
> >for that, I think.
> 
> What would it buy? rootfs is a tmpfs, is not it?

As far as I understand, it is a ramfs aka. non-swappable tmpfs without any 
limit and including a chance of DoSing the system.

Since I'm toying with root-on-initcpio, I'm looking for things that might 
make the task some easier.

Currently I'm thinking about changing the root=initramfs to root=tmpfs and
additionally mounting a tmpfs on / before unpacking the cpios. OTOH, this 
seems to be a little bit messy. OTOH again, in _that_ boot code, nobody
should complain :)

-- 
"Whoever said the pen is mightier than the sword obviously never
encountered automatic weapons."
-Gen. Douglas MacArthur
