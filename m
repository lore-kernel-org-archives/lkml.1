Return-Path: <linux-kernel-owner+w=401wt.eu-S1758336AbXKTHn6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758336AbXKTHn6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2007 02:43:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757889AbXKTHno
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Nov 2007 02:43:44 -0500
Received: from nf-out-0910.google.com ([64.233.182.189]:8144 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757578AbXKTHnl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2007 02:43:41 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:in-reply-to:mime-version:content-type:references;
        b=aNLFjXA3xMre4HNUbdkbv7TwJ1px2IgSsrzJOFD6bdBzk6nJJLiWKjyPWhf7Vc3ghRFIaz0zsPdim9lvv5ELi54WGbFUgR7VYNPrh2G/NCgrHiO3KZ866pxGoKrvhD+S0pkZQa/BSspdh/PWmO1rouW8e+UpcisBlBi4AgFf1cY=
Message-ID: <c002e7b30711192343n35c32f40n226d6847445ce22b@mail.gmail.com>
Date: Tue, 20 Nov 2007 15:43:38 +0800
From: "jordan liu" <jordanliuster@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: Fwd: kernel panic occurs randomly and has two different oops messages when configuring wireless
In-Reply-To: <c002e7b30711192254m744c384cn5cba851a3f2b0fe9@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; 
	boundary="----=_Part_24820_2636690.1195544618618"
References: <c002e7b30711192254m744c384cn5cba851a3f2b0fe9@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

------=_Part_24820_2636690.1195544618618
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

1. Problems&Help:
kernel panic occurs randomly and has two different oops messages when
configuring wireless.
I want to know the correct crash position and the solution.

2. Platform:Linux_2.4.17_mvl21 - MIPS (embedded)

3. Oops Messages:
1)Oops-1 messages
------------------------------------------------------------------------------------------------------------------------------------------------
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
------------------------------------------------------------------------------------------------------------------------------------------------

2)Oops-2 message
------------------------------------------------------------------------------------------------------------------------------------------------
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
------------------------------------------------------------------------------------------------------------------------------------------------


3. analyzing through ksymoops
./ksymoops -v vmlinux -k /proc/ksyms -l /proc/modules -o /lib/modules
-m System.map  -t elf32-tradlittlemips -a mips < panic.log

1)Oops-1
------------------------------------------------------------------------------------------------------------------------------------------------
>>RA;  9403fa8c <timer_bh+60/410>
>>$1; 941dc674 <tv1+4/804>
>>$3; 941dc468 <tv2+0/208>
>>$5; 943ecf70 <_end+1feb90/2be31c80>
>>$6; 941dc294 <tv3+34/208>
>>$10; 941dc260 <tv3+0/208>
>>$11; 94172408 <tvecs+8/23fc>
>>$17; 941c9620 <jiffies_64+0/8>
>>$21; 941c8860 <irq_stat+0/20>
>>$22; 941c00c0 <softirq_vec+0/100>
>>$23; 9457e4e0 <_end+390100/2be31c80>
>>$28; 94026000 <init_task_union+0/0>
>>$29; 94027e08 <dummy+1e08/2000>
>>$31; 9403fa8c <timer_bh+60/410>

>>PC;  9403fc1c <timer_bh+1f0/410>   <=====

Trace; 9403fe84 <timer_softirq+48/74>
Trace; 9403b890 <tasklet_action+d0/150>
Trace; c0061da8 <END_OF_CODE+85c0/????>
Trace; 9403b25c <do_softirq_from_daemon+c4/194>
Trace; 94026000 <init_task_union+0/0>
Trace; 9403f918 <update_process_times+34/f8>
Trace; 94027eb8 <dummy+1eb8/2000>
Trace; 9403b544 <do_softirq+30/3c>
Trace; 9403b544 <do_softirq+30/3c>
Trace; 9416d530 <__gnu_compiled_c+c0/f0>
Trace; 9416298c <avalanche_hw0_irqdispatch+e8/f8>
Trace; 94162958 <avalanche_hw0_irqdispatch+b4/f8>
Trace; 9416d0c0 <mipsIRQ+100/160>
Trace; 9416d0d8 <mipsIRQ+118/160>
Trace; 94027fe0 <dummy+1fe0/2000>
(skip...)

Kernel panic: Aiee, killing interrupt handler!

1 warning and 1 error issued.  Results may not be reliable.
------------------------------------------------------------------------------------------------------------------------------------------------

2)Oops-2
------------------------------------------------------------------------------------------------------------------------------------------------
>>RA;  94130b60 <ip_ct_refresh+78/bc>
>>$1; 941dc264 <tv3+4/208>
>>$2; 94630e70 <_end+442a90/2be31c80>
>>$4; 94c77cc4 <_end+a898e4/2be31c80>
>>$16; 94c77cc4 <_end+a898e4/2be31c80>
>>$17; 94c77c60 <_end+a89880/2be31c80>
>>$19; 941d5a08 <ip_conntrack_protocol_udp+0/38>
>>$20; 94451c4c <_end+26386c/2be31c80>
>>$23; 94451d88 <_end+2639a8/2be31c80>
>>$24; 94451c28 <_end+263848/2be31c80>
>>$28; 94450000 <_end+261c20/2be31c80>
>>$29; 94451bc8 <_end+2637e8/2be31c80>
>>$30; 9411b604 <udp_getfrag+0/134>
>>$31; 94130b60 <ip_ct_refresh+78/bc>

>>PC;  9403f020 <add_timer+10c/18c>   <=====

Trace; 94125b00 <inet_addr_type+84/dc>
Trace; 94130b60 <ip_ct_refresh+78/bc>
Trace; 941329c0 <udp_packet+30/70>
Trace; 9412fb70 <ip_conntrack_in+274/39c>
Trace; 940dd7f0 <neigh_alloc+8c/150>
Trace; 9405e300 <refile_buffer+c/1c>
Trace; 940dda34 <neigh_create+90/284>
Trace; 940d0011 <erase_write+4d/170>
Trace; 940890a0 <read_data+370/47c>
Trace; c0100d80 <END_OF_CODE+a7598/????>
Trace; 940fd5a0 <output_maybe_reroute+0/24>
Trace; 9412dd7c <ip_conntrack_local+64/70>
Trace; 9411d5d0 <arp_bind_neighbour+9c/d4>
Trace; 940fd5a0 <output_maybe_reroute+0/24>
Trace; 940e2224 <nf_iterate+70/144>
(skip...)

Kernel panic: Aiee, killing interrupt handler!

1 warning and 1 error issued.  Results may not be reliable.
------------------------------------------------------------------------------------------------------------------------------------------------

4. Objdump kernel vmlinux
the result is following:
------------------------------------------------------------------------------------------------------------------------------------------------
vmlinux:     file format elf32-tradlittlemips

Disassembly of section .text:

ffffffff94020000 <_ftext>:
    ...

ffffffff94020280 <except_vec2_generic>:
ffffffff94020280:    401a8000     mfc0    $k0,$16
ffffffff94020284:    241bfff8     li    $k1,-8
ffffffff94020288:    035bd024     and    $k0,$k0,$k1
ffffffff9402028c:    375a0002     ori    $k0,$k0,0x2
ffffffff94020290:    409a8000     mtc0    $k0,$16
    ...
(skip ...)

ffffffff9403ef14 <add_timer>:
ffffffff9403ef14:    27bdffe8     addiu    $sp,$sp,-24
ffffffff9403ef18:    afbf0010     sw    $ra,16($sp)
ffffffff9403ef1c:    40076000     mfc0    $a3,$12
ffffffff9403ef20:    00000000     nop
ffffffff9403ef24:    34e10001     ori    $at,$a3,0x1
ffffffff9403ef28:    38210001     xori    $at,$at,0x1
ffffffff9403ef2c:    40816000     mtc0    $at,$12
ffffffff9403ef30:    00000040     sll    $zero,$zero,0x1
ffffffff9403ef34:    00000040     sll    $zero,$zero,0x1
ffffffff9403ef38:    00000040     sll    $zero,$zero,0x1
ffffffff9403ef3c:    8c820000     lw    $v0,0($a0)
ffffffff9403ef40:    14400046     bnez    $v0,ffffffff9403f05c <add_timer+0x148>
ffffffff9403ef44:    00000000     nop
ffffffff9403ef48:    8c860008     lw    $a2,8($a0)
ffffffff9403ef4c:    3c02941e     lui    $v0,0x941e
ffffffff9403ef50:    8c42ce74     lw    $v0,-12684($v0)
ffffffff9403ef54:    00c22823     subu    $a1,$a2,$v0
ffffffff9403ef58:    2ca30100     sltiu    $v1,$a1,256
ffffffff9403ef5c:    14600024     bnez    $v1,ffffffff9403eff0 <add_timer+0xdc>
ffffffff9403ef60:    30c200ff     andi    $v0,$a2,0xff
ffffffff9403ef64:    2ca24000     sltiu    $v0,$a1,16384
ffffffff9403ef68:    10400007     beqz    $v0,ffffffff9403ef88 <add_timer+0x74>
ffffffff9403ef6c:    00061142     srl    $v0,$a2,0x5
ffffffff9403ef70:    304201f8     andi    $v0,$v0,0x1f8
ffffffff9403ef74:    3c01941e     lui    $at,0x941e
ffffffff9403ef78:    2421c46c     addiu    $at,$at,-15252
ffffffff9403ef7c:    00221021     addu    $v0,$at,$v0
ffffffff9403ef80:    0900fc07     j    ffffffff9403f01c <add_timer+0x108>
ffffffff9403ef84:    8c420004     lw    $v0,4($v0)
ffffffff9403ef88:    3c02000f     lui    $v0,0xf
ffffffff9403ef8c:    3442ffff     ori    $v0,$v0,0xffff
ffffffff9403ef90:    0045102b     sltu    $v0,$v0,$a1
ffffffff9403ef94:    14400008     bnez    $v0,ffffffff9403efb8 <add_timer+0xa4>
ffffffff9403ef98:    3c0203ff     lui    $v0,0x3ff
ffffffff9403ef9c:    000612c2     srl    $v0,$a2,0xb
ffffffff9403efa0:    304201f8     andi    $v0,$v0,0x1f8
ffffffff9403efa4:    3c01941e     lui    $at,0x941e
ffffffff9403efa8:    2421c264     addiu    $at,$at,-15772
ffffffff9403efac:    00221021     addu    $v0,$at,$v0
ffffffff9403efb0:    0900fc07     j    ffffffff9403f01c <add_timer+0x108>
ffffffff9403efb4:    8c420004     lw    $v0,4($v0)
ffffffff9403efb8:    3442ffff     ori    $v0,$v0,0xffff
ffffffff9403efbc:    0045102b     sltu    $v0,$v0,$a1
ffffffff9403efc0:    14400007     bnez    $v0,ffffffff9403efe0 <add_timer+0xcc>
ffffffff9403efc4:    00061442     srl    $v0,$a2,0x11
ffffffff9403efc8:    304201f8     andi    $v0,$v0,0x1f8
ffffffff9403efcc:    3c01941e     lui    $at,0x941e
ffffffff9403efd0:    2421c05c     addiu    $at,$at,-16292
ffffffff9403efd4:    00221021     addu    $v0,$at,$v0
ffffffff9403efd8:    0900fc07     j    ffffffff9403f01c <add_timer+0x108>
ffffffff9403efdc:    8c420004     lw    $v0,4($v0)
ffffffff9403efe0:    04a10009     bgez    $a1,ffffffff9403f008 <add_timer+0xf4>
ffffffff9403efe4:    00061682     srl    $v0,$a2,0x1a
ffffffff9403efe8:    3c02941e     lui    $v0,0x941e
ffffffff9403efec:    8c42c670     lw    $v0,-14736($v0)
ffffffff9403eff0:    000210c0     sll    $v0,$v0,0x3
ffffffff9403eff4:    3c01941e     lui    $at,0x941e
ffffffff9403eff8:    2421c674     addiu    $at,$at,-14732
ffffffff9403effc:    00221021     addu    $v0,$at,$v0
ffffffff9403f000:    0900fc07     j    ffffffff9403f01c <add_timer+0x108>
ffffffff9403f004:    8c420004     lw    $v0,4($v0)
ffffffff9403f008:    000210c0     sll    $v0,$v0,0x3
ffffffff9403f00c:    3c01941e     lui    $at,0x941e
ffffffff9403f010:    2421be54     addiu    $at,$at,-16812
ffffffff9403f014:    00221021     addu    $v0,$at,$v0
ffffffff9403f018:    8c420004     lw    $v0,4($v0)
ffffffff9403f01c:    8c430000     lw    $v1,0($v0)
ffffffff9403f020:    ac640004     sw    $a0,4($v1)
ffffffff9403f024:    ac830000     sw    $v1,0($a0)
ffffffff9403f028:    ac820004     sw    $v0,4($a0)
ffffffff9403f02c:    ac440000     sw    $a0,0($v0)
ffffffff9403f030:    40016000     mfc0    $at,$12
ffffffff9403f034:    30e70001     andi    $a3,$a3,0x1
ffffffff9403f038:    34210001     ori    $at,$at,0x1
ffffffff9403f03c:    38210001     xori    $at,$at,0x1
ffffffff9403f040:    00e13825     or    $a3,$a3,$at
ffffffff9403f044:    40876000     mtc0    $a3,$12
    ...
ffffffff9403f054:    0900fc26     j    ffffffff9403f098 <add_timer+0x184>
ffffffff9403f058:    8fbf0010     lw    $ra,16($sp)
ffffffff9403f05c:    40016000     mfc0    $at,$12
ffffffff9403f060:    30e70001     andi    $a3,$a3,0x1
ffffffff9403f064:    34210001     ori    $at,$at,0x1
ffffffff9403f068:    38210001     xori    $at,$at,0x1
ffffffff9403f06c:    00e13825     or    $a3,$a3,$at
ffffffff9403f070:    40876000     mtc0    $a3,$12
    ...
ffffffff9403f080:    27a30010     addiu    $v1,$sp,16
ffffffff9403f084:    3c049417     lui    $a0,0x9417
ffffffff9403f088:    24842414     addiu    $a0,$a0,9236
ffffffff9403f08c:    0d00d260     jal    ffffffff94034980 <printk>
ffffffff9403f090:    8c650000     lw    $a1,0($v1)
ffffffff9403f094:    8fbf0010     lw    $ra,16($sp)
ffffffff9403f098:    03e00008     jr    $ra
ffffffff9403f09c:    27bd0018     addiu    $sp,$sp,24

ffffffff9403f0a0 <mod_timer>:
ffffffff9403f0a0:    40076000     mfc0    $a3,$12

(skip ...)

ffffffff9403fa2c <timer_bh>:
ffffffff9403fa2c:    27bdffe0     addiu    $sp,$sp,-32
ffffffff9403fa30:    afbf0018     sw    $ra,24($sp)
ffffffff9403fa34:    afb10014     sw    $s1,20($sp)
ffffffff9403fa38:    afb00010     sw    $s0,16($sp)
ffffffff9403fa3c:    40016000     mfc0    $at,$12
ffffffff9403fa40:    00000000     nop
ffffffff9403fa44:    34210001     ori    $at,$at,0x1
ffffffff9403fa48:    38210001     xori    $at,$at,0x1
ffffffff9403fa4c:    40816000     mtc0    $at,$12
    ...
