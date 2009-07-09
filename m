Return-Path: <linux-kernel-owner+w=401wt.eu-S1760744AbZGIOLK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760744AbZGIOLK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jul 2009 10:11:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759701AbZGIOKz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Jul 2009 10:10:55 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:46614 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1759207AbZGIOKz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jul 2009 10:10:55 -0400
Date: Thu, 9 Jul 2009 15:10:09 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: tridge@samba.org, Martin Steigerwald <Martin@lichtvoll.de>,
       Jan Engelhardt <jengelh@medozas.de>, Theodore Tso <tytso@mit.edu>,
       Rusty Russell <rusty@rustcorp.com.au>, Pavel Machek <pavel@ucw.cz>,
       john.lanza@linux.com,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-fsdevel@vger.kernel.org,
       Dave Kleikamp <shaggy@linux.vnet.ibm.com>, corbet@lwn.net,
       jcm@jonmasters.org
Subject: Re: CONFIG_VFAT_FS_DUALNAMES regressions
Message-ID: <20090709151009.07b2508b@lxorguk.ukuu.org.uk>
In-Reply-To: <1247147981.3898.15.camel@mulgrave.site>
References: <19013.8005.541836.436991@samba.org>
	<alpine.LSU.2.00.0907062221520.27775@fbirervta.pbzchgretzou.qr>
	<19026.38137.63807.427511@samba.org>
	<200907072356.51553.Martin@lichtvoll.de>
	<19028.3736.892828.352905@samba.org>
	<20090708110451.1092afa7@lxorguk.ukuu.org.uk>
	<19028.31088.400461.939917@samba.org>
	<20090708130256.40957c3f@lxorguk.ukuu.org.uk>
	<19028.39145.180869.603673@samba.org>
	<20090708142510.5068b4c3@lxorguk.ukuu.org.uk>
	<19029.17896.769106.375379@samba.org>
	<20090709104228.7821e2f0@lxorguk.ukuu.org.uk>
	<1247147981.3898.15.camel@mulgrave.site>
X-Mailer: Claws Mail 3.7.1 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > Even if they go for the non-infringing tweak they will still end up with
> > patches to rip out the potentially infringing code paths.
> 
> You keep saying this and I keep pointing out to you it's not true.

You keep saying this is not true and you keep ignoring the fact that a)
it is true and b) you can look at lots of existing RPM packages and see
that today. The evidence is out there - no hearsay, no question marks, go
look.

> contributory infringement based on shipping the code.  I don't actually
> believe that a compile time option they turn on in the binary kernel to
> make it non infringing coupled with shipping code where the user could
> recompile with it off is sufficient to rise to the tests under the
> contributory infringement doctrine.

Its a simple risk test. Anything which reduces risk but does not change
functionality is something you do. Its basically a zero cost way to
reduce the chances of being shot at.

The decision they have to make is full vfat v tridgefat v fat. Once you
make that decision and any part of that decision involves not enabling a
feature because of a theoretical concern about a dubious patent you rip
the code out of your tree as well. So if a vendor picked tridgefat they'd
rip out the source bits outside of the ifdefs that switched tridgefat v
vfat.

Alan
