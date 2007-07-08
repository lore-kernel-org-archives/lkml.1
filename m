Return-Path: <linux-kernel-owner+w=401wt.eu-S1756955AbXGHKhZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756955AbXGHKhZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Jul 2007 06:37:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754471AbXGHKhR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Jul 2007 06:37:17 -0400
Received: from [212.12.190.172] ([212.12.190.172]:33999 "EHLO raad.intranet"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753600AbXGHKhQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Jul 2007 06:37:16 -0400
From: Al Boldi <a1426z@gawab.com>
To: linux-kernel@vger.kernel.org
Subject: Re: [RFC][Patch] Allow not mounting a root fs
Date: Sun, 8 Jul 2007 13:36:27 +0300
User-Agent: KMail/1.5
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200707081336.27985.a1426z@gawab.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Bodo Eggert wrote:
> On Sat, 7 Jul 2007, Jan Engelhardt wrote:
> > On Jul 5 2007 19:08, H. Peter Anvin wrote:
> > >> BTW: Is it possible to mount a tmpfs on / before extracting the cpio?
> > >
> > >Not in the stock kernel.  There have been some patches floating around
> > >for that, I think.
> > 
> > What would it buy? rootfs is a tmpfs, is not it?
> 
> As far as I understand, it is a ramfs aka. non-swappable tmpfs without any 
> limit and including a chance of DoSing the system.
> 
> Since I'm toying with root-on-initcpio, I'm looking for things that might 
> make the task some easier.
> 
> Currently I'm thinking about changing the root=initramfs to root=tmpfs and
> additionally mounting a tmpfs on / before unpacking the cpios. OTOH, this 
> seems to be a little bit messy. OTOH again, in _that_ boot code, nobody
> should complain :)

Try this "[PATCH] initramfs: Allow rootfs to use tmpfs instead of ramfs".

It's trivial and should be in mainline.


Thanks!

--
Al


