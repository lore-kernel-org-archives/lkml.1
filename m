Return-Path: <linux-kernel-owner+w=401wt.eu-S934115AbYBOO3m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934115AbYBOO3m (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2008 09:29:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759221AbYBOO3c
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Feb 2008 09:29:32 -0500
Received: from frost.carfax.org.uk ([212.13.194.111]:2347 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756858AbYBOO3a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2008 09:29:30 -0500
X-Greylist: delayed 2542 seconds by postgrey-1.27 at vger.kernel.org; Fri, 15 Feb 2008 09:29:30 EST
Date: Fri, 15 Feb 2008 13:46:58 +0000
From: Hugo Mills <hugo-lkml@carfax.org.uk>
To: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org
Subject: Spurious completions during NCQ
Message-ID: <20080215134658.GB27745@vlad.carfax.org.uk>
Mail-Followup-To: Hugo Mills <hugo-lkml@carfax.org.uk>,
	linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="DKU6Jbt7q3WqK7+M"
Content-Disposition: inline
X-GPG-Fingerprint: 8C59 86C7 81F3 93FE BB02  DDB1 20AC B3BE 515C 238D
X-GPG-Key: 515C238D
X-Parrot: It is no more. It has joined the choir invisible.
X-IRC-Nicks: darksatanic darkersatanic darkling darkthing
User-Agent: Mutt/1.5.13 (2006-08-11)
X-frost.carfax.org.uk-Spam-Score: -2.6 (--)
X-frost.carfax.org.uk-Spam-Report: Spam detection software, running on the system "admin.corona.bitfolk.com", has
	identified this incoming email as possible spam.  The original message
	has been attached to this so you can view it (if it isn't spam) or label
	similar future email.  If you have any questions, see
	the administrator of that system for details.
	Content preview:  I'm getting these on my Dell Latitude D830: Feb 15 13:06:00
	willow kernel: ata1.00: exception Emask 0x2 SAct 0x4 SErr 0x0 action 0x2
	frozen Feb 15 13:06:00 willow kernel: ata1.00: spurious completions during
	NCQ issue=0x0 SAct=0x4 FIS=004040a1:00000002 Feb 15 13:06:00 willow kernel:
	ata1.00: cmd 61/10:10:26:fb:c4/00:00:02:00:00/40 tag 2 cdb 0x0 data 8192
	out Feb 15 13:06:00 willow kernel: res 40/00:10:26:fb:c4/00:00:02:00:00/40
	Emask 0x2 (HSM violation) Feb 15 13:06:00 willow kernel: ata1: soft resetting
	port Feb 15 13:06:00 willow kernel: ata1: SATA link up 3.0 Gbps (SStatus
	123 SControl 300) Feb 15 13:06:00 willow kernel: ata1.00: configured for UDMA/133
	Feb 15 13:06:00 willow kernel: ata1: EH complete Feb 15 13:06:00 willow kernel:
	sd 0:0:0:0: [sda] 312581808 512-byte hardware sectors (160042 MB) Feb 15
	13:06:00 willow kernel: sd 0:0:0:0: [sda] Write Protect is off Feb 15 13:06:00
	willow kernel: sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00 Feb 15 13:06:00
	willow kernel: sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled,
	doesn't support DPO or FUA [...] 
	Content analysis details:   (-2.6 points, 5.0 required)
	pts rule name              description
	---- ---------------------- --------------------------------------------------
	-2.6 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--DKU6Jbt7q3WqK7+M
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

   I'm getting these on my Dell Latitude D830:

Feb 15 13:06:00 willow kernel: ata1.00: exception Emask 0x2 SAct 0x4 SErr 0x0 action 0x2 frozen
Feb 15 13:06:00 willow kernel: ata1.00: spurious completions during NCQ issue=0x0 SAct=0x4 FIS=004040a1:00000002
Feb 15 13:06:00 willow kernel: ata1.00: cmd 61/10:10:26:fb:c4/00:00:02:00:00/40 tag 2 cdb 0x0 data 8192 out
Feb 15 13:06:00 willow kernel:          res 40/00:10:26:fb:c4/00:00:02:00:00/40 Emask 0x2 (HSM violation)
Feb 15 13:06:00 willow kernel: ata1: soft resetting port
Feb 15 13:06:00 willow kernel: ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
Feb 15 13:06:00 willow kernel: ata1.00: configured for UDMA/133
Feb 15 13:06:00 willow kernel: ata1: EH complete
Feb 15 13:06:00 willow kernel: sd 0:0:0:0: [sda] 312581808 512-byte hardware sectors (160042 MB)
Feb 15 13:06:00 willow kernel: sd 0:0:0:0: [sda] Write Protect is off
Feb 15 13:06:00 willow kernel: sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
Feb 15 13:06:00 willow kernel: sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA

   In some cases, there are several cmd/res lines listed. It's
happening about once an hour or so (not correlated with any other
event that I can see). It doesn't seem to be affecting operation of
the machine, but it's making me nervous.

   Can anyone set my mind at rest? (Or suggest a fix?)

uname -a reports:
Linux willow 2.6.23.1-hrt3 #1 SMP Sun Nov 4 14:51:20 GMT 2007 x86_64 GNU/Linux

   It's a kernel.org kernel with the patch for tickless operation on
amd64.

hdparm -i reports:

/dev/sda:

 Model=ST9160823AS                             , FwRev=3.ADC   , SerialNo=            5NK0C448
 Config={ HardSect NotMFM HdSw>15uSec Fixed DTR>10Mbs RotSpdTol>.5% }
 RawCHS=16383/16/63, TrkSize=0, SectSize=0, ECCbytes=4
 BuffType=unknown, BuffSize=8192kB, MaxMultSect=16, MultSect=?8?
 CurCHS=16383/16/63, CurSects=16514064, LBA=yes, LBAsects=268435455
 IORDY=on/off, tPIO={min:120,w/IORDY:120}, tDMA={min:120,rec:120}
 PIO modes:  pio0 pio1 pio2 pio3 pio4 
 DMA modes:  mdma0 mdma1 mdma2 
 UDMA modes: udma0 udma1 udma2 udma3 udma4 udma5 
 AdvancedPM=yes: unknown setting WriteCache=enabled
 Drive conforms to: Unspecified:  ATA/ATAPI-1,2,3,4,5,6,7

 * signifies the current active mode


   Hugo.

-- 
=== Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk ===
  PGP key: 515C238D from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
              --- w.w.w.  : England's batting scorecard ---              

--DKU6Jbt7q3WqK7+M
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFHtZfSIKyzvlFcI40RAjGkAKCxuDHSck654WUiio7FZGO86RW/0ACfcU6d
vzeJ/lidh5rvDF+2LxONio8=
=M6oS
-----END PGP SIGNATURE-----

--DKU6Jbt7q3WqK7+M--
