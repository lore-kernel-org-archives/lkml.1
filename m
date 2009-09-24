Return-Path: <linux-kernel-owner+w=401wt.eu-S1752754AbZIXJKY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752754AbZIXJKY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Sep 2009 05:10:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752496AbZIXJKY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Sep 2009 05:10:24 -0400
Received: from casper.infradead.org ([85.118.1.10]:40617 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752566AbZIXJKX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Sep 2009 05:10:23 -0400
Date: Thu, 24 Sep 2009 11:10:39 +0200
From: Arjan van de Ven <arjan@infradead.org>
To: whansard@sbcglobal.net
Cc: Jon Smirl <jonsmirl@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: disk speed regression kernel 2.6.29 and after
Message-ID: <20090924111039.49f2d3d6@infradead.org>
In-Reply-To: <20090923220654.71cd5548.whansard@sbcglobal.net>
References: <4ABA0FDA.9090707@sbcglobal.net>
	<9e4733910909230523v47d1fb3fn2575ed5d8e86069c@mail.gmail.com>
	<20090923220654.71cd5548.whansard@sbcglobal.net>
Organization: Intel
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.14.7; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 23 Sep 2009 22:06:54 -0500
Will <whansard@sbcglobal.net> wrote:

> 
> > On Wed, Sep 23, 2009 at 8:08 AM, will <whansard@sbcglobal.net>
> > wrote:
> > > I had been using an old 2.6.22 kernel on my machine, and I often
> > > backup one partition of my main hard drive to a partition on a
> > > second hard drive. The main hard drive is sata 640 gigs, and the
> > > second is a pata 320 gig. copying this partition from one drive
> > > to the other with dd takes about 3 minutes and 30 seconds. When I
> > > installed kernel 2.6.30, and 2.6.31, the time took 9 minutes and
> > > 20 seconds. I decided to go to the trouble of compiling all the
> > > kernels between, and kernels 2.6.22-2.6.28 all do the operation
> > > in about 3
> > 
> 
> > > the drives
> > > with the kernels 2.6.29 and after.
> > > Please cc me with any followups or anything. thanks
> 
> 295f00042aaf6b553b5f37348f89bab463d4a469 is first bad commit
> commit 295f00042aaf6b553b5f37348f89bab463d4a469
> Author: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
> Date:   Fri Jan 2 16:12:48 2009 +0100
> 
>     ide: don't execute the next queued command from the hard-IRQ
> context (v2) 


if you're using CONFIG_IDE.... might be worth switching to the LIBATA
subsystem instead...


-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
