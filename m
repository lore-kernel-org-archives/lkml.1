Return-Path: <linux-kernel-owner+w=401wt.eu-S932539AbZJ1DOR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932539AbZJ1DOR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Oct 2009 23:14:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932529AbZJ1DOQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Oct 2009 23:14:16 -0400
Received: from snt0-omc4-s17.snt0.hotmail.com ([65.55.90.220]:56889 "EHLO
	snt0-omc4-s17.snt0.hotmail.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932516AbZJ1DOP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Oct 2009 23:14:15 -0400
X-Greylist: delayed 369 seconds by postgrey-1.27 at vger.kernel.org; Tue, 27 Oct 2009 23:14:15 EDT
Message-ID: <SNT125-W471F856F2358A53E59A13BC3B80@phx.gbl>
X-Originating-IP: [173.64.154.25]
From: Yuhong Bao <yuhongbao_386@hotmail.com>
To: <macro@linux-mips.org>
CC: <jengelh@medozas.de>, <davej@redhat.com>, <linux-kernel@vger.kernel.org>,
       <mingo@elte.hu>, <tglx@linutronix.de>, <hpa@zytor.com>
Subject: RE: [X86] Fix up silly i1586 boot message.
Date: Tue, 27 Oct 2009 20:08:11 -0700
Importance: Normal
In-Reply-To: <Pine.LNX.4.55.0805290102340.29522@cliff.in.clinika.pl>
References: <20080528165713.GA412@redhat.com>
 <alpine.LNX.1.10.0805281943330.19264@fbirervta.pbzchgretzou.qr>
 <Pine.LNX.4.55.0805281850540.29522@cliff.in.clinika.pl>
 <alpine.LNX.1.10.0805282001180.19264@fbirervta.pbzchgretzou.qr>
 <Pine.LNX.4.55.0805281916480.29522@c
X-OriginalArrivalTime: 28 Oct 2009 03:08:10.0773 (UTC) FILETIME=[E1677C50:01CA577B]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


 <Pine.LNX.4.55.0805290102340.29522@cliff.in.clinika.pl>
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0


> Intel started it first with picking up a ridiculous number for the family
> ID for the P4 line. There is no technical justification for not keeping
> these numbers consecutive.=20
Well=2C the problem was that Intel has assigned family 7 for the original I=
tanium processor=2C back when Intel thought that would replace x86 (the cod=
ename for the original Itanium was P7=2C and the codename for the original =
P4 was P68). And then there was a bug in original NT 4 truncating family ID=
s returned by CPUID to 3 bits. This was not the only bug in the original NT=
 4's CPUID code=2C there was another bug relating to CX8 detection with non=
-Intel/AMD/Cyrix processors forcing the other CPU vendors to provide an opt=
ion to mask this bit=2C which caused trouble for MS itself later on when th=
ey decide they would begin to require CX8 in XP=2C and it ignores CPUID if =
max standard CPUID level is greater than 3=2C forcing Intel to again add a =
workaround into their Prescott and later processors.
Geoff Chappell wrote articles describing these problems in NT 4:
http://geoffchappell.com/viewer.htm?doc=3Dstudies/windows/km/cpu/index.htm
http://geoffchappell.com/viewer.htm?doc=3Dstudies/windows/km/cpu/cx8.htm

Yuhong Bao
 		 	   		 =20
_________________________________________________________________
Windows 7: It helps you do more. Explore Windows 7.
http://www.microsoft.com/Windows/windows-7/default.aspx?ocid=3DPID24727::T:=
WLMTAGL:ON:WL:en-US:WWL_WIN_evergreen3:102009=
