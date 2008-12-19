Return-Path: <linux-kernel-owner+w=401wt.eu-S1754290AbYLSOYX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754290AbYLSOYX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Dec 2008 09:24:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753148AbYLSOYG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Dec 2008 09:24:06 -0500
Received: from Powered.by.Root24.eu ([81.169.180.23]:36139 "EHLO Root24.de"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752630AbYLSOYE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Dec 2008 09:24:04 -0500
X-Greylist: delayed 686 seconds by postgrey-1.27 at vger.kernel.org; Fri, 19 Dec 2008 09:24:04 EST
Message-ID: <494BABB0.8050309@ionic.de>
Date: Fri, 19 Dec 2008 15:12:00 +0100
From: Mihai Moldovan <ionic@ionic.de>
User-Agent: Thunderbird 2.0.0.17 (X11/20081005)
MIME-Version: 1.0
To: LKML <linux-kernel@vger.kernel.org>
Subject: Multiple minor glitches with 2.6.27.* and linux-NEXT
X-Enigmail-Version: 0.95.7
Content-Type: multipart/signed; micalg=pgp-sha512;
 protocol="application/pgp-signature";
 boundary="------------enigC1EF3B79BA9D66C8C466CB42"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigC1EF3B79BA9D66C8C466CB42
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Good morning/afternoon/evening, chose whatever does suit your timezone he=
re,

I am asking for some help with my new box (read new as in really new,
the hardware is quite a couple of month old, especially the board.)

[ GENERAL INFORMATION ]

Mainboard: Intel=C2=AE=E2=84=A2 Q45CB
CPU: Intel=C2=AE=E2=84=A2 Q9550

[    0.000000] BIOS-provided physical RAM map:
[    0.000000]  BIOS-e820: 0000000000000000 - 000000000009e800 (usable)
[    0.000000]  BIOS-e820: 000000000009e800 - 00000000000a0000 (reserved)=

[    0.000000]  BIOS-e820: 00000000000e0000 - 0000000000100000 (reserved)=

[    0.000000]  BIOS-e820: 0000000000100000 - 00000000bd3ce000 (usable)
[    0.000000]  BIOS-e820: 00000000bd3ce000 - 00000000bd410000 (ACPI NVS)=

[    0.000000]  BIOS-e820: 00000000bd410000 - 00000000bd52e000 (reserved)=

[    0.000000]  BIOS-e820: 00000000bd52e000 - 00000000bd542000 (ACPI NVS)=

[    0.000000]  BIOS-e820: 00000000bd542000 - 00000000bd642000 (reserved)=

[    0.000000]  BIOS-e820: 00000000bd642000 - 00000000bd643000 (ACPI NVS)=

[    0.000000]  BIOS-e820: 00000000bd643000 - 00000000bd648000 (reserved)=

[    0.000000]  BIOS-e820: 00000000bd648000 - 00000000bd650000 (ACPI data=
)
[    0.000000]  BIOS-e820: 00000000bd650000 - 00000000bd66b000 (ACPI NVS)=

[    0.000000]  BIOS-e820: 00000000bd66b000 - 00000000bd68a000 (reserved)=

[    0.000000]  BIOS-e820: 00000000bd68a000 - 00000000bd690000 (ACPI NVS)=

[    0.000000]  BIOS-e820: 00000000bd690000 - 00000000bd800000 (usable)
[    0.000000]  BIOS-e820: 00000000bd800000 - 00000000bdb00000 (reserved)=

[    0.000000]  BIOS-e820: 00000000bdc00000 - 00000000c0000000 (reserved)=

[    0.000000]  BIOS-e820: 00000000fed1c000 - 00000000fed20000 (reserved)=

[    0.000000]  BIOS-e820: 00000000ff000000 - 0000000100000000 (reserved)=

[    0.000000]  BIOS-e820: 0000000100000000 - 000000013c000000 (usable)



[----------------------]

First of all, will the changes to e1000e be integrated in Linux 2.6.28
as soon as it is released? 2.6.27 does not detect my onboard NIC, whilst
Linux-NEXT does. Some basic information about this:



[   25.662299] PM: Adding info for No Bus:eth0
[   25.662407] 0000:00:19.0: eth0: (PCI Express:2.5GB/s:Width x1)
00:1c:c0:7e:53:fe
[   25.662409] 0000:00:19.0: eth0: Intel(R) PRO/1000 Network Connection
[   25.662449] 0000:00:19.0: eth0: MAC: 7, PHY: 8, PBA No: ffffff-0ff
[   25.662497] e1000e 0000:03:00.0: PCI INT A -> GSI 16 (level, low) ->
IRQ 16
[   25.662507] e1000e 0000:03:00.0: setting latency timer to 64
[   25.662681] e1000e 0000:03:00.0: irq 373 for MSI/MSI-X

PCI-ID: 8086:10de

[----------------------]

Secondly, the In-Kernel ath9k driver is not working correctly for me,
just again, it displays a nasty message and only detects one of my cards.=


[   26.297199] WARNING: at net/mac80211/rate.c:41
ieee80211_rate_control_register+0x9c/0xe1 [mac80211]()
[   26.297200] Modules linked in: ath9k(+) mac80211 e1000e cfg80211
[   26.297206] Pid: 3171, comm: modprobe Not tainted
2.6.28-rc9-squashFS3.3-OSS4.1 #1
[   26.297207] Call Trace:
[   26.297214]  [<ffffffff80256dad>] warn_on_slowpath+0x58/0x75
[   26.297226]  [<ffffffffa0079821>] ? kzalloc+0xf/0x11 [ath9k]
[   26.297236]  [<ffffffffa006d87f>] ? ath9k_hw_setbssidmask+0x4f/0x59
[ath9k]
[   26.297246]  [<ffffffffa007be96>] ? ath_init+0x62f/0x719 [ath9k]
[   26.297260]  [<ffffffffa00373e8>]
ieee80211_rate_control_register+0x9c/0xe1 [mac80211]
[   26.297271]  [<ffffffffa0079f24>] ath_rate_control_register+0x10/0x12
[ath9k]
[   26.297281]  [<ffffffffa0073f83>] ath_pci_probe+0x2fe/0x6e1 [ath9k]
[   26.297285]  [<ffffffff804d2fef>] pci_device_probe+0x4c/0x74
[   26.297289]  [<ffffffff8056d062>] driver_probe_device+0xd9/0x169
[   26.297292]  [<ffffffff8056d154>] __driver_attach+0x62/0x8c
[   26.297295]  [<ffffffff8056d0f2>] ? __driver_attach+0x0/0x8c
[   26.297298]  [<ffffffff8056d0f2>] ? __driver_attach+0x0/0x8c
[   26.297300]  [<ffffffff8056c8f0>] bus_for_each_dev+0x4a/0x79
[   26.297303]  [<ffffffff8056ce93>] driver_attach+0x1c/0x1e
[   26.297306]  [<ffffffff8056c1f2>] bus_add_driver+0xb5/0x207
[   26.297309]  [<ffffffff8056d3e3>] driver_register+0x93/0x10a
[   26.297316]  [<ffffffffa009f000>] ? init_ath_pci+0x0/0x63 [ath9k]
[   26.297319]  [<ffffffff804d3263>] __pci_register_driver+0x63/0x9c
[   26.297326]  [<ffffffffa009f000>] ? init_ath_pci+0x0/0x63 [ath9k]
[   26.297333]  [<ffffffffa009f03a>] init_ath_pci+0x3a/0x63 [ath9k]
[   26.297335]  [<ffffffff8020905e>] _stext+0x5e/0x148
[   26.297339]  [<ffffffff8023bdd2>] ? __send_IPI_dest_field+0x5c/0x64
[   26.297343]  [<ffffffff802349c2>] ? native_smp_send_reschedule+0x3b/0x=
3d
[   26.297346]  [<ffffffff80247ec4>] ? smp_send_reschedule+0xa/0xc
[   26.297349]  [<ffffffff80249857>] ? resched_task+0x7b/0x7f
[   26.297352]  [<ffffffff8024a4a5>] ? task_rq_unlock+0xc/0xe
[   26.297355]  [<ffffffff8024ed1d>] ? try_to_wake_up+0x232/0x244
[   26.297358]  [<ffffffff802794e3>] sys_init_module+0x9f/0x1b0
[   26.297362]  [<ffffffff8022408b>] system_call_fastpath+0x16/0x1b
[   26.297364] ---[ end trace 1d57ef7783b1ab9c ]---
[   26.297366] ath_attach: Unable to register rate control algorithm:-114=

[   26.297379] ath9k 0000:04:00.0: PCI INT A disabled

I'd like to report that the ath9k driver in compat-wireless (yesterday's
daily snapshot) is working fine for both cards (PCI-IDs 168c:0024 and
168c:0023.)

