Return-Path: <linux-kernel-owner+w=401wt.eu-S1754004Ab0AZOOK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754004Ab0AZOOK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jan 2010 09:14:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753859Ab0AZOOJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Jan 2010 09:14:09 -0500
Received: from luna.emailsicura.it ([83.136.146.238]:49757 "EHLO
	luna.emailsicura.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751476Ab0AZOOH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jan 2010 09:14:07 -0500
X-Greylist: delayed 8030 seconds by postgrey-1.27 at vger.kernel.org; Tue, 26 Jan 2010 09:14:07 EST
Message-ID: <4B5EF86D.6070109@officineinformatiche.net>
Date: Tue, 26 Jan 2010 15:13:01 +0100
From: Fabio Bas - Officine Informatiche 
	<fabio.bas@officineinformatiche.net>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.7) Gecko/20100121 Thunderbird/3.0.1
MIME-Version: 1.0
To: Oliver Neukum <oliver@neukum.org>
CC: "Rafael J. Wysocki" <rjw@sisk.pl>, linux-kernel@vger.kernel.org
Subject: Re: PROBLEM: freeze on ppp connection (using an usb "key" modem)
References: <4B5ED90E.6060304@officineinformatiche.net> <201001261353.08528.rjw@sisk.pl> <201001261354.58287.oliver@neukum.org>
In-Reply-To: <201001261354.58287.oliver@neukum.org>
X-Enigmail-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 26/01/2010 13:54, Oliver Neukum wrote:
> Am Dienstag, 26. Januar 2010 13:53:08 schrieb Rafael J. Wysocki:
>> On Tuesday 26 January 2010, Fabio Bas - Officine Informatiche wrote:
>> ...
>>> The last working kernel i'm aware of is kernel 2.6.30, the first showing
>>> the problem 2.6.32.2
>>
>> Can you test 2.6.31.x please?
I'll download, compile and test it asap

> 
> Is there a bugzilla for this?

I've just created it and attached all of my logs
http://bugzilla.kernel.org/show_bug.cgi?id=15146

> Sysrq-t?

Here's my new crash log; sysrq-t output refers to the time after the
connection was estabilished but before the freeze. I've tried to
alt+sysrq+t dìseveral times when the box was freezed, but i had no reply
from the kernel.

