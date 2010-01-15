Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932211Ab0AOMFL (ORCPT <rfc822;list-kernel77@spinics.net>);
	Fri, 15 Jan 2010 07:05:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757283Ab0AOMFJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Jan 2010 07:05:09 -0500
Received: from mail-ew0-f209.google.com ([209.85.219.209]:59224 "EHLO
	mail-ew0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757383Ab0AOMFH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jan 2010 07:05:07 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:subject
         :content-type;
        b=UA8pH0w+tkGhZ4FaxzgSsZVXz6otrzppUD3DG/OBJB8j/kNURbyVC5pX8m8K0kBrAP
         kZTeu0NlYzp5NRUOy6E9vW8fA7wIM6Nb+ZxX0j/8w1Ko4sa+k0qFDY+DTA8fuoOVJdTu
         NKwEb74qSFtscX8Yblokf74VHf1MZX37JI9B8=
Message-ID: <4B5059EB.6010006@googlemail.com>
Date: Fri, 15 Jan 2010 13:04:59 +0100
From: olsen <sesselastronaut@googlemail.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: 2.6.31-9-rt kernel EXT4-fs error
Content-Type: multipart/mixed;
 boundary="------------010909070805000301010305"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------010909070805000301010305
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Hi
i've serious problems with my 2.6.31-9-rt kernel and ext4 filesystem
dmesg:
[27216.779223] EXT4-fs error (device sda3): ext4_add_entry: bad entry in 
directory #859924: directory entry across blocks - offset=0, 
inode=3633236108, rec_len=180364, name_len=142
[27216.779231] Aborting journal on device sda3:8.
[27216.779448] EXT4-fs (sda3): Remounting filesystem read-only
[27216.780388] EXT4-fs error (device sda3) in ext4_delete_inode: Journal 
has aborted
[27216.780393] EXT4-fs error (device sda3) in ext4_create: IO failure

lshw is attached
please give me a shout if anything else is needed!
greets
olsen


-- 
ETs DNA will not be televised

--------------010909070805000301010305
Content-Type: text/plain;
 name="lshw.txt"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline;
 filename="lshw.txt"

aldebaran
    description: Computer
    product: MacBookPro4,1
    vendor: Apple Inc.
    version: 1.0
    serial: W883318LYJY
    width: 32 bits
    capabilities: smbios-2.4 dmi-2.4
    configuration: boot=3Dnormal uuid=3D26A96EAC-CD73-7A49-8B7C-2DA8F466D=
971
  *-core
       description: Motherboard
       product: Mac-F42C89C8
       vendor: Apple Inc.
       physical id: 0
       version: PVT
       serial: 1
       slot: Part Component
     *-cpu:0
          description: CPU
          product: Intel(R) Core(TM)2 Duo CPU     T9300  @ 2.50GHz
          vendor: Intel Corp.
          physical id: 0
          bus info: cpu@0
          version: 6.7.6
          serial: 0001-0676-0000-0000-0000-0000
          slot: U2E1
          size: 800MHz
          capacity: 2500MHz
          width: 64 bits
          clock: 200MHz
          capabilities: fpu fpu_exception wp vme de pse tsc msr pae mce c=
x8 apic sep mtrr pge mca cmov pat pse36 clflush dts acpi mmx fxsr sse sse=
2 ss ht tm pbe nx x86-64 constant_tsc arch_perfmon pebs bts pni dtes64 mo=
nitor ds_cpl vmx est tm2 ssse3 cx16 xtpr pdcm sse4_1 lahf_lm tpr_shadow v=
nmi flexpriority cpufreq
          configuration: id=3D0
        *-cache
             description: L1 cache
             physical id: 2
             slot: Unknown
             size: 32KiB
             capacity: 32KiB
             capabilities: asynchronous internal write-back data
        *-logicalcpu:0
             description: Logical CPU
             physical id: 0.1
             width: 64 bits
             capabilities: logical
        *-logicalcpu:1
             description: Logical CPU
             physical id: 0.2
             width: 64 bits
             capabilities: logical
     *-cache:0
          description: L1 cache
          physical id: 1
          slot: Unknown
          size: 32KiB
          capacity: 32KiB
          capabilities: asynchronous internal write-back instruction
     *-cpu:1
          description: CPU
          vendor: Intel(R) Corporation
          physical id: 3
          bus info: cpu@1
          version: 6.7.6
          serial: 0001-0676-0000-0000-0000-0000
          slot: U2E1
          size: 800MHz
          capacity: 2500MHz
          clock: 200MHz
          capabilities: vmx ht cpufreq
          configuration: id=3D0
        *-cache
             description: L1 cache
             physical id: 5
             slot: Unknown
             size: 32KiB
             capacity: 32KiB
             capabilities: asynchronous internal write-back data
        *-logicalcpu:0
             description: Logical CPU
             physical id: 0.1
             capabilities: logical
        *-logicalcpu:1
             description: Logical CPU
             physical id: 0.2
             capabilities: logical
     *-cache:1
          description: L1 cache
          physical id: 4
          slot: Unknown
          size: 32KiB
          capacity: 32KiB
          capabilities: asynchronous internal write-back instruction
     *-memory
          description: System Memory
          physical id: 6
          slot: System board or motherboard
          size: 4GiB
        *-bank:0
             description: SODIMM DDR2 Synchronous 667 MHz (1.5 ns)
             product: 0x4D324E32473634545538484436422D334320
             vendor: 0x7F7F7F0B00000000
             physical id: 0
             serial: 0x13B70213
             slot: DIMM0
             size: 2GiB
             width: 64 bits
             clock: 667MHz (1.5ns)
        *-bank:1
             description: SODIMM DDR2 Synchronous 667 MHz (1.5 ns)
             product: 0x4D324E32473634545538484436422D334320
             vendor: 0x7F7F7F0B00000000
             physical id: 1
             serial: 0xD4B40212
             slot: DIMM1
             size: 2GiB
             width: 64 bits
             clock: 667MHz (1.5ns)
     *-firmware
          description: BIOS
          vendor: Apple Inc.
          physical id: e
          version: MBP41.88Z.00C1.B03.0802271651 (02/27/08)
          size: 1MiB
          capacity: 1984KiB
          capabilities: pci upgrade shadowing cdboot bootselect acpi ieee=
1394boot smartbattery netboot
     *-pci
          description: Host bridge
          product: Mobile PM965/GM965/GL960 Memory Controller Hub
          vendor: Intel Corporation
          physical id: 100
          bus info: pci@0000:00:00.0
          version: 03
          width: 32 bits
          clock: 33MHz
        *-pci:0
             description: PCI bridge
             product: Mobile PM965/GM965/GL960 PCI Express Root Port
             vendor: Intel Corporation
             physical id: 1
             bus info: pci@0000:00:01.0
             version: 03
             width: 32 bits
             clock: 33MHz
             capabilities: pci pm msi pciexpress bus_master cap_list
             configuration: driver=3Dpcieport-driver
             resources: irq:24 ioport:7000(size=3D4096) memory:d0000000-d=
30fffff ioport:c0000000(size=3D268435456)
           *-display
                description: VGA compatible controller
                product: G84 [GeForce 8600M GT]
                vendor: nVidia Corporation
                physical id: 0
                bus info: pci@0000:01:00.0
                version: a1
                width: 64 bits
                clock: 33MHz
                capabilities: pm msi pciexpress bus_master cap_list rom
                configuration: driver=3Dnvidia latency=3D0
                resources: irq:16 memory:d2000000-d2ffffff memory:c000000=
0-cfffffff(prefetchable) memory:d0000000-d1ffffff ioport:7000(size=3D128)=
 memory:d3000000-d301ffff(prefetchable)
        *-usb:0
             description: USB Controller
             product: 82801H (ICH8 Family) USB UHCI Controller #4
             vendor: Intel Corporation
             physical id: 1a
             bus info: pci@0000:00:1a.0
             version: 04
             width: 32 bits
             clock: 33MHz
             capabilities: bus_master
             configuration: driver=3Duhci_hcd latency=3D0
             resources: irq:20 ioport:80c0(size=3D32)
        *-usb:1
             description: USB Controller
             product: 82801H (ICH8 Family) USB UHCI Controller #5
             vendor: Intel Corporation
             physical id: 1a.1
             bus info: pci@0000:00:1a.1
             version: 04
             width: 32 bits
             clock: 33MHz
             capabilities: bus_master
             configuration: driver=3Duhci_hcd latency=3D0
             resources: irq:16 ioport:80a0(size=3D32)
        *-usb:2
             description: USB Controller
             product: 82801H (ICH8 Family) USB2 EHCI Controller #2
             vendor: Intel Corporation
             physical id: 1a.7
             bus info: pci@0000:00:1a.7
             version: 04
             width: 32 bits
             clock: 33MHz
             capabilities: pm debug bus_master cap_list
             configuration: driver=3Dehci_hcd latency=3D0
             resources: irq:21 memory:db504c00-db504fff
        *-multimedia
             description: Audio device
             product: 82801H (ICH8 Family) HD Audio Controller
             vendor: Intel Corporation
             physical id: 1b
             bus info: pci@0000:00:1b.0
             version: 04
             width: 64 bits
             clock: 33MHz
             capabilities: pm msi pciexpress bus_master cap_list
             configuration: driver=3DHDA Intel latency=3D0
             resources: irq:20 memory:db500000-db503fff
        *-pci:1
             description: PCI bridge
             product: 82801H (ICH8 Family) PCI Express Port 1
             vendor: Intel Corporation
             physical id: 1c
             bus info: pci@0000:00:1c.0
             version: 04
             width: 32 bits
             clock: 33MHz
             capabilities: pci pciexpress msi pm bus_master cap_list
             configuration: driver=3Dpcieport-driver
             resources: irq:25 memory:db400000-db4fffff
        *-pci:2
             description: PCI bridge
             product: 82801H (ICH8 Family) PCI Express Port 3
             vendor: Intel Corporation
             physical id: 1c.2
             bus info: pci@0000:00:1c.2
             version: 04
             width: 32 bits
             clock: 33MHz
             capabilities: pci pciexpress msi pm bus_master cap_list
             configuration: driver=3Dpcieport-driver
             resources: irq:26 ioport:6000(size=3D4096) memory:d7400000-d=
b3fffff ioport:d3100000(size=3D67108864)
        *-pci:3
             description: PCI bridge
             product: 82801H (ICH8 Family) PCI Express Port 5
             vendor: Intel Corporation
             physical id: 1c.4
             bus info: pci@0000:00:1c.4
             version: 04
             width: 32 bits
             clock: 33MHz
             capabilities: pci pciexpress msi pm bus_master cap_list
             configuration: driver=3Dpcieport-driver
             resources: irq:27 memory:d7300000-d73fffff
           *-network
                description: Wireless interface
                product: BCM4328 802.11a/b/g/n
                vendor: Broadcom Corporation
                physical id: 0
                bus info: pci@0000:0b:00.0
                logical name: eth1
                version: 05
                serial: 00:21:e9:e5:67:99
                width: 64 bits
                clock: 33MHz
                capabilities: pm msi pciexpress bus_master cap_list ether=
net physical wireless
                configuration: broadcast=3Dyes driver=3Dwl0 driverversion=
=3D5.10.91.9 latency=3D0 multicast=3Dyes wireless=3DIEEE 802.11abgn
                resources: irq:16 memory:d7300000-d7303fff
        *-pci:4
             description: PCI bridge
             product: 82801H (ICH8 Family) PCI Express Port 6
             vendor: Intel Corporation
             physical id: 1c.5
             bus info: pci@0000:00:1c.5
             version: 04
             width: 32 bits
             clock: 33MHz
             capabilities: pci pciexpress msi pm bus_master cap_list
             configuration: driver=3Dpcieport-driver
             resources: irq:28 ioport:5000(size=3D4096) memory:d7200000-d=
72fffff memory:db600000-db6fffff(prefetchable)
           *-network
                description: Ethernet interface
                product: Marvell Yukon 88E8058 PCI-E Gigabit Ethernet Con=
troller
                vendor: Marvell Technology Group Ltd.
                physical id: 0
                bus info: pci@0000:0c:00.0
                logical name: eth0
                version: 13
                serial: 00:22:41:28:e8:c4
                size: 100MB/s
                capacity: 1GB/s
                width: 64 bits
                clock: 33MHz
                capabilities: pm vpd msi pciexpress bus_master cap_list r=
om ethernet physical tp 10bt 10bt-fd 100bt 100bt-fd 1000bt 1000bt-fd auto=
negotiation
                configuration: autonegotiation=3Don broadcast=3Dyes drive=
r=3Dsky2 driverversion=3D1.23 duplex=3Dfull firmware=3DN/A ip=3D172.31.68=
=2E155 latency=3D0 link=3Dyes multicast=3Dyes port=3Dtwisted pair speed=3D=
100MB/s
                resources: irq:29 memory:d7200000-d7203fff ioport:5000(si=
ze=3D256) memory:db600000-db61ffff(prefetchable)
        *-usb:3
             description: USB Controller
             product: 82801H (ICH8 Family) USB UHCI Controller #1
             vendor: Intel Corporation
             physical id: 1d
             bus info: pci@0000:00:1d.0
             version: 04
             width: 32 bits
             clock: 33MHz
             capabilities: bus_master
             configuration: driver=3Duhci_hcd latency=3D0
             resources: irq:16 ioport:8080(size=3D32)
        *-usb:4
             description: USB Controller
             product: 82801H (ICH8 Family) USB UHCI Controller #2
             vendor: Intel Corporation
             physical id: 1d.1
             bus info: pci@0000:00:1d.1
             version: 04
             width: 32 bits
             clock: 33MHz
             capabilities: bus_master
             configuration: driver=3Duhci_hcd latency=3D0
             resources: irq:18 ioport:8060(size=3D32)
        *-usb:5
             description: USB Controller
             product: 82801H (ICH8 Family) USB UHCI Controller #3
             vendor: Intel Corporation
             physical id: 1d.2
             bus info: pci@0000:00:1d.2
             version: 04
             width: 32 bits
             clock: 33MHz
             capabilities: bus_master
             configuration: driver=3Duhci_hcd latency=3D0
             resources: irq:21 ioport:8040(size=3D32)
        *-usb:6
             description: USB Controller
             product: 82801H (ICH8 Family) USB2 EHCI Controller #1
             vendor: Intel Corporation
             physical id: 1d.7
             bus info: pci@0000:00:1d.7
             version: 04
             width: 32 bits
             clock: 33MHz
             capabilities: pm debug bus_master cap_list
             configuration: driver=3Dehci_hcd latency=3D0
             resources: irq:20 memory:db504800-db504bff
        *-pci:5
             description: PCI bridge
             product: 82801 Mobile PCI Bridge
             vendor: Intel Corporation
             physical id: 1e
             bus info: pci@0000:00:1e.0
             version: f4
             width: 32 bits
             clock: 33MHz
             capabilities: pci bus_master cap_list
             resources: memory:d7100000-d71fffff
           *-firewire
                description: FireWire (IEEE 1394)
                product: TSB82AA2 IEEE-1394b Link Layer Controller
                vendor: Texas Instruments
                physical id: 3
                bus info: pci@0000:0d:03.0
                version: 02
                width: 32 bits
                clock: 33MHz
                capabilities: pm bus_master cap_list
                configuration: driver=3Dohci1394 latency=3D248 maxlatency=
=3D4 mingnt=3D2
                resources: irq:19 memory:d7104000-d71047ff memory:d710000=
0-d7103fff
        *-isa
             description: ISA bridge
             product: 82801HEM (ICH8M) LPC Interface Controller
             vendor: Intel Corporation
             physical id: 1f
             bus info: pci@0000:00:1f.0
             version: 04
             width: 32 bits
             clock: 33MHz
             capabilities: isa bus_master cap_list
             configuration: latency=3D0
        *-ide:0
             description: IDE interface
             product: 82801HBM/HEM (ICH8M/ICH8M-E) IDE Controller
             vendor: Intel Corporation
             physical id: 1f.1
             bus info: pci@0000:00:1f.1
             logical name: scsi0
             version: 04
             width: 32 bits
             clock: 33MHz
             capabilities: ide bus_master emulated
             configuration: driver=3Data_piix latency=3D0
             resources: irq:21 ioport:8108(size=3D8) ioport:811c(size=3D4=
) ioport:8100(size=3D8) ioport:8118(size=3D4) ioport:80e0(size=3D16)
           *-cdrom
                description: DVD writer
                product: DVDRW  GSA-S10N
                vendor: HL-DT-ST
                physical id: 0.0.0
                bus info: scsi@0:0.0.0
                logical name: /dev/cdrom
                logical name: /dev/cdrw
                logical name: /dev/dvd
                logical name: /dev/dvdrw
                logical name: /dev/scd0
                logical name: /dev/sr0
                version: AP12
                capabilities: removable audio cd-r cd-rw dvd dvd-r
                configuration: ansiversion=3D5 status=3Dopen
        *-ide:1
             description: IDE interface
             product: 82801HBM/HEM (ICH8M/ICH8M-E) SATA IDE Controller
             vendor: Intel Corporation
             physical id: 1f.2
             bus info: pci@0000:00:1f.2
             logical name: scsi2
             version: 04
             width: 32 bits
             clock: 66MHz
             capabilities: ide pm bus_master cap_list emulated
             configuration: driver=3Data_piix latency=3D0
             resources: irq:18 ioport:80f8(size=3D8) ioport:8114(size=3D4=
) ioport:80f0(size=3D8) ioport:8110(size=3D4) ioport:8020(size=3D16) iopo=
rt:4000(size=3D16)
           *-disk
                description: ATA Disk
                product: Hitachi HTS54252
                vendor: Hitachi
                physical id: 0.0.0
                bus info: scsi@2:0.0.0
                logical name: /dev/sda
                version: BBFA
                serial: 080718BB2F10WDEY0X7A
                size: 232GiB (250GB)
                capabilities: partitioned partitioned:dos
                configuration: ansiversion=3D5
              *-volume:0 UNCLAIMED
                   description: EFI GPT partition
                   physical id: 1
                   bus info: scsi@2:0.0.0,1
                   capacity: 200MiB
                   capabilities: primary nofs
              *-volume:1
                   description: Darwin/OS X HFS+ partition
                   vendor: Mac OS X (journaled)
                   physical id: 2
                   bus info: scsi@2:0.0.0,2
                   logical name: /dev/sda2
                   version: 4
                   serial: 29b68879-2138-b6e1-0000-000000744000
                   size: 79GiB
                   capacity: 79GiB
                   capabilities: primary bootable journaled osx hfsplus i=
nitialized
                   configuration: boot=3Dosx checked=3D2009-10-28 12:43:4=
7 created=3D2009-10-28 04:43:47 filesystem=3Dhfsplus lastmountedby=3DHFSJ=
 modified=3D2010-01-10 18:18:35 state=3Dclean
              *-volume:2
                   description: EXT4 volume
                   vendor: Linux
                   physical id: 3
                   bus info: scsi@2:0.0.0,3
                   logical name: /dev/sda3
                   logical name: /
                   version: 1.0
                   serial: 8cf75e77-6114-47b9-bf1f-fad3073f977c
                   size: 134GiB
                   capacity: 134GiB
                   capabilities: primary journaled extended_attributes la=
rge_files huge_files dir_nlink recover extents ext4 ext2 initialized
                   configuration: created=3D2009-10-28 21:47:27 filesyste=
m=3Dext4 lastmountpoint=3D/v{=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=EF=BF=BD=EF=BF=
=BD=EF=BF=BD=EF=BF=BD7=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=EF=BF=BD=EF=BF=BD=EF=
=BF=BD=EF=BF=BDB=EF=BF=BD=EF=BF=BDP=EF=BF=BD=EF=BF=BDP=EF=BF=BD=EF=BF=BD=EF=
=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BDB=EF=BF=BD=EF=BF=BDB=EF=BF=BDu=EF=BF=BD=EF=
=BF=BD=EF=BF=BD=EF=BF=BDp.&=EF=BF=BD=EF=BF=BD=EF=BF=BD modified=3D2010-01=
-15 12:27:06 mount.fstype=3Dext4 mount.options=3Drw,relatime,errors=3Drem=
ount-ro,barrier=3D1,data=3Dordered mounted=3D2010-01-15 12:28:41 state=3D=
mounted
        *-serial UNCLAIMED
             description: SMBus
             product: 82801H (ICH8 Family) SMBus Controller
             vendor: Intel Corporation
             physical id: 1f.3
             bus info: pci@0000:00:1f.3
             version: 04
             width: 32 bits
             clock: 33MHz
             configuration: latency=3D0
             resources: memory:db505000-db5050ff ioport:efa0(size=3D32)
  *-battery
       product: Unknown
       vendor: Unknown
       physical id: 1
       version: Unknown
       serial: Unknown
       slot: Unknown

--------------010909070805000301010305--