ffffffff9403fa5c:    3c11941d     lui    $s1,0x941d
ffffffff9403fa60:    26319620     addiu    $s1,$s1,-27104
ffffffff9403fa64:    8e220000     lw    $v0,0($s1)
ffffffff9403fa68:    3c03941d     lui    $v1,0x941d
ffffffff9403fa6c:    8c639678     lw    $v1,-27016($v1)
ffffffff9403fa70:    00438023     subu    $s0,$v0,$v1
ffffffff9403fa74:    12000005     beqz    $s0,ffffffff9403fa8c <timer_bh+0x60>
ffffffff9403fa78:    00701021     addu    $v0,$v1,$s0
ffffffff9403fa7c:    3c01941d     lui    $at,0x941d
ffffffff9403fa80:    ac229678     sw    $v0,-27016($at)
ffffffff9403fa84:    0d00fdcd     jal    ffffffff9403f734 <update_wall_time>
ffffffff9403fa88:    02002021     move    $a0,$s0
ffffffff9403fa8c:    40016000     mfc0    $at,$12
ffffffff9403fa90:    00000000     nop
ffffffff9403fa94:    3421001f     ori    $at,$at,0x1f
ffffffff9403fa98:    3821001e     xori    $at,$at,0x1e
ffffffff9403fa9c:    40816000     mtc0    $at,$12
ffffffff9403faa0:    3c02941d     lui    $v0,0x941d
ffffffff9403faa4:    8c429630     lw    $v0,-27088($v0)
ffffffff9403faa8:    00501023     subu    $v0,$v0,$s0
ffffffff9403faac:    3c01941d     lui    $at,0x941d
ffffffff9403fab0:    ac229630     sw    $v0,-27088($at)
ffffffff9403fab4:    04410032     bgez    $v0,ffffffff9403fb80 <timer_bh+0x154>
ffffffff9403fab8:    244201f4     addiu    $v0,$v0,500
ffffffff9403fabc:    3c01941d     lui    $at,0x941d
ffffffff9403fac0:    0d00fe77     jal    ffffffff9403f9dc <count_active_tasks>
ffffffff9403fac4:    ac229630     sw    $v0,-27088($at)
ffffffff9403fac8:    00021880     sll    $v1,$v0,0x2
ffffffff9403facc:    00621821     addu    $v1,$v1,$v0
ffffffff9403fad0:    000318c0     sll    $v1,$v1,0x3
ffffffff9403fad4:    3c05941d     lui    $a1,0x941d
ffffffff9403fad8:    8ca5964c     lw    $a1,-27060($a1)
ffffffff9403fadc:    00621821     addu    $v1,$v1,$v0
ffffffff9403fae0:    00052100     sll    $a0,$a1,0x4
ffffffff9403fae4:    00852023     subu    $a0,$a0,$a1
ffffffff9403fae8:    00042080     sll    $a0,$a0,0x2
ffffffff9403faec:    00852023     subu    $a0,$a0,$a1
ffffffff9403faf0:    000420c0     sll    $a0,$a0,0x3
ffffffff9403faf4:    00852023     subu    $a0,$a0,$a1
ffffffff9403faf8:    00641821     addu    $v1,$v1,$a0
ffffffff9403fafc:    00031880     sll    $v1,$v1,0x2
ffffffff9403fb00:    00031ac2     srl    $v1,$v1,0xb
ffffffff9403fb04:    3c01941d     lui    $at,0x941d
ffffffff9403fb08:    ac23964c     sw    $v1,-27060($at)
ffffffff9403fb0c:    00021900     sll    $v1,$v0,0x4
ffffffff9403fb10:    3c05941d     lui    $a1,0x941d
ffffffff9403fb14:    8ca59650     lw    $a1,-27056($a1)
ffffffff9403fb18:    00621821     addu    $v1,$v1,$v0
ffffffff9403fb1c:    00052180     sll    $a0,$a1,0x6
ffffffff9403fb20:    00852023     subu    $a0,$a0,$a1
ffffffff9403fb24:    00042100     sll    $a0,$a0,0x4
ffffffff9403fb28:    00852023     subu    $a0,$a0,$a1
ffffffff9403fb2c:    00641821     addu    $v1,$v1,$a0
ffffffff9403fb30:    00031840     sll    $v1,$v1,0x1
ffffffff9403fb34:    00031ac2     srl    $v1,$v1,0xb
ffffffff9403fb38:    3c01941d     lui    $at,0x941d
ffffffff9403fb3c:    ac239650     sw    $v1,-27056($at)
ffffffff9403fb40:    00021840     sll    $v1,$v0,0x1
ffffffff9403fb44:    00621821     addu    $v1,$v1,$v0
ffffffff9403fb48:    00031880     sll    $v1,$v1,0x2
ffffffff9403fb4c:    3c05941d     lui    $a1,0x941d
ffffffff9403fb50:    8ca59654     lw    $a1,-27052($a1)
ffffffff9403fb54:    00621823     subu    $v1,$v1,$v0
ffffffff9403fb58:    000521c0     sll    $a0,$a1,0x7
ffffffff9403fb5c:    00852023     subu    $a0,$a0,$a1
ffffffff9403fb60:    00042080     sll    $a0,$a0,0x2
ffffffff9403fb64:    00852021     addu    $a0,$a0,$a1
ffffffff9403fb68:    00042080     sll    $a0,$a0,0x2
ffffffff9403fb6c:    00852021     addu    $a0,$a0,$a1
ffffffff9403fb70:    00832021     addu    $a0,$a0,$v1
ffffffff9403fb74:    000422c2     srl    $a0,$a0,0xb
ffffffff9403fb78:    3c01941d     lui    $at,0x941d
ffffffff9403fb7c:    ac249654     sw    $a0,-27052($at)
ffffffff9403fb80:    40016000     mfc0    $at,$12
ffffffff9403fb84:    00000000     nop
ffffffff9403fb88:    34210001     ori    $at,$at,0x1
ffffffff9403fb8c:    38210001     xori    $at,$at,0x1
ffffffff9403fb90:    40816000     mtc0    $at,$12
    ...
ffffffff9403fba0:    8e220000     lw    $v0,0($s1)
ffffffff9403fba4:    3c03941e     lui    $v1,0x941e
ffffffff9403fba8:    8c63ce74     lw    $v1,-12684($v1)
ffffffff9403fbac:    00431023     subu    $v0,$v0,$v1
ffffffff9403fbb0:    04400098     bltz    $v0,ffffffff9403fe14 <timer_bh+0x3e8>
ffffffff9403fbb4:    00000000     nop
ffffffff9403fbb8:    3c02941e     lui    $v0,0x941e
ffffffff9403fbbc:    8c42c670     lw    $v0,-14736($v0)
ffffffff9403fbc0:    14400060     bnez    $v0,ffffffff9403fd44 <timer_bh+0x318>
ffffffff9403fbc4:    000210c0     sll    $v0,$v0,0x3
ffffffff9403fbc8:    240d0001     li    $t5,1
ffffffff9403fbcc:    240f0001     li    $t7,1
ffffffff9403fbd0:    3c0e941e     lui    $t6,0x941e
ffffffff9403fbd4:    8dcece74     lw    $t6,-12684($t6)
ffffffff9403fbd8:    3c0b9417     lui    $t3,0x9417
ffffffff9403fbdc:    256b2404     addiu    $t3,$t3,9220
ffffffff9403fbe0:    8d6a0000     lw    $t2,0($t3)
ffffffff9403fbe4:    8d420000     lw    $v0,0($t2)
ffffffff9403fbe8:    000210c0     sll    $v0,$v0,0x3
ffffffff9403fbec:    24420004     addiu    $v0,$v0,4
ffffffff9403fbf0:    01423021     addu    $a2,$t2,$v0
ffffffff9403fbf4:    8cc50000     lw    $a1,0($a2)
ffffffff9403fbf8:    50a60042     0x50a60042
ffffffff9403fbfc:    acc60000     sw    $a2,0($a2)
ffffffff9403fc00:    01c06021     move    $t4,$t6
ffffffff9403fc04:    3c09000f     lui    $t1,0xf
ffffffff9403fc08:    3529ffff     ori    $t1,$t1,0xffff
ffffffff9403fc0c:    3c0803ff     lui    $t0,0x3ff
ffffffff9403fc10:    3508ffff     ori    $t0,$t0,0xffff
ffffffff9403fc14:    8ca70000     lw    $a3,0($a1)
ffffffff9403fc18:    8ca20004     lw    $v0,4($a1)
ffffffff9403fc1c:    ace20004     sw    $v0,4($a3)
ffffffff9403fc20:    ac470000     sw    $a3,0($v0)
ffffffff9403fc24:    8ca40008     lw    $a0,8($a1)
ffffffff9403fc28:    008c1823     subu    $v1,$a0,$t4
ffffffff9403fc2c:    2c620100     sltiu    $v0,$v1,256
ffffffff9403fc30:    14400020     bnez    $v0,ffffffff9403fcb4 <timer_bh+0x288>
ffffffff9403fc34:    308200ff     andi    $v0,$a0,0xff
ffffffff9403fc38:    2c624000     sltiu    $v0,$v1,16384
ffffffff9403fc3c:    10400007     beqz    $v0,ffffffff9403fc5c <timer_bh+0x230>
ffffffff9403fc40:    00041142     srl    $v0,$a0,0x5
ffffffff9403fc44:    304201f8     andi    $v0,$v0,0x1f8
ffffffff9403fc48:    3c01941e     lui    $at,0x941e
ffffffff9403fc4c:    2421c46c     addiu    $at,$at,-15252
ffffffff9403fc50:    00221021     addu    $v0,$at,$v0
ffffffff9403fc54:    0900ff38     j    ffffffff9403fce0 <timer_bh+0x2b4>
ffffffff9403fc58:    8c430004     lw    $v1,4($v0)
ffffffff9403fc5c:    0123102b     sltu    $v0,$t1,$v1
ffffffff9403fc60:    14400008     bnez    $v0,ffffffff9403fc84 <timer_bh+0x258>
ffffffff9403fc64:    0103102b     sltu    $v0,$t0,$v1
ffffffff9403fc68:    000412c2     srl    $v0,$a0,0xb
ffffffff9403fc6c:    304201f8     andi    $v0,$v0,0x1f8
ffffffff9403fc70:    3c01941e     lui    $at,0x941e
ffffffff9403fc74:    2421c264     addiu    $at,$at,-15772
ffffffff9403fc78:    00221021     addu    $v0,$at,$v0
ffffffff9403fc7c:    0900ff38     j    ffffffff9403fce0 <timer_bh+0x2b4>
ffffffff9403fc80:    8c430004     lw    $v1,4($v0)
ffffffff9403fc84:    14400007     bnez    $v0,ffffffff9403fca4 <timer_bh+0x278>
ffffffff9403fc88:    00041442     srl    $v0,$a0,0x11
ffffffff9403fc8c:    304201f8     andi    $v0,$v0,0x1f8
ffffffff9403fc90:    3c01941e     lui    $at,0x941e
ffffffff9403fc94:    2421c05c     addiu    $at,$at,-16292
ffffffff9403fc98:    00221021     addu    $v0,$at,$v0
ffffffff9403fc9c:    0900ff38     j    ffffffff9403fce0 <timer_bh+0x2b4>
ffffffff9403fca0:    8c430004     lw    $v1,4($v0)
ffffffff9403fca4:    04610009     bgez    $v1,ffffffff9403fccc <timer_bh+0x2a0>
ffffffff9403fca8:    00041682     srl    $v0,$a0,0x1a
ffffffff9403fcac:    3c02941e     lui    $v0,0x941e
ffffffff9403fcb0:    8c42c670     lw    $v0,-14736($v0)
ffffffff9403fcb4:    000210c0     sll    $v0,$v0,0x3
ffffffff9403fcb8:    3c01941e     lui    $at,0x941e
ffffffff9403fcbc:    2421c674     addiu    $at,$at,-14732
ffffffff9403fcc0:    00221021     addu    $v0,$at,$v0
ffffffff9403fcc4:    0900ff38     j    ffffffff9403fce0 <timer_bh+0x2b4>
ffffffff9403fcc8:    8c430004     lw    $v1,4($v0)
ffffffff9403fccc:    000210c0     sll    $v0,$v0,0x3
ffffffff9403fcd0:    3c01941e     lui    $at,0x941e
ffffffff9403fcd4:    2421be54     addiu    $at,$at,-16812
ffffffff9403fcd8:    00221021     addu    $v0,$at,$v0
ffffffff9403fcdc:    8c430004     lw    $v1,4($v0)
ffffffff9403fce0:    8c620000     lw    $v0,0($v1)
ffffffff9403fce4:    ac450004     sw    $a1,4($v0)
ffffffff9403fce8:    aca20000     sw    $v0,0($a1)
ffffffff9403fcec:    aca30004     sw    $v1,4($a1)
ffffffff9403fcf0:    ac650000     sw    $a1,0($v1)
ffffffff9403fcf4:    00e02821     move    $a1,$a3
ffffffff9403fcf8:    54a6ffc7     0x54a6ffc7
ffffffff9403fcfc:    8ca70000     lw    $a3,0($a1)
ffffffff9403fd00:    acc60000     sw    $a2,0($a2)
ffffffff9403fd04:    acc60004     sw    $a2,4($a2)
ffffffff9403fd08:    8d420000     lw    $v0,0($t2)
ffffffff9403fd0c:    24420001     addiu    $v0,$v0,1
ffffffff9403fd10:    3042003f     andi    $v0,$v0,0x3f
ffffffff9403fd14:    ad420000     sw    $v0,0($t2)
ffffffff9403fd18:    8d630000     lw    $v1,0($t3)
ffffffff9403fd1c:    8c620000     lw    $v0,0($v1)
ffffffff9403fd20:    144f0005     bne    $v0,$t7,ffffffff9403fd38
<timer_bh+0x30c>
ffffffff9403fd24:    00000000     nop
ffffffff9403fd28:    25ad0001     addiu    $t5,$t5,1
ffffffff9403fd2c:    2da20005     sltiu    $v0,$t5,5
ffffffff9403fd30:    1440ffab     bnez    $v0,ffffffff9403fbe0 <timer_bh+0x1b4>
ffffffff9403fd34:    256b0004     addiu    $t3,$t3,4
ffffffff9403fd38:    3c02941e     lui    $v0,0x941e
ffffffff9403fd3c:    8c42c670     lw    $v0,-14736($v0)
ffffffff9403fd40:    000210c0     sll    $v0,$v0,0x3
ffffffff9403fd44:    3c10941e     lui    $s0,0x941e
ffffffff9403fd48:    2610c674     addiu    $s0,$s0,-14732
ffffffff9403fd4c:    02028021     addu    $s0,$s0,$v0
ffffffff9403fd50:    8e050000     lw    $a1,0($s0)
ffffffff9403fd54:    10b00020     beq    $a1,$s0,ffffffff9403fdd8
<timer_bh+0x3ac>
ffffffff9403fd58:    00000000     nop
ffffffff9403fd5c:    8e220000     lw    $v0,0($s1)
ffffffff9403fd60:    8ca30008     lw    $v1,8($a1)
ffffffff9403fd64:    00431023     subu    $v0,$v0,$v1
ffffffff9403fd68:    0440001b     bltz    $v0,ffffffff9403fdd8 <timer_bh+0x3ac>
ffffffff9403fd6c:    00000000     nop
ffffffff9403fd70:    8ca60010     lw    $a2,16($a1)
ffffffff9403fd74:    8ca30000     lw    $v1,0($a1)
ffffffff9403fd78:    10600004     beqz    $v1,ffffffff9403fd8c <timer_bh+0x360>
ffffffff9403fd7c:    8ca4000c     lw    $a0,12($a1)
ffffffff9403fd80:    8ca20004     lw    $v0,4($a1)
ffffffff9403fd84:    ac620004     sw    $v0,4($v1)
ffffffff9403fd88:    ac430000     sw    $v1,0($v0)
ffffffff9403fd8c:    aca00004     sw    $zero,4($a1)
ffffffff9403fd90:    aca00000     sw    $zero,0($a1)
ffffffff9403fd94:    40016000     mfc0    $at,$12
ffffffff9403fd98:    00000000     nop
ffffffff9403fd9c:    3421001f     ori    $at,$at,0x1f
ffffffff9403fda0:    3821001e     xori    $at,$at,0x1e
ffffffff9403fda4:    40816000     mtc0    $at,$12
ffffffff9403fda8:    00c0f809     jalr    $a2
ffffffff9403fdac:    00000000     nop
ffffffff9403fdb0:    40016000     mfc0    $at,$12
ffffffff9403fdb4:    00000000     nop
ffffffff9403fdb8:    34210001     ori    $at,$at,0x1
ffffffff9403fdbc:    38210001     xori    $at,$at,0x1
ffffffff9403fdc0:    40816000     mtc0    $at,$12
    ...
ffffffff9403fdd0:    0900ff55     j    ffffffff9403fd54 <timer_bh+0x328>
ffffffff9403fdd4:    8e050000     lw    $a1,0($s0)
ffffffff9403fdd8:    3c02941e     lui    $v0,0x941e
ffffffff9403fddc:    8c42ce74     lw    $v0,-12684($v0)
ffffffff9403fde0:    3c03941e     lui    $v1,0x941e
ffffffff9403fde4:    8c63c670     lw    $v1,-14736($v1)
ffffffff9403fde8:    24420001     addiu    $v0,$v0,1
ffffffff9403fdec:    24630001     addiu    $v1,$v1,1
ffffffff9403fdf0:    3c01941e     lui    $at,0x941e
ffffffff9403fdf4:    ac22ce74     sw    $v0,-12684($at)
ffffffff9403fdf8:    8e240000     lw    $a0,0($s1)
ffffffff9403fdfc:    306300ff     andi    $v1,$v1,0xff
ffffffff9403fe00:    3c01941e     lui    $at,0x941e
ffffffff9403fe04:    ac23c670     sw    $v1,-14736($at)
ffffffff9403fe08:    00822023     subu    $a0,$a0,$v0
ffffffff9403fe0c:    0481ff6a     bgez    $a0,ffffffff9403fbb8 <timer_bh+0x18c>
ffffffff9403fe10:    00000000     nop
ffffffff9403fe14:    40016000     mfc0    $at,$12
ffffffff9403fe18:    00000000     nop
ffffffff9403fe1c:    3421001f     ori    $at,$at,0x1f
ffffffff9403fe20:    3821001e     xori    $at,$at,0x1e
ffffffff9403fe24:    40816000     mtc0    $at,$12
ffffffff9403fe28:    8fbf0018     lw    $ra,24($sp)
ffffffff9403fe2c:    8fb10014     lw    $s1,20($sp)
ffffffff9403fe30:    8fb00010     lw    $s0,16($sp)
ffffffff9403fe34:    03e00008     jr    $ra
ffffffff9403fe38:    27bd0020     addiu    $sp,$sp,32

ffffffff9403fe3c <timer_softirq>:
ffffffff9403fe3c:    27bdffe0     addiu    $sp,$sp,-32

(skip ...)

--------------------------------------------------------------------------------------------

5. The attached is the source file of timer.c(linux-2.4.17_mvl21/kernel/timer.c)


Thanks.

-- 
Best Regards,

Libing Liu

------=_Part_24820_2636690.1195544618618
Content-Type: application/octet-stream; name=timer.c
Content-Transfer-Encoding: base64
X-Attachment-Id: f_f982iasa
Content-Disposition: attachment; filename=timer.c

