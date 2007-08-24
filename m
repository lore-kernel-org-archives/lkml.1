Return-Path: <linux-kernel-owner+w=401wt.eu-S932249AbXHXX1Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932249AbXHXX1Z (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Aug 2007 19:27:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762597AbXHXX1R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Aug 2007 19:27:17 -0400
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:45609 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1762292AbXHXX1Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Aug 2007 19:27:16 -0400
X-Sasl-enc: 8ONX6ow3KlcwXEZInvK7W3383IzsNmnS6n2mRV4PWu2K 1187998034
Message-ID: <46CF695D.1020008@imap.cc>
Date: Sat, 25 Aug 2007 01:27:25 +0200
From: Tilman Schmidt <tilman@imap.cc>
Organization: me - organized??
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.0; de-AT; rv:1.8.1.4) Gecko/20070509 SeaMonkey/1.1.2 Mnenhy/0.7.5.666
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: linux-kernel@vger.kernel.org
Subject: Re: 2.6.23-rc3-mm1
References: <20070822020648.5ea3a612.akpm@linux-foundation.org>
In-Reply-To: <20070822020648.5ea3a612.akpm@linux-foundation.org>
X-Enigmail-Version: 0.95.1
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enigE24FF85F7AE75226DDD39397"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigE24FF85F7AE75226DDD39397
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Am 22.08.2007 11:06 schrieb Andrew Morton:
> ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.23-rc=
3/2.6.23-rc3-mm1/

After applying Matthew Wilcox' patch to include/linux/isa.h this compiles=

and boots on my Intel/openSUSE 10.2 test machine but throws out the
following messages I don't remember ever seeing with other kernels:

- on console early during boot, also in SuSE's /var/log/boot.msg:

your system time is not correct:
Wed Jul 13 13:15:31 UTC 1910
setting system time to:
Tue Jul 24 00:00:00 UTC 2007

- later, dto. on console and in /var/log/boot.msg:

FATAL: Error inserting processor (/lib/modules/2.6.23-rc3-mm1-testing/ker=
nel/drivers/acpi/processor.ko): Input/output error
WARNING: Error inserting processor (/lib/modules/2.6.23-rc3-mm1-testing/k=
ernel/drivers/acpi/processor.ko): Input/output error
FATAL: Error inserting thermal (/lib/modules/2.6.23-rc3-mm1-testing/kerne=
l/drivers/acpi/thermal.ko): Unknown symbol in module, or unknown paramete=
r (see dmesg)

- apparently corresponding to that, in dmesg:

<4>[    7.691865] thermal: Unknown symbol acpi_processor_set_thermal_limi=
t

- from fsck during boot:

/dev/system/root: Superblock last mount time is in the future.  FIXED.
/dev/system/root: Superblock last write time is in the future.  FIXED.

- in /var/log/warn:

Aug 25 00:44:00 xenon powersaved[5356]: WARNING (CpufreqManagement:51) No=
 capability cpufreq_control
Aug 25 00:44:00 xenon powersaved[5356]: WARNING (CpufreqManagement:51) No=
 capability cpufreq_control

And the SUSE startup sequence displays "failed" for the acpid daemon.
So it seems there is some strangeness wrt to system time and power
management. I don't have the time to bisect this right now, but
wanted to let you know anyway.

Apart from that, the kernel seems to work fine.

HTH

--=20
Tilman Schmidt                          E-Mail: tilman@imap.cc
Bonn, Germany
Diese Nachricht besteht zu 100% aus wiederverwerteten Bits.
Unge=F6ffnet mindestens haltbar bis: (siehe R=FCckseite)


--------------enigE24FF85F7AE75226DDD39397
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.3rc1 (MingW32)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iD8DBQFGz2lqMdB4Whm86/kRAkdNAJ91ae9zfoTSJaZdCxpU54NtPkhGZgCfdeSR
P60cuHLEauqqrOfKP6fv43Q=
=JUDh
-----END PGP SIGNATURE-----

--------------enigE24FF85F7AE75226DDD39397--
