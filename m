Return-Path: <linux-kernel-owner+w=401wt.eu-S1753241AbZI1Uhf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753241AbZI1Uhf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Sep 2009 16:37:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753226AbZI1Uhe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Sep 2009 16:37:34 -0400
Received: from ey-out-2122.google.com ([74.125.78.24]:19153 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753230AbZI1Uhd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Sep 2009 16:37:33 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:in-reply-to:references:x-mailer
         :mime-version:content-type:content-transfer-encoding;
        b=r939g6nXSIX0oMJVn5RpiJU0A5xALpFN7oILdytCpZNewWOAstcmIElrPQMZOAx1NY
         1WA5UchRRfuwi8pPgI73CLO1dpKj1uRo81wlSdMRFtuvZ6TrCr2n5Wtk0aZ/aWLzPYsa
         esBNpJyaUyl3HPiCDhO6la1CGFhtV2NcvV1eU=
Date: Mon, 28 Sep 2009 22:37:27 +0200
From: Alejandro Riveira =?UTF-8?B?RmVybsOhbmRleg==?= 
	<ariveira@gmail.com>
To: FunFlyer@gmx.net
Cc: linux-kernel@vger.kernel.org
Subject: Re: Disabling DMA with ICH10?
Message-ID: <20090928223727.0b1367b7@varda>
In-Reply-To: <1254173481.4454.32.camel@goodbyte.homelinux.com>
References: <1254173481.4454.32.camel@goodbyte.homelinux.com>
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.16.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

El Mon, 28 Sep 2009 23:31:21 +0200
Lennart Baruschka <FunFlyer@gmx.net> escribió:

> Hello,
> 
> I'm new to this list, so please forgive me if this is the wrong place to
> ask. I'm trying to build a 2.6.30.5 kernel causing as little DMA traffic
> as possible in order to reduce latencies on a real-time system (using
> RTAI). 
> 
> 1. Is there a way to completely disable DMA usage system-wide?
> If not:
> 2. My system uses an ICH10 chipset, the harddrive is connected to the
> Intel SATA controller. Is there a way to disable DMA and switch back to
> PIO? I tried compiling with libata support and without SCSI support, but
> the kernel is unable to mount root (no matter if /dev/sda1
> or /dev/hda1), then.
  
  AFAIK libata needs scsi support. To disable dma in libata I get from
  Documentation/kernel-parameters.txt --> libata.dma = 0


> 3. Another source seems to be the ATL1E driver for ethernet. Is it
> possible to either disable DMA for this? 
  
  That I dunno

> 
> If disabling DMA is impossible for some reason for one or both drivers,
> is it at least possible to reduce the burst sizes so the bus gets free
> for a short time during which I could access it from my real time kernel
> module?
> 
> Please point me in the right direction; any suggestion will be greatly
> appreciated!
> 
> Cheers,
> Lennart
   
  Saludos,
  Alejandro 


