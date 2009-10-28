Return-Path: <linux-kernel-owner+w=401wt.eu-S1757250AbZJ1DjA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757250AbZJ1DjA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Oct 2009 23:39:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755426AbZJ1Di7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Oct 2009 23:38:59 -0400
Received: from snt0-omc4-s20.snt0.hotmail.com ([65.55.90.223]:34433 "EHLO
	snt0-omc4-s20.snt0.hotmail.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755308AbZJ1Di6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Oct 2009 23:38:58 -0400
Message-ID: <SNT125-W197E2FC08D767A0E6B69D1C3B80@phx.gbl>
X-Originating-IP: [173.64.154.25]
From: Yuhong Bao <yuhongbao_386@hotmail.com>
To: <macro@linux-mips.org>
CC: <hpa@zytor.com>, <jengelh@medozas.de>, <davej@redhat.com>,
       <linux-kernel@vger.kernel.org>, <mingo@elte.hu>, <tglx@linutronix.de>
Subject: RE: [X86] Fix up silly i1586 boot message.
Date: Tue, 27 Oct 2009 20:39:03 -0700
Importance: Normal
In-Reply-To: <Pine.LNX.4.55.0805290102340.29522@cliff.in.clinika.pl>
References: <20080528165713.GA412@redhat.com>
 <alpine.LNX.1.10.0805281943330.19264@fbirervta.pbzchgretzou.qr>
 <Pine.LNX.4.55.0805281850540.29522@cliff.in.clinika.pl>
 <alpine.LNX.1.10.0805282001180.19264@fbirervta.pbzchgretzou.qr>
 <Pine.LNX.4.55.0805281916480.29522@c
X-OriginalArrivalTime: 28 Oct 2009 03:39:03.0373 (UTC) FILETIME=[31A3CFD0:01CA5780]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


 <Pine.LNX.4.55.0805290102340.29522@cliff.in.clinika.pl>
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0



> Intel started it first with picking up a ridiculous number for the family
> ID for the P4 line. There is no technical justification for not keeping
> these numbers consecutive. Or keeping it at 6 actually if the P4 is meant
> to be seen by software as the Pentium Pro and the rest of the P6 gang.

Then Mooly Eden started the Pentium M project.
They decided to base Pentium M on the P6 microarchitecture.
Thus=2C the Pentium M was family 6=2C model 9=2C which was the same as orig=
inally used by the cancelled Timna project=2C led by the same Mooly Eden.
As it happened=2C Prescott turned out to have high heat output and power co=
nsumption=2C and as a result=2C Tejas was cancelled=2C and the NetBurst arc=
hitecture was abandoned and along with it the family 15.
The Pentium M project came to the rescue and made the Pentium M core better=
. By Core 2 Duo=2C the core had gained x86-64 support and thus was ready to=
 replace NetBurst on the desktop and server. It was family 6 model 15=2C wh=
ich confused Solaris 64-bit that thought all x86-64 CPUs was family 15. Sin=
ce they ran out of the 4-bit in the model=2C they then had to begin using t=
he extended model field=2C 45nm Core 2 processors was extended model 1. Add=
ing 15 and 1 yielded 16.
In the meantime=2C AMD came out with it's first x86-64 processor called the=
 K8=2C which copied the family 15 used by the P4 processor. Because similar=
 things had not happened at AMD=2C AMD was forced to begin using the extend=
ed family with the K10=2C which was extended family 1. Adding 15 and 1 yiel=
ded 16=2C or family 10h=2C which was what it was often called by AMD.

Yuhong Bao
 		 	   		 =20
_________________________________________________________________
Windows 7: I wanted more reliable=2C now it's more reliable. Wow!
http://microsoft.com/windows/windows-7/default-ga.aspx?h=3Dmyidea?ocid=3DPI=
D24727::T:WLMTAGL:ON:WL:en-US:WWL_WIN_myidea:102009=
