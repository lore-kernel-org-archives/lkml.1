Return-Path: <linux-kernel-owner+w=401wt.eu-S1755203AbYAXLVi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755203AbYAXLVi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2008 06:21:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752614AbYAXLVb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Jan 2008 06:21:31 -0500
Received: from static.88-198-5-81.clients.your-server.de ([88.198.5.81]:47420
	"EHLO static.88-198-5-81.clients.your-server.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752401AbYAXLVa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2008 06:21:30 -0500
Message-ID: <479874B2.5010208@linuxdingsda.de>
Date: Thu, 24 Jan 2008 12:21:22 +0100
From: Tobias Winter <tobias@linuxdingsda.de>
User-Agent: Mozilla-Thunderbird 2.0.0.9 (X11/20080109)
MIME-Version: 1.0
To: Roland Dreier <rdreier@cisco.com>
Cc: linux-kernel@vger.kernel.org,
       Stephen Hemminger <shemminger@linux-foundation.org>
Subject: Re: kernel bug report 2.6.24-rc8 on core2quad q6600 with debian unstable
 amd64
References: <4797D86B.3060202@linuxdingsda.de> <adaabmwowfz.fsf@cisco.com>
In-Reply-To: <adaabmwowfz.fsf@cisco.com>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA512

Stephen Hemminger wrote:
>> [2.] Full description of the problem/report:
>> I upgraded my system to fairly new hardware and find myself unable to
>> compile any kernel source and the system panics under high load e.g.
>> resyncing a RAID or building a kernel. Building kernel is 100% sure to
>> result in a kernel panic.
>
> Sounds like bad memory. Run memtest for at least 24hrs.
I think I'm going to just switch the memory modules. If the problem
persists maybe memtest will be able to shed some light on the problem.
Good thing, the weekend is coming.


>  > [8.6.] SCSI information (from /proc/scsi/scsi)
>  > Attached devices:
>  > Host: scsi0 Channel: 00 Id: 01 Lun: 00
>  >   Vendor: IBM-PCCO Model: DDRS-34560W   !# Rev: S97B
>  >   Type:   Direct-Access                    ANSI  SCSI revision: 02
>  > Host: scsi0 Channel: 00 Id: 05 Lun: 00
>  >   Vendor: NEC      Model: CD-ROM DRIVE:464 Rev: 1.14
>  >   Type:   CD-ROM                           ANSI  SCSI revision: 02
>  > Host: scsi1 Channel: 00 Id: 00 Lun: 00
>  >   Vendor: ATA      Model: Maxtor 6V250F0   Rev: VA11
>  >   Type:   Direct-Access                    ANSI  SCSI revision: 05
>  > Host: scsi2 Channel: 00 Id: 00 Lun: 00
>  >   Vendor: ATA      Model: Maxtor 6V250F0   Rev: VA11
>  >   Type:   Direct-Access                    ANSI  SCSI revision: 05
>  > Host: scsi3 Channel: 00 Id: 00 Lun: 00
>  >   Vendor: ATA      Model: Maxtor 6V250F0   Rev: VA11
>  >   Type:   Direct-Access                    ANSI  SCSI revision: 05
>  > Host: scsi4 Channel: 00 Id: 00 Lun: 00
>  >   Vendor: ATA      Model: Maxtor 6V250F0   Rev: VA11
>  >   Type:   Direct-Access                    ANSI  SCSI revision: 05
>  > Host: scsi5 Channel: 00 Id: 00 Lun: 00
>  >   Vendor: ATA      Model: Maxtor 6V250F0   Rev: VA11
>  >   Type:   Direct-Access                    ANSI  SCSI revision: 05
>  > Host: scsi6 Channel: 00 Id: 00 Lun: 00
>  >   Vendor: ATA      Model: Maxtor 6V250F0   Rev: VA11
>  >   Type:   Direct-Access                    ANSI  SCSI revision: 05
>  > Host: scsi7 Channel: 00 Id: 00 Lun: 00
>  >   Vendor: ATA      Model: Maxtor 6L250R0   Rev: BAJ4
>  >   Type:   Direct-Access                    ANSI  SCSI revision: 05
>  > Host: scsi7 Channel: 00 Id: 01 Lun: 00
>  >   Vendor: ATA      Model: Maxtor 6L250R0   Rev: BAH4
>  >   Type:   Direct-Access                    ANSI  SCSI revision: 05
>
> That is a lot of hard drives... my guess would be that your power
> supply is marginal, a cable/adapter card isn't seated perfectly
> somewhere, something is overheating, or something like that.
>
Hmm. Good thinking. But the system ran perfectly stable with a
Core2Duo E6600 and the same amount of hard drives. There are dedicated
power supplies with enough juice for the devices and for the mainboard
with the CPU and the usual PCI/PCIe cards.

I'll have a closer look at the whole hardware thing at the weekend.
Thanks for the fast responses.
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iD8DBQFHmHSxZhAcjSIb10ERCsH6AKCNwut8JZ494tqyq6/GyWZoP3H+1ACglpCk
xuRGbvfUzotk221yoI5h6uM=
=W/b+
-----END PGP SIGNATURE-----

