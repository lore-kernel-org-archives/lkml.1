Return-Path: <linux-kernel-owner+w=401wt.eu-S1754935AbYCBLST@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754935AbYCBLST (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Mar 2008 06:18:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753453AbYCBLSK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Mar 2008 06:18:10 -0500
Received: from pasmtpa.tele.dk ([80.160.77.114]:54428 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753445AbYCBLSJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Mar 2008 06:18:09 -0500
Subject: Re: [PATCH] chroot= as a new kernel parameter
From: Kasper Sandberg <lkml@metanurb.dk>
To: Stefan Hellermann <stefan@the2masters.de>
Cc: Pawel Plociennik <paplociennik@gmail.com>, linux-kernel@vger.kernel.org
In-Reply-To: <47C9B22D.6010003@the2masters.de>
References: <200803011409.59526.paplociennik@gmail.com>
	 <47C9B22D.6010003@the2masters.de>
Content-Type: text/plain
Date: Sun, 02 Mar 2008 12:17:06 +0100
Message-Id: <1204456626.4117.9.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.4.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2008-03-01 at 20:44 +0100, Stefan Hellermann wrote:
> Pawel Plociennik schrieb:
> > hi *real* hackers,
> > 
> > it is a my first post to lkml and I hope that you will have not been
> > ignored me if I have done some incorrect thing.
> > 
> > In the short this patch has added a new chroot= kernel parameter which can be used
> > to changing a chroot of an init process before it will has been runed.
> > I use that for testing variouses distroes without making a separate partition but
> > by copied a new root-fs to a new subdirectory on the my *base* filesystem.
> 
> Hi!
> 
> Gentoos initrd (build by genkernel) has support for a chrooted boot, the parameter is
> called subdir=
> Maybe other distros have something similar, it's easy to support this with a initrd/initramfs.

Hey!

Im a simple guy though, i prefer this being in the kernel. I do not even
use an initramfs.

> 
> Cheers
> Stefan
> 
> PS: This is my first post to lkml, too :)
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

