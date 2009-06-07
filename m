Return-Path: <linux-kernel-owner+w=401wt.eu-S1755754AbZFGUGj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755754AbZFGUGj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Jun 2009 16:06:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754331AbZFGUGa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 7 Jun 2009 16:06:30 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:51213 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754340AbZFGUG3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Jun 2009 16:06:29 -0400
Date: Sun, 7 Jun 2009 21:07:01 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Stephen Rothwell <sfr@canb.auug.org.au>, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [git pull] IDE fixes
Message-ID: <20090607210701.78103188@lxorguk.ukuu.org.uk>
In-Reply-To: <1244401729.8262.102.camel@mulgrave.site>
References: <200906071444.33047.bzolnier@gmail.com>
	<200906071744.23629.bzolnier@gmail.com>
	<1244390889.8262.47.camel@mulgrave.site>
	<200906071947.19723.bzolnier@gmail.com>
	<1244401729.8262.102.camel@mulgrave.site>
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > [ I also tried to encourage libata developers to look into making the needed
> >   libata changes (see my initial posting of HPA patches) and I will still be
> >   glad to help with libata patches if somebody would like to work on them
> >   (Robert? Tejun?). ]
> 
> OK, so back off on the 2.6.30-rc7 release of this and I'll undertake to
> get libata engaged for integrating this into both subsystems for
> 2.6.31 ... does that sound fair?

libata already is, and I've been following and reviewing the patches. The
problem remaining is basically that this is not the time to merge
it.

It will probably also be worth looking at the way the CD driver plays
fast and loose with capacity when handling CD-R devices as a follow on
from this stuff.

