Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754652Ab0CIK1Z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Mar 2010 05:27:25 -0500
Received: from mail-fx0-f213.google.com ([209.85.220.213]:58207 "EHLO
	mail-fx0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754389Ab0CIK1U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Mar 2010 05:27:20 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=gXPfqZB0KKP2RNfB1w1gcq7G3KIIJiykqOx9Tnx/AKA76/yJP9NaY9CxDN3ZsE1PgF
         KMGIY9g8gKOWuih9oiDGKsPr6PnNC3jGMeRgQGIgAGIsiCoTc4FCnBJqwe2uPR/YjUy/
         H2bg0PHcwvrIDK6hA7YeK/PgR1ZYJqkPAAfZs=
Date: Tue, 9 Mar 2010 12:27:54 +0200
From: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
To: linux-acpi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Lin Ming <ming.m.lin@intel.com>,
       Len Brown <lenb@kernel.org>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: BUG: key f70f4b50 not in .data
Message-ID: <20100309102754.GA3316@swordfish.minsk.epam.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="M9NhX3UHpAaciwkO"
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--M9NhX3UHpAaciwkO
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hello,
x86, ASUS f3jc. 2.6.34-rc1.

> dmesg

[    0.921368] ACPI: SSDT 7ffb91b0 00D24 (v01    AMI   CPU1PM 00000001 INTL=
 02002026)
[    0.928266] Marking TSC unstable due to TSC halts in idle
[    0.929094] Switching to clocksource hpet
[    0.930444] ACPI Warning: Incorrect checksum in table [SSDT] - 54, shoul=
d be 97 (20100121/tbutils-314)
[    0.930500] ACPI: SSDT 7ffb9ee0 00D24 (v01    AMI   CPU2PM 00000001 INTL=
 02002026)
[    0.952515] BUG: key f70f4b50 not in .data!
[    0.952537] ------------[ cut here ]------------
[    0.952564] WARNING: at kernel/lockdep.c:2706 lockdep_init_map+0xc3/0xf3=
()
[    0.952589] Hardware name: F3JC               =20
[    0.952608] Modules linked in:
[    0.952633] Pid: 1, comm: swapper Not tainted 2.6.34-rc1-dbg #38
[    0.953245] Call Trace:
[    0.953888]  [<c102e663>] warn_slowpath_common+0x65/0x7c
[    0.954555]  [<c104e13c>] ? lockdep_init_map+0xc3/0xf3
[    0.955215]  [<c102e687>] warn_slowpath_null+0xd/0x10
[    0.955897]  [<c104e13c>] lockdep_init_map+0xc3/0xf3
[    0.956594]  [<c10e26df>] sysfs_add_file_mode+0x4c/0x7e
[    0.957305]  [<c10e271f>] sysfs_add_file+0xe/0x13
[    0.958036]  [<c10e2788>] sysfs_create_file+0x20/0x22
[    0.958760]  [<c12046b9>] device_create_file+0x13/0x15
[    0.959499]  [<c1242677>] thermal_zone_device_register+0x32e/0x53e
[    0.960264]  [<c11dc083>] acpi_thermal_add+0x1a2/0x3c4
[    0.961051]  [<c10e36bd>] ? sysfs_do_create_link+0xc5/0xec
[    0.961839]  [<c11b279f>] acpi_device_probe+0x3a/0x142
[    0.962633]  [<c12064d1>] driver_probe_device+0x87/0x107
[    0.963445]  [<c120658d>] __driver_attach+0x3c/0x54
[    0.964277]  [<c1205cd5>] bus_for_each_dev+0x3d/0x67
[    0.965113]  [<c120639a>] driver_attach+0x14/0x16
[    0.965953]  [<c1206551>] ? __driver_attach+0x0/0x54
[    0.966817]  [<c120608c>] bus_add_driver+0x92/0x1c6
[    0.967687]  [<c149bac5>] ? acpi_thermal_init+0x0/0x6f
[    0.968532]  [<c12067bf>] driver_register+0x79/0xe0
[    0.969378]  [<c149bac5>] ? acpi_thermal_init+0x0/0x6f
[    0.970220]  [<c149bac5>] ? acpi_thermal_init+0x0/0x6f
[    0.971062]  [<c11b3178>] acpi_bus_register_driver+0x3a/0x3c
[    0.971887]  [<c149bb15>] acpi_thermal_init+0x50/0x6f
[    0.972709]  [<c1001139>] do_one_initcall+0x4c/0x136
[    0.973533]  [<c147c35b>] kernel_init+0x128/0x1a9
[    0.974367]  [<c147c233>] ? kernel_init+0x0/0x1a9
[    0.975179]  [<c1002e42>] kernel_thread_helper+0x6/0x1a
[    0.975991] ---[ end trace a22d306b065d4a66 ]---
[    0.976803] BUG: key f70f4b80 not in .data!
[    0.977640] BUG: key f70c1048 not in .data!
[    0.978892] thermal LNXTHERM:01: registered as thermal_zone0
[    0.979695] ACPI: Thermal Zone [THRM] (68 C)


	Sergey
--M9NhX3UHpAaciwkO
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iJsEAQECAAYFAkuWIqoACgkQfKHnntdSXjRNOwP2MmN6Dv/+0YzfVNabM/PaF8+L
8iWysa0K736ZQHy3eL3AoDpZFqDRZTnOSCTWY1b2GW4BqIf5QX4XEgyo+h51vU1i
8Z2A/yrCH3UTGJ9ma07PTQG0qq/n09k6eCFm51HudNskcTc9/JFGtEAHzRT0Z/s3
7jyhhR5oHM0rzPNg+g==
=gyLn
-----END PGP SIGNATURE-----

--M9NhX3UHpAaciwkO--