Could this be pushed into Mainline, too?

[----------------------]

Next, I see those error messages in my Kernel log about USB/EHCI:


[    8.544011] pci 0000:00:1a.7: EHCI: BIOS handoff failed (BIOS bug?)
01010001
[   16.544011] pci 0000:00:1d.7: EHCI: BIOS handoff failed (BIOS bug?)
01010001

lspci output regarding USB:

00:1a.7 USB Controller [0c03]: Intel Corporation Device [8086:3a6c] (rev =
02)
00:1d.7 USB Controller [0c03]: Intel Corporation Device [8086:3a6a] (rev =
02)

USB seems to work fine, though I would like to get rid of the messages
because the system seems to hang some seconds due to this on bootup.
Disabling USB legacy is in-BIOS is no alternative, because the box has
no PS/2 ports, guess what would happen. ;)

I am aware this might be no Kernel bug at all, but I would like to start
with this on this list, though. If you find that I am in the wrong here
for this problem, please CC/FWD me to the Intel guys where I can report
this issue and let them - hopefully - have the BIOS fixed soon.

I will not include my DSDT in this post, feel free to request it when
needed. :)

[----------------------]


Alright, that was my "complaining" part, let's get to something more
interesting now. :)

Since my CPU got four CPU cores, I am playing around with the thought of
disabling some cores based on the current time (that is, via cron.)
I know that Linux greatly supports CPU hotplugging, and it's working
quite fine, too.
Now, disabling specific CPU/cores using the CPU hotplug support is only
"logical", the cores will actually stay active the whole time, even
after disabling them. In the README file, there is no real explanation
of how to disable CPU/cores also *physically*, just some general
statements that this would require deep ACPI-hacking.

