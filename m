Return-Path: <linux-kernel-owner+w=401wt.eu-S1757128AbYEPN1a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757128AbYEPN1a (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2008 09:27:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755166AbYEPN1W
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 May 2008 09:27:22 -0400
Received: from zone0.gcu-squad.org ([212.85.147.21]:1907 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754419AbYEPN1V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2008 09:27:21 -0400
Date: Fri, 16 May 2008 15:27:12 +0200
From: Jean Delvare <khali@linux-fr.org>
To: "Oliver Pinter" <oliver.pntr@gmail.com>
Cc: LM Sensors <lm-sensors@lm-sensors.org>, linux-kernel@vger.kernel.org
Subject: Re: Bad value with w83627thf
Message-ID: <20080516152712.629606bf@hyperion.delvare>
In-Reply-To: <6101e8c40805160559i4eb94ba7y7cbfea9c3f528821@mail.gmail.com>
References: <6101e8c40805160559i4eb94ba7y7cbfea9c3f528821@mail.gmail.com>
X-Mailer: Claws Mail 3.4.0 (GTK+ 2.10.6; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Oliver,

You are writing to the wrong mailing list (i2c instead of lm-sensors)
so I am redirecting.

On Fri, 16 May 2008 14:59:21 +0200, Oliver Pinter wrote:
> linux-2.6 - git HEAD on: 9662369
> lm-sensors: 1:3.0.1-5
> libsensors4: 1:3.0.1-5
> os: debian lenny
> sernsor: w83627thf on asus p4c800 MB
> 
> with 2.6.26-rcX kernel, reported false Battery values,
> -------------------------------------->
> VBat:        +3.26 V  (min =  +0.02 V, max =  +3.01 V)   ALARM
> <-------------------------------------

There is nothing wrong here. +3.26V sounds possible and correct for the
battery voltage. If you are worried about the min and max values: it is
up to you to edit your sensors3.conf file to set them properly if the
BIOS of your motherboard did not (apply the changes with "sensors -s").
The alarm will go away when you do.

> lspci -xxx
> 00:1f.3 SMBus: Intel Corporation 82801EB/ER (ICH5/ICH5R) SMBus
> Controller (rev 02)
> 00: 86 80 d3 24 01 00 80 02 02 00 05 0c 00 00 00 00
> 10: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> 20: 01 04 00 00 00 00 00 00 00 00 00 00 43 10 a6 80
> 30: 00 00 00 00 00 00 00 00 00 00 00 00 03 02 00 00
> 40: 01 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> 50: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> 60: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> 70: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> 80: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> 90: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> a0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> b0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> c0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> d0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> e0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> f0: 00 00 00 00 00 00 00 00 66 0f 04 00 00 00 00 00

Completely irrelevant here, the Winbond W83627THF is an LPC chip, it
doesn't have an I2C/SMBus interface, so the SMBus controller doesn't
matter at all.

-- 
Jean Delvare