LyoNCiAqICBsaW51eC9rZXJuZWwvdGltZXIuYw0KICoNCiAqICBLZXJuZWwgaW50ZXJuYWwgdGlt
ZXJzLCBrZXJuZWwgdGltZWtlZXBpbmcsIGJhc2ljIHByb2Nlc3Mgc3lzdGVtIGNhbGxzDQogKg0K
ICogIENvcHlyaWdodCAoQykgMTk5MSwgMTk5MiAgTGludXMgVG9ydmFsZHMNCiAqDQogKiAgMTk5
Ny0wMS0yOCAgTW9kaWZpZWQgYnkgRmlubiBBcm5lIEdhbmdzdGFkIHRvIG1ha2UgdGltZXJzIHNj
YWxlIGJldHRlci4NCiAqDQogKiAgMTk5Ny0wOS0xMCAgVXBkYXRlZCBOVFAgY29kZSBhY2NvcmRp
bmcgdG8gdGVjaG5pY2FsIG1lbW9yYW5kdW0gSmFuICc5Ng0KICogICAgICAgICAgICAgICJBIEtl
cm5lbCBNb2RlbCBmb3IgUHJlY2lzaW9uIFRpbWVrZWVwaW5nIiBieSBEYXZlIE1pbGxzDQogKiAg
MTk5OC0xMi0yNCAgRml4ZWQgYSB4dGltZSBTTVAgcmFjZSAod2UgbmVlZCB0aGUgeHRpbWVfbG9j
ayBydyBzcGlubG9jayB0bw0KICogICAgICAgICAgICAgIHNlcmlhbGl6ZSBhY2Nlc3NlcyB0byB4
dGltZS9sb3N0X3RpY2tzKS4NCiAqICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgQ29weXJp
Z2h0IChDKSAxOTk4ICBBbmRyZWEgQXJjYW5nZWxpDQogKiAgMTk5OS0wMy0xMCAgSW1wcm92ZWQg
TlRQIGNvbXBhdGliaWxpdHkgYnkgVWxyaWNoIFdpbmRsDQogKi8NCg0KI2luY2x1ZGUgPGxpbnV4
L2NvbmZpZy5oPg0KI2luY2x1ZGUgPGxpbnV4L21tLmg+DQojaW5jbHVkZSA8bGludXgvdGltZXgu
aD4NCiNpbmNsdWRlIDxsaW51eC9kZWxheS5oPg0KI2luY2x1ZGUgPGxpbnV4L3NtcF9sb2NrLmg+
DQojaW5jbHVkZSA8bGludXgvaW50ZXJydXB0Lmg+DQojaW5jbHVkZSA8bGludXgva2VybmVsX3N0
YXQuaD4NCiNpbmNsdWRlIDxsaW51eC9ocnRpbWUuaD4NCiNpbmNsdWRlIDxsaW51eC9jb21waWxl
ci5oPg0KI2luY2x1ZGUgPGFzbS9zaWduYWwuaD4NCg0KI2luY2x1ZGUgPGxpbnV4L3RyYWNlLmg+
DQojaW5jbHVkZSA8YXNtL3VhY2Nlc3MuaD4NCiNpZmRlZiBDT05GSUdfVElNRVJfU1RBVFMNCiNp
bmNsdWRlIDxhc20vdGltZXBlZy5oPg0KI2Vsc2UNCiNkZWZpbmUgVFBfU1RBUlQoYSkNCiNkZWZp
bmUgVFBfU1RPUChhKQ0KI2RlZmluZSBEVElNRVBFRyhhLGIpDQojZW5kaWYNCg0KLyoNCiAqIFRp
bWVrZWVwaW5nIHZhcmlhYmxlcw0KICovDQoNCmxvbmcgdGljayA9ICgxMDAwMDAwICsgSFovMikg
LyBIWjsgICAgLyogdGltZXIgaW50ZXJydXB0IHBlcmlvZCAqLw0KDQovKiBUaGUgY3VycmVudCB0
aW1lICovDQpzdHJ1Y3QgdGltZXZhbCB4dGltZSBfX2F0dHJpYnV0ZV9fICgoYWxpZ25lZCAoMTYp
KSk7DQovKg0KICogVGhpcyBzcGlubG9jayBwcm90ZWN0IHVzIGZyb20gcmFjZXMgaW4gU01QIHdo
aWxlIHBsYXlpbmcgd2l0aCB4dGltZS4gLWFyY2ENCiAqLw0Kcndsb2NrX3QgeHRpbWVfbG9jayA9
IFJXX0xPQ0tfVU5MT0NLRUQ7DQovKg0KICogVGhpcyBhdG9taWMgcHJldmVudHMgcmUtZW50cnkg
b2YgdGhlIHJ1bl90aW1lcl9saXN0IGFuZCBoYXMgdGhlIHNpZGUNCiAqIGVmZmVjdCBvZiBzaGlm
dGluZyBjb25mbGljdCBydW5zIHRvIHRoZSAib3duaW5nIiBjcHUuDQogKi8NCg0Kc3RhdGljIGF0
b21pY190IHRpbWVyX3Rhc2tsZXRfbG9jayA9IEFUT01JQ19JTklUKC0xKTsNCg0KLyogRG9uJ3Qg
Y29tcGxldGVseSBmYWlsIGZvciBIWiA+IDUwMC4gICovDQppbnQgdGlja2FkaiA9IDUwMC9IWiA/
IDogMTsgICAgICAgIC8qIG1pY3Jvc2VjcyAqLw0KDQpERUNMQVJFX1RBU0tfUVVFVUUodHFfdGlt
ZXIpOw0KREVDTEFSRV9UQVNLX1FVRVVFKHRxX2ltbWVkaWF0ZSk7DQoNCi8qDQogKiBwaGFzZS1s
b2NrIGxvb3AgdmFyaWFibGVzDQogKi8NCi8qIFRJTUVfRVJST1IgcHJldmVudHMgb3ZlcndyaXRp
bmcgdGhlIENNT1MgY2xvY2sgKi8NCmludCB0aW1lX3N0YXRlID0gVElNRV9PSzsgICAgICAgIC8q
IGNsb2NrIHN5bmNocm9uaXphdGlvbiBzdGF0dXMgICAgKi8NCmludCB0aW1lX3N0YXR1cyA9IFNU
QV9VTlNZTkM7ICAgICAgICAvKiBjbG9jayBzdGF0dXMgYml0cyAgICAgICAgKi8NCmxvbmcgdGlt
ZV9vZmZzZXQ7ICAgICAgICAgICAgLyogdGltZSBhZGp1c3RtZW50ICh1cykgICAgICAgICovDQps
b25nIHRpbWVfY29uc3RhbnQgPSAyOyAgICAgICAgICAgIC8qIHBsbCB0aW1lIGNvbnN0YW50ICAg
ICAgICAqLw0KbG9uZyB0aW1lX3RvbGVyYW5jZSA9IE1BWEZSRVE7ICAgICAgICAvKiBmcmVxdWVu
Y3kgdG9sZXJhbmNlIChwcG0pICAgICovDQpsb25nIHRpbWVfcHJlY2lzaW9uID0gMTsgICAgICAg
IC8qIGNsb2NrIHByZWNpc2lvbiAodXMpICAgICAgICAqLw0KbG9uZyB0aW1lX21heGVycm9yID0g
TlRQX1BIQVNFX0xJTUlUOyAgICAvKiBtYXhpbXVtIGVycm9yICh1cykgICAgICAgICovDQpsb25n
IHRpbWVfZXN0ZXJyb3IgPSBOVFBfUEhBU0VfTElNSVQ7ICAgIC8qIGVzdGltYXRlZCBlcnJvciAo
dXMpICAgICAgICAqLw0KbG9uZyB0aW1lX3BoYXNlOyAgICAgICAgICAgIC8qIHBoYXNlIG9mZnNl
dCAoc2NhbGVkIHVzKSAgICAqLw0KbG9uZyB0aW1lX2ZyZXEgPSAoKDEwMDAwMDAgKyBIWi8yKSAl
IEhaIC0gSFovMikgPDwgU0hJRlRfVVNFQzsNCiAgICAgICAgICAgICAgICAgICAgLyogZnJlcXVl
bmN5IG9mZnNldCAoc2NhbGVkIHBwbSkqLw0KbG9uZyB0aW1lX2FkajsgICAgICAgICAgICAgICAg
LyogdGljayBhZGp1c3QgKHNjYWxlZCAxIC8gSFopICAgICovDQpsb25nIHRpbWVfcmVmdGltZTsg
ICAgICAgICAgICAvKiB0aW1lIGF0IGxhc3QgYWRqdXN0bWVudCAocykgICAgKi8NCg0KbG9uZyB0
aW1lX2FkanVzdDsNCmxvbmcgdGltZV9hZGp1c3Rfc3RlcDsNCg0KdW5zaWduZWQgbG9uZyBldmVu
dDsNCg0KZXh0ZXJuIGludCBkb19zZXRpdGltZXIoaW50LCBzdHJ1Y3QgaXRpbWVydmFsICosIHN0
cnVjdCBpdGltZXJ2YWwgKik7DQoNCnZvbGF0aWxlIHU2NCBqaWZmaWVzXzY0PTA7DQoNCnVuc2ln
bmVkIGludCAqIHByb2ZfYnVmZmVyOw0KdW5zaWduZWQgbG9uZyBwcm9mX2xlbjsNCnVuc2lnbmVk
IGxvbmcgcHJvZl9zaGlmdDsNCg0KLyoNCiAqIEV2ZW50IHRpbWVyIGNvZGUNCiAqLw0KI2lmZGVm
IENPTkZJR19ISUdIX1JFU19USU1FUlMNCi8qDQogKiBpZmRlZiBlbGltaW5hdG9yIG1hY3JvLi4u
DQogKi8NCiNkZWZpbmUgSUZfSElHSF9SRVMoYSkgYQ0KI2lmbmRlZiBDT05GSUdfTkVXX1RJTUVS
TElTVA0KI2RlZmluZSBDT05GSUdfTkVXX1RJTUVSTElTVA0KI2VuZGlmDQojZWxzZQ0KI2RlZmlu
ZSBJRl9ISUdIX1JFUyhhKQ0KI2VuZGlmDQojaWYgISBkZWZpbmVkKENPTkZJR19DQVNDQURJTkdf
VElNRVJTKSAmJiAhIGRlZmluZWQoQ09ORklHX05FV19USU1FUkxJU1QpDQojZGVmaW5lIENPTkZJ
R19DQVNDQURJTkdfVElNRVJTDQojZW5kaWYgLyogQ09ORklHX0hJR0hfUkVTX1RJTUVSUyAqLw0K
I2RlZmluZSBUVk5fQklUUyA2DQojZGVmaW5lIFRWUl9CSVRTIDgNCiNkZWZpbmUgVFZOX1NJWkUg
KDEgPDwgVFZOX0JJVFMpDQojZGVmaW5lIFRWUl9TSVpFICgxIDw8IFRWUl9CSVRTKQ0KI2RlZmlu
ZSBUVk5fTUFTSyAoVFZOX1NJWkUgLSAxKQ0KI2RlZmluZSBUVlJfTUFTSyAoVFZSX1NJWkUgLSAx
KQ0KI2lmZGVmIENPTkZJR19ORVdfVElNRVJMSVNUDQojZGVmaW5lIElGX05FV19USU1FUl9MSVNU
KGEpIGENCiNpZm5kZWYgQ09ORklHX05FV19USU1FUl9MSVNUU0laRQ0KI2RlZmluZSBDT05GSUdf
TkVXX1RJTUVSX0xJU1RTSVpFIDUxMg0KI2VuZGlmIC8qIENPTkZJR19ORVdfVElNRVJMSVNUICov
DQojZGVmaW5lIE5FV19UVkVDX1NJWkUgQ09ORklHX05FV19USU1FUl9MSVNUU0laRQ0KI2RlZmlu
ZSBORVdfVFZFQ19NQVNLIChORVdfVFZFQ19TSVpFIC0gMSkNCnN0YXRpYyBzdHJ1Y3QgbGlzdF9o
ZWFkIG5ld190dmVjW05FV19UVkVDX1NJWkVdOw0KI2Vsc2UgIC8qIENPTkZJR19ORVdfVElNRVJM
SVNUICovDQojZGVmaW5lIElGX05FV19USU1FUl9MSVNUKGEpDQojZW5kaWYgLyogQ09ORklHX05F
V19USU1FUkxJU1QgKi8NCiNpZmRlZiBDT05GSUdfQ0FTQ0FESU5HX1RJTUVSUw0Kc3RydWN0IHRp
bWVyX3ZlYyB7DQogICAgaW50IGluZGV4Ow0KICAgIHN0cnVjdCBsaXN0X2hlYWQgdmVjW1RWTl9T
SVpFXTsNCn07DQoNCnN0cnVjdCB0aW1lcl92ZWNfcm9vdCB7DQogICAgaW50IGluZGV4Ow0KICAg
IHN0cnVjdCBsaXN0X2hlYWQgdmVjW1RWUl9TSVpFXTsNCn07DQoNCnN0YXRpYyBzdHJ1Y3QgdGlt
ZXJfdmVjIHR2NTsNCnN0YXRpYyBzdHJ1Y3QgdGltZXJfdmVjIHR2NDsNCnN0YXRpYyBzdHJ1Y3Qg
dGltZXJfdmVjIHR2MzsNCnN0YXRpYyBzdHJ1Y3QgdGltZXJfdmVjIHR2MjsNCnN0YXRpYyBzdHJ1
Y3QgdGltZXJfdmVjX3Jvb3QgdHYxOw0KDQpzdGF0aWMgc3RydWN0IHRpbWVyX3ZlYyAqIGNvbnN0
IHR2ZWNzW10gPSB7DQogICAgKHN0cnVjdCB0aW1lcl92ZWMgKikmdHYxLCAmdHYyLCAmdHYzLCAm
dHY0LCAmdHY1DQp9Ow0KDQojZGVmaW5lIE5PT0ZfVFZFQ1MgKHNpemVvZih0dmVjcykgLyBzaXpl
b2YodHZlY3NbMF0pKQ0KI2VuZGlmIC8qIENPTkZJR19DQVNDQURJTkdfVElNRVJTICovDQoNCnZv
aWQgaW5pdF90aW1lcnZlY3MgKHZvaWQpDQp7DQogICAgaW50IGk7DQoNCiNpZmRlZiBDT05GSUdf
Q0FTQ0FESU5HX1RJTUVSUw0KICAgIGZvciAoaSA9IDA7IGkgPCBUVk5fU0laRTsgaSsrKSB7DQog
ICAgICAgIElOSVRfTElTVF9IRUFEKHR2NS52ZWMgKyBpKTsNCiAgICAgICAgSU5JVF9MSVNUX0hF
QUQodHY0LnZlYyArIGkpOw0KICAgICAgICBJTklUX0xJU1RfSEVBRCh0djMudmVjICsgaSk7DQog
ICAgICAgIElOSVRfTElTVF9IRUFEKHR2Mi52ZWMgKyBpKTsNCiAgICB9DQogICAgZm9yIChpID0g
MDsgaSA8IFRWUl9TSVpFOyBpKyspDQogICAgICAgIElOSVRfTElTVF9IRUFEKCB0djEudmVjICsg
aSk7DQojZW5kaWYgLyogQ09ORklHX0NBU0NBRElOR19USU1FUlMgKi8NCiNpZmRlZiBDT05GSUdf
TkVXX1RJTUVSTElTVA0KICAgICAgICBmb3IgKGkgPSAwOyBpIDwgTkVXX1RWRUNfU0laRTsgaSsr
KQ0KICAgICAgICAgICAgICAgIElOSVRfTElTVF9IRUFEKCBuZXdfdHZlYyArIGkpOw0KI2VuZGlm
IC8qIENPTkZJR19ORVdfVElNRVJMSVNUICovDQp9DQoNCnN0YXRpYyB1bnNpZ25lZCBsb25nIHRp
bWVyX2ppZmZpZXM7DQoNCi8qIEluaXRpYWxpemUgYm90aCBleHBsaWNpdGx5IC0gbGV0J3MgdHJ5
IHRvIGhhdmUgdGhlbSBpbiB0aGUgc2FtZSBjYWNoZSBsaW5lICovDQpzcGlubG9ja190IHRpbWVy
bGlzdF9sb2NrID0gU1BJTl9MT0NLX1VOTE9DS0VEOw0KDQojaWYgZGVmaW5lZCggQ09ORklHX1NN
UCkgfHwgIGRlZmluZWQoQ09ORklHX0hJR0hfUkVTX1RJTUVSUykNCnZvbGF0aWxlIHN0cnVjdCB0
aW1lcl9saXN0ICogdm9sYXRpbGUgcnVubmluZ190aW1lcjsNCiNkZWZpbmUgdGltZXJfZW50ZXIo
dCkgZG8geyBydW5uaW5nX3RpbWVyID0gdDsgbWIoKTsgfSB3aGlsZSAoMCkNCiNkZWZpbmUgdGlt
ZXJfZXhpdCgpIGRvIHsgcnVubmluZ190aW1lciA9IE5VTEw7IH0gd2hpbGUgKDApDQojZGVmaW5l
IHRpbWVyX2lzX2luYWN0aXZlKCkgKHJ1bm5pbmdfdGltZXIgPT0gTlVMTCkNCiNlbHNlDQojZGVm
aW5lIHRpbWVyX2VudGVyKHQpICAgICAgICBkbyB7IH0gd2hpbGUgKDApDQojZGVmaW5lIHRpbWVy
X2V4aXQoKSAgICAgICAgZG8geyB9IHdoaWxlICgwKQ0KI2RlZmluZSB0aW1lcl9pc19pbmFjdGl2
ZSgpICAgICAxDQojZW5kaWYNCg0KI2lmZGVmIENPTkZJR19TTVANCiNkZWZpbmUgdGltZXJfaXNf
cnVubmluZyh0KSAocnVubmluZ190aW1lciA9PSB0KQ0KI2RlZmluZSB0aW1lcl9zeW5jaHJvbml6
ZSh0KSB3aGlsZSAodGltZXJfaXNfcnVubmluZyh0KSkgYmFycmllcigpDQojZW5kaWYNCg0KDQoN
CnN0YXRpYyBpbmxpbmUgdm9pZCBpbnRlcm5hbF9hZGRfdGltZXIoc3RydWN0IHRpbWVyX2xpc3Qg
KnRpbWVyKQ0Kew0KICAgIC8qDQogICAgICogbXVzdCBiZSBjbGktZWQgd2hlbiBjYWxsaW5nIHRo
aXMNCiAgICAgKi8NCiNpZmRlZiBDT05GSUdfTkVXX1RJTUVSTElTVA0KICAgICAgICAgICAgICAg
IHVuc2lnbmVkIGxvbmcgZXhwaXJlcyA9IHRpbWVyLT5leHBpcmVzOw0KICAgICAgICAgICAgICAg
IElGX0hJR0hfUkVTKGludCBzdWJfZXhwaXJlcyA9IHRpbWVyLT5zdWJfZXhwaXJlczspDQogICAg
ICAgICAgICAgICAgaW50IGluZHg7DQogICAgICAgICAgICAgICAgc3RydWN0IGxpc3RfaGVhZCAq
cG9zLCpsaXN0X3N0YXJ0Ow0KDQogICAgICAgICAgICAgICAgaWYgKCB0aW1lX2JlZm9yZShleHBp
cmVzLCB0aW1lcl9qaWZmaWVzKSApew0KICAgICAgICAgICAgICAgICAgICAgICAgLyoNCiAgICAg
ICAgICAgICAgICAgICAgICAgICAqIGFscmVhZHkgZXhwaXJlZCwgc2NoZWR1bGUgZm9yIG5leHQg
dGljaw0KICAgICAgICAgICAgICAgICAgICAgICAgICogd291bGQgbGlrZSB0byBkbyBiZXR0ZXIg
aGVyZQ0KICAgICAgICAgICAgICAgICAgICAgICAgICogQWN0dWFsbHkgdGhpcyBub3cgd29ya3Mg
anVzdCBmaW5lIHdpdGggdGhlDQogICAgICAgICAgICAgICAgICAgICAgICAgKiBiYWNrIHVwIG9m
IHRpbWVyX2ppZmZpZXMgaW4gInJ1bl90aW1lcl9saXN0Ii4NCiAgICAgICAgICAgICAgICAgICAg
ICAgICAqIE5vdGUgdGhhdCB0aGlzIHB1dHMgdGhlIHRpbWVyIG9uIGEgbGlzdCBvdGhlcg0KICAg
ICAgICAgICAgICAgICAgICAgICAgICogdGhhbiB0aGUgb25lIGl0IGlkZXhlcyB0by4gIFdlIGRv
bid0IHdhbnQgdG8NCiAgICAgICAgICAgICAgICAgICAgICAgICAqIGNoYW5nZSB0aGUgZXhwaXJl
cyB2YWx1ZSBpbiB0aGUgdGltZXIgYXMgaXQgaXMNCiAgICAgICAgICAgICAgICAgICAgICAgICAq
IHVzZWQgYnkgdGhlIHJlcGVhdCBjb2RlIGluIHNldGl0aW1lciBhbmQgdGhlDQogICAgICAgICAg
ICAgICAgICAgICAgICAgKiBQT1NJWCB0aW1lcnMgY29kZS4NCiAgICAgICAgICAgICAgICAgICAg
ICAgICAqLw0KICAgICAgICAgICAgICAgICAgICAgICAgZXhwaXJlcyA9IHRpbWVyX2ppZmZpZXM7
DQogICAgICAgICAgICAgICAgICAgICAgICBJRl9ISUdIX1JFUyhzdWJfZXhwaXJlcyA9IDApOw0K
ICAgICAgICAgICAgICAgIH0NCiAgICAgICAgICAgICAgICAgICAgICAgDQogICAgICAgICAgICAg
ICAgaW5keCA9ICBleHBpcmVzICYgTkVXX1RWRUNfTUFTSzsNCiAgICAgICAgICAgICAgICBpZiAo
KGV4cGlyZXMgLSB0aW1lcl9qaWZmaWVzKSA8PSBORVdfVFZFQ19TSVpFKSB7DQojaWZkZWYgQ09O
RklHX0hJR0hfUkVTX1RJTUVSUw0KICAgICAgICAgICAgICAgICAgICAgICAgdW5zaWduZWQgbG9u
ZyBqaWZmaWVzX2Y7DQogICAgICAgICAgICAgICAgICAgICAgICAvKg0KICAgICAgICAgICAgICAg
ICAgICAgICAgICogVGhlIGhpZ2ggZGlmZiBiaXRzIGFyZSB0aGUgc2FtZSwgZ29lcyB0byB0aGUg
aGVhZCBvZg0KICAgICAgICAgICAgICAgICAgICAgICAgICogdGhlIGxpc3QsIHNvcnQgb24gc3Vi
X2V4cGlyZS4NCiAgICAgICAgICAgICAgICAgICAgICAgICAqLw0KICAgICAgICAgICAgICAgICAg
ICAgICAgZm9yIChwb3MgPSAobGlzdF9zdGFydCA9ICZuZXdfdHZlY1tpbmR4XSktPm5leHQ7DQog
ICAgICAgICAgICAgICAgICAgICAgICAgICAgIHBvcyAhPSBsaXN0X3N0YXJ0Ow0KICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICBwb3MgPSBwb3MtPm5leHQpew0KICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICBzdHJ1Y3QgdGltZXJfbGlzdCAqdG1yID0NCiAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICBsaXN0X2VudHJ5KHBvcywNCiAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIHN0cnVjdCB0aW1lcl9saXN0LA0KICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgbGlzdCk7DQog
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIGlmICgodG1yLT5zdWJfZXhwaXJlcyA+PSBz
dWJfZXhwaXJlcykgfHwNCiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICh0bXIt
PmV4cGlyZXMgIT0gZXhwaXJlcykpew0KICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgIGJyZWFrOw0KICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICB9DQogICAgICAg
ICAgICAgICAgICAgICAgICB9DQogICAgICAgICAgICAgICAgICAgICAgICBsaXN0X2FkZF90YWls
KCZ0aW1lci0+bGlzdCwgcG9zKTsNCiAgICAgICAgICAgICAgICAgICAgICAgIC8qDQogICAgICAg
ICAgICAgICAgICAgICAgICAgKiBOb3RlcyB0byBtZS4gIFVzZSBqaWZmaWVzIGhlcmUgaW5zdGVh
ZCBvZg0KICAgICAgICAgICAgICAgICAgICAgICAgICogdGltZXJfamlmZmllcyB0byBwcmV2ZW50
IGFkZGluZyB1bm5lZWRlZCBpbnRlcnJ1cHRzLg0KICAgICAgICAgICAgICAgICAgICAgICAgICog
VGltZXJfaXNfaW5hY3RpdmUoKSBpcyBmYWxzZSBpZiB3ZSBhcmUgY3VycmVudGx5DQogICAgICAg
ICAgICAgICAgICAgICAgICAgKiBhY3Rpdmx5IGRpc3BhdGNoaW5nIHRpbWVycy4gIFNpbmNlIHdl
IGFyZSB1bmRlcg0KICAgICAgICAgICAgICAgICAgICAgICAgICogdGhlIHNhbWUgc3BpbiBsb2Nr
LCBpdCBiZWluZyBmYWxzZSBtZWFucyB0aGF0DQogICAgICAgICAgICAgICAgICAgICAgICAgKiBp
dCBoYXMgZHJvcHBlZCB0aGUgc3BpbmxvY2sgdG8gY2FsbCB0aGUgdGltZXINCiAgICAgICAgICAg
ICAgICAgICAgICAgICAqIGZ1bmN0aW9uLCB3aGljaCBjb3VsZCB3ZWxsIGJlIHdobyBjYWxsZWQg
dXMuDQogICAgICAgICAgICAgICAgICAgICAgICAgKiBJbiBhbnkgY2FzZSwgd2UgZG9uJ3QgbmVl
ZCBhIG5ldyBpbnRlcnJ1cHQgYXMNCiAgICAgICAgICAgICAgICAgICAgICAgICAqIHRoZSB0aW1l
ciBkaXNwYWNoIGNvZGUgKHJ1bl90aW1lcl9saXN0KSB3aWxsDQogICAgICAgICAgICAgICAgICAg
ICAgICAgKiBwaWNrIHRoaXMgdXAgd2hlbiB0aGUgZnVuY3Rpb24gaXQgaXMgY2FsbGluZw0KICAg
ICAgICAgICAgICAgICAgICAgICAgICogcmV0dXJucy4NCiAgICAgICAgICAgICAgICAgICAgICAg
ICAqLw0KICAgICAgICAgICAgICAgICAgICAgICAgaWYgKCBleHBpcmVzID09IChqaWZmaWVzX2Yg
PSBqaWZmaWVzKSAmJg0KICAgICAgICAgICAgICAgICAgICAgICAgICAgICBsaXN0X3N0YXJ0LT5u
ZXh0ID09ICZ0aW1lci0+bGlzdCAmJg0KICAgICAgICAgICAgICAgICAgICAgICAgICAgICB0aW1l
cl9pc19pbmFjdGl2ZSgpKSB7DQogICAgICAgICAgICAgICAgICAgICAgICAgICAgIHNjaGVkdWxl
X25leHRfaW50KGppZmZpZXNfZiwgc3ViX2V4cGlyZXMsMSk7DQogICAgICAgICAgICAgICAgICAg
ICAgICB9DQojZWxzZQ0KICAgICAgICAgICAgICAgICAgICAgICAgcG9zID0gKCZuZXdfdHZlY1tp
bmR4XSktPm5leHQ7DQogICAgICAgICAgICAgICAgICAgICAgICBsaXN0X2FkZF90YWlsKCZ0aW1l
ci0+bGlzdCwgcG9zKTsNCiNlbmRpZiAvKiBDT05GSUdfSElHSF9SRVNfVElNRVJTICovDQogICAg
ICAgICAgICAgICAgfWVsc2V7DQogICAgICAgICAgICAgICAgICAgICAgICAvKg0KICAgICAgICAg
ICAgICAgICAgICAgICAgICogVGhlIGhpZ2ggZGlmZiBiaXRzIGRpZmZlciwgc2VhcmNoIGZyb20g
dGhlIHRhaWwNCiAgICAgICAgICAgICAgICAgICAgICAgICAqIFRoZSBmb3Igd2lsbCBwaWNrIHVw
IGFuIGVtcHR5IGxpc3QuDQogICAgICAgICAgICAgICAgICAgICAgICAgKi8NCiAgICAgICAgICAg
ICAgICAgICAgICAgICBmb3IgKHBvcyA9IChsaXN0X3N0YXJ0ID0gJm5ld190dmVjW2luZHhdKS0+
cHJldjsNCiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgcG9zICE9IGxpc3Rfc3RhcnQ7DQog
ICAgICAgICAgICAgICAgICAgICAgICAgICAgIHBvcyA9IHBvcy0+cHJldil7DQogICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgIHN0cnVjdCB0aW1lcl9saXN0ICp0bXIgPQ0KICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIGxpc3RfZW50cnkocG9zLA0KICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgc3RydWN0IHRpbWVyX2xp
c3QsDQogICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICBs
aXN0KTsNCiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgaWYgKHRpbWVfYWZ0ZXIodG1y
LT5leHBpcmVzLCBleHBpcmVzKSl7DQogICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgY29udGludWU7DQogICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIH0NCiAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgSUZfSElHSF9SRVMoDQogICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgIGlmICgodG1yLT5leHBpcmVzICE9IGV4cGlyZXMp
IHx8DQogICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAodG1y
LT5zdWJfZXhwaXJlcyA8IHN1Yl9leHBpcmVzKSkgew0KICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgIGJyZWFrOw0KICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICB9DQogICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICkNCiAgICAgICAgICAgICAgICAgICAgICAgIH0NCiAgICAgICAgICAgICAg
ICAgICAgICAgIGxpc3RfYWRkKCZ0aW1lci0+bGlzdCwgcG9zKTsNCiAgICAgICAgICAgICAgICB9
DQogICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgDQojZW5kaWYgLyogQ09ORklHX05FV19U
SU1FUkxJU1QgKi8NCiNpZmRlZiBDT05GSUdfQ0FTQ0FESU5HX1RJTUVSUw0KICAgIHVuc2lnbmVk
IGxvbmcgZXhwaXJlcyA9IHRpbWVyLT5leHBpcmVzOw0KICAgIHVuc2lnbmVkIGxvbmcgaWR4ID0g
ZXhwaXJlcyAtIHRpbWVyX2ppZmZpZXM7DQogICAgc3RydWN0IGxpc3RfaGVhZCAqIHZlYzsNCg0K
ICAgIGlmIChpZHggPCBUVlJfU0laRSkgew0KICAgICAgICBpbnQgaSA9IGV4cGlyZXMgJiBUVlJf
TUFTSzsNCiAgICAgICAgdmVjID0gdHYxLnZlYyArIGk7DQogICAgfSBlbHNlIGlmIChpZHggPCAx
IDw8IChUVlJfQklUUyArIFRWTl9CSVRTKSkgew0KICAgICAgICBpbnQgaSA9IChleHBpcmVzID4+
IFRWUl9CSVRTKSAmIFRWTl9NQVNLOw0KICAgICAgICB2ZWMgPSB0djIudmVjICsgaTsNCiAgICB9
IGVsc2UgaWYgKGlkeCA8IDEgPDwgKFRWUl9CSVRTICsgMiAqIFRWTl9CSVRTKSkgew0KICAgICAg
ICBpbnQgaSA9IChleHBpcmVzID4+IChUVlJfQklUUyArIFRWTl9CSVRTKSkgJiBUVk5fTUFTSzsN
CiAgICAgICAgdmVjID0gIHR2My52ZWMgKyBpOw0KICAgIH0gZWxzZSBpZiAoaWR4IDwgMSA8PCAo
VFZSX0JJVFMgKyAzICogVFZOX0JJVFMpKSB7DQogICAgICAgIGludCBpID0gKGV4cGlyZXMgPj4g
KFRWUl9CSVRTICsgMiAqIFRWTl9CSVRTKSkgJiBUVk5fTUFTSzsNCiAgICAgICAgdmVjID0gdHY0
LnZlYyArIGk7DQogICAgfSBlbHNlIGlmICgoc2lnbmVkIGxvbmcpIGlkeCA8IDApIHsNCiAgICAg
ICAgLyogY2FuIGhhcHBlbiBpZiB5b3UgYWRkIGEgdGltZXIgd2l0aCBleHBpcmVzID09IGppZmZp
ZXMsDQogICAgICAgICAqIG9yIHlvdSBzZXQgYSB0aW1lciB0byBnbyBvZmYgaW4gdGhlIHBhc3QN
CiAgICAgICAgICovDQogICAgICAgIHZlYyA9IHR2MS52ZWMgKyB0djEuaW5kZXg7DQogICAgfSBl
bHNlIGlmIChpZHggPD0gMHhmZmZmZmZmZlVMKSB7DQogICAgICAgIGludCBpID0gKGV4cGlyZXMg
Pj4gKFRWUl9CSVRTICsgMyAqIFRWTl9CSVRTKSkgJiBUVk5fTUFTSzsNCiAgICAgICAgdmVjID0g
dHY1LnZlYyArIGk7DQogICAgfSBlbHNlIHsNCiAgICAgICAgLyogQ2FuIG9ubHkgZ2V0IGhlcmUg
b24gYXJjaGl0ZWN0dXJlcyB3aXRoIDY0LWJpdCBqaWZmaWVzICovDQogICAgICAgIElOSVRfTElT
VF9IRUFEKCZ0aW1lci0+bGlzdCk7DQogICAgICAgIHJldHVybjsNCiAgICB9DQogICAgLyoNCiAg
ICAgKiBUaW1lcnMgYXJlIEZJRk8hDQogICAgICovDQogICAgbGlzdF9hZGQoJnRpbWVyLT5saXN0
LCB2ZWMtPnByZXYpOw0KI2VuZGlmIC8qIENPTkZJR19DQVNDQURJTkdfVElNRVJTICovDQp9DQoN
CnZvaWQgYWRkX3RpbWVyKHN0cnVjdCB0aW1lcl9saXN0ICp0aW1lcikNCnsNCiAgICB1bnNpZ25l
ZCBsb25nIGZsYWdzOw0KDQogICAgc3Bpbl9sb2NrX2lycXNhdmUoJnRpbWVybGlzdF9sb2NrLCBm
bGFncyk7DQogICAgaWYgKHRpbWVyX3BlbmRpbmcodGltZXIpKQ0KICAgICAgICBnb3RvIGJ1ZzsN
CiAgICBpbnRlcm5hbF9hZGRfdGltZXIodGltZXIpOw0KICAgIHNwaW5fdW5sb2NrX2lycXJlc3Rv
cmUoJnRpbWVybGlzdF9sb2NrLCBmbGFncyk7DQogICAgcmV0dXJuOw0KYnVnOg0KICAgIHNwaW5f
dW5sb2NrX2lycXJlc3RvcmUoJnRpbWVybGlzdF9sb2NrLCBmbGFncyk7DQogICAgcHJpbnRrKCJi
dWc6IGtlcm5lbCB0aW1lciBhZGRlZCB0d2ljZSBhdCAlcC5cbiIsDQogICAgICAgICAgICBfX2J1
aWx0aW5fcmV0dXJuX2FkZHJlc3MoMCkpOw0KfQ0KDQpzdGF0aWMgaW5saW5lIGludCBkZXRhY2hf
dGltZXIgKHN0cnVjdCB0aW1lcl9saXN0ICp0aW1lcikNCnsNCiAgICBpZiAoIXRpbWVyX3BlbmRp
bmcodGltZXIpKXsNCiAgICAgICAgcmV0dXJuIDA7DQogICAgICAgIH0NCiAgICBsaXN0X2RlbCgm
dGltZXItPmxpc3QpOw0KICAgIHJldHVybiAxOw0KfQ0KDQppbnQgbW9kX3RpbWVyKHN0cnVjdCB0
aW1lcl9saXN0ICp0aW1lciwgdW5zaWduZWQgbG9uZyBleHBpcmVzKQ0Kew0KICAgIGludCByZXQ7
DQogICAgdW5zaWduZWQgbG9uZyBmbGFnczsNCg0KICAgIHNwaW5fbG9ja19pcnFzYXZlKCZ0aW1l
cmxpc3RfbG9jaywgZmxhZ3MpOw0KICAgIHRpbWVyLT5leHBpcmVzID0gZXhwaXJlczsNCiAgICBy
ZXQgPSBkZXRhY2hfdGltZXIodGltZXIpOw0KICAgIGludGVybmFsX2FkZF90aW1lcih0aW1lcik7
DQogICAgc3Bpbl91bmxvY2tfaXJxcmVzdG9yZSgmdGltZXJsaXN0X2xvY2ssIGZsYWdzKTsNCiAg
ICByZXR1cm4gcmV0Ow0KfQ0KI2lmZGVmIENPTkZJR19ISUdIX1JFU19USU1FUlMNCmludCBtb2Rf
dGltZXJfaHIoc3RydWN0IHRpbWVyX2xpc3QgKnRpbWVyLA0KICAgICAgICAgICAgICAgICB1bnNp
Z25lZCBsb25nIGV4cGlyZXMsDQogICAgICAgICAgICAgICAgIGxvbmcgc3ViX2V4cGlyZXMpDQp7
DQogICAgaW50IHJldDsNCiAgICB1bnNpZ25lZCBsb25nIGZsYWdzOw0KDQogICAgc3Bpbl9sb2Nr
X2lycXNhdmUoJnRpbWVybGlzdF9sb2NrLCBmbGFncyk7DQogICAgdGltZXItPmV4cGlyZXMgPSBl
eHBpcmVzOw0KICAgICAgICB0aW1lci0+c3ViX2V4cGlyZXMgPSBzdWJfZXhwaXJlczsNCiAgICBy
ZXQgPSBkZXRhY2hfdGltZXIodGltZXIpOw0KICAgIGludGVybmFsX2FkZF90aW1lcih0aW1lcik7
DQogICAgc3Bpbl91bmxvY2tfaXJxcmVzdG9yZSgmdGltZXJsaXN0X2xvY2ssIGZsYWdzKTsNCiAg
ICByZXR1cm4gcmV0Ow0KfQ0KI2VuZGlmIC8qIENPTkZJR19ISUdIX1JFU19USU1FUlMgKi8NCg0K
aW50IGRlbF90aW1lcihzdHJ1Y3QgdGltZXJfbGlzdCAqIHRpbWVyKQ0Kew0KICAgIGludCByZXQ7
DQogICAgdW5zaWduZWQgbG9uZyBmbGFnczsNCg0KICAgIHNwaW5fbG9ja19pcnFzYXZlKCZ0aW1l
cmxpc3RfbG9jaywgZmxhZ3MpOw0KICAgIHJldCA9IGRldGFjaF90aW1lcih0aW1lcik7DQogICAg
dGltZXItPmxpc3QubmV4dCA9IHRpbWVyLT5saXN0LnByZXYgPSBOVUxMOw0KICAgIHNwaW5fdW5s
b2NrX2lycXJlc3RvcmUoJnRpbWVybGlzdF9sb2NrLCBmbGFncyk7DQogICAgcmV0dXJuIHJldDsN
Cn0NCg0KI2lmZGVmIENPTkZJR19TTVANCnZvaWQgc3luY190aW1lcnModm9pZCkNCnsNCiAgICBz
cGluX3VubG9ja193YWl0KCZnbG9iYWxfYmhfbG9jayk7DQp9DQoNCi8qDQogKiBTTVAgc3BlY2lm
aWMgZnVuY3Rpb24gdG8gZGVsZXRlIHBlcmlvZGljIHRpbWVyLg0KICogQ2FsbGVyIG11c3QgZGlz
YWJsZSBieSBzb21lIG1lYW5zIHJlc3RhcnRpbmcgdGhlIHRpbWVyDQogKiBmb3IgbmV3LiBVcG9u
IGV4aXQgdGhlIHRpbWVyIGlzIG5vdCBxdWV1ZWQgYW5kIGhhbmRsZXIgaXMgbm90IHJ1bm5pbmcN
CiAqIG9uIGFueSBDUFUuIEl0IHJldHVybnMgbnVtYmVyIG9mIHRpbWVzLCB3aGljaCB0aW1lciB3
YXMgZGVsZXRlZA0KICogKGZvciByZWZlcmVuY2UgY291bnRpbmcpLg0KICovDQoNCmludCBkZWxf
dGltZXJfc3luYyhzdHJ1Y3QgdGltZXJfbGlzdCAqIHRpbWVyKQ0Kew0KICAgIGludCByZXQgPSAw
Ow0KDQogICAgZm9yICg7Oykgew0KICAgICAgICB1bnNpZ25lZCBsb25nIGZsYWdzOw0KICAgICAg
ICBpbnQgcnVubmluZzsNCg0KICAgICAgICBzcGluX2xvY2tfaXJxc2F2ZSgmdGltZXJsaXN0X2xv
Y2ssIGZsYWdzKTsNCiAgICAgICAgcmV0ICs9IGRldGFjaF90aW1lcih0aW1lcik7DQogICAgICAg
IHRpbWVyLT5saXN0Lm5leHQgPSB0aW1lci0+bGlzdC5wcmV2ID0gMDsNCiAgICAgICAgcnVubmlu
ZyA9IHRpbWVyX2lzX3J1bm5pbmcodGltZXIpOw0KICAgICAgICBzcGluX3VubG9ja19pcnFyZXN0
b3JlKCZ0aW1lcmxpc3RfbG9jaywgZmxhZ3MpOw0KDQogICAgICAgIGlmICghcnVubmluZykNCiAg
ICAgICAgICAgIGJyZWFrOw0KDQogICAgICAgIHRpbWVyX3N5bmNocm9uaXplKHRpbWVyKTsNCiAg
ICB9DQoNCiAgICByZXR1cm4gcmV0Ow0KfQ0KI2VuZGlmDQoNCiNpZmRlZiBDT05GSUdfQ0FTQ0FE
SU5HX1RJTUVSUw0KDQpzdGF0aWMgaW5saW5lIHZvaWQgY2FzY2FkZV90aW1lcnMoc3RydWN0IHRp
bWVyX3ZlYyAqdHYpDQp7DQogICAgLyogY2FzY2FkZSBhbGwgdGhlIHRpbWVycyBmcm9tIHR2IHVw
IG9uZSBsZXZlbCAqLw0KICAgIHN0cnVjdCBsaXN0X2hlYWQgKmhlYWQsICpjdXJyLCAqbmV4dDsN
Cg0KICAgIGhlYWQgPSB0di0+dmVjICsgdHYtPmluZGV4Ow0KICAgIGN1cnIgPSBoZWFkLT5uZXh0
Ow0KICAgIC8qDQogICAgICogV2UgYXJlIHJlbW92aW5nIF9hbGxfIHRpbWVycyBmcm9tIHRoZSBs
aXN0LCBzbyB3ZSBkb24ndCAgaGF2ZSB0bw0KICAgICAqIGRldGFjaCB0aGVtIGluZGl2aWR1YWxs
eSwganVzdCBjbGVhciB0aGUgbGlzdCBhZnRlcndhcmRzLg0KICAgICAqLw0KICAgIHdoaWxlIChj
dXJyICE9IGhlYWQpIHsNCiAgICAgICAgc3RydWN0IHRpbWVyX2xpc3QgKnRtcDsNCg0KICAgICAg
ICB0bXAgPSBsaXN0X2VudHJ5KGN1cnIsIHN0cnVjdCB0aW1lcl9saXN0LCBsaXN0KTsNCiAgICAg
ICAgbmV4dCA9IGN1cnItPm5leHQ7DQogICAgICAgIGxpc3RfZGVsKGN1cnIpOyAvLyBub3QgbmVl
ZGVkDQogICAgICAgIGludGVybmFsX2FkZF90aW1lcih0bXApOw0KICAgICAgICBjdXJyID0gbmV4
dDsNCiAgICB9DQogICAgSU5JVF9MSVNUX0hFQUQoaGVhZCk7DQogICAgdHYtPmluZGV4ID0gKHR2
LT5pbmRleCArIDEpICYgVFZOX01BU0s7DQp9DQojZW5kaWYgLyogQ09ORklHX0NBU0NBRElOR19U
SU1FUlMgKi8NCg0Kc3RhdGljIGlubGluZSB2b2lkIHJ1bl90aW1lcl9saXN0KHZvaWQpDQp7DQog
ICAgICAgIElGX0hJR0hfUkVTKCB1bnNpZ25lZCBsb25nIGppZmZpZXNfZjsNCiAgICAgICAgICAg
ICAgICAgICAgIGxvbmcgc3ViX2ppZmYgPSAtMTsNCiAgICAgICAgICAgICAgICAgICAgIGxvbmcg
c3ViX2ppZmZpZV9mKTsNCiAgICBzcGluX2xvY2tfaXJxKCZ0aW1lcmxpc3RfbG9jayk7DQojaWZk
ZWYgQ09ORklHX0hJR0hfUkVTX1RJTUVSUw0KICAgICAgICByZWFkX2xvY2soJnh0aW1lX2xvY2sp
Ow0KICAgICAgICBqaWZmaWVzX2YgPSBqaWZmaWVzOw0KICAgICAgICBzdWJfamlmZmllX2YgPSBz
dWJfamlmZmllKCkgKyBxdWlja19nZXRfY3B1Y3RyKCk7DQogICAgICAgIHJlYWRfdW5sb2NrKCZ4
dGltZV9sb2NrKTsNCiAgICAgICAgd2hpbGUgKCB1bmxpa2VseShzdWJfamlmZmllX2YgPj0gY3lj
bGVzX3Blcl9qaWZmaWVzKSl7DQogICAgICAgICAgICAgICAgc3ViX2ppZmZpZV9mIC09IGN5Y2xl
c19wZXJfamlmZmllczsNCiAgICAgICAgICAgICAgICBqaWZmaWVzX2YrKzsNCiAgICAgICAgfQ0K
ICAgIHdoaWxlICgobG9uZykoamlmZmllc19mIC0gdGltZXJfamlmZmllcykgPj0gMCkgew0KI2Vs
c2UNCiAgICB3aGlsZSAoKGxvbmcpKGppZmZpZXMgLSB0aW1lcl9qaWZmaWVzKSA+PSAwKSB7DQoj
ZW5kaWYgLyogQ09ORklHX0hJR0hfUkVTX1RJTUVSUyAqLw0KICAgICAgICBzdHJ1Y3QgbGlzdF9o
ZWFkICpoZWFkLCAqY3VycjsNCiNpZmRlZiBDT05GSUdfQ0FTQ0FESU5HX1RJTUVSUw0KICAgICAg
ICBpZiAoIXR2MS5pbmRleCkgew0KICAgICAgICAgICAgaW50IG4gPSAxOw0KICAgICAgICAgICAg
ZG8gew0KICAgICAgICAgICAgICAgIGNhc2NhZGVfdGltZXJzKHR2ZWNzW25dKTsNCiAgICAgICAg
ICAgIH0gd2hpbGUgKHR2ZWNzW25dLT5pbmRleCA9PSAxICYmICsrbiA8IE5PT0ZfVFZFQ1MpOw0K
ICAgICAgICB9DQoNCiAgICAgICAgaGVhZCA9IHR2MS52ZWMgKyB0djEuaW5kZXg7DQojZW5kaWYg
LyogQ09ORklHX0NBU0NBRElOR19USU1FUlMgKi8NCiAgICAgICAgICAgICAgICBJRl9ORVdfVElN
RVJfTElTVCgNCiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICBoZWFkID0gbmV3X3R2
ZWMgKw0KICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICh0aW1lcl9qaWZmaWVzICAm
IE5FV19UVkVDX01BU0spOw0KICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICkNCiAg
ICAgICAgICAgICAgICAvKg0KICAgICAgICAgICAgICAgICAqIE5vdGUgdGhhdCB3ZSBuZXZlciBt
b3ZlICJoZWFkIiBidXQgY29udGludWUgdG8NCiAgICAgICAgICAgICAgICAgKiBwaWNrIHRoZSBm
aXJzdCBlbnRyeSBmcm9tIGl0LiAgVGhpcyBhbGxvd3MgbmV3DQogICAgICAgICAgICAgICAgICog
ZW50cmllcyB0byBiZSBpbnNlcnRlZCB3aGlsZSB3ZSB1bmxvY2sgZm9yIHRoZQ0KICAgICAgICAg
ICAgICAgICAqIGZ1bmN0aW9uIGNhbGwgYmVsb3cuDQogICAgICAgICAgICAgICAgICovDQpyZXBl
YXQ6DQogICAgICAgIGN1cnIgPSBoZWFkLT5uZXh0Ow0KICAgICAgICBpZiAoY3VyciAhPSBoZWFk
KSB7DQogICAgICAgICAgICBzdHJ1Y3QgdGltZXJfbGlzdCAqdGltZXI7DQogICAgICAgICAgICB2
b2lkICgqZm4pKHVuc2lnbmVkIGxvbmcpOw0KICAgICAgICAgICAgdW5zaWduZWQgbG9uZyBkYXRh
Ow0KDQogICAgICAgICAgICB0aW1lciA9IGxpc3RfZW50cnkoY3Vyciwgc3RydWN0IHRpbWVyX2xp
c3QsIGxpc3QpOw0KI2lmZGVmIENPTkZJR19ISUdIX1JFU19USU1FUlMNCiAgICAgICAgICAgICAg
ICAgICAgICAgIC8qDQogICAgICAgICAgICAgICAgICAgICAgICAgKiBUaGlzIHdvdWxkIGJlIHNp
bXBsZXIgaWYgd2UgbmV2ZXIgZ290IGJlaGluZA0KICAgICAgICAgICAgICAgICAgICAgICAgICog
aS5lLiBpZiB0aW1lcl9qaWZmaWVzID09IGppZmZpZXMsIHdlIGNvdWxkDQogICAgICAgICAgICAg
ICAgICAgICAgICAgKiBkcm9wIG9uZSBvZiB0aGUgdGVzdHMuICBTaW5jZSB3ZSBtYXkgZ2V0DQog
ICAgICAgICAgICAgICAgICAgICAgICAgKiBiZWhpbmQsIChpbiBmYWN0IHdlIGRvbid0IHVwIGRh
dGUgdW50aWwNCiAgICAgICAgICAgICAgICAgICAgICAgICAqIHdlIGFyZSBiZWhpbmQgdG8gYWxs
b3cgc3ViX2ppZmZpZSBlbnRyaWVzKQ0KICAgICAgICAgICAgICAgICAgICAgICAgICogd2UgbmVl
ZCBhIHdheSB0byBuZWdhdGUgdGhlIHN1Yl9qaWZmaWUNCiAgICAgICAgICAgICAgICAgICAgICAg
ICAqIHRlc3QgaW4gdGhhdCBjYXNlLi4uDQogICAgICAgICAgICAgICAgICAgICAgICAgKi8NCiAg
ICAgICAgICAgICAgICAgICAgICAgIGlmICh0aW1lX2JlZm9yZSh0aW1lci0+ZXhwaXJlcywgamlm
Zmllc19mKXx8DQogICAgICAgICAgICAgICAgICAgICAgICAgICAgKCh0aW1lci0+ZXhwaXJlcyA9
PSBqaWZmaWVzX2YpICYmDQogICAgICAgICAgICAgICAgICAgICAgICAgICAgIHRpbWVyLT5zdWJf
ZXhwaXJlcyA8PSBzdWJfamlmZmllX2YpKQ0KI2Vsc2UNCiAgICAgICAgICAgICAgICAgICAgICAg
IGlmICh0aW1lX2JlZm9yZV9lcSh0aW1lci0+ZXhwaXJlcywgamlmZmllcykpDQojZW5kaWYgLyog
IENPTkZJR19ISUdIX1JFU19USU1FUlMgKi8NCiAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAge2ZuID0gdGltZXItPmZ1bmN0aW9uOw0KICAgICAgICAgICAgIGRhdGE9IHRpbWVyLT5kYXRh
Ow0KDQogICAgICAgICAgICBkZXRhY2hfdGltZXIodGltZXIpOw0KICAgICAgICAgICAgdGltZXIt
Pmxpc3QubmV4dCA9IHRpbWVyLT5saXN0LnByZXYgPSBOVUxMOw0KICAgICAgICAgICAgdGltZXJf
ZW50ZXIodGltZXIpOw0KICAgICAgICAgICAgc3Bpbl91bmxvY2tfaXJxKCZ0aW1lcmxpc3RfbG9j
ayk7DQogICAgICAgICAgICBmbihkYXRhKTsNCiAgICAgICAgICAgIHNwaW5fbG9ja19pcnEoJnRp
bWVybGlzdF9sb2NrKTsNCiAgICAgICAgICAgIHRpbWVyX2V4aXQoKTsNCiAgICAgICAgICAgIGdv
dG8gcmVwZWF0Ow0KICAgICAgICB9DQojaWZkZWYgQ09ORklHX0hJR0hfUkVTX1RJTUVSUw0KICAg
ICAgICAgICAgICAgICAgICAgICAgZWxzZXsNCiAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgLyoNCiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICogVGhlIG5ldyB0aW1lciBs
aXN0IGlzIG5vdCBhbHdheXMgZW1wdGllZA0KICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgKiBoZXJlIGFzIGl0IGNvbnRhaW5zOg0KICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgKiBhLikgZW50cmllcyAobGlzdCBzaXplKV5OKmppZmZpZXMgb3V0IGFuZA0KICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgKiBiLikgZW50cmllcyB0aGF0IG1hdGNoIGluIGppZmZp
ZXMsIGJ1dCBoYXZlDQogICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAqICAgICBzdWJf
ZXhwaXJlIHRpbWVzIGZ1cnRoZXIgb3V0IHRoYW4gbm93Lg0KICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgKi8NCiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIGlmICh0aW1l
ci0+ZXhwaXJlcyA9PSBqaWZmaWVzX2YgKXsNCiAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICBzdWJfamlmZiA9IHRpbWVyLT5zdWJfZXhwaXJlczsNCiAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgfQ0KICAgICAgICAgICAgICAgICAgICAgICAgfQ0KI2VuZGlmIC8q
IENPTkZJR19ISUdIX1JFU19USU1FUlMgKi8NCiAgICAgICAgICAgICAgICB9DQogICAgICAgICsr
dGltZXJfamlmZmllczsNCiNpZmRlZiBDT05GSUdfQ0FTQ0FESU5HX1RJTUVSUw0KICAgICAgICB0
djEuaW5kZXggPSAodHYxLmluZGV4ICsgMSkgJiBUVlJfTUFTSzsNCiNlbmRpZg0KICAgIH0NCiAg
ICAgICAgLyoNCiAgICAgICAgICogSXQgaXMgZmFzdGVyIHRvIGJhY2sgb3V0IHRoZSBsYXN0IGJ1
bXAsIHRoYW4gdG8gcHJldmVudCBpdC4NCiAgICAgICAgICogVGhpcyBhbGxvd3MgemVybyB0aW1l
IGluc2VydHMgYXMgd2VsbCBhcyBzdWJfamlmZmllIHZhbHVlcyBpbg0KICAgICAgICAgKiB0aGUg
Y3VycmVudCBqaWZmaWUuICBXaWxsIG5vdCB3b3JrIGZvciB0aGUgY2FzY2FkZSBhcyB0djEuaW5k
ZXgNCiAgICAgICAgICogYWxzbyBuZWVkcyBhZGp1c3RpbmcuDQogICAgICAgICAqLw0KICAgICAg
ICBJRl9ORVdfVElNRVJfTElTVCgtLXRpbWVyX2ppZmZpZXMpOw0KDQogICAgICAgIElGX0hJR0hf
UkVTKGlmIChzY2hlZHVsZV9uZXh0X2ludCggamlmZmllc19mLCBzdWJfamlmZiwgMCkpew0KICAg
ICAgICAgICAgICAgIC8qDQogICAgICAgICAgICAgICAgICogSWYgc2NoZWR1bGVfbmV4dF9pbnQg
c2F5cyB0aGUgdGltZSBoYXMgcGFzc2VkDQogICAgICAgICAgICAgICAgICogYnVtcCB0aGUgdGFz
a2xldCBsb2NrIHNvIHdlIGdvIHJvdW5kIGFnYWluDQogICAgICAgICAgICAgICAgICovDQogICAg
ICAgICAgICAgICAgYXRvbWljX2luYygmdGltZXJfdGFza2xldF9sb2NrKTsNCiAgICAgICAgICAg
ICAgICB9KTsNCg0KICAgIHNwaW5fdW5sb2NrX2lycSgmdGltZXJsaXN0X2xvY2spOw0KfQ0KDQpz
cGlubG9ja190IHRxdWV1ZV9sb2NrID0gU1BJTl9MT0NLX1VOTE9DS0VEOw0KDQp2b2lkIHRxdWV1
ZV9iaCh2b2lkKQ0Kew0KICAgIHJ1bl90YXNrX3F1ZXVlKCZ0cV90aW1lcik7DQp9DQoNCnZvaWQg
aW1tZWRpYXRlX2JoKHZvaWQpDQp7DQogICAgcnVuX3Rhc2tfcXVldWUoJnRxX2ltbWVkaWF0ZSk7
DQp9DQoNCi8qDQogKiB0aGlzIHJvdXRpbmUgaGFuZGxlcyB0aGUgb3ZlcmZsb3cgb2YgdGhlIG1p
Y3Jvc2Vjb25kIGZpZWxkDQogKg0KICogVGhlIHRyaWNreSBiaXRzIG9mIGNvZGUgdG8gaGFuZGxl
IHRoZSBhY2N1cmF0ZSBjbG9jayBzdXBwb3J0DQogKiB3ZXJlIHByb3ZpZGVkIGJ5IERhdmUgTWls
bHMgKCBNaWxsc0BVREVMLkVEVSkgb2YgTlRQIGZhbWUuDQogKiBUaGV5IHdlcmUgb3JpZ2luYWxs
eSBkZXZlbG9wZWQgZm9yIFNVTiBhbmQgREVDIGtlcm5lbHMuDQogKiBBbGwgdGhlIGt1ZG9zIHNo
b3VsZCBnbyB0byBEYXZlIGZvciB0aGlzIHN0dWZmLg0KICoNCiAqLw0Kc3RhdGljIHZvaWQgc2Vj
b25kX292ZXJmbG93KHZvaWQpDQp7DQogICAgbG9uZyBsdGVtcDsNCg0KICAgIC8qIEJ1bXAgdGhl
IG1heGVycm9yIGZpZWxkICovDQogICAgdGltZV9tYXhlcnJvciArPSB0aW1lX3RvbGVyYW5jZSA+
PiBTSElGVF9VU0VDOw0KICAgIGlmICggdGltZV9tYXhlcnJvciA+IE5UUF9QSEFTRV9MSU1JVCAp
IHsNCiAgICB0aW1lX21heGVycm9yID0gTlRQX1BIQVNFX0xJTUlUOw0KICAgIHRpbWVfc3RhdHVz
IHw9IFNUQV9VTlNZTkM7DQogICAgfQ0KDQogICAgLyoNCiAgICAgKiBMZWFwIHNlY29uZCBwcm9j
ZXNzaW5nLiBJZiBpbiBsZWFwLWluc2VydCBzdGF0ZSBhdA0KICAgICAqIHRoZSBlbmQgb2YgdGhl
IGRheSwgdGhlIHN5c3RlbSBjbG9jayBpcyBzZXQgYmFjayBvbmUNCiAgICAgKiBzZWNvbmQ7IGlm
IGluIGxlYXAtZGVsZXRlIHN0YXRlLCB0aGUgc3lzdGVtIGNsb2NrIGlzDQogICAgICogc2V0IGFo
ZWFkIG9uZSBzZWNvbmQuIFRoZSBtaWNyb3RpbWUoKSByb3V0aW5lIG9yDQogICAgICogZXh0ZXJu
YWwgY2xvY2sgZHJpdmVyIHdpbGwgaW5zdXJlIHRoYXQgcmVwb3J0ZWQgdGltZQ0KICAgICAqIGlz
IGFsd2F5cyBtb25vdG9uaWMuIFRoZSB1Z2x5IGRpdmlkZXMgc2hvdWxkIGJlDQogICAgICogcmVw
bGFjZWQuDQogICAgICovDQogICAgc3dpdGNoICh0aW1lX3N0YXRlKSB7DQoNCiAgICBjYXNlIFRJ
TUVfT0s6DQogICAgaWYgKHRpbWVfc3RhdHVzICYgU1RBX0lOUykNCiAgICAgICAgdGltZV9zdGF0
ZSA9IFRJTUVfSU5TOw0KICAgIGVsc2UgaWYgKHRpbWVfc3RhdHVzICYgU1RBX0RFTCkNCiAgICAg
ICAgdGltZV9zdGF0ZSA9IFRJTUVfREVMOw0KICAgIGJyZWFrOw0KDQogICAgY2FzZSBUSU1FX0lO
UzoNCiAgICBpZiAoeHRpbWUudHZfc2VjICUgODY0MDAgPT0gMCkgew0KICAgICAgICB4dGltZS50
dl9zZWMtLTsNCiAgICAgICAgdGltZV9zdGF0ZSA9IFRJTUVfT09QOw0KICAgICAgICBwcmludGso
S0VSTl9OT1RJQ0UgIkNsb2NrOiBpbnNlcnRpbmcgbGVhcCBzZWNvbmQgMjM6NTk6NjAgVVRDXG4i
KTsNCiAgICB9DQogICAgYnJlYWs7DQoNCiAgICBjYXNlIFRJTUVfREVMOg0KICAgIGlmICgoeHRp
bWUudHZfc2VjICsgMSkgJSA4NjQwMCA9PSAwKSB7DQogICAgICAgIHh0aW1lLnR2X3NlYysrOw0K
ICAgICAgICB0aW1lX3N0YXRlID0gVElNRV9XQUlUOw0KICAgICAgICBwcmludGsoS0VSTl9OT1RJ
Q0UgIkNsb2NrOiBkZWxldGluZyBsZWFwIHNlY29uZCAyMzo1OTo1OSBVVENcbiIpOw0KICAgIH0N
CiAgICBicmVhazsNCg0KICAgIGNhc2UgVElNRV9PT1A6DQogICAgdGltZV9zdGF0ZSA9IFRJTUVf
V0FJVDsNCiAgICBicmVhazsNCg0KICAgIGNhc2UgVElNRV9XQUlUOg0KICAgIGlmICghKHRpbWVf
c3RhdHVzICYgKFNUQV9JTlMgfCBTVEFfREVMKSkpDQogICAgICAgIHRpbWVfc3RhdGUgPSBUSU1F
X09LOw0KICAgIH0NCg0KICAgIC8qDQogICAgICogQ29tcHV0ZSB0aGUgcGhhc2UgYWRqdXN0bWVu
dCBmb3IgdGhlIG5leHQgc2Vjb25kLiBJbg0KICAgICAqIFBMTCBtb2RlLCB0aGUgb2Zmc2V0IGlz
IHJlZHVjZWQgYnkgYSBmaXhlZCBmYWN0b3INCiAgICAgKiB0aW1lcyB0aGUgdGltZSBjb25zdGFu
dC4gSW4gRkxMIG1vZGUgdGhlIG9mZnNldCBpcw0KICAgICAqIHVzZWQgZGlyZWN0bHkuIEluIGVp
dGhlciBtb2RlLCB0aGUgbWF4aW11bSBwaGFzZQ0KICAgICAqIGFkanVzdG1lbnQgZm9yIGVhY2gg
c2Vjb25kIGlzIGNsYW1wZWQgc28gYXMgdG8gc3ByZWFkDQogICAgICogdGhlIGFkanVzdG1lbnQg
b3ZlciBub3QgbW9yZSB0aGFuIHRoZSBudW1iZXIgb2YNCiAgICAgKiBzZWNvbmRzIGJldHdlZW4g
dXBkYXRlcy4NCiAgICAgKi8NCiAgICBpZiAodGltZV9vZmZzZXQgPCAwKSB7DQogICAgbHRlbXAg
PSAtdGltZV9vZmZzZXQ7DQogICAgaWYgKCEodGltZV9zdGF0dXMgJiBTVEFfRkxMKSkNCiAgICAg
ICAgbHRlbXAgPj49IFNISUZUX0tHICsgdGltZV9jb25zdGFudDsNCiAgICBpZiAobHRlbXAgPiAo
TUFYUEhBU0UgLyBNSU5TRUMpIDw8IFNISUZUX1VQREFURSkNCiAgICAgICAgbHRlbXAgPSAoTUFY
UEhBU0UgLyBNSU5TRUMpIDw8IFNISUZUX1VQREFURTsNCiAgICB0aW1lX29mZnNldCArPSBsdGVt
cDsNCiAgICB0aW1lX2FkaiA9IC1sdGVtcCA8PCAoU0hJRlRfU0NBTEUgLSBTSElGVF9IWiAtIFNI
SUZUX1VQREFURSk7DQogICAgfSBlbHNlIHsNCiAgICBsdGVtcCA9IHRpbWVfb2Zmc2V0Ow0KICAg
IGlmICghKHRpbWVfc3RhdHVzICYgU1RBX0ZMTCkpDQogICAgICAgIGx0ZW1wID4+PSBTSElGVF9L
RyArIHRpbWVfY29uc3RhbnQ7DQogICAgaWYgKGx0ZW1wID4gKE1BWFBIQVNFIC8gTUlOU0VDKSA8
PCBTSElGVF9VUERBVEUpDQogICAgICAgIGx0ZW1wID0gKE1BWFBIQVNFIC8gTUlOU0VDKSA8PCBT
SElGVF9VUERBVEU7DQogICAgdGltZV9vZmZzZXQgLT0gbHRlbXA7DQogICAgdGltZV9hZGogPSBs
dGVtcCA8PCAoU0hJRlRfU0NBTEUgLSBTSElGVF9IWiAtIFNISUZUX1VQREFURSk7DQogICAgfQ0K
DQogICAgLyoNCiAgICAgKiBDb21wdXRlIHRoZSBmcmVxdWVuY3kgZXN0aW1hdGUgYW5kIGFkZGl0
aW9uYWwgcGhhc2UNCiAgICAgKiBhZGp1c3RtZW50IGR1ZSB0byBmcmVxdWVuY3kgZXJyb3IgZm9y
IHRoZSBuZXh0DQogICAgICogc2Vjb25kLiBXaGVuIHRoZSBQUFMgc2lnbmFsIGlzIGVuZ2FnZWQs
IGduYXcgb24gdGhlDQogICAgICogd2F0Y2hkb2cgY291bnRlciBhbmQgdXBkYXRlIHRoZSBmcmVx
dWVuY3kgY29tcHV0ZWQgYnkNCiAgICAgKiB0aGUgcGxsIGFuZCB0aGUgUFBTIHNpZ25hbC4NCiAg
ICAgKi8NCiAgICBwcHNfdmFsaWQrKzsNCiAgICBpZiAocHBzX3ZhbGlkID09IFBQU19WQUxJRCkg
eyAgICAvKiBQUFMgc2lnbmFsIGxvc3QgKi8NCiAgICBwcHNfaml0dGVyID0gTUFYVElNRTsNCiAg
ICBwcHNfc3RhYmlsID0gTUFYRlJFUTsNCiAgICB0aW1lX3N0YXR1cyAmPSB+KFNUQV9QUFNTSUdO
QUwgfCBTVEFfUFBTSklUVEVSIHwNCiAgICAgICAgICAgICBTVEFfUFBTV0FOREVSIHwgU1RBX1BQ
U0VSUk9SKTsNCiAgICB9DQogICAgbHRlbXAgPSB0aW1lX2ZyZXEgKyBwcHNfZnJlcTsNCiAgICBp
ZiAobHRlbXAgPCAwKQ0KICAgIHRpbWVfYWRqIC09IC1sdGVtcCA+Pg0KICAgICAgICAoU0hJRlRf
VVNFQyArIFNISUZUX0haIC0gU0hJRlRfU0NBTEUpOw0KICAgIGVsc2UNCiAgICB0aW1lX2FkaiAr
PSBsdGVtcCA+Pg0KICAgICAgICAoU0hJRlRfVVNFQyArIFNISUZUX0haIC0gU0hJRlRfU0NBTEUp
Ow0KDQojaWYgSFogPT0gMTAwDQogICAgLyogQ29tcGVuc2F0ZSBmb3IgKEhaPT0xMDApICE9ICgx
IDw8IFNISUZUX0haKS4NCiAgICAgKiBBZGQgMjUlIGFuZCAzLjEyNSUgdG8gZ2V0IDEyOC4xMjU7
ID0+IG9ubHkgMC4xMjUlIGVycm9yIChwLiAxNCkNCiAgICAgKi8NCiAgICBpZiAodGltZV9hZGog
PCAwKQ0KICAgIHRpbWVfYWRqIC09ICgtdGltZV9hZGogPj4gMikgKyAoLXRpbWVfYWRqID4+IDUp
Ow0KICAgIGVsc2UNCiAgICB0aW1lX2FkaiArPSAodGltZV9hZGogPj4gMikgKyAodGltZV9hZGog
Pj4gNSk7DQojZW5kaWYNCn0NCg0KLyogaW4gdGhlIE5UUCByZWZlcmVuY2UgdGhpcyBpcyBjYWxs
ZWQgImhhcmRjbG9jaygpIiAqLw0Kc3RhdGljIHZvaWQgdXBkYXRlX3dhbGxfdGltZV9vbmVfdGlj
ayh2b2lkKQ0Kew0KICAgIGlmICggKHRpbWVfYWRqdXN0X3N0ZXAgPSB0aW1lX2FkanVzdCkgIT0g
MCApIHsNCiAgICAgICAgLyogV2UgYXJlIGRvaW5nIGFuIGFkanRpbWUgdGhpbmcuDQogICAgICAg
ICAqDQogICAgICAgICAqIFByZXBhcmUgdGltZV9hZGp1c3Rfc3RlcCB0byBiZSB3aXRoaW4gYm91
bmRzLg0KICAgICAgICAgKiBOb3RlIHRoYXQgYSBwb3NpdGl2ZSB0aW1lX2FkanVzdCBtZWFucyB3
ZSB3YW50IHRoZSBjbG9jaw0KICAgICAgICAgKiB0byBydW4gZmFzdGVyLg0KICAgICAgICAgKg0K
ICAgICAgICAgKiBMaW1pdCB0aGUgYW1vdW50IG9mIHRoZSBzdGVwIHRvIGJlIGluIHRoZSByYW5n
ZQ0KICAgICAgICAgKiAtdGlja2FkaiAuLiArdGlja2Fkag0KICAgICAgICAgKi8NCiAgICAgICAg
IGlmICh0aW1lX2FkanVzdCA+IHRpY2thZGopDQogICAgICAgIHRpbWVfYWRqdXN0X3N0ZXAgPSB0
aWNrYWRqOw0KICAgICAgICAgZWxzZSBpZiAodGltZV9hZGp1c3QgPCAtdGlja2FkaikNCiAgICAg
ICAgdGltZV9hZGp1c3Rfc3RlcCA9IC10aWNrYWRqOw0KICAgICAgICANCiAgICAgICAgLyogUmVk
dWNlIGJ5IHRoaXMgc3RlcCB0aGUgYW1vdW50IG9mIHRpbWUgbGVmdCAgKi8NCiAgICAgICAgdGlt
ZV9hZGp1c3QgLT0gdGltZV9hZGp1c3Rfc3RlcDsNCiAgICB9DQogICAgeHRpbWUudHZfdXNlYyAr
PSB0aWNrICsgdGltZV9hZGp1c3Rfc3RlcDsNCiAgICAvKg0KICAgICAqIEFkdmFuY2UgdGhlIHBo
YXNlLCBvbmNlIGl0IGdldHMgdG8gb25lIG1pY3Jvc2Vjb25kLCB0aGVuDQogICAgICogYWR2YW5j
ZSB0aGUgdGljayBtb3JlLg0KICAgICAqLw0KICAgIHRpbWVfcGhhc2UgKz0gdGltZV9hZGo7DQog
ICAgaWYgKHRpbWVfcGhhc2UgPD0gLUZJTkVVU0VDKSB7DQogICAgICAgIGxvbmcgbHRlbXAgPSAt
dGltZV9waGFzZSA+PiBTSElGVF9TQ0FMRTsNCiAgICAgICAgdGltZV9waGFzZSArPSBsdGVtcCA8
PCBTSElGVF9TQ0FMRTsNCiAgICAgICAgeHRpbWUudHZfdXNlYyAtPSBsdGVtcDsNCiAgICB9DQog
ICAgZWxzZSBpZiAodGltZV9waGFzZSA+PSBGSU5FVVNFQykgew0KICAgICAgICBsb25nIGx0ZW1w
ID0gdGltZV9waGFzZSA+PiBTSElGVF9TQ0FMRTsNCiAgICAgICAgdGltZV9waGFzZSAtPSBsdGVt
cCA8PCBTSElGVF9TQ0FMRTsNCiAgICAgICAgeHRpbWUudHZfdXNlYyArPSBsdGVtcDsNCiAgICB9
DQp9DQoNCi8qDQogKiBVc2luZyBhIGxvb3AgbG9va3MgaW5lZmZpY2llbnQsIGJ1dCAidGlja3Mi
IGlzDQogKiB1c3VhbGx5IGp1c3Qgb25lICh3ZSBzaG91bGRuJ3QgYmUgbG9zaW5nIHRpY2tzLA0K
ICogd2UncmUgZG9pbmcgdGhpcyB0aGlzIHdheSBtYWlubHkgZm9yIGludGVycnVwdA0KICogbGF0
ZW5jeSByZWFzb25zLCBub3QgYmVjYXVzZSB3ZSB0aGluayB3ZSdsbA0KICogaGF2ZSBsb3RzIG9m
IGxvc3QgdGltZXIgdGlja3MNCiAqLw0Kc3RhdGljIHZvaWQgdXBkYXRlX3dhbGxfdGltZSh1bnNp
Z25lZCBsb25nIHRpY2tzKQ0Kew0KICAgIGRvIHsNCiAgICAgICAgdGlja3MtLTsNCiAgICAgICAg
dXBkYXRlX3dhbGxfdGltZV9vbmVfdGljaygpOw0KICAgIH0gd2hpbGUgKHRpY2tzKTsNCg0KICAg
IGlmICh4dGltZS50dl91c2VjID49IDEwMDAwMDApIHsNCiAgICAgICAgeHRpbWUudHZfdXNlYyAt
PSAxMDAwMDAwOw0KICAgICAgICB4dGltZS50dl9zZWMrKzsNCiAgICAgICAgc2Vjb25kX292ZXJm
bG93KCk7DQogICAgfQ0KfQ0KDQpzdGF0aWMgaW5saW5lIHZvaWQgZG9fcHJvY2Vzc190aW1lcyhz
dHJ1Y3QgdGFza19zdHJ1Y3QgKnAsDQogICAgdW5zaWduZWQgbG9uZyB1c2VyLCB1bnNpZ25lZCBs
b25nIHN5c3RlbSkNCnsNCiAgICB1bnNpZ25lZCBsb25nIHBzZWNzOw0KDQogICAgcHNlY3MgPSAo
cC0+dGltZXMudG1zX3V0aW1lICs9IHVzZXIpOw0KICAgIHBzZWNzICs9IChwLT50aW1lcy50bXNf
c3RpbWUgKz0gc3lzdGVtKTsNCiAgICBpZiAocHNlY3MgLyBIWiA+IHAtPnJsaW1bUkxJTUlUX0NQ
VV0ucmxpbV9jdXIpIHsNCiAgICAgICAgLyogU2VuZCBTSUdYQ1BVIGV2ZXJ5IHNlY29uZC4uICov
DQogICAgICAgIGlmICghKHBzZWNzICUgSFopKQ0KICAgICAgICAgICAgc2VuZF9zaWcoU0lHWENQ
VSwgcCwgMSk7DQogICAgICAgIC8qIGFuZCBTSUdLSUxMIHdoZW4gd2UgZ28gb3ZlciBtYXguLiAq
Lw0KICAgICAgICBpZiAocHNlY3MgLyBIWiA+IHAtPnJsaW1bUkxJTUlUX0NQVV0ucmxpbV9tYXgp
DQogICAgICAgICAgICBzZW5kX3NpZyhTSUdLSUxMLCBwLCAxKTsNCiAgICB9DQp9DQoNCnN0YXRp
YyBpbmxpbmUgdm9pZCBkb19pdF92aXJ0KHN0cnVjdCB0YXNrX3N0cnVjdCAqIHAsIHVuc2lnbmVk
IGxvbmcgdGlja3MpDQp7DQogICAgdW5zaWduZWQgbG9uZyBpdF92aXJ0ID0gcC0+aXRfdmlydF92
YWx1ZTsNCg0KICAgIGlmIChpdF92aXJ0KSB7DQogICAgICAgIGl0X3ZpcnQgLT0gdGlja3M7DQog
ICAgICAgIGlmICghaXRfdmlydCkgew0KICAgICAgICAgICAgaXRfdmlydCA9IHAtPml0X3ZpcnRf
aW5jcjsNCiAgICAgICAgICAgIHNlbmRfc2lnKFNJR1ZUQUxSTSwgcCwgMSk7DQogICAgICAgIH0N
CiAgICAgICAgcC0+aXRfdmlydF92YWx1ZSA9IGl0X3ZpcnQ7DQogICAgfQ0KfQ0KDQpzdGF0aWMg
aW5saW5lIHZvaWQgZG9faXRfcHJvZihzdHJ1Y3QgdGFza19zdHJ1Y3QgKnApDQp7DQogICAgdW5z
aWduZWQgbG9uZyBpdF9wcm9mID0gcC0+aXRfcHJvZl92YWx1ZTsNCg0KICAgIGlmIChpdF9wcm9m
KSB7DQogICAgICAgIGlmICgtLWl0X3Byb2YgPT0gMCkgew0KICAgICAgICAgICAgaXRfcHJvZiA9
IHAtPml0X3Byb2ZfaW5jcjsNCiAgICAgICAgICAgIHNlbmRfc2lnKFNJR1BST0YsIHAsIDEpOw0K
ICAgICAgICB9DQogICAgICAgIHAtPml0X3Byb2ZfdmFsdWUgPSBpdF9wcm9mOw0KICAgIH0NCn0N
Cg0Kdm9pZCB1cGRhdGVfb25lX3Byb2Nlc3Moc3RydWN0IHRhc2tfc3RydWN0ICpwLCB1bnNpZ25l
ZCBsb25nIHVzZXIsDQogICAgICAgICAgICB1bnNpZ25lZCBsb25nIHN5c3RlbSwgaW50IGNwdSkN
CnsNCiAgICBwLT5wZXJfY3B1X3V0aW1lW2NwdV0gKz0gdXNlcjsNCiAgICBwLT5wZXJfY3B1X3N0
aW1lW2NwdV0gKz0gc3lzdGVtOw0KICAgIGRvX3Byb2Nlc3NfdGltZXMocCwgdXNlciwgc3lzdGVt
KTsNCiAgICBkb19pdF92aXJ0KHAsIHVzZXIpOw0KICAgIGRvX2l0X3Byb2YocCk7DQp9ICAgDQoN
Ci8qDQogKiBDYWxsZWQgZnJvbSB0aGUgdGltZXIgaW50ZXJydXB0IGhhbmRsZXIgdG8gY2hhcmdl
IG9uZSB0aWNrIHRvIHRoZSBjdXJyZW50DQogKiBwcm9jZXNzLiAgdXNlcl90aWNrIGlzIDEgaWYg
dGhlIHRpY2sgaXMgdXNlciB0aW1lLCAwIGZvciBzeXN0ZW0uDQogKi8NCnZvaWQgdXBkYXRlX3By
b2Nlc3NfdGltZXMoaW50IHVzZXJfdGljaykNCnsNCiAgICBzdHJ1Y3QgdGFza19zdHJ1Y3QgKnAg
PSBjdXJyZW50Ow0KICAgIGludCBjcHUgPSBzbXBfcHJvY2Vzc29yX2lkKCksIHN5c3RlbSA9IHVz
ZXJfdGljayBeIDE7DQoNCiAgICB1cGRhdGVfb25lX3Byb2Nlc3MocCwgdXNlcl90aWNrLCBzeXN0
ZW0sIGNwdSk7DQogICAgaWYgKHAtPnBpZCkgew0KI2lmZGVmIENPTkZJR19SVFNDSEVEDQogICAg
ICAgICAgICAgICAgLyogU0NIRURfRklGTyBhbmQgdGhlIGlkbGUocykgaGF2ZSBjb3VudGVycyBz
ZXQgdG8gLTEwMCwNCiAgICAgICAgICAgICAgICAgKiBzbyB3ZSB3b24ndCBjb3VudCB0aGVtLCBz
ZWVtcyBsaWtlIGEgZ29vZCBpZGVhIGZvcg0KICAgICAgICAgICAgICAgICAqIGJvdGggc2NoZWR1
bGVycywgYnV0LCBiZWluZyBwdXJlLi4uDQogICAgICAgICAgICAgICAgICovDQogICAgICAgIGlm
IChwLT5jb3VudGVyID49IDAgJiYgLS1wLT5jb3VudGVyIDw9IDApIHsNCiNlbHNlDQogICAgICAg
IGlmICgtLXAtPmNvdW50ZXIgPD0gMCkgew0KI2VuZGlmDQogICAgICAgICAgICBwLT5jb3VudGVy
ID0gMDsNCiAgICAgICAgICAgIHAtPm5lZWRfcmVzY2hlZCA9IDE7DQogICAgICAgIH0NCiAgICAg
ICAgaWYgKHAtPm5pY2UgPiAwKQ0KICAgICAgICAgICAga3N0YXQucGVyX2NwdV9uaWNlW2NwdV0g
Kz0gdXNlcl90aWNrOw0KICAgICAgICBlbHNlDQogICAgICAgICAgICBrc3RhdC5wZXJfY3B1X3Vz
ZXJbY3B1XSArPSB1c2VyX3RpY2s7DQogICAgICAgIGtzdGF0LnBlcl9jcHVfc3lzdGVtW2NwdV0g
Kz0gc3lzdGVtOw0KICAgIH0gZWxzZSBpZiAobG9jYWxfYmhfY291bnQoY3B1KSB8fCBsb2NhbF9p
cnFfY291bnQoY3B1KSA+IDEpDQogICAgICAgIGtzdGF0LnBlcl9jcHVfc3lzdGVtW2NwdV0gKz0g
c3lzdGVtOw0KfQ0KDQovKg0KICogTnIgb2YgYWN0aXZlIHRhc2tzIC0gY291bnRlZCBpbiBmaXhl
ZC1wb2ludCBudW1iZXJzDQogKi8NCnN0YXRpYyB1bnNpZ25lZCBsb25nIGNvdW50X2FjdGl2ZV90
YXNrcyh2b2lkKQ0Kew0KICAgIHN0cnVjdCB0YXNrX3N0cnVjdCAqcDsNCiAgICB1bnNpZ25lZCBs
b25nIG5yID0gMDsNCg0KICAgIHJlYWRfbG9jaygmdGFza2xpc3RfbG9jayk7DQogICAgZm9yX2Vh
Y2hfdGFzayhwKSB7DQogICAgICAgIGlmICgocC0+c3RhdGUgPT0gVEFTS19SVU5OSU5HIHx8DQog
ICAgICAgICAgICAgKHAtPnN0YXRlICYgVEFTS19VTklOVEVSUlVQVElCTEUpKSkNCiAgICAgICAg
ICAgIG5yICs9IEZJWEVEXzE7DQogICAgfQ0KICAgIHJlYWRfdW5sb2NrKCZ0YXNrbGlzdF9sb2Nr
KTsNCiAgICByZXR1cm4gbnI7DQp9DQoNCi8qDQogKiBIbW0uLiBDaGFuZ2VkIHRoaXMsIGFzIHRo
ZSBHTlUgbWFrZSBzb3VyY2VzIChsb2FkLmMpIHNlZW1zIHRvDQogKiBpbXBseSB0aGF0IGF2ZW5y
dW5bXSBpcyB0aGUgc3RhbmRhcmQgbmFtZSBmb3IgdGhpcyBraW5kIG9mIHRoaW5nLg0KICogTm90
aGluZyBlbHNlIHNlZW1zIHRvIGJlIHN0YW5kYXJkaXplZDogdGhlIGZyYWN0aW9uYWwgc2l6ZSBl
dGMNCiAqIGFsbCBzZWVtIHRvIGRpZmZlciBvbiBkaWZmZXJlbnQgbWFjaGluZXMuDQogKi8NCnVu
c2lnbmVkIGxvbmcgYXZlbnJ1blszXTsNCg0Kc3RhdGljIGlubGluZSB2b2lkIGNhbGNfbG9hZCh1
bnNpZ25lZCBsb25nIHRpY2tzKQ0Kew0KICAgIHVuc2lnbmVkIGxvbmcgYWN0aXZlX3Rhc2tzOyAv
KiBmaXhlZC1wb2ludCAqLw0KICAgIHN0YXRpYyBpbnQgY291bnQgPSBMT0FEX0ZSRVE7DQoNCiAg
ICBjb3VudCAtPSB0aWNrczsNCiAgICBpZiAoY291bnQgPCAwKSB7DQogICAgICAgIGNvdW50ICs9
IExPQURfRlJFUTsNCiAgICAgICAgYWN0aXZlX3Rhc2tzID0gY291bnRfYWN0aXZlX3Rhc2tzKCk7
DQogICAgICAgIENBTENfTE9BRChhdmVucnVuWzBdLCBFWFBfMSwgYWN0aXZlX3Rhc2tzKTsNCiAg
ICAgICAgQ0FMQ19MT0FEKGF2ZW5ydW5bMV0sIEVYUF81LCBhY3RpdmVfdGFza3MpOw0KICAgICAg
ICBDQUxDX0xPQUQoYXZlbnJ1blsyXSwgRVhQXzE1LCBhY3RpdmVfdGFza3MpOw0KICAgIH0NCn0N
Cg0KLyogamlmZmllcyBhdCB0aGUgbW9zdCByZWNlbnQgdXBkYXRlIG9mIHdhbGwgdGltZSAqLw0K
dW5zaWduZWQgbG9uZyB3YWxsX2ppZmZpZXM7DQoNCg0Kc3RhdGljIGlubGluZSB1bnNpZ25lZCBs
b25nIHVwZGF0ZV90aW1lcyh2b2lkKQ0Kew0KICAgIHVuc2lnbmVkIGxvbmcgdGlja3M7DQoNCiAg
ICAvKg0KICAgICAqIHVwZGF0ZV90aW1lcygpIGlzIHJ1biBmcm9tIHRoZSByYXcgdGltZXJfYmgg
aGFuZGxlciBzbyB3ZQ0KICAgICAqIGp1c3Qga25vdyB0aGF0IHRoZSBpcnFzIGFyZSBsb2NhbGx5
IGVuYWJsZWQgYW5kIHNvIHdlIGRvbid0DQogICAgICogbmVlZCB0byBzYXZlL3Jlc3RvcmUgdGhl
IGZsYWdzIG9mIHRoZSBsb2NhbCBDUFUgaGVyZS4gLWFyY2ENCiAgICAgKi8NCiAgICB3cml0ZV9s
b2NrX2lycSgmeHRpbWVfbG9jayk7DQoNCiAgICB0aWNrcyA9IGppZmZpZXMgLSB3YWxsX2ppZmZp
ZXM7DQogICAgaWYgKHRpY2tzKSB7DQogICAgICAgIHdhbGxfamlmZmllcyArPSB0aWNrczsNCiAg
ICAgICAgdXBkYXRlX3dhbGxfdGltZSh0aWNrcyk7DQogICAgfQ0KICAgIHdyaXRlX3VubG9ja19p
cnEoJnh0aW1lX2xvY2spOw0KICAgIHJldHVybiB0aWNrczsgLyogVGhpcyBpcyBkdW0uICBjaGFu
Z2UgY2FsY19sb2FkIHRvIGEgdGltZXIgKi8NCg0KfQ0KI2lmZGVmIENPTkZJR19ISUdIX1JFU19U
SU1FUlMNCnZvaWQgdXBkYXRlX3JlYWxfd2FsbF90aW1lKHZvaWQpDQp7DQogICAgICAgdW5zaWdu
ZWQgbG9uZyB0aWNrczsNCiAgICAgICAvKg0KICAgICAgICAqIFRvIGdldCB0aGUgdGltZSBvZiBk
YXkgcmVhbGx5IHJpZ2h0LCB3ZSBuZWVkIHRvIG1ha2Ugc3VyZQ0KICAgICAgICAqIGV2ZXJ5IG9u
ZSBpcyBvbiB0aGUgc2FtZSBqaWZmaWUuIChCZWNhdXNlIG9mIGFkal90aW1lLCBldGMuKQ0KICAg
ICAgICAqIFNvIHdlIHByb3ZpZGUgdGhpcyBmb3IgdGhlIGhpZ2ggcmVzIGNvZGUuICBNdXN0IGJl
IGNhbGxlZA0KICAgICAgICAqIHVuZGVyIHRoZSB3cml0ZSh4dGltZV9sb2NrKS4gIChFeHRlcm5h
bCBsb2NraW5nIGFsbG93cyB0aGUNCiAgICAgICAgKiBjYWxsZXIgdG8gaW5jbHVkZSBzdWIgamlm
ZmllcyBpbiB0aGUgbG9jayByZWdpb24uKQ0KICAgICAgICAqLw0KICAgICAgICB0aWNrcyA9IGpp
ZmZpZXMgLSB3YWxsX2ppZmZpZXM7DQogICAgICAgIGlmICh0aWNrcykgew0KICAgICAgICAgICAg
ICAgd2FsbF9qaWZmaWVzICs9IHRpY2tzOw0KICAgICAgICAgICAgICAgdXBkYXRlX3dhbGxfdGlt
ZSh0aWNrcyk7DQogICAgICAgIH0NCn0NCiNlbmRpZiAvKiBDT05GSUdfSElHSF9SRVNfVElNRVJT
ICovDQp2b2lkIHRpbWVyX2JoKHZvaWQpDQp7DQogICAgICAgdW5zaWduZWQgbG9uZyB0aWNrczsN
CiAgICBUUkFDRV9FVkVOVChUUkFDRV9FVl9LRVJORUxfVElNRVIsIE5VTEwpOw0KICAgIHByaW50
aygiaGFoYS0xXG4iKTsNCiAgICB0aWNrcyA9IHVwZGF0ZV90aW1lcygpOw0KICAgIHByaW50aygi
aGFoYS0yXG4iKTsNCiAgICBjYWxjX2xvYWQodGlja3MpOw0KICAgIHByaW50aygiaGFoYS0zXG4i
KTsNCiAgICBydW5fdGltZXJfbGlzdCgpOw0KfQ0KDQovKg0KICogdGltZXJfdGFza2xldF9sb2Nr
IHN0YXJ0cyBhdCAtMS4gIDAsIHRoZW4gbWVhbnMgaXQgaXMgY29vbCB0byBjb250aW51ZS4NCiAq
IElmIGFub3RoZXIgY3B1IGJ1bXBzIGl0IHdoaWxlIHRoZSBmaXJzdCBpcyBzdGlsbCBpbiB0aW1l
cl9iaCwgaXQgd2lsbA0KICogYmUgZGV0ZWN0ZWQgb24gZXhpdCwgYW5kIHdlIHdpbGwgcnVuIGl0
IGFnYWluLiAgQnV0IG11bHRpcGxlIGVudHJpZXMNCiAqIGFyZSBub3QgbmVlZGVkLCBqdXN0IG9u
Y2UgZm9yIGFsbCB0aGUgImhpdHMiIHdoaWxlIHdlIGFyZSBpbiB0aW1lcl9iaC4NCiAqLw0Kdm9p
ZCB0aW1lcl9zb2Z0aXJxKHN0cnVjdCBzb2Z0aXJxX2FjdGlvbiogYSkNCnsNCg0KICAgICAgICAg
aWYgKCAhIGF0b21pY19pbmNfYW5kX3Rlc3QoJnRpbWVyX3Rhc2tsZXRfbG9jaykpew0KICAgICAg
ICAgICAgICAgICAvL2tnZGJfdHMoYXRvbWljX3JlYWQoJnRpbWVyX3Rhc2tsZXRfbG9jayksMCk7
DQogICAgICAgICAgICAgICAgIHJldHVybjsNCiAgICAgICAgIH0NCiAgICAgICAgIGRvIHsNCiAg
ICAgICAgICAgICAgICAgLy9rZ2RiX3RzKGF0b21pY19yZWFkKCZ0aW1lcl90YXNrbGV0X2xvY2sp
LDEpOw0KICAgICAgICAgICAgICAgICBhdG9taWNfc2V0KCZ0aW1lcl90YXNrbGV0X2xvY2ssMCk7
DQogICAgICAgICAgICAgICAgIHRpbWVyX2JoKCk7DQogICAgLy8gICAgIG1hcmtfYmgoVElNRVJf
QkgpOw0KICAgICAgICAgfXdoaWxlICggISBhdG9taWNfYWRkX25lZ2F0aXZlKC0xLCZ0aW1lcl90
YXNrbGV0X2xvY2spKTsNCiANCiAgICAgICAgIC8va2dkYl90cyhhdG9taWNfcmVhZCgmdGltZXJf
dGFza2xldF9sb2NrKSwyKTsNCiB9DQoNCnZvaWQgZG9fdGltZXIoc3RydWN0IHB0X3JlZ3MgKnJl
Z3MpDQp7DQogICAgdXBkYXRlX2ppZmZpZXMoKTsNCiNpZm5kZWYgQ09ORklHX1NNUA0KICAgIC8q
IFNNUCBwcm9jZXNzIGFjY291bnRpbmcgdXNlcyB0aGUgbG9jYWwgQVBJQyB0aW1lciAqLw0KICAg
IElGX0hJR0hfUkVTKCBpZiAobmV3X2ppZmZpZSgpKSkNCiAgICAgICAgICAgICAgICAgICAgIHVw
ZGF0ZV9wcm9jZXNzX3RpbWVzKHVzZXJfbW9kZShyZWdzKSk7DQoNCiNlbmRpZg0KICAgIC8qbWFy
a19iaChUSU1FUl9CSCk7Ki8NCiAgICAgICAgcmFpc2Vfc29mdGlycSggUlVOX1RJTUVSX0xJU1Qg
KTsNCiAgICBpZiAoVFFfQUNUSVZFKHRxX3RpbWVyKSkNCiAgICAgICAgbWFya19iaChUUVVFVUVf
QkgpOw0KfQ0KDQojaWYgIWRlZmluZWQoX19hbHBoYV9fKSAmJiAhZGVmaW5lZChfX2lhNjRfXykN
Cg0KLyoNCiAqIEZvciBiYWNrd2FyZHMgY29tcGF0aWJpbGl0eT8gIFRoaXMgY2FuIGJlIGRvbmUg
aW4gbGliYyBzbyBBbHBoYQ0KICogYW5kIGFsbCBuZXdlciBwb3J0cyBzaG91bGRuJ3QgbmVlZCBp
dC4NCiAqLw0KYXNtbGlua2FnZSB1bnNpZ25lZCBsb25nIHN5c19hbGFybSh1bnNpZ25lZCBpbnQg
c2Vjb25kcykNCnsNCiAgICBzdHJ1Y3QgaXRpbWVydmFsIGl0X25ldywgaXRfb2xkOw0KICAgIHVu
c2lnbmVkIGludCBvbGRhbGFybTsNCg0KICAgIGl0X25ldy5pdF9pbnRlcnZhbC50dl9zZWMgPSBp
dF9uZXcuaXRfaW50ZXJ2YWwudHZfdXNlYyA9IDA7DQogICAgaXRfbmV3Lml0X3ZhbHVlLnR2X3Nl
YyA9IHNlY29uZHM7DQogICAgaXRfbmV3Lml0X3ZhbHVlLnR2X3VzZWMgPSAwOw0KICAgIGRvX3Nl
dGl0aW1lcihJVElNRVJfUkVBTCwgJml0X25ldywgJml0X29sZCk7DQogICAgb2xkYWxhcm0gPSBp
dF9vbGQuaXRfdmFsdWUudHZfc2VjOw0KICAgIC8qIGVoaGguLiBXZSBjYW4ndCByZXR1cm4gMCBp
ZiB3ZSBoYXZlIGFuIGFsYXJtIHBlbmRpbmcuLiAqLw0KICAgIC8qIEFuZCB3ZSdkIGJldHRlciBy
ZXR1cm4gdG9vIG11Y2ggdGhhbiB0b28gbGl0dGxlIGFueXdheSAqLw0KICAgIGlmIChpdF9vbGQu
aXRfdmFsdWUudHZfdXNlYykNCiAgICAgICAgb2xkYWxhcm0rKzsNCiAgICByZXR1cm4gb2xkYWxh
cm07DQp9DQoNCiNlbmRpZg0KDQojaWZuZGVmIF9fYWxwaGFfXw0KDQovKg0KICogVGhlIEFscGhh
IHVzZXMgZ2V0eHBpZCwgZ2V0eHVpZCwgYW5kIGdldHhnaWQgaW5zdGVhZC4gIE1heWJlIHRoaXMN
CiAqIHNob3VsZCBiZSBtb3ZlZCBpbnRvIGFyY2gvaTM4NiBpbnN0ZWFkPw0KICovDQogDQphc21s
aW5rYWdlIGxvbmcgc3lzX2dldHBpZCh2b2lkKQ0Kew0KICAgIC8qIFRoaXMgaXMgU01QIHNhZmUg
LSBjdXJyZW50LT5waWQgZG9lc24ndCBjaGFuZ2UgKi8NCiAgICByZXR1cm4gY3VycmVudC0+dGdp
ZDsNCn0NCg0KLyoNCiAqIFRoaXMgaXMgbm90IHN0cmljdGx5IFNNUCBzYWZlOiBwX29wcHRyIGNv
dWxkIGNoYW5nZQ0KICogZnJvbSB1bmRlciB1cy4gSG93ZXZlciwgcmF0aGVyIHRoYW4gZ2V0dGlu
ZyBhbnkgbG9jaw0KICogd2UgY2FuIHVzZSBhbiBvcHRpbWlzdGljIGFsZ29yaXRobTogZ2V0IHRo
ZSBwYXJlbnQNCiAqIHBpZCwgYW5kIGdvIGJhY2sgYW5kIGNoZWNrIHRoYXQgdGhlIHBhcmVudCBp
cyBzdGlsbA0KICogdGhlIHNhbWUuIElmIGl0IGhhcyBjaGFuZ2VkICh3aGljaCBpcyBleHRyZW1l
bHkgdW5saWtlbHkNCiAqIGluZGVlZCksIHdlIGp1c3QgdHJ5IGFnYWluLi4NCiAqDQogKiBOT1RF
ISBUaGlzIGRlcGVuZHMgb24gdGhlIGZhY3QgdGhhdCBldmVuIGlmIHdlIF9kb18NCiAqIGdldCBh
biBvbGQgdmFsdWUgb2YgInBhcmVudCIsIHdlIGNhbiBoYXBwaWx5IGRlcmVmZXJlbmNlDQogKiB0
aGUgcG9pbnRlcjogd2UganVzdCBjYW4ndCBuZWNlc3NhcmlseSB0cnVzdCB0aGUgcmVzdWx0DQog
KiB1bnRpbCB3ZSBrbm93IHRoYXQgdGhlIHBhcmVudCBwb2ludGVyIGlzIHZhbGlkLg0KICoNCiAq
IFRoZSAibWIoKSIgbWFjcm8gaXMgYSBtZW1vcnkgYmFycmllciAtIGEgc3luY2hyb25pemluZw0K
ICogZXZlbnQuIEl0IGFsc28gbWFrZXMgc3VyZSB0aGF0IGdjYyBkb2Vzbid0IG9wdGltaXplDQog
KiBhd2F5IHRoZSBuZWNlc3NhcnkgbWVtb3J5IHJlZmVyZW5jZXMuLiBUaGUgYmFycmllciBkb2Vz
bid0DQogKiBoYXZlIHRvIGhhdmUgYWxsIHRoYXQgc3Ryb25nIHNlbWFudGljczogb24geDg2IHdl
IGRvbid0DQogKiByZWFsbHkgcmVxdWlyZSBhIHN5bmNocm9uaXppbmcgaW5zdHJ1Y3Rpb24sIGZv
ciBleGFtcGxlLg0KICogVGhlIGJhcnJpZXIgaXMgbW9yZSBpbXBvcnRhbnQgZm9yIGNvZGUgZ2Vu
ZXJhdGlvbiB0aGFuDQogKiBmb3IgYW55IHJlYWwgbWVtb3J5IG9yZGVyaW5nIHNlbWFudGljcyAo
ZXZlbiBpZiB0aGVyZSBpcw0KICogYSBzbWFsbCB3aW5kb3cgZm9yIGEgcmFjZSwgdXNpbmcgdGhl
IG9sZCBwb2ludGVyIGlzDQogKiBoYXJtbGVzcyBmb3IgYSB3aGlsZSkuDQogKi8NCmFzbWxpbmth
Z2UgbG9uZyBzeXNfZ2V0cHBpZCh2b2lkKQ0Kew0KICAgIGludCBwaWQ7DQogICAgc3RydWN0IHRh
c2tfc3RydWN0ICogbWUgPSBjdXJyZW50Ow0KICAgIHN0cnVjdCB0YXNrX3N0cnVjdCAqIHBhcmVu
dDsNCg0KICAgIHBhcmVudCA9IG1lLT5wX29wcHRyOw0KICAgIGZvciAoOzspIHsNCiAgICAgICAg
cGlkID0gcGFyZW50LT5waWQ7DQojaWYgQ09ORklHX1NNUA0Kew0KICAgICAgICBzdHJ1Y3QgdGFz
a19zdHJ1Y3QgKm9sZCA9IHBhcmVudDsNCiAgICAgICAgbWIoKTsNCiAgICAgICAgcGFyZW50ID0g
bWUtPnBfb3BwdHI7DQogICAgICAgIGlmIChvbGQgIT0gcGFyZW50KQ0KICAgICAgICAgICAgY29u
dGludWU7DQp9DQojZW5kaWYNCiAgICAgICAgYnJlYWs7DQogICAgfQ0KICAgIHJldHVybiBwaWQ7
DQp9DQoNCmFzbWxpbmthZ2UgbG9uZyBzeXNfZ2V0dWlkKHZvaWQpDQp7DQogICAgLyogT25seSB3
ZSBjaGFuZ2UgdGhpcyBzbyBTTVAgc2FmZSAqLw0KICAgIHJldHVybiBjdXJyZW50LT51aWQ7DQp9
DQoNCmFzbWxpbmthZ2UgbG9uZyBzeXNfZ2V0ZXVpZCh2b2lkKQ0Kew0KICAgIC8qIE9ubHkgd2Ug
Y2hhbmdlIHRoaXMgc28gU01QIHNhZmUgKi8NCiAgICByZXR1cm4gY3VycmVudC0+ZXVpZDsNCn0N
Cg0KYXNtbGlua2FnZSBsb25nIHN5c19nZXRnaWQodm9pZCkNCnsNCiAgICAvKiBPbmx5IHdlIGNo
YW5nZSB0aGlzIHNvIFNNUCBzYWZlICovDQogICAgcmV0dXJuIGN1cnJlbnQtPmdpZDsNCn0NCg0K
YXNtbGlua2FnZSBsb25nIHN5c19nZXRlZ2lkKHZvaWQpDQp7DQogICAgLyogT25seSB3ZSBjaGFu
Z2UgdGhpcyBzbyBTTVAgc2FmZSAqLw0KICAgIHJldHVybiAgY3VycmVudC0+ZWdpZDsNCn0NCg0K
I2VuZGlmDQoNCi8qIFRocmVhZCBJRCAtIHRoZSBpbnRlcm5hbCBrZXJuZWwgInBpZCIgKi8NCmFz
bWxpbmthZ2UgbG9uZyBzeXNfZ2V0dGlkKHZvaWQpDQp7DQogICAgcmV0dXJuIGN1cnJlbnQtPnBp
ZDsNCn0NCg0KI2lmIDANCi8vIFRoaXMgI2lmIDAgaXMgdG8ga2VlcCB0aGUgcHJldHR5IHByaW50
ZXIvIGZvcm1hdHRlciBoYXBweSBzbyB0aGUgaW5kZW50cyB3aWxsDQovLyBjb3JyZWN0IGJlbG93
Lg0KLy8gVGhlIE5BTk9TTEVFUF9FTlRSWSBtYWNybyBpcyBkZWZpbmVkIGluICBhc20vc2lnbmFs
LmggYW5kDQovLyBpcyBzdHJ1Y3R1cmVkIHRvIGFsbG93IGNvZGUgYXMgd2VsbCBhcyBlbnRyeSBk
ZWZpbml0aW9ucywgc28gdGhhdCB3aGVuDQovLyB3ZSBnZXQgY29udHJvbCBiYWNrIGhlcmUgdGhl
IGVudHJ5IHBhcmFtZXRlcnMgd2lsbCBiZSBhdmFpbGFibGUgYXMgZXhwZWN0ZWQuDQovLyBTb21l
IHN5c3RlbXMgbWF5IGZpbmQgdGhlc2UgcGFyYW1lcnRzIGluIG90aGVyIHdheXMgdGhhbiBhcyBl
bnRyeSBwYXJtcywNCi8vIGZvciBleGFtcGxlLCBzdHJ1Y3QgcHRfcmVncyAqcmVncyBpcyBkZWZp
bmVkIGluIGkzODYgYXMgdGhlIGFkZHJlc3Mgb2YgdGhlDQovLyBmaXJzdCBwYXJhbWV0ZXIsIHdo
ZXJlIGFzIG90aGVyIGFyY2hzIHBhc3MgaXQgYXMgb25lIG9mIHRoZSBwYXJhbWVydGVycy4NCmFz
bWxpbmthZ2UgbG9uZyBzeXNfbmFub3NsZWVwKHZvaWQpDQp7DQojZW5kaWYNCiAgICAgICAgTkFO
T1NMRUVQX0VOVFJZKCAgICBzdHJ1Y3QgdGltZXNwZWMgdDsNCiAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgdW5zaWduZWQgbG9uZyBleHBpcmU7KQ0KDQoNCiAgICAgICAgICAgICAgICAv
LyBUaGUgZm9sbG93aW5nIGNvZGUgZXhwZWN0cyBycXRwLCBybXRwIHRvIGJlIGF2YWlsYWJsZSBh
cyBhIHJlc3VsdCBvZg0KICAgICAgICAgICAgICAgIC8vIHRoZSBhYm92ZSBtYWNyby4gIEFsc28g
YW55IHJlZ3MgbmVlZGVkIGZvciB0aGUgX2RvX3NpZ25hbCgpIG1hY3JvDQogICAgICAgICAgICAg
ICAgLy8gc2hvdWxlIGJlIHNldCB1cCBoZXJlLg0KICAgIGlmKGNvcHlfZnJvbV91c2VyKCZ0LCBy
cXRwLCBzaXplb2Yoc3RydWN0IHRpbWVzcGVjKSkpDQogICAgICAgIHJldHVybiAtRUZBVUxUOw0K
DQogICAgaWYgKHQudHZfbnNlYyA+PSAxMDAwMDAwMDAwTCB8fCB0LnR2X25zZWMgPCAwIHx8IHQu
dHZfc2VjIDwgMCkNCiAgICAgICAgcmV0dXJuIC1FSU5WQUw7DQoNCg0KICAgIGlmICh0LnR2X3Nl
YyA9PSAwICYmIHQudHZfbnNlYyA8PSAyMDAwMDAwTCAmJg0KICAgICAgICBjdXJyZW50LT5wb2xp
Y3kgIT0gU0NIRURfT1RIRVIpDQogICAgew0KICAgICAgICAvKg0KICAgICAgICAgKiBTaG9ydCBk
ZWxheSByZXF1ZXN0cyB1cCB0byAyIG1zIHdpbGwgYmUgaGFuZGxlZCB3aXRoDQogICAgICAgICAq
IGhpZ2ggcHJlY2lzaW9uIGJ5IGEgYnVzeSB3YWl0IGZvciBhbGwgcmVhbC10aW1lIHByb2Nlc3Nl
cy4NCiAgICAgICAgICoNCiAgICAgICAgICogSXRzIGltcG9ydGFudCBvbiBTTVAgbm90IHRvIGRv
IHRoaXMgaG9sZGluZyBsb2Nrcy4NCiAgICAgICAgICovDQogICAgICAgIHVkZWxheSgodC50dl9u
c2VjICsgOTk5KSAvIDEwMDApOw0KICAgICAgICByZXR1cm4gMDsNCiAgICB9DQoNCiAgICBleHBp
cmUgPSB0aW1lc3BlY190b19qaWZmaWVzKCZ0KSArICh0LnR2X3NlYyB8fCB0LnR2X25zZWMpOw0K
ICAgIGRvIHsNCiAgICBjdXJyZW50LT5zdGF0ZSA9IFRBU0tfSU5URVJSVVBUSUJMRTsNCiAgICAg
ICAgfSB3aGlsZSgoZXhwaXJlID0gc2NoZWR1bGVfdGltZW91dChleHBpcmUpKSAmJiAhX2RvX3Np
Z25hbCgpKTsNCg0KICAgIGlmIChleHBpcmUpIHsNCiAgICAgICAgaWYgKHJtdHApIHsNCiAgICAg
ICAgICAgIGppZmZpZXNfdG9fdGltZXNwZWMoZXhwaXJlLCAmdCk7DQogICAgICAgICAgICBpZiAo
Y29weV90b191c2VyKHJtdHAsICZ0LCBzaXplb2Yoc3RydWN0IHRpbWVzcGVjKSkpDQogICAgICAg
ICAgICAgICAgcmV0dXJuIC1FRkFVTFQ7DQogICAgICAgIH0NCiAgICAgICAgcmV0dXJuIC1FSU5U
UjsNCiAgICB9DQogICAgcmV0dXJuIDA7DQp9
------=_Part_24820_2636690.1195544618618--
