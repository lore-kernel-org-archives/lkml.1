Return-Path: <linux-kernel-owner+w=401wt.eu-S1757531AbZC3CqZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757531AbZC3CqZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Mar 2009 22:46:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756286AbZC3CqQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Mar 2009 22:46:16 -0400
Received: from mail-bw0-f169.google.com ([209.85.218.169]:57729 "EHLO
	mail-bw0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752218AbZC3CqP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Mar 2009 22:46:15 -0400
From: "Morten P.D. Stevens" <mstevens@win-professional.com>
To: "'Trenton Adams'" <trenton.d.adams@gmail.com>
Cc: "'Linux Kernel Mailing List'" <linux-kernel@vger.kernel.org>
References: <9b1675090903291904g7eca965eydb1aa3f852a1b91c@mail.gmail.com>
In-Reply-To: <9b1675090903291904g7eca965eydb1aa3f852a1b91c@mail.gmail.com>
Subject: RE: 2.6.29 on MacBook 2,1 fails to reboot
Date: Mon, 30 Mar 2009 04:46:10 +0200
Organization: win-professional.com
Message-ID: <000301c9b0e1$af531e40$0df95ac0$@com>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-Index: Acmw2/wPINsUIzeXSWW9krsls2NSGgABP+wA
Content-Language: de
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

> System information below.  If you need more info, let me know.

Please post your dmesg output.

-----Original Message-----
From: linux-kernel-owner@vger.kernel.org
[mailto:linux-kernel-owner@vger.kernel.org] On Behalf Of Trenton Adams
Sent: Monday, March 30, 2009 4:04 AM
To: Linux Kernel Mailing List
Subject: 2.6.29 on MacBook 2,1 fails to reboot

Hi Guys,

I am using v2.6.29 (x86_64 mode) on Linus' tree.

I get to run level 6, where all processes have been killed, and the
system is about to reboot, but it doesn't.  No apparent error messages
are printed out, it just hangs.

I do the skinny elephant dance, and everything is fine.  But, note
that when doing "Elephant", it says that there are no more processes
to kill.

System information below.  If you need more info, let me know.

tdamac ~ # uname -a
Linux tdamac 2.6.29 #3 SMP Sun Mar 29 19:07:55 MDT 2009 x86_64
Intel(R) Core(TM)2 CPU T7400 @ 2.16GHz GenuineIntel GNU/Linux

tdamac ~ # lspci
00:00.0 Host bridge: Intel Corporation Mobile 945GM/PM/GMS, 943/940GML
and 945GT Express Memory Controller Hub (rev 03)
00:02.0 VGA compatible controller: Intel Corporation Mobile 945GM/GMS,
943/940GML Express Integrated Graphics Controller (rev 03)
00:02.1 Display controller: Intel Corporation Mobile 945GM/GMS/GME,
943/940GML Express Integrated Graphics Controller (rev 03)
00:07.0 Performance counters: Intel Corporation Device 27a3 (rev 03)
00:1b.0 Audio device: Intel Corporation 82801G (ICH7 Family) High
Definition Audio Controller (rev 02)
00:1c.0 PCI bridge: Intel Corporation 82801G (ICH7 Family) PCI Express
Port 1 (rev 02)
00:1c.1 PCI bridge: Intel Corporation 82801G (ICH7 Family) PCI Express
Port 2 (rev 02)
00:1d.0 USB Controller: Intel Corporation 82801G (ICH7 Family) USB
UHCI Controller #1 (rev 02)
00:1d.1 USB Controller: Intel Corporation 82801G (ICH7 Family) USB
UHCI Controller #2 (rev 02)
00:1d.2 USB Controller: Intel Corporation 82801G (ICH7 Family) USB
UHCI Controller #3 (rev 02)
00:1d.3 USB Controller: Intel Corporation 82801G (ICH7 Family) USB
UHCI Controller #4 (rev 02)
00:1d.7 USB Controller: Intel Corporation 82801G (ICH7 Family) USB2
EHCI Controller (rev 02)
00:1e.0 PCI bridge: Intel Corporation 82801 Mobile PCI Bridge (rev e2)
00:1f.0 ISA bridge: Intel Corporation 82801GBM (ICH7-M) LPC Interface
Bridge (rev 02)
00:1f.1 IDE interface: Intel Corporation 82801G (ICH7 Family) IDE
Controller (rev 02)
00:1f.2 IDE interface: Intel Corporation 82801GBM/GHM (ICH7 Family)
SATA IDE Controller (rev 02)
00:1f.3 SMBus: Intel Corporation 82801G (ICH7 Family) SMBus Controller (rev
02)
01:00.0 Ethernet controller: Marvell Technology Group Ltd. 88E8053
PCI-E Gigabit Ethernet Controller (rev 22)
02:00.0 Network controller: Atheros Communications Inc. AR5418
802.11abgn Wireless PCI Express Adapter (rev 01)
03:03.0 FireWire (IEEE 1394): Agere Systems FW323 (rev 61)

tdamac ~ # cat /proc/cpuinfo
processor       : 0
vendor_id       : GenuineIntel
cpu family      : 6
model           : 15
model name      : Intel(R) Core(TM)2 CPU         T7400  @ 2.16GHz
stepping        : 6
cpu MHz         : 1000.000
cache size      : 4096 KB
physical id     : 0
siblings        : 2
core id         : 0
cpu cores       : 2
apicid          : 0
initial apicid  : 0
fpu             : yes
fpu_exception   : yes
cpuid level     : 10
wp              : yes
flags           : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge
mca cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe
syscall nx lm constant_tsc arch_perfmon pebs bts rep_good pni dtes64
monitor ds_cpl vmx est tm2 ssse3 cx16 xtpr pdcm lahf_lm tpr_shadow
bogomips        : 4322.42
clflush size    : 64
cache_alignment : 64
address sizes   : 36 bits physical, 48 bits virtual
power management:

processor       : 1
vendor_id       : GenuineIntel
cpu family      : 6
model           : 15
model name      : Intel(R) Core(TM)2 CPU         T7400  @ 2.16GHz
stepping        : 6
cpu MHz         : 1000.000
cache size      : 4096 KB
physical id     : 0
siblings        : 2
core id         : 1
cpu cores       : 2
apicid          : 1
initial apicid  : 1
fpu             : yes
fpu_exception   : yes
cpuid level     : 10
wp              : yes
flags           : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge
mca cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe
syscall nx lm constant_tsc arch_perfmon pebs bts rep_good pni dtes64
monitor ds_cpl vmx est tm2 ssse3 cx16 xtpr pdcm lahf_lm tpr_shadow
bogomips        : 4322.44
clflush size    : 64
cache_alignment : 64
address sizes   : 36 bits physical, 48 bits virtual
power management:

tdamac ~ # lsmod
Module                  Size  Used by
i915                  148744  2
drm                   149184  3 i915
snd_pcm_oss            37728  0
snd_mixer_oss          14576  1 snd_pcm_oss
snd_seq_oss            29056  0
snd_seq_midi_event      6608  1 snd_seq_oss
snd_seq                48416  4 snd_seq_oss,snd_seq_midi_event
snd_seq_device          6564  2 snd_seq_oss,snd_seq
ipt_MASQUERADE          3024  1
iptable_nat             5392  1
nf_nat                 18084  2 ipt_MASQUERADE,iptable_nat
pl2303                 17332  0
usbserial              30480  1 pl2303
hermes                  6800  0
fuse                   53424  0
cifs                  222728  2
snd_hda_codec_idt      61392  1
snd_hda_intel          25096  3
snd_hda_codec          52368  2 snd_hda_codec_idt,snd_hda_intel
snd_pcm                71576  3 snd_pcm_oss,snd_hda_intel,snd_hda_codec
snd_timer              19808  2 snd_seq,snd_pcm
snd                    55272  16
snd_pcm_oss,snd_mixer_oss,snd_seq_oss,snd_seq,snd_seq_device,snd_hda_codec_i
dt,snd_hda_intel,snd_hda_codec,snd_pcm,snd_timer
snd_page_alloc          8608  2 snd_hda_intel,snd_pcm
appletouch             10676  0
pcspkr                  2736  0
applesmc               29972  0
hwmon                   2696  1 applesmc
led_class               3672  1 applesmc
input_polldev           3808  1 applesmc
scsi_wait_scan          1360  0

Thanks.
--
To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
Please read the FAQ at  http://www.tux.org/lkml/

