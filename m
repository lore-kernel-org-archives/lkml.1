Return-Path: <linux-kernel-owner+w=401wt.eu-S1754184AbZJ1Oqx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754184AbZJ1Oqx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Oct 2009 10:46:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752994AbZJ1Oqw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Oct 2009 10:46:52 -0400
Received: from snt0-omc1-s27.snt0.hotmail.com ([65.55.90.38]:5987 "EHLO
	snt0-omc1-s27.snt0.hotmail.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752104AbZJ1Oqw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Oct 2009 10:46:52 -0400
Message-ID: <SNT125-W4557277972E36C16091B9EC3B80@phx.gbl>
X-Originating-IP: [164.116.126.146]
From: Yuhong Bao <yuhongbao_386@hotmail.com>
To: <jengelh@medozas.de>
CC: <macro@linux-mips.org>, <davej@redhat.com>, <linux-kernel@vger.kernel.org>,
       <mingo@elte.hu>, <tglx@linutronix.de>, <hpa@zytor.com>
Subject: RE: [X86] Fix up silly i1586 boot message.
Date: Wed, 28 Oct 2009 07:46:54 -0700
Importance: Normal
In-Reply-To: <alpine.LSU.2.00.0910280914590.28170@obet.zrqbmnf.qr>
References: <20080528165713.GA412@redhat.com>
 <alpine.LNX.1.10.0805281943330.19264@fbirervta.pbzchgretzou.qr>
 <Pine.LNX.4.55.0805281850540.29522@cliff.in.clinika.pl>
 <alpine.LNX.1.10.0805282001180.19264@fbirervta.pbzchgretzou.qr>
 <Pine.LNX.4.55.0805281916480.29522@c
 <SNT125-W471F856F2358A53E59A13BC3B80@phx.gbl>
X-OriginalArrivalTime: 28 Oct 2009 14:46:53.0584 (UTC) FILETIME=[7D58C900:01CA57DD]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


 <alpine.LSU.2.00.0910280914590.28170@obet.zrqbmnf.qr>
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0


> On Wednesday 2009-10-28 04:08=2C Yuhong Bao wrote:
>>=20
>>
>>> Intel started it first with picking up a ridiculous number for the fami=
ly
>>> ID for the P4 line. There is no technical justification for not keeping
>>> these numbers consecutive.
>
> Once one knows that there are 4 bits for the family field=2C 15 is not
> such a strange value - it is the last value=2C one could take it as
> "reserved=2C and look elsewhere".
Indeed=2C as I said=2C AMD began to use the extended family field with the =
K10.
>>[...] Intel has assigned family 7 for the original Itanium processor
>>[...] there was a bug in original NT 4 truncating family IDs
>>returned by CPUID [...]
>
> That would explain why Intel still shows an oldfashioned family=3D6 on
> many contemporary processors (e.g. core i7). BUT=2C AMD64 processors
> have family=3D15 "almost throughout"=2C and so seem to have at least some
> Intel models.=A0See my second mailing post message for why.
> So that tells us that either NT4 works=2C or nobody uses
> NT4 on fam15s.Family 15 truncated to 3 bits is family 7=2C which do work =
with NT 4=2C while family 8 truncated to 3 bits is family 0.
Yuhong bao 		 	   		 =20
_________________________________________________________________
Windows 7: Simplify your PC. Learn more.
http://www.microsoft.com/Windows/windows-7/default.aspx?ocid=3DPID24727::T:=
WLMTAGL:ON:WL:en-US:WWL_WIN_evergreen1:102009=