Might anyone here be so kind to explain me whether disabling specific
Cores of an Intel=C2=AE=E2=84=A2 Core2Quad CPU completely ...

  - is possible? I am not quite sure whether this would work at all.
  - would indeed safe power/lower the power consumption? Logically
disabling cores does safe hardly any power. :)


Thank you for all the answers in advance,


Mihai Moldovan



--------------enigC1EF3B79BA9D66C8C466CB42
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.9 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iQIcBAEBCgAGBQJJS6vIAAoJEB/WLtluJTqHc+kP/j1X72Jn9s4M/bTZXwdiNZNm
ur6vaIljcnpYbGjvuaRvzebwh/lCXkTF0NyhPECCPk2s4nA0ev3eNs1iZgKnChGY
Rhgm8OF2Ib3DaPlEm2n5x4VCj6Y05Lo4DD9kwc831SEBJWTDuOGLAX50V5wG2lNC
GnjrfvJC/o/RZpqLta2l7JPB1ke6+QzfTB29baWOrUnV5iXW/MByxWt95rp2vcR9
7T45lsEkBqvF6bC5YgHKi/daghMNroEfIvjIilZ1o/zTLUZoFAmr5jlXHHaxXRBX
tx5xG1rYPuHPqLaF17M9gb/nVZcvbJKK5L1q+R6CszaxGAh9oTeq4ILFkj2FMdzb
ARXcpyz1CgtqtviPZF312GJWcE2kdBxGcKYfTmpUF9CEQawifkRMoMCzNnoBrZ3X
RrD9z3B+4aoNXfTQVNxBIj580LIqkeSdo3QnF8WRMub+1uFO8R0KVjAY9InYaBEh
K3Tn6+NDcGGvDgJ9AfT18WOseYE1ARCe2pQbquznox4IVSZHwlzgYSIGtef9a1Jw
Fsy+KUZETJKb2CYh+MI8rNFVlQ9IbXXQQkqM2XyyNuGFCnrIeqRNqB/t2UnckOAu
9kr3XSmRdhhBXCC4YSa4oXyP8uHCfm9lSYVafbfoNOMz5TOI6RKq+ryH7I3I+5UK
GlM1nNCR1V4zYNqqUfxK
=f0le
-----END PGP SIGNATURE-----

--------------enigC1EF3B79BA9D66C8C466CB42--
