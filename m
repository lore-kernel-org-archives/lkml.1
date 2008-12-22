Return-Path: <linux-kernel-owner+w=401wt.eu-S1754861AbYLVO3z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754861AbYLVO3z (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Dec 2008 09:29:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754169AbYLVO3r
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Dec 2008 09:29:47 -0500
Received: from host193-178-static.190-82-b.business.telecomitalia.it ([82.190.178.193]:34912
	"EHLO ns1.ibs.sm" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754163AbYLVO3n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Dec 2008 09:29:43 -0500
X-Greylist: delayed 1328 seconds by postgrey-1.27 at vger.kernel.org; Mon, 22 Dec 2008 09:29:41 EST
Reply-To: <draschi@ibs.sm>
From: "Diego Raschi" <draschi@ibs.sm>
To: <linux-kernel@vger.kernel.org>
Subject: BUG smbd crash
Date: Mon, 22 Dec 2008 15:07:24 +0100
Message-ID: <000701c9643e$9d949480$1b02a8c0@client018>
MIME-Version: 1.0
Content-Type: multipart/mixed;
	boundary="----=_NextPart_000_0008_01C96446.FF58FC80"
X-Priority: 3 (Normal)
X-MSMail-Priority: Normal
X-Mailer: Microsoft Outlook CWS, Build 9.0.6604 (9.0.2911.0)
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2900.2180
Importance: Normal
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.

------=_NextPart_000_0008_01C96446.FF58FC80
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: 7bit

1.smbd crash
2.The daemon smbd crash and after restart the system is unstable.
3.daemon
4.Linux version 2.6.27.8.fc9.x86_64 (root@node1) (gcc version 4.3.0 20080428
(Red Hat 4.3.0-8) (GCC) ) #3 SMP Thu Dec 18 10:40:19 CET 2008
5.Mon Dec 22 13:49:01 CET 2008
BUG: soft lockup - CPU#5 stuck for 61s! [smbd:16614]
Modules linked in: sha256_generic aes_x86_64 aes_generic cbc dm_crypt
crypto_blkcipher nfs lockd nfs_acl ipmi_si ipmi_devintf ipmi_msghandler
sunrpc bonding ipv6 xfs dm_mirror dm_log dm_multipath dm_mod kvm_amd kvm
sr_mod cdrom raid0 ata_generic pata_amd cfi_cmdset_0002 pcspkr cfi_util
ppdev sata_nv pata_acpi floppy libata button jedec_probe parport_pc
cfi_probe gen_probe ck804xrom parport mtd qla2xxx chipreg scsi_transport_fc
scsi_tgt map_funcs sg forcedeth i2c_nforce2 i2c_core shpchp 3w_9xxx sd_mod
scsi_mod raid456 async_xor async_memcpy async_tx xor raid1 ext3 jbd mbcache
uhci_hcd ohci_hcd ehci_hcd [last unloaded: e1000]
CPU 5:
Modules linked in: sha256_generic aes_x86_64 aes_generic cbc dm_crypt
crypto_blkcipher nfs lockd nfs_acl ipmi_si ipmi_devintf ipmi_msghandler
sunrpc bonding ipv6 xfs dm_mirror dm_log dm_multipath dm_mod kvm_amd kvm
sr_mod cdrom raid0 ata_generic pata_amd cfi_cmdset_0002 pcspkr cfi_util
ppdev sata_nv pata_acpi floppy libata button jedec_probe parport_pc
cfi_probe gen_probe ck804xrom parport mtd qla2xxx chipreg scsi_transport_fc
scsi_tgt map_funcs sg forcedeth i2c_nforce2 i2c_core shpchp 3w_9xxx sd_mod
scsi_mod raid456 async_xor async_memcpy async_tx xor raid1 ext3 jbd mbcache
uhci_hcd ohci_hcd ehci_hcd [last unloaded: e1000]
Pid: 16614, comm: smbd Not tainted 2.6.27.8.fc9.x86_64 #3
RIP: 0010:[<ffffffff812a1871>]  [<ffffffff812a1871>] mutex_lock+0x23/0x2e
RSP: 0000:ffff88032f0c1e38  EFLAGS: 00000246
RAX: 0000000000000246 RBX: ffff88032f0c1e48 RCX: 0000000000000002
RDX: ffff88032e91ebc0 RSI: 0000000000000058 RDI: ffff88010b65d3f0
RBP: 0000000000000000 R08: ffff88032f0c0000 R09: 0000000000000000
R10: 0000150d29bc50cf R11: ffff8802dca56048 R12: 0000150d29bc50cf
R13: ffff8802dca56048 R14: ffff88032f0c1e28 R15: 0000000000000000
FS:  00007f011676a7a0(0000) GS:ffff88022fa13200(0000) knlGS:00000000f7fd86c0
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 0000000002642fc0 CR3: 000000032e91d000 CR4: 00000000000006e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400

Call Trace:
 [<ffffffff812a186b>] ? mutex_lock+0x1d/0x2e
 [<ffffffff810dbd0e>] ? inotify_destroy+0x83/0xda
 [<ffffffff810dbefe>] ? inotify_release+0x28/0xd7
 [<ffffffff810b2202>] ? __fput+0xc5/0x184
 [<ffffffff810b22d6>] ? fput+0x15/0x17
 [<ffffffff810af745>] ? filp_close+0x67/0x72
 [<ffffffff810af7fd>] ? sys_close+0xad/0xf0
 [<ffffffff8100c0ea>] ? system_call_fastpath+0x16/0x1b

6.
7.Fedora 9 x86_64
7.1 samba-3.2.0-1.pre3.9.fc9.x86_64
7.2
7.3nfs 263072 2 - Live 0xffffffffa0364000
lockd 68384 1 nfs, Live 0xffffffffa0352000
nfs_acl 7296 1 nfs, Live 0xffffffffa0148000
ipmi_si 44428 0 - Live 0xffffffffa013c000
ipmi_devintf 13840 0 - Live 0xffffffffa0137000
ipmi_msghandler 35832 2 ipmi_si,ipmi_devintf, Live 0xffffffffa012d000
sunrpc 186472 13 nfs,lockd,nfs_acl, Live 0xffffffffa0323000
bonding 86696 0 - Live 0xffffffffa030c000
ipv6 270696 320 - Live 0xffffffffa02c8000
xfs 482864 3 - Live 0xffffffffa0251000
dm_mirror 21568 0 - Live 0xffffffffa024a000
dm_log 13892 1 dm_mirror, Live 0xffffffffa0245000
dm_multipath 19032 0 - Live 0xffffffffa023f000
dm_mod 57632 3 dm_mirror,dm_log,dm_multipath, Live 0xffffffffa022f000
kvm_amd 33932 0 - Live 0xffffffffa0225000
kvm 134960 1 kvm_amd, Live 0xffffffffa0203000
sr_mod 19764 0 - Live 0xffffffffa01fd000
cdrom 36520 1 sr_mod, Live 0xffffffffa01f3000
ata_generic 10180 0 - Live 0xffffffffa01ef000
pata_amd 17348 0 - Live 0xffffffffa01e9000
cfi_cmdset_0002 30528 1 - Live 0xffffffffa01e0000
raid0 10880 1 - Live 0xffffffffa01dc000
cfi_util 7424 1 cfi_cmdset_0002, Live 0xffffffffa012a000
jedec_probe 18496 0 - Live 0xffffffffa01d6000
cfi_probe 11136 0 - Live 0xffffffffa01d2000
ppdev 11912 0 - Live 0xffffffffa01ce000
sata_nv 28616 0 - Live 0xffffffffa01c4000
gen_probe 7488 2 jedec_probe,cfi_probe, Live 0xffffffffa01c1000
qla2xxx 183076 1 - Live 0xffffffffa0191000
pata_acpi 9280 0 - Live 0xffffffffa018b000
ck804xrom 8708 0 - Live 0xffffffffa0185000
mtd 18060 3 cfi_cmdset_0002,ck804xrom, Live 0xffffffffa017f000
libata 156032 4 ata_generic,pata_amd,sata_nv,pata_acpi, Live
0xffffffffa0157000
parport_pc 30360 0 - Live 0xffffffffa014e000
floppy 62568 0 - Live 0xffffffffa0119000
forcedeth 59152 0 - Live 0xffffffffa0109000
i2c_nforce2 10944 0 - Live 0xffffffffa0105000
chipreg 7172 3 jedec_probe,cfi_probe,ck804xrom, Live 0xffffffffa0102000
pcspkr 7104 0 - Live 0xffffffffa00fd000
parport 38944 2 ppdev,parport_pc, Live 0xffffffffa00f2000
scsi_transport_fc 46852 1 qla2xxx, Live 0xffffffffa00e5000
sg 36688 0 - Live 0xffffffffa00db000
i2c_core 25312 1 i2c_nforce2, Live 0xffffffffa00d3000
map_funcs 6208 1 ck804xrom, Live 0xffffffffa00d0000
scsi_tgt 16688 1 scsi_transport_fc, Live 0xffffffffa00ca000
button 11808 0 - Live 0xffffffffa00c6000
shpchp 34204 0 - Live 0xffffffffa00bc000
3w_9xxx 35412 7 - Live 0xffffffffa00b2000
sd_mod 30760 12 - Live 0xffffffffa00a9000
scsi_mod 148888 8
sr_mod,qla2xxx,libata,scsi_transport_fc,sg,scsi_tgt,3w_9xxx,sd_mod, Live 0xf
fffffffa0083000
raid456 125984 0 - Live 0xffffffffa0063000
async_xor 7552 1 raid456, Live 0xffffffffa0060000
async_memcpy 6272 1 raid456, Live 0xffffffffa005d000
async_tx 11052 3 raid456,async_xor,async_memcpy, Live 0xffffffffa0059000
xor 9360 2 raid456,async_xor, Live 0xffffffffa0055000
raid1 25664 2 - Live 0xffffffffa004d000
ext3 126608 1 - Live 0xffffffffa002d000
jbd 51560 1 ext3, Live 0xffffffffa001f000
mbcache 11908 1 ext3, Live 0xffffffffa001b000
uhci_hcd 26464 0 - Live 0xffffffffa0013000
ohci_hcd 27292 0 - Live 0xffffffffa000b000
ehci_hcd 38156 0 - Live 0xffffffffa0000000

7.4
[root@node1]/backup>cat /proc/ioports
0000-8fff : PCI Bus #00
  0000-001f : dma1
  0020-0021 : pic1
  0040-0043 : timer0
  0050-0053 : timer1
  0060-0060 : keyboard
  0064-0064 : keyboard
  0070-0071 : rtc0
  0080-008f : dma page reg
  00a0-00a1 : pic2
  00c0-00df : dma2
  00f0-00ff : fpu
  0170-0177 : 0000:00:06.0
    0170-0177 : pata_amd
  01f0-01f7 : 0000:00:06.0
    01f0-01f7 : pata_amd
  02f8-02ff : serial
  0376-0376 : 0000:00:06.0
    0376-0376 : pata_amd
  0378-037a : parport0
  037b-037f : parport0
  03c0-03df : vesafb
  03f2-03f5 : floppy
  03f6-03f6 : 0000:00:06.0
    03f6-03f6 : pata_amd
  03f7-03f7 : floppy DIR
  03f8-03ff : serial
  0400-045e : pnp 00:09
  04d0-04d1 : pnp 00:09
  0ca8-0ca8 : ipmi_si
  0cac-0cac : ipmi_si
  0cf8-0cff : PCI conf1
  1000-101f : 0000:00:01.1
  1400-140f : 0000:00:06.0
    1400-140f : pata_amd
  1410-141f : 0000:00:07.0
    1410-141f : sata_nv
  1420-142f : 0000:00:08.0
    1420-142f : sata_nv
  1430-1433 : 0000:00:07.0
    1430-1433 : sata_nv
  1434-1437 : 0000:00:07.0
    1434-1437 : sata_nv
  1438-143f : 0000:00:07.0
    1438-143f : sata_nv
  1440-1447 : 0000:00:07.0
    1440-1447 : sata_nv
  1448-144b : 0000:00:08.0
    1448-144b : sata_nv
  144c-144f : 0000:00:08.0
    144c-144f : sata_nv
  1450-1457 : 0000:00:08.0
    1450-1457 : sata_nv
  1458-145f : 0000:00:08.0
    1458-145f : sata_nv
  1460-1467 : 0000:00:0a.0
    1460-1467 : forcedeth
  2000-2fff : PCI Bus 0000:01
    2000-207f : 0000:01:09.0
    2080-20bf : 0000:01:06.0
  3000-3fff : PCI Bus 0000:05
    3000-30ff : 0000:05:00.0
  8000-807f : pnp 00:08
    8000-8003 : ACPI PM1a_EVT_BLK
    8004-8005 : ACPI PM1a_CNT_BLK
    8008-800b : ACPI PM_TMR
    8010-8015 : ACPI CPU throttle
    801c-801c : ACPI PM2_CNT_BLK
    8020-8027 : ACPI GPE0_BLK
  8080-80ff : pnp 00:08
  8400-847f : pnp 00:08
  8480-84ff : pnp 00:08
  8800-887f : pnp 00:08
  8880-88ff : pnp 00:08
9000-9fff : PCI Bus #80
  9000-907f : pnp 00:09
  9080-90ff : pnp 00:09
  9200-927f : pnp 00:09
  9280-92ff : pnp 00:09
  9400-947f : pnp 00:09
  9480-94ff : pnp 00:09
a000-afff : PCI Bus #00
  a000-a03f : 0000:00:01.1
    a000-a03f : pnp 00:08
      a000-a03f : nForce2_smbus
  a040-a07f : 0000:00:01.1
    a040-a07f : pnp 00:08
      a040-a07f : nForce2_smbus
b000-cfff : PCI Bus #80
  b000-b00f : 0000:80:07.0
    b000-b00f : sata_nv
  b010-b01f : 0000:80:08.0
    b010-b01f : sata_nv
  b020-b023 : 0000:80:07.0
    b020-b023 : sata_nv
  b024-b027 : 0000:80:07.0
    b024-b027 : sata_nv
  b028-b02f : 0000:80:07.0
    b028-b02f : sata_nv
  b030-b037 : 0000:80:07.0
    b030-b037 : sata_nv
  b038-b03b : 0000:80:08.0
    b038-b03b : sata_nv
  b03c-b03f : 0000:80:08.0
    b03c-b03f : sata_nv
  b040-b047 : 0000:80:08.0
    b040-b047 : sata_nv
  b048-b04f : 0000:80:08.0
    b048-b04f : sata_nv
  b050-b057 : 0000:80:0a.0
    b050-b057 : forcedeth
  c000-cfff : PCI Bus 0000:8b
    c000-c0ff : 0000:8b:00.0
      c000-c0ff : 3w-9xxx
d000-ffff : PCI Bus #00


[root@node1]/backup>cat /proc/iomem
00000000-0000ffff : reserved
00010000-000953ff : System RAM
00095400-0009ffff : reserved
000a0000-000bffff : PCI Bus #00
000ca000-000fffff : reserved
00100000-7ff7ffff : System RAM
  00200000-004a9a84 : Kernel code
  004a9a85-0062fc1f : Kernel data
  00fe1000-0108b06b : Kernel bss
  20000000-23ffffff : GART
7ff80000-7ff84fff : ACPI Tables
7ff85000-7fffffff : ACPI Non-volatile Storage
80000000-cfdfffff : System RAM
cfe00000-cfffffff : reserved
d0000000-dbffffff : PCI Bus #00
  d0000000-d00fffff : PCI Bus 0000:05
    d0000000-d003ffff : 0000:05:00.0
  d4000000-d4000fff : 0000:00:02.0
    d4000000-d4000fff : ohci_hcd
  d4001000-d40010ff : 0000:00:02.1
    d4001000-d40010ff : ehci_hcd
  d4002000-d4002fff : 0000:00:07.0
    d4002000-d4002fff : sata_nv
  d4003000-d4003fff : 0000:00:08.0
    d4003000-d4003fff : sata_nv
  d4004000-d4004fff : 0000:00:0a.0
    d4004000-d4004fff : forcedeth
  d4100000-d41fffff : PCI Bus 0000:01
    d4100000-d411ffff : 0000:01:06.0
    d4120000-d413ffff : 0000:01:06.0
    d4140000-d417ffff : 0000:01:09.0
    d4180000-d419ffff : 0000:01:06.0
  d4200000-d42fffff : PCI Bus 0000:05
    d4200000-d4203fff : 0000:05:00.0
      d4200000-d4203fff : qla2xxx
  d8000000-dbffffff : PCI Bus 0000:01
    d8000000-dbffffff : 0000:01:09.0
      d8000000-d9ffffff : vesafb
dc000000-dfffffff : PCI Bus #80
  dc000000-dc000fff : 0000:80:07.0
    dc000000-dc000fff : sata_nv
  dc001000-dc001fff : 0000:80:08.0
    dc001000-dc001fff : sata_nv
  dc002000-dc002fff : 0000:80:0a.0
    dc002000-dc002fff : forcedeth
  dc100000-dc1fffff : PCI Bus 0000:8b
    dc100000-dc100fff : 0000:8b:00.0
      dc100000-dc100fff : 3w-9xxx
    dc120000-dc13ffff : 0000:8b:00.0
  de000000-dfffffff : PCI Bus 0000:8b
    de000000-dfffffff : 0000:8b:00.0
      de000000-dfffffff : 3w-9xxx
e0000000-efffffff : reserved
  e0000000-e7ffffff : PCI Bus #00
  e8000000-efffffff : PCI Bus #80
f0000000-ffffffff : PCI Bus #00
  fec00000-fec0ffff : reserved
    fec00000-fec00fff : IOAPIC 0
  fee00000-fee00fff : Local APIC
    fee00000-fee00fff : reserved
  fefff000-feffffff : pnp 00:00
  fff80000-ffffffff : reserved
100000000-82fffffff : System RAM
830000000-fcffffffff : PCI Bus #00

7.5
7.6 [root@node1]/backup>cat /proc/scsi/scsi
Attached devices:
Host: scsi0 Channel: 00 Id: 00 Lun: 00
  Vendor: AMCC     Model: 9690SA-8I  DISK  Rev: 4.04
  Type:   Direct-Access                    ANSI  SCSI revision: 05
Host: scsi0 Channel: 00 Id: 01 Lun: 00
  Vendor: AMCC     Model: 9690SA-8I  DISK  Rev: 4.04
  Type:   Direct-Access                    ANSI  SCSI revision: 05
Host: scsi0 Channel: 00 Id: 02 Lun: 00
  Vendor: AMCC     Model: 9690SA-8I  DISK  Rev: 4.04
  Type:   Direct-Access                    ANSI  SCSI revision: 05
Host: scsi5 Channel: 00 Id: 00 Lun: 00
  Vendor: IFT      Model: F12F-G2A2        Rev: 342R
  Type:   Direct-Access                    ANSI  SCSI revision: 03
Host: scsi7 Channel: 00 Id: 00 Lun: 00
  Vendor: TEAC     Model: DV-516GB         Rev: HT13
  Type:   CD-ROM                           ANSI  SCSI revision: 05


My server work with smbd, nmbd, nfs, mysqld, ntpd, vsftpd. I have tried to
kill the pid smbd:16614, but the system don't execute my command kill -15
16614 or kill -9 16614. After I have restart the daemon smbd and nmbd but
the process don't sutdown, the server give me at on dmesg much error BUG:
soft lockup - CPU#5 stuck for 61s! [smbd:16614]. After the restart smbd
daemon the system is unstable with other process.


Thank you

Diego Raschi
Responsabile Risorse Informatiche

Istituto Bancario Sammarinese S.p.A.
via III Settembre 99 - 47891 Repubblica di San Marino
Tel. 0549 872014 Fax. 0549 872050
draschi@ibs.sm
www.ibs.sm         https://ibs.sm/

------=_NextPart_000_0008_01C96446.FF58FC80
Content-Type: text/plain;
	name="cpuinfo.txt"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment;
	filename="cpuinfo.txt"

processor	: 0=0A=
vendor_id	: AuthenticAMD=0A=
cpu family	: 16=0A=
model		: 2=0A=
model name	: Quad-Core AMD Opteron(tm) Processor 8358 SE=0A=
stepping	: 3=0A=
cpu MHz		: 2411.105=0A=
cache size	: 512 KB=0A=
physical id	: 0=0A=
siblings	: 4=0A=
core id		: 0=0A=
cpu cores	: 4=0A=
apicid		: 4=0A=
initial apicid	: 0=0A=
fpu		: yes=0A=
fpu_exception	: yes=0A=
cpuid level	: 5=0A=
wp		: yes=0A=
flags		: fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov =
pat pse36 clflush mmx fxsr sse sse2 ht syscall nx mmxext fxsr_opt =
pdpe1gb rdtscp lm 3dnowext 3dnow constant_tsc rep_good nopl pni monitor =
cx16 popcnt lahf_lm cmp_legacy svm extapic cr8_legacy abm sse4a =
misalignsse 3dnowprefetch osvw ibs=0A=
bogomips	: 4822.20=0A=
TLB size	: 1024 4K pages=0A=
clflush size	: 64=0A=
cache_alignment	: 64=0A=
address sizes	: 48 bits physical, 48 bits virtual=0A=
power management: ts ttp tm stc 100mhzsteps hwpstate=0A=
=0A=
processor	: 1=0A=
vendor_id	: AuthenticAMD=0A=
cpu family	: 16=0A=
model		: 2=0A=
model name	: Quad-Core AMD Opteron(tm) Processor 8358 SE=0A=
stepping	: 3=0A=
cpu MHz		: 2411.105=0A=
cache size	: 512 KB=0A=
physical id	: 0=0A=
siblings	: 4=0A=
core id		: 1=0A=
cpu cores	: 4=0A=
apicid		: 5=0A=
initial apicid	: 1=0A=
fpu		: yes=0A=
fpu_exception	: yes=0A=
cpuid level	: 5=0A=
wp		: yes=0A=
flags		: fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov =
pat pse36 clflush mmx fxsr sse sse2 ht syscall nx mmxext fxsr_opt =
pdpe1gb rdtscp lm 3dnowext 3dnow constant_tsc rep_good nopl pni monitor =
cx16 popcnt lahf_lm cmp_legacy svm extapic cr8_legacy abm sse4a =
misalignsse 3dnowprefetch osvw ibs=0A=
bogomips	: 4826.72=0A=
TLB size	: 1024 4K pages=0A=
clflush size	: 64=0A=
cache_alignment	: 64=0A=
address sizes	: 48 bits physical, 48 bits virtual=0A=
power management: ts ttp tm stc 100mhzsteps hwpstate=0A=
=0A=
processor	: 2=0A=
vendor_id	: AuthenticAMD=0A=
cpu family	: 16=0A=
model		: 2=0A=
model name	: Quad-Core AMD Opteron(tm) Processor 8358 SE=0A=
stepping	: 3=0A=
cpu MHz		: 2411.105=0A=
cache size	: 512 KB=0A=
physical id	: 0=0A=
siblings	: 4=0A=
core id		: 2=0A=
cpu cores	: 4=0A=
apicid		: 6=0A=
initial apicid	: 2=0A=
fpu		: yes=0A=
fpu_exception	: yes=0A=
cpuid level	: 5=0A=
wp		: yes=0A=
flags		: fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov =
pat pse36 clflush mmx fxsr sse sse2 ht syscall nx mmxext fxsr_opt =
pdpe1gb rdtscp lm 3dnowext 3dnow constant_tsc rep_good nopl pni monitor =
cx16 popcnt lahf_lm cmp_legacy svm extapic cr8_legacy abm sse4a =
misalignsse 3dnowprefetch osvw ibs=0A=
bogomips	: 4826.61=0A=
TLB size	: 1024 4K pages=0A=
clflush size	: 64=0A=
cache_alignment	: 64=0A=
address sizes	: 48 bits physical, 48 bits virtual=0A=
power management: ts ttp tm stc 100mhzsteps hwpstate=0A=
=0A=
processor	: 3=0A=
vendor_id	: AuthenticAMD=0A=
cpu family	: 16=0A=
model		: 2=0A=
model name	: Quad-Core AMD Opteron(tm) Processor 8358 SE=0A=
stepping	: 3=0A=
cpu MHz		: 2411.105=0A=
cache size	: 512 KB=0A=
physical id	: 0=0A=
siblings	: 4=0A=
core id		: 3=0A=
cpu cores	: 4=0A=
apicid		: 7=0A=
initial apicid	: 3=0A=
fpu		: yes=0A=
fpu_exception	: yes=0A=
cpuid level	: 5=0A=
wp		: yes=0A=
flags		: fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov =
pat pse36 clflush mmx fxsr sse sse2 ht syscall nx mmxext fxsr_opt =
pdpe1gb rdtscp lm 3dnowext 3dnow constant_tsc rep_good nopl pni monitor =
cx16 popcnt lahf_lm cmp_legacy svm extapic cr8_legacy abm sse4a =
misalignsse 3dnowprefetch osvw ibs=0A=
bogomips	: 4826.60=0A=
TLB size	: 1024 4K pages=0A=
clflush size	: 64=0A=
cache_alignment	: 64=0A=
address sizes	: 48 bits physical, 48 bits virtual=0A=
power management: ts ttp tm stc 100mhzsteps hwpstate=0A=
=0A=
processor	: 4=0A=
vendor_id	: AuthenticAMD=0A=
cpu family	: 16=0A=
model		: 2=0A=
model name	: Quad-Core AMD Opteron(tm) Processor 8358 SE=0A=
stepping	: 3=0A=
cpu MHz		: 2411.105=0A=
cache size	: 512 KB=0A=
physical id	: 1=0A=
siblings	: 4=0A=
core id		: 0=0A=
cpu cores	: 4=0A=
apicid		: 8=0A=
initial apicid	: 4=0A=
fpu		: yes=0A=
fpu_exception	: yes=0A=
cpuid level	: 5=0A=
wp		: yes=0A=
flags		: fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov =
pat pse36 clflush mmx fxsr sse sse2 ht syscall nx mmxext fxsr_opt =
pdpe1gb rdtscp lm 3dnowext 3dnow constant_tsc rep_good nopl pni monitor =
cx16 popcnt lahf_lm cmp_legacy svm extapic cr8_legacy abm sse4a =
misalignsse 3dnowprefetch osvw ibs=0A=
bogomips	: 4823.11=0A=
TLB size	: 1024 4K pages=0A=
clflush size	: 64=0A=
cache_alignment	: 64=0A=
address sizes	: 48 bits physical, 48 bits virtual=0A=
power management: ts ttp tm stc 100mhzsteps hwpstate=0A=
=0A=
processor	: 5=0A=
vendor_id	: AuthenticAMD=0A=
cpu family	: 16=0A=
model		: 2=0A=
model name	: Quad-Core AMD Opteron(tm) Processor 8358 SE=0A=
stepping	: 3=0A=
cpu MHz		: 2411.105=0A=
cache size	: 512 KB=0A=
physical id	: 1=0A=
siblings	: 4=0A=
core id		: 1=0A=
cpu cores	: 4=0A=
apicid		: 9=0A=
initial apicid	: 5=0A=
fpu		: yes=0A=
fpu_exception	: yes=0A=
cpuid level	: 5=0A=
wp		: yes=0A=
flags		: fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov =
pat pse36 clflush mmx fxsr sse sse2 ht syscall nx mmxext fxsr_opt =
pdpe1gb rdtscp lm 3dnowext 3dnow constant_tsc rep_good nopl pni monitor =
cx16 popcnt lahf_lm cmp_legacy svm extapic cr8_legacy abm sse4a =
misalignsse 3dnowprefetch osvw ibs=0A=
bogomips	: 4823.11=0A=
TLB size	: 1024 4K pages=0A=
clflush size	: 64=0A=
cache_alignment	: 64=0A=
address sizes	: 48 bits physical, 48 bits virtual=0A=
power management: ts ttp tm stc 100mhzsteps hwpstate=0A=
=0A=
processor	: 6=0A=
vendor_id	: AuthenticAMD=0A=
cpu family	: 16=0A=
model		: 2=0A=
model name	: Quad-Core AMD Opteron(tm) Processor 8358 SE=0A=
stepping	: 3=0A=
cpu MHz		: 2411.105=0A=
cache size	: 512 KB=0A=
physical id	: 1=0A=
siblings	: 4=0A=
core id		: 2=0A=
cpu cores	: 4=0A=
apicid		: 10=0A=
initial apicid	: 6=0A=
fpu		: yes=0A=
fpu_exception	: yes=0A=
cpuid level	: 5=0A=
wp		: yes=0A=
flags		: fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov =
pat pse36 clflush mmx fxsr sse sse2 ht syscall nx mmxext fxsr_opt =
pdpe1gb rdtscp lm 3dnowext 3dnow constant_tsc rep_good nopl pni monitor =
cx16 popcnt lahf_lm cmp_legacy svm extapic cr8_legacy abm sse4a =
misalignsse 3dnowprefetch osvw ibs=0A=
bogomips	: 4823.13=0A=
TLB size	: 1024 4K pages=0A=
clflush size	: 64=0A=
cache_alignment	: 64=0A=
address sizes	: 48 bits physical, 48 bits virtual=0A=
power management: ts ttp tm stc 100mhzsteps hwpstate=0A=
=0A=
processor	: 7=0A=
vendor_id	: AuthenticAMD=0A=
cpu family	: 16=0A=
model		: 2=0A=
model name	: Quad-Core AMD Opteron(tm) Processor 8358 SE=0A=
stepping	: 3=0A=
cpu MHz		: 2411.105=0A=
cache size	: 512 KB=0A=
physical id	: 1=0A=
siblings	: 4=0A=
core id		: 3=0A=
cpu cores	: 4=0A=
apicid		: 11=0A=
initial apicid	: 7=0A=
fpu		: yes=0A=
fpu_exception	: yes=0A=
cpuid level	: 5=0A=
wp		: yes=0A=
flags		: fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov =
pat pse36 clflush mmx fxsr sse sse2 ht syscall nx mmxext fxsr_opt =
pdpe1gb rdtscp lm 3dnowext 3dnow constant_tsc rep_good nopl pni monitor =
cx16 popcnt lahf_lm cmp_legacy svm extapic cr8_legacy abm sse4a =
misalignsse 3dnowprefetch osvw ibs=0A=
bogomips	: 4823.49=0A=
TLB size	: 1024 4K pages=0A=
clflush size	: 64=0A=
cache_alignment	: 64=0A=
address sizes	: 48 bits physical, 48 bits virtual=0A=
power management: ts ttp tm stc 100mhzsteps hwpstate=0A=
=0A=
processor	: 8=0A=
vendor_id	: AuthenticAMD=0A=
cpu family	: 16=0A=
model		: 2=0A=
model name	: Quad-Core AMD Opteron(tm) Processor 8358 SE=0A=
stepping	: 3=0A=
cpu MHz		: 2411.105=0A=
cache size	: 512 KB=0A=
physical id	: 2=0A=
siblings	: 4=0A=
core id		: 0=0A=
cpu cores	: 4=0A=
apicid		: 12=0A=
initial apicid	: 8=0A=
fpu		: yes=0A=
fpu_exception	: yes=0A=
cpuid level	: 5=0A=
wp		: yes=0A=
flags		: fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov =
pat pse36 clflush mmx fxsr sse sse2 ht syscall nx mmxext fxsr_opt =
pdpe1gb rdtscp lm 3dnowext 3dnow constant_tsc rep_good nopl pni monitor =
cx16 popcnt lahf_lm cmp_legacy svm extapic cr8_legacy abm sse4a =
misalignsse 3dnowprefetch osvw ibs=0A=
bogomips	: 4823.00=0A=
TLB size	: 1024 4K pages=0A=
clflush size	: 64=0A=
cache_alignment	: 64=0A=
address sizes	: 48 bits physical, 48 bits virtual=0A=
power management: ts ttp tm stc 100mhzsteps hwpstate=0A=
=0A=
processor	: 9=0A=
vendor_id	: AuthenticAMD=0A=
cpu family	: 16=0A=
model		: 2=0A=
model name	: Quad-Core AMD Opteron(tm) Processor 8358 SE=0A=
stepping	: 3=0A=
cpu MHz		: 2411.105=0A=
cache size	: 512 KB=0A=
physical id	: 2=0A=
siblings	: 4=0A=
core id		: 1=0A=
cpu cores	: 4=0A=
apicid		: 13=0A=
initial apicid	: 9=0A=
fpu		: yes=0A=
fpu_exception	: yes=0A=
cpuid level	: 5=0A=
wp		: yes=0A=
flags		: fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov =
pat pse36 clflush mmx fxsr sse sse2 ht syscall nx mmxext fxsr_opt =
pdpe1gb rdtscp lm 3dnowext 3dnow constant_tsc rep_good nopl pni monitor =
cx16 popcnt lahf_lm cmp_legacy svm extapic cr8_legacy abm sse4a =
misalignsse 3dnowprefetch osvw ibs=0A=
bogomips	: 4824.39=0A=
TLB size	: 1024 4K pages=0A=
clflush size	: 64=0A=
cache_alignment	: 64=0A=
address sizes	: 48 bits physical, 48 bits virtual=0A=
power management: ts ttp tm stc 100mhzsteps hwpstate=0A=
=0A=
processor	: 10=0A=
vendor_id	: AuthenticAMD=0A=
cpu family	: 16=0A=
model		: 2=0A=
model name	: Quad-Core AMD Opteron(tm) Processor 8358 SE=0A=
stepping	: 3=0A=
cpu MHz		: 2411.105=0A=
cache size	: 512 KB=0A=
physical id	: 2=0A=
siblings	: 4=0A=
core id		: 2=0A=
cpu cores	: 4=0A=
apicid		: 14=0A=
initial apicid	: 10=0A=
fpu		: yes=0A=
fpu_exception	: yes=0A=
cpuid level	: 5=0A=
wp		: yes=0A=
flags		: fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov =
pat pse36 clflush mmx fxsr sse sse2 ht syscall nx mmxext fxsr_opt =
pdpe1gb rdtscp lm 3dnowext 3dnow constant_tsc rep_good nopl pni monitor =
cx16 popcnt lahf_lm cmp_legacy svm extapic cr8_legacy abm sse4a =
misalignsse 3dnowprefetch osvw ibs=0A=
bogomips	: 4822.59=0A=
TLB size	: 1024 4K pages=0A=
clflush size	: 64=0A=
cache_alignment	: 64=0A=
address sizes	: 48 bits physical, 48 bits virtual=0A=
power management: ts ttp tm stc 100mhzsteps hwpstate=0A=
=0A=
processor	: 11=0A=
vendor_id	: AuthenticAMD=0A=
cpu family	: 16=0A=
model		: 2=0A=
model name	: Quad-Core AMD Opteron(tm) Processor 8358 SE=0A=
stepping	: 3=0A=
cpu MHz		: 2411.105=0A=
cache size	: 512 KB=0A=
physical id	: 2=0A=
siblings	: 4=0A=
core id		: 3=0A=
cpu cores	: 4=0A=
apicid		: 15=0A=
initial apicid	: 11=0A=
fpu		: yes=0A=
fpu_exception	: yes=0A=
cpuid level	: 5=0A=
wp		: yes=0A=
flags		: fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov =
pat pse36 clflush mmx fxsr sse sse2 ht syscall nx mmxext fxsr_opt =
pdpe1gb rdtscp lm 3dnowext 3dnow constant_tsc rep_good nopl pni monitor =
cx16 popcnt lahf_lm cmp_legacy svm extapic cr8_legacy abm sse4a =
misalignsse 3dnowprefetch osvw ibs=0A=
bogomips	: 4822.87=0A=
TLB size	: 1024 4K pages=0A=
clflush size	: 64=0A=
cache_alignment	: 64=0A=
address sizes	: 48 bits physical, 48 bits virtual=0A=
power management: ts ttp tm stc 100mhzsteps hwpstate=0A=
=0A=
processor	: 12=0A=
vendor_id	: AuthenticAMD=0A=
cpu family	: 16=0A=
model		: 2=0A=
model name	: Quad-Core AMD Opteron(tm) Processor 8358 SE=0A=
stepping	: 3=0A=
cpu MHz		: 2411.105=0A=
cache size	: 512 KB=0A=
physical id	: 3=0A=
siblings	: 4=0A=
core id		: 0=0A=
cpu cores	: 4=0A=
apicid		: 16=0A=
initial apicid	: 12=0A=
fpu		: yes=0A=
fpu_exception	: yes=0A=
cpuid level	: 5=0A=
wp		: yes=0A=
flags		: fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov =
pat pse36 clflush mmx fxsr sse sse2 ht syscall nx mmxext fxsr_opt =
pdpe1gb rdtscp lm 3dnowext 3dnow constant_tsc rep_good nopl pni monitor =
cx16 popcnt lahf_lm cmp_legacy svm extapic cr8_legacy abm sse4a =
misalignsse 3dnowprefetch osvw ibs=0A=
bogomips	: 4822.26=0A=
TLB size	: 1024 4K pages=0A=
clflush size	: 64=0A=
cache_alignment	: 64=0A=
address sizes	: 48 bits physical, 48 bits virtual=0A=
power management: ts ttp tm stc 100mhzsteps hwpstate=0A=
=0A=
processor	: 13=0A=
vendor_id	: AuthenticAMD=0A=
cpu family	: 16=0A=
model		: 2=0A=
model name	: Quad-Core AMD Opteron(tm) Processor 8358 SE=0A=
stepping	: 3=0A=
cpu MHz		: 2411.105=0A=
cache size	: 512 KB=0A=
physical id	: 3=0A=
siblings	: 4=0A=
core id		: 1=0A=
cpu cores	: 4=0A=
apicid		: 17=0A=
initial apicid	: 13=0A=
fpu		: yes=0A=
fpu_exception	: yes=0A=
cpuid level	: 5=0A=
wp		: yes=0A=
flags		: fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov =
pat pse36 clflush mmx fxsr sse sse2 ht syscall nx mmxext fxsr_opt =
pdpe1gb rdtscp lm 3dnowext 3dnow constant_tsc rep_good nopl pni monitor =
cx16 popcnt lahf_lm cmp_legacy svm extapic cr8_legacy abm sse4a =
misalignsse 3dnowprefetch osvw ibs=0A=
bogomips	: 4822.27=0A=
TLB size	: 1024 4K pages=0A=
clflush size	: 64=0A=
cache_alignment	: 64=0A=
address sizes	: 48 bits physical, 48 bits virtual=0A=
power management: ts ttp tm stc 100mhzsteps hwpstate=0A=
=0A=
processor	: 14=0A=
vendor_id	: AuthenticAMD=0A=
cpu family	: 16=0A=
model		: 2=0A=
model name	: Quad-Core AMD Opteron(tm) Processor 8358 SE=0A=
stepping	: 3=0A=
cpu MHz		: 2411.105=0A=
cache size	: 512 KB=0A=
physical id	: 3=0A=
siblings	: 4=0A=
core id		: 2=0A=
cpu cores	: 4=0A=
apicid		: 18=0A=
initial apicid	: 14=0A=
fpu		: yes=0A=
fpu_exception	: yes=0A=
cpuid level	: 5=0A=
wp		: yes=0A=
flags		: fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov =
pat pse36 clflush mmx fxsr sse sse2 ht syscall nx mmxext fxsr_opt =
pdpe1gb rdtscp lm 3dnowext 3dnow constant_tsc rep_good nopl pni monitor =
cx16 popcnt lahf_lm cmp_legacy svm extapic cr8_legacy abm sse4a =
misalignsse 3dnowprefetch osvw ibs=0A=
bogomips	: 4822.26=0A=
TLB size	: 1024 4K pages=0A=
clflush size	: 64=0A=
cache_alignment	: 64=0A=
address sizes	: 48 bits physical, 48 bits virtual=0A=
power management: ts ttp tm stc 100mhzsteps hwpstate=0A=
=0A=
processor	: 15=0A=
vendor_id	: AuthenticAMD=0A=
cpu family	: 16=0A=
model		: 2=0A=
model name	: Quad-Core AMD Opteron(tm) Processor 8358 SE=0A=
stepping	: 3=0A=
cpu MHz		: 2411.105=0A=
cache size	: 512 KB=0A=
physical id	: 3=0A=
siblings	: 4=0A=
core id		: 3=0A=
cpu cores	: 4=0A=
apicid		: 19=0A=
initial apicid	: 15=0A=
fpu		: yes=0A=
fpu_exception	: yes=0A=
cpuid level	: 5=0A=
wp		: yes=0A=
flags		: fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov =
pat pse36 clflush mmx fxsr sse sse2 ht syscall nx mmxext fxsr_opt =
pdpe1gb rdtscp lm 3dnowext 3dnow constant_tsc rep_good nopl pni monitor =
cx16 popcnt lahf_lm cmp_legacy svm extapic cr8_legacy abm sse4a =
misalignsse 3dnowprefetch osvw ibs=0A=
bogomips	: 4822.26=0A=
TLB size	: 1024 4K pages=0A=
clflush size	: 64=0A=
cache_alignment	: 64=0A=
address sizes	: 48 bits physical, 48 bits virtual=0A=
power management: ts ttp tm stc 100mhzsteps hwpstate=0A=
=0A=
processor	: 16=0A=
vendor_id	: AuthenticAMD=0A=
cpu family	: 16=0A=
model		: 2=0A=
model name	: Quad-Core AMD Opteron(tm) Processor 8358 SE=0A=
stepping	: 3=0A=
cpu MHz		: 2411.105=0A=
cache size	: 512 KB=0A=
physical id	: 4=0A=
siblings	: 4=0A=
core id		: 0=0A=
cpu cores	: 4=0A=
apicid		: 20=0A=
initial apicid	: 16=0A=
fpu		: yes=0A=
fpu_exception	: yes=0A=
cpuid level	: 5=0A=
wp		: yes=0A=
flags		: fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov =
pat pse36 clflush mmx fxsr sse sse2 ht syscall nx mmxext fxsr_opt =
pdpe1gb rdtscp lm 3dnowext 3dnow constant_tsc rep_good nopl pni monitor =
cx16 popcnt lahf_lm cmp_legacy svm extapic cr8_legacy abm sse4a =
misalignsse 3dnowprefetch osvw ibs=0A=
bogomips	: 4822.29=0A=
TLB size	: 1024 4K pages=0A=
clflush size	: 64=0A=
cache_alignment	: 64=0A=
address sizes	: 48 bits physical, 48 bits virtual=0A=
power management: ts ttp tm stc 100mhzsteps hwpstate=0A=
=0A=
processor	: 17=0A=
vendor_id	: AuthenticAMD=0A=
cpu family	: 16=0A=
model		: 2=0A=
model name	: Quad-Core AMD Opteron(tm) Processor 8358 SE=0A=
stepping	: 3=0A=
cpu MHz		: 2411.105=0A=
cache size	: 512 KB=0A=
physical id	: 4=0A=
siblings	: 4=0A=
core id		: 1=0A=
cpu cores	: 4=0A=
apicid		: 21=0A=
initial apicid	: 17=0A=
fpu		: yes=0A=
fpu_exception	: yes=0A=
cpuid level	: 5=0A=
wp		: yes=0A=
flags		: fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov =
pat pse36 clflush mmx fxsr sse sse2 ht syscall nx mmxext fxsr_opt =
pdpe1gb rdtscp lm 3dnowext 3dnow constant_tsc rep_good nopl pni monitor =
cx16 popcnt lahf_lm cmp_legacy svm extapic cr8_legacy abm sse4a =
misalignsse 3dnowprefetch osvw ibs=0A=
bogomips	: 4822.27=0A=
TLB size	: 1024 4K pages=0A=
clflush size	: 64=0A=
cache_alignment	: 64=0A=
address sizes	: 48 bits physical, 48 bits virtual=0A=
power management: ts ttp tm stc 100mhzsteps hwpstate=0A=
=0A=
processor	: 18=0A=
vendor_id	: AuthenticAMD=0A=
cpu family	: 16=0A=
model		: 2=0A=
model name	: Quad-Core AMD Opteron(tm) Processor 8358 SE=0A=
stepping	: 3=0A=
cpu MHz		: 2411.105=0A=
cache size	: 512 KB=0A=
physical id	: 4=0A=
siblings	: 4=0A=
core id		: 2=0A=
cpu cores	: 4=0A=
apicid		: 22=0A=
initial apicid	: 18=0A=
fpu		: yes=0A=
fpu_exception	: yes=0A=
cpuid level	: 5=0A=
wp		: yes=0A=
flags		: fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov =
pat pse36 clflush mmx fxsr sse sse2 ht syscall nx mmxext fxsr_opt =
pdpe1gb rdtscp lm 3dnowext 3dnow constant_tsc rep_good nopl pni monitor =
cx16 popcnt lahf_lm cmp_legacy svm extapic cr8_legacy abm sse4a =
misalignsse 3dnowprefetch osvw ibs=0A=
bogomips	: 4822.27=0A=
TLB size	: 1024 4K pages=0A=
clflush size	: 64=0A=
cache_alignment	: 64=0A=
address sizes	: 48 bits physical, 48 bits virtual=0A=
power management: ts ttp tm stc 100mhzsteps hwpstate=0A=
=0A=
processor	: 19=0A=
vendor_id	: AuthenticAMD=0A=
cpu family	: 16=0A=
model		: 2=0A=
model name	: Quad-Core AMD Opteron(tm) Processor 8358 SE=0A=
stepping	: 3=0A=
cpu MHz		: 2411.105=0A=
cache size	: 512 KB=0A=
physical id	: 4=0A=
siblings	: 4=0A=
core id		: 3=0A=
cpu cores	: 4=0A=
apicid		: 23=0A=
initial apicid	: 19=0A=
fpu		: yes=0A=
fpu_exception	: yes=0A=
cpuid level	: 5=0A=
wp		: yes=0A=
flags		: fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov =
pat pse36 clflush mmx fxsr sse sse2 ht syscall nx mmxext fxsr_opt =
pdpe1gb rdtscp lm 3dnowext 3dnow constant_tsc rep_good nopl pni monitor =
cx16 popcnt lahf_lm cmp_legacy svm extapic cr8_legacy abm sse4a =
misalignsse 3dnowprefetch osvw ibs=0A=
bogomips	: 4821.94=0A=
TLB size	: 1024 4K pages=0A=
clflush size	: 64=0A=
cache_alignment	: 64=0A=
address sizes	: 48 bits physical, 48 bits virtual=0A=
power management: ts ttp tm stc 100mhzsteps hwpstate=0A=
=0A=
processor	: 20=0A=
vendor_id	: AuthenticAMD=0A=
cpu family	: 16=0A=
model		: 2=0A=
model name	: Quad-Core AMD Opteron(tm) Processor 8358 SE=0A=
stepping	: 3=0A=
cpu MHz		: 2411.105=0A=
cache size	: 512 KB=0A=
physical id	: 5=0A=
siblings	: 4=0A=
core id		: 0=0A=
cpu cores	: 4=0A=
apicid		: 24=0A=
initial apicid	: 20=0A=
fpu		: yes=0A=
fpu_exception	: yes=0A=
cpuid level	: 5=0A=
wp		: yes=0A=
flags		: fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov =
pat pse36 clflush mmx fxsr sse sse2 ht syscall nx mmxext fxsr_opt =
pdpe1gb rdtscp lm 3dnowext 3dnow constant_tsc rep_good nopl pni monitor =
cx16 popcnt lahf_lm cmp_legacy svm extapic cr8_legacy abm sse4a =
misalignsse 3dnowprefetch osvw ibs=0A=
bogomips	: 4822.55=0A=
TLB size	: 1024 4K pages=0A=
clflush size	: 64=0A=
cache_alignment	: 64=0A=
address sizes	: 48 bits physical, 48 bits virtual=0A=
power management: ts ttp tm stc 100mhzsteps hwpstate=0A=
=0A=
processor	: 21=0A=
vendor_id	: AuthenticAMD=0A=
cpu family	: 16=0A=
model		: 2=0A=
model name	: Quad-Core AMD Opteron(tm) Processor 8358 SE=0A=
stepping	: 3=0A=
cpu MHz		: 2411.105=0A=
cache size	: 512 KB=0A=
physical id	: 5=0A=
siblings	: 4=0A=
core id		: 1=0A=
cpu cores	: 4=0A=
apicid		: 25=0A=
initial apicid	: 21=0A=
fpu		: yes=0A=
fpu_exception	: yes=0A=
cpuid level	: 5=0A=
wp		: yes=0A=
flags		: fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov =
pat pse36 clflush mmx fxsr sse sse2 ht syscall nx mmxext fxsr_opt =
pdpe1gb rdtscp lm 3dnowext 3dnow constant_tsc rep_good nopl pni monitor =
cx16 popcnt lahf_lm cmp_legacy svm extapic cr8_legacy abm sse4a =
misalignsse 3dnowprefetch osvw ibs=0A=
bogomips	: 4822.08=0A=
TLB size	: 1024 4K pages=0A=
clflush size	: 64=0A=
cache_alignment	: 64=0A=
address sizes	: 48 bits physical, 48 bits virtual=0A=
power management: ts ttp tm stc 100mhzsteps hwpstate=0A=
=0A=
processor	: 22=0A=
vendor_id	: AuthenticAMD=0A=
cpu family	: 16=0A=
model		: 2=0A=
model name	: Quad-Core AMD Opteron(tm) Processor 8358 SE=0A=
stepping	: 3=0A=
cpu MHz		: 2411.105=0A=
cache size	: 512 KB=0A=
physical id	: 5=0A=
siblings	: 4=0A=
core id		: 2=0A=
cpu cores	: 4=0A=
apicid		: 26=0A=
initial apicid	: 22=0A=
fpu		: yes=0A=
fpu_exception	: yes=0A=
cpuid level	: 5=0A=
wp		: yes=0A=
flags		: fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov =
pat pse36 clflush mmx fxsr sse sse2 ht syscall nx mmxext fxsr_opt =
pdpe1gb rdtscp lm 3dnowext 3dnow constant_tsc rep_good nopl pni monitor =
cx16 popcnt lahf_lm cmp_legacy svm extapic cr8_legacy abm sse4a =
misalignsse 3dnowprefetch osvw ibs=0A=
bogomips	: 4822.35=0A=
TLB size	: 1024 4K pages=0A=
clflush size	: 64=0A=
cache_alignment	: 64=0A=
address sizes	: 48 bits physical, 48 bits virtual=0A=
power management: ts ttp tm stc 100mhzsteps hwpstate=0A=
=0A=
processor	: 23=0A=
vendor_id	: AuthenticAMD=0A=
cpu family	: 16=0A=
model		: 2=0A=
model name	: Quad-Core AMD Opteron(tm) Processor 8358 SE=0A=
stepping	: 3=0A=
cpu MHz		: 2411.105=0A=
cache size	: 512 KB=0A=
physical id	: 5=0A=
siblings	: 4=0A=
core id		: 3=0A=
cpu cores	: 4=0A=
apicid		: 27=0A=
initial apicid	: 23=0A=
fpu		: yes=0A=
fpu_exception	: yes=0A=
cpuid level	: 5=0A=
wp		: yes=0A=
flags		: fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov =
pat pse36 clflush mmx fxsr sse sse2 ht syscall nx mmxext fxsr_opt =
pdpe1gb rdtscp lm 3dnowext 3dnow constant_tsc rep_good nopl pni monitor =
cx16 popcnt lahf_lm cmp_legacy svm extapic cr8_legacy abm sse4a =
misalignsse 3dnowprefetch osvw ibs=0A=
bogomips	: 4823.35=0A=
TLB size	: 1024 4K pages=0A=
clflush size	: 64=0A=
cache_alignment	: 64=0A=
address sizes	: 48 bits physical, 48 bits virtual=0A=
power management: ts ttp tm stc 100mhzsteps hwpstate=0A=
=0A=
processor	: 24=0A=
vendor_id	: AuthenticAMD=0A=
cpu family	: 16=0A=
model		: 2=0A=
model name	: Quad-Core AMD Opteron(tm) Processor 8358 SE=0A=
stepping	: 3=0A=
cpu MHz		: 2411.105=0A=
cache size	: 512 KB=0A=
physical id	: 6=0A=
siblings	: 4=0A=
core id		: 0=0A=
cpu cores	: 4=0A=
apicid		: 28=0A=
initial apicid	: 24=0A=
fpu		: yes=0A=
fpu_exception	: yes=0A=
cpuid level	: 5=0A=
wp		: yes=0A=
flags		: fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov =
pat pse36 clflush mmx fxsr sse sse2 ht syscall nx mmxext fxsr_opt =
pdpe1gb rdtscp lm 3dnowext 3dnow constant_tsc rep_good nopl pni monitor =
cx16 popcnt lahf_lm cmp_legacy svm extapic cr8_legacy abm sse4a =
misalignsse 3dnowprefetch osvw ibs=0A=
bogomips	: 4824.25=0A=
TLB size	: 1024 4K pages=0A=
clflush size	: 64=0A=
cache_alignment	: 64=0A=
address sizes	: 48 bits physical, 48 bits virtual=0A=
power management: ts ttp tm stc 100mhzsteps hwpstate=0A=
=0A=
processor	: 25=0A=
vendor_id	: AuthenticAMD=0A=
cpu family	: 16=0A=
model		: 2=0A=
model name	: Quad-Core AMD Opteron(tm) Processor 8358 SE=0A=
stepping	: 3=0A=
cpu MHz		: 2411.105=0A=
cache size	: 512 KB=0A=
physical id	: 6=0A=
siblings	: 4=0A=
core id		: 1=0A=
cpu cores	: 4=0A=
apicid		: 29=0A=
initial apicid	: 25=0A=
fpu		: yes=0A=
fpu_exception	: yes=0A=
cpuid level	: 5=0A=
wp		: yes=0A=
flags		: fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov =
pat pse36 clflush mmx fxsr sse sse2 ht syscall nx mmxext fxsr_opt =
pdpe1gb rdtscp lm 3dnowext 3dnow constant_tsc rep_good nopl pni monitor =
cx16 popcnt lahf_lm cmp_legacy svm extapic cr8_legacy abm sse4a =
misalignsse 3dnowprefetch osvw ibs=0A=
bogomips	: 4824.03=0A=
TLB size	: 1024 4K pages=0A=
clflush size	: 64=0A=
cache_alignment	: 64=0A=
address sizes	: 48 bits physical, 48 bits virtual=0A=
power management: ts ttp tm stc 100mhzsteps hwpstate=0A=
=0A=
processor	: 26=0A=
vendor_id	: AuthenticAMD=0A=
cpu family	: 16=0A=
model		: 2=0A=
model name	: Quad-Core AMD Opteron(tm) Processor 8358 SE=0A=
stepping	: 3=0A=
cpu MHz		: 2411.105=0A=
cache size	: 512 KB=0A=
physical id	: 6=0A=
siblings	: 4=0A=
core id		: 2=0A=
cpu cores	: 4=0A=
apicid		: 30=0A=
initial apicid	: 26=0A=
fpu		: yes=0A=
fpu_exception	: yes=0A=
cpuid level	: 5=0A=
wp		: yes=0A=
flags		: fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov =
pat pse36 clflush mmx fxsr sse sse2 ht syscall nx mmxext fxsr_opt =
pdpe1gb rdtscp lm 3dnowext 3dnow constant_tsc rep_good nopl pni monitor =
cx16 popcnt lahf_lm cmp_legacy svm extapic cr8_legacy abm sse4a =
misalignsse 3dnowprefetch osvw ibs=0A=
bogomips	: 4822.24=0A=
TLB size	: 1024 4K pages=0A=
clflush size	: 64=0A=
cache_alignment	: 64=0A=
address sizes	: 48 bits physical, 48 bits virtual=0A=
power management: ts ttp tm stc 100mhzsteps hwpstate=0A=
=0A=
processor	: 27=0A=
vendor_id	: AuthenticAMD=0A=
cpu family	: 16=0A=
model		: 2=0A=
model name	: Quad-Core AMD Opteron(tm) Processor 8358 SE=0A=
stepping	: 3=0A=
cpu MHz		: 2411.105=0A=
cache size	: 512 KB=0A=
physical id	: 6=0A=
siblings	: 4=0A=
core id		: 3=0A=
cpu cores	: 4=0A=
apicid		: 31=0A=
initial apicid	: 27=0A=
fpu		: yes=0A=
fpu_exception	: yes=0A=
cpuid level	: 5=0A=
wp		: yes=0A=
flags		: fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov =
pat pse36 clflush mmx fxsr sse sse2 ht syscall nx mmxext fxsr_opt =
pdpe1gb rdtscp lm 3dnowext 3dnow constant_tsc rep_good nopl pni monitor =
cx16 popcnt lahf_lm cmp_legacy svm extapic cr8_legacy abm sse4a =
misalignsse 3dnowprefetch osvw ibs=0A=
bogomips	: 4822.20=0A=
TLB size	: 1024 4K pages=0A=
clflush size	: 64=0A=
cache_alignment	: 64=0A=
address sizes	: 48 bits physical, 48 bits virtual=0A=
power management: ts ttp tm stc 100mhzsteps hwpstate=0A=
=0A=
processor	: 28=0A=
vendor_id	: AuthenticAMD=0A=
cpu family	: 16=0A=
model		: 2=0A=
model name	: Quad-Core AMD Opteron(tm) Processor 8358 SE=0A=
stepping	: 3=0A=
cpu MHz		: 2411.105=0A=
cache size	: 512 KB=0A=
physical id	: 7=0A=
siblings	: 4=0A=
core id		: 0=0A=
cpu cores	: 4=0A=
apicid		: 32=0A=
initial apicid	: 28=0A=
fpu		: yes=0A=
fpu_exception	: yes=0A=
cpuid level	: 5=0A=
wp		: yes=0A=
flags		: fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov =
pat pse36 clflush mmx fxsr sse sse2 ht syscall nx mmxext fxsr_opt =
pdpe1gb rdtscp lm 3dnowext 3dnow constant_tsc rep_good nopl pni monitor =
cx16 popcnt lahf_lm cmp_legacy svm extapic cr8_legacy abm sse4a =
misalignsse 3dnowprefetch osvw ibs=0A=
bogomips	: 4822.95=0A=
TLB size	: 1024 4K pages=0A=
clflush size	: 64=0A=
cache_alignment	: 64=0A=
address sizes	: 48 bits physical, 48 bits virtual=0A=
power management: ts ttp tm stc 100mhzsteps hwpstate=0A=
=0A=
processor	: 29=0A=
vendor_id	: AuthenticAMD=0A=
cpu family	: 16=0A=
model		: 2=0A=
model name	: Quad-Core AMD Opteron(tm) Processor 8358 SE=0A=
stepping	: 3=0A=
cpu MHz		: 2411.105=0A=
cache size	: 512 KB=0A=
physical id	: 7=0A=
siblings	: 4=0A=
core id		: 1=0A=
cpu cores	: 4=0A=
apicid		: 33=0A=
initial apicid	: 29=0A=
fpu		: yes=0A=
fpu_exception	: yes=0A=
cpuid level	: 5=0A=
wp		: yes=0A=
flags		: fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov =
pat pse36 clflush mmx fxsr sse sse2 ht syscall nx mmxext fxsr_opt =
pdpe1gb rdtscp lm 3dnowext 3dnow constant_tsc rep_good nopl pni monitor =
cx16 popcnt lahf_lm cmp_legacy svm extapic cr8_legacy abm sse4a =
misalignsse 3dnowprefetch osvw ibs=0A=
bogomips	: 4822.31=0A=
TLB size	: 1024 4K pages=0A=
clflush size	: 64=0A=
cache_alignment	: 64=0A=
address sizes	: 48 bits physical, 48 bits virtual=0A=
power management: ts ttp tm stc 100mhzsteps hwpstate=0A=
=0A=
processor	: 30=0A=
vendor_id	: AuthenticAMD=0A=
cpu family	: 16=0A=
model		: 2=0A=
model name	: Quad-Core AMD Opteron(tm) Processor 8358 SE=0A=
stepping	: 3=0A=
cpu MHz		: 2411.105=0A=
cache size	: 512 KB=0A=
physical id	: 7=0A=
siblings	: 4=0A=
core id		: 2=0A=
cpu cores	: 4=0A=
apicid		: 34=0A=
initial apicid	: 30=0A=
fpu		: yes=0A=
fpu_exception	: yes=0A=
cpuid level	: 5=0A=
wp		: yes=0A=
flags		: fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov =
pat pse36 clflush mmx fxsr sse sse2 ht syscall nx mmxext fxsr_opt =
pdpe1gb rdtscp lm 3dnowext 3dnow constant_tsc rep_good nopl pni monitor =
cx16 popcnt lahf_lm cmp_legacy svm extapic cr8_legacy abm sse4a =
misalignsse 3dnowprefetch osvw ibs=0A=
bogomips	: 4822.22=0A=
TLB size	: 1024 4K pages=0A=
clflush size	: 64=0A=
cache_alignment	: 64=0A=
address sizes	: 48 bits physical, 48 bits virtual=0A=
power management: ts ttp tm stc 100mhzsteps hwpstate=0A=
=0A=
processor	: 31=0A=
vendor_id	: AuthenticAMD=0A=
cpu family	: 16=0A=
model		: 2=0A=
model name	: Quad-Core AMD Opteron(tm) Processor 8358 SE=0A=
stepping	: 3=0A=
cpu MHz		: 2411.105=0A=
cache size	: 512 KB=0A=
physical id	: 7=0A=
siblings	: 4=0A=
core id		: 3=0A=
cpu cores	: 4=0A=
apicid		: 35=0A=
initial apicid	: 31=0A=
fpu		: yes=0A=
fpu_exception	: yes=0A=
cpuid level	: 5=0A=
wp		: yes=0A=
flags		: fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov =
pat pse36 clflush mmx fxsr sse sse2 ht syscall nx mmxext fxsr_opt =
pdpe1gb rdtscp lm 3dnowext 3dnow constant_tsc rep_good nopl pni monitor =
cx16 popcnt lahf_lm cmp_legacy svm extapic cr8_legacy abm sse4a =
misalignsse 3dnowprefetch osvw ibs=0A=
bogomips	: 4822.20=0A=
TLB size	: 1024 4K pages=0A=
clflush size	: 64=0A=
cache_alignment	: 64=0A=
address sizes	: 48 bits physical, 48 bits virtual=0A=
power management: ts ttp tm stc 100mhzsteps hwpstate=0A=
=0A=

------=_NextPart_000_0008_01C96446.FF58FC80
Content-Type: text/plain;
	name="lspci.txt"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment;
	filename="lspci.txt"

00:00.0 Memory controller: nVidia Corporation CK804 Memory Controller =
(rev a4)=0A=
	Subsystem: Tyan Computer Unknown device 4985=0A=
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- =
Stepping- SERR- FastB2B- DisINTx-=0A=
	Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=3Dfast >TAbort- =
<TAbort- <MAbort- >SERR- <PERR- INTx-=0A=
	Latency: 0=0A=
	Capabilities: [44] HyperTransport: Slave or Primary Interface=0A=
		Command: BaseUnitID=3D0 UnitCnt=3D15 MastHost- DefDir- DUL-=0A=
		Link Control 0: CFlE+ CST- CFE- <LkFail- Init+ EOC- TXO- <CRCErr=3D0 =
IsocEn- LSEn- ExtCTL- 64b-=0A=
		Link Config 0: MLWI=3D16bit DwFcIn- MLWO=3D16bit DwFcOut- LWI=3D16bit =
DwFcInEn- LWO=3D16bit DwFcOutEn-=0A=
		Link Control 1: CFlE- CST- CFE- <LkFail+ Init- EOC+ TXO+ <CRCErr=3D0 =
IsocEn- LSEn- ExtCTL- 64b-=0A=
		Link Config 1: MLWI=3D8bit DwFcIn- MLWO=3D8bit DwFcOut- LWI=3D8bit =
DwFcInEn- LWO=3D8bit DwFcOutEn-=0A=
		Revision ID: 1.03=0A=
		Link Frequency 0: 1.0GHz=0A=
		Link Error 0: <Prot- <Ovfl- <EOC- CTLTm-=0A=
		Link Frequency Capability 0: 200MHz+ 300MHz+ 400MHz+ 500MHz+ 600MHz+ =
800MHz+ 1.0GHz+ 1.2GHz- 1.4GHz- 1.6GHz- Vend-=0A=
		Feature Capability: IsocFC+ LDTSTOP+ CRCTM- ECTLT- 64bA- UIDRD-=0A=
		Link Frequency 1: 200MHz=0A=
		Link Error 1: <Prot- <Ovfl- <EOC- CTLTm-=0A=
		Link Frequency Capability 1: 200MHz- 300MHz- 400MHz- 500MHz- 600MHz- =
800MHz- 1.0GHz- 1.2GHz- 1.4GHz- 1.6GHz- Vend-=0A=
		Error Handling: PFlE+ OFlE+ PFE- OFE- EOCFE- RFE- CRCFE- SERRFE- CF- =
RE- PNFE- ONFE- EOCNFE- RNFE- CRCNFE- SERRNFE-=0A=
		Prefetchable memory behind bridge Upper: 00-00=0A=
		Bus Number: 00=0A=
	Capabilities: [e0] HyperTransport: MSI Mapping Enable+ Fixed-=0A=
		Mapping Address Base: 00000000fee00000=0A=
=0A=
00:01.0 ISA bridge: nVidia Corporation CK804 ISA Bridge (rev f1)=0A=
	Subsystem: Tyan Computer Unknown device 4985=0A=
	Control: I/O+ Mem+ BusMaster+ SpecCycle+ MemWINV- VGASnoop- ParErr- =
Stepping- SERR- FastB2B- DisINTx-=0A=
	Status: Cap- 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=3Dfast >TAbort- =
<TAbort- <MAbort- >SERR- <PERR- INTx-=0A=
	Latency: 0=0A=
	Kernel modules: ck804xrom=0A=
=0A=
00:01.1 SMBus: nVidia Corporation CK804 SMBus (rev a2)=0A=
	Subsystem: Tyan Computer Unknown device 4985=0A=
	Control: I/O+ Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- =
Stepping- SERR- FastB2B- DisINTx-=0A=
	Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=3Dfast >TAbort- =
<TAbort- <MAbort- >SERR- <PERR- INTx-=0A=
	Interrupt: pin A routed to IRQ 0=0A=
	Region 0: I/O ports at 1000 [size=3D32]=0A=
	Region 4: I/O ports at a000 [size=3D64]=0A=
	Region 5: I/O ports at a040 [size=3D64]=0A=
	Capabilities: [44] Power Management version 2=0A=
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=3D0mA =
PME(D0-,D1-,D2-,D3hot+,D3cold+)=0A=
		Status: D0 PME-Enable- DSel=3D0 DScale=3D0 PME-=0A=
	Kernel driver in use: nForce2_smbus=0A=
	Kernel modules: i2c-nforce2=0A=
=0A=
00:02.0 USB Controller: nVidia Corporation CK804 USB Controller (rev a2) =
(prog-if 10 [OHCI])=0A=
	Subsystem: Tyan Computer Unknown device 4985=0A=
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- =
Stepping- SERR- FastB2B- DisINTx-=0A=
	Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=3Dfast >TAbort- =
<TAbort- <MAbort- >SERR- <PERR- INTx-=0A=
	Latency: 0 (750ns min, 250ns max)=0A=
	Interrupt: pin A routed to IRQ 22=0A=
	Region 0: Memory at d4000000 (32-bit, non-prefetchable) [size=3D4K]=0A=
	Capabilities: [44] Power Management version 2=0A=
		Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=3D0mA =
PME(D0+,D1+,D2+,D3hot+,D3cold+)=0A=
		Status: D0 PME-Enable- DSel=3D0 DScale=3D0 PME-=0A=
	Kernel driver in use: ohci_hcd=0A=
	Kernel modules: ohci-hcd=0A=
=0A=
00:02.1 USB Controller: nVidia Corporation CK804 USB Controller (rev a4) =
(prog-if 20 [EHCI])=0A=
	Subsystem: Tyan Computer Unknown device 4985=0A=
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- =
Stepping- SERR- FastB2B- DisINTx-=0A=
	Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=3Dfast >TAbort- =
<TAbort- <MAbort- >SERR- <PERR- INTx-=0A=
	Latency: 0 (750ns min, 250ns max)=0A=
	Interrupt: pin B routed to IRQ 23=0A=
	Region 0: Memory at d4001000 (32-bit, non-prefetchable) [size=3D256]=0A=
	Capabilities: [44] Debug port: BAR=3D1 offset=3D0098=0A=
	Capabilities: [80] Power Management version 2=0A=
		Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=3D0mA =
PME(D0+,D1+,D2+,D3hot+,D3cold+)=0A=
		Status: D0 PME-Enable- DSel=3D0 DScale=3D0 PME-=0A=
	Kernel driver in use: ehci_hcd=0A=
	Kernel modules: ehci-hcd=0A=
=0A=
00:06.0 IDE interface: nVidia Corporation CK804 IDE (rev f3) (prog-if 8a =
[Master SecP PriP])=0A=
	Subsystem: Unknown device f0f1:4985=0A=
	Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- =
Stepping- SERR- FastB2B- DisINTx-=0A=
	Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=3Dfast >TAbort- =
<TAbort- <MAbort- >SERR- <PERR- INTx-=0A=
	Latency: 0 (750ns min, 250ns max)=0A=
	Region 0: [virtual] Memory at 000001f0 (32-bit, non-prefetchable) =
[disabled] [size=3D8]=0A=
	Region 1: [virtual] Memory at 000003f0 (type 3, non-prefetchable) =
[disabled] [size=3D1]=0A=
	Region 2: [virtual] Memory at 00000170 (32-bit, non-prefetchable) =
[disabled] [size=3D8]=0A=
	Region 3: [virtual] Memory at 00000370 (type 3, non-prefetchable) =
[disabled] [size=3D1]=0A=
	Region 4: I/O ports at 1400 [size=3D16]=0A=
	Capabilities: [44] Power Management version 2=0A=
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=3D0mA =
PME(D0-,D1-,D2-,D3hot-,D3cold-)=0A=
		Status: D0 PME-Enable- DSel=3D0 DScale=3D0 PME-=0A=
	Kernel driver in use: pata_amd=0A=
	Kernel modules: ata_generic, pata_amd, pata_acpi=0A=
=0A=
00:07.0 IDE interface: nVidia Corporation CK804 Serial ATA Controller =
(rev f3) (prog-if 85 [Master SecO PriO])=0A=
	Subsystem: Tyan Computer Unknown device 4985=0A=
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- =
Stepping- SERR- FastB2B- DisINTx-=0A=
	Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=3Dfast >TAbort- =
<TAbort- <MAbort- >SERR- <PERR- INTx-=0A=
	Latency: 0 (750ns min, 250ns max)=0A=
	Interrupt: pin A routed to IRQ 20=0A=
	Region 0: I/O ports at 1440 [size=3D8]=0A=
	Region 1: I/O ports at 1434 [size=3D4]=0A=
	Region 2: I/O ports at 1438 [size=3D8]=0A=
	Region 3: I/O ports at 1430 [size=3D4]=0A=
	Region 4: I/O ports at 1410 [size=3D16]=0A=
	Region 5: Memory at d4002000 (32-bit, non-prefetchable) [size=3D4K]=0A=
	Capabilities: [44] Power Management version 2=0A=
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=3D0mA =
PME(D0-,D1-,D2-,D3hot-,D3cold-)=0A=
		Status: D0 PME-Enable- DSel=3D0 DScale=3D0 PME-=0A=
	Kernel driver in use: sata_nv=0A=
	Kernel modules: ata_generic, pata_acpi, sata_nv=0A=
=0A=
00:08.0 IDE interface: nVidia Corporation CK804 Serial ATA Controller =
(rev f3) (prog-if 85 [Master SecO PriO])=0A=
	Subsystem: Tyan Computer Unknown device 4985=0A=
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- =
Stepping- SERR- FastB2B- DisINTx-=0A=
	Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=3Dfast >TAbort- =
<TAbort- <MAbort- >SERR- <PERR- INTx-=0A=
	Latency: 0 (750ns min, 250ns max)=0A=
	Interrupt: pin A routed to IRQ 23=0A=
	Region 0: I/O ports at 1458 [size=3D8]=0A=
	Region 1: I/O ports at 144c [size=3D4]=0A=
	Region 2: I/O ports at 1450 [size=3D8]=0A=
	Region 3: I/O ports at 1448 [size=3D4]=0A=
	Region 4: I/O ports at 1420 [size=3D16]=0A=
	Region 5: Memory at d4003000 (32-bit, non-prefetchable) [size=3D4K]=0A=
	Capabilities: [44] Power Management version 2=0A=
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=3D0mA =
PME(D0-,D1-,D2-,D3hot-,D3cold-)=0A=
		Status: D0 PME-Enable- DSel=3D0 DScale=3D0 PME-=0A=
	Kernel driver in use: sata_nv=0A=
	Kernel modules: ata_generic, pata_acpi, sata_nv=0A=
=0A=
00:09.0 PCI bridge: nVidia Corporation CK804 PCI Bridge (rev f2) =
(prog-if 01 [Subtractive decode])=0A=
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- =
Stepping- SERR- FastB2B- DisINTx-=0A=
	Status: Cap- 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=3Dfast >TAbort- =
<TAbort- <MAbort- >SERR- <PERR- INTx-=0A=
	Latency: 0=0A=
	Bus: primary=3D00, secondary=3D01, subordinate=3D01, sec-latency=3D64=0A=
	I/O behind bridge: 00002000-00002fff=0A=
	Memory behind bridge: d4100000-d41fffff=0A=
	Prefetchable memory behind bridge: d8000000-dbffffff=0A=
	Secondary status: 66MHz- FastB2B+ ParErr- DEVSEL=3Dmedium >TAbort- =
<TAbort- <MAbort+ <SERR- <PERR-=0A=
	BridgeCtl: Parity- SERR- NoISA+ VGA+ MAbort- >Reset- FastB2B-=0A=
		PriDiscTmr- SecDiscTmr+ DiscTmrStat- DiscTmrSERREn-=0A=
=0A=
00:0a.0 Bridge: nVidia Corporation CK804 Ethernet Controller (rev f3)=0A=
	Subsystem: Tyan Computer Unknown device 4985=0A=
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- =
Stepping- SERR- FastB2B- DisINTx-=0A=
	Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=3Dfast >TAbort- =
<TAbort- <MAbort- >SERR- <PERR- INTx-=0A=
	Latency: 0 (250ns min, 5000ns max)=0A=
	Interrupt: pin A routed to IRQ 21=0A=
	Region 0: Memory at d4004000 (32-bit, non-prefetchable) [size=3D4K]=0A=
	Region 1: I/O ports at 1460 [size=3D8]=0A=
	Capabilities: [44] Power Management version 2=0A=
		Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=3D0mA =
PME(D0+,D1+,D2+,D3hot+,D3cold+)=0A=
		Status: D0 PME-Enable+ DSel=3D0 DScale=3D0 PME-=0A=
	Kernel driver in use: forcedeth=0A=
	Kernel modules: forcedeth=0A=
=0A=
00:0b.0 PCI bridge: nVidia Corporation CK804 PCIE Bridge (rev f3) =
(prog-if 00 [Normal decode])=0A=
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- =
Stepping- SERR- FastB2B- DisINTx+=0A=
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=3Dfast >TAbort- =
<TAbort- <MAbort- >SERR- <PERR- INTx-=0A=
	Latency: 0, Cache Line Size: 64 bytes=0A=
	Bus: primary=3D00, secondary=3D02, subordinate=3D02, sec-latency=3D0=0A=
	I/O behind bridge: 0000f000-00000fff=0A=
	Memory behind bridge: fff00000-000fffff=0A=
	Prefetchable memory behind bridge: 00000000fff00000-00000000000fffff=0A=
	Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=3Dfast >TAbort- =
<TAbort- <MAbort- <SERR- <PERR-=0A=
	BridgeCtl: Parity- SERR- NoISA+ VGA- MAbort- >Reset- FastB2B-=0A=
		PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-=0A=
	Capabilities: [40] Power Management version 2=0A=
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=3D0mA =
PME(D0+,D1+,D2+,D3hot+,D3cold+)=0A=
		Status: D0 PME-Enable- DSel=3D0 DScale=3D0 PME-=0A=
	Capabilities: [48] Message Signalled Interrupts: Mask- 64bit+ =
Queue=3D0/1 Enable+=0A=
		Address: 00000000fee04000  Data: 4049=0A=
	Capabilities: [58] HyperTransport: MSI Mapping Enable+ Fixed-=0A=
		Mapping Address Base: 00000000fee00000=0A=
	Capabilities: [80] Express (v1) Root Port (Slot+), MSI 00=0A=
		DevCap:	MaxPayload 128 bytes, PhantFunc 0, Latency L0s <512ns, L1 <4us=0A=
			ExtTag- RBE- FLReset-=0A=
		DevCtl:	Report errors: Correctable+ Non-Fatal+ Fatal+ Unsupported+=0A=
			RlxdOrd+ ExtTag- PhantFunc- AuxPwr- NoSnoop+=0A=
			MaxPayload 128 bytes, MaxReadReq 512 bytes=0A=
		DevSta:	CorrErr- UncorrErr- FatalErr+ UnsuppReq- AuxPwr- TransPend-=0A=
		LnkCap:	Port #3, Speed 2.5GT/s, Width x0, ASPM L0s, Latency L0 <512ns, =
L1 <4us=0A=
			ClockPM- Suprise- LLActRep- BwNot-=0A=
		LnkCtl:	ASPM Disabled; RCB 64 bytes Disabled- Retrain- CommClk-=0A=
			ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-=0A=
		LnkSta:	Speed 2.5GT/s, Width x4, TrErr+ Train- SlotClk+ DLActive- =
BWMgmt- ABWMgmt-=0A=
		SltCap:	AttnBtn- PwrCtrl- MRL- AttnInd- PwrInd- HotPlug- Surpise-=0A=
			Slot #  0, PowerLimit 0.000000; Interlock- NoCompl-=0A=
		SltCtl:	Enable: AttnBtn- PwrFlt- MRL- PresDet- CmdCplt- HPIrq- LinkChg-=0A=
			Control: AttnInd Unknown, PwrInd Unknown, Power- Interlock-=0A=
		SltSta:	Status: AttnBtn- PowerFlt- MRL- CmdCplt- PresDet- Interlock-=0A=
			Changed: MRL- PresDet- LinkState-=0A=
		RootCtl: ErrCorrectable- ErrNon-Fatal- ErrFatal- PMEIntEna- CRSVisible-=0A=
		RootCap: CRSVisible-=0A=
		RootSta: PME ReqID 0000, PMEStatus- PMEPending-=0A=
	Capabilities: [100] Virtual Channel <?>=0A=
	Capabilities: [160] Advanced Error Reporting <?>=0A=
	Kernel driver in use: pcieport-driver=0A=
	Kernel modules: shpchp=0A=
=0A=
00:0c.0 PCI bridge: nVidia Corporation CK804 PCIE Bridge (rev f3) =
(prog-if 00 [Normal decode])=0A=
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- =
Stepping- SERR- FastB2B- DisINTx+=0A=
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=3Dfast >TAbort- =
<TAbort- <MAbort- >SERR- <PERR- INTx-=0A=
	Latency: 0, Cache Line Size: 64 bytes=0A=
	Bus: primary=3D00, secondary=3D03, subordinate=3D03, sec-latency=3D0=0A=
	I/O behind bridge: 0000f000-00000fff=0A=
	Memory behind bridge: fff00000-000fffff=0A=
	Prefetchable memory behind bridge: 00000000fff00000-00000000000fffff=0A=
	Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=3Dfast >TAbort- =
<TAbort- <MAbort- <SERR- <PERR-=0A=
	BridgeCtl: Parity- SERR- NoISA+ VGA- MAbort- >Reset- FastB2B-=0A=
		PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-=0A=
	Capabilities: [40] Power Management version 2=0A=
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=3D0mA =
PME(D0+,D1+,D2+,D3hot+,D3cold+)=0A=
		Status: D0 PME-Enable- DSel=3D0 DScale=3D0 PME-=0A=
	Capabilities: [48] Message Signalled Interrupts: Mask- 64bit+ =
Queue=3D0/1 Enable+=0A=
		Address: 00000000fee04000  Data: 4051=0A=
	Capabilities: [58] HyperTransport: MSI Mapping Enable+ Fixed-=0A=
		Mapping Address Base: 00000000fee00000=0A=
	Capabilities: [80] Express (v1) Root Port (Slot+), MSI 00=0A=
		DevCap:	MaxPayload 128 bytes, PhantFunc 0, Latency L0s <512ns, L1 <4us=0A=
			ExtTag- RBE- FLReset-=0A=
		DevCtl:	Report errors: Correctable+ Non-Fatal+ Fatal+ Unsupported+=0A=
			RlxdOrd+ ExtTag- PhantFunc- AuxPwr- NoSnoop+=0A=
			MaxPayload 128 bytes, MaxReadReq 512 bytes=0A=
		DevSta:	CorrErr- UncorrErr- FatalErr+ UnsuppReq- AuxPwr- TransPend-=0A=
		LnkCap:	Port #2, Speed 2.5GT/s, Width x0, ASPM L0s, Latency L0 <512ns, =
L1 <4us=0A=
			ClockPM- Suprise- LLActRep- BwNot-=0A=
		LnkCtl:	ASPM Disabled; RCB 64 bytes Disabled- Retrain- CommClk-=0A=
			ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-=0A=
		LnkSta:	Speed 2.5GT/s, Width x4, TrErr+ Train- SlotClk+ DLActive- =
BWMgmt- ABWMgmt-=0A=
		SltCap:	AttnBtn- PwrCtrl- MRL- AttnInd- PwrInd- HotPlug- Surpise-=0A=
			Slot #  0, PowerLimit 0.000000; Interlock- NoCompl-=0A=
		SltCtl:	Enable: AttnBtn- PwrFlt- MRL- PresDet- CmdCplt- HPIrq- LinkChg-=0A=
			Control: AttnInd Unknown, PwrInd Unknown, Power- Interlock-=0A=
		SltSta:	Status: AttnBtn- PowerFlt- MRL- CmdCplt- PresDet- Interlock-=0A=
			Changed: MRL- PresDet- LinkState-=0A=
		RootCtl: ErrCorrectable- ErrNon-Fatal- ErrFatal- PMEIntEna- CRSVisible-=0A=
		RootCap: CRSVisible-=0A=
		RootSta: PME ReqID 0000, PMEStatus- PMEPending-=0A=
	Capabilities: [100] Virtual Channel <?>=0A=
	Capabilities: [160] Advanced Error Reporting <?>=0A=
	Kernel driver in use: pcieport-driver=0A=
	Kernel modules: shpchp=0A=
=0A=
00:0d.0 PCI bridge: nVidia Corporation CK804 PCIE Bridge (rev f3) =
(prog-if 00 [Normal decode])=0A=
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- =
Stepping- SERR- FastB2B- DisINTx+=0A=
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=3Dfast >TAbort- =
<TAbort- <MAbort- >SERR- <PERR- INTx-=0A=
	Latency: 0, Cache Line Size: 64 bytes=0A=
	Bus: primary=3D00, secondary=3D04, subordinate=3D04, sec-latency=3D0=0A=
	I/O behind bridge: 0000f000-00000fff=0A=
	Memory behind bridge: fff00000-000fffff=0A=
	Prefetchable memory behind bridge: 00000000fff00000-00000000000fffff=0A=
	Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=3Dfast >TAbort- =
<TAbort- <MAbort- <SERR- <PERR-=0A=
	BridgeCtl: Parity- SERR- NoISA+ VGA- MAbort- >Reset- FastB2B-=0A=
		PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-=0A=
	Capabilities: [40] Power Management version 2=0A=
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=3D0mA =
PME(D0+,D1+,D2+,D3hot+,D3cold+)=0A=
		Status: D0 PME-Enable- DSel=3D0 DScale=3D0 PME-=0A=
	Capabilities: [48] Message Signalled Interrupts: Mask- 64bit+ =
Queue=3D0/1 Enable+=0A=
		Address: 00000000fee04000  Data: 4059=0A=
	Capabilities: [58] HyperTransport: MSI Mapping Enable+ Fixed-=0A=
		Mapping Address Base: 00000000fee00000=0A=
	Capabilities: [80] Express (v1) Root Port (Slot+), MSI 00=0A=
		DevCap:	MaxPayload 128 bytes, PhantFunc 0, Latency L0s <512ns, L1 <4us=0A=
			ExtTag- RBE- FLReset-=0A=
		DevCtl:	Report errors: Correctable+ Non-Fatal+ Fatal+ Unsupported+=0A=
			RlxdOrd+ ExtTag- PhantFunc- AuxPwr- NoSnoop+=0A=
			MaxPayload 128 bytes, MaxReadReq 512 bytes=0A=
		DevSta:	CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr- TransPend-=0A=
		LnkCap:	Port #1, Speed 2.5GT/s, Width x4, ASPM L0s, Latency L0 <512ns, =
L1 <4us=0A=
			ClockPM- Suprise- LLActRep- BwNot-=0A=
		LnkCtl:	ASPM Disabled; RCB 64 bytes Disabled- Retrain- CommClk-=0A=
			ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-=0A=
		LnkSta:	Speed 2.5GT/s, Width x8, TrErr- Train- SlotClk+ DLActive- =
BWMgmt- ABWMgmt-=0A=
		SltCap:	AttnBtn- PwrCtrl- MRL- AttnInd- PwrInd- HotPlug- Surpise-=0A=
			Slot #  0, PowerLimit 0.000000; Interlock- NoCompl-=0A=
		SltCtl:	Enable: AttnBtn- PwrFlt- MRL- PresDet- CmdCplt- HPIrq- LinkChg-=0A=
			Control: AttnInd Unknown, PwrInd Unknown, Power- Interlock-=0A=
		SltSta:	Status: AttnBtn- PowerFlt- MRL- CmdCplt- PresDet- Interlock-=0A=
			Changed: MRL- PresDet- LinkState-=0A=
		RootCtl: ErrCorrectable- ErrNon-Fatal- ErrFatal- PMEIntEna- CRSVisible-=0A=
		RootCap: CRSVisible-=0A=
		RootSta: PME ReqID 0000, PMEStatus- PMEPending-=0A=
	Capabilities: [100] Virtual Channel <?>=0A=
	Capabilities: [160] Advanced Error Reporting <?>=0A=
	Kernel driver in use: pcieport-driver=0A=
	Kernel modules: shpchp=0A=
=0A=
00:0e.0 PCI bridge: nVidia Corporation CK804 PCIE Bridge (rev a3) =
(prog-if 00 [Normal decode])=0A=
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- =
Stepping- SERR- FastB2B- DisINTx+=0A=
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=3Dfast >TAbort- =
<TAbort- <MAbort- >SERR- <PERR- INTx-=0A=
	Latency: 0, Cache Line Size: 64 bytes=0A=
	Bus: primary=3D00, secondary=3D05, subordinate=3D05, sec-latency=3D0=0A=
	I/O behind bridge: 00003000-00003fff=0A=
	Memory behind bridge: d4200000-d42fffff=0A=
	Prefetchable memory behind bridge: 00000000d0000000-00000000d00fffff=0A=
	Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=3Dfast >TAbort- =
<TAbort- <MAbort- <SERR- <PERR-=0A=
	BridgeCtl: Parity- SERR- NoISA+ VGA- MAbort- >Reset- FastB2B-=0A=
		PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-=0A=
	Capabilities: [40] Power Management version 2=0A=
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=3D0mA =
PME(D0+,D1+,D2+,D3hot+,D3cold+)=0A=
		Status: D0 PME-Enable- DSel=3D0 DScale=3D0 PME-=0A=
	Capabilities: [48] Message Signalled Interrupts: Mask- 64bit+ =
Queue=3D0/1 Enable+=0A=
		Address: 00000000fee04000  Data: 4061=0A=
	Capabilities: [58] HyperTransport: MSI Mapping Enable+ Fixed-=0A=
		Mapping Address Base: 00000000fee00000=0A=
	Capabilities: [80] Express (v1) Root Port (Slot+), MSI 00=0A=
		DevCap:	MaxPayload 128 bytes, PhantFunc 0, Latency L0s <512ns, L1 <4us=0A=
			ExtTag- RBE- FLReset-=0A=
		DevCtl:	Report errors: Correctable+ Non-Fatal+ Fatal+ Unsupported+=0A=
			RlxdOrd+ ExtTag- PhantFunc- AuxPwr- NoSnoop+=0A=
			MaxPayload 128 bytes, MaxReadReq 512 bytes=0A=
		DevSta:	CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr- TransPend-=0A=
		LnkCap:	Port #0, Speed 2.5GT/s, Width x16, ASPM L0s, Latency L0 =
<512ns, L1 <4us=0A=
			ClockPM- Suprise- LLActRep- BwNot-=0A=
		LnkCtl:	ASPM Disabled; RCB 64 bytes Disabled- Retrain- CommClk-=0A=
			ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-=0A=
		LnkSta:	Speed 2.5GT/s, Width x8, TrErr- Train- SlotClk+ DLActive- =
BWMgmt- ABWMgmt-=0A=
		SltCap:	AttnBtn- PwrCtrl- MRL- AttnInd- PwrInd- HotPlug- Surpise-=0A=
			Slot #  0, PowerLimit 0.000000; Interlock- NoCompl-=0A=
		SltCtl:	Enable: AttnBtn- PwrFlt- MRL- PresDet- CmdCplt- HPIrq- LinkChg-=0A=
			Control: AttnInd Unknown, PwrInd Unknown, Power- Interlock-=0A=
		SltSta:	Status: AttnBtn- PowerFlt- MRL- CmdCplt- PresDet+ Interlock-=0A=
			Changed: MRL- PresDet+ LinkState-=0A=
		RootCtl: ErrCorrectable- ErrNon-Fatal- ErrFatal- PMEIntEna- CRSVisible-=0A=
		RootCap: CRSVisible-=0A=
		RootSta: PME ReqID 0000, PMEStatus- PMEPending-=0A=
	Capabilities: [100] Virtual Channel <?>=0A=
	Capabilities: [160] Advanced Error Reporting <?>=0A=
	Kernel driver in use: pcieport-driver=0A=
	Kernel modules: shpchp=0A=
=0A=
00:18.0 Host bridge: Advanced Micro Devices [AMD] Family 10h [Opteron, =
Athlon64, Sempron] HyperTransport Configuration=0A=
	Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- =
Stepping- SERR- FastB2B- DisINTx-=0A=
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=3Dfast >TAbort- =
<TAbort- <MAbort- >SERR- <PERR- INTx-=0A=
	Capabilities: [80] HyperTransport: Host or Secondary Interface=0A=
		Command: WarmRst+ DblEnd- DevNum=3D0 ChainSide- HostHide+ Slave- =
<EOCErr- DUL-=0A=
		Link Control: CFlE- CST- CFE- <LkFail- Init+ EOC- TXO- <CRCErr=3D0 =
IsocEn- LSEn+ ExtCTL- 64b-=0A=
		Link Config: MLWI=3D16bit DwFcIn- MLWO=3D16bit DwFcOut- LWI=3D16bit =
DwFcInEn- LWO=3D16bit DwFcOutEn-=0A=
		Revision ID: 3.00=0A=
		Link Frequency: 1.0GHz=0A=
		Link Error: <Prot- <Ovfl- <EOC- CTLTm-=0A=
		Link Frequency Capability: 200MHz+ 300MHz- 400MHz+ 500MHz- 600MHz+ =
800MHz+ 1.0GHz+ 1.2GHz- 1.4GHz- 1.6GHz- Vend-=0A=
		Feature Capability: IsocFC+ LDTSTOP+ CRCTM- ECTLT- 64bA+ UIDRD- ExtRS- =
UCnfE-=0A=
	Capabilities: [a0] HyperTransport: Host or Secondary Interface=0A=
		Command: WarmRst+ DblEnd- DevNum=3D0 ChainSide- HostHide+ Slave- =
<EOCErr- DUL-=0A=
		Link Control: CFlE- CST- CFE- <LkFail- Init+ EOC- TXO- <CRCErr=3D0 =
IsocEn- LSEn+ ExtCTL- 64b-=0A=
		Link Config: MLWI=3D16bit DwFcIn- MLWO=3D16bit DwFcOut- LWI=3D16bit =
DwFcInEn- LWO=3D16bit DwFcOutEn-=0A=
		Revision ID: 3.00=0A=
		Link Frequency: 1.0GHz=0A=
		Link Error: <Prot- <Ovfl- <EOC- CTLTm-=0A=
		Link Frequency Capability: 200MHz+ 300MHz- 400MHz+ 500MHz- 600MHz+ =
800MHz+ 1.0GHz+ 1.2GHz- 1.4GHz- 1.6GHz- Vend-=0A=
		Feature Capability: IsocFC+ LDTSTOP+ CRCTM- ECTLT- 64bA+ UIDRD- ExtRS- =
UCnfE-=0A=
	Capabilities: [c0] HyperTransport: Host or Secondary Interface=0A=
		Command: WarmRst+ DblEnd- DevNum=3D0 ChainSide- HostHide+ Slave- =
<EOCErr- DUL-=0A=
		Link Control: CFlE- CST- CFE- <LkFail- Init+ EOC- TXO- <CRCErr=3D0 =
IsocEn- LSEn+ ExtCTL- 64b-=0A=
		Link Config: MLWI=3D16bit DwFcIn- MLWO=3D16bit DwFcOut- LWI=3D16bit =
DwFcInEn- LWO=3D16bit DwFcOutEn-=0A=
		Revision ID: 3.00=0A=
		Link Frequency: 1.0GHz=0A=
		Link Error: <Prot- <Ovfl- <EOC- CTLTm-=0A=
		Link Frequency Capability: 200MHz+ 300MHz- 400MHz+ 500MHz- 600MHz+ =
800MHz+ 1.0GHz+ 1.2GHz- 1.4GHz- 1.6GHz- Vend-=0A=
		Feature Capability: IsocFC+ LDTSTOP+ CRCTM- ECTLT- 64bA+ UIDRD- ExtRS- =
UCnfE-=0A=
=0A=
00:18.1 Host bridge: Advanced Micro Devices [AMD] Family 10h [Opteron, =
Athlon64, Sempron] Address Map=0A=
	Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- =
Stepping- SERR- FastB2B- DisINTx-=0A=
	Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=3Dfast >TAbort- =
<TAbort- <MAbort- >SERR- <PERR- INTx-=0A=
=0A=
00:18.2 Host bridge: Advanced Micro Devices [AMD] Family 10h [Opteron, =
Athlon64, Sempron] DRAM Controller=0A=
	Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- =
Stepping- SERR- FastB2B- DisINTx-=0A=
	Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=3Dfast >TAbort- =
<TAbort- <MAbort- >SERR- <PERR- INTx-=0A=
=0A=
00:18.3 Host bridge: Advanced Micro Devices [AMD] Family 10h [Opteron, =
Athlon64, Sempron] Miscellaneous Control=0A=
	Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- =
Stepping- SERR- FastB2B- DisINTx-=0A=
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=3Dfast >TAbort- =
<TAbort- <MAbort- >SERR- <PERR- INTx-=0A=
	Capabilities: [f0] Secure device <?>=0A=
=0A=
00:18.4 Host bridge: Advanced Micro Devices [AMD] Family 10h [Opteron, =
Athlon64, Sempron] Link Control=0A=
	Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- =
Stepping- SERR- FastB2B- DisINTx-=0A=
	Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=3Dfast >TAbort- =
<TAbort- <MAbort- >SERR- <PERR- INTx-=0A=
=0A=
00:19.0 Host bridge: Advanced Micro Devices [AMD] Family 10h [Opteron, =
Athlon64, Sempron] HyperTransport Configuration=0A=
	Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- =
Stepping- SERR- FastB2B- DisINTx-=0A=
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=3Dfast >TAbort- =
<TAbort- <MAbort- >SERR- <PERR- INTx-=0A=
	Capabilities: [80] HyperTransport: Host or Secondary Interface=0A=
		Command: WarmRst+ DblEnd- DevNum=3D0 ChainSide- HostHide+ Slave- =
<EOCErr- DUL-=0A=
		Link Control: CFlE- CST- CFE- <LkFail- Init+ EOC- TXO- <CRCErr=3D0 =
IsocEn- LSEn+ ExtCTL- 64b-=0A=
		Link Config: MLWI=3D16bit DwFcIn- MLWO=3D16bit DwFcOut- LWI=3D16bit =
DwFcInEn- LWO=3D16bit DwFcOutEn-=0A=
		Revision ID: 3.00=0A=
		Link Frequency: 1.0GHz=0A=
		Link Error: <Prot- <Ovfl- <EOC- CTLTm-=0A=
		Link Frequency Capability: 200MHz+ 300MHz- 400MHz+ 500MHz- 600MHz+ =
800MHz+ 1.0GHz+ 1.2GHz- 1.4GHz- 1.6GHz- Vend-=0A=
		Feature Capability: IsocFC+ LDTSTOP+ CRCTM- ECTLT- 64bA+ UIDRD- ExtRS- =
UCnfE-=0A=
	Capabilities: [a0] HyperTransport: Host or Secondary Interface=0A=
		Command: WarmRst+ DblEnd- DevNum=3D0 ChainSide- HostHide+ Slave- =
<EOCErr- DUL-=0A=
		Link Control: CFlE- CST- CFE- <LkFail- Init+ EOC- TXO- <CRCErr=3D0 =
IsocEn- LSEn+ ExtCTL- 64b-=0A=
		Link Config: MLWI=3D16bit DwFcIn- MLWO=3D16bit DwFcOut- LWI=3D16bit =
DwFcInEn- LWO=3D16bit DwFcOutEn-=0A=
		Revision ID: 3.00=0A=
		Link Frequency: 1.0GHz=0A=
		Link Error: <Prot- <Ovfl- <EOC- CTLTm-=0A=
		Link Frequency Capability: 200MHz+ 300MHz- 400MHz+ 500MHz- 600MHz+ =
800MHz+ 1.0GHz+ 1.2GHz- 1.4GHz- 1.6GHz- Vend-=0A=
		Feature Capability: IsocFC+ LDTSTOP+ CRCTM- ECTLT- 64bA+ UIDRD- ExtRS- =
UCnfE-=0A=
	Capabilities: [c0] HyperTransport: Host or Secondary Interface=0A=
		Command: WarmRst+ DblEnd- DevNum=3D0 ChainSide- HostHide+ Slave- =
<EOCErr- DUL-=0A=
		Link Control: CFlE- CST- CFE- <LkFail- Init+ EOC- TXO- <CRCErr=3D0 =
IsocEn- LSEn+ ExtCTL- 64b-=0A=
		Link Config: MLWI=3D16bit DwFcIn- MLWO=3D16bit DwFcOut- LWI=3D16bit =
DwFcInEn- LWO=3D16bit DwFcOutEn-=0A=
		Revision ID: 3.00=0A=
		Link Frequency: 1.0GHz=0A=
		Link Error: <Prot- <Ovfl- <EOC- CTLTm-=0A=
		Link Frequency Capability: 200MHz+ 300MHz- 400MHz+ 500MHz- 600MHz+ =
800MHz+ 1.0GHz+ 1.2GHz- 1.4GHz- 1.6GHz- Vend-=0A=
		Feature Capability: IsocFC+ LDTSTOP+ CRCTM- ECTLT- 64bA+ UIDRD- ExtRS- =
UCnfE-=0A=
=0A=
00:19.1 Host bridge: Advanced Micro Devices [AMD] Family 10h [Opteron, =
Athlon64, Sempron] Address Map=0A=
	Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- =
Stepping- SERR- FastB2B- DisINTx-=0A=
	Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=3Dfast >TAbort- =
<TAbort- <MAbort- >SERR- <PERR- INTx-=0A=
=0A=
00:19.2 Host bridge: Advanced Micro Devices [AMD] Family 10h [Opteron, =
Athlon64, Sempron] DRAM Controller=0A=
	Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- =
Stepping- SERR- FastB2B- DisINTx-=0A=
	Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=3Dfast >TAbort- =
<TAbort- <MAbort- >SERR- <PERR- INTx-=0A=
=0A=
00:19.3 Host bridge: Advanced Micro Devices [AMD] Family 10h [Opteron, =
Athlon64, Sempron] Miscellaneous Control=0A=
	Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- =
Stepping- SERR- FastB2B- DisINTx-=0A=
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=3Dfast >TAbort- =
<TAbort- <MAbort- >SERR- <PERR- INTx-=0A=
	Capabilities: [f0] Secure device <?>=0A=
=0A=
00:19.4 Host bridge: Advanced Micro Devices [AMD] Family 10h [Opteron, =
Athlon64, Sempron] Link Control=0A=
	Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- =
Stepping- SERR- FastB2B- DisINTx-=0A=
	Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=3Dfast >TAbort- =
<TAbort- <MAbort- >SERR- <PERR- INTx-=0A=
=0A=
00:1a.0 Host bridge: Advanced Micro Devices [AMD] Family 10h [Opteron, =
Athlon64, Sempron] HyperTransport Configuration=0A=
	Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- =
Stepping- SERR- FastB2B- DisINTx-=0A=
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=3Dfast >TAbort- =
<TAbort- <MAbort- >SERR- <PERR- INTx-=0A=
	Capabilities: [80] HyperTransport: Host or Secondary Interface=0A=
		Command: WarmRst+ DblEnd- DevNum=3D0 ChainSide- HostHide+ Slave- =
<EOCErr- DUL-=0A=
		Link Control: CFlE- CST- CFE- <LkFail- Init+ EOC- TXO- <CRCErr=3D0 =
IsocEn- LSEn+ ExtCTL- 64b-=0A=
		Link Config: MLWI=3D16bit DwFcIn- MLWO=3D16bit DwFcOut- LWI=3D16bit =
DwFcInEn- LWO=3D16bit DwFcOutEn-=0A=
		Revision ID: 3.00=0A=
		Link Frequency: 1.0GHz=0A=
		Link Error: <Prot- <Ovfl- <EOC- CTLTm-=0A=
		Link Frequency Capability: 200MHz+ 300MHz- 400MHz+ 500MHz- 600MHz+ =
800MHz+ 1.0GHz+ 1.2GHz- 1.4GHz- 1.6GHz- Vend-=0A=
		Feature Capability: IsocFC+ LDTSTOP+ CRCTM- ECTLT- 64bA+ UIDRD- ExtRS- =
UCnfE-=0A=
	Capabilities: [a0] HyperTransport: Host or Secondary Interface=0A=
		Command: WarmRst+ DblEnd- DevNum=3D0 ChainSide- HostHide+ Slave- =
<EOCErr- DUL-=0A=
		Link Control: CFlE- CST- CFE- <LkFail- Init+ EOC- TXO- <CRCErr=3D0 =
IsocEn- LSEn+ ExtCTL- 64b-=0A=
		Link Config: MLWI=3D16bit DwFcIn- MLWO=3D16bit DwFcOut- LWI=3D16bit =
DwFcInEn- LWO=3D16bit DwFcOutEn-=0A=
		Revision ID: 3.00=0A=
		Link Frequency: 1.0GHz=0A=
		Link Error: <Prot- <Ovfl- <EOC- CTLTm-=0A=
		Link Frequency Capability: 200MHz+ 300MHz- 400MHz+ 500MHz- 600MHz+ =
800MHz+ 1.0GHz+ 1.2GHz- 1.4GHz- 1.6GHz- Vend-=0A=
		Feature Capability: IsocFC+ LDTSTOP+ CRCTM- ECTLT- 64bA+ UIDRD- ExtRS- =
UCnfE-=0A=
	Capabilities: [c0] HyperTransport: Host or Secondary Interface=0A=
		Command: WarmRst+ DblEnd- DevNum=3D0 ChainSide- HostHide+ Slave- =
<EOCErr- DUL-=0A=
		Link Control: CFlE- CST- CFE- <LkFail- Init+ EOC- TXO- <CRCErr=3D0 =
IsocEn- LSEn+ ExtCTL- 64b-=0A=
		Link Config: MLWI=3D16bit DwFcIn- MLWO=3D16bit DwFcOut- LWI=3D16bit =
DwFcInEn- LWO=3D16bit DwFcOutEn-=0A=
		Revision ID: 3.00=0A=
		Link Frequency: 1.0GHz=0A=
		Link Error: <Prot- <Ovfl- <EOC- CTLTm-=0A=
		Link Frequency Capability: 200MHz+ 300MHz- 400MHz+ 500MHz- 600MHz+ =
800MHz+ 1.0GHz+ 1.2GHz- 1.4GHz- 1.6GHz- Vend-=0A=
		Feature Capability: IsocFC+ LDTSTOP+ CRCTM- ECTLT- 64bA+ UIDRD- ExtRS- =
UCnfE-=0A=
=0A=
00:1a.1 Host bridge: Advanced Micro Devices [AMD] Family 10h [Opteron, =
Athlon64, Sempron] Address Map=0A=
	Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- =
Stepping- SERR- FastB2B- DisINTx-=0A=
	Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=3Dfast >TAbort- =
<TAbort- <MAbort- >SERR- <PERR- INTx-=0A=
=0A=
00:1a.2 Host bridge: Advanced Micro Devices [AMD] Family 10h [Opteron, =
Athlon64, Sempron] DRAM Controller=0A=
	Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- =
Stepping- SERR- FastB2B- DisINTx-=0A=
	Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=3Dfast >TAbort- =
<TAbort- <MAbort- >SERR- <PERR- INTx-=0A=
=0A=
00:1a.3 Host bridge: Advanced Micro Devices [AMD] Family 10h [Opteron, =
Athlon64, Sempron] Miscellaneous Control=0A=
	Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- =
Stepping- SERR- FastB2B- DisINTx-=0A=
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=3Dfast >TAbort- =
<TAbort- <MAbort- >SERR- <PERR- INTx-=0A=
	Capabilities: [f0] Secure device <?>=0A=
=0A=
00:1a.4 Host bridge: Advanced Micro Devices [AMD] Family 10h [Opteron, =
Athlon64, Sempron] Link Control=0A=
	Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- =
Stepping- SERR- FastB2B- DisINTx-=0A=
	Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=3Dfast >TAbort- =
<TAbort- <MAbort- >SERR- <PERR- INTx-=0A=
=0A=
00:1b.0 Host bridge: Advanced Micro Devices [AMD] Family 10h [Opteron, =
Athlon64, Sempron] HyperTransport Configuration=0A=
	Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- =
Stepping- SERR- FastB2B- DisINTx-=0A=
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=3Dfast >TAbort- =
<TAbort- <MAbort- >SERR- <PERR- INTx-=0A=
	Capabilities: [80] HyperTransport: Host or Secondary Interface=0A=
		Command: WarmRst+ DblEnd- DevNum=3D0 ChainSide- HostHide+ Slave- =
<EOCErr- DUL-=0A=
		Link Control: CFlE- CST- CFE- <LkFail- Init+ EOC- TXO- <CRCErr=3D0 =
IsocEn- LSEn+ ExtCTL- 64b-=0A=
		Link Config: MLWI=3D16bit DwFcIn- MLWO=3D16bit DwFcOut- LWI=3D16bit =
DwFcInEn- LWO=3D16bit DwFcOutEn-=0A=
		Revision ID: 3.00=0A=
		Link Frequency: 1.0GHz=0A=
		Link Error: <Prot- <Ovfl- <EOC- CTLTm-=0A=
		Link Frequency Capability: 200MHz+ 300MHz- 400MHz+ 500MHz- 600MHz+ =
800MHz+ 1.0GHz+ 1.2GHz- 1.4GHz- 1.6GHz- Vend-=0A=
		Feature Capability: IsocFC+ LDTSTOP+ CRCTM- ECTLT- 64bA+ UIDRD- ExtRS- =
UCnfE-=0A=
	Capabilities: [a0] HyperTransport: Host or Secondary Interface=0A=
		Command: WarmRst+ DblEnd- DevNum=3D0 ChainSide- HostHide+ Slave- =
<EOCErr- DUL-=0A=
		Link Control: CFlE- CST- CFE- <LkFail- Init+ EOC- TXO- <CRCErr=3D0 =
IsocEn- LSEn+ ExtCTL- 64b-=0A=
		Link Config: MLWI=3D16bit DwFcIn- MLWO=3D16bit DwFcOut- LWI=3D16bit =
DwFcInEn- LWO=3D16bit DwFcOutEn-=0A=
		Revision ID: 3.00=0A=
		Link Frequency: 1.0GHz=0A=
		Link Error: <Prot- <Ovfl- <EOC- CTLTm-=0A=
		Link Frequency Capability: 200MHz+ 300MHz- 400MHz+ 500MHz- 600MHz+ =
800MHz+ 1.0GHz+ 1.2GHz- 1.4GHz- 1.6GHz- Vend-=0A=
		Feature Capability: IsocFC+ LDTSTOP+ CRCTM- ECTLT- 64bA+ UIDRD- ExtRS- =
UCnfE-=0A=
	Capabilities: [c0] HyperTransport: Host or Secondary Interface=0A=
		Command: WarmRst+ DblEnd- DevNum=3D0 ChainSide- HostHide+ Slave- =
<EOCErr- DUL-=0A=
		Link Control: CFlE- CST- CFE- <LkFail- Init+ EOC- TXO- <CRCErr=3D0 =
IsocEn- LSEn+ ExtCTL- 64b-=0A=
		Link Config: MLWI=3D16bit DwFcIn- MLWO=3D16bit DwFcOut- LWI=3D16bit =
DwFcInEn- LWO=3D16bit DwFcOutEn-=0A=
		Revision ID: 3.00=0A=
		Link Frequency: 1.0GHz=0A=
		Link Error: <Prot- <Ovfl- <EOC- CTLTm-=0A=
		Link Frequency Capability: 200MHz+ 300MHz- 400MHz+ 500MHz- 600MHz+ =
800MHz+ 1.0GHz+ 1.2GHz- 1.4GHz- 1.6GHz- Vend-=0A=
		Feature Capability: IsocFC+ LDTSTOP+ CRCTM- ECTLT- 64bA+ UIDRD- ExtRS- =
UCnfE-=0A=
=0A=
00:1b.1 Host bridge: Advanced Micro Devices [AMD] Family 10h [Opteron, =
Athlon64, Sempron] Address Map=0A=
	Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- =
Stepping- SERR- FastB2B- DisINTx-=0A=
	Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=3Dfast >TAbort- =
<TAbort- <MAbort- >SERR- <PERR- INTx-=0A=
=0A=
00:1b.2 Host bridge: Advanced Micro Devices [AMD] Family 10h [Opteron, =
Athlon64, Sempron] DRAM Controller=0A=
	Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- =
Stepping- SERR- FastB2B- DisINTx-=0A=
	Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=3Dfast >TAbort- =
<TAbort- <MAbort- >SERR- <PERR- INTx-=0A=
=0A=
00:1b.3 Host bridge: Advanced Micro Devices [AMD] Family 10h [Opteron, =
Athlon64, Sempron] Miscellaneous Control=0A=
	Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- =
Stepping- SERR- FastB2B- DisINTx-=0A=
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=3Dfast >TAbort- =
<TAbort- <MAbort- >SERR- <PERR- INTx-=0A=
	Capabilities: [f0] Secure device <?>=0A=
=0A=
00:1b.4 Host bridge: Advanced Micro Devices [AMD] Family 10h [Opteron, =
Athlon64, Sempron] Link Control=0A=
	Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- =
Stepping- SERR- FastB2B- DisINTx-=0A=
	Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=3Dfast >TAbort- =
<TAbort- <MAbort- >SERR- <PERR- INTx-=0A=
=0A=
00:1c.0 Host bridge: Advanced Micro Devices [AMD] Family 10h [Opteron, =
Athlon64, Sempron] HyperTransport Configuration=0A=
	Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- =
Stepping- SERR- FastB2B- DisINTx-=0A=
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=3Dfast >TAbort- =
<TAbort- <MAbort- >SERR- <PERR- INTx-=0A=
	Capabilities: [80] HyperTransport: Host or Secondary Interface=0A=
		Command: WarmRst+ DblEnd- DevNum=3D0 ChainSide- HostHide+ Slave- =
<EOCErr- DUL-=0A=
		Link Control: CFlE- CST- CFE- <LkFail- Init+ EOC- TXO- <CRCErr=3D0 =
IsocEn- LSEn+ ExtCTL- 64b-=0A=
		Link Config: MLWI=3D16bit DwFcIn- MLWO=3D16bit DwFcOut- LWI=3D16bit =
DwFcInEn- LWO=3D16bit DwFcOutEn-=0A=
		Revision ID: 3.00=0A=
		Link Frequency: 1.0GHz=0A=
		Link Error: <Prot- <Ovfl- <EOC- CTLTm-=0A=
		Link Frequency Capability: 200MHz+ 300MHz- 400MHz+ 500MHz- 600MHz+ =
800MHz+ 1.0GHz+ 1.2GHz- 1.4GHz- 1.6GHz- Vend-=0A=
		Feature Capability: IsocFC+ LDTSTOP+ CRCTM- ECTLT- 64bA+ UIDRD- ExtRS- =
UCnfE-=0A=
	Capabilities: [a0] HyperTransport: Host or Secondary Interface=0A=
		Command: WarmRst+ DblEnd- DevNum=3D0 ChainSide- HostHide+ Slave- =
<EOCErr- DUL-=0A=
		Link Control: CFlE- CST- CFE- <LkFail- Init+ EOC- TXO- <CRCErr=3D0 =
IsocEn- LSEn+ ExtCTL- 64b-=0A=
		Link Config: MLWI=3D16bit DwFcIn- MLWO=3D16bit DwFcOut- LWI=3D16bit =
DwFcInEn- LWO=3D16bit DwFcOutEn-=0A=
		Revision ID: 3.00=0A=
		Link Frequency: 1.0GHz=0A=
		Link Error: <Prot- <Ovfl- <EOC- CTLTm-=0A=
		Link Frequency Capability: 200MHz+ 300MHz- 400MHz+ 500MHz- 600MHz+ =
800MHz+ 1.0GHz+ 1.2GHz- 1.4GHz- 1.6GHz- Vend-=0A=
		Feature Capability: IsocFC+ LDTSTOP+ CRCTM- ECTLT- 64bA+ UIDRD- ExtRS- =
UCnfE-=0A=
	Capabilities: [c0] HyperTransport: Host or Secondary Interface=0A=
		Command: WarmRst+ DblEnd- DevNum=3D0 ChainSide- HostHide+ Slave- =
<EOCErr- DUL-=0A=
		Link Control: CFlE- CST- CFE- <LkFail- Init+ EOC- TXO- <CRCErr=3D0 =
IsocEn- LSEn+ ExtCTL- 64b-=0A=
		Link Config: MLWI=3D16bit DwFcIn- MLWO=3D16bit DwFcOut- LWI=3D16bit =
DwFcInEn- LWO=3D16bit DwFcOutEn-=0A=
		Revision ID: 3.00=0A=
		Link Frequency: 1.0GHz=0A=
		Link Error: <Prot- <Ovfl- <EOC- CTLTm-=0A=
		Link Frequency Capability: 200MHz+ 300MHz- 400MHz+ 500MHz- 600MHz+ =
800MHz+ 1.0GHz+ 1.2GHz- 1.4GHz- 1.6GHz- Vend-=0A=
		Feature Capability: IsocFC+ LDTSTOP+ CRCTM- ECTLT- 64bA+ UIDRD- ExtRS- =
UCnfE-=0A=
=0A=
00:1c.1 Host bridge: Advanced Micro Devices [AMD] Family 10h [Opteron, =
Athlon64, Sempron] Address Map=0A=
	Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- =
Stepping- SERR- FastB2B- DisINTx-=0A=
	Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=3Dfast >TAbort- =
<TAbort- <MAbort- >SERR- <PERR- INTx-=0A=
=0A=
00:1c.2 Host bridge: Advanced Micro Devices [AMD] Family 10h [Opteron, =
Athlon64, Sempron] DRAM Controller=0A=
	Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- =
Stepping- SERR- FastB2B- DisINTx-=0A=
	Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=3Dfast >TAbort- =
<TAbort- <MAbort- >SERR- <PERR- INTx-=0A=
=0A=
00:1c.3 Host bridge: Advanced Micro Devices [AMD] Family 10h [Opteron, =
Athlon64, Sempron] Miscellaneous Control=0A=
	Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- =
Stepping- SERR- FastB2B- DisINTx-=0A=
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=3Dfast >TAbort- =
<TAbort- <MAbort- >SERR- <PERR- INTx-=0A=
	Capabilities: [f0] Secure device <?>=0A=
=0A=
00:1c.4 Host bridge: Advanced Micro Devices [AMD] Family 10h [Opteron, =
Athlon64, Sempron] Link Control=0A=
	Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- =
Stepping- SERR- FastB2B- DisINTx-=0A=
	Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=3Dfast >TAbort- =
<TAbort- <MAbort- >SERR- <PERR- INTx-=0A=
=0A=
00:1d.0 Host bridge: Advanced Micro Devices [AMD] Family 10h [Opteron, =
Athlon64, Sempron] HyperTransport Configuration=0A=
	Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- =
Stepping- SERR- FastB2B- DisINTx-=0A=
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=3Dfast >TAbort- =
<TAbort- <MAbort- >SERR- <PERR- INTx-=0A=
	Capabilities: [80] HyperTransport: Host or Secondary Interface=0A=
		Command: WarmRst+ DblEnd- DevNum=3D0 ChainSide- HostHide+ Slave- =
<EOCErr- DUL-=0A=
		Link Control: CFlE- CST- CFE- <LkFail- Init+ EOC- TXO- <CRCErr=3D0 =
IsocEn- LSEn+ ExtCTL- 64b-=0A=
		Link Config: MLWI=3D16bit DwFcIn- MLWO=3D16bit DwFcOut- LWI=3D16bit =
DwFcInEn- LWO=3D16bit DwFcOutEn-=0A=
		Revision ID: 3.00=0A=
		Link Frequency: 1.0GHz=0A=
		Link Error: <Prot- <Ovfl- <EOC- CTLTm-=0A=
		Link Frequency Capability: 200MHz+ 300MHz- 400MHz+ 500MHz- 600MHz+ =
800MHz+ 1.0GHz+ 1.2GHz- 1.4GHz- 1.6GHz- Vend-=0A=
		Feature Capability: IsocFC+ LDTSTOP+ CRCTM- ECTLT- 64bA+ UIDRD- ExtRS- =
UCnfE-=0A=
	Capabilities: [a0] HyperTransport: Host or Secondary Interface=0A=
		Command: WarmRst+ DblEnd- DevNum=3D0 ChainSide- HostHide+ Slave- =
<EOCErr- DUL-=0A=
		Link Control: CFlE- CST- CFE- <LkFail- Init+ EOC- TXO- <CRCErr=3D0 =
IsocEn- LSEn+ ExtCTL- 64b-=0A=
		Link Config: MLWI=3D16bit DwFcIn- MLWO=3D16bit DwFcOut- LWI=3D16bit =
DwFcInEn- LWO=3D16bit DwFcOutEn-=0A=
		Revision ID: 3.00=0A=
		Link Frequency: 1.0GHz=0A=
		Link Error: <Prot- <Ovfl- <EOC- CTLTm-=0A=
		Link Frequency Capability: 200MHz+ 300MHz- 400MHz+ 500MHz- 600MHz+ =
800MHz+ 1.0GHz+ 1.2GHz- 1.4GHz- 1.6GHz- Vend-=0A=
		Feature Capability: IsocFC+ LDTSTOP+ CRCTM- ECTLT- 64bA+ UIDRD- ExtRS- =
UCnfE-=0A=
	Capabilities: [c0] HyperTransport: Host or Secondary Interface=0A=
		Command: WarmRst+ DblEnd- DevNum=3D0 ChainSide- HostHide+ Slave- =
<EOCErr- DUL-=0A=
		Link Control: CFlE- CST- CFE- <LkFail- Init+ EOC- TXO- <CRCErr=3D0 =
IsocEn- LSEn+ ExtCTL- 64b-=0A=
		Link Config: MLWI=3D16bit DwFcIn- MLWO=3D16bit DwFcOut- LWI=3D16bit =
DwFcInEn- LWO=3D16bit DwFcOutEn-=0A=
		Revision ID: 3.00=0A=
		Link Frequency: 1.0GHz=0A=
		Link Error: <Prot- <Ovfl- <EOC- CTLTm-=0A=
		Link Frequency Capability: 200MHz+ 300MHz- 400MHz+ 500MHz- 600MHz+ =
800MHz+ 1.0GHz+ 1.2GHz- 1.4GHz- 1.6GHz- Vend-=0A=
		Feature Capability: IsocFC+ LDTSTOP+ CRCTM- ECTLT- 64bA+ UIDRD- ExtRS- =
UCnfE-=0A=
=0A=
00:1d.1 Host bridge: Advanced Micro Devices [AMD] Family 10h [Opteron, =
Athlon64, Sempron] Address Map=0A=
	Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- =
Stepping- SERR- FastB2B- DisINTx-=0A=
	Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=3Dfast >TAbort- =
<TAbort- <MAbort- >SERR- <PERR- INTx-=0A=
=0A=
00:1d.2 Host bridge: Advanced Micro Devices [AMD] Family 10h [Opteron, =
Athlon64, Sempron] DRAM Controller=0A=
	Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- =
Stepping- SERR- FastB2B- DisINTx-=0A=
	Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=3Dfast >TAbort- =
<TAbort- <MAbort- >SERR- <PERR- INTx-=0A=
=0A=
00:1d.3 Host bridge: Advanced Micro Devices [AMD] Family 10h [Opteron, =
Athlon64, Sempron] Miscellaneous Control=0A=
	Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- =
Stepping- SERR- FastB2B- DisINTx-=0A=
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=3Dfast >TAbort- =
<TAbort- <MAbort- >SERR- <PERR- INTx-=0A=
	Capabilities: [f0] Secure device <?>=0A=
=0A=
00:1d.4 Host bridge: Advanced Micro Devices [AMD] Family 10h [Opteron, =
Athlon64, Sempron] Link Control=0A=
	Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- =
Stepping- SERR- FastB2B- DisINTx-=0A=
	Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=3Dfast >TAbort- =
<TAbort- <MAbort- >SERR- <PERR- INTx-=0A=
=0A=
00:1e.0 Host bridge: Advanced Micro Devices [AMD] Family 10h [Opteron, =
Athlon64, Sempron] HyperTransport Configuration=0A=
	Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- =
Stepping- SERR- FastB2B- DisINTx-=0A=
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=3Dfast >TAbort- =
<TAbort- <MAbort- >SERR- <PERR- INTx-=0A=
	Capabilities: [80] HyperTransport: Host or Secondary Interface=0A=
		Command: WarmRst+ DblEnd- DevNum=3D0 ChainSide- HostHide+ Slave- =
<EOCErr- DUL-=0A=
		Link Control: CFlE- CST- CFE- <LkFail- Init+ EOC- TXO- <CRCErr=3D0 =
IsocEn- LSEn+ ExtCTL- 64b-=0A=
		Link Config: MLWI=3D16bit DwFcIn- MLWO=3D16bit DwFcOut- LWI=3D16bit =
DwFcInEn- LWO=3D16bit DwFcOutEn-=0A=
		Revision ID: 3.00=0A=
		Link Frequency: 1.0GHz=0A=
		Link Error: <Prot- <Ovfl- <EOC- CTLTm-=0A=
		Link Frequency Capability: 200MHz+ 300MHz- 400MHz+ 500MHz- 600MHz+ =
800MHz+ 1.0GHz+ 1.2GHz- 1.4GHz- 1.6GHz- Vend-=0A=
		Feature Capability: IsocFC+ LDTSTOP+ CRCTM- ECTLT- 64bA+ UIDRD- ExtRS- =
UCnfE-=0A=
	Capabilities: [a0] HyperTransport: Host or Secondary Interface=0A=
		Command: WarmRst+ DblEnd- DevNum=3D0 ChainSide- HostHide+ Slave- =
<EOCErr- DUL-=0A=
		Link Control: CFlE- CST- CFE- <LkFail- Init+ EOC- TXO- <CRCErr=3D0 =
IsocEn- LSEn+ ExtCTL- 64b-=0A=
		Link Config: MLWI=3D16bit DwFcIn- MLWO=3D16bit DwFcOut- LWI=3D16bit =
DwFcInEn- LWO=3D16bit DwFcOutEn-=0A=
		Revision ID: 3.00=0A=
		Link Frequency: 1.0GHz=0A=
		Link Error: <Prot- <Ovfl- <EOC- CTLTm-=0A=
		Link Frequency Capability: 200MHz+ 300MHz- 400MHz+ 500MHz- 600MHz+ =
800MHz+ 1.0GHz+ 1.2GHz- 1.4GHz- 1.6GHz- Vend-=0A=
		Feature Capability: IsocFC+ LDTSTOP+ CRCTM- ECTLT- 64bA+ UIDRD- ExtRS- =
UCnfE-=0A=
	Capabilities: [c0] HyperTransport: Host or Secondary Interface=0A=
		Command: WarmRst+ DblEnd- DevNum=3D0 ChainSide- HostHide+ Slave- =
<EOCErr- DUL-=0A=
		Link Control: CFlE- CST- CFE- <LkFail- Init+ EOC- TXO- <CRCErr=3D0 =
IsocEn- LSEn+ ExtCTL- 64b-=0A=
		Link Config: MLWI=3D16bit DwFcIn- MLWO=3D16bit DwFcOut- LWI=3D16bit =
DwFcInEn- LWO=3D16bit DwFcOutEn-=0A=
		Revision ID: 3.00=0A=
		Link Frequency: 1.0GHz=0A=
		Link Error: <Prot- <Ovfl- <EOC- CTLTm-=0A=
		Link Frequency Capability: 200MHz+ 300MHz- 400MHz+ 500MHz- 600MHz+ =
800MHz+ 1.0GHz+ 1.2GHz- 1.4GHz- 1.6GHz- Vend-=0A=
		Feature Capability: IsocFC+ LDTSTOP+ CRCTM- ECTLT- 64bA+ UIDRD- ExtRS- =
UCnfE-=0A=
=0A=
00:1e.1 Host bridge: Advanced Micro Devices [AMD] Family 10h [Opteron, =
Athlon64, Sempron] Address Map=0A=
	Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- =
Stepping- SERR- FastB2B- DisINTx-=0A=
	Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=3Dfast >TAbort- =
<TAbort- <MAbort- >SERR- <PERR- INTx-=0A=
=0A=
00:1e.2 Host bridge: Advanced Micro Devices [AMD] Family 10h [Opteron, =
Athlon64, Sempron] DRAM Controller=0A=
	Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- =
Stepping- SERR- FastB2B- DisINTx-=0A=
	Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=3Dfast >TAbort- =
<TAbort- <MAbort- >SERR- <PERR- INTx-=0A=
=0A=
00:1e.3 Host bridge: Advanced Micro Devices [AMD] Family 10h [Opteron, =
Athlon64, Sempron] Miscellaneous Control=0A=
	Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- =
Stepping- SERR- FastB2B- DisINTx-=0A=
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=3Dfast >TAbort- =
<TAbort- <MAbort- >SERR- <PERR- INTx-=0A=
	Capabilities: [f0] Secure device <?>=0A=
=0A=
00:1e.4 Host bridge: Advanced Micro Devices [AMD] Family 10h [Opteron, =
Athlon64, Sempron] Link Control=0A=
	Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- =
Stepping- SERR- FastB2B- DisINTx-=0A=
	Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=3Dfast >TAbort- =
<TAbort- <MAbort- >SERR- <PERR- INTx-=0A=
=0A=
00:1f.0 Host bridge: Advanced Micro Devices [AMD] Family 10h [Opteron, =
Athlon64, Sempron] HyperTransport Configuration=0A=
	Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- =
Stepping- SERR- FastB2B- DisINTx-=0A=
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=3Dfast >TAbort- =
<TAbort- <MAbort- >SERR- <PERR- INTx-=0A=
	Capabilities: [80] HyperTransport: Host or Secondary Interface=0A=
		Command: WarmRst+ DblEnd- DevNum=3D0 ChainSide- HostHide+ Slave- =
<EOCErr- DUL-=0A=
		Link Control: CFlE- CST- CFE- <LkFail- Init+ EOC- TXO- <CRCErr=3D0 =
IsocEn- LSEn+ ExtCTL- 64b-=0A=
		Link Config: MLWI=3D16bit DwFcIn- MLWO=3D16bit DwFcOut- LWI=3D16bit =
DwFcInEn- LWO=3D16bit DwFcOutEn-=0A=
		Revision ID: 3.00=0A=
		Link Frequency: 1.0GHz=0A=
		Link Error: <Prot- <Ovfl- <EOC- CTLTm-=0A=
		Link Frequency Capability: 200MHz+ 300MHz- 400MHz+ 500MHz- 600MHz+ =
800MHz+ 1.0GHz+ 1.2GHz- 1.4GHz- 1.6GHz- Vend-=0A=
		Feature Capability: IsocFC+ LDTSTOP+ CRCTM- ECTLT- 64bA+ UIDRD- ExtRS- =
UCnfE-=0A=
	Capabilities: [a0] HyperTransport: Host or Secondary Interface=0A=
		Command: WarmRst+ DblEnd- DevNum=3D0 ChainSide- HostHide+ Slave- =
<EOCErr- DUL-=0A=
		Link Control: CFlE- CST- CFE- <LkFail- Init+ EOC- TXO- <CRCErr=3D0 =
IsocEn- LSEn+ ExtCTL- 64b-=0A=
		Link Config: MLWI=3D16bit DwFcIn- MLWO=3D16bit DwFcOut- LWI=3D16bit =
DwFcInEn- LWO=3D16bit DwFcOutEn-=0A=
		Revision ID: 3.00=0A=
		Link Frequency: 1.0GHz=0A=
		Link Error: <Prot- <Ovfl- <EOC- CTLTm-=0A=
		Link Frequency Capability: 200MHz+ 300MHz- 400MHz+ 500MHz- 600MHz+ =
800MHz+ 1.0GHz+ 1.2GHz- 1.4GHz- 1.6GHz- Vend-=0A=
		Feature Capability: IsocFC+ LDTSTOP+ CRCTM- ECTLT- 64bA+ UIDRD- ExtRS- =
UCnfE-=0A=
	Capabilities: [c0] HyperTransport: Host or Secondary Interface=0A=
		Command: WarmRst+ DblEnd- DevNum=3D0 ChainSide- HostHide+ Slave- =
<EOCErr- DUL-=0A=
		Link Control: CFlE- CST- CFE- <LkFail- Init+ EOC- TXO- <CRCErr=3D0 =
IsocEn- LSEn+ ExtCTL- 64b-=0A=
		Link Config: MLWI=3D16bit DwFcIn- MLWO=3D16bit DwFcOut- LWI=3D16bit =
DwFcInEn- LWO=3D16bit DwFcOutEn-=0A=
		Revision ID: 3.00=0A=
		Link Frequency: 1.0GHz=0A=
		Link Error: <Prot- <Ovfl- <EOC- CTLTm-=0A=
		Link Frequency Capability: 200MHz+ 300MHz- 400MHz+ 500MHz- 600MHz+ =
800MHz+ 1.0GHz+ 1.2GHz- 1.4GHz- 1.6GHz- Vend-=0A=
		Feature Capability: IsocFC+ LDTSTOP+ CRCTM- ECTLT- 64bA+ UIDRD- ExtRS- =
UCnfE-=0A=
=0A=
00:1f.1 Host bridge: Advanced Micro Devices [AMD] Family 10h [Opteron, =
Athlon64, Sempron] Address Map=0A=
	Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- =
Stepping- SERR- FastB2B- DisINTx-=0A=
	Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=3Dfast >TAbort- =
<TAbort- <MAbort- >SERR- <PERR- INTx-=0A=
=0A=
00:1f.2 Host bridge: Advanced Micro Devices [AMD] Family 10h [Opteron, =
Athlon64, Sempron] DRAM Controller=0A=
	Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- =
Stepping- SERR- FastB2B- DisINTx-=0A=
	Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=3Dfast >TAbort- =
<TAbort- <MAbort- >SERR- <PERR- INTx-=0A=
=0A=
00:1f.3 Host bridge: Advanced Micro Devices [AMD] Family 10h [Opteron, =
Athlon64, Sempron] Miscellaneous Control=0A=
	Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- =
Stepping- SERR- FastB2B- DisINTx-=0A=
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=3Dfast >TAbort- =
<TAbort- <MAbort- >SERR- <PERR- INTx-=0A=
	Capabilities: [f0] Secure device <?>=0A=
=0A=
00:1f.4 Host bridge: Advanced Micro Devices [AMD] Family 10h [Opteron, =
Athlon64, Sempron] Link Control=0A=
	Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- =
Stepping- SERR- FastB2B- DisINTx-=0A=
	Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=3Dfast >TAbort- =
<TAbort- <MAbort- >SERR- <PERR- INTx-=0A=
=0A=
01:06.0 Ethernet controller: Intel Corporation 82541GI Gigabit Ethernet =
Controller (rev 05)=0A=
	Subsystem: Tyan Computer Unknown device 3870=0A=
	Control: I/O+ Mem+ BusMaster- SpecCycle- MemWINV+ VGASnoop- ParErr- =
Stepping- SERR- FastB2B- DisINTx-=0A=
	Status: Cap+ 66MHz+ UDF- FastB2B- ParErr- DEVSEL=3Dmedium >TAbort- =
<TAbort- <MAbort- >SERR- <PERR- INTx-=0A=
	Interrupt: pin A routed to IRQ 17=0A=
	Region 0: Memory at d4120000 (32-bit, non-prefetchable) [size=3D128K]=0A=
	Region 1: Memory at d4100000 (32-bit, non-prefetchable) [size=3D128K]=0A=
	Region 2: I/O ports at 2080 [size=3D64]=0A=
	[virtual] Expansion ROM at d4180000 [disabled] [size=3D128K]=0A=
	Capabilities: [dc] Power Management version 2=0A=
		Flags: PMEClk- DSI+ D1- D2- AuxCurrent=3D0mA =
PME(D0+,D1-,D2-,D3hot+,D3cold+)=0A=
		Status: D0 PME-Enable- DSel=3D0 DScale=3D1 PME-=0A=
	Capabilities: [e4] PCI-X non-bridge device=0A=
		Command: DPERE- ERO+ RBC=3D512 OST=3D1=0A=
		Status: Dev=3D00:00.0 64bit- 133MHz- SCD- USC- DC=3Dsimple =
DMMRBC=3D2048 DMOST=3D1 DMCRS=3D8 RSCEM- 266MHz- 533MHz-=0A=
	Kernel modules: e1000=0A=
=0A=
01:09.0 VGA compatible controller: XGI Technology Inc. (eXtreme Graphics =
Innovation) Volari Z7 (prog-if 00 [VGA controller])=0A=
	Subsystem: XGI Technology Inc. (eXtreme Graphics Innovation) Volari Z7=0A=
	Control: I/O+ Mem+ BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- =
Stepping- SERR- FastB2B- DisINTx-=0A=
	Status: Cap+ 66MHz+ UDF- FastB2B- ParErr- DEVSEL=3Dmedium >TAbort- =
<TAbort- <MAbort- >SERR- <PERR- INTx-=0A=
	BIST result: 00=0A=
	Region 0: Memory at d8000000 (32-bit, prefetchable) [size=3D64M]=0A=
	Region 1: Memory at d4140000 (32-bit, non-prefetchable) [size=3D256K]=0A=
	Region 2: I/O ports at 2000 [size=3D128]=0A=
	Capabilities: [40] Power Management version 2=0A=
		Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=3D0mA =
PME(D0-,D1-,D2-,D3hot-,D3cold-)=0A=
		Status: D0 PME-Enable- DSel=3D0 DScale=3D0 PME-=0A=
=0A=
05:00.0 Fibre Channel: QLogic Corp. ISP2532-based 8Gb Fibre Channel to =
PCI Express HBA (rev 02)=0A=
	Subsystem: QLogic Corp. Unknown device 015c=0A=
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr+ =
Stepping- SERR+ FastB2B- DisINTx+=0A=
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=3Dfast >TAbort- =
<TAbort- <MAbort- >SERR- <PERR- INTx-=0A=
	Latency: 0, Cache Line Size: 64 bytes=0A=
	Interrupt: pin A routed to IRQ 18=0A=
	Region 0: I/O ports at 3000 [size=3D256]=0A=
	Region 1: Memory at d4200000 (64-bit, non-prefetchable) [size=3D16K]=0A=
	[virtual] Expansion ROM at d0000000 [disabled] [size=3D256K]=0A=
	Capabilities: [44] Power Management version 3=0A=
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=3D0mA =
PME(D0-,D1-,D2-,D3hot-,D3cold-)=0A=
		Status: D0 PME-Enable- DSel=3D0 DScale=3D0 PME-=0A=
	Capabilities: [4c] Express (v2) Endpoint, MSI 00=0A=
		DevCap:	MaxPayload 1024 bytes, PhantFunc 0, Latency L0s <4us, L1 <1us=0A=
			ExtTag- AttnBtn- AttnInd- PwrInd- RBE+ FLReset+=0A=
		DevCtl:	Report errors: Correctable+ Non-Fatal+ Fatal+ Unsupported+=0A=
			RlxdOrd+ ExtTag- PhantFunc- AuxPwr- NoSnoop+ FLReset-=0A=
			MaxPayload 128 bytes, MaxReadReq 2048 bytes=0A=
		DevSta:	CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr- TransPend-=0A=
		LnkCap:	Port #0, Speed 5GT/s, Width x8, ASPM L0s, Latency L0 <2us, L1 =
<2us=0A=
			ClockPM- Suprise- LLActRep- BwNot-=0A=
		LnkCtl:	ASPM Disabled; RCB 64 bytes Disabled- Retrain- CommClk-=0A=
			ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-=0A=
		LnkSta:	Speed 2.5GT/s, Width x8, TrErr- Train- SlotClk+ DLActive- =
BWMgmt- ABWMgmt-=0A=
	Capabilities: [88] Message Signalled Interrupts: Mask- 64bit+ =
Queue=3D0/5 Enable-=0A=
		Address: 0000000000000000  Data: 0000=0A=
	Capabilities: [98] Vital Product Data <?>=0A=
	Capabilities: [a0] MSI-X: Enable+ Mask- TabSize=3D2=0A=
		Vector table: BAR=3D1 offset=3D00002000=0A=
		PBA: BAR=3D1 offset=3D00003000=0A=
	Capabilities: [100] Advanced Error Reporting <?>=0A=
	Capabilities: [138] Power Budgeting <?>=0A=
	Kernel driver in use: qla2xxx=0A=
	Kernel modules: qla2xxx=0A=
=0A=
80:00.0 Memory controller: nVidia Corporation CK804 Memory Controller =
(rev a4)=0A=
	Subsystem: Tyan Computer Unknown device 4985=0A=
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- =
Stepping- SERR- FastB2B- DisINTx-=0A=
	Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=3Dfast >TAbort- =
<TAbort- <MAbort- >SERR- <PERR- INTx-=0A=
	Latency: 0=0A=
	Capabilities: [44] HyperTransport: Slave or Primary Interface=0A=
		Command: BaseUnitID=3D0 UnitCnt=3D15 MastHost- DefDir- DUL-=0A=
		Link Control 0: CFlE+ CST- CFE- <LkFail- Init+ EOC- TXO- <CRCErr=3D3 =
IsocEn- LSEn- ExtCTL- 64b-=0A=
		Link Config 0: MLWI=3D16bit DwFcIn- MLWO=3D16bit DwFcOut- LWI=3D16bit =
DwFcInEn- LWO=3D16bit DwFcOutEn-=0A=
		Link Control 1: CFlE- CST- CFE- <LkFail+ Init- EOC+ TXO+ <CRCErr=3D0 =
IsocEn- LSEn- ExtCTL- 64b-=0A=
		Link Config 1: MLWI=3D8bit DwFcIn- MLWO=3D8bit DwFcOut- LWI=3D8bit =
DwFcInEn- LWO=3D8bit DwFcOutEn-=0A=
		Revision ID: 1.03=0A=
		Link Frequency 0: 1.0GHz=0A=
		Link Error 0: <Prot- <Ovfl- <EOC- CTLTm-=0A=
		Link Frequency Capability 0: 200MHz+ 300MHz+ 400MHz+ 500MHz+ 600MHz+ =
800MHz+ 1.0GHz+ 1.2GHz- 1.4GHz- 1.6GHz- Vend-=0A=
		Feature Capability: IsocFC+ LDTSTOP+ CRCTM- ECTLT- 64bA- UIDRD-=0A=
		Link Frequency 1: 200MHz=0A=
		Link Error 1: <Prot- <Ovfl- <EOC- CTLTm-=0A=
		Link Frequency Capability 1: 200MHz- 300MHz- 400MHz- 500MHz- 600MHz- =
800MHz- 1.0GHz- 1.2GHz- 1.4GHz- 1.6GHz- Vend-=0A=
		Error Handling: PFlE+ OFlE+ PFE- OFE- EOCFE- RFE- CRCFE- SERRFE- CF- =
RE- PNFE- ONFE- EOCNFE- RNFE- CRCNFE- SERRNFE-=0A=
		Prefetchable memory behind bridge Upper: 00-00=0A=
		Bus Number: 00=0A=
	Capabilities: [e0] HyperTransport: MSI Mapping Enable+ Fixed-=0A=
		Mapping Address Base: 00000000fee00000=0A=
=0A=
80:01.0 Memory controller: nVidia Corporation CK804 Memory Controller =
(rev f1)=0A=
	Subsystem: Tyan Computer Unknown device 4985=0A=
	Control: I/O+ Mem+ BusMaster+ SpecCycle+ MemWINV- VGASnoop- ParErr- =
Stepping- SERR- FastB2B- DisINTx-=0A=
	Status: Cap- 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=3Dfast >TAbort- =
<TAbort- <MAbort- >SERR- <PERR- INTx-=0A=
	Latency: 0=0A=
=0A=
80:07.0 IDE interface: nVidia Corporation CK804 Serial ATA Controller =
(rev f3) (prog-if 85 [Master SecO PriO])=0A=
	Subsystem: nVidia Corporation Unknown device cb84=0A=
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- =
Stepping- SERR- FastB2B- DisINTx-=0A=
	Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=3Dfast >TAbort- =
<TAbort- <MAbort- >SERR- <PERR- INTx-=0A=
	Latency: 0 (750ns min, 250ns max)=0A=
	Interrupt: pin A routed to IRQ 17=0A=
	Region 0: I/O ports at b030 [size=3D8]=0A=
	Region 1: I/O ports at b024 [size=3D4]=0A=
	Region 2: I/O ports at b028 [size=3D8]=0A=
	Region 3: I/O ports at b020 [size=3D4]=0A=
	Region 4: I/O ports at b000 [size=3D16]=0A=
	Region 5: Memory at dc000000 (32-bit, non-prefetchable) [size=3D4K]=0A=
	Capabilities: [44] Power Management version 2=0A=
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=3D0mA =
PME(D0-,D1-,D2-,D3hot-,D3cold-)=0A=
		Status: D0 PME-Enable- DSel=3D0 DScale=3D0 PME-=0A=
	Kernel driver in use: sata_nv=0A=
	Kernel modules: ata_generic, pata_acpi, sata_nv=0A=
=0A=
80:08.0 IDE interface: nVidia Corporation CK804 Serial ATA Controller =
(rev f3) (prog-if 85 [Master SecO PriO])=0A=
	Subsystem: nVidia Corporation Unknown device cb84=0A=
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- =
Stepping- SERR- FastB2B- DisINTx-=0A=
	Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=3Dfast >TAbort- =
<TAbort- <MAbort- >SERR- <PERR- INTx-=0A=
	Latency: 0 (750ns min, 250ns max)=0A=
	Interrupt: pin A routed to IRQ 16=0A=
	Region 0: I/O ports at b048 [size=3D8]=0A=
	Region 1: I/O ports at b03c [size=3D4]=0A=
	Region 2: I/O ports at b040 [size=3D8]=0A=
	Region 3: I/O ports at b038 [size=3D4]=0A=
	Region 4: I/O ports at b010 [size=3D16]=0A=
	Region 5: Memory at dc001000 (32-bit, non-prefetchable) [size=3D4K]=0A=
	Capabilities: [44] Power Management version 2=0A=
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=3D0mA =
PME(D0-,D1-,D2-,D3hot-,D3cold-)=0A=
		Status: D0 PME-Enable- DSel=3D0 DScale=3D0 PME-=0A=
	Kernel driver in use: sata_nv=0A=
	Kernel modules: ata_generic, pata_acpi, sata_nv=0A=
=0A=
80:0a.0 Bridge: nVidia Corporation CK804 Ethernet Controller (rev f3)=0A=
	Subsystem: Tyan Computer Unknown device 4985=0A=
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- =
Stepping- SERR- FastB2B- DisINTx-=0A=
	Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=3Dfast >TAbort- =
<TAbort- <MAbort- >SERR- <PERR- INTx-=0A=
	Latency: 0 (250ns min, 5000ns max)=0A=
	Interrupt: pin A routed to IRQ 18=0A=
	Region 0: Memory at dc002000 (32-bit, non-prefetchable) [size=3D4K]=0A=
	Region 1: I/O ports at b050 [size=3D8]=0A=
	Capabilities: [44] Power Management version 2=0A=
		Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=3D0mA =
PME(D0+,D1+,D2+,D3hot+,D3cold+)=0A=
		Status: D0 PME-Enable+ DSel=3D0 DScale=3D0 PME-=0A=
	Kernel driver in use: forcedeth=0A=
	Kernel modules: forcedeth=0A=
=0A=
80:0b.0 PCI bridge: nVidia Corporation CK804 PCIE Bridge (rev f3) =
(prog-if 00 [Normal decode])=0A=
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- =
Stepping- SERR- FastB2B- DisINTx+=0A=
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=3Dfast >TAbort- =
<TAbort- <MAbort- >SERR- <PERR- INTx-=0A=
	Latency: 0, Cache Line Size: 64 bytes=0A=
	Bus: primary=3D80, secondary=3D81, subordinate=3D85, sec-latency=3D0=0A=
	I/O behind bridge: 0000f000-00000fff=0A=
	Memory behind bridge: fff00000-000fffff=0A=
	Prefetchable memory behind bridge: 00000000fff00000-00000000000fffff=0A=
	Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=3Dfast >TAbort- =
<TAbort- <MAbort- <SERR- <PERR-=0A=
	BridgeCtl: Parity- SERR- NoISA+ VGA- MAbort- >Reset- FastB2B-=0A=
		PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-=0A=
	Capabilities: [40] Power Management version 2=0A=
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=3D0mA =
PME(D0+,D1+,D2+,D3hot+,D3cold+)=0A=
		Status: D0 PME-Enable- DSel=3D0 DScale=3D0 PME-=0A=
	Capabilities: [48] Message Signalled Interrupts: Mask- 64bit+ =
Queue=3D0/1 Enable+=0A=
		Address: 00000000fee04000  Data: 4069=0A=
	Capabilities: [58] HyperTransport: MSI Mapping Enable+ Fixed-=0A=
		Mapping Address Base: 00000000fee00000=0A=
	Capabilities: [80] Express (v1) Root Port (Slot+), MSI 00=0A=
		DevCap:	MaxPayload 128 bytes, PhantFunc 0, Latency L0s <512ns, L1 <4us=0A=
			ExtTag- RBE- FLReset-=0A=
		DevCtl:	Report errors: Correctable+ Non-Fatal+ Fatal+ Unsupported+=0A=
			RlxdOrd+ ExtTag- PhantFunc- AuxPwr- NoSnoop+=0A=
			MaxPayload 128 bytes, MaxReadReq 512 bytes=0A=
		DevSta:	CorrErr- UncorrErr- FatalErr+ UnsuppReq- AuxPwr- TransPend-=0A=
		LnkCap:	Port #3, Speed 2.5GT/s, Width x0, ASPM L0s, Latency L0 <512ns, =
L1 <4us=0A=
			ClockPM- Suprise- LLActRep- BwNot-=0A=
		LnkCtl:	ASPM Disabled; RCB 64 bytes Disabled- Retrain- CommClk-=0A=
			ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-=0A=
		LnkSta:	Speed 2.5GT/s, Width x4, TrErr+ Train- SlotClk+ DLActive- =
BWMgmt- ABWMgmt-=0A=
		SltCap:	AttnBtn- PwrCtrl- MRL- AttnInd- PwrInd- HotPlug- Surpise-=0A=
			Slot #  0, PowerLimit 0.000000; Interlock- NoCompl-=0A=
		SltCtl:	Enable: AttnBtn- PwrFlt- MRL- PresDet- CmdCplt- HPIrq- LinkChg-=0A=
			Control: AttnInd Unknown, PwrInd Unknown, Power- Interlock-=0A=
		SltSta:	Status: AttnBtn- PowerFlt- MRL- CmdCplt- PresDet- Interlock-=0A=
			Changed: MRL- PresDet- LinkState-=0A=
		RootCtl: ErrCorrectable- ErrNon-Fatal- ErrFatal- PMEIntEna- CRSVisible-=0A=
		RootCap: CRSVisible-=0A=
		RootSta: PME ReqID 0000, PMEStatus- PMEPending-=0A=
	Capabilities: [100] Virtual Channel <?>=0A=
	Capabilities: [160] Advanced Error Reporting <?>=0A=
	Kernel driver in use: pcieport-driver=0A=
	Kernel modules: shpchp=0A=
=0A=
80:0c.0 PCI bridge: nVidia Corporation CK804 PCIE Bridge (rev f3) =
(prog-if 00 [Normal decode])=0A=
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- =
Stepping- SERR- FastB2B- DisINTx+=0A=
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=3Dfast >TAbort- =
<TAbort- <MAbort- >SERR- <PERR- INTx-=0A=
	Latency: 0, Cache Line Size: 64 bytes=0A=
	Bus: primary=3D80, secondary=3D86, subordinate=3D8a, sec-latency=3D0=0A=
	I/O behind bridge: 0000f000-00000fff=0A=
	Memory behind bridge: fff00000-000fffff=0A=
	Prefetchable memory behind bridge: 00000000fff00000-00000000000fffff=0A=
	Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=3Dfast >TAbort- =
<TAbort- <MAbort- <SERR- <PERR-=0A=
	BridgeCtl: Parity- SERR- NoISA+ VGA- MAbort- >Reset- FastB2B-=0A=
		PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-=0A=
	Capabilities: [40] Power Management version 2=0A=
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=3D0mA =
PME(D0+,D1+,D2+,D3hot+,D3cold+)=0A=
		Status: D0 PME-Enable- DSel=3D0 DScale=3D0 PME-=0A=
	Capabilities: [48] Message Signalled Interrupts: Mask- 64bit+ =
Queue=3D0/1 Enable+=0A=
		Address: 00000000fee04000  Data: 4071=0A=
	Capabilities: [58] HyperTransport: MSI Mapping Enable+ Fixed-=0A=
		Mapping Address Base: 00000000fee00000=0A=
	Capabilities: [80] Express (v1) Root Port (Slot+), MSI 00=0A=
		DevCap:	MaxPayload 128 bytes, PhantFunc 0, Latency L0s <512ns, L1 <4us=0A=
			ExtTag- RBE- FLReset-=0A=
		DevCtl:	Report errors: Correctable+ Non-Fatal+ Fatal+ Unsupported+=0A=
			RlxdOrd+ ExtTag- PhantFunc- AuxPwr- NoSnoop+=0A=
			MaxPayload 128 bytes, MaxReadReq 512 bytes=0A=
		DevSta:	CorrErr- UncorrErr- FatalErr+ UnsuppReq- AuxPwr- TransPend-=0A=
		LnkCap:	Port #2, Speed 2.5GT/s, Width x0, ASPM L0s, Latency L0 <512ns, =
L1 <4us=0A=
			ClockPM- Suprise- LLActRep- BwNot-=0A=
		LnkCtl:	ASPM Disabled; RCB 64 bytes Disabled- Retrain- CommClk-=0A=
			ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-=0A=
		LnkSta:	Speed 2.5GT/s, Width x4, TrErr+ Train- SlotClk+ DLActive- =
BWMgmt- ABWMgmt-=0A=
		SltCap:	AttnBtn- PwrCtrl- MRL- AttnInd- PwrInd- HotPlug- Surpise-=0A=
			Slot #  0, PowerLimit 0.000000; Interlock- NoCompl-=0A=
		SltCtl:	Enable: AttnBtn- PwrFlt- MRL- PresDet- CmdCplt- HPIrq- LinkChg-=0A=
			Control: AttnInd Unknown, PwrInd Unknown, Power- Interlock-=0A=
		SltSta:	Status: AttnBtn- PowerFlt- MRL- CmdCplt- PresDet- Interlock-=0A=
			Changed: MRL- PresDet- LinkState-=0A=
		RootCtl: ErrCorrectable- ErrNon-Fatal- ErrFatal- PMEIntEna- CRSVisible-=0A=
		RootCap: CRSVisible-=0A=
		RootSta: PME ReqID 0000, PMEStatus- PMEPending-=0A=
	Capabilities: [100] Virtual Channel <?>=0A=
	Capabilities: [160] Advanced Error Reporting <?>=0A=
	Kernel driver in use: pcieport-driver=0A=
	Kernel modules: shpchp=0A=
=0A=
80:0d.0 PCI bridge: nVidia Corporation CK804 PCIE Bridge (rev f3) =
(prog-if 00 [Normal decode])=0A=
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- =
Stepping- SERR- FastB2B- DisINTx+=0A=
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=3Dfast >TAbort- =
<TAbort- <MAbort- >SERR- <PERR- INTx-=0A=
	Latency: 0, Cache Line Size: 64 bytes=0A=
	Bus: primary=3D80, secondary=3D8b, subordinate=3D8f, sec-latency=3D0=0A=
	I/O behind bridge: 0000c000-0000cfff=0A=
	Memory behind bridge: dc100000-dc1fffff=0A=
	Prefetchable memory behind bridge: 00000000de000000-00000000dfffffff=0A=
	Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=3Dfast >TAbort- =
<TAbort- <MAbort- <SERR- <PERR-=0A=
	BridgeCtl: Parity- SERR- NoISA+ VGA- MAbort- >Reset- FastB2B-=0A=
		PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-=0A=
	Capabilities: [40] Power Management version 2=0A=
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=3D0mA =
PME(D0+,D1+,D2+,D3hot+,D3cold+)=0A=
		Status: D0 PME-Enable- DSel=3D0 DScale=3D0 PME-=0A=
	Capabilities: [48] Message Signalled Interrupts: Mask- 64bit+ =
Queue=3D0/1 Enable+=0A=
		Address: 00000000fee04000  Data: 4079=0A=
	Capabilities: [58] HyperTransport: MSI Mapping Enable+ Fixed-=0A=
		Mapping Address Base: 00000000fee00000=0A=
	Capabilities: [80] Express (v1) Root Port (Slot+), MSI 00=0A=
		DevCap:	MaxPayload 128 bytes, PhantFunc 0, Latency L0s <512ns, L1 <4us=0A=
			ExtTag- RBE- FLReset-=0A=
		DevCtl:	Report errors: Correctable+ Non-Fatal+ Fatal+ Unsupported+=0A=
			RlxdOrd+ ExtTag- PhantFunc- AuxPwr- NoSnoop+=0A=
			MaxPayload 128 bytes, MaxReadReq 512 bytes=0A=
		DevSta:	CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr- TransPend-=0A=
		LnkCap:	Port #1, Speed 2.5GT/s, Width x4, ASPM L0s, Latency L0 <512ns, =
L1 <4us=0A=
			ClockPM- Suprise- LLActRep- BwNot-=0A=
		LnkCtl:	ASPM Disabled; RCB 64 bytes Disabled- Retrain- CommClk-=0A=
			ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-=0A=
		LnkSta:	Speed 2.5GT/s, Width x4, TrErr- Train- SlotClk+ DLActive- =
BWMgmt- ABWMgmt-=0A=
		SltCap:	AttnBtn- PwrCtrl- MRL- AttnInd- PwrInd- HotPlug- Surpise-=0A=
			Slot #  0, PowerLimit 0.000000; Interlock- NoCompl-=0A=
		SltCtl:	Enable: AttnBtn- PwrFlt- MRL- PresDet- CmdCplt- HPIrq- LinkChg-=0A=
			Control: AttnInd Unknown, PwrInd Unknown, Power- Interlock-=0A=
		SltSta:	Status: AttnBtn- PowerFlt- MRL- CmdCplt- PresDet+ Interlock-=0A=
			Changed: MRL- PresDet+ LinkState-=0A=
		RootCtl: ErrCorrectable- ErrNon-Fatal- ErrFatal- PMEIntEna- CRSVisible-=0A=
		RootCap: CRSVisible-=0A=
		RootSta: PME ReqID 0000, PMEStatus- PMEPending-=0A=
	Capabilities: [100] Virtual Channel <?>=0A=
	Capabilities: [160] Advanced Error Reporting <?>=0A=
	Kernel driver in use: pcieport-driver=0A=
	Kernel modules: shpchp=0A=
=0A=
80:0e.0 PCI bridge: nVidia Corporation CK804 PCIE Bridge (rev a3) =
(prog-if 00 [Normal decode])=0A=
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- =
Stepping- SERR- FastB2B- DisINTx+=0A=
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=3Dfast >TAbort- =
<TAbort- <MAbort- >SERR- <PERR- INTx-=0A=
	Latency: 0, Cache Line Size: 64 bytes=0A=
	Bus: primary=3D80, secondary=3D90, subordinate=3D94, sec-latency=3D0=0A=
	I/O behind bridge: 0000f000-00000fff=0A=
	Memory behind bridge: fff00000-000fffff=0A=
	Prefetchable memory behind bridge: 00000000fff00000-00000000000fffff=0A=
	Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=3Dfast >TAbort- =
<TAbort- <MAbort- <SERR- <PERR-=0A=
	BridgeCtl: Parity- SERR- NoISA+ VGA- MAbort- >Reset- FastB2B-=0A=
		PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-=0A=
	Capabilities: [40] Power Management version 2=0A=
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=3D0mA =
PME(D0+,D1+,D2+,D3hot+,D3cold+)=0A=
		Status: D0 PME-Enable- DSel=3D0 DScale=3D0 PME-=0A=
	Capabilities: [48] Message Signalled Interrupts: Mask- 64bit+ =
Queue=3D0/1 Enable+=0A=
		Address: 00000000fee04000  Data: 4081=0A=
	Capabilities: [58] HyperTransport: MSI Mapping Enable+ Fixed-=0A=
		Mapping Address Base: 00000000fee00000=0A=
	Capabilities: [80] Express (v1) Root Port (Slot+), MSI 00=0A=
		DevCap:	MaxPayload 128 bytes, PhantFunc 0, Latency L0s <512ns, L1 <4us=0A=
			ExtTag- RBE- FLReset-=0A=
		DevCtl:	Report errors: Correctable+ Non-Fatal+ Fatal+ Unsupported+=0A=
			RlxdOrd+ ExtTag- PhantFunc- AuxPwr- NoSnoop+=0A=
			MaxPayload 128 bytes, MaxReadReq 512 bytes=0A=
		DevSta:	CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr- TransPend-=0A=
		LnkCap:	Port #0, Speed 2.5GT/s, Width x16, ASPM L0s, Latency L0 =
<512ns, L1 <4us=0A=
			ClockPM- Suprise- LLActRep- BwNot-=0A=
		LnkCtl:	ASPM Disabled; RCB 64 bytes Disabled- Retrain- CommClk-=0A=
			ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-=0A=
		LnkSta:	Speed 2.5GT/s, Width x16, TrErr- Train- SlotClk+ DLActive- =
BWMgmt- ABWMgmt-=0A=
		SltCap:	AttnBtn- PwrCtrl- MRL- AttnInd- PwrInd- HotPlug- Surpise-=0A=
			Slot #  0, PowerLimit 0.000000; Interlock- NoCompl-=0A=
		SltCtl:	Enable: AttnBtn- PwrFlt- MRL- PresDet- CmdCplt- HPIrq- LinkChg-=0A=
			Control: AttnInd Unknown, PwrInd Unknown, Power- Interlock-=0A=
		SltSta:	Status: AttnBtn- PowerFlt- MRL- CmdCplt- PresDet- Interlock-=0A=
			Changed: MRL- PresDet- LinkState-=0A=
		RootCtl: ErrCorrectable- ErrNon-Fatal- ErrFatal- PMEIntEna- CRSVisible-=0A=
		RootCap: CRSVisible-=0A=
		RootSta: PME ReqID 0000, PMEStatus- PMEPending-=0A=
	Capabilities: [100] Virtual Channel <?>=0A=
	Capabilities: [160] Advanced Error Reporting <?>=0A=
	Kernel driver in use: pcieport-driver=0A=
	Kernel modules: shpchp=0A=
=0A=
8b:00.0 RAID bus controller: 3ware Inc Unknown device 1005 (rev 01)=0A=
	Subsystem: 3ware Inc Unknown device 1005=0A=
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- =
Stepping- SERR- FastB2B- DisINTx-=0A=
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=3Dfast >TAbort- =
<TAbort- <MAbort- >SERR- <PERR- INTx-=0A=
	Latency: 0, Cache Line Size: 64 bytes=0A=
	Interrupt: pin A routed to IRQ 19=0A=
	Region 0: Memory at de000000 (64-bit, prefetchable) [size=3D32M]=0A=
	Region 2: Memory at dc100000 (64-bit, non-prefetchable) [size=3D4K]=0A=
	Region 4: I/O ports at c000 [size=3D256]=0A=
	[virtual] Expansion ROM at dc120000 [disabled] [size=3D128K]=0A=
	Capabilities: [40] Power Management version 2=0A=
		Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=3D0mA =
PME(D0-,D1-,D2-,D3hot-,D3cold-)=0A=
		Status: D0 PME-Enable- DSel=3D0 DScale=3D0 PME-=0A=
	Capabilities: [50] Message Signalled Interrupts: Mask- 64bit+ =
Queue=3D0/5 Enable-=0A=
		Address: 0000000000000000  Data: 0000=0A=
	Capabilities: [70] Express (v1) Legacy Endpoint, MSI 00=0A=
		DevCap:	MaxPayload 512 bytes, PhantFunc 0, Latency L0s <128ns, L1 <2us=0A=
			ExtTag- AttnBtn- AttnInd- PwrInd- RBE+ FLReset-=0A=
		DevCtl:	Report errors: Correctable- Non-Fatal- Fatal- Unsupported-=0A=
			RlxdOrd+ ExtTag- PhantFunc- AuxPwr- NoSnoop+=0A=
			MaxPayload 128 bytes, MaxReadReq 512 bytes=0A=
		DevSta:	CorrErr+ UncorrErr- FatalErr- UnsuppReq+ AuxPwr- TransPend-=0A=
		LnkCap:	Port #0, Speed 2.5GT/s, Width x8, ASPM L0s L1, Latency L0 =
<512ns, L1 <64us=0A=
			ClockPM- Suprise- LLActRep+ BwNot-=0A=
		LnkCtl:	ASPM Disabled; RCB 128 bytes Disabled- Retrain- CommClk-=0A=
			ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-=0A=
		LnkSta:	Speed 2.5GT/s, Width x4, TrErr- Train- SlotClk- DLActive+ =
BWMgmt- ABWMgmt-=0A=
	Capabilities: [100] Advanced Error Reporting <?>=0A=
	Kernel driver in use: 3w-9xxx=0A=
	Kernel modules: 3w-9xxx=0A=
=0A=

------=_NextPart_000_0008_01C96446.FF58FC80--

