Return-Path: <linux-kernel-owner+w=401wt.eu-S1754145AbXFMByq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754145AbXFMByq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jun 2007 21:54:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751854AbXFMByi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Jun 2007 21:54:38 -0400
Received: from fwstl1-1.wul.qc.ec.gc.ca ([205.211.132.24]:63932 "EHLO
	ecqcmtlbh.quebec.int.ec.gc.ca" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751724AbXFMByh convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jun 2007 21:54:37 -0400
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Subject: RE: call for more SD versus CFS comparisons (was: Re: [ck] Mainline plans)
Date: Tue, 12 Jun 2007 21:54:16 -0400
Message-ID: <F1D642E5A91BC94D9504EC83AE19E6B01289E9@ecqcmtlmail3.quebec.int.ec.gc.ca>
In-Reply-To: <F1D642E5A91BC94D9504EC83AE19E6B01289E8@ecqcmtlmail3.quebec.int.ec.gc.ca>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: call for more SD versus CFS comparisons (was: Re: [ck] Mainline plans)
Thread-Index: AcesiO/OiGlZliQRQc2RTeRL2MWpLQA0RHsQAAB04CA=
References: <466DE921.9030709@debianpt.org> <F1D642E5A91BC94D9504EC83AE19E6B01289E8@ecqcmtlmail3.quebec.int.ec.gc.ca>
From: "Fortier,Vincent [Montreal]" <Vincent.Fortier1@EC.GC.CA>
To: "Miguel Figueiredo" <elmig@debianpt.org>,
       "linux kernel mailing list" <linux-kernel@vger.kernel.org>,
       <ck@vds.kolivas.org>
Cc: "Con Kolivas" <kernel@kolivas.org>, "Ingo Molnar" <mingo@elte.hu>,
       "Martin Steigerwald" <Martin@lichtvoll.de>
X-OriginalArrivalTime: 13 Jun 2007 01:54:16.0693 (UTC) FILETIME=[BFED9250:01C7AD5D]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> -----Message d'origine-----
> De : linux-kernel-owner@vger.kernel.org 
> [mailto:linux-kernel-owner@vger.kernel.org] De la part de 
> Fortier,Vincent [Montreal]
> Envoyé : 12 juin 2007 21:36
> À : Miguel Figueiredo; linux kernel mailing list; ck@vds.kolivas.org
> Cc : Con Kolivas; Ingo Molnar
> Objet : RE: call for more SD versus CFS comparisons (was: Re: 
> [ck] Mainline plans)
> 
> > -----Message d'origine-----
> > De : linux-kernel-owner@vger.kernel.org
> > [mailto:linux-kernel-owner@vger.kernel.org] De la part de Miguel 
> > Figueiredo Envoyé : 11 juin 2007 20:30
> > 
> > Hi all,
> > 
> > some results based on massing_intr.c by Satoru, can be found on 
> > http://people.redhat.com/mingo/cfs-scheduler/tools/massive_intr.c
> > 
> > 
> > I know that other people, who read lkml, also tested the 
> same way, it 
> > would be nice if they also post their data.
> > 
> 
> For the pleasure of comparing CPU schedulers, both CFS v16 & 
> full CK2 patched pre-built kernels for Fedora 7 using latest 
> build 3194 are now available at http://linux-dev.qc.ec.gc.ca
> 
> There is also a not yet fully tuned YUM repository 
> configuration file available at 
> http://linux-dev.qc.ec.gc.ca/kernel/fedora/alt-sched.repo
> Although I suggest you download the rpm's directly from the 
> web page & install both manually using rpm -ivh --force
> 
> Have fun.
> 

Also, now that I think of it, here are my results:

Test:
./massive_intr 20 6000

Hardware:
- Athlon 64 4200+
- 2GB ram
- nVidia 6600GT using latest Beta driver NVIDIA-Linux-x86_64-100.14.06-pkg2.run
- SATA drive
- On-board audio (00:04.0 Multimedia audio controller: nVidia Corporation CK804 AC'97 Audio Controller (rev a2))

Kernels:
CFS v16 2.6.21 FC7 build 3194
CK2 2.6.21 FC7 build 3194

Here is what the TOP output was looking like for both case:
top - 13:36:22 up 38 min,  4 users,  load average: 20.41, 13.43, 7.49
Tasks: 172 total,  21 running, 150 sleeping,   0 stopped,   1 zombie
Cpu0  : 99.7%us,  0.3%sy,  0.0%ni,  0.0%id,  0.0%wa,  0.0%hi,  0.0%si,  0.0%st
Cpu1  : 94.7%us,  4.6%sy,  0.0%ni,  0.0%id,  0.0%wa,  0.3%hi,  0.3%si,  0.0%st
Mem:   2058860k total,  1217132k used,   841728k free,    56456k buffers
Swap:  1959888k total,        0k used,  1959888k free,   781636k cached

  PID USER      PR  NI  VIRT  RES  SHR S %CPU %MEM    TIME+  COMMAND
 6099 megalout  20   0  7860  224  136 R   10  0.0   0:26.12 massive_intr
 6102 megalout  20   0  7860  224  136 R   10  0.0   0:26.27 massive_intr
 6104 megalout  20   0  7860  224  136 R   10  0.0   0:26.51 massive_intr
 6105 megalout  20   0  7860  224  136 R   10  0.0   0:26.32 massive_intr
 6107 megalout  20   0  7860  224  136 R   10  0.0   0:26.62 massive_intr
 6112 megalout  20   0  7860  224  136 R   10  0.0   0:26.32 massive_intr
 6116 megalout  20   0  7860  224  136 R   10  0.0   0:26.26 massive_intr
 6109 megalout  20   0  7860  224  136 R   10  0.0   0:26.32 massive_intr
 6115 megalout  20   0  7860  224  136 R   10  0.0   0:26.50 massive_intr
 6118 megalout  20   0  7860  224  136 R    9  0.0   0:26.37 massive_intr
 6100 megalout  20   0  7860  224  136 R    9  0.0   0:26.51 massive_intr
 6103 megalout  20   0  7860  224  136 R    9  0.0   0:26.24 massive_intr
 6106 megalout  20   0  7860  224  136 R    9  0.0   0:26.32 massive_intr
 6108 megalout  20   0  7860  224  136 R    9  0.0   0:26.32 massive_intr
 6110 megalout  20   0  7860  224  136 R    9  0.0   0:26.54 massive_intr
 6111 megalout  20   0  7860  224  136 R    9  0.0   0:26.37 massive_intr
 6113 megalout  20   0  7860  224  136 R    9  0.0   0:26.56 massive_intr
 6114 megalout  20   0  7860  224  136 R    9  0.0   0:26.30 massive_intr
 6117 megalout  20   0  7860  224  136 R    9  0.0   0:26.34 massive_intr
 6101 megalout  20   0  7860  224  136 R    9  0.0   0:26.31 massive_intr
 4681 root      20   0  196m  67m  12m S    8  3.4   4:06.00 X
 6036 megalout  20   0  694m  53m  32m S    2  2.6   0:07.82 amarokapp
 4904 megalout  20   0  271m 9.9m 6948 S    1  0.5   0:18.16 gkrellm
 5054 megalout  20   0  160m  45m  20m S    1  2.2   0:10.90 firefox-bin
 5201 megalout  20   0  160m 9304 5480 S    1  0.5   0:01.42 emerald
 5210 megalout  20   0  240m  12m 6284 S    1  0.6   0:33.29 beryl


CFS v16:
---------
beryl interractivity way too unresponsive..
- window decoration highlight taking around 5-10 secs to switch between windows focus
- window movement either impossible or animation laggy enough to not being seen at all.
- Cube rotation still possible using mouse scroll although really really really laggy

Amarok MP3 music:
- No audio skips at all.  Playing really well!


CK2 patchset:
-------------
Beryl interractivity almost totally unresponsive... In fact mouse movement was near-impossible to control.
- window movement totally impossible
- Cube rotation still possible using mouse scroll although there was no animation at all

Amarok MP3 music:
- Same as CFS, no skips at all.  Playing really well!


I'll quote Martin on the Ck mailing list:
> According to Ingo most of the interactivity issues should be fixed by now. 
> Still I do not see how that translates to "CFS was generally better".

Well, here you go:
For having followed RSDL since version 0.28 I'd say Con did a really great job but for me CFS v16 now, on my hardware, offers better interactivity using beryl window manager.

- vin
