Return-Path: <linux-kernel-owner+w=401wt.eu-S1758112AbXFMWkX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758112AbXFMWkX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jun 2007 18:40:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755467AbXFMWkL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Jun 2007 18:40:11 -0400
Received: from ug-out-1314.google.com ([66.249.92.169]:5374 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753398AbXFMWkI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jun 2007 18:40:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:mime-version:content-type;
        b=rudedQjUVasIh80JZbD+brd7LFCliuc1hgEiQrhl6OVtPPQb8D+Rywix4VXe6iHpRPdiwmHOMUDNzS4SxB2FX/1S2fXlnr1O4Qj3M5qwehBwELZqzae+L7GJThYsvlE4Y6ZroLvn3eCEXdwT5TYgp1pqINpM6t1RVzVeXYe4j5E=
Message-ID: <ac0773110706131540r4c201539n74528d45a24a2156@mail.gmail.com>
Date: Thu, 14 Jun 2007 00:40:06 +0200
From: "Sav vas" <vicedar@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: Possible kernel bug: Time increases gradually in "date" command
MIME-Version: 1.0
Content-Type: multipart/mixed; 
	boundary="----=_Part_39064_23058807.1181774406728"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

------=_Part_39064_23058807.1181774406728
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Hello, this is my first time I've ever posted on this list. If you
need further info, do not hesitate, as I would love to get this matter
solved!

########
The problem:
Time increases faster than normal (which in turn makes timestamps in
logfiles go crazy).
I've been using ubuntu linux since dapper drake (6.06), ubuntu linux
edgy (6.10) and now ubuntu linux feisty fawn (7.04). I have noticed
that upon using ubuntu linux feisty fawn, the time in "date" command
shifts (increases gradually and faster than normal) while the pc is
turned on.
I use gnome desktop and in the time panel of gnome it shows the date
normally after a "refresh" of time using the command: sudo ntpdate
time.nist.gov ntp.nasa.gov
Yet after some time (when ntpd is disabled, even when it is enabled
sometimes) the problem reappears after a while, the time in "date"
command and in gnome time panel after some hours is way ahead than
normal.

I did not and do not have this problem in windows xp nor in earlier
ubuntu versions (I have tried a format of the root partition,
installed an earlier version of ubuntu linux - edgy 6.10 - and the
time was kept almost perfect! Then reinstalled ubuntu feisty 7.04 and
the time problem/bug reappeared)

I assume something changed in ubuntu linux feisty faw 7.04 causes this
bug to appear, maybe motherboard related or something else.

The full story of the possible bug is here as well:
https://bugs.launchpad.net/ubuntu/+bug/104091

I have attached a clock.log.tar.gz, which contains a clock.log file.
clock.log was produced by this: hwclock && date
Example of the format is:
hwclock: Wed 13 Jun 2007 06:45:55 PM CEST  -0.093260 seconds
date: Wed Jun 13 18:30:01 CEST 2007

I used crontab to log the output of hwclock && date every 5 minutes,
giving me the freedom to further analyse it and prove my theory.
Notice how the time in the output of date command increases faster
almost every time.


########
Specifications (using sysinfo):
SYSTEM INFORMATION
	Running Ubuntu Linux, the 4.0 release.
	GNOME: 2.18.1 (Ubuntu 2007-04-10)
	Kernel version: 2.6.20-16-generic (#2 SMP Wed May 23 01:46:23 UTC 2007)
                  (Version: 2.6.20-16.29)
	GCC: 4.1.2 (i486-linux-gnu)
	Xorg: 7.2.0 (04 April 2007)
	Hostname: ubuntu
	Uptime: 3 days 2 h 51 min

CPU INFORMATION
	AuthenticAMD, AMD Sempron(tm)   2500+
	Number of CPUs: 1
	CPU clock currently at 1750.066 MHz with 256 KB cache
	Numbering: family(6) model(8) stepping(1)
	Bogomips: 3502.87
	Flags: fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov
pat pse36 mmx fxsr sse syscall mp mmxext 3dnowext 3dnow up ts

MEMORY INFORMATION
	Total memory: 503 MB
	Total swap: 996 MB

STORAGE INFORMATION
	Primary Master /dev/hda - disk
		Model: Maxtor 6L080L0
		Capacity: 80 GB
		Cache: 2.048 MB
	Primary Master /dev/hdb - cdrom
		Model: PIONEER DVD-RW DVR-111D
		Capacity: no media
	SCSI device -  scsi1
		Vendor:  ATA
		Model:  WDC WD800JD-00MS

HARDWARE INFORMATION
MOTHERBOARD
	Host bridge
		nVidia Corporation nForce2 AGP (different version?) (rev c1)
	PCI bridge(s)
		nVidia Corporation MCP2A PCI Bridge (rev a3) (prog-if 00 [Normal decode])
		nVidia Corporation nForce2 AGP (rev c1) (prog-if 00 [Normal decode])
	USB controller(s)
		nVidia Corporation MCP2A USB Controller (rev a1) (prog-if 10 [OHCI])
		nVidia Corporation MCP2A USB Controller (rev a1) (prog-if 10 [OHCI])
		nVidia Corporation MCP2A USB Controller (rev a2) (prog-if 20 [EHCI])
	ISA bridge
		nVidia Corporation MCP2A ISA bridge (rev a3)
		Subsystem: Micro-Star International Co., Ltd. Unknown device 5700
	IDE interface
		nVidia Corporation nForce2 Serial ATA Controller (rev a3) (prog-if
85 [Master SecO PriO])
		Subsystem: Micro-Star International Co., Ltd. Unknown device 5700

GRAPHIC CARD
	VGA controller
		nVidia Corporation NV43 [GeForce 6600/GeForce 6600 GT] (rev a2)
(prog-if 00 [VGA])
		Subsystem: nVidia Corporation Unknown device 027d

SOUND CARD
	Multimedia controller
		nVidia Corporation MCP2S AC'97 Audio Controller (rev a1)
		Subsystem: Micro-Star International Co., Ltd. Unknown device 0080

NETWORK

NVIDIA GRAPHIC CARD INFORMATION
	Model name: GeForce 6600 GT
	Card Type: AGP 8x
	Video RAM: 128 MB
	GPU Frequency: 300 MHz
	Driver version: NVIDIA UNIX x86 Kernel Module  1.0-9755  Mon Feb 26
23:21:15 PST 2007

------=_Part_39064_23058807.1181774406728
Content-Type: application/x-gzip; name=clock.log.tar.gz
Content-Transfer-Encoding: base64
X-Attachment-Id: f_f2wdrh11
Content-Disposition: attachment; filename="clock.log.tar.gz"

H4sICOdwcEYAAy5mci4xNjYyNi4wLmNsb2NrLmxvZy50YXIA7ZjNihRZEIVr7VPkC4zEz/3N7eBm
YGBAwbW0rQvFhu7x/T33CmJG3jBmI4OSsammuvKryBsn4kTW3ceHuw/PPz68v/28IERJabxyzfT9
6/hThOjGVDRRJdVym2/pbaOfmNO3+Pz075vHbbu9e3h8f//ofy76/y8ar+/fbqzbX58/bShD3ajs
Ke85b//8vf354uWrbfuDnlNXKbQ93d89fHr79GxcMy7Addx2pZ3462cH4dmCmGnP5UDsqXTNHjHv
JAEROaYDsZEI3loTEwXEuhPhxg/E2ouW7hGjHEHMux7vOksq7OWY4xyZcDZHYiuCL3GIOagMiPlE
LOjCdWX6OKQoR0GOyRBTTetz7OOQQiJy1CMRyKQOkSM91iFZS8QxOufYxyFFOUKyKkei1s4eUeIc
IVlLLLUxe8Q4R0hW2Zxjz7hqTdS41pCskiGykJejxnqEZC0xdUrrnulxX7chWemG2Ao1jxjl2IZk
T8SexFN42NdtSFaaOUdiZ/b02dcRETlWQ6w9L/U4xBjpsQ3JnoiYPsvKDGKcIyQrxaonk5dj2NfT
ik7EUspS4YMY5wjJipmPWSFxhyhxrSFZsfORaln2zCDGeoRkT0RJeTkfx3SOc4Rk5TQfWbwcw76e
VmSJmZsuFQ5i2NfTikQsUXv1iFGtpxWJnY8sLjFHepxWZImFqXkKD/t6WpHYiSvVIXLc19OKuFti
ciYFz76OiPlELGOhd4gc1xqSZTsfq7NTDGKcIyR7IqIP1wrnuK+nFbGZj0WpucS41pAsF6uewsvd
DMRwD59WdCIq5OMR4xwhWbbzEXvPeuLy7Osf5cjTiixRJVdPj1Ff87QiNvMxSVvvPSBGfs3Tivg4
zVKv4nghh3s4TytiOx+TOvNRwj2cpxXxcT4mxghf11rCvuZpRZZYuDuuIGFf81crOk4KoSzZJca1
1rTnI5EZVrj2awn38EEcbXPMsfTqqEdCvwYxpT0dXQGPcCJrhUvo14PY7WYvXP0cI78GMSfrriiL
JO8c/0Nf524VLrhpdolRrWFFaSdDFOzha7+W0K8HsdlfFSRjAfByDPsaVqT2VwWMiVTWOWrc1yA2
+8SOu+7kEuMc8SmzNUuS3DxitIcPYrNeiAlOfT0fNe5rWBHuxBAVT0jrymjc1yDiYbOZHPEwvJ64
Gvc1rAiqNdMsN3IrE/Y1iBXjx/Q1UV/3tcZ9DSsS+3wtJTN5lQn7GsRqnz56L9LWW4rOvk7fEf/v
3z+vuOKKK6644oorrrjiiiuuuOKKK373+AKsGCnNACgAAA==
------=_Part_39064_23058807.1181774406728--
