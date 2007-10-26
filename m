Return-Path: <linux-kernel-owner+w=401wt.eu-S1762528AbXJZSP5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762528AbXJZSP5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2007 14:15:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756567AbXJZSPs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Oct 2007 14:15:48 -0400
Received: from mx40.mail.ru ([194.67.23.36]:50271 "EHLO mx40.mail.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753667AbXJZSPr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2007 14:15:47 -0400
From: Andrey Borzenkov <arvidjaar@mail.ru>
To: Alexey Starikovskiy <aystarik@gmail.com>
Subject: Re: [2.624-rc1 regression] lost battery information
Date: Fri, 26 Oct 2007 22:15:42 +0400
User-Agent: KMail/1.9.7
Cc: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
References: <200710262024.06012.arvidjaar@mail.ru> <200710262120.22536.arvidjaar@mail.ru> <47222DF3.3040208@gmail.com>
In-Reply-To: <47222DF3.3040208@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart7907813.P7lePVfKgB";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200710262215.42939.arvidjaar@mail.ru>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart7907813.P7lePVfKgB
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

On Friday 26 October 2007, Alexey Starikovskiy wrote:
> Andrey Borzenkov wrote:
> > On Friday 26 October 2007, Alexey Starikovskiy wrote:
> >> Andrey Borzenkov wrote:
> >>> I have lost battery in 2.6.24-rc1. Without CONFIG_ACPI_PROCFS I have
> >>> no /proc/acpi/battery and cannot test netlink interface because right
> >>> now there is no consumer of this.
> >>
> >> for /sysfs interface you need to enable power_supply driver.
> >> or you could apply this patch and power_supply will be selected by
> >> battery itself.
> >
> > I already have power_supply module, battery depends on it and it is
> > autloaded. But I fail to see where I can get battery info in /sys
>
> Intent was to put into /sysfs same information:
> aystarik@samsung:~/client_conf$ ls /sys/class/power_supply/BAT1/
> alarm  charge_full  charge_full_design  charge_now  current_now  device=20
> manufacturer  model_name  present  status  subsystem  technology  type=20
> uevent  voltage_min_design  voltage_now
>

is it in -rc1 or can you point me to the patch (I'd rather avoid having to=
=20
pull from different git trees). Thank you.

And what about ACPI_PROCFS case? It still needs attention I believe.

> aystarik@samsung:~/client_conf$ cat /sys/class/power_supply/BAT1/*
> 0
> 4172000
> 4300000
> 4172000
> 0
> cat: /sys/class/power_supply/BAT1/device: Is a directory
> Pacifi
> Bat1
> 1
> Full
> cat: /sys/class/power_supply/BAT1/subsystem: Is a directory
> Li-ion
> Battery
> PHYSDEVPATH=3D/devices/LNXSYSTM:00/device:00/PNP0C0A:00
> PHYSDEVBUS=3Dacpi
> PHYSDEVDRIVER=3Dbattery
> POWER_SUPPLY_NAME=3DBAT1
> POWER_SUPPLY_TYPE=3DBattery
> POWER_SUPPLY_STATUS=3DFull
> POWER_SUPPLY_PRESENT=3D1
> POWER_SUPPLY_TECHNOLOGY=3DLi-ion
> POWER_SUPPLY_VOLTAGE_MIN_DESIGN=3D14800000
> POWER_SUPPLY_VOLTAGE_NOW=3D16522000
> POWER_SUPPLY_CURRENT_NOW=3D0
> POWER_SUPPLY_CHARGE_FULL_DESIGN=3D4300000
> POWER_SUPPLY_CHARGE_FULL=3D4172000
> POWER_SUPPLY_CHARGE_NOW=3D4172000
> POWER_SUPPLY_MODEL_NAME=3DBat1
> POWER_SUPPLY_MANUFACTURER=3DPacifi
> 14800000
> 16522000
>
> aystarik@samsung:~/client_conf$ cat /proc/acpi/battery/BAT1/*
> alarm:                   unsupported
> present:                 yes
> design capacity:         4300 mAh
> last full capacity:      4172 mAh
> battery technology:      rechargeable
> design voltage:          14800 mV
> design capacity warning: 208 mAh
> design capacity low:     41 mAh
> capacity granularity 1:  41 mAh
> capacity granularity 2:  41 mAh
> model number:            Bat1
> serial number:           001
> battery type:            LION
> OEM info:                Pacifi
> present:                 yes
> capacity state:          ok
> charging state:          charged
> present rate:            0 mA
> remaining capacity:      4172 mAh
> present voltage:         16518 mV



--nextPart7907813.P7lePVfKgB
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)

iD8DBQBHIi7OR6LMutpd94wRAmW1AKDFRCErVY55k5tN7UhEcJHjP7j3JACgr7WD
JGIKNz+zytuvqtKMSGP3D9U=
=EJUP
-----END PGP SIGNATURE-----

--nextPart7907813.P7lePVfKgB--
