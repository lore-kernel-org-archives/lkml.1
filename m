Return-Path: <linux-kernel-owner+w=401wt.eu-S1755919AbXKWJvU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755919AbXKWJvU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Nov 2007 04:51:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753442AbXKWJvM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Nov 2007 04:51:12 -0500
Received: from wx-out-0506.google.com ([66.249.82.232]:60226 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752359AbXKWJvH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Nov 2007 04:51:07 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:mime-version:content-type;
        b=oShMCHdVOPb6YShywM5X1brwZK02zKKjQ/ey6DZ1wy5HjUfCE6hFVEXCXNQVrMr2Zkff2Jo9abIB6v+i34ufWE4VekHbGX4OWDAWRJA92bw3qtG3x0fwm4msm1xIiNoUibQQ4zs4peQsbEiSyZQbN0k38+sm+YmRagKdBe08s1U=
Message-ID: <c002e7b30711230151u239d6a28y28ed3a2a34eac160@mail.gmail.com>
Date: Fri, 23 Nov 2007 17:51:03 +0800
From: "jordan liu" <jordanliuster@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: kernel panic when configure wireless
MIME-Version: 1.0
Content-Type: multipart/mixed; 
	boundary="----=_Part_38509_179054.1195811464066"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

------=_Part_38509_179054.1195811464066
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Hi

When I configure wireless(system will rmmod wireless driver and
restart to load it after configuration) kernel panic occurs randomly,
and it is not very easy to be reproduced.
The platform is linux_2.4.17_mvl21/MIPS, and the attached is timer.c file.

Oops messages are as following(two addresses):
===========================================================================
Unable to handle kernel paging request at virtual address 00000004,
epc == 9403fc1c, ra == 9403fa8c
Oops in fault.c:do_page_fault, line 229:
$0 : 00000000 941dc674 00000000 941dc468 000180d1 943ecf70 941dc294 00000000
$8 : 03ffffff 000fffff 941dc260 94172408 00018000 00000002 00018000 00000001
$16: 00000001 941c9620 fffffffe ffffffff 1000fc00 941c8860 941c00c0 9457e4e0
$24: 00000000 2ab86410                   94026000 94027e08 01000000 9403fa8c
Hi : 0000596a
Lo : e147fc52
epc  : 9403fc1c    Not tainted
Status: 1000fc02
Cause : 3080000c
Process swapper (pid: 0, stackpage=94026000)
Stack: 00000000 941c8860 00000001 941c0080 941c95e8 ffffffff 9403fe84 9403b890
       941ed918 a8611800 c0061da8 ffffffef 00000001 941c00c0 9403b25c ffffffef
       94026000 00000001 00000000 9403f918 7ffffffe 941c7f94 941c8864 94027eb8
       00000000 9400b478 0000000b 9403b544 00000000 9400b478 0000000b 9403b544
       9416d530 9000e310 941c8864 94003f30 9416298c 94162958 00808000 94003f30
       00000001 ...
Call Trace: [<9403fe84>] [<9403b890>] [<c0061da8>] [<9403b25c>]
[<94026000>] [<9403f918>]
 [<94027eb8>] [<9403b544>] [<9403b544>] [<9416d530>] [<9416298c>] [<94162958>]
 [<9416d0c0>] [<9416d0d8>] [<94027fe0>] [<94027fe0>] [<94026000>] [<94027f68>]
 [<94028578>] [<94028560>] [<9402802c>] [<9416dc18>] [<94027f84>] [<9416eff4>]
 [<940204b0>]

Code: 3508ffff  8ca70000  8ca20004 <ace20004> ac470000  8ca40008
008c1823  2c620100  14400020
Kernel panic: Aiee, killing interrupt handler!
------------------------------------------------------------------------------------------------------------------------------------
Unable to handle kernel paging request at virtual address 00000004,
epc == 9403f020, ra == 94130b60
Oops in fault.c:do_page_fault, line 229:
$0 : 00000000 941dc264 94630e70 00000000 94c77cc4 0000464f 000188d7 1000fc01
$8 : 00001407 0101a8c0 6901a8c0 00001407 00000001 00000001 00000001 00000000
$16: 94c77cc4 94c77c60 00004650 941d5a08 94451c4c 00000000 00000003 94451d88
$24: 94451c28 00000714                   94450000 94451bc8 9411b604 94130b60
Hi : 0000007e
Lo : 013ef214
epc  : 9403f020    Not tainted
Status: 1000fc02
Cause : 3080000c
Process wpa_authenticat (pid: 1161, stackpage=94450000)
Stack: 00000001 6901a8c0 941c8868 94125b00 94130b60 00000002 00000000 942f28e8
       6901a8c0 00000000 94c77c60 94018e20 94451d10 941329c0 00000003 94450000
       94bea2e0 94c640a0 94c77c60 9412fb70 00014287 940dd7f0 0080005d 9405e300
       0101a8c0 00001407 6901a8c0 00001407 940dda34 940d0011 940890a0 c0100d80
       00000000 00000000 94451ce0 94451d10 941d1ca0 940fd5a0 94fa600c 9412dd7c
       00000000 ...
Call Trace: [<94125b00>] [<94130b60>] [<941329c0>] [<9412fb70>]
[<940dd7f0>] [<9405e300>]
 [<940dda34>] [<940d0011>] [<940890a0>] [<c0100d80>] [<940fd5a0>] [<9412dd7c>]
 [<9411d5d0>] [<940fd5a0>] [<940e2224>] [<940d78ac>] [<940fd5a0>] [<940fd5a0>]
 [<940e2874>] [<940fd5a0>] [<9411b63c>] [<940fca88>] [<940fd5a0>] [<9411bb78>]
 [<9404a6f8>] [<941236e8>] [<940d1694>] [<9404769c>] [<940d2660>] [<940543cc>]
 [<9402e9a8>] [<9402e950>] [<9406d3d0>] [<94092bb0>] [<94092b74>] [<94071280>]
 [<9406d88c>] [<9406d754>] [<9402d428>] [<940302f8>]

Code: 00221021  8c420004  8c430000 <ac640004> ac830000  ac820004
ac440000  40016000  30e70001
Kernel panic: Aiee, killing interrupt handler!
===========================================================================


The results of objdump vmlinux are as following:
===========================================================================
...(skip)...

ffffffff9403ef14 <add_timer>:
ffffffff9403ef14:	27bdffe8 	addiu	$sp,$sp,-24
ffffffff9403ef18:	afbf0010 	sw	$ra,16($sp)
ffffffff9403ef1c:	40076000 	mfc0	$a3,$12
ffffffff9403ef20:	00000000 	nop
ffffffff9403ef24:	34e10001 	ori	$at,$a3,0x1
ffffffff9403ef28:	38210001 	xori	$at,$at,0x1
ffffffff9403ef2c:	40816000 	mtc0	$at,$12
ffffffff9403ef30:	00000040 	sll	$zero,$zero,0x1
ffffffff9403ef34:	00000040 	sll	$zero,$zero,0x1
ffffffff9403ef38:	00000040 	sll	$zero,$zero,0x1
ffffffff9403ef3c:	8c820000 	lw	$v0,0($a0)
ffffffff9403ef40:	14400046 	bnez	$v0,ffffffff9403f05c <add_timer+0x148>
ffffffff9403ef44:	00000000 	nop
ffffffff9403ef48:	8c860008 	lw	$a2,8($a0)
ffffffff9403ef4c:	3c02941e 	lui	$v0,0x941e
ffffffff9403ef50:	8c42ce74 	lw	$v0,-12684($v0)
ffffffff9403ef54:	00c22823 	subu	$a1,$a2,$v0
ffffffff9403ef58:	2ca30100 	sltiu	$v1,$a1,256
ffffffff9403ef5c:	14600024 	bnez	$v1,ffffffff9403eff0 <add_timer+0xdc>
ffffffff9403ef60:	30c200ff 	andi	$v0,$a2,0xff
ffffffff9403ef64:	2ca24000 	sltiu	$v0,$a1,16384
ffffffff9403ef68:	10400007 	beqz	$v0,ffffffff9403ef88 <add_timer+0x74>
ffffffff9403ef6c:	00061142 	srl	$v0,$a2,0x5
ffffffff9403ef70:	304201f8 	andi	$v0,$v0,0x1f8
ffffffff9403ef74:	3c01941e 	lui	$at,0x941e
ffffffff9403ef78:	2421c46c 	addiu	$at,$at,-15252
ffffffff9403ef7c:	00221021 	addu	$v0,$at,$v0
ffffffff9403ef80:	0900fc07 	j	ffffffff9403f01c <add_timer+0x108>
ffffffff9403ef84:	8c420004 	lw	$v0,4($v0)
ffffffff9403ef88:	3c02000f 	lui	$v0,0xf
ffffffff9403ef8c:	3442ffff 	ori	$v0,$v0,0xffff
ffffffff9403ef90:	0045102b 	sltu	$v0,$v0,$a1
ffffffff9403ef94:	14400008 	bnez	$v0,ffffffff9403efb8 <add_timer+0xa4>
ffffffff9403ef98:	3c0203ff 	lui	$v0,0x3ff
ffffffff9403ef9c:	000612c2 	srl	$v0,$a2,0xb
ffffffff9403efa0:	304201f8 	andi	$v0,$v0,0x1f8
ffffffff9403efa4:	3c01941e 	lui	$at,0x941e
ffffffff9403efa8:	2421c264 	addiu	$at,$at,-15772
ffffffff9403efac:	00221021 	addu	$v0,$at,$v0
ffffffff9403efb0:	0900fc07 	j	ffffffff9403f01c <add_timer+0x108>
ffffffff9403efb4:	8c420004 	lw	$v0,4($v0)
ffffffff9403efb8:	3442ffff 	ori	$v0,$v0,0xffff
ffffffff9403efbc:	0045102b 	sltu	$v0,$v0,$a1
ffffffff9403efc0:	14400007 	bnez	$v0,ffffffff9403efe0 <add_timer+0xcc>
ffffffff9403efc4:	00061442 	srl	$v0,$a2,0x11
ffffffff9403efc8:	304201f8 	andi	$v0,$v0,0x1f8
ffffffff9403efcc:	3c01941e 	lui	$at,0x941e
ffffffff9403efd0:	2421c05c 	addiu	$at,$at,-16292
ffffffff9403efd4:	00221021 	addu	$v0,$at,$v0
ffffffff9403efd8:	0900fc07 	j	ffffffff9403f01c <add_timer+0x108>
ffffffff9403efdc:	8c420004 	lw	$v0,4($v0)
ffffffff9403efe0:	04a10009 	bgez	$a1,ffffffff9403f008 <add_timer+0xf4>
ffffffff9403efe4:	00061682 	srl	$v0,$a2,0x1a
ffffffff9403efe8:	3c02941e 	lui	$v0,0x941e
ffffffff9403efec:	8c42c670 	lw	$v0,-14736($v0)
ffffffff9403eff0:	000210c0 	sll	$v0,$v0,0x3
ffffffff9403eff4:	3c01941e 	lui	$at,0x941e
ffffffff9403eff8:	2421c674 	addiu	$at,$at,-14732
ffffffff9403effc:	00221021 	addu	$v0,$at,$v0
ffffffff9403f000:	0900fc07 	j	ffffffff9403f01c <add_timer+0x108>
ffffffff9403f004:	8c420004 	lw	$v0,4($v0)
ffffffff9403f008:	000210c0 	sll	$v0,$v0,0x3
ffffffff9403f00c:	3c01941e 	lui	$at,0x941e
ffffffff9403f010:	2421be54 	addiu	$at,$at,-16812
ffffffff9403f014:	00221021 	addu	$v0,$at,$v0
ffffffff9403f018:	8c420004 	lw	$v0,4($v0)
ffffffff9403f01c:	8c430000 	lw	$v1,0($v0)
ffffffff9403f020:	ac640004 	sw	$a0,4($v1)
ffffffff9403f024:	ac830000 	sw	$v1,0($a0)
ffffffff9403f028:	ac820004 	sw	$v0,4($a0)
ffffffff9403f02c:	ac440000 	sw	$a0,0($v0)
ffffffff9403f030:	40016000 	mfc0	$at,$12
ffffffff9403f034:	30e70001 	andi	$a3,$a3,0x1
ffffffff9403f038:	34210001 	ori	$at,$at,0x1
ffffffff9403f03c:	38210001 	xori	$at,$at,0x1
ffffffff9403f040:	00e13825 	or	$a3,$a3,$at
ffffffff9403f044:	40876000 	mtc0	$a3,$12
	...
(skip)
...
ffffffff9403fa2c <timer_bh>:
ffffffff9403fa2c:	27bdffe0 	addiu	$sp,$sp,-32
ffffffff9403fa30:	afbf0018 	sw	$ra,24($sp)
ffffffff9403fa34:	afb10014 	sw	$s1,20($sp)
ffffffff9403fa38:	afb00010 	sw	$s0,16($sp)
ffffffff9403fa3c:	40016000 	mfc0	$at,$12
ffffffff9403fa40:	00000000 	nop
ffffffff9403fa44:	34210001 	ori	$at,$at,0x1
ffffffff9403fa48:	38210001 	xori	$at,$at,0x1
ffffffff9403fa4c:	40816000 	mtc0	$at,$12
	...
ffffffff9403fa5c:	3c11941d 	lui	$s1,0x941d
ffffffff9403fa60:	26319620 	addiu	$s1,$s1,-27104
ffffffff9403fa64:	8e220000 	lw	$v0,0($s1)
ffffffff9403fa68:	3c03941d 	lui	$v1,0x941d
ffffffff9403fa6c:	8c639678 	lw	$v1,-27016($v1)
ffffffff9403fa70:	00438023 	subu	$s0,$v0,$v1
ffffffff9403fa74:	12000005 	beqz	$s0,ffffffff9403fa8c <timer_bh+0x60>
ffffffff9403fa78:	00701021 	addu	$v0,$v1,$s0
ffffffff9403fa7c:	3c01941d 	lui	$at,0x941d
ffffffff9403fa80:	ac229678 	sw	$v0,-27016($at)
ffffffff9403fa84:	0d00fdcd 	jal	ffffffff9403f734 <update_wall_time>
ffffffff9403fa88:	02002021 	move	$a0,$s0
ffffffff9403fa8c:	40016000 	mfc0	$at,$12
ffffffff9403fa90:	00000000 	nop
ffffffff9403fa94:	3421001f 	ori	$at,$at,0x1f
ffffffff9403fa98:	3821001e 	xori	$at,$at,0x1e
ffffffff9403fa9c:	40816000 	mtc0	$at,$12
ffffffff9403faa0:	3c02941d 	lui	$v0,0x941d
ffffffff9403faa4:	8c429630 	lw	$v0,-27088($v0)
ffffffff9403faa8:	00501023 	subu	$v0,$v0,$s0
ffffffff9403faac:	3c01941d 	lui	$at,0x941d
ffffffff9403fab0:	ac229630 	sw	$v0,-27088($at)
ffffffff9403fab4:	04410032 	bgez	$v0,ffffffff9403fb80 <timer_bh+0x154>
ffffffff9403fab8:	244201f4 	addiu	$v0,$v0,500
ffffffff9403fabc:	3c01941d 	lui	$at,0x941d
ffffffff9403fac0:	0d00fe77 	jal	ffffffff9403f9dc <count_active_tasks>
ffffffff9403fac4:	ac229630 	sw	$v0,-27088($at)
ffffffff9403fac8:	00021880 	sll	$v1,$v0,0x2
ffffffff9403facc:	00621821 	addu	$v1,$v1,$v0
ffffffff9403fad0:	000318c0 	sll	$v1,$v1,0x3
ffffffff9403fad4:	3c05941d 	lui	$a1,0x941d
ffffffff9403fad8:	8ca5964c 	lw	$a1,-27060($a1)
ffffffff9403fadc:	00621821 	addu	$v1,$v1,$v0
ffffffff9403fae0:	00052100 	sll	$a0,$a1,0x4
ffffffff9403fae4:	00852023 	subu	$a0,$a0,$a1
ffffffff9403fae8:	00042080 	sll	$a0,$a0,0x2
ffffffff9403faec:	00852023 	subu	$a0,$a0,$a1
ffffffff9403faf0:	000420c0 	sll	$a0,$a0,0x3
ffffffff9403faf4:	00852023 	subu	$a0,$a0,$a1
ffffffff9403faf8:	00641821 	addu	$v1,$v1,$a0
ffffffff9403fafc:	00031880 	sll	$v1,$v1,0x2
ffffffff9403fb00:	00031ac2 	srl	$v1,$v1,0xb
ffffffff9403fb04:	3c01941d 	lui	$at,0x941d
ffffffff9403fb08:	ac23964c 	sw	$v1,-27060($at)
ffffffff9403fb0c:	00021900 	sll	$v1,$v0,0x4
ffffffff9403fb10:	3c05941d 	lui	$a1,0x941d
ffffffff9403fb14:	8ca59650 	lw	$a1,-27056($a1)
ffffffff9403fb18:	00621821 	addu	$v1,$v1,$v0
ffffffff9403fb1c:	00052180 	sll	$a0,$a1,0x6
ffffffff9403fb20:	00852023 	subu	$a0,$a0,$a1
ffffffff9403fb24:	00042100 	sll	$a0,$a0,0x4
ffffffff9403fb28:	00852023 	subu	$a0,$a0,$a1
ffffffff9403fb2c:	00641821 	addu	$v1,$v1,$a0
ffffffff9403fb30:	00031840 	sll	$v1,$v1,0x1
ffffffff9403fb34:	00031ac2 	srl	$v1,$v1,0xb
ffffffff9403fb38:	3c01941d 	lui	$at,0x941d
ffffffff9403fb3c:	ac239650 	sw	$v1,-27056($at)
ffffffff9403fb40:	00021840 	sll	$v1,$v0,0x1
ffffffff9403fb44:	00621821 	addu	$v1,$v1,$v0
ffffffff9403fb48:	00031880 	sll	$v1,$v1,0x2
ffffffff9403fb4c:	3c05941d 	lui	$a1,0x941d
ffffffff9403fb50:	8ca59654 	lw	$a1,-27052($a1)
ffffffff9403fb54:	00621823 	subu	$v1,$v1,$v0
ffffffff9403fb58:	000521c0 	sll	$a0,$a1,0x7
ffffffff9403fb5c:	00852023 	subu	$a0,$a0,$a1
ffffffff9403fb60:	00042080 	sll	$a0,$a0,0x2
ffffffff9403fb64:	00852021 	addu	$a0,$a0,$a1
ffffffff9403fb68:	00042080 	sll	$a0,$a0,0x2
ffffffff9403fb6c:	00852021 	addu	$a0,$a0,$a1
ffffffff9403fb70:	00832021 	addu	$a0,$a0,$v1
ffffffff9403fb74:	000422c2 	srl	$a0,$a0,0xb
ffffffff9403fb78:	3c01941d 	lui	$at,0x941d
ffffffff9403fb7c:	ac249654 	sw	$a0,-27052($at)
ffffffff9403fb80:	40016000 	mfc0	$at,$12
ffffffff9403fb84:	00000000 	nop
ffffffff9403fb88:	34210001 	ori	$at,$at,0x1
ffffffff9403fb8c:	38210001 	xori	$at,$at,0x1
ffffffff9403fb90:	40816000 	mtc0	$at,$12
	...
ffffffff9403fba0:	8e220000 	lw	$v0,0($s1)
ffffffff9403fba4:	3c03941e 	lui	$v1,0x941e
ffffffff9403fba8:	8c63ce74 	lw	$v1,-12684($v1)
ffffffff9403fbac:	00431023 	subu	$v0,$v0,$v1
ffffffff9403fbb0:	04400098 	bltz	$v0,ffffffff9403fe14 <timer_bh+0x3e8>
ffffffff9403fbb4:	00000000 	nop
ffffffff9403fbb8:	3c02941e 	lui	$v0,0x941e
ffffffff9403fbbc:	8c42c670 	lw	$v0,-14736($v0)
ffffffff9403fbc0:	14400060 	bnez	$v0,ffffffff9403fd44 <timer_bh+0x318>
ffffffff9403fbc4:	000210c0 	sll	$v0,$v0,0x3
ffffffff9403fbc8:	240d0001 	li	$t5,1
ffffffff9403fbcc:	240f0001 	li	$t7,1
ffffffff9403fbd0:	3c0e941e 	lui	$t6,0x941e
ffffffff9403fbd4:	8dcece74 	lw	$t6,-12684($t6)
ffffffff9403fbd8:	3c0b9417 	lui	$t3,0x9417
ffffffff9403fbdc:	256b2404 	addiu	$t3,$t3,9220
ffffffff9403fbe0:	8d6a0000 	lw	$t2,0($t3)
ffffffff9403fbe4:	8d420000 	lw	$v0,0($t2)
ffffffff9403fbe8:	000210c0 	sll	$v0,$v0,0x3
ffffffff9403fbec:	24420004 	addiu	$v0,$v0,4
ffffffff9403fbf0:	01423021 	addu	$a2,$t2,$v0
ffffffff9403fbf4:	8cc50000 	lw	$a1,0($a2)
ffffffff9403fbf8:	50a60042 	0x50a60042
ffffffff9403fbfc:	acc60000 	sw	$a2,0($a2)
ffffffff9403fc00:	01c06021 	move	$t4,$t6
ffffffff9403fc04:	3c09000f 	lui	$t1,0xf
ffffffff9403fc08:	3529ffff 	ori	$t1,$t1,0xffff
ffffffff9403fc0c:	3c0803ff 	lui	$t0,0x3ff
ffffffff9403fc10:	3508ffff 	ori	$t0,$t0,0xffff
ffffffff9403fc14:	8ca70000 	lw	$a3,0($a1)
ffffffff9403fc18:	8ca20004 	lw	$v0,4($a1)
ffffffff9403fc1c:	ace20004 	sw	$v0,4($a3)
ffffffff9403fc20:	ac470000 	sw	$a3,0($v0)
ffffffff9403fc24:	8ca40008 	lw	$a0,8($a1)
ffffffff9403fc28:	008c1823 	subu	$v1,$a0,$t4
ffffffff9403fc2c:	2c620100 	sltiu	$v0,$v1,256
ffffffff9403fc30:	14400020 	bnez	$v0,ffffffff9403fcb4 <timer_bh+0x288>
ffffffff9403fc34:	308200ff 	andi	$v0,$a0,0xff
ffffffff9403fc38:	2c624000 	sltiu	$v0,$v1,16384
ffffffff9403fc3c:	10400007 	beqz	$v0,ffffffff9403fc5c <timer_bh+0x230>
ffffffff9403fc40:	00041142 	srl	$v0,$a0,0x5
ffffffff9403fc44:	304201f8 	andi	$v0,$v0,0x1f8
ffffffff9403fc48:	3c01941e 	lui	$at,0x941e
ffffffff9403fc4c:	2421c46c 	addiu	$at,$at,-15252
ffffffff9403fc50:	00221021 	addu	$v0,$at,$v0
ffffffff9403fc54:	0900ff38 	j	ffffffff9403fce0 <timer_bh+0x2b4>
ffffffff9403fc58:	8c430004 	lw	$v1,4($v0)
ffffffff9403fc5c:	0123102b 	sltu	$v0,$t1,$v1
ffffffff9403fc60:	14400008 	bnez	$v0,ffffffff9403fc84 <timer_bh+0x258>
ffffffff9403fc64:	0103102b 	sltu	$v0,$t0,$v1
ffffffff9403fc68:	000412c2 	srl	$v0,$a0,0xb
ffffffff9403fc6c:	304201f8 	andi	$v0,$v0,0x1f8
ffffffff9403fc70:	3c01941e 	lui	$at,0x941e
ffffffff9403fc74:	2421c264 	addiu	$at,$at,-15772
ffffffff9403fc78:	00221021 	addu	$v0,$at,$v0
ffffffff9403fc7c:	0900ff38 	j	ffffffff9403fce0 <timer_bh+0x2b4>
ffffffff9403fc80:	8c430004 	lw	$v1,4($v0)
ffffffff9403fc84:	14400007 	bnez	$v0,ffffffff9403fca4 <timer_bh+0x278>
ffffffff9403fc88:	00041442 	srl	$v0,$a0,0x11
ffffffff9403fc8c:	304201f8 	andi	$v0,$v0,0x1f8
ffffffff9403fc90:	3c01941e 	lui	$at,0x941e
ffffffff9403fc94:	2421c05c 	addiu	$at,$at,-16292
ffffffff9403fc98:	00221021 	addu	$v0,$at,$v0
ffffffff9403fc9c:	0900ff38 	j	ffffffff9403fce0 <timer_bh+0x2b4>
ffffffff9403fca0:	8c430004 	lw	$v1,4($v0)
ffffffff9403fca4:	04610009 	bgez	$v1,ffffffff9403fccc <timer_bh+0x2a0>
ffffffff9403fca8:	00041682 	srl	$v0,$a0,0x1a
ffffffff9403fcac:	3c02941e 	lui	$v0,0x941e
ffffffff9403fcb0:	8c42c670 	lw	$v0,-14736($v0)
ffffffff9403fcb4:	000210c0 	sll	$v0,$v0,0x3
ffffffff9403fcb8:	3c01941e 	lui	$at,0x941e
ffffffff9403fcbc:	2421c674 	addiu	$at,$at,-14732
ffffffff9403fcc0:	00221021 	addu	$v0,$at,$v0
ffffffff9403fcc4:	0900ff38 	j	ffffffff9403fce0 <timer_bh+0x2b4>
ffffffff9403fcc8:	8c430004 	lw	$v1,4($v0)
ffffffff9403fccc:	000210c0 	sll	$v0,$v0,0x3
ffffffff9403fcd0:	3c01941e 	lui	$at,0x941e
ffffffff9403fcd4:	2421be54 	addiu	$at,$at,-16812
ffffffff9403fcd8:	00221021 	addu	$v0,$at,$v0
ffffffff9403fcdc:	8c430004 	lw	$v1,4($v0)
ffffffff9403fce0:	8c620000 	lw	$v0,0($v1)
ffffffff9403fce4:	ac450004 	sw	$a1,4($v0)
ffffffff9403fce8:	aca20000 	sw	$v0,0($a1)
ffffffff9403fcec:	aca30004 	sw	$v1,4($a1)
ffffffff9403fcf0:	ac650000 	sw	$a1,0($v1)
ffffffff9403fcf4:	00e02821 	move	$a1,$a3
ffffffff9403fcf8:	54a6ffc7 	0x54a6ffc7
ffffffff9403fcfc:	8ca70000 	lw	$a3,0($a1)
ffffffff9403fd00:	acc60000 	sw	$a2,0($a2)
ffffffff9403fd04:	acc60004 	sw	$a2,4($a2)
ffffffff9403fd08:	8d420000 	lw	$v0,0($t2)
ffffffff9403fd0c:	24420001 	addiu	$v0,$v0,1
ffffffff9403fd10:	3042003f 	andi	$v0,$v0,0x3f
ffffffff9403fd14:	ad420000 	sw	$v0,0($t2)
ffffffff9403fd18:	8d630000 	lw	$v1,0($t3)
ffffffff9403fd1c:	8c620000 	lw	$v0,0($v1)
ffffffff9403fd20:	144f0005 	bne	$v0,$t7,ffffffff9403fd38 <timer_bh+0x30c>
ffffffff9403fd24:	00000000 	nop
ffffffff9403fd28:	25ad0001 	addiu	$t5,$t5,1
ffffffff9403fd2c:	2da20005 	sltiu	$v0,$t5,5
ffffffff9403fd30:	1440ffab 	bnez	$v0,ffffffff9403fbe0 <timer_bh+0x1b4>
ffffffff9403fd34:	256b0004 	addiu	$t3,$t3,4
ffffffff9403fd38:	3c02941e 	lui	$v0,0x941e
ffffffff9403fd3c:	8c42c670 	lw	$v0,-14736($v0)
ffffffff9403fd40:	000210c0 	sll	$v0,$v0,0x3
ffffffff9403fd44:	3c10941e 	lui	$s0,0x941e
ffffffff9403fd48:	2610c674 	addiu	$s0,$s0,-14732
ffffffff9403fd4c:	02028021 	addu	$s0,$s0,$v0
ffffffff9403fd50:	8e050000 	lw	$a1,0($s0)
ffffffff9403fd54:	10b00020 	beq	$a1,$s0,ffffffff9403fdd8 <timer_bh+0x3ac>
ffffffff9403fd58:	00000000 	nop
ffffffff9403fd5c:	8e220000 	lw	$v0,0($s1)
ffffffff9403fd60:	8ca30008 	lw	$v1,8($a1)
ffffffff9403fd64:	00431023 	subu	$v0,$v0,$v1
ffffffff9403fd68:	0440001b 	bltz	$v0,ffffffff9403fdd8 <timer_bh+0x3ac>
ffffffff9403fd6c:	00000000 	nop
ffffffff9403fd70:	8ca60010 	lw	$a2,16($a1)
ffffffff9403fd74:	8ca30000 	lw	$v1,0($a1)
ffffffff9403fd78:	10600004 	beqz	$v1,ffffffff9403fd8c <timer_bh+0x360>
ffffffff9403fd7c:	8ca4000c 	lw	$a0,12($a1)
ffffffff9403fd80:	8ca20004 	lw	$v0,4($a1)
ffffffff9403fd84:	ac620004 	sw	$v0,4($v1)
ffffffff9403fd88:	ac430000 	sw	$v1,0($v0)
ffffffff9403fd8c:	aca00004 	sw	$zero,4($a1)
ffffffff9403fd90:	aca00000 	sw	$zero,0($a1)
ffffffff9403fd94:	40016000 	mfc0	$at,$12
ffffffff9403fd98:	00000000 	nop
ffffffff9403fd9c:	3421001f 	ori	$at,$at,0x1f
ffffffff9403fda0:	3821001e 	xori	$at,$at,0x1e
ffffffff9403fda4:	40816000 	mtc0	$at,$12
ffffffff9403fda8:	00c0f809 	jalr	$a2
ffffffff9403fdac:	00000000 	nop
ffffffff9403fdb0:	40016000 	mfc0	$at,$12
ffffffff9403fdb4:	00000000 	nop
ffffffff9403fdb8:	34210001 	ori	$at,$at,0x1
ffffffff9403fdbc:	38210001 	xori	$at,$at,0x1
ffffffff9403fdc0:	40816000 	mtc0	$at,$12
	...
(skip)
...
===========================================================================

Thanks.

-- 
Best Regards,

Lee

------=_Part_38509_179054.1195811464066
Content-Type: text/x-csrc; name=timer.c
Content-Transfer-Encoding: base64
X-Attachment-Id: f_f9citxxq
Content-Disposition: attachment; filename=timer.c

LyoKICogIGxpbnV4L2tlcm5lbC90aW1lci5jCiAqCiAqICBLZXJuZWwgaW50ZXJuYWwgdGltZXJz
LCBrZXJuZWwgdGltZWtlZXBpbmcsIGJhc2ljIHByb2Nlc3Mgc3lzdGVtIGNhbGxzCiAqCiAqICBD
b3B5cmlnaHQgKEMpIDE5OTEsIDE5OTIgIExpbnVzIFRvcnZhbGRzCiAqCiAqICAxOTk3LTAxLTI4
ICBNb2RpZmllZCBieSBGaW5uIEFybmUgR2FuZ3N0YWQgdG8gbWFrZSB0aW1lcnMgc2NhbGUgYmV0
dGVyLgogKgogKiAgMTk5Ny0wOS0xMCAgVXBkYXRlZCBOVFAgY29kZSBhY2NvcmRpbmcgdG8gdGVj
aG5pY2FsIG1lbW9yYW5kdW0gSmFuICc5NgogKiAgICAgICAgICAgICAgIkEgS2VybmVsIE1vZGVs
IGZvciBQcmVjaXNpb24gVGltZWtlZXBpbmciIGJ5IERhdmUgTWlsbHMKICogIDE5OTgtMTItMjQg
IEZpeGVkIGEgeHRpbWUgU01QIHJhY2UgKHdlIG5lZWQgdGhlIHh0aW1lX2xvY2sgcncgc3Bpbmxv
Y2sgdG8KICogICAgICAgICAgICAgIHNlcmlhbGl6ZSBhY2Nlc3NlcyB0byB4dGltZS9sb3N0X3Rp
Y2tzKS4KICogICAgICAgICAgICAgICAgICAgICAgICAgICAgICBDb3B5cmlnaHQgKEMpIDE5OTgg
IEFuZHJlYSBBcmNhbmdlbGkKICogIDE5OTktMDMtMTAgIEltcHJvdmVkIE5UUCBjb21wYXRpYmls
aXR5IGJ5IFVscmljaCBXaW5kbAogKi8KCiNpbmNsdWRlIDxsaW51eC9jb25maWcuaD4KI2luY2x1
ZGUgPGxpbnV4L21tLmg+CiNpbmNsdWRlIDxsaW51eC90aW1leC5oPgojaW5jbHVkZSA8bGludXgv
ZGVsYXkuaD4KI2luY2x1ZGUgPGxpbnV4L3NtcF9sb2NrLmg+CiNpbmNsdWRlIDxsaW51eC9pbnRl
cnJ1cHQuaD4KI2luY2x1ZGUgPGxpbnV4L2tlcm5lbF9zdGF0Lmg+CiNpbmNsdWRlIDxsaW51eC9o
cnRpbWUuaD4KI2luY2x1ZGUgPGxpbnV4L2NvbXBpbGVyLmg+CiNpbmNsdWRlIDxhc20vc2lnbmFs
Lmg+CgojaW5jbHVkZSA8bGludXgvdHJhY2UuaD4KI2luY2x1ZGUgPGFzbS91YWNjZXNzLmg+CiNp
ZmRlZiBDT05GSUdfVElNRVJfU1RBVFMKI2luY2x1ZGUgPGFzbS90aW1lcGVnLmg+CiNlbHNlCiNk
ZWZpbmUgVFBfU1RBUlQoYSkKI2RlZmluZSBUUF9TVE9QKGEpCiNkZWZpbmUgRFRJTUVQRUcoYSxi
KQojZW5kaWYKCi8qCiAqIFRpbWVrZWVwaW5nIHZhcmlhYmxlcwogKi8KCmxvbmcgdGljayA9ICgx
MDAwMDAwICsgSFovMikgLyBIWjsJLyogdGltZXIgaW50ZXJydXB0IHBlcmlvZCAqLwoKLyogVGhl
IGN1cnJlbnQgdGltZSAqLwpzdHJ1Y3QgdGltZXZhbCB4dGltZSBfX2F0dHJpYnV0ZV9fICgoYWxp
Z25lZCAoMTYpKSk7Ci8qCiAqIFRoaXMgc3BpbmxvY2sgcHJvdGVjdCB1cyBmcm9tIHJhY2VzIGlu
IFNNUCB3aGlsZSBwbGF5aW5nIHdpdGggeHRpbWUuIC1hcmNhCiAqLwpyd2xvY2tfdCB4dGltZV9s
b2NrID0gUldfTE9DS19VTkxPQ0tFRDsKLyoKICogVGhpcyBhdG9taWMgcHJldmVudHMgcmUtZW50
cnkgb2YgdGhlIHJ1bl90aW1lcl9saXN0IGFuZCBoYXMgdGhlIHNpZGUKICogZWZmZWN0IG9mIHNo
aWZ0aW5nIGNvbmZsaWN0IHJ1bnMgdG8gdGhlICJvd25pbmciIGNwdS4KICovCgpzdGF0aWMgYXRv
bWljX3QgdGltZXJfdGFza2xldF9sb2NrID0gQVRPTUlDX0lOSVQoLTEpOwoKLyogRG9uJ3QgY29t
cGxldGVseSBmYWlsIGZvciBIWiA+IDUwMC4gICovCmludCB0aWNrYWRqID0gNTAwL0haID8gOiAx
OwkJLyogbWljcm9zZWNzICovCgpERUNMQVJFX1RBU0tfUVVFVUUodHFfdGltZXIpOwpERUNMQVJF
X1RBU0tfUVVFVUUodHFfaW1tZWRpYXRlKTsKCi8qCiAqIHBoYXNlLWxvY2sgbG9vcCB2YXJpYWJs
ZXMKICovCi8qIFRJTUVfRVJST1IgcHJldmVudHMgb3ZlcndyaXRpbmcgdGhlIENNT1MgY2xvY2sg
Ki8KaW50IHRpbWVfc3RhdGUgPSBUSU1FX09LOwkJLyogY2xvY2sgc3luY2hyb25pemF0aW9uIHN0
YXR1cwkqLwppbnQgdGltZV9zdGF0dXMgPSBTVEFfVU5TWU5DOwkJLyogY2xvY2sgc3RhdHVzIGJp
dHMJCSovCmxvbmcgdGltZV9vZmZzZXQ7CQkJLyogdGltZSBhZGp1c3RtZW50ICh1cykJCSovCmxv
bmcgdGltZV9jb25zdGFudCA9IDI7CQkJLyogcGxsIHRpbWUgY29uc3RhbnQJCSovCmxvbmcgdGlt
ZV90b2xlcmFuY2UgPSBNQVhGUkVROwkJLyogZnJlcXVlbmN5IHRvbGVyYW5jZSAocHBtKQkqLwps
b25nIHRpbWVfcHJlY2lzaW9uID0gMTsJCS8qIGNsb2NrIHByZWNpc2lvbiAodXMpCQkqLwpsb25n
IHRpbWVfbWF4ZXJyb3IgPSBOVFBfUEhBU0VfTElNSVQ7CS8qIG1heGltdW0gZXJyb3IgKHVzKQkJ
Ki8KbG9uZyB0aW1lX2VzdGVycm9yID0gTlRQX1BIQVNFX0xJTUlUOwkvKiBlc3RpbWF0ZWQgZXJy
b3IgKHVzKQkJKi8KbG9uZyB0aW1lX3BoYXNlOwkJCS8qIHBoYXNlIG9mZnNldCAoc2NhbGVkIHVz
KQkqLwpsb25nIHRpbWVfZnJlcSA9ICgoMTAwMDAwMCArIEhaLzIpICUgSFogLSBIWi8yKSA8PCBT
SElGVF9VU0VDOwoJCQkJCS8qIGZyZXF1ZW5jeSBvZmZzZXQgKHNjYWxlZCBwcG0pKi8KbG9uZyB0
aW1lX2FkajsJCQkJLyogdGljayBhZGp1c3QgKHNjYWxlZCAxIC8gSFopCSovCmxvbmcgdGltZV9y
ZWZ0aW1lOwkJCS8qIHRpbWUgYXQgbGFzdCBhZGp1c3RtZW50IChzKQkqLwoKbG9uZyB0aW1lX2Fk
anVzdDsKbG9uZyB0aW1lX2FkanVzdF9zdGVwOwoKdW5zaWduZWQgbG9uZyBldmVudDsKCmV4dGVy
biBpbnQgZG9fc2V0aXRpbWVyKGludCwgc3RydWN0IGl0aW1lcnZhbCAqLCBzdHJ1Y3QgaXRpbWVy
dmFsICopOwoKdm9sYXRpbGUgdTY0IGppZmZpZXNfNjQ9MDsKCnVuc2lnbmVkIGludCAqIHByb2Zf
YnVmZmVyOwp1bnNpZ25lZCBsb25nIHByb2ZfbGVuOwp1bnNpZ25lZCBsb25nIHByb2Zfc2hpZnQ7
CgovKgogKiBFdmVudCB0aW1lciBjb2RlCiAqLwojaWZkZWYgQ09ORklHX0hJR0hfUkVTX1RJTUVS
UwovKgogKiBpZmRlZiBlbGltaW5hdG9yIG1hY3JvLi4uCiAqLwojZGVmaW5lIElGX0hJR0hfUkVT
KGEpIGEKI2lmbmRlZiBDT05GSUdfTkVXX1RJTUVSTElTVAojZGVmaW5lIENPTkZJR19ORVdfVElN
RVJMSVNUCiNlbmRpZgojZWxzZQojZGVmaW5lIElGX0hJR0hfUkVTKGEpCiNlbmRpZgojaWYgISBk
ZWZpbmVkKENPTkZJR19DQVNDQURJTkdfVElNRVJTKSAmJiAhIGRlZmluZWQoQ09ORklHX05FV19U
SU1FUkxJU1QpCiNkZWZpbmUgQ09ORklHX0NBU0NBRElOR19USU1FUlMKI2VuZGlmIC8qIENPTkZJ
R19ISUdIX1JFU19USU1FUlMgKi8KI2RlZmluZSBUVk5fQklUUyA2CiNkZWZpbmUgVFZSX0JJVFMg
OAojZGVmaW5lIFRWTl9TSVpFICgxIDw8IFRWTl9CSVRTKQojZGVmaW5lIFRWUl9TSVpFICgxIDw8
IFRWUl9CSVRTKQojZGVmaW5lIFRWTl9NQVNLIChUVk5fU0laRSAtIDEpCiNkZWZpbmUgVFZSX01B
U0sgKFRWUl9TSVpFIC0gMSkKI2lmZGVmIENPTkZJR19ORVdfVElNRVJMSVNUCiNkZWZpbmUgSUZf
TkVXX1RJTUVSX0xJU1QoYSkgYQojaWZuZGVmIENPTkZJR19ORVdfVElNRVJfTElTVFNJWkUKI2Rl
ZmluZSBDT05GSUdfTkVXX1RJTUVSX0xJU1RTSVpFIDUxMgojZW5kaWYgLyogQ09ORklHX05FV19U
SU1FUkxJU1QgKi8KI2RlZmluZSBORVdfVFZFQ19TSVpFIENPTkZJR19ORVdfVElNRVJfTElTVFNJ
WkUKI2RlZmluZSBORVdfVFZFQ19NQVNLIChORVdfVFZFQ19TSVpFIC0gMSkKc3RhdGljIHN0cnVj
dCBsaXN0X2hlYWQgbmV3X3R2ZWNbTkVXX1RWRUNfU0laRV07CiNlbHNlICAvKiBDT05GSUdfTkVX
X1RJTUVSTElTVCAqLwojZGVmaW5lIElGX05FV19USU1FUl9MSVNUKGEpCiNlbmRpZiAvKiBDT05G
SUdfTkVXX1RJTUVSTElTVCAqLwojaWZkZWYgQ09ORklHX0NBU0NBRElOR19USU1FUlMKc3RydWN0
IHRpbWVyX3ZlYyB7CglpbnQgaW5kZXg7CglzdHJ1Y3QgbGlzdF9oZWFkIHZlY1tUVk5fU0laRV07
Cn07CgpzdHJ1Y3QgdGltZXJfdmVjX3Jvb3QgewoJaW50IGluZGV4OwoJc3RydWN0IGxpc3RfaGVh
ZCB2ZWNbVFZSX1NJWkVdOwp9OwoKc3RhdGljIHN0cnVjdCB0aW1lcl92ZWMgdHY1OwpzdGF0aWMg
c3RydWN0IHRpbWVyX3ZlYyB0djQ7CnN0YXRpYyBzdHJ1Y3QgdGltZXJfdmVjIHR2MzsKc3RhdGlj
IHN0cnVjdCB0aW1lcl92ZWMgdHYyOwpzdGF0aWMgc3RydWN0IHRpbWVyX3ZlY19yb290IHR2MTsK
CnN0YXRpYyBzdHJ1Y3QgdGltZXJfdmVjICogY29uc3QgdHZlY3NbXSA9IHsKCShzdHJ1Y3QgdGlt
ZXJfdmVjICopJnR2MSwgJnR2MiwgJnR2MywgJnR2NCwgJnR2NQp9OwoKI2RlZmluZSBOT09GX1RW
RUNTIChzaXplb2YodHZlY3MpIC8gc2l6ZW9mKHR2ZWNzWzBdKSkKI2VuZGlmIC8qIENPTkZJR19D
QVNDQURJTkdfVElNRVJTICovCgp2b2lkIGluaXRfdGltZXJ2ZWNzICh2b2lkKQp7CglpbnQgaTsK
CiNpZmRlZiBDT05GSUdfQ0FTQ0FESU5HX1RJTUVSUwoJZm9yIChpID0gMDsgaSA8IFRWTl9TSVpF
OyBpKyspIHsKCQlJTklUX0xJU1RfSEVBRCh0djUudmVjICsgaSk7CgkJSU5JVF9MSVNUX0hFQUQo
dHY0LnZlYyArIGkpOwoJCUlOSVRfTElTVF9IRUFEKHR2My52ZWMgKyBpKTsKCQlJTklUX0xJU1Rf
SEVBRCh0djIudmVjICsgaSk7Cgl9Cglmb3IgKGkgPSAwOyBpIDwgVFZSX1NJWkU7IGkrKykKCQlJ
TklUX0xJU1RfSEVBRCh0djEudmVjICsgaSk7CiNlbmRpZiAvKiBDT05GSUdfQ0FTQ0FESU5HX1RJ
TUVSUyAqLwojaWZkZWYgQ09ORklHX05FV19USU1FUkxJU1QKICAgICAgICBmb3IgKGkgPSAwOyBp
IDwgTkVXX1RWRUNfU0laRTsgaSsrKQogICAgICAgICAgICAgICAgSU5JVF9MSVNUX0hFQUQoIG5l
d190dmVjICsgaSk7CiNlbmRpZiAvKiBDT05GSUdfTkVXX1RJTUVSTElTVCAqLwp9CgpzdGF0aWMg
dW5zaWduZWQgbG9uZyB0aW1lcl9qaWZmaWVzOwoKLyogSW5pdGlhbGl6ZSBib3RoIGV4cGxpY2l0
bHkgLSBsZXQncyB0cnkgdG8gaGF2ZSB0aGVtIGluIHRoZSBzYW1lIGNhY2hlIGxpbmUgKi8Kc3Bp
bmxvY2tfdCB0aW1lcmxpc3RfbG9jayA9IFNQSU5fTE9DS19VTkxPQ0tFRDsKCiNpZiBkZWZpbmVk
KCBDT05GSUdfU01QKSB8fCAgZGVmaW5lZChDT05GSUdfSElHSF9SRVNfVElNRVJTKQp2b2xhdGls
ZSBzdHJ1Y3QgdGltZXJfbGlzdCAqIHZvbGF0aWxlIHJ1bm5pbmdfdGltZXI7CiNkZWZpbmUgdGlt
ZXJfZW50ZXIodCkgZG8geyBydW5uaW5nX3RpbWVyID0gdDsgbWIoKTsgfSB3aGlsZSAoMCkKI2Rl
ZmluZSB0aW1lcl9leGl0KCkgZG8geyBydW5uaW5nX3RpbWVyID0gTlVMTDsgfSB3aGlsZSAoMCkK
I2RlZmluZSB0aW1lcl9pc19pbmFjdGl2ZSgpIChydW5uaW5nX3RpbWVyID09IE5VTEwpCiNlbHNl
CiNkZWZpbmUgdGltZXJfZW50ZXIodCkJCWRvIHsgfSB3aGlsZSAoMCkKI2RlZmluZSB0aW1lcl9l
eGl0KCkJCWRvIHsgfSB3aGlsZSAoMCkKI2RlZmluZSB0aW1lcl9pc19pbmFjdGl2ZSgpICAgICAx
CiNlbmRpZgoKI2lmZGVmIENPTkZJR19TTVAKI2RlZmluZSB0aW1lcl9pc19ydW5uaW5nKHQpIChy
dW5uaW5nX3RpbWVyID09IHQpCiNkZWZpbmUgdGltZXJfc3luY2hyb25pemUodCkgd2hpbGUgKHRp
bWVyX2lzX3J1bm5pbmcodCkpIGJhcnJpZXIoKQojZW5kaWYKCgoKc3RhdGljIGlubGluZSB2b2lk
IGludGVybmFsX2FkZF90aW1lcihzdHJ1Y3QgdGltZXJfbGlzdCAqdGltZXIpCnsKCS8qCgkgKiBt
dXN0IGJlIGNsaS1lZCB3aGVuIGNhbGxpbmcgdGhpcwoJICovCiNpZmRlZiBDT05GSUdfTkVXX1RJ
TUVSTElTVAogICAgICAgICAgICAgICAgdW5zaWduZWQgbG9uZyBleHBpcmVzID0gdGltZXItPmV4
cGlyZXM7CiAgICAgICAgICAgICAgICBJRl9ISUdIX1JFUyhpbnQgc3ViX2V4cGlyZXMgPSB0aW1l
ci0+c3ViX2V4cGlyZXM7KQogICAgICAgICAgICAgICAgaW50IGluZHg7CiAgICAgICAgICAgICAg
ICBzdHJ1Y3QgbGlzdF9oZWFkICpwb3MsKmxpc3Rfc3RhcnQ7CgogICAgICAgICAgICAgICAgaWYg
KCB0aW1lX2JlZm9yZShleHBpcmVzLCB0aW1lcl9qaWZmaWVzKSApewogICAgICAgICAgICAgICAg
ICAgICAgICAvKgogICAgICAgICAgICAgICAgICAgICAgICAgKiBhbHJlYWR5IGV4cGlyZWQsIHNj
aGVkdWxlIGZvciBuZXh0IHRpY2sgCiAgICAgICAgICAgICAgICAgICAgICAgICAqIHdvdWxkIGxp
a2UgdG8gZG8gYmV0dGVyIGhlcmUKICAgICAgICAgICAgICAgICAgICAgICAgICogQWN0dWFsbHkg
dGhpcyBub3cgd29ya3MganVzdCBmaW5lIHdpdGggdGhlCiAgICAgICAgICAgICAgICAgICAgICAg
ICAqIGJhY2sgdXAgb2YgdGltZXJfamlmZmllcyBpbiAicnVuX3RpbWVyX2xpc3QiLgogICAgICAg
ICAgICAgICAgICAgICAgICAgKiBOb3RlIHRoYXQgdGhpcyBwdXRzIHRoZSB0aW1lciBvbiBhIGxp
c3Qgb3RoZXIKICAgICAgICAgICAgICAgICAgICAgICAgICogdGhhbiB0aGUgb25lIGl0IGlkZXhl
cyB0by4gIFdlIGRvbid0IHdhbnQgdG8KICAgICAgICAgICAgICAgICAgICAgICAgICogY2hhbmdl
IHRoZSBleHBpcmVzIHZhbHVlIGluIHRoZSB0aW1lciBhcyBpdCBpcwogICAgICAgICAgICAgICAg
ICAgICAgICAgKiB1c2VkIGJ5IHRoZSByZXBlYXQgY29kZSBpbiBzZXRpdGltZXIgYW5kIHRoZQog
ICAgICAgICAgICAgICAgICAgICAgICAgKiBQT1NJWCB0aW1lcnMgY29kZS4KICAgICAgICAgICAg
ICAgICAgICAgICAgICovCiAgICAgICAgICAgICAgICAgICAgICAgIGV4cGlyZXMgPSB0aW1lcl9q
aWZmaWVzOwogICAgICAgICAgICAgICAgICAgICAgICBJRl9ISUdIX1JFUyhzdWJfZXhwaXJlcyA9
IDApOwogICAgICAgICAgICAgICAgfQogICAgICAgICAgICAgICAgICAgICAgICAKICAgICAgICAg
ICAgICAgIGluZHggPSAgZXhwaXJlcyAmIE5FV19UVkVDX01BU0s7CiAgICAgICAgICAgICAgICBp
ZiAoKGV4cGlyZXMgLSB0aW1lcl9qaWZmaWVzKSA8PSBORVdfVFZFQ19TSVpFKSB7CiNpZmRlZiBD
T05GSUdfSElHSF9SRVNfVElNRVJTCiAgICAgICAgICAgICAgICAgICAgICAgIHVuc2lnbmVkIGxv
bmcgamlmZmllc19mOwogICAgICAgICAgICAgICAgICAgICAgICAvKgogICAgICAgICAgICAgICAg
ICAgICAgICAgKiBUaGUgaGlnaCBkaWZmIGJpdHMgYXJlIHRoZSBzYW1lLCBnb2VzIHRvIHRoZSBo
ZWFkIG9mIAogICAgICAgICAgICAgICAgICAgICAgICAgKiB0aGUgbGlzdCwgc29ydCBvbiBzdWJf
ZXhwaXJlLgogICAgICAgICAgICAgICAgICAgICAgICAgKi8KICAgICAgICAgICAgICAgICAgICAg
ICAgZm9yIChwb3MgPSAobGlzdF9zdGFydCA9ICZuZXdfdHZlY1tpbmR4XSktPm5leHQ7IAogICAg
ICAgICAgICAgICAgICAgICAgICAgICAgIHBvcyAhPSBsaXN0X3N0YXJ0OyAKICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICBwb3MgPSBwb3MtPm5leHQpewogICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgIHN0cnVjdCB0aW1lcl9saXN0ICp0bXIgPSAKICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgIGxpc3RfZW50cnkocG9zLAogICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICBzdHJ1Y3QgdGltZXJfbGlzdCwKICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgbGlzdCk7CiAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgaWYgKCh0bXItPnN1Yl9leHBpcmVzID49IHN1Yl9leHBp
cmVzKSB8fAogICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAodG1yLT5leHBpcmVz
ICE9IGV4cGlyZXMpKXsKICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIGJy
ZWFrOwogICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIH0KICAgICAgICAgICAgICAgICAg
ICAgICAgfQogICAgICAgICAgICAgICAgICAgICAgICBsaXN0X2FkZF90YWlsKCZ0aW1lci0+bGlz
dCwgcG9zKTsKICAgICAgICAgICAgICAgICAgICAgICAgLyoKICAgICAgICAgICAgICAgICAgICAg
ICAgICogTm90ZXMgdG8gbWUuICBVc2UgamlmZmllcyBoZXJlIGluc3RlYWQgb2YgCiAgICAgICAg
ICAgICAgICAgICAgICAgICAqIHRpbWVyX2ppZmZpZXMgdG8gcHJldmVudCBhZGRpbmcgdW5uZWVk
ZWQgaW50ZXJydXB0cy4KICAgICAgICAgICAgICAgICAgICAgICAgICogVGltZXJfaXNfaW5hY3Rp
dmUoKSBpcyBmYWxzZSBpZiB3ZSBhcmUgY3VycmVudGx5IAogICAgICAgICAgICAgICAgICAgICAg
ICAgKiBhY3Rpdmx5IGRpc3BhdGNoaW5nIHRpbWVycy4gIFNpbmNlIHdlIGFyZSB1bmRlcgogICAg
ICAgICAgICAgICAgICAgICAgICAgKiB0aGUgc2FtZSBzcGluIGxvY2ssIGl0IGJlaW5nIGZhbHNl
IG1lYW5zIHRoYXQgCiAgICAgICAgICAgICAgICAgICAgICAgICAqIGl0IGhhcyBkcm9wcGVkIHRo
ZSBzcGlubG9jayB0byBjYWxsIHRoZSB0aW1lcgogICAgICAgICAgICAgICAgICAgICAgICAgKiBm
dW5jdGlvbiwgd2hpY2ggY291bGQgd2VsbCBiZSB3aG8gY2FsbGVkIHVzLgogICAgICAgICAgICAg
ICAgICAgICAgICAgKiBJbiBhbnkgY2FzZSwgd2UgZG9uJ3QgbmVlZCBhIG5ldyBpbnRlcnJ1cHQg
YXMKICAgICAgICAgICAgICAgICAgICAgICAgICogdGhlIHRpbWVyIGRpc3BhY2ggY29kZSAocnVu
X3RpbWVyX2xpc3QpIHdpbGwKICAgICAgICAgICAgICAgICAgICAgICAgICogcGljayB0aGlzIHVw
IHdoZW4gdGhlIGZ1bmN0aW9uIGl0IGlzIGNhbGxpbmcgCiAgICAgICAgICAgICAgICAgICAgICAg
ICAqIHJldHVybnMuCiAgICAgICAgICAgICAgICAgICAgICAgICAqLwogICAgICAgICAgICAgICAg
ICAgICAgICBpZiAoIGV4cGlyZXMgPT0gKGppZmZpZXNfZiA9IGppZmZpZXMpICYmIAogICAgICAg
ICAgICAgICAgICAgICAgICAgICAgIGxpc3Rfc3RhcnQtPm5leHQgPT0gJnRpbWVyLT5saXN0ICYm
CiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgdGltZXJfaXNfaW5hY3RpdmUoKSkgewogICAg
ICAgICAgICAgICAgICAgICAgICAgICAgIHNjaGVkdWxlX25leHRfaW50KGppZmZpZXNfZiwgc3Vi
X2V4cGlyZXMsMSk7CiAgICAgICAgICAgICAgICAgICAgICAgIH0KI2Vsc2UKICAgICAgICAgICAg
ICAgICAgICAgICAgcG9zID0gKCZuZXdfdHZlY1tpbmR4XSktPm5leHQ7CiAgICAgICAgICAgICAg
ICAgICAgICAgIGxpc3RfYWRkX3RhaWwoJnRpbWVyLT5saXN0LCBwb3MpOwojZW5kaWYgLyogQ09O
RklHX0hJR0hfUkVTX1RJTUVSUyAqLwogICAgICAgICAgICAgICAgfWVsc2V7CiAgICAgICAgICAg
ICAgICAgICAgICAgIC8qCiAgICAgICAgICAgICAgICAgICAgICAgICAqIFRoZSBoaWdoIGRpZmYg
Yml0cyBkaWZmZXIsIHNlYXJjaCBmcm9tIHRoZSB0YWlsCiAgICAgICAgICAgICAgICAgICAgICAg
ICAqIFRoZSBmb3Igd2lsbCBwaWNrIHVwIGFuIGVtcHR5IGxpc3QuCiAgICAgICAgICAgICAgICAg
ICAgICAgICAqLwogICAgICAgICAgICAgICAgICAgICAgICAgZm9yIChwb3MgPSAobGlzdF9zdGFy
dCA9ICZuZXdfdHZlY1tpbmR4XSktPnByZXY7IAogICAgICAgICAgICAgICAgICAgICAgICAgICAg
IHBvcyAhPSBsaXN0X3N0YXJ0OyAKICAgICAgICAgICAgICAgICAgICAgICAgICAgICBwb3MgPSBw
b3MtPnByZXYpewogICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIHN0cnVjdCB0aW1lcl9s
aXN0ICp0bXIgPSAKICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIGxpc3Rf
ZW50cnkocG9zLAogICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICBzdHJ1Y3QgdGltZXJfbGlzdCwKICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgbGlzdCk7CiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
aWYgKHRpbWVfYWZ0ZXIodG1yLT5leHBpcmVzLCBleHBpcmVzKSl7CiAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICBjb250aW51ZTsKICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICB9CiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgSUZfSElHSF9SRVMoCiAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgaWYgKCh0bXItPmV4cGly
ZXMgIT0gZXhwaXJlcykgfHwKICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgKHRtci0+c3ViX2V4cGlyZXMgPCBzdWJfZXhwaXJlcykpIHsKICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIGJyZWFrOwogICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIH0KICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICApCiAgICAgICAgICAgICAgICAgICAgICAgIH0KICAgICAg
ICAgICAgICAgICAgICAgICAgbGlzdF9hZGQoJnRpbWVyLT5saXN0LCBwb3MpOwogICAgICAgICAg
ICAgICAgfQogICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIAojZW5kaWYgLyogQ09ORklH
X05FV19USU1FUkxJU1QgKi8KI2lmZGVmIENPTkZJR19DQVNDQURJTkdfVElNRVJTCgl1bnNpZ25l
ZCBsb25nIGV4cGlyZXMgPSB0aW1lci0+ZXhwaXJlczsKCXVuc2lnbmVkIGxvbmcgaWR4ID0gZXhw
aXJlcyAtIHRpbWVyX2ppZmZpZXM7CglzdHJ1Y3QgbGlzdF9oZWFkICogdmVjOwoKCWlmIChpZHgg
PCBUVlJfU0laRSkgewoJCWludCBpID0gZXhwaXJlcyAmIFRWUl9NQVNLOwoJCXZlYyA9IHR2MS52
ZWMgKyBpOwoJfSBlbHNlIGlmIChpZHggPCAxIDw8IChUVlJfQklUUyArIFRWTl9CSVRTKSkgewoJ
CWludCBpID0gKGV4cGlyZXMgPj4gVFZSX0JJVFMpICYgVFZOX01BU0s7CgkJdmVjID0gdHYyLnZl
YyArIGk7Cgl9IGVsc2UgaWYgKGlkeCA8IDEgPDwgKFRWUl9CSVRTICsgMiAqIFRWTl9CSVRTKSkg
ewoJCWludCBpID0gKGV4cGlyZXMgPj4gKFRWUl9CSVRTICsgVFZOX0JJVFMpKSAmIFRWTl9NQVNL
OwoJCXZlYyA9ICB0djMudmVjICsgaTsKCX0gZWxzZSBpZiAoaWR4IDwgMSA8PCAoVFZSX0JJVFMg
KyAzICogVFZOX0JJVFMpKSB7CgkJaW50IGkgPSAoZXhwaXJlcyA+PiAoVFZSX0JJVFMgKyAyICog
VFZOX0JJVFMpKSAmIFRWTl9NQVNLOwoJCXZlYyA9IHR2NC52ZWMgKyBpOwoJfSBlbHNlIGlmICgo
c2lnbmVkIGxvbmcpIGlkeCA8IDApIHsKCQkvKiBjYW4gaGFwcGVuIGlmIHlvdSBhZGQgYSB0aW1l
ciB3aXRoIGV4cGlyZXMgPT0gamlmZmllcywKCQkgKiBvciB5b3Ugc2V0IGEgdGltZXIgdG8gZ28g
b2ZmIGluIHRoZSBwYXN0CgkJICovCgkJdmVjID0gdHYxLnZlYyArIHR2MS5pbmRleDsKCX0gZWxz
ZSBpZiAoaWR4IDw9IDB4ZmZmZmZmZmZVTCkgewoJCWludCBpID0gKGV4cGlyZXMgPj4gKFRWUl9C
SVRTICsgMyAqIFRWTl9CSVRTKSkgJiBUVk5fTUFTSzsKCQl2ZWMgPSB0djUudmVjICsgaTsKCX0g
ZWxzZSB7CgkJLyogQ2FuIG9ubHkgZ2V0IGhlcmUgb24gYXJjaGl0ZWN0dXJlcyB3aXRoIDY0LWJp
dCBqaWZmaWVzICovCgkJSU5JVF9MSVNUX0hFQUQoJnRpbWVyLT5saXN0KTsKCQlyZXR1cm47Cgl9
CgkvKgoJICogVGltZXJzIGFyZSBGSUZPIQoJICovCglsaXN0X2FkZCgmdGltZXItPmxpc3QsIHZl
Yy0+cHJldik7CiNlbmRpZiAvKiBDT05GSUdfQ0FTQ0FESU5HX1RJTUVSUyAqLwp9Cgp2b2lkIGFk
ZF90aW1lcihzdHJ1Y3QgdGltZXJfbGlzdCAqdGltZXIpCnsKCXVuc2lnbmVkIGxvbmcgZmxhZ3M7
CgoJc3Bpbl9sb2NrX2lycXNhdmUoJnRpbWVybGlzdF9sb2NrLCBmbGFncyk7CglpZiAodGltZXJf
cGVuZGluZyh0aW1lcikpCgkJZ290byBidWc7CglpbnRlcm5hbF9hZGRfdGltZXIodGltZXIpOwoJ
c3Bpbl91bmxvY2tfaXJxcmVzdG9yZSgmdGltZXJsaXN0X2xvY2ssIGZsYWdzKTsKCXJldHVybjsK
YnVnOgoJc3Bpbl91bmxvY2tfaXJxcmVzdG9yZSgmdGltZXJsaXN0X2xvY2ssIGZsYWdzKTsKCXBy
aW50aygiYnVnOiBrZXJuZWwgdGltZXIgYWRkZWQgdHdpY2UgYXQgJXAuXG4iLAoJCQlfX2J1aWx0
aW5fcmV0dXJuX2FkZHJlc3MoMCkpOwp9CgpzdGF0aWMgaW5saW5lIGludCBkZXRhY2hfdGltZXIg
KHN0cnVjdCB0aW1lcl9saXN0ICp0aW1lcikKewoJaWYgKCF0aW1lcl9wZW5kaW5nKHRpbWVyKSl7
CgkJcmV0dXJuIDA7CiAgICAgICAgfQoJbGlzdF9kZWwoJnRpbWVyLT5saXN0KTsKCXJldHVybiAx
Owp9CgppbnQgbW9kX3RpbWVyKHN0cnVjdCB0aW1lcl9saXN0ICp0aW1lciwgdW5zaWduZWQgbG9u
ZyBleHBpcmVzKQp7CglpbnQgcmV0OwoJdW5zaWduZWQgbG9uZyBmbGFnczsKCglzcGluX2xvY2tf
aXJxc2F2ZSgmdGltZXJsaXN0X2xvY2ssIGZsYWdzKTsKCXRpbWVyLT5leHBpcmVzID0gZXhwaXJl
czsKCXJldCA9IGRldGFjaF90aW1lcih0aW1lcik7CglpbnRlcm5hbF9hZGRfdGltZXIodGltZXIp
OwoJc3Bpbl91bmxvY2tfaXJxcmVzdG9yZSgmdGltZXJsaXN0X2xvY2ssIGZsYWdzKTsKCXJldHVy
biByZXQ7Cn0KI2lmZGVmIENPTkZJR19ISUdIX1JFU19USU1FUlMKaW50IG1vZF90aW1lcl9ocihz
dHJ1Y3QgdGltZXJfbGlzdCAqdGltZXIsIAogICAgICAgICAgICAgICAgIHVuc2lnbmVkIGxvbmcg
ZXhwaXJlcywKICAgICAgICAgICAgICAgICBsb25nIHN1Yl9leHBpcmVzKQp7CglpbnQgcmV0OwoJ
dW5zaWduZWQgbG9uZyBmbGFnczsKCglzcGluX2xvY2tfaXJxc2F2ZSgmdGltZXJsaXN0X2xvY2ss
IGZsYWdzKTsKCXRpbWVyLT5leHBpcmVzID0gZXhwaXJlczsKICAgICAgICB0aW1lci0+c3ViX2V4
cGlyZXMgPSBzdWJfZXhwaXJlczsKCXJldCA9IGRldGFjaF90aW1lcih0aW1lcik7CglpbnRlcm5h
bF9hZGRfdGltZXIodGltZXIpOwoJc3Bpbl91bmxvY2tfaXJxcmVzdG9yZSgmdGltZXJsaXN0X2xv
Y2ssIGZsYWdzKTsKCXJldHVybiByZXQ7Cn0KI2VuZGlmIC8qIENPTkZJR19ISUdIX1JFU19USU1F
UlMgKi8KCmludCBkZWxfdGltZXIoc3RydWN0IHRpbWVyX2xpc3QgKiB0aW1lcikKewoJaW50IHJl
dDsKCXVuc2lnbmVkIGxvbmcgZmxhZ3M7CgoJc3Bpbl9sb2NrX2lycXNhdmUoJnRpbWVybGlzdF9s
b2NrLCBmbGFncyk7CglyZXQgPSBkZXRhY2hfdGltZXIodGltZXIpOwoJdGltZXItPmxpc3QubmV4
dCA9IHRpbWVyLT5saXN0LnByZXYgPSBOVUxMOwoJc3Bpbl91bmxvY2tfaXJxcmVzdG9yZSgmdGlt
ZXJsaXN0X2xvY2ssIGZsYWdzKTsKCXJldHVybiByZXQ7Cn0KCiNpZmRlZiBDT05GSUdfU01QCnZv
aWQgc3luY190aW1lcnModm9pZCkKewoJc3Bpbl91bmxvY2tfd2FpdCgmZ2xvYmFsX2JoX2xvY2sp
Owp9CgovKgogKiBTTVAgc3BlY2lmaWMgZnVuY3Rpb24gdG8gZGVsZXRlIHBlcmlvZGljIHRpbWVy
LgogKiBDYWxsZXIgbXVzdCBkaXNhYmxlIGJ5IHNvbWUgbWVhbnMgcmVzdGFydGluZyB0aGUgdGlt
ZXIKICogZm9yIG5ldy4gVXBvbiBleGl0IHRoZSB0aW1lciBpcyBub3QgcXVldWVkIGFuZCBoYW5k
bGVyIGlzIG5vdCBydW5uaW5nCiAqIG9uIGFueSBDUFUuIEl0IHJldHVybnMgbnVtYmVyIG9mIHRp
bWVzLCB3aGljaCB0aW1lciB3YXMgZGVsZXRlZAogKiAoZm9yIHJlZmVyZW5jZSBjb3VudGluZyku
CiAqLwoKaW50IGRlbF90aW1lcl9zeW5jKHN0cnVjdCB0aW1lcl9saXN0ICogdGltZXIpCnsKCWlu
dCByZXQgPSAwOwoKCWZvciAoOzspIHsKCQl1bnNpZ25lZCBsb25nIGZsYWdzOwoJCWludCBydW5u
aW5nOwoKCQlzcGluX2xvY2tfaXJxc2F2ZSgmdGltZXJsaXN0X2xvY2ssIGZsYWdzKTsKCQlyZXQg
Kz0gZGV0YWNoX3RpbWVyKHRpbWVyKTsKCQl0aW1lci0+bGlzdC5uZXh0ID0gdGltZXItPmxpc3Qu
cHJldiA9IDA7CgkJcnVubmluZyA9IHRpbWVyX2lzX3J1bm5pbmcodGltZXIpOwoJCXNwaW5fdW5s
b2NrX2lycXJlc3RvcmUoJnRpbWVybGlzdF9sb2NrLCBmbGFncyk7CgoJCWlmICghcnVubmluZykK
CQkJYnJlYWs7CgoJCXRpbWVyX3N5bmNocm9uaXplKHRpbWVyKTsKCX0KCglyZXR1cm4gcmV0Owp9
CiNlbmRpZgoKI2lmZGVmIENPTkZJR19DQVNDQURJTkdfVElNRVJTCgpzdGF0aWMgaW5saW5lIHZv
aWQgY2FzY2FkZV90aW1lcnMoc3RydWN0IHRpbWVyX3ZlYyAqdHYpCnsKCS8qIGNhc2NhZGUgYWxs
IHRoZSB0aW1lcnMgZnJvbSB0diB1cCBvbmUgbGV2ZWwgKi8KCXN0cnVjdCBsaXN0X2hlYWQgKmhl
YWQsICpjdXJyLCAqbmV4dDsKCgloZWFkID0gdHYtPnZlYyArIHR2LT5pbmRleDsKCWN1cnIgPSBo
ZWFkLT5uZXh0OwoJLyoKCSAqIFdlIGFyZSByZW1vdmluZyBfYWxsXyB0aW1lcnMgZnJvbSB0aGUg
bGlzdCwgc28gd2UgZG9uJ3QgIGhhdmUgdG8KCSAqIGRldGFjaCB0aGVtIGluZGl2aWR1YWxseSwg
anVzdCBjbGVhciB0aGUgbGlzdCBhZnRlcndhcmRzLgoJICovCgl3aGlsZSAoY3VyciAhPSBoZWFk
KSB7CgkJc3RydWN0IHRpbWVyX2xpc3QgKnRtcDsKCgkJdG1wID0gbGlzdF9lbnRyeShjdXJyLCBz
dHJ1Y3QgdGltZXJfbGlzdCwgbGlzdCk7CgkJbmV4dCA9IGN1cnItPm5leHQ7CgkJbGlzdF9kZWwo
Y3Vycik7IC8vIG5vdCBuZWVkZWQKCQlpbnRlcm5hbF9hZGRfdGltZXIodG1wKTsKCQljdXJyID0g
bmV4dDsKCX0KCUlOSVRfTElTVF9IRUFEKGhlYWQpOwoJdHYtPmluZGV4ID0gKHR2LT5pbmRleCAr
IDEpICYgVFZOX01BU0s7Cn0KI2VuZGlmIC8qIENPTkZJR19DQVNDQURJTkdfVElNRVJTICovCgpz
dGF0aWMgaW5saW5lIHZvaWQgcnVuX3RpbWVyX2xpc3Qodm9pZCkKewogICAgICAgIElGX0hJR0hf
UkVTKCB1bnNpZ25lZCBsb25nIGppZmZpZXNfZjsKICAgICAgICAgICAgICAgICAgICAgbG9uZyBz
dWJfamlmZiA9IC0xOwogICAgICAgICAgICAgICAgICAgICBsb25nIHN1Yl9qaWZmaWVfZik7Cglz
cGluX2xvY2tfaXJxKCZ0aW1lcmxpc3RfbG9jayk7CiNpZmRlZiBDT05GSUdfSElHSF9SRVNfVElN
RVJTCiAgICAgICAgcmVhZF9sb2NrKCZ4dGltZV9sb2NrKTsKICAgICAgICBqaWZmaWVzX2YgPSBq
aWZmaWVzOwogICAgICAgIHN1Yl9qaWZmaWVfZiA9IHN1Yl9qaWZmaWUoKSArIHF1aWNrX2dldF9j
cHVjdHIoKTsKICAgICAgICByZWFkX3VubG9jaygmeHRpbWVfbG9jayk7CiAgICAgICAgd2hpbGUg
KCB1bmxpa2VseShzdWJfamlmZmllX2YgPj0gY3ljbGVzX3Blcl9qaWZmaWVzKSl7CiAgICAgICAg
ICAgICAgICBzdWJfamlmZmllX2YgLT0gY3ljbGVzX3Blcl9qaWZmaWVzOwogICAgICAgICAgICAg
ICAgamlmZmllc19mKys7CiAgICAgICAgfQoJd2hpbGUgKChsb25nKShqaWZmaWVzX2YgLSB0aW1l
cl9qaWZmaWVzKSA+PSAwKSB7CiNlbHNlCgl3aGlsZSAoKGxvbmcpKGppZmZpZXMgLSB0aW1lcl9q
aWZmaWVzKSA+PSAwKSB7CiNlbmRpZiAvKiBDT05GSUdfSElHSF9SRVNfVElNRVJTICovCgkJc3Ry
dWN0IGxpc3RfaGVhZCAqaGVhZCwgKmN1cnI7CiNpZmRlZiBDT05GSUdfQ0FTQ0FESU5HX1RJTUVS
UwoJCWlmICghdHYxLmluZGV4KSB7CgkJCWludCBuID0gMTsKCQkJZG8gewoJCQkJY2FzY2FkZV90
aW1lcnModHZlY3Nbbl0pOwoJCQl9IHdoaWxlICh0dmVjc1tuXS0+aW5kZXggPT0gMSAmJiArK24g
PCBOT09GX1RWRUNTKTsKCQl9CgoJCWhlYWQgPSB0djEudmVjICsgdHYxLmluZGV4OwojZW5kaWYg
LyogQ09ORklHX0NBU0NBRElOR19USU1FUlMgKi8KICAgICAgICAgICAgICAgIElGX05FV19USU1F
Ul9MSVNUKAogICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgaGVhZCA9IG5ld190dmVj
ICsgCiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAodGltZXJfamlmZmllcyAgJiBO
RVdfVFZFQ19NQVNLKTsKICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICkKICAgICAg
ICAgICAgICAgIC8qCiAgICAgICAgICAgICAgICAgKiBOb3RlIHRoYXQgd2UgbmV2ZXIgbW92ZSAi
aGVhZCIgYnV0IGNvbnRpbnVlIHRvCiAgICAgICAgICAgICAgICAgKiBwaWNrIHRoZSBmaXJzdCBl
bnRyeSBmcm9tIGl0LiAgVGhpcyBhbGxvd3MgbmV3CiAgICAgICAgICAgICAgICAgKiBlbnRyaWVz
IHRvIGJlIGluc2VydGVkIHdoaWxlIHdlIHVubG9jayBmb3IgdGhlCiAgICAgICAgICAgICAgICAg
KiBmdW5jdGlvbiBjYWxsIGJlbG93LgogICAgICAgICAgICAgICAgICovCnJlcGVhdDoKCQljdXJy
ID0gaGVhZC0+bmV4dDsKCQlpZiAoY3VyciAhPSBoZWFkKSB7CgkJCXN0cnVjdCB0aW1lcl9saXN0
ICp0aW1lcjsKCQkJdm9pZCAoKmZuKSh1bnNpZ25lZCBsb25nKTsKCQkJdW5zaWduZWQgbG9uZyBk
YXRhOwoKCQkJdGltZXIgPSBsaXN0X2VudHJ5KGN1cnIsIHN0cnVjdCB0aW1lcl9saXN0LCBsaXN0
KTsKI2lmZGVmIENPTkZJR19ISUdIX1JFU19USU1FUlMKICAgICAgICAgICAgICAgICAgICAgICAg
LyoKICAgICAgICAgICAgICAgICAgICAgICAgICogVGhpcyB3b3VsZCBiZSBzaW1wbGVyIGlmIHdl
IG5ldmVyIGdvdCBiZWhpbmQKICAgICAgICAgICAgICAgICAgICAgICAgICogaS5lLiBpZiB0aW1l
cl9qaWZmaWVzID09IGppZmZpZXMsIHdlIGNvdWxkCiAgICAgICAgICAgICAgICAgICAgICAgICAq
IGRyb3Agb25lIG9mIHRoZSB0ZXN0cy4gIFNpbmNlIHdlIG1heSBnZXQgCiAgICAgICAgICAgICAg
ICAgICAgICAgICAqIGJlaGluZCwgKGluIGZhY3Qgd2UgZG9uJ3QgdXAgZGF0ZSB1bnRpbAogICAg
ICAgICAgICAgICAgICAgICAgICAgKiB3ZSBhcmUgYmVoaW5kIHRvIGFsbG93IHN1Yl9qaWZmaWUg
ZW50cmllcykKICAgICAgICAgICAgICAgICAgICAgICAgICogd2UgbmVlZCBhIHdheSB0byBuZWdh
dGUgdGhlIHN1Yl9qaWZmaWUKICAgICAgICAgICAgICAgICAgICAgICAgICogdGVzdCBpbiB0aGF0
IGNhc2UuLi4KICAgICAgICAgICAgICAgICAgICAgICAgICovCiAgICAgICAgICAgICAgICAgICAg
ICAgIGlmICh0aW1lX2JlZm9yZSh0aW1lci0+ZXhwaXJlcywgamlmZmllc19mKXx8CiAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAoKHRpbWVyLT5leHBpcmVzID09IGppZmZpZXNfZikgJiYKICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICB0aW1lci0+c3ViX2V4cGlyZXMgPD0gc3ViX2ppZmZp
ZV9mKSkKI2Vsc2UKICAgICAgICAgICAgICAgICAgICAgICAgaWYgKHRpbWVfYmVmb3JlX2VxKHRp
bWVyLT5leHBpcmVzLCBqaWZmaWVzKSkKI2VuZGlmIC8qICBDT05GSUdfSElHSF9SRVNfVElNRVJT
ICovCiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAge2ZuID0gdGltZXItPmZ1bmN0aW9u
OwogCQkJZGF0YT0gdGltZXItPmRhdGE7CgoJCQlkZXRhY2hfdGltZXIodGltZXIpOwoJCQl0aW1l
ci0+bGlzdC5uZXh0ID0gdGltZXItPmxpc3QucHJldiA9IE5VTEw7CgkJCXRpbWVyX2VudGVyKHRp
bWVyKTsKCQkJc3Bpbl91bmxvY2tfaXJxKCZ0aW1lcmxpc3RfbG9jayk7CgkJCWZuKGRhdGEpOwoJ
CQlzcGluX2xvY2tfaXJxKCZ0aW1lcmxpc3RfbG9jayk7CgkJCXRpbWVyX2V4aXQoKTsKCQkJZ290
byByZXBlYXQ7CgkJfQojaWZkZWYgQ09ORklHX0hJR0hfUkVTX1RJTUVSUwogICAgICAgICAgICAg
ICAgICAgICAgICBlbHNlewogICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIC8qCiAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICogVGhlIG5ldyB0aW1lciBsaXN0IGlzIG5vdCBh
bHdheXMgZW1wdGllZAogICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAqIGhlcmUgYXMg
aXQgY29udGFpbnM6CiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICogYS4pIGVudHJp
ZXMgKGxpc3Qgc2l6ZSleTipqaWZmaWVzIG91dCBhbmQKICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgKiBiLikgZW50cmllcyB0aGF0IG1hdGNoIGluIGppZmZpZXMsIGJ1dCBoYXZlCiAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICogICAgIHN1Yl9leHBpcmUgdGltZXMgZnVy
dGhlciBvdXQgdGhhbiBub3cuCiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICovCiAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIGlmICh0aW1lci0+ZXhwaXJlcyA9PSBqaWZm
aWVzX2YgKXsKICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIHN1Yl9qaWZm
ID0gdGltZXItPnN1Yl9leHBpcmVzOwogICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIH0K
ICAgICAgICAgICAgICAgICAgICAgICAgfQojZW5kaWYgLyogQ09ORklHX0hJR0hfUkVTX1RJTUVS
UyAqLwogICAgICAgICAgICAgICAgfQoJCSsrdGltZXJfamlmZmllczsgCiNpZmRlZiBDT05GSUdf
Q0FTQ0FESU5HX1RJTUVSUwoJCXR2MS5pbmRleCA9ICh0djEuaW5kZXggKyAxKSAmIFRWUl9NQVNL
OwojZW5kaWYKCX0KICAgICAgICAvKgogICAgICAgICAqIEl0IGlzIGZhc3RlciB0byBiYWNrIG91
dCB0aGUgbGFzdCBidW1wLCB0aGFuIHRvIHByZXZlbnQgaXQuCiAgICAgICAgICogVGhpcyBhbGxv
d3MgemVybyB0aW1lIGluc2VydHMgYXMgd2VsbCBhcyBzdWJfamlmZmllIHZhbHVlcyBpbgogICAg
ICAgICAqIHRoZSBjdXJyZW50IGppZmZpZS4gIFdpbGwgbm90IHdvcmsgZm9yIHRoZSBjYXNjYWRl
IGFzIHR2MS5pbmRleAogICAgICAgICAqIGFsc28gbmVlZHMgYWRqdXN0aW5nLiAKICAgICAgICAg
Ki8KICAgICAgICBJRl9ORVdfVElNRVJfTElTVCgtLXRpbWVyX2ppZmZpZXMpOwoKICAgICAgICBJ
Rl9ISUdIX1JFUyhpZiAoc2NoZWR1bGVfbmV4dF9pbnQoIGppZmZpZXNfZiwgc3ViX2ppZmYsIDAp
KXsKICAgICAgICAgICAgICAgIC8qCiAgICAgICAgICAgICAgICAgKiBJZiBzY2hlZHVsZV9uZXh0
X2ludCBzYXlzIHRoZSB0aW1lIGhhcyBwYXNzZWQKICAgICAgICAgICAgICAgICAqIGJ1bXAgdGhl
IHRhc2tsZXQgbG9jayBzbyB3ZSBnbyByb3VuZCBhZ2FpbgogICAgICAgICAgICAgICAgICovCiAg
ICAgICAgICAgICAgICBhdG9taWNfaW5jKCZ0aW1lcl90YXNrbGV0X2xvY2spOwogICAgICAgICAg
ICAgICAgfSk7CgoJc3Bpbl91bmxvY2tfaXJxKCZ0aW1lcmxpc3RfbG9jayk7Cn0KCnNwaW5sb2Nr
X3QgdHF1ZXVlX2xvY2sgPSBTUElOX0xPQ0tfVU5MT0NLRUQ7Cgp2b2lkIHRxdWV1ZV9iaCh2b2lk
KQp7CglydW5fdGFza19xdWV1ZSgmdHFfdGltZXIpOwp9Cgp2b2lkIGltbWVkaWF0ZV9iaCh2b2lk
KQp7CglydW5fdGFza19xdWV1ZSgmdHFfaW1tZWRpYXRlKTsKfQoKLyoKICogdGhpcyByb3V0aW5l
IGhhbmRsZXMgdGhlIG92ZXJmbG93IG9mIHRoZSBtaWNyb3NlY29uZCBmaWVsZAogKgogKiBUaGUg
dHJpY2t5IGJpdHMgb2YgY29kZSB0byBoYW5kbGUgdGhlIGFjY3VyYXRlIGNsb2NrIHN1cHBvcnQK
ICogd2VyZSBwcm92aWRlZCBieSBEYXZlIE1pbGxzIChNaWxsc0BVREVMLkVEVSkgb2YgTlRQIGZh
bWUuCiAqIFRoZXkgd2VyZSBvcmlnaW5hbGx5IGRldmVsb3BlZCBmb3IgU1VOIGFuZCBERUMga2Vy
bmVscy4KICogQWxsIHRoZSBrdWRvcyBzaG91bGQgZ28gdG8gRGF2ZSBmb3IgdGhpcyBzdHVmZi4K
ICoKICovCnN0YXRpYyB2b2lkIHNlY29uZF9vdmVyZmxvdyh2b2lkKQp7CiAgICBsb25nIGx0ZW1w
OwoKICAgIC8qIEJ1bXAgdGhlIG1heGVycm9yIGZpZWxkICovCiAgICB0aW1lX21heGVycm9yICs9
IHRpbWVfdG9sZXJhbmNlID4+IFNISUZUX1VTRUM7CiAgICBpZiAoIHRpbWVfbWF4ZXJyb3IgPiBO
VFBfUEhBU0VfTElNSVQgKSB7Cgl0aW1lX21heGVycm9yID0gTlRQX1BIQVNFX0xJTUlUOwoJdGlt
ZV9zdGF0dXMgfD0gU1RBX1VOU1lOQzsKICAgIH0KCiAgICAvKgogICAgICogTGVhcCBzZWNvbmQg
cHJvY2Vzc2luZy4gSWYgaW4gbGVhcC1pbnNlcnQgc3RhdGUgYXQKICAgICAqIHRoZSBlbmQgb2Yg
dGhlIGRheSwgdGhlIHN5c3RlbSBjbG9jayBpcyBzZXQgYmFjayBvbmUKICAgICAqIHNlY29uZDsg
aWYgaW4gbGVhcC1kZWxldGUgc3RhdGUsIHRoZSBzeXN0ZW0gY2xvY2sgaXMKICAgICAqIHNldCBh
aGVhZCBvbmUgc2Vjb25kLiBUaGUgbWljcm90aW1lKCkgcm91dGluZSBvcgogICAgICogZXh0ZXJu
YWwgY2xvY2sgZHJpdmVyIHdpbGwgaW5zdXJlIHRoYXQgcmVwb3J0ZWQgdGltZQogICAgICogaXMg
YWx3YXlzIG1vbm90b25pYy4gVGhlIHVnbHkgZGl2aWRlcyBzaG91bGQgYmUKICAgICAqIHJlcGxh
Y2VkLgogICAgICovCiAgICBzd2l0Y2ggKHRpbWVfc3RhdGUpIHsKCiAgICBjYXNlIFRJTUVfT0s6
CglpZiAodGltZV9zdGF0dXMgJiBTVEFfSU5TKQoJICAgIHRpbWVfc3RhdGUgPSBUSU1FX0lOUzsK
CWVsc2UgaWYgKHRpbWVfc3RhdHVzICYgU1RBX0RFTCkKCSAgICB0aW1lX3N0YXRlID0gVElNRV9E
RUw7CglicmVhazsKCiAgICBjYXNlIFRJTUVfSU5TOgoJaWYgKHh0aW1lLnR2X3NlYyAlIDg2NDAw
ID09IDApIHsKCSAgICB4dGltZS50dl9zZWMtLTsKCSAgICB0aW1lX3N0YXRlID0gVElNRV9PT1A7
CgkgICAgcHJpbnRrKEtFUk5fTk9USUNFICJDbG9jazogaW5zZXJ0aW5nIGxlYXAgc2Vjb25kIDIz
OjU5OjYwIFVUQ1xuIik7Cgl9CglicmVhazsKCiAgICBjYXNlIFRJTUVfREVMOgoJaWYgKCh4dGlt
ZS50dl9zZWMgKyAxKSAlIDg2NDAwID09IDApIHsKCSAgICB4dGltZS50dl9zZWMrKzsKCSAgICB0
aW1lX3N0YXRlID0gVElNRV9XQUlUOwoJICAgIHByaW50ayhLRVJOX05PVElDRSAiQ2xvY2s6IGRl
bGV0aW5nIGxlYXAgc2Vjb25kIDIzOjU5OjU5IFVUQ1xuIik7Cgl9CglicmVhazsKCiAgICBjYXNl
IFRJTUVfT09QOgoJdGltZV9zdGF0ZSA9IFRJTUVfV0FJVDsKCWJyZWFrOwoKICAgIGNhc2UgVElN
RV9XQUlUOgoJaWYgKCEodGltZV9zdGF0dXMgJiAoU1RBX0lOUyB8IFNUQV9ERUwpKSkKCSAgICB0
aW1lX3N0YXRlID0gVElNRV9PSzsKICAgIH0KCiAgICAvKgogICAgICogQ29tcHV0ZSB0aGUgcGhh
c2UgYWRqdXN0bWVudCBmb3IgdGhlIG5leHQgc2Vjb25kLiBJbgogICAgICogUExMIG1vZGUsIHRo
ZSBvZmZzZXQgaXMgcmVkdWNlZCBieSBhIGZpeGVkIGZhY3RvcgogICAgICogdGltZXMgdGhlIHRp
bWUgY29uc3RhbnQuIEluIEZMTCBtb2RlIHRoZSBvZmZzZXQgaXMKICAgICAqIHVzZWQgZGlyZWN0
bHkuIEluIGVpdGhlciBtb2RlLCB0aGUgbWF4aW11bSBwaGFzZQogICAgICogYWRqdXN0bWVudCBm
b3IgZWFjaCBzZWNvbmQgaXMgY2xhbXBlZCBzbyBhcyB0byBzcHJlYWQKICAgICAqIHRoZSBhZGp1
c3RtZW50IG92ZXIgbm90IG1vcmUgdGhhbiB0aGUgbnVtYmVyIG9mCiAgICAgKiBzZWNvbmRzIGJl
dHdlZW4gdXBkYXRlcy4KICAgICAqLwogICAgaWYgKHRpbWVfb2Zmc2V0IDwgMCkgewoJbHRlbXAg
PSAtdGltZV9vZmZzZXQ7CglpZiAoISh0aW1lX3N0YXR1cyAmIFNUQV9GTEwpKQoJICAgIGx0ZW1w
ID4+PSBTSElGVF9LRyArIHRpbWVfY29uc3RhbnQ7CglpZiAobHRlbXAgPiAoTUFYUEhBU0UgLyBN
SU5TRUMpIDw8IFNISUZUX1VQREFURSkKCSAgICBsdGVtcCA9IChNQVhQSEFTRSAvIE1JTlNFQykg
PDwgU0hJRlRfVVBEQVRFOwoJdGltZV9vZmZzZXQgKz0gbHRlbXA7Cgl0aW1lX2FkaiA9IC1sdGVt
cCA8PCAoU0hJRlRfU0NBTEUgLSBTSElGVF9IWiAtIFNISUZUX1VQREFURSk7CiAgICB9IGVsc2Ug
ewoJbHRlbXAgPSB0aW1lX29mZnNldDsKCWlmICghKHRpbWVfc3RhdHVzICYgU1RBX0ZMTCkpCgkg
ICAgbHRlbXAgPj49IFNISUZUX0tHICsgdGltZV9jb25zdGFudDsKCWlmIChsdGVtcCA+IChNQVhQ
SEFTRSAvIE1JTlNFQykgPDwgU0hJRlRfVVBEQVRFKQoJICAgIGx0ZW1wID0gKE1BWFBIQVNFIC8g
TUlOU0VDKSA8PCBTSElGVF9VUERBVEU7Cgl0aW1lX29mZnNldCAtPSBsdGVtcDsKCXRpbWVfYWRq
ID0gbHRlbXAgPDwgKFNISUZUX1NDQUxFIC0gU0hJRlRfSFogLSBTSElGVF9VUERBVEUpOwogICAg
fQoKICAgIC8qCiAgICAgKiBDb21wdXRlIHRoZSBmcmVxdWVuY3kgZXN0aW1hdGUgYW5kIGFkZGl0
aW9uYWwgcGhhc2UKICAgICAqIGFkanVzdG1lbnQgZHVlIHRvIGZyZXF1ZW5jeSBlcnJvciBmb3Ig
dGhlIG5leHQKICAgICAqIHNlY29uZC4gV2hlbiB0aGUgUFBTIHNpZ25hbCBpcyBlbmdhZ2VkLCBn
bmF3IG9uIHRoZQogICAgICogd2F0Y2hkb2cgY291bnRlciBhbmQgdXBkYXRlIHRoZSBmcmVxdWVu
Y3kgY29tcHV0ZWQgYnkKICAgICAqIHRoZSBwbGwgYW5kIHRoZSBQUFMgc2lnbmFsLgogICAgICov
CiAgICBwcHNfdmFsaWQrKzsKICAgIGlmIChwcHNfdmFsaWQgPT0gUFBTX1ZBTElEKSB7CS8qIFBQ
UyBzaWduYWwgbG9zdCAqLwoJcHBzX2ppdHRlciA9IE1BWFRJTUU7CglwcHNfc3RhYmlsID0gTUFY
RlJFUTsKCXRpbWVfc3RhdHVzICY9IH4oU1RBX1BQU1NJR05BTCB8IFNUQV9QUFNKSVRURVIgfAoJ
CQkgU1RBX1BQU1dBTkRFUiB8IFNUQV9QUFNFUlJPUik7CiAgICB9CiAgICBsdGVtcCA9IHRpbWVf
ZnJlcSArIHBwc19mcmVxOwogICAgaWYgKGx0ZW1wIDwgMCkKCXRpbWVfYWRqIC09IC1sdGVtcCA+
PgoJICAgIChTSElGVF9VU0VDICsgU0hJRlRfSFogLSBTSElGVF9TQ0FMRSk7CiAgICBlbHNlCgl0
aW1lX2FkaiArPSBsdGVtcCA+PgoJICAgIChTSElGVF9VU0VDICsgU0hJRlRfSFogLSBTSElGVF9T
Q0FMRSk7CgojaWYgSFogPT0gMTAwCiAgICAvKiBDb21wZW5zYXRlIGZvciAoSFo9PTEwMCkgIT0g
KDEgPDwgU0hJRlRfSFopLgogICAgICogQWRkIDI1JSBhbmQgMy4xMjUlIHRvIGdldCAxMjguMTI1
OyA9PiBvbmx5IDAuMTI1JSBlcnJvciAocC4gMTQpCiAgICAgKi8KICAgIGlmICh0aW1lX2FkaiA8
IDApCgl0aW1lX2FkaiAtPSAoLXRpbWVfYWRqID4+IDIpICsgKC10aW1lX2FkaiA+PiA1KTsKICAg
IGVsc2UKCXRpbWVfYWRqICs9ICh0aW1lX2FkaiA+PiAyKSArICh0aW1lX2FkaiA+PiA1KTsKI2Vu
ZGlmCn0KCi8qIGluIHRoZSBOVFAgcmVmZXJlbmNlIHRoaXMgaXMgY2FsbGVkICJoYXJkY2xvY2so
KSIgKi8Kc3RhdGljIHZvaWQgdXBkYXRlX3dhbGxfdGltZV9vbmVfdGljayh2b2lkKQp7CglpZiAo
ICh0aW1lX2FkanVzdF9zdGVwID0gdGltZV9hZGp1c3QpICE9IDAgKSB7CgkgICAgLyogV2UgYXJl
IGRvaW5nIGFuIGFkanRpbWUgdGhpbmcuIAoJICAgICAqCgkgICAgICogUHJlcGFyZSB0aW1lX2Fk
anVzdF9zdGVwIHRvIGJlIHdpdGhpbiBib3VuZHMuCgkgICAgICogTm90ZSB0aGF0IGEgcG9zaXRp
dmUgdGltZV9hZGp1c3QgbWVhbnMgd2Ugd2FudCB0aGUgY2xvY2sKCSAgICAgKiB0byBydW4gZmFz
dGVyLgoJICAgICAqCgkgICAgICogTGltaXQgdGhlIGFtb3VudCBvZiB0aGUgc3RlcCB0byBiZSBp
biB0aGUgcmFuZ2UKCSAgICAgKiAtdGlja2FkaiAuLiArdGlja2FkagoJICAgICAqLwoJICAgICBp
ZiAodGltZV9hZGp1c3QgPiB0aWNrYWRqKQoJCXRpbWVfYWRqdXN0X3N0ZXAgPSB0aWNrYWRqOwoJ
ICAgICBlbHNlIGlmICh0aW1lX2FkanVzdCA8IC10aWNrYWRqKQoJCXRpbWVfYWRqdXN0X3N0ZXAg
PSAtdGlja2FkajsKCSAgICAgCgkgICAgLyogUmVkdWNlIGJ5IHRoaXMgc3RlcCB0aGUgYW1vdW50
IG9mIHRpbWUgbGVmdCAgKi8KCSAgICB0aW1lX2FkanVzdCAtPSB0aW1lX2FkanVzdF9zdGVwOwoJ
fQoJeHRpbWUudHZfdXNlYyArPSB0aWNrICsgdGltZV9hZGp1c3Rfc3RlcDsKCS8qCgkgKiBBZHZh
bmNlIHRoZSBwaGFzZSwgb25jZSBpdCBnZXRzIHRvIG9uZSBtaWNyb3NlY29uZCwgdGhlbgoJICog
YWR2YW5jZSB0aGUgdGljayBtb3JlLgoJICovCgl0aW1lX3BoYXNlICs9IHRpbWVfYWRqOwoJaWYg
KHRpbWVfcGhhc2UgPD0gLUZJTkVVU0VDKSB7CgkJbG9uZyBsdGVtcCA9IC10aW1lX3BoYXNlID4+
IFNISUZUX1NDQUxFOwoJCXRpbWVfcGhhc2UgKz0gbHRlbXAgPDwgU0hJRlRfU0NBTEU7CgkJeHRp
bWUudHZfdXNlYyAtPSBsdGVtcDsKCX0KCWVsc2UgaWYgKHRpbWVfcGhhc2UgPj0gRklORVVTRUMp
IHsKCQlsb25nIGx0ZW1wID0gdGltZV9waGFzZSA+PiBTSElGVF9TQ0FMRTsKCQl0aW1lX3BoYXNl
IC09IGx0ZW1wIDw8IFNISUZUX1NDQUxFOwoJCXh0aW1lLnR2X3VzZWMgKz0gbHRlbXA7Cgl9Cn0K
Ci8qCiAqIFVzaW5nIGEgbG9vcCBsb29rcyBpbmVmZmljaWVudCwgYnV0ICJ0aWNrcyIgaXMKICog
dXN1YWxseSBqdXN0IG9uZSAod2Ugc2hvdWxkbid0IGJlIGxvc2luZyB0aWNrcywKICogd2UncmUg
ZG9pbmcgdGhpcyB0aGlzIHdheSBtYWlubHkgZm9yIGludGVycnVwdAogKiBsYXRlbmN5IHJlYXNv
bnMsIG5vdCBiZWNhdXNlIHdlIHRoaW5rIHdlJ2xsCiAqIGhhdmUgbG90cyBvZiBsb3N0IHRpbWVy
IHRpY2tzCiAqLwpzdGF0aWMgdm9pZCB1cGRhdGVfd2FsbF90aW1lKHVuc2lnbmVkIGxvbmcgdGlj
a3MpCnsKCWRvIHsKCQl0aWNrcy0tOwoJCXVwZGF0ZV93YWxsX3RpbWVfb25lX3RpY2soKTsKCX0g
d2hpbGUgKHRpY2tzKTsKCglpZiAoeHRpbWUudHZfdXNlYyA+PSAxMDAwMDAwKSB7CgkgICAgeHRp
bWUudHZfdXNlYyAtPSAxMDAwMDAwOwoJICAgIHh0aW1lLnR2X3NlYysrOwoJICAgIHNlY29uZF9v
dmVyZmxvdygpOwoJfQp9CgpzdGF0aWMgaW5saW5lIHZvaWQgZG9fcHJvY2Vzc190aW1lcyhzdHJ1
Y3QgdGFza19zdHJ1Y3QgKnAsCgl1bnNpZ25lZCBsb25nIHVzZXIsIHVuc2lnbmVkIGxvbmcgc3lz
dGVtKQp7Cgl1bnNpZ25lZCBsb25nIHBzZWNzOwoKCXBzZWNzID0gKHAtPnRpbWVzLnRtc191dGlt
ZSArPSB1c2VyKTsKCXBzZWNzICs9IChwLT50aW1lcy50bXNfc3RpbWUgKz0gc3lzdGVtKTsKCWlm
IChwc2VjcyAvIEhaID4gcC0+cmxpbVtSTElNSVRfQ1BVXS5ybGltX2N1cikgewoJCS8qIFNlbmQg
U0lHWENQVSBldmVyeSBzZWNvbmQuLiAqLwoJCWlmICghKHBzZWNzICUgSFopKQoJCQlzZW5kX3Np
ZyhTSUdYQ1BVLCBwLCAxKTsKCQkvKiBhbmQgU0lHS0lMTCB3aGVuIHdlIGdvIG92ZXIgbWF4Li4g
Ki8KCQlpZiAocHNlY3MgLyBIWiA+IHAtPnJsaW1bUkxJTUlUX0NQVV0ucmxpbV9tYXgpCgkJCXNl
bmRfc2lnKFNJR0tJTEwsIHAsIDEpOwoJfQp9CgpzdGF0aWMgaW5saW5lIHZvaWQgZG9faXRfdmly
dChzdHJ1Y3QgdGFza19zdHJ1Y3QgKiBwLCB1bnNpZ25lZCBsb25nIHRpY2tzKQp7Cgl1bnNpZ25l
ZCBsb25nIGl0X3ZpcnQgPSBwLT5pdF92aXJ0X3ZhbHVlOwoKCWlmIChpdF92aXJ0KSB7CgkJaXRf
dmlydCAtPSB0aWNrczsKCQlpZiAoIWl0X3ZpcnQpIHsKCQkJaXRfdmlydCA9IHAtPml0X3ZpcnRf
aW5jcjsKCQkJc2VuZF9zaWcoU0lHVlRBTFJNLCBwLCAxKTsKCQl9CgkJcC0+aXRfdmlydF92YWx1
ZSA9IGl0X3ZpcnQ7Cgl9Cn0KCnN0YXRpYyBpbmxpbmUgdm9pZCBkb19pdF9wcm9mKHN0cnVjdCB0
YXNrX3N0cnVjdCAqcCkKewoJdW5zaWduZWQgbG9uZyBpdF9wcm9mID0gcC0+aXRfcHJvZl92YWx1
ZTsKCglpZiAoaXRfcHJvZikgewoJCWlmICgtLWl0X3Byb2YgPT0gMCkgewoJCQlpdF9wcm9mID0g
cC0+aXRfcHJvZl9pbmNyOwoJCQlzZW5kX3NpZyhTSUdQUk9GLCBwLCAxKTsKCQl9CgkJcC0+aXRf
cHJvZl92YWx1ZSA9IGl0X3Byb2Y7Cgl9Cn0KCnZvaWQgdXBkYXRlX29uZV9wcm9jZXNzKHN0cnVj
dCB0YXNrX3N0cnVjdCAqcCwgdW5zaWduZWQgbG9uZyB1c2VyLAoJCQl1bnNpZ25lZCBsb25nIHN5
c3RlbSwgaW50IGNwdSkKewoJcC0+cGVyX2NwdV91dGltZVtjcHVdICs9IHVzZXI7CglwLT5wZXJf
Y3B1X3N0aW1lW2NwdV0gKz0gc3lzdGVtOwoJZG9fcHJvY2Vzc190aW1lcyhwLCB1c2VyLCBzeXN0
ZW0pOwoJZG9faXRfdmlydChwLCB1c2VyKTsKCWRvX2l0X3Byb2YocCk7Cn0JCgovKgogKiBDYWxs
ZWQgZnJvbSB0aGUgdGltZXIgaW50ZXJydXB0IGhhbmRsZXIgdG8gY2hhcmdlIG9uZSB0aWNrIHRv
IHRoZSBjdXJyZW50IAogKiBwcm9jZXNzLiAgdXNlcl90aWNrIGlzIDEgaWYgdGhlIHRpY2sgaXMg
dXNlciB0aW1lLCAwIGZvciBzeXN0ZW0uCiAqLwp2b2lkIHVwZGF0ZV9wcm9jZXNzX3RpbWVzKGlu
dCB1c2VyX3RpY2spCnsKCXN0cnVjdCB0YXNrX3N0cnVjdCAqcCA9IGN1cnJlbnQ7CglpbnQgY3B1
ID0gc21wX3Byb2Nlc3Nvcl9pZCgpLCBzeXN0ZW0gPSB1c2VyX3RpY2sgXiAxOwoKCXVwZGF0ZV9v
bmVfcHJvY2VzcyhwLCB1c2VyX3RpY2ssIHN5c3RlbSwgY3B1KTsKCWlmIChwLT5waWQpIHsKI2lm
ZGVmIENPTkZJR19SVFNDSEVECiAgICAgICAgICAgICAgICAvKiBTQ0hFRF9GSUZPIGFuZCB0aGUg
aWRsZShzKSBoYXZlIGNvdW50ZXJzIHNldCB0byAtMTAwLCAKICAgICAgICAgICAgICAgICAqIHNv
IHdlIHdvbid0IGNvdW50IHRoZW0sIHNlZW1zIGxpa2UgYSBnb29kIGlkZWEgZm9yIAogICAgICAg
ICAgICAgICAgICogYm90aCBzY2hlZHVsZXJzLCBidXQsIGJlaW5nIHB1cmUuLi4KICAgICAgICAg
ICAgICAgICAqLwoJCWlmIChwLT5jb3VudGVyID49IDAgJiYgLS1wLT5jb3VudGVyIDw9IDApIHsK
I2Vsc2UKCQlpZiAoLS1wLT5jb3VudGVyIDw9IDApIHsKI2VuZGlmCgkJCXAtPmNvdW50ZXIgPSAw
OwoJCQlwLT5uZWVkX3Jlc2NoZWQgPSAxOwoJCX0KCQlpZiAocC0+bmljZSA+IDApCgkJCWtzdGF0
LnBlcl9jcHVfbmljZVtjcHVdICs9IHVzZXJfdGljazsKCQllbHNlCgkJCWtzdGF0LnBlcl9jcHVf
dXNlcltjcHVdICs9IHVzZXJfdGljazsKCQlrc3RhdC5wZXJfY3B1X3N5c3RlbVtjcHVdICs9IHN5
c3RlbTsKCX0gZWxzZSBpZiAobG9jYWxfYmhfY291bnQoY3B1KSB8fCBsb2NhbF9pcnFfY291bnQo
Y3B1KSA+IDEpCgkJa3N0YXQucGVyX2NwdV9zeXN0ZW1bY3B1XSArPSBzeXN0ZW07Cn0KCi8qCiAq
IE5yIG9mIGFjdGl2ZSB0YXNrcyAtIGNvdW50ZWQgaW4gZml4ZWQtcG9pbnQgbnVtYmVycwogKi8K
c3RhdGljIHVuc2lnbmVkIGxvbmcgY291bnRfYWN0aXZlX3Rhc2tzKHZvaWQpCnsKCXN0cnVjdCB0
YXNrX3N0cnVjdCAqcDsKCXVuc2lnbmVkIGxvbmcgbnIgPSAwOwoKCXJlYWRfbG9jaygmdGFza2xp
c3RfbG9jayk7Cglmb3JfZWFjaF90YXNrKHApIHsKCQlpZiAoKHAtPnN0YXRlID09IFRBU0tfUlVO
TklORyB8fAoJCSAgICAgKHAtPnN0YXRlICYgVEFTS19VTklOVEVSUlVQVElCTEUpKSkKCQkJbnIg
Kz0gRklYRURfMTsKCX0KCXJlYWRfdW5sb2NrKCZ0YXNrbGlzdF9sb2NrKTsKCXJldHVybiBucjsK
fQoKLyoKICogSG1tLi4gQ2hhbmdlZCB0aGlzLCBhcyB0aGUgR05VIG1ha2Ugc291cmNlcyAobG9h
ZC5jKSBzZWVtcyB0bwogKiBpbXBseSB0aGF0IGF2ZW5ydW5bXSBpcyB0aGUgc3RhbmRhcmQgbmFt
ZSBmb3IgdGhpcyBraW5kIG9mIHRoaW5nLgogKiBOb3RoaW5nIGVsc2Ugc2VlbXMgdG8gYmUgc3Rh
bmRhcmRpemVkOiB0aGUgZnJhY3Rpb25hbCBzaXplIGV0YwogKiBhbGwgc2VlbSB0byBkaWZmZXIg
b24gZGlmZmVyZW50IG1hY2hpbmVzLgogKi8KdW5zaWduZWQgbG9uZyBhdmVucnVuWzNdOwoKc3Rh
dGljIGlubGluZSB2b2lkIGNhbGNfbG9hZCh1bnNpZ25lZCBsb25nIHRpY2tzKQp7Cgl1bnNpZ25l
ZCBsb25nIGFjdGl2ZV90YXNrczsgLyogZml4ZWQtcG9pbnQgKi8KCXN0YXRpYyBpbnQgY291bnQg
PSBMT0FEX0ZSRVE7CgoJY291bnQgLT0gdGlja3M7CglpZiAoY291bnQgPCAwKSB7CgkJY291bnQg
Kz0gTE9BRF9GUkVROwoJCWFjdGl2ZV90YXNrcyA9IGNvdW50X2FjdGl2ZV90YXNrcygpOwoJCUNB
TENfTE9BRChhdmVucnVuWzBdLCBFWFBfMSwgYWN0aXZlX3Rhc2tzKTsKCQlDQUxDX0xPQUQoYXZl
bnJ1blsxXSwgRVhQXzUsIGFjdGl2ZV90YXNrcyk7CgkJQ0FMQ19MT0FEKGF2ZW5ydW5bMl0sIEVY
UF8xNSwgYWN0aXZlX3Rhc2tzKTsKCX0KfQoKLyogamlmZmllcyBhdCB0aGUgbW9zdCByZWNlbnQg
dXBkYXRlIG9mIHdhbGwgdGltZSAqLwp1bnNpZ25lZCBsb25nIHdhbGxfamlmZmllczsKCgpzdGF0
aWMgaW5saW5lIHVuc2lnbmVkIGxvbmcgdXBkYXRlX3RpbWVzKHZvaWQpCnsKCXVuc2lnbmVkIGxv
bmcgdGlja3M7CgoJLyoKCSAqIHVwZGF0ZV90aW1lcygpIGlzIHJ1biBmcm9tIHRoZSByYXcgdGlt
ZXJfYmggaGFuZGxlciBzbyB3ZQoJICoganVzdCBrbm93IHRoYXQgdGhlIGlycXMgYXJlIGxvY2Fs
bHkgZW5hYmxlZCBhbmQgc28gd2UgZG9uJ3QKCSAqIG5lZWQgdG8gc2F2ZS9yZXN0b3JlIHRoZSBm
bGFncyBvZiB0aGUgbG9jYWwgQ1BVIGhlcmUuIC1hcmNhCgkgKi8KCXdyaXRlX2xvY2tfaXJxKCZ4
dGltZV9sb2NrKTsKCgl0aWNrcyA9IGppZmZpZXMgLSB3YWxsX2ppZmZpZXM7CglpZiAodGlja3Mp
IHsKCQl3YWxsX2ppZmZpZXMgKz0gdGlja3M7CgkJdXBkYXRlX3dhbGxfdGltZSh0aWNrcyk7Cgl9
Cgl3cml0ZV91bmxvY2tfaXJxKCZ4dGltZV9sb2NrKTsKCXJldHVybiB0aWNrczsgLyogVGhpcyBp
cyBkdW0uICBjaGFuZ2UgY2FsY19sb2FkIHRvIGEgdGltZXIgKi8KCn0KI2lmZGVmIENPTkZJR19I
SUdIX1JFU19USU1FUlMKdm9pZCB1cGRhdGVfcmVhbF93YWxsX3RpbWUodm9pZCkKewogICAgICAg
dW5zaWduZWQgbG9uZyB0aWNrczsKICAgICAgIC8qCiAgICAgICAgKiBUbyBnZXQgdGhlIHRpbWUg
b2YgZGF5IHJlYWxseSByaWdodCwgd2UgbmVlZCB0byBtYWtlIHN1cmUgCiAgICAgICAgKiBldmVy
eSBvbmUgaXMgb24gdGhlIHNhbWUgamlmZmllLiAoQmVjYXVzZSBvZiBhZGpfdGltZSwgZXRjLikK
ICAgICAgICAqIFNvIHdlIHByb3ZpZGUgdGhpcyBmb3IgdGhlIGhpZ2ggcmVzIGNvZGUuICBNdXN0
IGJlIGNhbGxlZCAKICAgICAgICAqIHVuZGVyIHRoZSB3cml0ZSh4dGltZV9sb2NrKS4gIChFeHRl
cm5hbCBsb2NraW5nIGFsbG93cyB0aGUKICAgICAgICAqIGNhbGxlciB0byBpbmNsdWRlIHN1YiBq
aWZmaWVzIGluIHRoZSBsb2NrIHJlZ2lvbi4pCiAgICAgICAgKi8KICAgICAgICB0aWNrcyA9IGpp
ZmZpZXMgLSB3YWxsX2ppZmZpZXM7CiAgICAgICAgaWYgKHRpY2tzKSB7CiAgICAgICAgICAgICAg
IHdhbGxfamlmZmllcyArPSB0aWNrczsKICAgICAgICAgICAgICAgdXBkYXRlX3dhbGxfdGltZSh0
aWNrcyk7CiAgICAgICAgfQp9CiNlbmRpZiAvKiBDT05GSUdfSElHSF9SRVNfVElNRVJTICovCnZv
aWQgdGltZXJfYmgodm9pZCkKewogICAgICAgdW5zaWduZWQgbG9uZyB0aWNrczsKCVRSQUNFX0VW
RU5UKFRSQUNFX0VWX0tFUk5FTF9USU1FUiwgTlVMTCk7CglwcmludGsoImhhaGEtMVxuIik7CiAg
ICB0aWNrcyA9IHVwZGF0ZV90aW1lcygpOwoJcHJpbnRrKCJoYWhhLTJcbiIpOwogICAgY2FsY19s
b2FkKHRpY2tzKTsKCXByaW50aygiaGFoYS0zXG4iKTsKCXJ1bl90aW1lcl9saXN0KCk7Cn0KCi8q
CiAqIHRpbWVyX3Rhc2tsZXRfbG9jayBzdGFydHMgYXQgLTEuICAwLCB0aGVuIG1lYW5zIGl0IGlz
IGNvb2wgdG8gY29udGludWUuCiAqIElmIGFub3RoZXIgY3B1IGJ1bXBzIGl0IHdoaWxlIHRoZSBm
aXJzdCBpcyBzdGlsbCBpbiB0aW1lcl9iaCwgaXQgd2lsbAogKiBiZSBkZXRlY3RlZCBvbiBleGl0
LCBhbmQgd2Ugd2lsbCBydW4gaXQgYWdhaW4uICBCdXQgbXVsdGlwbGUgZW50cmllcwogKiBhcmUg
bm90IG5lZWRlZCwganVzdCBvbmNlIGZvciBhbGwgdGhlICJoaXRzIiB3aGlsZSB3ZSBhcmUgaW4g
dGltZXJfYmguCiAqLwp2b2lkIHRpbWVyX3NvZnRpcnEoc3RydWN0IHNvZnRpcnFfYWN0aW9uKiBh
KQp7CgogICAgICAgICBpZiAoICEgYXRvbWljX2luY19hbmRfdGVzdCgmdGltZXJfdGFza2xldF9s
b2NrKSl7CiAgICAgICAgICAgICAgICAgLy9rZ2RiX3RzKGF0b21pY19yZWFkKCZ0aW1lcl90YXNr
bGV0X2xvY2spLDApOwogICAgICAgICAgICAgICAgIHJldHVybjsKICAgICAgICAgfQogICAgICAg
ICBkbyB7CiAgICAgICAgICAgICAgICAgLy9rZ2RiX3RzKGF0b21pY19yZWFkKCZ0aW1lcl90YXNr
bGV0X2xvY2spLDEpOwogICAgICAgICAgICAgICAgIGF0b21pY19zZXQoJnRpbWVyX3Rhc2tsZXRf
bG9jaywwKTsKICAgICAgICAgICAgICAgICB0aW1lcl9iaCgpOwoJLy8JIG1hcmtfYmgoVElNRVJf
QkgpOwogICAgICAgICB9d2hpbGUgKCAhIGF0b21pY19hZGRfbmVnYXRpdmUoLTEsJnRpbWVyX3Rh
c2tsZXRfbG9jaykpOwogCiAgICAgICAgIC8va2dkYl90cyhhdG9taWNfcmVhZCgmdGltZXJfdGFz
a2xldF9sb2NrKSwyKTsKIH0KCnZvaWQgZG9fdGltZXIoc3RydWN0IHB0X3JlZ3MgKnJlZ3MpCnsK
CXVwZGF0ZV9qaWZmaWVzKCk7CiNpZm5kZWYgQ09ORklHX1NNUAoJLyogU01QIHByb2Nlc3MgYWNj
b3VudGluZyB1c2VzIHRoZSBsb2NhbCBBUElDIHRpbWVyICovCglJRl9ISUdIX1JFUyggaWYgKG5l
d19qaWZmaWUoKSkpCgkgICAgICAgICAgICAgICAgIHVwZGF0ZV9wcm9jZXNzX3RpbWVzKHVzZXJf
bW9kZShyZWdzKSk7CgojZW5kaWYKCS8qbWFya19iaChUSU1FUl9CSCk7Ki8KICAgICAgICByYWlz
ZV9zb2Z0aXJxKCBSVU5fVElNRVJfTElTVCApOwoJaWYgKFRRX0FDVElWRSh0cV90aW1lcikpCgkJ
bWFya19iaChUUVVFVUVfQkgpOwp9CgojaWYgIWRlZmluZWQoX19hbHBoYV9fKSAmJiAhZGVmaW5l
ZChfX2lhNjRfXykKCi8qCiAqIEZvciBiYWNrd2FyZHMgY29tcGF0aWJpbGl0eT8gIFRoaXMgY2Fu
IGJlIGRvbmUgaW4gbGliYyBzbyBBbHBoYQogKiBhbmQgYWxsIG5ld2VyIHBvcnRzIHNob3VsZG4n
dCBuZWVkIGl0LgogKi8KYXNtbGlua2FnZSB1bnNpZ25lZCBsb25nIHN5c19hbGFybSh1bnNpZ25l
ZCBpbnQgc2Vjb25kcykKewoJc3RydWN0IGl0aW1lcnZhbCBpdF9uZXcsIGl0X29sZDsKCXVuc2ln
bmVkIGludCBvbGRhbGFybTsKCglpdF9uZXcuaXRfaW50ZXJ2YWwudHZfc2VjID0gaXRfbmV3Lml0
X2ludGVydmFsLnR2X3VzZWMgPSAwOwoJaXRfbmV3Lml0X3ZhbHVlLnR2X3NlYyA9IHNlY29uZHM7
CglpdF9uZXcuaXRfdmFsdWUudHZfdXNlYyA9IDA7Cglkb19zZXRpdGltZXIoSVRJTUVSX1JFQUws
ICZpdF9uZXcsICZpdF9vbGQpOwoJb2xkYWxhcm0gPSBpdF9vbGQuaXRfdmFsdWUudHZfc2VjOwoJ
LyogZWhoaC4uIFdlIGNhbid0IHJldHVybiAwIGlmIHdlIGhhdmUgYW4gYWxhcm0gcGVuZGluZy4u
ICovCgkvKiBBbmQgd2UnZCBiZXR0ZXIgcmV0dXJuIHRvbyBtdWNoIHRoYW4gdG9vIGxpdHRsZSBh
bnl3YXkgKi8KCWlmIChpdF9vbGQuaXRfdmFsdWUudHZfdXNlYykKCQlvbGRhbGFybSsrOwoJcmV0
dXJuIG9sZGFsYXJtOwp9CgojZW5kaWYKCiNpZm5kZWYgX19hbHBoYV9fCgovKgogKiBUaGUgQWxw
aGEgdXNlcyBnZXR4cGlkLCBnZXR4dWlkLCBhbmQgZ2V0eGdpZCBpbnN0ZWFkLiAgTWF5YmUgdGhp
cwogKiBzaG91bGQgYmUgbW92ZWQgaW50byBhcmNoL2kzODYgaW5zdGVhZD8KICovCiAKYXNtbGlu
a2FnZSBsb25nIHN5c19nZXRwaWQodm9pZCkKewoJLyogVGhpcyBpcyBTTVAgc2FmZSAtIGN1cnJl
bnQtPnBpZCBkb2Vzbid0IGNoYW5nZSAqLwoJcmV0dXJuIGN1cnJlbnQtPnRnaWQ7Cn0KCi8qCiAq
IFRoaXMgaXMgbm90IHN0cmljdGx5IFNNUCBzYWZlOiBwX29wcHRyIGNvdWxkIGNoYW5nZQogKiBm
cm9tIHVuZGVyIHVzLiBIb3dldmVyLCByYXRoZXIgdGhhbiBnZXR0aW5nIGFueSBsb2NrCiAqIHdl
IGNhbiB1c2UgYW4gb3B0aW1pc3RpYyBhbGdvcml0aG06IGdldCB0aGUgcGFyZW50CiAqIHBpZCwg
YW5kIGdvIGJhY2sgYW5kIGNoZWNrIHRoYXQgdGhlIHBhcmVudCBpcyBzdGlsbAogKiB0aGUgc2Ft
ZS4gSWYgaXQgaGFzIGNoYW5nZWQgKHdoaWNoIGlzIGV4dHJlbWVseSB1bmxpa2VseQogKiBpbmRl
ZWQpLCB3ZSBqdXN0IHRyeSBhZ2Fpbi4uCiAqCiAqIE5PVEUhIFRoaXMgZGVwZW5kcyBvbiB0aGUg
ZmFjdCB0aGF0IGV2ZW4gaWYgd2UgX2RvXwogKiBnZXQgYW4gb2xkIHZhbHVlIG9mICJwYXJlbnQi
LCB3ZSBjYW4gaGFwcGlseSBkZXJlZmVyZW5jZQogKiB0aGUgcG9pbnRlcjogd2UganVzdCBjYW4n
dCBuZWNlc3NhcmlseSB0cnVzdCB0aGUgcmVzdWx0CiAqIHVudGlsIHdlIGtub3cgdGhhdCB0aGUg
cGFyZW50IHBvaW50ZXIgaXMgdmFsaWQuCiAqCiAqIFRoZSAibWIoKSIgbWFjcm8gaXMgYSBtZW1v
cnkgYmFycmllciAtIGEgc3luY2hyb25pemluZwogKiBldmVudC4gSXQgYWxzbyBtYWtlcyBzdXJl
IHRoYXQgZ2NjIGRvZXNuJ3Qgb3B0aW1pemUKICogYXdheSB0aGUgbmVjZXNzYXJ5IG1lbW9yeSBy
ZWZlcmVuY2VzLi4gVGhlIGJhcnJpZXIgZG9lc24ndAogKiBoYXZlIHRvIGhhdmUgYWxsIHRoYXQg
c3Ryb25nIHNlbWFudGljczogb24geDg2IHdlIGRvbid0CiAqIHJlYWxseSByZXF1aXJlIGEgc3lu
Y2hyb25pemluZyBpbnN0cnVjdGlvbiwgZm9yIGV4YW1wbGUuCiAqIFRoZSBiYXJyaWVyIGlzIG1v
cmUgaW1wb3J0YW50IGZvciBjb2RlIGdlbmVyYXRpb24gdGhhbgogKiBmb3IgYW55IHJlYWwgbWVt
b3J5IG9yZGVyaW5nIHNlbWFudGljcyAoZXZlbiBpZiB0aGVyZSBpcwogKiBhIHNtYWxsIHdpbmRv
dyBmb3IgYSByYWNlLCB1c2luZyB0aGUgb2xkIHBvaW50ZXIgaXMKICogaGFybWxlc3MgZm9yIGEg
d2hpbGUpLgogKi8KYXNtbGlua2FnZSBsb25nIHN5c19nZXRwcGlkKHZvaWQpCnsKCWludCBwaWQ7
CglzdHJ1Y3QgdGFza19zdHJ1Y3QgKiBtZSA9IGN1cnJlbnQ7CglzdHJ1Y3QgdGFza19zdHJ1Y3Qg
KiBwYXJlbnQ7CgoJcGFyZW50ID0gbWUtPnBfb3BwdHI7Cglmb3IgKDs7KSB7CgkJcGlkID0gcGFy
ZW50LT5waWQ7CiNpZiBDT05GSUdfU01QCnsKCQlzdHJ1Y3QgdGFza19zdHJ1Y3QgKm9sZCA9IHBh
cmVudDsKCQltYigpOwoJCXBhcmVudCA9IG1lLT5wX29wcHRyOwoJCWlmIChvbGQgIT0gcGFyZW50
KQoJCQljb250aW51ZTsKfQojZW5kaWYKCQlicmVhazsKCX0KCXJldHVybiBwaWQ7Cn0KCmFzbWxp
bmthZ2UgbG9uZyBzeXNfZ2V0dWlkKHZvaWQpCnsKCS8qIE9ubHkgd2UgY2hhbmdlIHRoaXMgc28g
U01QIHNhZmUgKi8KCXJldHVybiBjdXJyZW50LT51aWQ7Cn0KCmFzbWxpbmthZ2UgbG9uZyBzeXNf
Z2V0ZXVpZCh2b2lkKQp7CgkvKiBPbmx5IHdlIGNoYW5nZSB0aGlzIHNvIFNNUCBzYWZlICovCgly
ZXR1cm4gY3VycmVudC0+ZXVpZDsKfQoKYXNtbGlua2FnZSBsb25nIHN5c19nZXRnaWQodm9pZCkK
ewoJLyogT25seSB3ZSBjaGFuZ2UgdGhpcyBzbyBTTVAgc2FmZSAqLwoJcmV0dXJuIGN1cnJlbnQt
PmdpZDsKfQoKYXNtbGlua2FnZSBsb25nIHN5c19nZXRlZ2lkKHZvaWQpCnsKCS8qIE9ubHkgd2Ug
Y2hhbmdlIHRoaXMgc28gU01QIHNhZmUgKi8KCXJldHVybiAgY3VycmVudC0+ZWdpZDsKfQoKI2Vu
ZGlmCgovKiBUaHJlYWQgSUQgLSB0aGUgaW50ZXJuYWwga2VybmVsICJwaWQiICovCmFzbWxpbmth
Z2UgbG9uZyBzeXNfZ2V0dGlkKHZvaWQpCnsKCXJldHVybiBjdXJyZW50LT5waWQ7Cn0KCiNpZiAw
ICAKLy8gVGhpcyAjaWYgMCBpcyB0byBrZWVwIHRoZSBwcmV0dHkgcHJpbnRlci8gZm9ybWF0dGVy
IGhhcHB5IHNvIHRoZSBpbmRlbnRzIHdpbGwKLy8gY29ycmVjdCBiZWxvdy4gIAovLyBUaGUgTkFO
T1NMRUVQX0VOVFJZIG1hY3JvIGlzIGRlZmluZWQgaW4gIGFzbS9zaWduYWwuaCBhbmQKLy8gaXMg
c3RydWN0dXJlZCB0byBhbGxvdyBjb2RlIGFzIHdlbGwgYXMgZW50cnkgZGVmaW5pdGlvbnMsIHNv
IHRoYXQgd2hlbgovLyB3ZSBnZXQgY29udHJvbCBiYWNrIGhlcmUgdGhlIGVudHJ5IHBhcmFtZXRl
cnMgd2lsbCBiZSBhdmFpbGFibGUgYXMgZXhwZWN0ZWQuCi8vIFNvbWUgc3lzdGVtcyBtYXkgZmlu
ZCB0aGVzZSBwYXJhbWVydHMgaW4gb3RoZXIgd2F5cyB0aGFuIGFzIGVudHJ5IHBhcm1zLCAKLy8g
Zm9yIGV4YW1wbGUsIHN0cnVjdCBwdF9yZWdzICpyZWdzIGlzIGRlZmluZWQgaW4gaTM4NiBhcyB0
aGUgYWRkcmVzcyBvZiB0aGUKLy8gZmlyc3QgcGFyYW1ldGVyLCB3aGVyZSBhcyBvdGhlciBhcmNo
cyBwYXNzIGl0IGFzIG9uZSBvZiB0aGUgcGFyYW1lcnRlcnMuCmFzbWxpbmthZ2UgbG9uZyBzeXNf
bmFub3NsZWVwKHZvaWQpCnsKI2VuZGlmCiAgICAgICAgTkFOT1NMRUVQX0VOVFJZKAlzdHJ1Y3Qg
dGltZXNwZWMgdDsKICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICB1bnNpZ25lZCBsb25n
IGV4cGlyZTspCgoKICAgICAgICAgICAgICAgIC8vIFRoZSBmb2xsb3dpbmcgY29kZSBleHBlY3Rz
IHJxdHAsIHJtdHAgdG8gYmUgYXZhaWxhYmxlIGFzIGEgcmVzdWx0IG9mCiAgICAgICAgICAgICAg
ICAvLyB0aGUgYWJvdmUgbWFjcm8uICBBbHNvIGFueSByZWdzIG5lZWRlZCBmb3IgdGhlIF9kb19z
aWduYWwoKSBtYWNybyAKICAgICAgICAgICAgICAgIC8vIHNob3VsZSBiZSBzZXQgdXAgaGVyZS4K
CWlmKGNvcHlfZnJvbV91c2VyKCZ0LCBycXRwLCBzaXplb2Yoc3RydWN0IHRpbWVzcGVjKSkpCgkJ
cmV0dXJuIC1FRkFVTFQ7CgoJaWYgKHQudHZfbnNlYyA+PSAxMDAwMDAwMDAwTCB8fCB0LnR2X25z
ZWMgPCAwIHx8IHQudHZfc2VjIDwgMCkKCQlyZXR1cm4gLUVJTlZBTDsKCgoJaWYgKHQudHZfc2Vj
ID09IDAgJiYgdC50dl9uc2VjIDw9IDIwMDAwMDBMICYmCgkgICAgY3VycmVudC0+cG9saWN5ICE9
IFNDSEVEX09USEVSKQoJewoJCS8qCgkJICogU2hvcnQgZGVsYXkgcmVxdWVzdHMgdXAgdG8gMiBt
cyB3aWxsIGJlIGhhbmRsZWQgd2l0aAoJCSAqIGhpZ2ggcHJlY2lzaW9uIGJ5IGEgYnVzeSB3YWl0
IGZvciBhbGwgcmVhbC10aW1lIHByb2Nlc3Nlcy4KCQkgKgoJCSAqIEl0cyBpbXBvcnRhbnQgb24g
U01QIG5vdCB0byBkbyB0aGlzIGhvbGRpbmcgbG9ja3MuCgkJICovCgkJdWRlbGF5KCh0LnR2X25z
ZWMgKyA5OTkpIC8gMTAwMCk7CgkJcmV0dXJuIDA7Cgl9CgoJZXhwaXJlID0gdGltZXNwZWNfdG9f
amlmZmllcygmdCkgKyAodC50dl9zZWMgfHwgdC50dl9uc2VjKTsKCWRvIHsKCWN1cnJlbnQtPnN0
YXRlID0gVEFTS19JTlRFUlJVUFRJQkxFOwogICAgICAgIH0gd2hpbGUoKGV4cGlyZSA9IHNjaGVk
dWxlX3RpbWVvdXQoZXhwaXJlKSkgJiYgIV9kb19zaWduYWwoKSk7CgoJaWYgKGV4cGlyZSkgewoJ
CWlmIChybXRwKSB7CgkJCWppZmZpZXNfdG9fdGltZXNwZWMoZXhwaXJlLCAmdCk7CgkJCWlmIChj
b3B5X3RvX3VzZXIocm10cCwgJnQsIHNpemVvZihzdHJ1Y3QgdGltZXNwZWMpKSkKCQkJCXJldHVy
biAtRUZBVUxUOwoJCX0KCQlyZXR1cm4gLUVJTlRSOwoJfQoJcmV0dXJuIDA7Cn0KCg==
------=_Part_38509_179054.1195811464066--
