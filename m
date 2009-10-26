Return-Path: <linux-kernel-owner+w=401wt.eu-S1755306AbZJZIbB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755306AbZJZIbB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Oct 2009 04:31:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755283AbZJZIbA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Oct 2009 04:31:00 -0400
Received: from clegg.madduck.net ([193.242.105.96]:33918 "EHLO
	clegg.madduck.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755281AbZJZIbA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Oct 2009 04:31:00 -0400
X-Greylist: delayed 429 seconds by postgrey-1.27 at vger.kernel.org; Mon, 26 Oct 2009 04:30:59 EDT
Date: Mon, 26 Oct 2009 09:23:50 +0100
From: martin f krafft <madduck@madduck.net>
To: linux kernel mailing list <linux-kernel@vger.kernel.org>
Subject: What are these ATA exceptions trying to tell me? [2.6.26] System
 Events]
Message-ID: <20091026082350.GA23992@piper.oerlikon.madduck.net>
Mail-Followup-To: linux kernel mailing list <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-ripemd160;
	protocol="application/pgp-signature"; boundary="KsGdsel6WgEHnImy"
Content-Disposition: inline
X-Motto: Keep the good times rollin'
X-OS: Debian GNU/Linux squeeze/sid kernel 2.6.31-rc6-amd64 x86_64
X-Spamtrap: madduck.bogus@madduck.net
X-Subliminal-Message: debian/rules!
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--KsGdsel6WgEHnImy
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Dear folks,

I have a quality and high performance, new rack-mounted system, but
every now and then, the kernel spews a slew of messages like the
following to syslog:

  ata3: EH in SWNCQ mode,QC:qc_active 0x7FFF sactive 0x7FFF
  ata3: SWNCQ:qc_active 0x1 defer_bits 0x7FFE last_issue_tag 0x0
  dhfis 0x1 dmafis 0x0 sdbfis 0x0
  ata3: ATA_REG 0x40 ERR_REG 0x0
  ata3: tag : dhfis dmafis sdbfis sacitve
  ata3: tag 0x0: 1 0 0 1
  ata3.00: exception Emask 0x0 SAct 0x7fff SErr 0x0 action 0x6 frozen
  ata3.00: cmd 61/18:00:4f:22:b3/00:00:05:00:00/40 tag 0 ncq 12288 out
          res 40/00:01:01:4f:c2/00:00:00:00:00/00 Emask 0x4 (timeout)
  ata3.00: status: { DRDY }
  [...]
  ata3: hard resetting link
  ata3: SRST failed (errno=3D-19)
  ata3: SATA link down (SStatus 0 SControl 300)
  ata3: failed to recover some devices, retrying in 5 secs
  ata3: hard resetting link
  ata3: link is slow to respond, please be patient (ready=3D-19)
  ata3: SRST failed (errno=3D-16)
  ata3: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
  ata3.00: configured for UDMA/133
  ata3: exception Emask 0x10 SAct 0x0 SErr 0x0 action 0x9 t4
  ata3: hot plug
  ata3.00: configured for UDMA/133
  sd 2:0:0:0: [sdc] 1953525168 512-byte hardware sectors (1000205 MB)
  sd 2:0:0:0: [sdc] Write Protect is off
  sd 2:0:0:0: [sdc] Mode Sense: 00 3a 00 00
  sd 2:0:0:0: [sdc] Write cache: enabled, read cache: enabled, doesn't supp=
ort DPO or FUA
  sd 2:0:0:0: [sdc] 1953525168 512-byte hardware sectors (1000205 MB)
  sd 2:0:0:0: [sdc] Write Protect is off
  sd 2:0:0:0: [sdc] Mode Sense: 00 3a 00 00
  sd 2:0:0:0: [sdc] Write cache: enabled, read cache: enabled, doesn't supp=
ort DPO or FUA

This happens for ata[34], but never for ata[12].

At the time of these messages, the the machine was not loaded. In
particular, there was no SMART self-test running. I mention this
because i have set smartd to short tests daily and extended tests
weekly, and those only rarely complete:

  # 1  Extended offline    Interrupted (host reset)      00%      4812     =
    -
  # 2  Short offline       Interrupted (host reset)      00%      4684     =
    -

while they run fine for ata[12].

The chipset is nVidia MCP55. Am I dealing with a broken controller?

Cheers,

--=20
martin | http://madduck.net/ | http://two.sentenc.es/
=20
"i like young girls. their stories are shorter."
                                                        -- tom mcguane
=20
spamtraps: madduck.bogus@madduck.net

--KsGdsel6WgEHnImy
Content-Type: application/pgp-signature; name="digital_signature_gpg.asc"
Content-Description: Digital signature (see http://martin-krafft.net/gpg/)
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEAREDAAYFAkrlXJEACgkQIgvIgzMMSnVpOQCg6KTfEQSfsiyKUiz9zo89EHYP
SygAn0aI2i6zaDcs0u8DTX5aSXYpwtQV
=yswe
-----END PGP SIGNATURE-----

--KsGdsel6WgEHnImy--
