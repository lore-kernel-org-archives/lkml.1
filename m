Return-Path: <linux-kernel-owner+w=401wt.eu-S1764805AbXHXNqm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764805AbXHXNqm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Aug 2007 09:46:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759149AbXHXNqf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Aug 2007 09:46:35 -0400
Received: from smtp2.it.da.ut.ee ([193.40.5.67]:53535 "EHLO smtp2.it.da.ut.ee"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753172AbXHXNqe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Aug 2007 09:46:34 -0400
Date: Fri, 24 Aug 2007 16:46:33 +0300 (EEST)
From: Meelis Roos <mroos@linux.ee>
To: Kay Sievers <kay.sievers@vrfy.org>
cc: Linux Kernel list <linux-kernel@vger.kernel.org>
Subject: Re: isapnp & module autoload (udev?)
In-Reply-To: <3ae72650708240540qcf05809j609e0fbb05f221b3@mail.gmail.com>
Message-ID: <Pine.SOC.4.64.0708241642540.27738@math.ut.ee>
References: <Pine.SOC.4.64.0708241434440.27738@math.ut.ee>
 <3ae72650708240540qcf05809j609e0fbb05f221b3@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> What's in the module? What does:
>   /sbin/modinfo <kernel module name> | grep alias
> print?

filename:       /lib/modules/2.6.23-rc3/kernel/sound/isa/sb/snd-sb16.ko
description:    Sound Blaster 16
license:        GPL
author:         Jaroslav Kysela <perex@suse.cz>
alias:          pnp:ctBA03b0dPNPb003*
alias:          pnp:cCTL00f0dCTL0043*
alias:          pnp:cCTL0086dCTL0041*
alias:          pnp:cCTL0080dCTL0041*
alias:          pnp:cCTL0070dCTL0001*
alias:          pnp:cCTL0051dCTL0001*
alias:          pnp:cCTL002cdCTL0031*
alias:          pnp:cCTL002bdCTL0031*
alias:          pnp:cCTL002adCTL0031*
alias:          pnp:cCTL0029dCTL0031*
alias:          pnp:cCTL0028dCTL0031*
alias:          pnp:cCTL0027dCTL0031*
alias:          pnp:cCTL0026dCTL0031*
alias:          pnp:cCTL0025dCTL0031*
alias:          pnp:cCTL0024dCTL0031*
depends:        snd-sb-common,snd-opl3-lib,snd-mpu401-uart,snd-sb16-dsp,snd-pcm,snd,snd-sb16-csp
vermagic:       2.6.23-rc3 SMP mod_unload PENTIUMII 4KSTACKS
parm:           index:Index value for SoundBlaster 16 soundcard. (array of int)
parm:           id:ID string for SoundBlaster 16 soundcard. (array of charp)
parm:           enable:Enable SoundBlaster 16 soundcard. (array of bool)
parm:           isapnp:PnP detection for specified soundcard. (array of bool)
parm:           port:Port # for SB16 driver. (array of long)
parm:           mpu_port:MPU-401 port # for SB16 driver. (array of long)
parm:           fm_port:FM port # for SB16 PnP driver. (array of long)
parm:           irq:IRQ # for SB16 driver. (array of int)
parm:           dma8:8-bit DMA # for SB16 driver. (array of int)
parm:           dma16:16-bit DMA # for SB16 driver. (array of int)
parm:           mic_agc:Mic Auto-Gain-Control switch. (array of int)
parm:           csp:ASP/CSP chip support. (array of int)

 
> And what does the hardware say? What does:
>   grep . /sys/bus/pnp/devices/*/id
> print?

/sys/bus/pnp/devices/00:00/id:PNP0c01
/sys/bus/pnp/devices/00:01/id:PNP0000
/sys/bus/pnp/devices/00:02/id:PNP0200
/sys/bus/pnp/devices/00:03/id:PNP0100
/sys/bus/pnp/devices/00:04/id:PNP0b00
/sys/bus/pnp/devices/00:05/id:PNP0303
/sys/bus/pnp/devices/00:06/id:PNP0800
/sys/bus/pnp/devices/00:07/id:PNP0c04
/sys/bus/pnp/devices/00:08/id:PNP0c02
/sys/bus/pnp/devices/00:09/id:PNP0c02
/sys/bus/pnp/devices/00:0a/id:PNP0501
/sys/bus/pnp/devices/00:0b/id:PNP0501
/sys/bus/pnp/devices/00:0c/id:PNP0401
/sys/bus/pnp/devices/00:0d/id:PNP0700
/sys/bus/pnp/devices/00:0e/id:PNP0a03
/sys/bus/pnp/devices/01:01.00/id:CTL0001
/sys/bus/pnp/devices/01:01.01/id:CTL7001
/sys/bus/pnp/devices/01:01.01/id:PNPb02f

CTL0001 seems to be present in both but it occurs with CTL0070 or 
CTL0051.

-- 
Meelis Roos (mroos@linux.ee)
