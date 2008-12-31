Return-Path: <linux-kernel-owner+w=401wt.eu-S1757181AbYLaV36@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757181AbYLaV36 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Dec 2008 16:29:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753595AbYLaV3t
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Dec 2008 16:29:49 -0500
Received: from lucidpixels.com ([75.144.35.66]:44185 "EHLO lucidpixels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751847AbYLaV3s (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Dec 2008 16:29:48 -0500
Date: Wed, 31 Dec 2008 16:29:47 -0500 (EST)
From: Justin Piszcz <jpiszcz@lucidpixels.com>
To: alsa-devel@vger.kernel.org, linux-kernel@vger.kernel.org,
       alsa-user@lists.sourceforge.net
Subject: Re: 2.6.28: hda_codec: Unknown model for ALC883, trying auto-probe
 from BIOS...
In-Reply-To: <alpine.DEB.1.10.0812300727380.11356@p34.internal.lan>
Message-ID: <alpine.DEB.1.10.0812311629040.951@p34.internal.lan>
References: <alpine.DEB.1.10.0812300616570.11356@p34.internal.lan> <alpine.DEB.1.10.0812300727380.11356@p34.internal.lan>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-1463747160-1501798997-1230758987=:951"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---1463747160-1501798997-1230758987=:951
Content-Type: TEXT/PLAIN; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE



On Tue, 30 Dec 2008, Justin Piszcz wrote:

>
>
> On Tue, 30 Dec 2008, Justin Piszcz wrote:
>
>> The audio for this board works fine, there are no issues, but there are=
=20
>> some cosmetic issues when the driver loads:
>>=20
>> 1. Unknown model.
>> 2. Wrong model number.
>>=20
>> On my ABIT AW9D-MAX motherboard:
>> [   10.667963] Advanced Linux Sound Architecture Driver Version 1.0.18rc=
3.
>> [   10.668156] HDA Intel 0000:00:1b.0: PCI INT A -> GSI 16 (level, low) =
->=20
>> IRQ 1
>> 6
>> [   10.668228] HDA Intel 0000:00:1b.0: setting latency timer to 64
>> [   10.677932] hda_codec: Unknown model for ALC883, trying auto-probe fr=
om=20
>> BIOS.
>> ..
>> [   10.705082] ALSA device list:
>> [   10.705128]   #0: HDA Intel at 0xfdff8000 irq 16
>>=20
>> On an Intel motherboard, correctly detected, no warnings about an Unknow=
n
>> model.
>>=20
>> [    5.466951] Advanced Linux Sound Architecture Driver Version 1.0.18rc=
3.
>> [    5.470149] HDA Intel 0000:00:1b.0: PCI INT A -> GSI 22 (level, low) =
->=20
>> IRQ 22
>> [    5.473135] HDA Intel 0000:00:1b.0: setting latency timer to 64
>> [    5.512645] ALSA device list:
>> [    5.515568]   #0: HDA Intel at 0xe2420000 irq 22
>>=20
>> Specs:
>> # abit AudioMAX# HD 7.1 CH
>> # Supports Jack Sensing and S/PDIF In/Out
>> # Dolby=AE Master Studio Certificated=20
>> http://www.abit.com.tw/page/en/motherboard/motherboard_detail.php?pMODEL=
_NAME=3DAW9D-MAX&fMTYPE=3DLGA775&pPRODINFO=3DSpecifications&fSEARCHTEXT=3DA=
W9D-MAX
>>=20
>> Not too specific, however:
>> http://www.anandtech.com/mb/showdoc.aspx?i=3D2829
>>=20
>> Reveals the correct model:
>> -> Realtek ALC882M HD-Audio 8-channel CODEC - Dolby Master Studio Where =
the=20
>> kernel believes it is an ALC883.
>>

This would need to be fixed in the kernel.. yes? I had been asked to run
update-pciids but afaik that only affects lspci output.

Justin.

---1463747160-1501798997-1230758987=:951--
