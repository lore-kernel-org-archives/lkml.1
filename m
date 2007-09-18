Return-Path: <linux-kernel-owner+w=401wt.eu-S1754640AbXISFeV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754640AbXISFeV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Sep 2007 01:34:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752042AbXISFeN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Sep 2007 01:34:13 -0400
Received: from smtp10.unit.tiscali.de ([213.205.33.46]:39909 "EHLO
	smtp10.unit.tiscali.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750756AbXISFeM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Sep 2007 01:34:12 -0400
X-Greylist: delayed 21298 seconds by postgrey-1.27 at vger.kernel.org; Wed, 19 Sep 2007 01:34:12 EDT
From: Michael Gerdau <mgerdau@tiscali.de>
To: linux-kernel@vger.kernel.org
Subject: 2.6.23-rc6-mm1 and acpi
Date: Tue, 18 Sep 2007 23:42:25 +0200
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1661553.fnMsPQTlUA";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200709182342.39905.mgerdau@tiscali.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart1661553.fnMsPQTlUA
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

Hi,

while trying to compile 2.6.23-rc6-mm1 I came across the following
build error:

mgd@seneca:/usr/src/linux-2.6.23-rc6-mm1> make modules
  CHK     include/linux/version.h
  CHK     include/linux/utsrelease.h
  CALL    scripts/checksyscalls.sh
<stdin>:1389:2: warning: #warning syscall revokeat not implemented
<stdin>:1393:2: warning: #warning syscall frevoke not implemented
  CC [M]  drivers/acpi/sbs.o
drivers/acpi/sbs.c: In function =E2=80=98acpi_battery_alarm_show=E2=80=99:
drivers/acpi/sbs.c:457: error: implicit declaration of function =E2=80=98ac=
pi_battery_get_alarm=E2=80=99
drivers/acpi/sbs.c: In function =E2=80=98acpi_battery_alarm_store=E2=80=99:
drivers/acpi/sbs.c:472: error: implicit declaration of function =E2=80=98ac=
pi_battery_set_alarm=E2=80=99
drivers/acpi/sbs.c: In function =E2=80=98acpi_battery_add=E2=80=99:
drivers/acpi/sbs.c:829: warning: ignoring return value of =E2=80=98device_c=
reate_file=E2=80=99, declared with attribute warn_unused_result
make[2]: *** [drivers/acpi/sbs.o] Fehler 1
make[1]: *** [drivers/acpi] Fehler 2
make: *** [drivers] Fehler 2

Not sure who to CC, which is why I send it to the list alone.

Best,
Michael
=2D-=20
 Vote against SPAM - see http://www.politik-digital.de/spam/
 Michael Gerdau       email: mgerdau@tiscali.de
 GPG-keys available on request or at public keyserver

--nextPart1661553.fnMsPQTlUA
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.5 (GNU/Linux)

iD8DBQBG8EZPUYYhyuxDQc4RAl4yAJ9UV3nK1I0oM+t9L56UbuWpi0ybSgCeOsoW
9SFNNZhr6H+aAYfEFHFdBCg=
=kKhl
-----END PGP SIGNATURE-----

--nextPart1661553.fnMsPQTlUA--
