Return-Path: <linux-kernel-owner+w=401wt.eu-S1763068AbYARQ3S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763068AbYARQ3S (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2008 11:29:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763183AbYARQ2N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jan 2008 11:28:13 -0500
Received: from threatwall.zlynx.org ([199.45.143.218]:33327 "EHLO zlynx.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1762657AbYARQ2L (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2008 11:28:11 -0500
Subject: Re: [2.6.24-rc8-mm1] Locking API boot-time self-tests hangs.
From: Zan Lynx <zlynx@acm.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>,
       linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>
In-Reply-To: <20080117204247.5318e500.akpm@linux-foundation.org>
References: <200801180120.m0I1KBuC065806@www262.sakura.ne.jp>
	 <20080117181935.02294863.akpm@linux-foundation.org>
	 <200801180319.m0I3Ju9N089501@www262.sakura.ne.jp>
	 <20080117204247.5318e500.akpm@linux-foundation.org>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-gLza4BB7VUNO3aUTfdoH"
Date: Fri, 18 Jan 2008 09:27:56 -0700
Message-Id: <1200673676.7735.3.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.2 
X-Envelope-From: zlynx@acm.org
X-Spam-Id: 20080118/1JFu4T-0004GX-Un-linux-kernel@vger.kernel.org:zlynx@acm.org:199.45.143.218
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-gLza4BB7VUNO3aUTfdoH
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


On Thu, 2008-01-17 at 20:42 -0800, Andrew Morton wrote:
> On Fri, 18 Jan 2008 12:19:56 +0900 Tetsuo Handa <penguin-kernel@i-love.sa=
kura.ne.jp> wrote:
>=20
> > Hello.
> >=20
> > Andrew Morton wrote:
> > > I'd be suspecting git-sched, so in lieu of a full bisection search it=
 would
> > > be great if one of you could apply
> > > http://userweb.kernel.org/~akpm/git-sched.patch to 2.6.24-rc8 and see=
 if it
> > > fails in the same way.
> > Too bad. It didn't fail.
> >=20
>=20
> I used your exact .config with the current mm lineup (I don't thinlk
> anything relevant has changed) and it booted OK on my old PIII machine.
>=20
> It could be compiler version dependent.  I used gcc-4.1.0.  Which version
> were you and Zan using please?

=46rom my -rc6-mm1 boot.

$ scripts/ver_linux=20
If some fields are empty or look unusual you may have an old version.
Compare to the current minimal requirements in Documentation/Changes.
=20
Linux zephyr 2.6.24-rc6-mm1 #1 SMP Tue Dec 25 17:53:03 MST 2007 x86_64
AMD Athlon(tm) 64 Processor 3400+ AuthenticAMD GNU/Linux
=20
Gnu C                  4.2.2
Gnu make               3.81
binutils               2.18.50.0.1.20070908
util-linux             2.13.1
mount                  2.13.1
module-init-tools      3.4
e2fsprogs              1.40.4
reiserfsprogs          3.6.19
reiser4progs           1.0.6
pcmciautils            014
pcmcia-cs              3.2.9
PPP                    2.4.4
nfs-utils              1.0.7
Linux C Library        Dynamic linker (ldd)   2.7
Procps                 3.2.7
Net-tools              1.60
Kbd                    1.13
oprofile               0.9.3
Sh-utils               6.9
udev                   118
wireless-tools         29
Modules Loaded         nls_cp437 vfat fat nls_iso8859_1 isofs nls_base
nouveau drm snd_pcm_oss snd_mixer_oss snd_seq_dummy snd_seq_oss
snd_seq_midi_event snd_seq snd_seq_device rfcomm l2cap usbhid hid
hci_usb bluetooth usb_storage libusual joydev nvidiafb fb fb_ddc
i2c_algo_bit cfbcopyarea vgastate i2c_core cfbimgblt cfbfillrect
snd_intel8x0m snd_intel8x0 snd_ac97_codec ehci_hcd psmouse ohci_hcd
serio_raw ac97_bus snd_pcm snd_timer usbcore evdev snd sg snd_page_alloc

--=20
Zan Lynx <zlynx@acm.org>

--=-gLza4BB7VUNO3aUTfdoH
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.7 (GNU/Linux)

iD8DBQBHkNOMG8fHaOLTWwgRAvS2AJ9OZZNZpMtbPkULFPKcezQyX7Hd8gCfYf3P
NFxBX5kpyAHdX9rWPmbtKT0=
=zsUq
-----END PGP SIGNATURE-----

--=-gLza4BB7VUNO3aUTfdoH--

