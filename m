Return-Path: <linux-kernel-owner+w=401wt.eu-S1755441AbZLYOYl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755441AbZLYOYl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Dec 2009 09:24:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754910AbZLYOYk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Dec 2009 09:24:40 -0500
Received: from mail-ew0-f219.google.com ([209.85.219.219]:60314 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752886AbZLYOYj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Dec 2009 09:24:39 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:in-reply-to:references:x-mailer
         :mime-version:content-type;
        b=VcmNUA/+765GHkt4PMRi0JfrpUppL9UntbcWG9RfFmhCo96dOs+acc6uF7FrOvhkWL
         EQqf1slKEREqCg8stTNnrCHlBMyTTBddA5xeZuLilKCL+3gc7QWB3ebipkoHfALXM00W
         uLcm42sCvQwjttb/mQvfUBIshhg2BhhUsd8Xs=
Date: Fri, 25 Dec 2009 16:25:28 +0200
From: Sergei Trofimovich <slyich@gmail.com>
To: Takashi Iwai <tiwai@suse.de>
Cc: linux-kernel@vger.kernel.org, Maciej Rutecki <maciej.rutecki@gmail.com>,
       =?UTF-8?B?w4lyaWM=?= Piel <eric.piel@tremplin-utc.net>
Subject: Re: intel hda regression: 2.6.33-rc{1,2}: hd-audio0 eats 25% CPU
 (according to top)
Message-ID: <20091225162528.5dbbbea0@mosly>
In-Reply-To: <s5h637vmhcu.wl%tiwai@suse.de>
References: <alpine.LFD.2.00.0912250124410.11466@x200s>
	<20091225122107.357d7102@mosly>
	<s5h637vmhcu.wl%tiwai@suse.de>
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.18.5; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/Huoy455xnyo=e+/X2Ro=hQP"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/Huoy455xnyo=e+/X2Ro=hQP
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Fri, 25 Dec 2009 12:18:57 +0100
Takashi Iwai <tiwai@suse.de> wrote:

> At Fri, 25 Dec 2009 12:21:07 +0200,
> Sergei Trofimovich wrote:
> >=20
> > $SUBJ
> >=20
> > $ git describe
> > v2.6.33-rc2
> >=20
> > No matter if I actually play any sounds that process consumes 23-24% CPU
> > Don't know if it's related to above: even if there is no any sound acti=
vity
> > I can hear crackling in headphones.
> >=20
> > $ lspci -vvv
> >=20
> > 00:1b.0 Audio device: Intel Corporation 82801H (ICH8 Family) HD Audio C=
ontroller (rev 03)
> >         Subsystem: Hewlett-Packard Company Device 30c9
> >         Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- Par=
Err- Stepping- SERR- FastB2B- DisINTx+
> >         Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=3Dfast >TAbort=
- <TAbort- <MAbort- >SERR- <PERR- INTx-
> >         Latency: 0, Cache Line Size: 64 bytes
> >         Interrupt: pin A routed to IRQ 27
> >         Region 0: Memory at e0644000 (64-bit, non-prefetchable) [size=
=3D16K]
> >         Capabilities: [50] Power Management version 2
> >                 Flags: PMEClk- DSI- D1- D2- AuxCurrent=3D55mA PME(D0+,D=
1-,D2-,D3hot+,D3cold+)
> >                 Status: D0 NoSoftRst- PME-Enable- DSel=3D0 DScale=3D0 P=
ME-
> >         Capabilities: [60] MSI: Enable+ Count=3D1/1 Maskable- 64bit+
> >                 Address: 00000000fee0300c  Data: 4191
> >         Capabilities: [70] Express (v1) Root Complex Integrated Endpoin=
t, MSI 00
> >                 DevCap: MaxPayload 128 bytes, PhantFunc 0, Latency L0s =
unlimited, L1 unlimited
> >                         ExtTag- RBE- FLReset-
> >                 DevCtl: Report errors: Correctable- Non-Fatal- Fatal- U=
nsupported-
> >                         RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop+
> >                         MaxPayload 128 bytes, MaxReadReq 128 bytes
> >                 DevSta: CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr=
+ TransPend-
> >                 LnkCap: Port #0, Speed unknown, Width x0, ASPM unknown,=
 Latency L0 <64ns, L1 <1us
> >                         ClockPM- Surprise- LLActRep- BwNot-
> >                 LnkCtl: ASPM Disabled; Disabled- Retrain- CommClk-
> >                         ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
> >                 LnkSta: Speed unknown, Width x0, TrErr- Train- SlotClk-=
 DLActive- BWMgmt- ABWMgmt-
> >         Capabilities: [100] Virtual Channel <?>
> >         Capabilities: [130] Root Complex Link <?>
> >         Kernel driver in use: HDA Intel
> >         Kernel modules: snd-hda-intel
> >=20
> > $ powertop
> >=20
> > Cn                Avg residency       P-states (frequencies)
> > C0 (cpu running)        (25.1%)         1200 Mhz     4.7%
> > C1                0.0ms ( 0.0%)         1067 Mhz     0.2%
> > C2                0.3ms (74.9%)          933 Mhz     0.2%
> >                                          800 Mhz    94.9%
> >=20
> >=20
> > Wakeups-from-idle per second : 2931.9   interval: 10.0s
> > no ACPI power usage estimate available
> >=20
> > Top causes for wakeups:
> >   80.6% (6766.8)       <interrupt> : HDA Intel=20
> >   10.5% (885.6)      <kernel IPI> : Rescheduling interrupts=20
> >    6.4% (541.3)     <kernel core> : hrtimer_start_range_ns (tick_sched_=
timer)=20
> This has been already reported by some people, but unfortunately I
> couldn't reproduce this on my test machines.
>=20
> Eric figured out that replacing the whole sound/pci/hda/* files with
> 2.6.31 works, so this must be a regression in that area.
> Could someone bisect it?  The commits to check are restricted only in
> sound/pci/hda, so there shouldn't be many changes.
>=20
> 	% git bisect start -- sound/pci/hda
> 	% git bisect bad
> 	% git bisect good v2.6.32
>=20
>=20
> thanks,

Done:

d56757abc11a21996d9839c0d4e3b2c3666cd318 is the first bad commit
commit d56757abc11a21996d9839c0d4e3b2c3666cd318
Author: Takashi Iwai <tiwai@suse.de>
Date:   Wed Nov 18 08:00:14 2009 +0100

    ALSA: hda - Replace the rest of jack-detections with snd_hda_jack_detec=
t()

    Signed-off-by: Takashi Iwai <tiwai@suse.de>

:040000 040000 46040881f7bc4b662a784ac66a6482c2a5b3dca5 6a76aa47a3d0cccad0c=
8a3ae62cb63ecbdd9b44d M      sound

Bisect log:
git bisect start '--' 'sound/pci/hda'
# bad: [55639353a0035052d9ea6cfe4dde0ac7fcbb2c9f] Linux 2.6.33-rc1
git bisect bad 55639353a0035052d9ea6cfe4dde0ac7fcbb2c9f
# good: [22763c5cf3690a681551162c15d34d935308c8d7] Linux 2.6.32
git bisect good 22763c5cf3690a681551162c15d34d935308c8d7
# good: [123c07aeddd71fbb295842a8c19866e780b9a100] ALSA: hda_intel: Digital=
 PC Beep - change behaviour for input layer
git bisect good 123c07aeddd71fbb295842a8c19866e780b9a100
# good: [123c07aeddd71fbb295842a8c19866e780b9a100] ALSA: hda_intel: Digital=
 PC Beep - change behaviour for input layer
git bisect good 123c07aeddd71fbb295842a8c19866e780b9a100
# bad: [0b587fc4d35afb1bc0fc3d890084bb14c78372dc] ALSA: hda: Fix max PCM le=
vel to 0 dB for Fujitsu-Siemens laptops using CX2054
9 (Venice)
git bisect bad 0b587fc4d35afb1bc0fc3d890084bb14c78372dc
# good: [23ccc2bd246a5bdb1ac03dc9040a0585c1890ef3] ALSA: intelhdmi - export=
 monitor-presence and ELD-valid status
git bisect good 23ccc2bd246a5bdb1ac03dc9040a0585c1890ef3
# bad: [d56757abc11a21996d9839c0d4e3b2c3666cd318] ALSA: hda - Replace the r=
est of jack-detections with snd_hda_jack_detect()
git bisect bad d56757abc11a21996d9839c0d4e3b2c3666cd318
# good: [848de598eef9603d6f2c174f90fded4e63ac5e23] ALSA: intelhdmi - sticky=
 infoframe
git bisect good 848de598eef9603d6f2c174f90fded4e63ac5e23
# good: [81bf31e2d0a6a9f5d83da0a757f8ca03db908162] ALSA: intelhdmi - sticky=
 channel count
git bisect good 81bf31e2d0a6a9f5d83da0a757f8ca03db908162
# good: [83d605fd63e704419ccb92d48b735c6890ce3d6a] ALSA: hda - show EPSS ca=
pability in proc
git bisect good 83d605fd63e704419ccb92d48b735c6890ce3d6a

Sorry, was unable to revert that commit on top of current 2.6.33-rc2 and ve=
rify it's guilty.

> Takashi

--=20

  Sergei

--Sig_/Huoy455xnyo=e+/X2Ro=hQP
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.11 (GNU/Linux)

iEYEARECAAYFAks0y10ACgkQcaHudmEf86oYogCfYNKbwJtqtGklJ6I5ZDcXHG2D
yv8AnAlAPcHS5/EnrsD5qsafwLZhs5sm
=QCmA
-----END PGP SIGNATURE-----

--Sig_/Huoy455xnyo=e+/X2Ro=hQP--
