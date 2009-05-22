Return-Path: <linux-kernel-owner+w=401wt.eu-S1758093AbZEVTGu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758093AbZEVTGu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 May 2009 15:06:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751955AbZEVTGm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 May 2009 15:06:42 -0400
Received: from mail-bw0-f174.google.com ([209.85.218.174]:42398 "EHLO
	mail-bw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751324AbZEVTGm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 May 2009 15:06:42 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-disposition:message-id:content-type
         :content-transfer-encoding;
        b=T0S8Z/0AOeMb3ndqbUlY2H0HUeh5vPYtD3z/cw6bXNAdl9XooLr4rvDdEsTPAHnEto
         luGOIf8eM88F2jij1tQQ9Mh6AZ8jxAVmRTOL9RWWWYc/ClEqrSoLT0tT6MOeacaSOyK0
         EkpygKhUE/p3J9xHc2TBFd7HUVsMuJuZfXRC8=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Pierre Ossman <pierre@ossman.eu>
Subject: Re: [PATCH/RFC 2.6.29.2] Driver for CB710/720 memory card reader (MMC part) - v4
Date: Fri, 22 May 2009 21:04:06 +0200
User-Agent: KMail/1.11.3 (Linux/2.6.30-rc6-next-20090518-05332-g0707b5a; KDE/4.2.3; i686; ; )
Cc: =?utf-8?q?Micha=C5=82_Miros=C5=82aw?= <mirq@rere.qmqm.pl>,
       linux-kernel@vger.kernel.org
References: <20080909090613.GA22158@rere.qmqm.pl> <20090508151622.GA23006@rere.qmqm.pl> <20090522132755.144efcca@mjolnir.ossman.eu>
In-Reply-To: <20090522132755.144efcca@mjolnir.ossman.eu>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200905222104.07148.bzolnier@gmail.com>
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 22 May 2009 13:27:55 Pierre Ossman wrote:
> On Fri, 8 May 2009 17:16:22 +0200
> Michał Mirosław <mirq@rere.qmqm.pl> wrote:
> 
> > Here is next version of the CB710 SD/MMC reader driver. As in previous
> > versions the code is divided in two parts - virtual 'bus' driver that
> > handles PCI device and registers three new devices one per card reader
> > type. The other device handles SD/MMC part of the reader.
> > 
> > Key changes from v3:
> >  - kerneldoc for sg_mapping_iterator extension
> >  - free/restore IRQ during suspend/resume
> >  - protect slot->irq_handler by spinlock instead of RCU
> >  - remove verify_serialization()
> >  - Kconfig
> >  - complete patch for linux kernel 2.6.29.2
> > 
> 
> Looks good to me. I just want you to add a MAINTAINERS entry so that
> people know who to contact if they have problems with this driver.
> 
> > My patches for sg_mapping_iterator extension went to /dev/null, so I have
> > incorporated them to the cb710 core driver module for now. Probably someone
> > with more karma points should look at them (sgbuf2.{c,h}) and push further
> > if they are of any value to other driver writers.

I like the general idea and I think that this could serve as a good starting
point into making generic PIO handling library (which has been on my personal
TODO of things to look into for a long time).

Michał, I'll try ping you back about it once I'm done with 2.6.31 IDE stuff..

> Give them to Andrew Morton. He's good at finding the right people and
> making sure they notice. :)

Hehe, please keep me on cc:.

Thanks.
Bart
