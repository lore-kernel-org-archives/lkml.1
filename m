Return-Path: <linux-kernel-owner+w=401wt.eu-S1762641AbXGEVqm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762641AbXGEVqm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jul 2007 17:46:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758449AbXGEVqf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Jul 2007 17:46:35 -0400
Received: from ns2.uludag.org.tr ([193.140.100.220]:36437 "EHLO uludag.org.tr"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752731AbXGEVqe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jul 2007 17:46:34 -0400
From: "=?utf-8?q?S=2E=C3=87a=C4=9Flar?= Onur" <caglar@pardus.org.tr>
Reply-To: caglar@pardus.org.tr
Organization: =?utf-8?q?T=C3=9CB=C4=B0TAK_/?= UEKAE
To: LKML <linux-kernel@vger.kernel.org>
Subject: SATA exceptions
Date: Fri, 6 Jul 2007 00:46:10 +0300
User-Agent: KMail/1.9.7
Cc: Tejun Heo <htejun@gmail.com>, Jeff Garzik <jgarzik@pobox.com>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart17411263.Cf5llTX13i";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200707060046.13237.caglar@pardus.org.tr>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart17411263.Cf5llTX13i
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

Hi;

I'm starting to see following logs in dmesg for a while (according to kern.=
log=20
these starts with 2.6.22-rc4) on HP Pavilion dv2385ea

=2E..
[ 4260.278408] ata1.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x0
[ 4260.278417] ata1.00: (irq_stat 0x40000001)
[ 4260.278427] ata1.00: cmd ca/00:08:d0:88:bc/00:00:00:00:00/ee tag 0 cdb 0=
x0=20
data 4096 out
[ 4260.278430]          res 51/40:01:d7:88:bc/00:00:0e:00:00/ee Emask 0x9=20
(media error)
[ 4260.911247] ata1.00: configured for UDMA/100
[ 4260.911263] ata1: EH complete
[ 4260.911809] sd 0:0:0:0: [sda] 312581808 512-byte hardware sectors (16004=
2=20
MB)
[ 4260.912127] sd 0:0:0:0: [sda] Write Protect is off
[ 4260.912135] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[ 4260.912672] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled,=
=20
doesn't support DPO or FUA
=2E..

zangetsu log # grep "ata1.00: exception" kern.log
Jun 10 23:23:33 localhost kernel: [ 3472.867317] ata1.00: exception Emask 0=
x0=20
SAct 0x0 SErr 0x0 action 0x0
Jun 12 17:09:56 localhost kernel: [ 2470.530793] ata1.00: exception Emask 0=
x0=20
SAct 0x0 SErr 0x0 action 0x0
Jun 12 17:11:19 localhost kernel: [ 2553.874662] ata1.00: exception Emask 0=
x0=20
SAct 0x0 SErr 0x0 action 0x0
Jun 13 12:08:46 localhost kernel: [ 2235.664683] ata1.00: exception Emask 0=
x0=20
SAct 0x0 SErr 0x0 action 0x0
Jun 17 16:59:23 localhost kernel: [ 9208.673909] ata1.00: exception Emask 0=
x0=20
SAct 0x0 SErr 0x0 action 0x0
Jun 22 13:35:56 localhost kernel: [ 1719.191725] ata1.00: exception Emask 0=
x0=20
SAct 0x0 SErr 0x0 action 0x0
Jun 24 14:13:46 localhost kernel: [ 5822.239007] ata1.00: exception Emask 0=
x0=20
SAct 0x0 SErr 0x0 action 0x0
Jun 26 15:24:11 localhost kernel: [ 1315.455726] ata1.00: exception Emask 0=
x0=20
SAct 0x0 SErr 0x0 action 0x0
Jun 26 15:36:46 localhost kernel: [ 2069.003291] ata1.00: exception Emask 0=
x0=20
SAct 0x0 SErr 0x0 action 0x0
Jun 26 15:37:01 localhost kernel: [ 2082.955499] ata1.00: exception Emask 0=
x0=20
SAct 0x0 SErr 0x0 action 0x0
Jun 26 15:37:21 localhost kernel: [ 2103.400411] ata1.00: exception Emask 0=
x0=20
SAct 0x0 SErr 0x0 action 0x0
Jun 26 15:37:38 localhost kernel: [ 2120.251088] ata1.00: exception Emask 0=
x0=20
SAct 0x0 SErr 0x0 action 0x0
Jun 28 10:23:55 localhost kernel: [  383.355017] ata1.00: exception Emask 0=
x0=20
SAct 0x0 SErr 0x0 action 0x0
Jul  5 22:05:14 localhost kernel: [ 4260.278408] ata1.00: exception Emask 0=
x0=20
SAct 0x0 SErr 0x0 action 0x0
Jul  5 22:05:52 localhost kernel: [ 4297.784773] ata1.00: exception Emask 0=
x0=20
SAct 0x0 SErr 0x0 action 0x0

Neither fsck nor badblocks didn't report anything wrong and i far as i know=
=20
these didn't make any real problem until now but i'm not sure they are=20
harmness or not (or indicates a hw error), so=20

dmesg, smartctl -a, /proc/interrupts and lspci -vv outputs can be found @[1]

if anything else needed please just tell...

[1] http://cekirdek.pardus.org.tr/~caglar/SATA/

Cheers
=2D-=20
S.=C3=87a=C4=9Flar Onur <caglar@pardus.org.tr>
http://cekirdek.pardus.org.tr/~caglar/

Linux is like living in a teepee. No Windows, no Gates and an Apache in hou=
se!

--nextPart17411263.Cf5llTX13i
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.4 (GNU/Linux)

iD8DBQBGjWaly7E6i0LKo6YRApl5AKCgK5ezcPEPrE6qDbx8VlHXwu6itgCghLsl
x0gNpAxmDpv/erXf5yfjqBU=
=Z0pF
-----END PGP SIGNATURE-----

--nextPart17411263.Cf5llTX13i--
