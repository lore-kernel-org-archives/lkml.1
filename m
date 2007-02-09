Return-Path: <linux-kernel-owner+w=401wt.eu-S2992446AbXBIRJ3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992446AbXBIRJ3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Feb 2007 12:09:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992449AbXBIRJ3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Feb 2007 12:09:29 -0500
Received: from moutng.kundenserver.de ([212.227.126.183]:54994 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2992446AbXBIRJ1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Feb 2007 12:09:27 -0500
From: Emmeran Seehuber <rototor@rototor.de>
To: Tejun Heo <htejun@gmail.com>
Subject: Re: 2.6.18.2: sporadic SATA port resets (Broadcom BCM5785 (HT1000))
Date: Fri, 9 Feb 2007 18:09:18 +0100
User-Agent: KMail/1.9.6
Cc: linux-kernel@vger.kernel.org
References: <200702071817.17006.rototor@rototor.de> <200702091237.24576.rototor@rototor.de> <45CC7D04.5090403@gmail.com>
In-Reply-To: <45CC7D04.5090403@gmail.com>
X-Face: r$Dk&6(PFBkz"O(d4nE<ZXvpygmFFB%`/+1FHeQCFD|K1tY#:C3t"=?utf-8?q?wW2zb=27QD=3FYWE=26liV=5E=0A=09h!=26-=7C=5DT=2E=5BRlcZ=7DN=7E4A0z?=
 =?utf-8?q?4syfMw=5E=26gH=24M?=,fWc+P@GWh1Ja)'J5]In}-=d<
 =?utf-8?q?tj=3A+oV-=23*D=27Bi=0A=094DR=5DF=7CEZH=5EjC/O?=)(Oe<Fc+`f}2^M14u<gK_mw4_wF$xn"~bF!BKsdTiaMs)"
 =?utf-8?q?=3D=5DxT8aC=5FS=3D=0A=09RA=3ATsO?="hfoHvOa%8'u0/6RLTL=-}>=S;uWHI5DiU)YUUnED+B784<x\2*,VR^E>
 =?utf-8?q?3=5Bz=7CIJ=7B=0A=09ftYrhFwU1=26?=<.=`'*vh@
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200702091809.19418.rototor@rototor.de>
X-Provags-ID: kundenserver.de abuse@kundenserver.de login:d84d732d8ddd2281dac05c143a411240
X-Provags-ID2: V01U2FsdGVkX19Nr7xdrzJrwmIgTeeYQN9pkBGan9TX2fvhOitWlpoYmrKR+O9wn+erA2pCUmqCvDkeqoIG1uGFJFnncGAsB5Sr8mniUvOxTNI5IDyFpFQFuA==
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Am Friday 09 February 2007 schrieb Tejun Heo:
> Yeap, that's exactly what I wanted.  So, the driver is sata_svw and
> errors are timeouts for both reads and writes with BMDMA engine still
> running.  It looks like transmission errors to me.  Can you post the
> result of 'smartctl -a /dev/sdX'?

here it is:

-->

# smartctl -a /dev/sda
smartctl version 5.36 [x86_64-unknown-linux-gnu] Copyright (C) 2002-6 Bruce 
Allen
Home page is http://smartmontools.sourceforge.net/

Device: ATA      WDC WD1500ADFD-0 Version: 20.0
Serial number:      WD-WMAP41246348
Device type: disk
Local Time is: Fri Feb  9 18:06:23 2007 CET
Device does not support SMART

Error Counter logging not supported

[GLTSD (Global Logging Target Save Disable) set. Enable Save with '-S on']
Device does not support Self Test logging

<--

cu,
  Emmy
