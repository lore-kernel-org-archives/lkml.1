Return-Path: <linux-kernel-owner+w=401wt.eu-S1756724AbXLJMdj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756724AbXLJMdj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Dec 2007 07:33:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755301AbXLJMdb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Dec 2007 07:33:31 -0500
Received: from rv-out-0910.google.com ([209.85.198.185]:25026 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754978AbXLJMda (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Dec 2007 07:33:30 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=h3TQfbF2O0q5RDKW/ZDMCMIglFxxtssSkrwMvCi+4F0Z9uFJ+kgRrwZBCC0NnrPnSB5FxQTU3ocRXRrKii0B4mqYmVNNAjHAAI2O2lut3W/71JNhgVexfX3UypReLJ4KdSyzknnN4NcJaTLEPlJV3dvEONCQDAvFsSqMk+xtpcI=
Message-ID: <d00698fb0712100433r1fd4a6dcw81ea52d39f9ce7cf@mail.gmail.com>
Date: Mon, 10 Dec 2007 13:33:29 +0100
From: noah <noah123@gmail.com>
To: "Alan Cox" <alan@lxorguk.ukuu.org.uk>
Subject: Re: Possibly SATA related freeze killed networking and RAID
Cc: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       linux-ide@vger.kernel.org
In-Reply-To: <d00698fb0711211106l4fe6223ega7ca160106a6e09b@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <d00698fb0711201109m23ff096eiabeb22c8f9a917dc@mail.gmail.com>
	 <20071120220512.46b9e975@the-village.bc.nu>
	 <d00698fb0711201416n30b54d26kd8d5887896d3da83@mail.gmail.com>
	 <20071121004545.512ad3ea@the-village.bc.nu>
	 <d00698fb0711211106l4fe6223ega7ca160106a6e09b@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2007/11/21, noah <noah123@gmail.com>:
> 2007/11/21, Alan Cox <alan@lxorguk.ukuu.org.uk>:
> > > I've had other freezes before but this was the first time I was able
> > > to see what was actually going on.
> > > IRQ 21 appears to be shared between sata_nv and ethernet.
> > >
> > > Does this mean my hardware/BIOS is broken somehow?
> >
> > Not neccessarily. It could a bug in one of the drivers using IRQ 21
> > (sata_nv or the nvidia ethernet), it could be another inactive device, or
> > it could be a hardware funny.
>
> How can I tell if there's an inactive device?
>
> > Nvidia stuff can be quite hard to diagnose as we have no documentation
> > but we can try. The first question is whether it is network or disk
> > triggered - seeing if heavy loads to one or the other trigger the problem
> > might be a first plan.
>
> I haven't managed to trigger it again yet but at the time the CPU was
> heavily loaded and I was re-indexing a database which caused a lot of
> disk activity. I'm quite confident the network was pretty much idle at
> the time.

The same thing has happened twice now, both during the weekly check of
the md0 and md1 RAID1-arrays. That is, networking on the primary
interface is dead. It's interrupt (irq 21) is shared between sata_nv
and forcedeth.

Is there anything I can do to debug this problem?

I don't have access to the logs right now but will have later.

  -- noah
