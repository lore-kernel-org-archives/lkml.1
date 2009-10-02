Return-Path: <linux-kernel-owner+w=401wt.eu-S1756885AbZJBQku@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756885AbZJBQku (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Oct 2009 12:40:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756689AbZJBQkt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Oct 2009 12:40:49 -0400
Received: from bay0-omc3-s41.bay0.hotmail.com ([65.54.246.241]:20363 "EHLO
	bay0-omc3-s41.bay0.hotmail.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756608AbZJBQkt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Oct 2009 12:40:49 -0400
Message-ID: <BAY109-W3302C19CAD0A6635085210C3D20@phx.gbl>
X-Originating-IP: [164.116.126.146]
From: Yuhong Bao <yuhongbao_386@hotmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: <eric.dumazet@gmail.com>, <arjan@infradead.org>, <schwidefsky@de.ibm.com>,
       <tglx@linutronix.de>, <johnstul@us.ibm.com>,
       <linux-kernel@vger.kernel.org>, <mingo@elte.hu>
Subject: RE: [GIT PULL] scheduler fixes
Date: Fri, 2 Oct 2009 09:40:53 -0700
Importance: Normal
In-Reply-To: <alpine.LFD.2.01.0909301743150.6996@localhost.localdomain>
References: <20090928191506.40b61793@mschwide.boeblingen.de.ibm.com>
 <4AC10365.7090802@gmail.com> <4AC2712C.4080901@gmail.com>
 <alpine.LFD.2.01.0909291410440.6996@localhost.localdomain>
 <20090929232248.735bf4df@infradead.org>
 <alpine.LFD.2.01.0909291429570.6996@loca
X-OriginalArrivalTime: 02 Oct 2009 16:40:53.0383 (UTC) FILETIME=[1B71C970:01CA437F]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


 <alpine.LFD.2.01.0909301743150.6996@localhost.localdomain>
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0



> [ If I recall correctly=2C cmpxchg8b support detection was something that
> was totally messed up in WNT=2C and I have this memory of TMTA _not_
> claiming to support CX8 in the cpuid bits=2C but happily supporting the
> instruction itself - because otherwise WNT would blue-screen on boot or
> something silly like that.
Yep=2C Geoff Chappell describe this bug excellently:http://www.geoffchappel=
l.com/viewer.htm?doc=3Dstudies/windows/km/cpu/cx8.htm
> As a result=2C the patch below only adds CMPXCHG8B for the obvious Intel
> CPU's=2C not for others. There was something really messy about cmpxchg8b
> and clone CPU's=2C but I'm not 100% sure about the details=2C so take thi=
s
> patch with a pinch of salt=2C and some thinking ]
Basically=2C pre-SP4 NT 4 would crash if the CX8 bit was set in CPUID and v=
endor was not GenuineIntel=2C AuthenticAMD=2C or CyrixInstead due to a bug =
in the CPU detection=2C XP had to workaround it too when it began requiring=
 CX8.
Yuhong bao 		 	   		  =0A=
_________________________________________________________________=0A=
Insert movie times and more without leaving Hotmail=AE.=0A=
http://windowslive.com/Tutorial/Hotmail/QuickAdd?ocid=3DTXT_TAGLM_WL_HM_Tut=
orial_QuickAdd_062009=
