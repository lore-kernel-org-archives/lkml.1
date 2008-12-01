Return-Path: <linux-kernel-owner+w=401wt.eu-S1751177AbYLAKDx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751177AbYLAKDx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2008 05:03:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751954AbYLAKDm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Dec 2008 05:03:42 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:54115 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751636AbYLAKDl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2008 05:03:41 -0500
Date: Mon, 1 Dec 2008 10:03:50 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: weigelt@metux.de
Cc: linux kernel list <linux-kernel@vger.kernel.org>
Subject: Re: scanner interface proposal was: [TALPA] Intro to a linux
 interface for on access scanning (fwd)
Message-ID: <20081201100350.34af705e@lxorguk.ukuu.org.uk>
In-Reply-To: <20081201005142.GA27387@nibiru.local>
References: <alpine.DEB.1.10.0808171824060.12859@asgard.lang.hm>
	<20081123223753.GA16424@nibiru.local>
	<20081123230306.48bc0274@lxorguk.ukuu.org.uk>
	<20081201005142.GA27387@nibiru.local>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.12; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 1 Dec 2008 01:51:42 +0100
Enrico Weigelt <weigelt@metux.de> wrote:

> * Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:
> > > Fine. Why not just putting this into a userland filesystem ?
> > 
> > 1. Performance
> 
> Does it really hurt so bad, compared with all actual AV stuff ?
> It has to go to userland anyway, in case you don't intend to 
> put the scanner into the kernel ;-o

That depends on the scanning and what you are using it for - at least
part of the interest is in asynchronous indexing systems in which case
the answer appears to be no, the scanner doesn't trash your performance.
> 
> > 2. Networked file systems
> 
> What's the problem ?
> (btw: 9P already *IS* an network filesystem ;-P)

Try 9P with an NFS backing store. Try a cluster file system.

> > 3. Ioctls
> 
> Ah, just forgot a while that this crap still exists ;-o
> 
> BUT: do the affected dirs have to contain devices ? 
> Is there any point for pulling /dev through the AV scanner ?

Lots of ioctls apply to files. Please think about what is involved rather
than just assuming.
