Return-Path: <linux-kernel-owner+w=401wt.eu-S1161375AbXDQWTj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161375AbXDQWTj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Apr 2007 18:19:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161383AbXDQWTj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Apr 2007 18:19:39 -0400
Received: from dhazelton.dsl.enter.net ([216.193.185.50]:50481 "EHLO mail"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1161375AbXDQWTi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Apr 2007 18:19:38 -0400
From: Daniel Hazelton <dhazelton@enter.net>
To: Tomasz =?utf-8?q?K=C5=82oczko?= <kloczek@rudy.mif.pg.gda.pl>
Subject: Re: ZFS with Linux: An Open Plea
Date: Tue, 17 Apr 2007 18:19:28 -0400
User-Agent: KMail/1.9.6
Cc: Matthew Garrett <mjg59@srcf.ucam.org>, Theodore Tso <tytso@mit.edu>,
       "David R. Litwin" <presently42@gmail.com>, linux-kernel@vger.kernel.org
References: <op.tqw1g6n0ftfxs2@localhost.localdomain> <200704171229.21433.dhazelton@enter.net> <Pine.BSO.4.63.0704172045560.11088@rudy.mif.pg.gda.pl>
In-Reply-To: <Pine.BSO.4.63.0704172045560.11088@rudy.mif.pg.gda.pl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200704171819.28407.dhazelton@enter.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 17 April 2007 15:58:09 Tomasz Kłoczko wrote:
> On Tue, 17 Apr 2007, Daniel Hazelton wrote:
> [..]
>
> >> Why on discussion about switching to GPL v3 Linux code this argument was
> >> allways taken as "piece of cake". Why in case switching to another
> >> license which will allow use CDDL code just it is most importand contr
> >> argument ?
> >>
> >> kloczek
> >
> > Because *EVERY* version of the GPL contains the "or any later version of
> > this license" clause (except, now, the version being used with the Linux
> > kernel)
>
> So after around commented swiching to GPL v3 it will be possible to start
> work on GLP v3.5 which will allow easy reuse CDDL code under Linux .. good
> to know :o)

Nope. Note that I said "Except the Linux Kernel".

After the discussions that took place back around the time of the release of 
the first draft of GPLv3 it was decided to lock Linux to *ONLY* GPLv2

So the Linux kernel will *never* be able to have a version of the GPL other 
than the current one applied. This change might have occurred without the 
knowledge or agreement of the FSF, who maintain the GPL, but since it was 
done with the complete agreement of all the current developers - and assumed 
agreement of any who contributed and are no longer able to consent (since 
their code was originally released under GPLv2) - it should stand. After all, 
the form of the license that applies to the kernel is shipped with the 
kernels sources.

In fact, from the copy in the latest Git:
 NOTE! This copyright does *not* cover user programs that use kernel
 services by normal system calls - this is merely considered normal use
 of the kernel, and does *not* fall under the heading of "derived work".
 Also note that the GPL below is copyrighted by the Free Software
 Foundation, but the instance of code that it refers to (the Linux
 kernel) is copyrighted by me and others who actually wrote it.

 Also note that the only valid version of the GPL as far as the kernel
 is concerned is _this_ particular version of the license (ie v2, not
 v2.2 or v3.x or whatever), unless explicitly otherwise stated.

                        Linus Torvalds
-----------------

So the Linux kernel, unless things change some years in the future, will never 
have a license completely compatible with the CDDL. (and the CDDL isn't 
really a "Free Software" license in the GPL vein because it makes demands 
such as retention of the header blocks and reserves Sun (or whoever is 
releasing code under the CDDL) the right to revoke the implicit patent grant 
the license offers.)

> How many years it will take ? two, three ? more ? (it will be
> good to know how long we must wait on ZFS under Linux .. I don't belive in
> rewriting ZFS code time and make it so useable on production as *now* it
> is possible under Solaris/*BSD/MOX and passing all pointless arguing will
> take shorter time) .. or maybe never because some people says
> something like "Linux is in GPL cage".

Linux is not in any cage - Solaris and ZFS, because of the CDDL, sit inside 
the cage. I, personally, will *NEVER* release code meant to be "open source" 
under a license that makes demands like those of the user.

DRH
