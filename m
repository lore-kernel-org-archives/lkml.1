Return-Path: <linux-kernel-owner+w=401wt.eu-S1754525AbZBNWan@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754525AbZBNWan (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Feb 2009 17:30:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752747AbZBNWaW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Feb 2009 17:30:22 -0500
Received: from bay0-omc3-s25.bay0.hotmail.com ([65.54.246.225]:7800 "EHLO
	bay0-omc3-s25.bay0.hotmail.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752477AbZBNWaU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Feb 2009 17:30:20 -0500
Message-ID: <BAY108-W52F43AD46BC7BE27057F0B9DB90@phx.gbl>
Content-Type: multipart/mixed;
	boundary="_987e6a83-ec27-4650-913d-84355869003d_"
X-Originating-IP: [83.226.134.188]
From: Richard Jonsson <richard_jonsson@hotmail.com>
To: <hancockrwd@gmail.com>
CC: lkml <linux-kernel@vger.kernel.org>
Subject: RE: Unable to write dvd+r on 3 systems
Date: Sat, 14 Feb 2009 23:30:18 +0100
Importance: Normal
In-Reply-To: <49973D4B.30802@gmail.com>
References: <BAY108-W34B897781EDB26A588B4B29DB90@phx.gbl>
 <49973D4B.30802@gmail.com>
MIME-Version: 1.0
X-OriginalArrivalTime: 14 Feb 2009 22:30:19.0350 (UTC) FILETIME=[D11FF760:01C98EF3]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--_987e6a83-ec27-4650-913d-84355869003d_
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable




----------------------------------------
> Date: Sat=2C 14 Feb 2009 15:53:15 -0600
> From: hancockrwd@gmail.com
> To: richard_jonsson@hotmail.com
> CC: linux-kernel@vger.kernel.org
> Subject: Re: Unable to write dvd+r on 3 systems
>
> Richard Jonsson wrote:
>>
>> It seems I am the last person on earth burning dvd's. I have tried on th=
ree different systems=2C using a mix of growisofs=2C xfburn=2C brasero and =
k3b. They all give the same result for their respective system.
>>
>> On system 1 it takes forever to complete the process. The system is comp=
letely useless while burning. IO wait is 50% and hardIRQ is 10-20%. If audi=
o is playing at the same time it stutters in a way that it sounds as it's p=
laying slow. Mouse cursor jerks and it takes eons to even open a new termin=
al.
>>
>> On system 2 growisofs will try for half a minute and then fail with a me=
ssage in dmesg. The disc isn't even touched. Tried homebuilt kernel.org ker=
nels from 2.6.25 to current git with no difference. See attachment "growiso=
fs_system2.txt". I have been able to burn exactly 1 disc in total=2C which =
magically started recording immediately.
>>
>> System 3 burns at decent speed and always reports success=2C but about h=
alf the time only part of the disc is actually burned. It is visible to the=
 eye=2C and it will not work. Tried at 4x too.
>
> It sounds like you may have multiple problems. System 1 sounds like
> maybe DMA is not being used for some reason=2C the dmesg output would be
> useful. On System 2 it looks like a write timed out=2C and system 3 is
> having burn quality problems. System 1 may have a kernel issue that
> should be looked into=2C but as for the other two=2C I would tend to susp=
ect
> the quality of the discs you are using. There is a lot of crap media out
> there=2C and also some burners don't like discs with media codes that the=
y
> don't have preprogrammed burn strategies for.

Thanks for your reply.

System 1 is affected by
http://bugzilla.kernel.org/show_bug.cgi?id=3D12309
Also=2C just noticed that it doesn't appear to have udma capability?!
(see attachment).

Regarding system 3=2C should there not be an error raised or some such?
It appears to complete the process=2C but halfway through the laser is
cut?

As for the media=2C I currently use branded discs (tdk)=2C any
recommendations what to shop for?

_________________________________________________________________
Kolla mailen n=E4r du =E4r p=E5 spr=E5ng - skaffa Hotmail i mobilen!
http://windowslivemobile.msn.com/BrowserServiceHotmail.aspx?lang=3DSE-SE=

--_987e6a83-ec27-4650-913d-84355869003d_
Content-Type: text/plain
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="hdparm_system1.txt"

Ci9kZXYvZHZkOgoKIE1vZGVsPUhMLURULVNUIERWRFJBTSBHTUEtNDA4Mk4gICAgICAgICAgICAg
ICAsIEZ3UmV2PUhRMDQgICAgLCBTZXJpYWxObz1LMDg2OEVLNTIwMSAgICAgICAgIAogQ29uZmln
PXsgRml4ZWQgUmVtb3ZlYWJsZSBEVFI8PTVNYnMgRFRSPjEwTWJzIG5vbk1hZ25ldGljIH0KIFJh
d0NIUz0wLzAvMCwgVHJrU2l6ZT0wLCBTZWN0U2l6ZT0wLCBFQ0NieXRlcz0wCiBCdWZmVHlwZT11
bmtub3duLCBCdWZmU2l6ZT0wa0IsIE1heE11bHRTZWN0PTAKIChtYXliZSk6IEN1ckNIUz0wLzAv
MCwgQ3VyU2VjdHM9MCwgTEJBPXllcywgTEJBc2VjdHM9MAogSU9SRFk9b24vb2ZmLCB0UElPPXtt
aW46MTIwLHcvSU9SRFk6MTIwfSwgdERNQT17bWluOjEyMCxyZWM6MTIwfQogUElPIG1vZGVzOiAg
cGlvMCBwaW8xIHBpbzIgcGlvMyBwaW80IAogRE1BIG1vZGVzOiAgbWRtYTAgbWRtYTEgKm1kbWEy
IAogQWR2YW5jZWRQTT1ubwogRHJpdmUgY29uZm9ybXMgdG86IEFUQS9BVEFQSS01IFQxMyAxMzIx
RCByZXZpc2lvbiAzOiAgQVRBL0FUQVBJLTIsMyw0LDUKCiAqIHNpZ25pZmllcyB0aGUgY3VycmVu
dCBhY3RpdmUgbW9kZQoKCkFUQVBJIENELVJPTSwgd2l0aCByZW1vdmFibGUgbWVkaWEKCU1vZGVs
IE51bWJlcjogICAgICAgSEwtRFQtU1QgRFZEUkFNIEdNQS00MDgyTiAgICAgICAgICAgICAgIAoJ
U2VyaWFsIE51bWJlcjogICAgICBLMDg2OEVLNTIwMSAgICAgICAgIAoJRmlybXdhcmUgUmV2aXNp
b246ICBIUTA0ICAgIApTdGFuZGFyZHM6CglMaWtlbHkgdXNlZCBDRC1ST00gQVRBUEktMQpDb25m
aWd1cmF0aW9uOgoJRFJRIHJlc3BvbnNlOiA1MHVzLgoJUGFja2V0IHNpemU6IDEyIGJ5dGVzCkNh
cGFiaWxpdGllczoKCUxCQSwgSU9SRFkoY2FuIGJlIGRpc2FibGVkKQoJRE1BOiBtZG1hMCBtZG1h
MSAqbWRtYTIgCgkgICAgIEN5Y2xlIHRpbWU6IG1pbj0xMjBucyByZWNvbW1lbmRlZD0xMjBucwoJ
UElPOiBwaW8wIHBpbzEgcGlvMiBwaW8zIHBpbzQgCgkgICAgIEN5Y2xlIHRpbWU6IG5vIGZsb3cg
Y29udHJvbD0xMjBucyAgSU9SRFkgZmxvdyBjb250cm9sPTEyMG5zCkhXIHJlc2V0IHJlc3VsdHM6
CglDQkxJRC0gYmVsb3cgVmloCglEZXZpY2UgbnVtID0gMAo=

--_987e6a83-ec27-4650-913d-84355869003d_--
