Return-Path: <linux-kernel-owner+w=401wt.eu-S1755101AbXKUTGv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755101AbXKUTGv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Nov 2007 14:06:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752330AbXKUTGm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Nov 2007 14:06:42 -0500
Received: from py-out-1112.google.com ([64.233.166.182]:9645 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752328AbXKUTGl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Nov 2007 14:06:41 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=eAT1+MdofQ2E0N1U6+rDIS/spUcDv7yk+3R+3AlaBQFK+GmLEbGQAWh18WSDJ11LuSEEUvwtZMaV1SUySJF2Tdr9/gPiGY2U9omzE2YtXtzJJWsUTBAQ6/NcL/xliUB159mHlgi1QJujwbRnuA5suLH2QruVHVERPiB0MZMSJr8=
Message-ID: <d00698fb0711211106l4fe6223ega7ca160106a6e09b@mail.gmail.com>
Date: Wed, 21 Nov 2007 20:06:40 +0100
From: noah <noah123@gmail.com>
To: "Alan Cox" <alan@lxorguk.ukuu.org.uk>
Subject: Re: Possibly SATA related freeze killed networking and RAID
Cc: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       linux-ide@vger.kernel.org
In-Reply-To: <20071121004545.512ad3ea@the-village.bc.nu>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <d00698fb0711201109m23ff096eiabeb22c8f9a917dc@mail.gmail.com>
	 <20071120220512.46b9e975@the-village.bc.nu>
	 <d00698fb0711201416n30b54d26kd8d5887896d3da83@mail.gmail.com>
	 <20071121004545.512ad3ea@the-village.bc.nu>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

2007/11/21, Alan Cox <alan@lxorguk.ukuu.org.uk>:
> > I've had other freezes before but this was the first time I was able
> > to see what was actually going on.
> > IRQ 21 appears to be shared between sata_nv and ethernet.
> >
> > Does this mean my hardware/BIOS is broken somehow?
>
> Not neccessarily. It could a bug in one of the drivers using IRQ 21
> (sata_nv or the nvidia ethernet), it could be another inactive device, or
> it could be a hardware funny.

How can I tell if there's an inactive device?

> Nvidia stuff can be quite hard to diagnose as we have no documentation
> but we can try. The first question is whether it is network or disk
> triggered - seeing if heavy loads to one or the other trigger the problem
> might be a first plan.

I haven't managed to trigger it again yet but at the time the CPU was
heavily loaded and I was re-indexing a database which caused a lot of
disk activity. I'm quite confident the network was pretty much idle at
the time.

  -- noah