Jan 26 14:30:36 ambassador kernel: PPP generic driver version 2.4.2
Jan 26 14:30:36 ambassador pppd[5976]: pppd 2.4.4 started by root, uid 0
Jan 26 14:30:37 ambassador chat[5978]: send (ATZ^M)
Jan 26 14:30:37 ambassador chat[5978]: expect (OK^M^J)
Jan 26 14:30:37 ambassador chat[5978]: ATZ^M^M
Jan 26 14:30:37 ambassador chat[5978]: OK^M
Jan 26 14:30:37 ambassador chat[5978]:  -- got it
Jan 26 14:30:37 ambassador chat[5978]: send (AT+CGDCONT=1,"IP","internet"^M)
Jan 26 14:30:37 ambassador chat[5978]: expect (OK^M^J)
Jan 26 14:30:37 ambassador chat[5978]: AT+CGDCONT=1,"IP","internet"^M^M
Jan 26 14:30:37 ambassador chat[5978]: OK^M
Jan 26 14:30:37 ambassador chat[5978]:  -- got it
Jan 26 14:30:37 ambassador chat[5978]: send (ATDT*99***1#^M)
Jan 26 14:30:37 ambassador chat[5978]: expect (CONNECT)
Jan 26 14:30:37 ambassador chat[5978]: ATDT*99***1#^M^M
Jan 26 14:30:37 ambassador chat[5978]: CONNECT
Jan 26 14:30:37 ambassador chat[5978]:  -- got it
Jan 26 14:30:37 ambassador chat[5978]: send (^M)
Jan 26 14:30:37 ambassador chat[5978]: expect (^M^J)
Jan 26 14:30:37 ambassador chat[5978]:  7200000^M
Jan 26 14:30:37 ambassador chat[5978]:  -- got it
Jan 26 14:30:37 ambassador pppd[5976]: Serial connection established.
Jan 26 14:30:37 ambassador pppd[5976]: Using interface ppp0
Jan 26 14:30:37 ambassador pppd[5976]: Connect: ppp0 <--> /dev/ttyHS3
Jan 26 14:30:38 ambassador kernel: PPP BSD Compression module registered
Jan 26 14:30:38 ambassador kernel: PPP Deflate Compression module registered
Jan 26 14:30:39 ambassador pppd[5976]: local  IP address 93.68.131.123
Jan 26 14:30:39 ambassador pppd[5976]: remote IP address 10.64.64.64
Jan 26 14:30:39 ambassador pppd[5976]: primary   DNS address 83.224.65.143
Jan 26 14:30:39 ambassador pppd[5976]: secondary DNS address 83.224.66.138
Jan 26 14:30:40 ambassador kernel: scsi 29:0:0:0: Direct-Access
ZCOption HSUPA Modem           PQ: 0 ANSI: 2
Jan 26 14:30:40 ambassador kernel: sd 29:0:0:0: Attached scsi generic
sg2 type 0
Jan 26 14:30:40 ambassador kernel: sd 29:0:0:0: [sdb] 3964928 512-byte
logical blocks: (2.03 GB/1.89 GiB)
Jan 26 14:30:40 ambassador kernel: sd 29:0:0:0: [sdb] Write Protect is off
Jan 26 14:30:40 ambassador kernel:  sdb: sdb1
Jan 26 14:30:40 ambassador kernel: sd 29:0:0:0: [sdb] Attached SCSI
removable disk
Jan 26 14:31:04 ambassador /usr/sbin/gpm[2285]: *** info [client.c(137)]:
Jan 26 14:31:04 ambassador /usr/sbin/gpm[2285]: Connecting at fd 6
Jan 26 14:31:32 ambassador /usr/sbin/gpm[2285]: *** info [client.c(275)]:
Jan 26 14:31:32 ambassador /usr/sbin/gpm[2285]: Request on 6 (console 1)
Jan 26 14:31:32 ambassador /usr/sbin/gpm[2285]: *** info [client.c(284)]:
Jan 26 14:31:32 ambassador /usr/sbin/gpm[2285]: Closing
Jan 26 14:32:28 ambassador kernel: 00000
Jan 26 14:32:28 ambassador kernel: flush-8:0     S 0000000000000000
0  1902      2 0x00000000
Jan 26 14:32:28 ambassador kernel: kondemand/0   S ffff88000180dd88
0  1969      2 0x00000000
Jan 26 14:32:28 ambassador kernel: kondemand/1   S ffff88000190dd88
0  1970      2 0x00000000
Jan 26 14:32:28 ambassador kernel: syslogd       S ffff88000180dd88
0  2016      1 0x00000000
Jan 26 14:32:28 ambassador kernel: klogd         S ffff88007f908000
0  2020      1 0x00000000
Jan 26 14:32:28 ambassador kernel: acpid         S ffff88000190dd88
0  2149      1 0x00000000
Jan 26 14:32:28 ambassador kernel: dbus-daemon   S ffff88000180dd88
0  2161      1 0x00000000
Jan 26 14:32:28 ambassador kernel: hald          S ffff88000180dd88
0  2166      1 0x00000000
Jan 26 14:32:28 ambassador kernel: hald-runner   S ffff88000190dd88
0  2167   2166 0x00000000
Jan 26 14:32:28 ambassador kernel: hald-addon-in S ffff88000180dd88
0  2195   2167 0x00000000
Jan 26 14:32:28 ambassador kernel: hald-addon-cp S 0000000000000000
0  2199   2167 0x00000000
Jan 26 14:32:28 ambassador kernel: hald-addon-ac S ffff88007bf81d08
0  2200   2167 0x00000000
Jan 26 14:32:28 ambassador kernel: hald-addon-st S ffff88007bd53b88
0  2207   2167 0x00000000
Jan 26 14:32:28 ambassador kernel: cupsd         S ffff88000180dd88
0  2237      1 0x00000000
Jan 26 14:32:28 ambassador kernel: wicd          S ffff88000190dd88
0  2239      1 0x00000000
Jan 26 14:32:28 ambassador kernel: crond         S ffff88000180dd88
0  2252      1 0x00000000
Jan 26 14:32:28 ambassador kernel: atd           S ffff88000180dd88
0  2254      1 0x00000000
Jan 26 14:32:28 ambassador kernel: wicd-monitor  S ffff88000190dd88
0  2269   2239 0x00000000
Jan 26 14:32:28 ambassador kernel: gpm           S 0000000000000040
0  2285      1 0x00000000
Jan 26 14:32:28 ambassador kernel: agetty        S ffff88000180dd88
0  2304      1 0x00000000
Jan 26 14:32:28 ambassador kernel: dhcpcd        ? ffff88000180dd88
0  5158   2239 0x00000000
Jan 26 14:32:28 ambassador kernel: bash          S ffff88000190dd88
0  5833      1 0x00000000
Jan 26 14:32:28 ambassador kernel: bash          S ffff88000180dd88
0  5834      1 0x00000000
Jan 26 14:32:28 ambassador kernel: agetty        S ffff88006e45bf50
0  5835      1 0x00000000
Jan 26 14:32:28 ambassador kernel: agetty        S ffff88007ed84900
0  5836      1 0x00000000
Jan 26 14:32:28 ambassador kernel: agetty        S ffff88006e45bee0
0  5837      1 0x00000000
Jan 26 14:32:28 ambassador kernel: scsi_eh_29    S ffff88000180dd88
0  5930      2 0x00000000
Jan 26 14:32:28 ambassador kernel: usb-storage   S ffff88000c109a80
0  5931      2 0x00000000
Jan 26 14:32:28 ambassador kernel: pppd          S ffff88000180dd88
0  5976      1 0x00000000
Jan 26 14:32:28 ambassador kernel: hald-addon-st S ffff880079551b88
0  6014   2167 0x00000000
Jan 26 14:32:44 ambassador /usr/sbin/gpm[2285]: *** info [client.c(137)]:
Jan 26 14:32:44 ambassador /usr/sbin/gpm[2285]: Connecting at fd 6
Jan 26 14:34:29 ambassador /usr/sbin/gpm[2285]: *** info [client.c(275)]:
Jan 26 14:34:29 ambassador /usr/sbin/gpm[2285]: Request on 6 (console 1)
Jan 26 14:34:29 ambassador /usr/sbin/gpm[2285]: *** info [client.c(284)]:
Jan 26 14:34:29 ambassador /usr/sbin/gpm[2285]: Closing
Jan 26 14:34:31 ambassador /usr/sbin/gpm[2285]: *** info [client.c(137)]:
Jan 26 14:34:31 ambassador /usr/sbin/gpm[2285]: Connecting at fd 6
Jan 26 14:35:13 ambassador /usr/sbin/gpm[2285]: *** info [client.c(275)]:
Jan 26 14:35:13 ambassador /usr/sbin/gpm[2285]: Request on 6 (console 1)
Jan 26 14:35:13 ambassador /usr/sbin/gpm[2285]: *** info [client.c(284)]:
Jan 26 14:35:13 ambassador /usr/sbin/gpm[2285]: Closing
Jan 26 14:36:02 ambassador kernel: CPU 1:
Jan 26 14:36:02 ambassador kernel: Pid: 0, comm: swapper Not tainted
2.6.32.5 #2 Satellite A210
Jan 26 14:36:02 ambassador kernel: RIP: 0010:[<ffffffff81014488>]
[<ffffffff81014488>] default_idle+0x38/0x80
Jan 26 14:36:02 ambassador kernel: RSP: 0018:ffff88007f8c5eb8  EFLAGS:
00000246
Jan 26 14:36:02 ambassador kernel: RAX: 0000000000000000 RBX:
ffff88007f8c5ec8 RCX: 0000000000000000
Jan 26 14:36:02 ambassador kernel: RDX: 0000000000000001 RSI:
0000000000000086 RDI: 0000000000000000
Jan 26 14:36:02 ambassador kernel: RBP: ffffffff8100c10e R08:
0000000000000000 R09: 0000000000001920
Jan 26 14:36:02 ambassador kernel: R10: 0000000000000002 R11:
00000001007667fc R12: 0000000000000004
Jan 26 14:36:02 ambassador kernel: R13: 0000000000000292 R14:
ffff88007f8c0000 R15: 00000001007667fc
Jan 26 14:36:02 ambassador kernel: FS:  00007fe5bdb987e0(0000)
GS:ffff880001900000(0000) knlGS:0000000000000000
Jan 26 14:36:02 ambassador kernel: CS:  0010 DS: 0018 ES: 0018 CR0:
000000008005003b
Jan 26 14:36:02 ambassador kernel: CR2: 00007fe5b0d74f70 CR3:
000000006ee8e000 CR4: 00000000000006e0
Jan 26 14:36:02 ambassador kernel: DR0: 0000000000000000 DR1:
0000000000000000 DR2: 0000000000000000
Jan 26 14:36:02 ambassador kernel: DR3: 0000000000000000 DR6:
00000000ffff0ff0 DR7: 0000000000000400
Jan 26 14:36:02 ambassador kernel: CPU 1:
Jan 26 14:36:02 ambassador kernel: Pid: 0, comm: swapper Not tainted
2.6.32.5 #2 Satellite A210
Jan 26 14:36:02 ambassador kernel: RIP: 0010:[<ffffffff813e1be0>]
[<ffffffff813e1be0>] _spin_lock_bh+0x20/0x40
Jan 26 14:36:02 ambassador kernel: RSP: 0018:ffff880001903e00  EFLAGS:
00000286
Jan 26 14:36:02 ambassador kernel: RAX: 0000000000009f9f RBX:
ffff880001903e10 RCX: ffff88007b715c90
Jan 26 14:36:02 ambassador kernel: RDX: ffff88007b715c90 RSI:
ffff8800791aee00 RDI: ffff8800793f367c
Jan 26 14:36:02 ambassador kernel: RBP: ffffffff8100c113 R08:
0000000000000000 R09: ffff88007eb2d150
Jan 26 14:36:02 ambassador kernel: R10: 0000000000001000 R11:
0000000000000001 R12: ffff880001903d80
Jan 26 14:36:02 ambassador kernel: R13: ffff8800793f367c R14:
ffff8800793f3600 R15: ffff8800791aee00
Jan 26 14:36:02 ambassador kernel: FS:  00007ff0bbbec740(0000)
GS:ffff880001900000(0000) knlGS:0000000000000000
Jan 26 14:36:02 ambassador kernel: CS:  0010 DS: 0018 ES: 0018 CR0:
000000008005003b
Jan 26 14:36:02 ambassador kernel: CR2: 00007fe5b0d74f70 CR3:
000000000c224000 CR4: 00000000000006e0
Jan 26 14:36:02 ambassador kernel: DR0: 0000000000000000 DR1:
0000000000000000 DR2: 0000000000000000
Jan 26 14:36:02 ambassador kernel: DR3: 0000000000000000 DR6:
00000000ffff0ff0 DR7: 0000000000000400
Jan 26 14:36:52 ambassador kernel: CPU 1:
Jan 26 14:36:52 ambassador kernel: Pid: 0, comm: swapper Not tainted
2.6.32.5 #2 Satellite A210
Jan 26 14:36:52 ambassador kernel: RIP: 0010:[<ffffffff8103fe92>]
[<ffffffff8103fe92>] finish_task_switch+0x52/0xc0
Jan 26 14:36:52 ambassador kernel: RSP: 0018:ffff88007f8c5e08  EFLAGS:
00000286
Jan 26 14:36:52 ambassador kernel: RAX: 000000000000f7c0 RBX:
ffff88007f8c5e38 RCX: 0000000000000000
Jan 26 14:36:52 ambassador kernel: RDX: 0000000000000001 RSI:
0000000000000001 RDI: ffff88007f8a27c0
Jan 26 14:36:52 ambassador kernel: RBP: ffffffff8100c10e R08:
ffff88007f8c4000 R09: 0000000000000000
Jan 26 14:36:52 ambassador kernel: R10: 0000000000000000 R11:
0000000000000000 R12: ffffffff810747c4
Jan 26 14:36:52 ambassador kernel: R13: ffff88007f8c5d78 R14:
ffffffff810242ed R15: ffff88007f8c5d68
Jan 26 14:36:52 ambassador kernel: FS:  00007fa2e4e02780(0000)
GS:ffff880001900000(0000) knlGS:0000000000000000
Jan 26 14:36:52 ambassador kernel: CS:  0010 DS: 0018 ES: 0018 CR0:
000000008005003b
Jan 26 14:36:52 ambassador kernel: CR2: 000000000230f6a4 CR3:
000000006129a000 CR4: 00000000000006e0
Jan 26 14:36:52 ambassador kernel: DR0: 0000000000000000 DR1:
0000000000000000 DR2: 0000000000000000
Jan 26 14:36:52 ambassador kernel: DR3: 0000000000000000 DR6:
00000000ffff0ff0 DR7: 0000000000000400
Jan 26 14:37:11 ambassador kernel: CPU 1:
Jan 26 14:37:11 ambassador kernel: Pid: 0, comm: swapper Not tainted
2.6.32.5 #2 Satellite A210
Jan 26 14:37:11 ambassador kernel: RIP: 0010:[<ffffffff81014488>]
[<ffffffff81014488>] default_idle+0x38/0x80
Jan 26 14:37:11 ambassador kernel: RSP: 0018:ffff88007f8c5eb8  EFLAGS:
00000246
Jan 26 14:37:11 ambassador kernel: RAX: 0000000000000000 RBX:
ffff88007f8c5ec8 RCX: 0000000000000000
Jan 26 14:37:11 ambassador kernel: RDX: 0000000000000001 RSI:
0000000000000086 RDI: 0000000000000000
Jan 26 14:37:11 ambassador kernel: RBP: ffffffff8100c10e R08:
0000000000000000 R09: ffff88000190e148
Jan 26 14:37:11 ambassador kernel: R10: 00000764a2424598 R11:
0000000100777386 R12: 0000000000000004
Jan 26 14:37:11 ambassador kernel: R13: 0000000000000292 R14:
ffff88007f8c0000 R15: 0000000100777386
Jan 26 14:37:11 ambassador kernel: FS:  00007f9c97a9e740(0000)
GS:ffff880001900000(0000) knlGS:0000000000000000
Jan 26 14:37:11 ambassador kernel: CS:  0010 DS: 0018 ES: 0018 CR0:
000000008005003b
Jan 26 14:37:11 ambassador kernel: CR2: 00000000055bf9b8 CR3:
000000007b624000 CR4: 00000000000006e0
Jan 26 14:37:11 ambassador kernel: DR0: 0000000000000000 DR1:
0000000000000000 DR2: 0000000000000000
Jan 26 14:37:11 ambassador kernel: DR3: 0000000000000000 DR6:
00000000ffff0ff0 DR7: 0000000000000400
Jan 26 14:37:24 ambassador kernel: CPU 1:
Jan 26 14:37:24 ambassador kernel: Pid: 0, comm: swapper Not tainted
2.6.32.5 #2 Satellite A210
Jan 26 14:37:24 ambassador kernel: RIP: 0010:[<ffffffff81014488>]
[<ffffffff81014488>] default_idle+0x38/0x80
Jan 26 14:37:24 ambassador kernel: RSP: 0018:ffff88007f8c5eb8  EFLAGS:
00000246
Jan 26 14:37:24 ambassador kernel: RAX: 0000000000000000 RBX:
ffff88007f8c5ec8 RCX: 0000000000000000
Jan 26 14:37:24 ambassador kernel: RDX: 0000000000000001 RSI:
0000000000000086 RDI: 0000000000000000
Jan 26 14:37:24 ambassador kernel: RBP: ffffffff8100c10e R08:
0000000000000000 R09: ffff88000190e148
Jan 26 14:37:24 ambassador kernel: R10: 00000767b5048c00 R11:
000000010077a7bc R12: 0000000000000004
Jan 26 14:37:24 ambassador kernel: R13: 0000000000000292 R14:
ffff88007f8c0000 R15: 000000010077a7bb
Jan 26 14:37:24 ambassador kernel: FS:  00007ff0bbbec740(0000)
GS:ffff880001900000(0000) knlGS:0000000000000000
Jan 26 14:37:24 ambassador kernel: CS:  0010 DS: 0018 ES: 0018 CR0:
000000008005003b
Jan 26 14:37:24 ambassador kernel: CR2: 0000000000989060 CR3:
000000000c224000 CR4: 00000000000006e0
Jan 26 14:37:24 ambassador kernel: DR0: 0000000000000000 DR1:
0000000000000000 DR2: 0000000000000000
Jan 26 14:37:24 ambassador kernel: DR3: 0000000000000000 DR6:
00000000ffff0ff0 DR7: 0000000000000400
Jan 26 14:37:25 ambassador kernel: CPU 1:
Jan 26 14:37:25 ambassador kernel: Pid: 0, comm: swapper Not tainted
2.6.32.5 #2 Satellite A210
Jan 26 14:37:25 ambassador kernel: RIP: 0010:[<ffffffff8101453f>]
[<ffffffff8101453f>] c1e_idle+0x6f/0x110
Jan 26 14:37:25 ambassador kernel: RSP: 0018:ffff88007f8c5ef0  EFLAGS:
00000296
Jan 26 14:37:25 ambassador kernel: RAX: 0000000000000001 RBX:
ffff88007f8c5ef8 RCX: 0000000000000000
Jan 26 14:37:25 ambassador kernel: RDX: 000000000000f22b RSI:
0000000000000096 RDI: ffffffff816a2d80
Jan 26 14:37:25 ambassador kernel: RBP: ffffffff8100c10e R08:
ffff88000190cce0 R09: 0000000000000000
Jan 26 14:37:25 ambassador kernel: R10: 0000000000000002 R11:
000000010077ad09 R12: 0000000000000005
Jan 26 14:37:25 ambassador kernel: R13: 0000000000000000 R14:
ffffffff8106cdd7 R15: ffff88007f8c5e88
Jan 26 14:37:25 ambassador kernel: FS:  00007ff0bbbec740(0000)
GS:ffff880001900000(0000) knlGS:0000000000000000
Jan 26 14:37:25 ambassador kernel: CS:  0010 DS: 0018 ES: 0018 CR0:
000000008005003b
Jan 26 14:37:25 ambassador kernel: CR2: 00007f04d488b650 CR3:
000000000c224000 CR4: 00000000000006e0
Jan 26 14:37:25 ambassador kernel: DR0: 0000000000000000 DR1:
0000000000000000 DR2: 0000000000000000
Jan 26 14:37:25 ambassador kernel: DR3: 0000000000000000 DR6:
00000000ffff0ff0 DR7: 0000000000000400

> Which driver cdc-acm or a serial driver?

Serial (my modem device is /dev/ttyHS3):

root@ambassador:~# cat /proc/tty/drivers
/dev/tty             /dev/tty        5       0 system:/dev/tty
/dev/console         /dev/console    5       1 system:console
/dev/ptmx            /dev/ptmx       5       2 system
/dev/vc/0            /dev/vc/0       4       0 system:vtmaster
hso                  /dev/ttyHS    249 0-255 serial
serial               /dev/ttyS       4 64-67 serial
pty_slave            /dev/pts      136 0-1048575 pty:slave
pty_master           /dev/ptm      128 0-1048575 pty:master
pty_slave            /dev/ttyp       3 0-31 pty:slave
pty_master           /dev/pty        2 0-31 pty:master
unknown              /dev/tty        4 1-63 console

> 
> 	Regards
> 		Oliver
> 
> 

Thank you :)

fabio
