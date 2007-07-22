Return-Path: <linux-kernel-owner+w=401wt.eu-S1765941AbXGVWEc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765941AbXGVWEc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jul 2007 18:04:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932065AbXGVWEV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Jul 2007 18:04:21 -0400
Received: from wrzx28.rz.uni-wuerzburg.de ([132.187.3.28]:56878 "EHLO
	mailrelay.rz.uni-wuerzburg.de" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1759873AbXGVWEU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jul 2007 18:04:20 -0400
X-Greylist: delayed 1988 seconds by postgrey-1.27 at vger.kernel.org; Sun, 22 Jul 2007 18:04:20 EDT
From: Andreas Messer <andreas.messer@stud-mail.uni-wuerzburg.de>
To: linux-kernel@vger.kernel.org
Subject: [BUG] firewire: mass-storage i/o-problems
Date: Sun, 22 Jul 2007 23:32:08 +0200
User-Agent: KMail/1.9.5
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart16713316.rddFpg5vCG";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200707222332.12270.andreas.messer@stud-mail.uni-wuerzburg.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart16713316.rddFpg5vCG
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

Hello,

I tried the new firewire stack with a external harddisc and a external dvd=
=20
writer and get massive i/o problems. Here is the kernel output for the=20
harddisc. Please cc me for further questions. I hope its not too much outpu=
t=20
for lkml email.=20

=2D-------------------------------------------------------------
firewire_core: created new fw device fw1 (0 config rom retries)
firewire_core: phy config: card 0, new root=3Dffc0, gap_count=3D5
scsi2 : SBP-2 IEEE-1394
firewire_sbp2: management write failed, rcode 0x14
firewire_sbp2: orb reply timed out, rcode=3D0x11
firewire_sbp2: management write failed, rcode 0x10
message repeated 2 times
firewire_sbp2: management write failed, rcode 0x14
firewire_sbp2: failed to login to fw1.0
firewire_sbp2: management write failed, rcode 0x13
firewire_sbp2: removed sbp2 unit fw1.0
firewire_core: phy config: card 0, new root=3Dffc1, gap_count=3D5
scsi3 : SBP-2 IEEE-1394
firewire_core: created new fw device fw1 (0 config rom retries)
firewire_sbp2: logged in to sbp2 unit fw1.0 (0 retries)
firewire_sbp2: - management_agent_address: 0xfffff0010000
firewire_sbp2: - command_block_agent_address: 0xfffff0010020
firewire_sbp2: - status write address: 0x000100000000
scsi 3:0:0:0: Direct-Access-RBC SAMSUNG HD300LD PQ: 0 ANSI: 4
sd 3:0:0:0: [sdb] 586072368 512-byte hardware sectors (300069 MB)
firewire_sbp2: sbp2_scsi_abort
firewire_sbp2: sbp2_scsi_abort
sd 3:0:0:0: scsi: Device offlined - not ready after error recovery
sd 3:0:0:0: [sdb] Write Protect is off
sd 3:0:0:0: [sdb] Mode Sense: 00 00 00 00
sd 3:0:0:0: rejecting I/O to offline device
sd 3:0:0:0: [sdb] Asking for cache data failed
sd 3:0:0:0: [sdb] Assuming drive cache: write through
sd 3:0:0:0: [sdb] Attached SCSI disk
sd 3:0:0:0: Attached scsi generic sg3 type 14
firewire_sbp2: management write failed, rcode 0x13
firewire_sbp2: removed sbp2 unit fw1.0

replugged hdd:

firewire_core: phy config: card 0, new root=3Dffc1, gap_count=3D5
scsi4 : SBP-2 IEEE-1394
firewire_core: created new fw device fw1 (0 config rom retries)
firewire_sbp2: logged in to sbp2 unit fw1.0 (0 retries)
firewire_sbp2: - management_agent_address: 0xfffff0010000
firewire_sbp2: - command_block_agent_address: 0xfffff0010020
firewire_sbp2: - status write address: 0x000100000000
scsi 4:0:0:0: Direct-Access-RBC SAMSUNG HD300LD PQ: 0 ANSI: 4
sd 4:0:0:0: [sdb] 586072368 512-byte hardware sectors (300069 MB)
sd 4:0:0:0: [sdb] Write Protect is off
sd 4:0:0:0: [sdb] Mode Sense: 11 00 00 00
sd 4:0:0:0: [sdb] Write cache: enabled, read cache: enabled, doesn't suppor=
t=20
DPO or FUA
sd 4:0:0:0: [sdb] 586072368 512-byte hardware sectors (300069 MB)
sd 4:0:0:0: [sdb] Write Protect is off
sd 4:0:0:0: [sdb] Mode Sense: 11 00 00 00
sd 4:0:0:0: [sdb] Write cache: enabled, read cache: enabled, doesn't suppor=
t=20
DPO or FUA
sdb: sdb1
sd 4:0:0:0: [sdb] Attached SCSI disk
sd 4:0:0:0: Attached scsi generic sg3 type 14
firewire_sbp2: sbp2_scsi_abort
firewire_sbp2: sbp2_scsi_abort
sd 4:0:0:0: scsi: Device offlined - not ready after error recovery
sd 4:0:0:0: [sdb] Result: hostbyte=3DDID_BUS_BUSY=20
driverbyte=3DDRIVER_OK,SUGGEST_OK
end_request: I/O error, dev sdb, sector 518
sd 4:0:0:0: rejecting I/O to offline device
sd 4:0:0:0: rejecting I/O to offline device
sd 4:0:0:0: [sdb] Result: hostbyte=3DDID_NO_CONNECT=20
driverbyte=3DDRIVER_OK,SUGGEST_OK
end_request: I/O error, dev sdb, sector 286153
=46AT: FAT read failed (blocknr 455)
sd 4:0:0:0: rejecting I/O to offline device
=46AT: Directory bread(block 286090) failed
sd 4:0:0:0: rejecting I/O to offline device

=2E... (many lines of that)

Buffer I/O error on device sdb1, logical block 143073
lost page write due to I/O error on sdb1
firewire_sbp2: management write failed, rcode 0x13
sd 4:0:0:0: [sdb] Synchronizing SCSI cache
sd 4:0:0:0: [sdb] Result: hostbyte=3DDID_BUS_BUSY=20
driverbyte=3DDRIVER_OK,SUGGEST_OK
firewire_sbp2: removed sbp2 unit fw1.0

replugged again:

firewire_core: phy config: card 0, new root=3Dffc1, gap_count=3D5
scsi5 : SBP-2 IEEE-1394
firewire_core: created new fw device fw1 (0 config rom retries)
firewire_sbp2: orb reply timed out, rcode=3D0x11
firewire_sbp2: management write failed, rcode 0x12
message repeated 4 times
firewire_sbp2: failed to login to fw1.0
firewire_sbp2: status write for unknown orb
firewire_sbp2: management write failed, rcode 0x13
firewire_sbp2: removed sbp2 unit fw1.0

replugged again:

firewire_core: phy config: card 0, new root=3Dffc1, gap_count=3D5
scsi6 : SBP-2 IEEE-1394
firewire_core: created new fw device fw1 (0 config rom retries)
firewire_sbp2: orb reply timed out, rcode=3D0x11
firewire_sbp2: management write failed, rcode 0x12
message repeated 4 times
firewire_sbp2: failed to login to fw1.0
firewire_sbp2: status write for unknown orb

using old fw stack, everything fine:

ohci1394: fw-host0: OHCI-1394 1.0 (PCI): IRQ=3D[19] MMIO=3D[ee001000-ee0017=
ff] Max=20
Packet=3D[2048] IR/IT contexts=3D[4/8]
ieee1394: The root node is not cycle master capable; selecting a new root n=
ode=20
and resetting...
ieee1394: Node added: ID:BUS[0-00:1023] GUID[0050770e0000002e]
ieee1394: Host added: ID:BUS[0-01:1023] GUID[000a480000000edf]
scsi2 : SBP-2 IEEE-1394
ieee1394: sbp2: Logged into SBP-2 device
ieee1394: sbp2: Node 0-00:1023: Max speed [S400] - Max payload [2048]
scsi 2:0:0:0: Direct-Access-RBC SAMSUNG HD300LD PQ: 0 ANSI: 4
sd 2:0:0:0: [sdb] 586072368 512-byte hardware sectors (300069 MB)
sd 2:0:0:0: [sdb] Write Protect is off
sd 2:0:0:0: [sdb] Mode Sense: 11 00 00 00
sd 2:0:0:0: [sdb] Write cache: enabled, read cache: enabled, doesn't suppor=
t=20
DPO or FUA
sd 2:0:0:0: [sdb] 586072368 512-byte hardware sectors (300069 MB)
sd 2:0:0:0: [sdb] Write Protect is off
sd 2:0:0:0: [sdb] Mode Sense: 11 00 00 00
sd 2:0:0:0: [sdb] Write cache: enabled, read cache: enabled, doesn't suppor=
t=20
DPO or FUA
sdb: sdb1
sd 2:0:0:0: [sdb] Attached SCSI disk
sd 2:0:0:0: Attached scsi generic sg3 type 14
=2D------------------------------------------

Hardware:=20
Via ohci1394 FW Controller (PCI), nforce2 chipset, Athlon XP-M

Software:
Kernel Vanilla 2.6.22, gcc 4.1.2.=20

On another PC same problem, but replugging one or two times get the thing=20
working.=20

greeting
Andreas Messer
=2D-=20
gnuPG keyid: 8C2BAF51
fingerprint: 28EE 8438 E688 D992 3661 C753 90B3 BAAA 8C2B AF51

--nextPart16713316.rddFpg5vCG
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQBGo8zckLO6qowrr1ERAtmjAJ9u3NQDo/BuQW5AcB47zBPS1SqLiwCgnffD
o5t/mJDIAXzhRmhXuNPZiMA=
=TSTW
-----END PGP SIGNATURE-----

--nextPart16713316.rddFpg5vCG--
