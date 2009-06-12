Return-Path: <linux-kernel-owner+w=401wt.eu-S1763481AbZFLSQR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763481AbZFLSQR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jun 2009 14:16:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753768AbZFLSQD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Jun 2009 14:16:03 -0400
Received: from avs3.arnes.si ([193.2.1.68]:54135 "EHLO avs3.arnes.si"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753063AbZFLSQB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jun 2009 14:16:01 -0400
To: "Michael S. Zick" <lkml@morethan.org>, tomaz.mertelj@guest.arnes.si
From: tomaz.mertelj@guest.arnes.si
Cc: Harald Welte <HaraldWelte@viatech.com>, Jean Delvare <khali@linux-fr.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       lm-sensors@lm-sensors.org
Subject: =?UTF-8?Q?Re: [lm-sensors] [PATCH] hwmon: Add driver for VIA CPU core	temperature=
	?=
Date: Fri, 12 Jun 2009 20:16:03 +0200
Message-ID: <20090612_181603_063915.tomaz.mertelj@guest.arnes.si>
X-originating-IP: 84.20.248.126
MIME-Version: 1.0
Content-type: text/plain; charset=utf-8
Content-transfer-encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Fri June 12 2009, Michael S. Zick wrote:
> 
> And the output of sensors with H.W. driver built-in:
> 
> root@cb01:~# sensors
> acpitz-virtual-0
> Adapter: Virtual device
> temp1:       +48.8�C  (crit = +94.8�C)
> 
> via-cputemp-isa-0000
> Adapter: ISA adapter
> Core 0:      +50.0�C
> 
> Which looks reasonable to me, on this machine.
> 
> Mike 

On VIA VB7002  acpitz  obviously does not work so I can not compare. I 
guess BIOS does not support the temperature reading since there is no 
temperature readout in BIOS. 

acpitz-virtual-0
Adapter: Virtual device
temp1:      -247.7 C  (crit = +140.0 C)

via-cputemp-isa-0000
Adapter: ISA adapter
Core 0:      +27.0 C

Is there a way to reset the CPU temperature calibration to the factory 
default?  

Tomaz Mertelj 

