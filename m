Return-Path: <linux-kernel-owner+w=401wt.eu-S1756551AbZFLSUW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756551AbZFLSUW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jun 2009 14:20:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751771AbZFLSUL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Jun 2009 14:20:11 -0400
Received: from mx-out.daemonmail.net ([216.104.160.38]:46691 "EHLO
	mx-out.daemonmail.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750941AbZFLSUK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jun 2009 14:20:10 -0400
From: "Michael S. Zick" <lkml@morethan.org>
Reply-To: lkml@morethan.org
To: tomaz.mertelj@guest.arnes.si
Subject: Re: [lm-sensors] [PATCH] hwmon: Add driver for VIA CPU =?utf-8?q?core=09temperature?=
Date: Fri, 12 Jun 2009 13:20:06 -0500
User-Agent: KMail/1.9.9
Cc: Harald Welte <HaraldWelte@viatech.com>, Jean Delvare <khali@linux-fr.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       lm-sensors@lm-sensors.org
References: <20090612_181603_063915.tomaz.mertelj@guest.arnes.si>
In-Reply-To: <20090612_181603_063915.tomaz.mertelj@guest.arnes.si>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200906121320.10169.lkml@morethan.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri June 12 2009, tomaz.mertelj@guest.arnes.si wrote:
> > On Fri June 12 2009, Michael S. Zick wrote:
> > 
> > And the output of sensors with H.W. driver built-in:
> > 
> > root@cb01:~# sensors
> > acpitz-virtual-0
> > Adapter: Virtual device
> > temp1:       +48.8�C  (crit = +94.8�C)
> > 
> > via-cputemp-isa-0000
> > Adapter: ISA adapter
> > Core 0:      +50.0�C
> > 
> > Which looks reasonable to me, on this machine.
> > 
> > Mike 
> 
> On VIA VB7002  acpitz  obviously does not work so I can not compare. I 
> guess BIOS does not support the temperature reading since there is no 
> temperature readout in BIOS. 
> 
> acpitz-virtual-0
> Adapter: Virtual device
> temp1:      -247.7 C  (crit = +140.0 C)
> 
> via-cputemp-isa-0000
> Adapter: ISA adapter
> Core 0:      +27.0 C
> 
> Is there a way to reset the CPU temperature calibration to the factory 
> default?  
> 

There should be among those registers we dumped
for Harald.  He now has a good and a bad case to
look at - he also has access to the msr magic numbers.

Mike
> Tomaz Mertelj 
> 
> 
> 


