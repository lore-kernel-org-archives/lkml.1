Return-Path: <linux-kernel-owner+w=401wt.eu-S1760739AbXGDBJr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760739AbXGDBJr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jul 2007 21:09:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755566AbXGDBJh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Jul 2007 21:09:37 -0400
Received: from wa-out-1112.google.com ([209.85.146.182]:7627 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755507AbXGDBJb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jul 2007 21:09:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=L0kND/4RjLiRYsQKzX7UTNNXZUhDjfokS/u8zKq7qzSP298TKgXHbCzA/uHZeGOOwXT6Op80xoHRO/D4DCrfhfypTiddP0he1M9+/NEqrjmT7SGvNNTPbFIWC3bq5iirHPfClo5njw9BLjP7MbuqZvFUC/xZQ0/NwV1e2zOkNzk=
Message-ID: <a44ae5cd0707031809p3d7c3b68gf2d5633736bb4f3@mail.gmail.com>
Date: Tue, 3 Jul 2007 18:09:29 -0700
From: "Miles Lane" <miles.lane@gmail.com>
To: "Andrew Morton" <akpm@osdl.org>, LKML <linux-kernel@vger.kernel.org>
Subject: 2.6.22-rc6-mm1 -- Problems with suspend/resume.
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew,

Sorry.  I don't know who else to include in the To: list.  Should I
send this again with .config information?  Would ps -Af help?

ACPI: PCI interrupt for device 0000:01:00.0 disabled
ACPI: PCI interrupt for device 0000:01:06.0 disabled
Stopping tasks ...
Freezing of user space  timed out after 20 seconds (5 tasks refusing to freeze):

                         free                        sibling
  task             PC    stack   pid father child younger older
init          D 000000A3     0     1      0 (NOTLB)
       c2848eac 00000096 107860bd 000000a3 00000000 c2848e94 c0216c13 c2858000
       c2858190 c265c100 107860bd 000000a3 00000000 c0157c10 c32b8780 00000046
       c2848ea0 c338ab84 bfc9e11c 00000000 bfc9e11c 00000000 c2848eb8 c0157c3d
Call Trace:
 [<c0157c3d>] refrigerator+0xcb/0xda
 [<c0138d38>] get_signal_to_deliver+0x33/0x463
 [<c01077ea>] do_notify_resume+0x94/0x732
 [<c01082f9>] work_notifysig+0x13/0x1a
 [<ffffe410>] 0xffffe410
 =======================
INFO: lockdep is turned off.
kthreadd      S 000000A2     0     2      0 (L-TLB)
       c2847fcc 00000092 88a3d180 000000a2 00000000 c2847fb4 c0216c13 c2858af0
       c2858c80 c265c100 88a3d180 000000a2 00000000 c013fac1 c8206580 00000246
       c2847fc0 c0216abf c0520d48 c0520d40 000023c8 d03d8e64 c2847fe0 c013fa29
Call Trace:
 [<c013fa29>] kthreadd+0x37/0xd4
 [<c0108eab>] kernel_thread_helper+0x7/0x10
 =======================
INFO: lockdep is turned off.
migration/0   S 00000000     0     3      2 (L-TLB)
       c2846fa0 00000086 0923af1f 00000000 c2859ba8 c28595e0 c2859ba0 c28595e0
       c2859770 c265c100 0923af1f 00000000 00000000 c0129aa0 c0514180 00000046
       c2846f94 c265c100 c265c100 c265c53c c265c100 00000000 c2846fd0 c0129aa5
Call Trace:
 [<c0129aa5>] migration_thread+0x178/0x204
 [<c013fba7>] kthread+0x3b/0x64
 [<c0108eab>] kernel_thread_helper+0x7/0x10
 =======================
INFO: lockdep is turned off.
ksoftirqd/0   S 000000A7     0     4      2 (L-TLB)
       c2845fc4 00000096 7dbb6b36 000000a7 c0366252 c2845fa0 c014b438 c285a0d0
       c285a260 c265c100 7dbb6b36 000000a7 00000000 c2845fc4 c8205e00 00000000
       c0132be9 00000000 c2845fbc 00000000 c0132be9 00000000 c2845fd0 c0132c0e
Call Trace:
 [<c0132c0e>] ksoftirqd+0x25/0xbd
 [<c013fba7>] kthread+0x3b/0x64
 [<c0108eab>] kernel_thread_helper+0x7/0x10
 =======================
INFO: lockdep is turned off.
watchdog/0    S 00000000     0     5      2 (L-TLB)
       c2844fc4 00000096 0923b057 00000000 c010e74a c2844f90 00000292 c285abc0
       c285ad50 c265c100 0923b057 00000000 00000000 c05c4108 c0514180 00000000
       c2844fb4 c015d367 c2844fc4 00000000 c015d4a9 00000000 c2844fd0 c015d4e8
Call Trace:
 [<c015d4e8>] watchdog+0x3f/0x4f
 [<c013fba7>] kthread+0x3b/0x64
 [<c0108eab>] kernel_thread_helper+0x7/0x10
 =======================
INFO: lockdep is turned off.
events/0      S 000000A7     0     6      2 (L-TLB)
       c2842fac 00000096 982afcbe 000000a7 c2842f84 c014b438 c013fdee c285b6b0
       c285b840 c265c100 982afcbe 000000a7 00000000 00000282 c8205e00 c2813394
       c2842fac c013fdee 00000282 c2813370 c013d0c1 c2842fc8 c2842fd0 c013d149
Call Trace:
 [<c013d149>] worker_thread+0x88/0xc7
 [<c013fba7>] kthread+0x3b/0x64
 [<c0108eab>] kernel_thread_helper+0x7/0x10
 =======================
INFO: lockdep is turned off.
khelper       S 000000A2     0     7      2 (L-TLB)
       c2841fac 00000096 cbfc2f5c 000000a2 c2841f84 c014b438 c013fdee c285c1a0
       c285c330 c265c100 cbfc2f5c 000000a2 00000000 00000282 c7f12300 c2813444
       c2841fac c013fdee 00000282 c2813420 c013d0c1 c2841fc8 c2841fd0 c013d149
Call Trace:
 [<c013d149>] worker_thread+0x88/0xc7
 [<c013fba7>] kthread+0x3b/0x64
 [<c0108eab>] kernel_thread_helper+0x7/0x10
 =======================
INFO: lockdep is turned off.
kblockd/0     S 000000A2     0    52      2 (L-TLB)
       c28c9fac 00000096 f74f2a8b 000000a2 c28c9f84 c014b438 c013fdee c28815e0
       c2881770 c265c100 f74f2a8b 000000a2 00000000 00000282 c3988f00 c283b2e4
       c28c9fac c013fdee 00000282 c283b2c0 c013d0c1 c28c9fc8 c28c9fd0 c013d149
Call Trace:
 [<c013d149>] worker_thread+0x88/0xc7
 [<c013fba7>] kthread+0x3b/0x64
 [<c0108eab>] kernel_thread_helper+0x7/0x10
 =======================
INFO: lockdep is turned off.
kacpid        S 000000A6     0    55      2 (L-TLB)
       c28c6fac 00000096 b88309bb 000000a6 c28c6f84 c014b438 c013fdee c285ed60
       c285eef0 c265c100 b88309bb 000000a6 00000000 00000282 c8205e00 c283b4f4
       c28c6fac c013fdee 00000282 c283b4d0 c013d0c1 c28c6fc8 c28c6fd0 c013d149
Call Trace:
 [<c013d149>] worker_thread+0x88/0xc7
 [<c013fba7>] kthread+0x3b/0x64
 [<c0108eab>] kernel_thread_helper+0x7/0x10
 =======================
INFO: lockdep is turned off.
kacpi_notify  S 000000A6     0    56      2 (L-TLB)
       c28c5fac 00000096 b8843b57 000000a6 c28c5f84 c014b438 c013fdee c285e270
       c285e400 c265c100 b8843b57 000000a6 00000000 00000282 c8205e00 c283b5a4
       c28c5fac c013fdee 00000282 c283b580 c013d0c1 c28c5fc8 c28c5fd0 c013d149
Call Trace:
 [<c013d149>] worker_thread+0x88/0xc7
 [<c013fba7>] kthread+0x3b/0x64
 [<c0108eab>] kernel_thread_helper+0x7/0x10
 =======================
INFO: lockdep is turned off.
ata/0         S 000000A2     0   153      2 (L-TLB)
       c2917fac 00000096 dc3c3696 000000a2 c2917f84 c014b438 c013fdee c29395e0
       c2939770 c265c100 dc3c3696 000000a2 00000000 00000282 c3988c80 c283bc84
       c2917fac c013fdee 00000282 c283bc60 c013d0c1 c2917fc8 c2917fd0 c013d149
Call Trace:
 [<c013d149>] worker_thread+0x88/0xc7
 [<c013fba7>] kthread+0x3b/0x64
 [<c0108eab>] kernel_thread_helper+0x7/0x10
 =======================
INFO: lockdep is turned off.
ata_aux       S 00000000     0   154      2 (L-TLB)
       c2915fac 00000096 0f06bdb4 00000000 c2915f84 c014b598 c013fdee c293a0d0
       c293a260 c265c100 0f06bdb4 00000000 00000000 00000282 c0514180 c283bd34
       c2915fac c013fdee 00000282 c283bd10 c013d0c1 c2915fc8 c2915fd0 c013d149
Call Trace:
 [<c013d149>] worker_thread+0x88/0xc7
 [<c013fba7>] kthread+0x3b/0x64
 [<c0108eab>] kernel_thread_helper+0x7/0x10
 =======================
INFO: lockdep is turned off.
kseriod       S 00000000     0   158      2 (L-TLB)
       c290ff94 00000096 599fa437 00000000 c290ff6c c014b598 c013fdee c293cc90
       c293ce20 c265c100 599fa437 00000000 00000000 00000292 c329c280 c054a900
       c290ff94 c013fdee 00000292 c3381370 c3381320 c290ffc4 c290ffd0 c02bcc79
Call Trace:
 [<c02bcc79>] serio_thread+0x279/0x2c4
 [<c013fba7>] kthread+0x3b/0x64
 [<c0108eab>] kernel_thread_helper+0x7/0x10
 =======================
INFO: lockdep is turned off.
rt-test-0     S 00000000     0   193      2 (L-TLB)
       c291afc0 00000086 21528113 00000000 00000000 c2938000 c0368f94 c2938000
       c2938190 c265c100 21528113 00000000 00000000 c291afa8 c0514180 c084e760
       c291afb4 c0368f94 00000001 00000001 c084e760 00000000 c291afd0 c0151222
Call Trace:
 [<c0151222>] test_func+0x63/0xb8
 [<c013fba7>] kthread+0x3b/0x64
 [<c0108eab>] kernel_thread_helper+0x7/0x10
 =======================
INFO: lockdep is turned off.
rt-test-1     S 00000000     0   195      2 (L-TLB)
       c290efc0 00000086 2155ed84 00000000 00000000 c285d780 c0368f94 c285d780
       c285d910 c265c100 2155ed84 00000000 00000000 c290efa8 c0514180 c084e7f0
       c290efb4 c0368f94 00000001 00000001 c084e7f0 00000000 c290efd0 c0151222
Call Trace:
 [<c0151222>] test_func+0x63/0xb8
 [<c013fba7>] kthread+0x3b/0x64
 [<c0108eab>] kernel_thread_helper+0x7/0x10
 =======================
INFO: lockdep is turned off.
rt-test-2     S 00000000     0   197      2 (L-TLB)
       c2891fc0 00000086 215959ed 00000000 00000000 c2880af0 c0368f94 c2880af0
       c2880c80 c265c100 215959ed 00000000 00000000 c2891fa8 c0514180 c084e880
       c2891fb4 c0368f94 00000001 00000001 c084e880 00000000 c2891fd0 c0151222
Call Trace:
 [<c0151222>] test_func+0x63/0xb8
 [<c013fba7>] kthread+0x3b/0x64
 [<c0108eab>] kernel_thread_helper+0x7/0x10
 =======================
INFO: lockdep is turned off.
rt-test-3     S 00000000     0   199      2 (L-TLB)
       c2905fc0 00000086 215d4fbb 00000000 00000000 c2882bc0 c0368f94 c2882bc0
       c2882d50 c265c100 215d4fbb 00000000 00000000 c2905fa8 c0514180 c084e910
       c2905fb4 c0368f94 00000001 00000001 c084e910 00000000 c2905fd0 c0151222
Call Trace:
 [<c0151222>] test_func+0x63/0xb8
 [<c013fba7>] kthread+0x3b/0x64
 [<c0108eab>] kernel_thread_helper+0x7/0x10
 =======================
INFO: lockdep is turned off.
rt-test-4     S 00000000     0   201      2 (L-TLB)
       c335afc0 00000086 2160dc86 00000000 00000000 c2884c90 c0368f94 c2884c90
       c2884e20 c265c100 2160dc86 00000000 00000000 c335afa8 c0514180 c084e9a0
       c335afb4 c0368f94 00000001 00000001 c084e9a0 00000000 c335afd0 c0151222
Call Trace:
 [<c0151222>] test_func+0x63/0xb8
 [<c013fba7>] kthread+0x3b/0x64
 [<c0108eab>] kernel_thread_helper+0x7/0x10
 =======================
INFO: lockdep is turned off.
rt-test-5     S 00000000     0   203      2 (L-TLB)
       c3358fc0 00000086 216421f8 00000000 00000000 c2886270 c0368f94 c2886270
       c2886400 c265c100 216421f8 00000000 00000000 c3358fa8 c0514180 c084ea30
       c3358fb4 c0368f94 00000001 00000001 c084ea30 00000000 c3358fd0 c0151222
Call Trace:
 [<c0151222>] test_func+0x63/0xb8
 [<c013fba7>] kthread+0x3b/0x64
 [<c0108eab>] kernel_thread_helper+0x7/0x10
 =======================
INFO: lockdep is turned off.
rt-test-6     S 00000000     0   205      2 (L-TLB)
       c3356fc0 00000086 2167cafd 00000000 00000000 c28841a0 c0368f94 c28841a0
       c2884330 c265c100 2167cafd 00000000 00000000 c3356fa8 c0514180 c084eac0
       c3356fb4 c0368f94 00000001 00000001 c084eac0 00000000 c3356fd0 c0151222
Call Trace:
 [<c0151222>] test_func+0x63/0xb8
 [<c013fba7>] kthread+0x3b/0x64
 [<c0108eab>] kernel_thread_helper+0x7/0x10
 =======================
INFO: lockdep is turned off.
rt-test-7     S 00000000     0   207      2 (L-TLB)
       c3354fc0 00000086 216b1fe3 00000000 00000000 c33c0af0 c0368f94 c33c0af0
       c33c0c80 c265c100 216b1fe3 00000000 00000000 c3354fa8 c0514180 c084eb50
       c3354fb4 c0368f94 00000001 00000001 c084eb50 00000000 c3354fd0 c0151222
Call Trace:
 [<c0151222>] test_func+0x63/0xb8
 [<c013fba7>] kthread+0x3b/0x64
 [<c0108eab>] kernel_thread_helper+0x7/0x10
 =======================
INFO: lockdep is turned off.
pdflush       S 000000A3     0   210      2 (L-TLB)
       c3350fa8 00000096 77efdd91 000000a3 00000000 c3350f90 c0216c13 c33c2bc0
       c33c2d50 c265c100 77efdd91 000000a3 00000000 c01670e4 c8205e00 00000046
       c3350f9c c05277e4 c0167042 c3350fc0 c0167042 00000000 c3350fd0 c01670e9
Call Trace:
 [<c01670e9>] pdflush+0xa7/0x194
 [<c013fba7>] kthread+0x3b/0x64
 [<c0108eab>] kernel_thread_helper+0x7/0x10
 =======================
INFO: lockdep is turned off.
pdflush       S 000000A3     0   211      2 (L-TLB)
       c33effa8 00000096 7b91b8b8 000000a3 00000000 c33eff90 c0216c13 c33c36b0
       c33c3840 c265c100 7b91b8b8 000000a3 00000000 c01670e4 c8205e00 00000046
       c33eff9c c05277e4 c0167042 c33effc0 c0167042 00000000 c33effd0 c01670e9
Call Trace:
 [<c01670e9>] pdflush+0xa7/0x194
 [<c013fba7>] kthread+0x3b/0x64
 [<c0108eab>] kernel_thread_helper+0x7/0x10
 =======================
INFO: lockdep is turned off.
kswapd0       S 000000A1     0   212      2 (L-TLB)
       c33eef44 00000092 cb3a0bc8 000000a1 c33eef1c c014b438 c013fdee c33c41a0
       c33c4330 c265c100 cb3a0bc8 000000a1 00000000 00000296 c3988a00 c0526efc
       c33eef44 c013fdee 00000296 00000001 ffffffff c0526700 c33eefd0 c016a3b1
Call Trace:
 [<c016a3b1>] kswapd+0xc7/0x3fa
 [<c013fba7>] kthread+0x3b/0x64
 [<c0108eab>] kernel_thread_helper+0x7/0x10
 =======================
INFO: lockdep is turned off.
kprefetchd    S 00000000     0   213      2 (L-TLB)
       c3370fa4 00000092 2181b982 00000000 c3370f6c 00000296 c265c100 c33c4c90
       c33c4e20 c265c100 2181b982 00000000 00000000 c33c4c90 c0514180 c265c100
       c265c138 c265c138 00000296 00000000 c0178f82 00000000 c3370fd0 c017900a
Call Trace:
 [<c017900a>] kprefetchd+0x88/0x34e
 [<c013fba7>] kthread+0x3b/0x64
 [<c0108eab>] kernel_thread_helper+0x7/0x10
 =======================
INFO: lockdep is turned off.
aio/0         S 00000000     0   306      2 (L-TLB)
       c33fafac 00000096 230b2f58 00000000 c33faf84 c014b598 c013fdee c33c15e0
       c33c1770 c265c100 230b2f58 00000000 00000000 00000282 c0514180 c33ff7b4
       c33fafac c013fdee 00000282 c33ff790 c013d0c1 c33fafc8 c33fafd0 c013d149
Call Trace:
 [<c013d149>] worker_thread+0x88/0xc7
 [<c013fba7>] kthread+0x3b/0x64
 [<c0108eab>] kernel_thread_helper+0x7/0x10
 =======================
INFO: lockdep is turned off.
khvcd         S 00000000     0   403      2 (L-TLB)
       c3325fc0 00000086 247bd613 00000000 c327d258 c327cc90 c327d250 c327cc90
       c327ce20 c265c100 247bd613 00000000 00000000 c0275212 c0514180 00000246
       c3325fb4 c0216abf c0540a00 c05409d4 00000000 00000000 c3325fd0 c027524a
Call Trace:
 [<c027524a>] khvcd+0xb7/0x101
 [<c013fba7>] kthread+0x3b/0x64
 [<c0108eab>] kernel_thread_helper+0x7/0x10
 =======================
INFO: lockdep is turned off.
scsi_eh_0     S 00000000     0   442      2 (L-TLB)
       c333af7c 00000096 301304b3 00000000 c333af40 c33b8040 00000296 c33c0000
       c33c0190 c265c100 301304b3 00000000 00000000 00000000 c0514180 00000292
       c33b8000 00000000 c333af7c 00000292 c33b8000 00000000 c333afd0 c0295125
Call Trace:
 [<c0295125>] scsi_error_handler+0x30/0x27d
 [<c013fba7>] kthread+0x3b/0x64
 [<c0108eab>] kernel_thread_helper+0x7/0x10
 =======================
INFO: lockdep is turned off.
scsi_eh_1     S 000000A2     0   444      2 (L-TLB)
       c333cf7c 00000096 dc3a448e 000000a2 c020406b c333cf40 c02872f1 c33c5780
       c33c5910 c265c100 dc3a448e 000000a2 00000000 c33b94f0 c8207200 c33b94f0
       c33b8430 00000000 c333cf7c 00000292 c33b8430 00000000 c333cfd0 c0295125
Call Trace:
 [<c0295125>] scsi_error_handler+0x30/0x27d
 [<c013fba7>] kthread+0x3b/0x64
 [<c0108eab>] kernel_thread_helper+0x7/0x10
 =======================
INFO: lockdep is turned off.
kpsmoused     S 00000000     0   472      2 (L-TLB)
       c33a9fac 00000096 347350c3 00000000 c33a9f84 c014b598 c013fdee c285cc90
       c285ce20 c265c100 347350c3 00000000 00000000 00000282 c0514180 c3283024
       c33a9fac c013fdee 00000282 c3283000 c013d0c1 c33a9fc8 c33a9fd0 c013d149
Call Trace:
 [<c013d149>] worker_thread+0x88/0xc7
 [<c013fba7>] kthread+0x3b/0x64
 [<c0108eab>] kernel_thread_helper+0x7/0x10
 =======================
INFO: lockdep is turned off.
kondemand/0   S 000000A7     0   479      2 (L-TLB)
       c3333fac 00000096 b4ff88e8 000000a7 c3333f84 c014b438 c013fdee c3278000
       c3278190 c265c100 b4ff88e8 000000a7 00000000 00000282 c8205e00 c32830d4
       c3333fac c013fdee 00000282 c32830b0 c013d0c1 c3333fc8 c3333fd0 c013d149
Call Trace:
 [<c013d149>] worker_thread+0x88/0xc7
 [<c013fba7>] kthread+0x3b/0x64
 [<c0108eab>] kernel_thread_helper+0x7/0x10
 =======================
INFO: lockdep is turned off.
ksuspend_usbd S 00000034     0  1067      2 (L-TLB)
       c299ffac 00000096 3d64711b 00000034 c299ff84 c014b438 c013fdee c29f4c90
       c29f4e20 c265c100 3d64711b 00000034 00000000 00000282 c32bb700 c3365914
       c299ffac c013fdee 00000282 c33658f0 c013d0c1 c299ffc8 c299ffd0 c013d149
Call Trace:
 [<c013d149>] worker_thread+0x88/0xc7
 [<c013fba7>] kthread+0x3b/0x64
 [<c0108eab>] kernel_thread_helper+0x7/0x10
 =======================
INFO: lockdep is turned off.
khubd         S 00000034     0  1073      2 (L-TLB)
       c3839f34 00000092 1484c7e3 00000034 c3839f0c c014b438 c013fdee c29f6d60
       c29f6ef0 c265c100 1484c7e3 00000034 00000000 00000292 c7f13200 f8874c40
       c3839f34 c013fdee 00000292 f8874c1c c32af6b0 c3839fb8 c3839fd0 f8859ab4
Call Trace:
 [<f8859ab4>] hub_thread+0x9ec/0xa57 [usbcore]
 [<c013fba7>] kthread+0x3b/0x64
 [<c0108eab>] kernel_thread_helper+0x7/0x10
 =======================
INFO: lockdep is turned off.
kjournald     S 000000A3     0  1348      2 (L-TLB)
       c2994fa0 00000086 783f51b0 000000a3 c2994f78 c014b438 c013fdee c29f41a0
       c29f4330 c265c100 783f51b0 000000a3 00000000 c01d61d7 c8205e00 00000246
       c2994f94 c0216abf c38a90d4 c38a90d4 c38a90c0 c2994fc4 c2994fd0 c01d61dc
Call Trace:
 [<c01d61dc>] kjournald+0x169/0x1e8
 [<c013fba7>] kthread+0x3b/0x64
 [<c0108eab>] kernel_thread_helper+0x7/0x10
 =======================
INFO: lockdep is turned off.
udevd         D 000000A3     0  1510      1 (NOTLB)
       c388feac 00000096 1068e677 000000a3 00000000 c388fe94 c0216c13 c29f20d0
       c29f2260 c265c100 1068e677 000000a3 00000000 c0157c10 c32b8000 00000046
       c388fea0 c29dbc04 00000000 00000000 00000000 00000000 c388feb8 c0157c3d
Call Trace:
 [<c0157c3d>] refrigerator+0xcb/0xda
 [<c0138d38>] get_signal_to_deliver+0x33/0x463
 [<c01077ea>] do_notify_resume+0x94/0x732
 [<c01082f9>] work_notifysig+0x13/0x1a
 [<ffffe410>] 0xffffe410
 =======================
INFO: lockdep is turned off.
tifm          S 00000002     0  1912      2 (L-TLB)
       c32b1fac 00000096 328602e7 00000002 c32b1f84 c014b598 c013fdee c3942bc0
       c3942d50 c265c100 328602e7 00000002 00000000 00000282 c32b8f00 c325fd34
       c32b1fac c013fdee 00000282 c325fd10 c013d0c1 c32b1fc8 c32b1fd0 c013d149
Call Trace:
 [<c013d149>] worker_thread+0x88/0xc7
 [<c013fba7>] kthread+0x3b/0x64
 [<c0108eab>] kernel_thread_helper+0x7/0x10
 =======================
INFO: lockdep is turned off.
kmmcd         S 00000002     0  1939      2 (L-TLB)
       c395ffac 00000096 590b1ca2 00000002 c395ff84 c014b598 c013fdee c3944c90
       c3944e20 c265c100 590b1ca2 00000002 00000000 00000282 c398b200 c325fc84
       c395ffac c013fdee 00000282 c325fc60 c013d0c1 c395ffc8 c395ffd0 c013d149
Call Trace:
 [<c013d149>] worker_thread+0x88/0xc7
 [<c013fba7>] kthread+0x3b/0x64
 [<c0108eab>] kernel_thread_helper+0x7/0x10
 =======================
INFO: lockdep is turned off.
pccardd       S 00000002     0  2019      2 (L-TLB)
       c39aff9c 00000092 566b6848 00000002 c39441a0 c3944760 00000000 c39441a0
       c3944330 c265c100 566b6848 00000002 00000000 c38a74d0 c32ba800 c39aff8c
       c38a74c0 00000296 c39aff9c c38a74c0 c38a72e0 00000000 c39affd0 f897ab30
Call Trace:
 [<f897ab30>] pccardd+0x1a7/0x1f3 [pcmcia_core]
 [<c013fba7>] kthread+0x3b/0x64
 [<c0108eab>] kernel_thread_helper+0x7/0x10
 =======================
INFO: lockdep is turned off.
kjournald     S 00000049     0  2291      2 (L-TLB)
       c39a7fa0 00000086 76a760f1 00000049 c39a7f78 c014b438 c013fdee c3976270
       c3976400 c265c100 76a760f1 00000049 00000000 c01d61d7 c7f12080 00000246
       c39a7f94 c0216abf c3a2e494 c3a2e494 c3a2e480 c39a7fc4 c39a7fd0 c01d61dc
Call Trace:
 [<c01d61dc>] kjournald+0x169/0x1e8
 [<c013fba7>] kthread+0x3b/0x64
 [<c0108eab>] kernel_thread_helper+0x7/0x10
 =======================
INFO: lockdep is turned off.
kjournald     S 0000004C     0  2292      2 (L-TLB)
       c3a6dfa0 00000086 3f284f6c 0000004c c3a6df78 c014b438 c013fdee c39720d0
       c3972260 c265c100 3f284f6c 0000004c 00000000 c01d61d7 c8204a00 00000246
       c3a6df94 c0216abf c3a2ecf4 c3a2ecf4 c3a2ece0 c3a6dfc4 c3a6dfd0 c01d61dc
Call Trace:
 [<c01d61dc>] kjournald+0x169/0x1e8
 [<c013fba7>] kthread+0x3b/0x64
 [<c0108eab>] kernel_thread_helper+0x7/0x10
 =======================
INFO: lockdep is turned off.
kjournald     S 000000A1     0  2295      2 (L-TLB)
       c3929fa0 00000086 783f7bac 000000a1 c3929f78 c014b438 c013fdee c3975780
       c3975910 c265c100 783f7bac 000000a1 00000000 c01d61d7 c7cc2800 00000246
       c3929f94 c0216abf c3a2f984 c3a2f984 c3a2f970 c3929fc4 c3929fd0 c01d61dc
Call Trace:
 [<c01d61dc>] kjournald+0x169/0x1e8
 [<c013fba7>] kthread+0x3b/0x64
 [<c0108eab>] kernel_thread_helper+0x7/0x10
 =======================
INFO: lockdep is turned off.
kjournald     S 00000004     0  2296      2 (L-TLB)
       c3867fa0 00000086 9dc344ae 00000004 c3971ba8 c39715e0 c3971ba0 c39715e0
       c3971770 c265c100 9dc344ae 00000004 00000000 c01d61d7 c3988c80 00000246
       c3867f94 c0216abf c38aa5c4 c38aa5c4 c38aa5b0 c3867fc4 c3867fd0 c01d61dc
Call Trace:
 [<c01d61dc>] kjournald+0x169/0x1e8
 [<c013fba7>] kthread+0x3b/0x64
 [<c0108eab>] kernel_thread_helper+0x7/0x10
 =======================
INFO: lockdep is turned off.
getty         D 000000A3     0  2604      1 (NOTLB)
       c3a02eac 00000096 1077fa47 000000a3 00000000 c3a02e94 c0216c13 c293d780
       c293d910 c265c100 1077fa47 000000a3 00000000 c0157c10 c398b980 00000046
       c3a02ea0 c39de284 0804b214 00000000 0804b214 bfb5d8f8 c3a02eb8 c0157c3d
Call Trace:
 [<c0157c3d>] refrigerator+0xcb/0xda
 [<c0138d38>] get_signal_to_deliver+0x33/0x463
 [<c01077ea>] do_notify_resume+0x94/0x732
 [<c01082f9>] work_notifysig+0x13/0x1a
 [<ffffe410>] 0xffffe410
 =======================
INFO: lockdep is turned off.
getty         D 000000A3     0  2605      1 (NOTLB)
       c84f6eac 00000096 1077e3da 000000a3 00000000 c84f6e94 c0216c13 c293abc0
       c293ad50 c265c100 1077e3da 000000a3 00000000 c0157c10 c3988780 00000046
       c84f6ea0 c39ded84 0804b214 00000000 0804b214 bf8e2678 c84f6eb8 c0157c3d
Call Trace:
 [<c0157c3d>] refrigerator+0xcb/0xda
 [<c0138d38>] get_signal_to_deliver+0x33/0x463
 [<c01077ea>] do_notify_resume+0x94/0x732
 [<c01082f9>] work_notifysig+0x13/0x1a
 [<ffffe410>] 0xffffe410
 =======================
INFO: lockdep is turned off.
login         D 000000A3     0  2609      1 (NOTLB)
       c339beac 00000096 1077cf85 000000a3 00000000 c339be94 c0216c13 c3946d60
       c3946ef0 c265c100 1077cf85 000000a3 00000000 c0157c10 c8205400 00000046
       c339bea0 c39dbc04 00000000 00000000 00000000 b7ee3ff4 c339beb8 c0157c3d
Call Trace:
 [<c0157c3d>] refrigerator+0xcb/0xda
 [<c0138d38>] get_signal_to_deliver+0x33/0x463
 [<c01077ea>] do_notify_resume+0x94/0x732
 [<c01082f9>] work_notifysig+0x13/0x1a
 [<ffffe410>] 0xffffe410
 =======================
INFO: lockdep is turned off.
login         D 000000A3     0  2610      1 (NOTLB)
       c39e5eac 00000096 1077be32 000000a3 00000000 c39e5e94 c0216c13 c3940000
       c3940190 c265c100 1077be32 000000a3 00000000 c0157c10 c8204000 00000046
       c39e5ea0 c39da084 00000000 00000000 00000000 b7f7dff4 c39e5eb8 c0157c3d
Call Trace:
 [<c0157c3d>] refrigerator+0xcb/0xda
 [<c0138d38>] get_signal_to_deliver+0x33/0x463
 [<c01077ea>] do_notify_resume+0x94/0x732
 [<c01082f9>] work_notifysig+0x13/0x1a
 [<ffffe410>] 0xffffe410
 =======================
INFO: lockdep is turned off.
login         D 000000A3     0  2611      1 (NOTLB)
       c39a3eac 00000096 1077af2f 000000a3 00000000 c39a3e94 c0216c13 c3945780
       c3945910 c265c100 1077af2f 000000a3 00000000 c0157c10 c8204500 00000046
       c39a3ea0 c39da604 00000000 00000000 00000000 b7eb9ff4 c39a3eb8 c0157c3d
Call Trace:
 [<c0157c3d>] refrigerator+0xcb/0xda
 [<c0138d38>] get_signal_to_deliver+0x33/0x463
 [<c01077ea>] do_notify_resume+0x94/0x732
 [<c01082f9>] work_notifysig+0x13/0x1a
 [<ffffe410>] 0xffffe410
 =======================
INFO: lockdep is turned off.
getty         D 000000A3     0  2612      1 (NOTLB)
       c903ceac 00000096 10779f13 000000a3 00000000 c903ce94 c0216c13 c293ed60
       c293eef0 c265c100 10779f13 000000a3 00000000 c0157c10 c398b700 00000046
       c903cea0 c39dd784 0804b214 00000000 0804b214 bfd4b2d8 c903ceb8 c0157c3d
Call Trace:
 [<c0157c3d>] refrigerator+0xcb/0xda
 [<c0138d38>] get_signal_to_deliver+0x33/0x463
 [<c01077ea>] do_notify_resume+0x94/0x732
 [<c01082f9>] work_notifysig+0x13/0x1a
 [<ffffe410>] 0xffffe410
 =======================
INFO: lockdep is turned off.
acpid         D 000000A3     0  2777      1 (NOTLB)
       c3998eac 00000096 1077899d 000000a3 00000000 c3998e94 c0216c13 c327abc0
       c327ad50 c265c100 1077899d 000000a3 00000000 c0157c10 c398ad00 00000046
       c3998ea0 c29dc184 b7fd5ce0 00000000 b7fd5ce0 b7fa5ff4 c3998eb8 c0157c3d
Call Trace:
 [<c0157c3d>] refrigerator+0xcb/0xda
 [<c0138d38>] get_signal_to_deliver+0x33/0x463
 [<c01077ea>] do_notify_resume+0x94/0x732
 [<c01082f9>] work_notifysig+0x13/0x1a
 [<ffffe410>] 0xffffe410
 =======================
INFO: lockdep is turned off.
syslogd       D 000000A3     0  2851      1 (NOTLB)
       c3955eac 00000096 107768a8 000000a3 00000000 c3955e94 c0216c13 c327d780
       c327d910 c265c100 107768a8 000000a3 00000000 c0157c10 c398a080 00000046
       c3955ea0 c29dab84 00000000 00000000 00000000 00000000 c3955eb8 c0157c3d
Call Trace:
 [<c0157c3d>] refrigerator+0xcb/0xda
 [<c0138d38>] get_signal_to_deliver+0x33/0x463
 [<c01077ea>] do_notify_resume+0x94/0x732
 [<c01082f9>] work_notifysig+0x13/0x1a
 [<ffffe410>] 0xffffe410
 =======================
INFO: lockdep is turned off.
dd            D 000000A3     0  2901      1 (NOTLB)
       c3b72eac 00000096 1078a5dc 000000a3 00000000 c3b72e94 c0216c13 c3970af0
       c3970c80 c265c100 1078a5dc 000000a3 00000000 c0157c10 c398b200 00000046
       c3b72ea0 c29df304 00000001 00000000 00000001 08053000 c3b72eb8 c0157c3d
Call Trace:
 [<c0157c3d>] refrigerator+0xcb/0xda
 [<c0138d38>] get_signal_to_deliver+0x33/0x463
 [<c01077ea>] do_notify_resume+0x94/0x732
 [<c01082f9>] work_notifysig+0x13/0x1a
 [<ffffe410>] 0xffffe410
 =======================
INFO: lockdep is turned off.
klogd         D 000000A3     0  2903      1 (NOTLB)
       c903deac 00000096 107753d5 000000a3 00000000 c903de94 c0216c13 c327b6b0
       c327b840 c265c100 107753d5 000000a3 00000000 c0157c10 c398a580 00000046
       c903dea0 c29df884 00000400 00000000 00000400 00000000 c903deb8 c0157c3d
Call Trace:
 [<c0157c3d>] refrigerator+0xcb/0xda
 [<c0138d38>] get_signal_to_deliver+0x33/0x463
 [<c01077ea>] do_notify_resume+0x94/0x732
 [<c01082f9>] work_notifysig+0x13/0x1a
 [<ffffe410>] 0xffffe410
 =======================
INFO: lockdep is turned off.
dbus-daemon   D 000000A3     0  2924      1 (NOTLB)
       c3b73eac 00000096 107741f3 000000a3 00000000 c3b73e94 c0216c13 c327a0d0
       c327a260 c265c100 107741f3 000000a3 00000000 c0157c10 c3989b80 00000046
       c3b73ea0 c29dd784 080c0b30 00000000 080c0b30 b7eb4ff4 c3b73eb8 c0157c3d
Call Trace:
 [<c0157c3d>] refrigerator+0xcb/0xda
 [<c0138d38>] get_signal_to_deliver+0x33/0x463
 [<c01077ea>] do_notify_resume+0x94/0x732
 [<c01082f9>] work_notifysig+0x13/0x1a
 [<ffffe410>] 0xffffe410
 =======================
INFO: lockdep is turned off.
NetworkManage D 000000A3     0  2943      1 (NOTLB)
       c39c8eac 00000096 1076e72c 000000a3 00000000 c39c8e94 c0216c13 c3972bc0
       c3972d50 c265c100 1076e72c 000000a3 00000000 c0157c10 c398aa80 00000046
       c39c8ea0 c29dc704 0001d22b 00000000 0001d22b b7ccfff4 c39c8eb8 c0157c3d
Call Trace:
 [<c0157c3d>] refrigerator+0xcb/0xda
 [<c0138d38>] get_signal_to_deliver+0x33/0x463
 [<c01077ea>] do_notify_resume+0x94/0x732
 [<c01082f9>] work_notifysig+0x13/0x1a
 [<ffffe410>] 0xffffe410
 =======================
INFO: lockdep is turned off.
NetworkManage D 000000A3     0  4536      1 (NOTLB)
       c7f2eeac 00000096 1076be5b 000000a3 00000000 c7f2ee94 c0216c13 c7fb36b0
       c7fb3840 c265c100 1076be5b 000000a3 00000000 c0157c10 c398aa80 00000046
       c7f2eea0 c29dc704 b7cddb70 00000000 b7cddb70 0808e958 c7f2eeb8 c0157c3d
Call Trace:
 [<c0157c3d>] refrigerator+0xcb/0xda
 [<c0138d38>] get_signal_to_deliver+0x33/0x463
 [<c01077ea>] do_notify_resume+0x94/0x732
 [<c01082f9>] work_notifysig+0x13/0x1a
 [<ffffe410>] 0xffffe410
 =======================
INFO: lockdep is turned off.
NetworkManage D 000000A3     0  2956      1 (NOTLB)
       c63e1eac 00000096 1076ad4f 000000a3 00000000 c63e1e94 c0216c13 c2938af0
       c2938c80 c265c100 1076ad4f 000000a3 00000000 c0157c10 c398bc00 00000046
       c63e1ea0 c29da604 ffffffff 00000000 ffffffff b7df3ff4 c63e1eb8 c0157c3d
Call Trace:
 [<c0157c3d>] refrigerator+0xcb/0xda
 [<c0138d38>] get_signal_to_deliver+0x33/0x463
 [<c01077ea>] do_notify_resume+0x94/0x732
 [<c01082f9>] work_notifysig+0x13/0x1a
 [<ffffe410>] 0xffffe410
 =======================
INFO: lockdep is turned off.
system-tools- D 000000A3     0  2969      1 (NOTLB)
       c84feeac 00000096 10769253 000000a3 00000000 c84fee94 c0216c13 c293c1a0
       c293c330 c265c100 10769253 000000a3 00000000 c0157c10 c398a800 00000046
       c84feea0 c29d9584 ffffffff 00000000 ffffffff b7dfbff4 c84feeb8 c0157c3d
Call Trace:
 [<c0157c3d>] refrigerator+0xcb/0xda
 [<c0138d38>] get_signal_to_deliver+0x33/0x463
 [<c01077ea>] do_notify_resume+0x94/0x732
 [<c01082f9>] work_notifysig+0x13/0x1a
 [<ffffe410>] 0xffffe410
 =======================
INFO: lockdep is turned off.
dbus-daemon   D 000000A3     0  2970   2969 (NOTLB)
       c84ffeac 00000096 107623df 000000a3 00000000 c84ffe94 c0216c13 c3278af0
       c3278c80 c265c100 107623df 000000a3 00000000 c0157c10 c3988500 00000046
       c84ffea0 c29db684 08093650 00000000 08093650 b7f31ff4 c84ffeb8 c0157c3d
Call Trace:
 [<c0157c3d>] refrigerator+0xcb/0xda
 [<c0138d38>] get_signal_to_deliver+0x33/0x463
 [<c01077ea>] do_notify_resume+0x94/0x732
 [<c01082f9>] work_notifysig+0x13/0x1a
 [<ffffe410>] 0xffffe410
 =======================
INFO: lockdep is turned off.
gdm           D 000000A3     0  2992      1 (NOTLB)
       c3a23eac 00000096 10760784 000000a3 00000000 c3a23e94 c0216c13 c32795e0
       c3279770 c265c100 10760784 000000a3 00000000 c0157c10 c3989680 00000046
       c3a23ea0 c29de804 ffffffff 00000000 ffffffff b7740ff4 c3a23eb8 c0157c3d
Call Trace:
 [<c0157c3d>] refrigerator+0xcb/0xda
 [<c0138d38>] get_signal_to_deliver+0x33/0x463
 [<c01077ea>] do_notify_resume+0x94/0x732
 [<c01082f9>] work_notifysig+0x13/0x1a
 [<ffffe410>] 0xffffe410
 =======================
INFO: lockdep is turned off.
gdm           D 000000A3     0  2993   2992 (NOTLB)
       c8feeeac 00000096 1075e727 000000a3 00000000 c8feee94 c0216c13 c327ed60
       c327eef0 c265c100 1075e727 000000a3 00000000 c0157c10 c398b480 00000046
       c8feeea0 c29dd204 00000000 00000000 00000000 00000000 c8feeeb8 c0157c3d
Call Trace:
 [<c0157c3d>] refrigerator+0xcb/0xda
 [<c0138d38>] get_signal_to_deliver+0x33/0x463
 [<c01077ea>] do_notify_resume+0x94/0x732
 [<c01082f9>] work_notifysig+0x13/0x1a
 [<ffffe410>] 0xffffe410
 =======================
INFO: lockdep is turned off.
Xorg          D 000000A3     0  3008   2993 (NOTLB)
       c329eeac 00000096 107678e6 000000a3 00000000 c329ee94 c0216c13 c39436b0
       c3943840 c265c100 107678e6 000000a3 00000000 c0157c10 c3988a00 00000046
       c329eea0 c29de284 00000000 00000000 00000000 00000000 c329eeb8 c0157c3d
Call Trace:
 [<c0157c3d>] refrigerator+0xcb/0xda
 [<c0138d38>] get_signal_to_deliver+0x33/0x463
 [<c01077ea>] do_notify_resume+0x94/0x732
 [<c01082f9>] work_notifysig+0x13/0x1a
 [<ffffe410>] 0xffffe410
 =======================
INFO: lockdep is turned off.
cupsd         D 000000A3     0  3029      1 (NOTLB)
       c329feac 00000096 1075cc44 000000a3 00000000 c329fe94 c0216c13 c29f2bc0
       c29f2d50 c265c100 1075cc44 000000a3 00000000 c0157c10 c3989e00 00000046
       c329fea0 c29d9004 00000000 00000000 00000000 bfec498c c329feb8 c0157c3d
Call Trace:
 [<c0157c3d>] refrigerator+0xcb/0xda
 [<c0138d38>] get_signal_to_deliver+0x33/0x463
 [<c01077ea>] do_notify_resume+0x94/0x732
 [<c01082f9>] work_notifysig+0x13/0x1a
 [<ffffe410>] 0xffffe410
 =======================
INFO: lockdep is turned off.
hpiod         D 000000A3     0  3057      1 (NOTLB)
       c3987eac 00200096 1075950b 000000a3 00000000 c3987e94 c0216c13 c29f6270
       c29f6400 c265c100 1075950b 000000a3 00000000 c0157c10 c32b8a00 00200046
       c3987ea0 c29db104 08063190 00000000 08063190 00000000 c3987eb8 c0157c3d
Call Trace:
 [<c0157c3d>] refrigerator+0xcb/0xda
 [<c0138d38>] get_signal_to_deliver+0x33/0x463
 [<c01077ea>] do_notify_resume+0x94/0x732
 [<c01082f9>] work_notifysig+0x13/0x1a
 [<ffffe410>] 0xffffe410
 =======================
INFO: lockdep is turned off.
python        D 000000A3     0  3060      1 (NOTLB)
       c6cedeac 00200096 10753fb5 000000a3 00000000 c6cede94 c0216c13 c29f5780
       c29f5910 c265c100 10753fb5 000000a3 00000000 c0157c10 c32ba800 00200046
       c6cedea0 c29ded84 bf8e2428 00000000 bf8e2428 bf8e25a8 c6cedeb8 c0157c3d
Call Trace:
 [<c0157c3d>] refrigerator+0xcb/0xda
 [<c0138d38>] get_signal_to_deliver+0x33/0x463
 [<c01077ea>] do_notify_resume+0x94/0x732
 [<c01082f9>] work_notifysig+0x13/0x1a
 [<ffffe410>] 0xffffe410
 =======================
INFO: lockdep is turned off.
ledd          D 000000A3     0  3136      1 (NOTLB)
       c67e4eac 00000096 1075a65c 000000a3 00000000 c67e4e94 c0216c13 c3970000
       c3970190 c265c100 1075a65c 000000a3 00000000 c0157c10 c32bb700 00000046
       c67e4ea0 c39dd204 080504c8 00000000 080504c8 b7ebdff4 c67e4eb8 c0157c3d
Call Trace:
 [<c0157c3d>] refrigerator+0xcb/0xda
 [<c0138d38>] get_signal_to_deliver+0x33/0x463
 [<c01077ea>] do_notify_resume+0x94/0x732
 [<c01082f9>] work_notifysig+0x13/0x1a
 [<ffffe410>] 0xffffe410
 =======================
INFO: lockdep is turned off.
sh            D 000000A3     0  3137   3136 (NOTLB)
       c67e3eac 00000096 10752558 000000a3 00000000 c67e3e94 c0216c13 c39736b0
       c3973840 c265c100 10752558 000000a3 00000000 c0157c10 c32b9680 00000046
       c67e3ea0 c39df304 00000000 00000000 00000000 00000001 c67e3eb8 c0157c3d
Call Trace:
 [<c0157c3d>] refrigerator+0xcb/0xda
 [<c0138d38>] get_signal_to_deliver+0x33/0x463
 [<c01077ea>] do_notify_resume+0x94/0x732
 [<c01082f9>] work_notifysig+0x13/0x1a
 [<ffffe410>] 0xffffe410
 =======================
INFO: lockdep is turned off.
startup.sh    D 000000A3     0  3138   3137 (NOTLB)
       c67e2eac 00000096 1075177a 000000a3 00000000 c67e2e94 c0216c13 c33c6270
       c33c6400 c265c100 1075177a 000000a3 00000000 c0157c10 c32b9b80 00000046
       c67e2ea0 c39dab84 00000000 00000000 00000000 00000002 c67e2eb8 c0157c3d
Call Trace:
 [<c0157c3d>] refrigerator+0xcb/0xda
 [<c0138d38>] get_signal_to_deliver+0x33/0x463
 [<c01077ea>] do_notify_resume+0x94/0x732
 [<c01082f9>] work_notifysig+0x13/0x1a
 [<ffffe410>] 0xffffe410
 =======================
INFO: lockdep is turned off.
nasd          D 000000A3     0  3149      1 (NOTLB)
       c9010eac 00000096 1068c657 000000a3 00000000 c9010e94 c0216c13 c3974c90
       c3974e20 c265c100 1068c657 000000a3 00000000 c0157c10 c32b9400 00000046
       c9010ea0 c29dfe04 00000000 00000000 00000000 00000000 c9010eb8 c0157c3d
Call Trace:
 [<c0157c3d>] refrigerator+0xcb/0xda
 [<c0138d38>] get_signal_to_deliver+0x33/0x463
 [<c01077ea>] do_notify_resume+0x94/0x732
 [<c01082f9>] work_notifysig+0x13/0x1a
 [<ffffe410>] 0xffffe410
 =======================
INFO: lockdep is turned off.
powernowd     D 000000A3     0  3186      1 (NOTLB)
       c67e0eac 00000096 10791523 000000a3 00000000 c67e0e94 c0216c13 c33c20d0
       c33c2260 c265c100 10791523 000000a3 00000000 c0157c10 c32bbc00 00000046
       c67e0ea0 c29dcc84 00000065 00000000 00000065 00000000 c67e0eb8 c0157c3d
Call Trace:
 [<c0157c3d>] refrigerator+0xcb/0xda
 [<c0138d38>] get_signal_to_deliver+0x33/0x463
 [<c01077ea>] do_notify_resume+0x94/0x732
 [<c01082f9>] work_notifysig+0x13/0x1a
 [<ffffe410>] 0xffffe410
 =======================
INFO: lockdep is turned off.
avahi-daemon  D 000000A3     0  3238      1 (NOTLB)
       c67e1eac 00000096 107508b1 000000a3 00000000 c67e1e94 c0216c13 c39741a0
       c3974330 c265c100 107508b1 000000a3 00000000 c0157c10 c32bb200 00000046
       c67e1ea0 c338b684 08065fc0 00000000 08065fc0 b7eb6ff4 c67e1eb8 c0157c3d
Call Trace:
 [<c0157c3d>] refrigerator+0xcb/0xda
 [<c0138d38>] get_signal_to_deliver+0x33/0x463
 [<c01077ea>] do_notify_resume+0x94/0x732
 [<c01082f9>] work_notifysig+0x13/0x1a
 [<ffffe410>] 0xffffe410
 =======================
INFO: lockdep is turned off.
avahi-daemon  D 000000A3     0  3239   3238 (NOTLB)
       c67cdeac 00000096 1074d117 000000a3 00000000 c67cde94 c0216c13 c293e270
       c293e400 c265c100 1074d117 000000a3 00000000 c0157c10 c32b8f00 00000046
       c67cdea0 c338ed84 00000007 00000000 00000007 00000003 c67cdeb8 c0157c3d
Call Trace:
 [<c0157c3d>] refrigerator+0xcb/0xda
 [<c0138d38>] get_signal_to_deliver+0x33/0x463
 [<c01077ea>] do_notify_resume+0x94/0x732
 [<c01082f9>] work_notifysig+0x13/0x1a
 [<ffffe410>] 0xffffe410
 =======================
INFO: lockdep is turned off.
dhcdbd        D 000000A3     0  3253      1 (NOTLB)
       c67dbeac 00000096 1074bed6 000000a3 00000000 c67dbe94 c0216c13 c2886d60
       c2886ef0 c265c100 1074bed6 000000a3 00000000 c0157c10 c32b9900 00000046
       c67dbea0 c338e804 08067288 00000000 08067288 bf9a1674 c67dbeb8 c0157c3d
Call Trace:
 [<c0157c3d>] refrigerator+0xcb/0xda
 [<c0138d38>] get_signal_to_deliver+0x33/0x463
 [<c01077ea>] do_notify_resume+0x94/0x732
 [<c01082f9>] work_notifysig+0x13/0x1a
 [<ffffe410>] 0xffffe410
 =======================
INFO: lockdep is turned off.
hald          D 000000A3     0  3269      1 (NOTLB)
       c67d2eac 00000096 1074a556 000000a3 00000000 c67d2e94 c0216c13 c29f36b0
       c29f3840 c265c100 1074a556 000000a3 00000000 c0157c10 c32ba080 00000046
       c67d2ea0 c338e284 00000c14 00000000 00000c14 b7e32ff4 c67d2eb8 c0157c3d
Call Trace:
 [<c0157c3d>] refrigerator+0xcb/0xda
 [<c0138d38>] get_signal_to_deliver+0x33/0x463
 [<c01077ea>] do_notify_resume+0x94/0x732
 [<c01082f9>] work_notifysig+0x13/0x1a
 [<ffffe410>] 0xffffe410
 =======================
INFO: lockdep is turned off.
hald-runner   D 000000A3     0  3270   3269 (NOTLB)
       c67d1eac 00000096 10745819 000000a3 00000000 c67d1e94 c0216c13 c29f0af0
       c29f0c80 c265c100 10745819 000000a3 00000000 c0157c10 c32baf80 00000046
       c67d1ea0 c338dd04 ffffffff 00000000 ffffffff b7e2dff4 c67d1eb8 c0157c3d
Call Trace:
 [<c0157c3d>] refrigerator+0xcb/0xda
 [<c0138d38>] get_signal_to_deliver+0x33/0x463
 [<c01077ea>] do_notify_resume+0x94/0x732
 [<c01082f9>] work_notifysig+0x13/0x1a
 [<ffffe410>] 0xffffe410
 =======================
INFO: lockdep is turned off.
hald-addon-ke D 000000A3     0  3287   3270 (NOTLB)
       c7c1eeac 00000096 1078def0 000000a3 00000000 c7c1ee94 c0216c13 c28820d0
       c2882260 c265c100 1078def0 000000a3 00000000 c0157c10 c32bb480 00000046
       c7c1eea0 c338c704 0804e590 00000000 0804e590 0804e590 c7c1eeb8 c0157c3d
Call Trace:
 [<c0157c3d>] refrigerator+0xcb/0xda
 [<c0138d38>] get_signal_to_deliver+0x33/0x463
 [<c01077ea>] do_notify_resume+0x94/0x732
 [<c01082f9>] work_notifysig+0x13/0x1a
 [<ffffe410>] 0xffffe410
 =======================
INFO: lockdep is turned off.
hald-addon-cp D 000000A3     0  3289   3270 (NOTLB)
       c7c1aeac 00000096 1074445b 000000a3 00000000 c7c1ae94 c0216c13 c2880000
       c2880190 c265c100 1074445b 000000a3 00000000 c0157c10 c32b8500 00000046
       c7c1aea0 c338c184 ffffffff 00000000 ffffffff b7eb4ff4 c7c1aeb8 c0157c3d
Call Trace:
 [<c0157c3d>] refrigerator+0xcb/0xda
 [<c0138d38>] get_signal_to_deliver+0x33/0x463
 [<c01077ea>] do_notify_resume+0x94/0x732
 [<c01082f9>] work_notifysig+0x13/0x1a
 [<ffffe410>] 0xffffe410
 =======================
INFO: lockdep is turned off.
hald-addon-ac D 000000A3     0  3290   3270 (NOTLB)
       c67d7eac 00000096 10742b07 000000a3 00000000 c67d7e94 c0216c13 c327c1a0
       c327c330 c265c100 10742b07 000000a3 00000000 c0157c10 c32b9180 00000046
       c67d7ea0 c338fe04 08050888 00000000 08050888 b7f46001 c67d7eb8 c0157c3d
Call Trace:
 [<c0157c3d>] refrigerator+0xcb/0xda
 [<c0138d38>] get_signal_to_deliver+0x33/0x463
 [<c01077ea>] do_notify_resume+0x94/0x732
 [<c01082f9>] work_notifysig+0x13/0x1a
 [<ffffe410>] 0xffffe410
 =======================
INFO: lockdep is turned off.
hald-addon-ke D 000000A3     0  3294   3270 (NOTLB)
       c7c20eac 00000096 10741626 000000a3 00000000 c7c20e94 c0216c13 c28836b0
       c2883840 c265c100 10741626 000000a3 00000000 c0157c10 c32bb980 00000046
       c7c20ea0 c338f304 0804e498 00000000 0804e498 0804e498 c7c20eb8 c0157c3d
Call Trace:
 [<c0157c3d>] refrigerator+0xcb/0xda
 [<c0138d38>] get_signal_to_deliver+0x33/0x463
 [<c01077ea>] do_notify_resume+0x94/0x732
 [<c01082f9>] work_notifysig+0x13/0x1a
 [<ffffe410>] 0xffffe410
 =======================
INFO: lockdep is turned off.
hald-addon-ke D 000000A3     0  3296   3270 (NOTLB)
       c7c17eac 00000096 10740434 000000a3 00000000 c7c17e94 c0216c13 c33c6d60
       c33c6ef0 c265c100 10740434 000000a3 00000000 c0157c10 c32baa80 00000046
       c7c17ea0 c338bc04 0804e4d0 00000000 0804e4d0 0804e4d0 c7c17eb8 c0157c3d
Call Trace:
 [<c0157c3d>] refrigerator+0xcb/0xda
 [<c0138d38>] get_signal_to_deliver+0x33/0x463
 [<c01077ea>] do_notify_resume+0x94/0x732
 [<c01082f9>] work_notifysig+0x13/0x1a
 [<ffffe410>] 0xffffe410
 =======================
INFO: lockdep is turned off.
hald-addon-ke D 000000A3     0  3297   3270 (NOTLB)
       c7c13eac 00000096 1073f135 000000a3 00000000 c7c13e94 c0216c13 c39420d0
       c3942260 c265c100 1073f135 000000a3 00000000 c0157c10 c32bad00 00000046
       c7c13ea0 c338d204 0804e4a0 00000000 0804e4a0 0804e4a0 c7c13eb8 c0157c3d
Call Trace:
 [<c0157c3d>] refrigerator+0xcb/0xda
 [<c0138d38>] get_signal_to_deliver+0x33/0x463
 [<c01077ea>] do_notify_resume+0x94/0x732
 [<c01082f9>] work_notifysig+0x13/0x1a
 [<ffffe410>] 0xffffe410
 =======================
INFO: lockdep is turned off.
hald-addon-st D 000000A3     0  3309   3270 (NOTLB)
       c7c9deac 00000096 1073df27 000000a3 00000000 c7c9de94 c0216c13 c7c28000
       c7c28190 c265c100 1073df27 000000a3 00000000 c0157c10 c3988c80 00000046
       c7c9dea0 c338cc84 000007a5 00000000 000007a5 b7e12ff4 c7c9deb8 c0157c3d
Call Trace:
 [<c0157c3d>] refrigerator+0xcb/0xda
 [<c0138d38>] get_signal_to_deliver+0x33/0x463
 [<c01077ea>] do_notify_resume+0x94/0x732
 [<c01082f9>] work_notifysig+0x13/0x1a
 [<ffffe410>] 0xffffe410
 =======================
INFO: lockdep is turned off.
hcid          D 000000A3     0  3333      1 (NOTLB)
       c67ddeac 00000096 1073c83c 000000a3 00000000 c67dde94 c0216c13 c7c2d780
       c7c2d910 c265c100 1073c83c 000000a3 00000000 c0157c10 c32b8280 00000046
       c67ddea0 c338b104 ffffffff 00000000 ffffffff b7e56ff4 c67ddeb8 c0157c3d
Call Trace:
 [<c0157c3d>] refrigerator+0xcb/0xda
 [<c0138d38>] get_signal_to_deliver+0x33/0x463
 [<c01077ea>] do_notify_resume+0x94/0x732
 [<c01082f9>] work_notifysig+0x13/0x1a
 [<ffffe410>] 0xffffe410
 =======================
INFO: lockdep is turned off.
atd           D 000000A3     0  3405      1 (NOTLB)
       c39cceac 00000096 1073a13f 000000a3 00000000 c39cce94 c0216c13 c6ce2bc0
       c6ce2d50 c265c100 1073a13f 000000a3 00000000 c0157c10 c7cc0280 00000046
       c39ccea0 c3a81b04 bfe23314 00000000 bfe23314 00000000 c39cceb8 c0157c3d
Call Trace:
 [<c0157c3d>] refrigerator+0xcb/0xda
 [<c0138d38>] get_signal_to_deliver+0x33/0x463
 [<c01077ea>] do_notify_resume+0x94/0x732
 [<c01082f9>] work_notifysig+0x13/0x1a
 [<ffffe410>] 0xffffe410
 =======================
INFO: lockdep is turned off.
cron          D 000000A3     0  3425      1 (NOTLB)
       c7c70eac 00000096 10738dc2 000000a3 00000000 c7c70e94 c0216c13 c29f15e0
       c29f1770 c265c100 10738dc2 000000a3 00000000 c0157c10 c7cc0c80 00000046
       c7c70ea0 c3a83104 bf9080e4 00000000 bf9080e4 00000000 c7c70eb8 c0157c3d
Call Trace:
 [<c0157c3d>] refrigerator+0xcb/0xda
 [<c0138d38>] get_signal_to_deliver+0x33/0x463
 [<c01077ea>] do_notify_resume+0x94/0x732
 [<c01082f9>] work_notifysig+0x13/0x1a
 [<ffffe410>] 0xffffe410
 =======================
INFO: lockdep is turned off.
x-session-man D 000000A3     0  3555   2993 (NOTLB)
       c32b3eac 00200096 10737a32 000000a3 00000000 c32b3e94 c0216c13 c29f0000
       c29f0190 c265c100 10737a32 000000a3 00000000 c0157c10 c7cc2080 00200046
       c32b3ea0 c3a82b84 ffffffff 00000000 ffffffff b76d9ff4 c32b3eb8 c0157c3d
Call Trace:
 [<c0157c3d>] refrigerator+0xcb/0xda
 [<c0138d38>] get_signal_to_deliver+0x33/0x463
 [<c01077ea>] do_notify_resume+0x94/0x732
 [<c01082f9>] work_notifysig+0x13/0x1a
 [<ffffe410>] 0xffffe410
 =======================
INFO: lockdep is turned off.
x-session-man D 000000A3     0  3633   2993 (NOTLB)
       c7d03eac 00200096 10730f74 000000a3 00000000 c7d03e94 c0216c13 c7c2a0d0
       c7c2a260 c265c100 10730f74 000000a3 00000000 c0157c10 c7cc2080 00200046
       c7d03ea0 c3a82b84 b76e6b70 00000000 b76e6b70 b77b7874 c7d03eb8 c0157c3d
Call Trace:
 [<c0157c3d>] refrigerator+0xcb/0xda
 [<c0138d38>] get_signal_to_deliver+0x33/0x463
 [<c01077ea>] do_notify_resume+0x94/0x732
 [<c01082f9>] work_notifysig+0x13/0x1a
 [<ffffe410>] 0xffffe410
 =======================
INFO: lockdep is turned off.
ssh-agent     D 000000A3     0  3593   3555 (NOTLB)
       c7c4eeac 00200096 1072fd51 000000a3 00000000 c7c4ee94 c0216c13 c6ce0af0
       c6ce0c80 c265c100 1072fd51 000000a3 00000000 c0157c10 c7cc1680 00200046
       c7c4eea0 c3a84184 00000000 00000000 00000000 bfbfdc2c c7c4eeb8 c0157c3d
Call Trace:
 [<c0157c3d>] refrigerator+0xcb/0xda
 [<c0138d38>] get_signal_to_deliver+0x33/0x463
 [<c01077ea>] do_notify_resume+0x94/0x732
 [<c01082f9>] work_notifysig+0x13/0x1a
 [<ffffe410>] 0xffffe410
 =======================
INFO: lockdep is turned off.
gconfd-2      D 000000A3     0  3595      1 (NOTLB)
       c7c3feac 00200096 1072e5bd 000000a3 00000000 c7c3fe94 c0216c13 c6ce5780
       c6ce5910 c265c100 1072e5bd 000000a3 00000000 c0157c10 c7cc1900 00200046
       c7c3fea0 c3a81584 00005e99 00000000 00005e99 b7e25ff4 c7c3feb8 c0157c3d
Call Trace:
 [<c0157c3d>] refrigerator+0xcb/0xda
 [<c0138d38>] get_signal_to_deliver+0x33/0x463
 [<c01077ea>] do_notify_resume+0x94/0x732
 [<c01082f9>] work_notifysig+0x13/0x1a
 [<ffffe410>] 0xffffe410
 =======================
INFO: lockdep is turned off.
gnome-keyring D 000000A3     0  3598      1 (NOTLB)
       c7c5beac 00200096 1071f4f7 000000a3 00000000 c7c5be94 c0216c13 c6ce0000
       c6ce0190 c265c100 1071f4f7 000000a3 00000000 c0157c10 c7cc1b80 00200046
       c7c5bea0 c3a83684 ffffffff 00000000 ffffffff b7da6ff4 c7c5beb8 c0157c3d
Call Trace:
 [<c0157c3d>] refrigerator+0xcb/0xda
 [<c0138d38>] get_signal_to_deliver+0x33/0x463
 [<c01077ea>] do_notify_resume+0x94/0x732
 [<c01082f9>] work_notifysig+0x13/0x1a
 [<ffffe410>] 0xffffe410
 =======================
INFO: lockdep is turned off.
dbus-daemon   D 000000A3     0  3600      1 (NOTLB)
       c7c40eac 00200096 1071dad7 000000a3 00000000 c7c40e94 c0216c13 c6ce6270
       c6ce6400 c265c100 1071dad7 000000a3 00000000 c0157c10 c7cc0000 00200046
       c7c40ea0 c3a84c84 080b06f0 00000000 080b06f0 b7f0fff4 c7c40eb8 c0157c3d
Call Trace:
 [<c0157c3d>] refrigerator+0xcb/0xda
 [<c0138d38>] get_signal_to_deliver+0x33/0x463
 [<c01077ea>] do_notify_resume+0x94/0x732
 [<c01082f9>] work_notifysig+0x13/0x1a
 [<ffffe410>] 0xffffe410
 =======================
INFO: lockdep is turned off.
gnome-setting D 000000A3     0  3602      1 (NOTLB)
       c7c19eac 00000096 10718bc9 000000a3 00000000 c7c19e94 c0216c13 c6ce4c90
       c6ce4e20 c265c100 10718bc9 000000a3 00000000 c0157c10 c7cc1400 00000046
       c7c19ea0 c3a84704 00000d6f 00000000 00000d6f b75cbff4 c7c19eb8 c0157c3d
Call Trace:
 [<c0157c3d>] refrigerator+0xcb/0xda
 [<c0138d38>] get_signal_to_deliver+0x33/0x463
 [<c01077ea>] do_notify_resume+0x94/0x732
 [<c01082f9>] work_notifysig+0x13/0x1a
 [<ffffe410>] 0xffffe410
 =======================
INFO: lockdep is turned off.
gnome-setting D 000000A3     0  3605      1 (NOTLB)
       c7ce2eac 00200096 107152bd 000000a3 00000000 c7ce2e94 c0216c13 c3976d60
       c3976ef0 c265c100 107152bd 000000a3 00000000 c0157c10 c7cc1400 00200046
       c7ce2ea0 c3a84704 b75d8b70 00000000 b75d8b70 b77e4874 c7ce2eb8 c0157c3d
Call Trace:
 [<c0157c3d>] refrigerator+0xcb/0xda
 [<c0138d38>] get_signal_to_deliver+0x33/0x463
 [<c01077ea>] do_notify_resume+0x94/0x732
 [<c01082f9>] work_notifysig+0x13/0x1a
 [<ffffe410>] 0xffffe410
 =======================
INFO: lockdep is turned off.
sh            D 000000A3     0  3618      1 (NOTLB)
       c7ce3eac 00200096 10710883 000000a3 00000000 c7ce3e94 c0216c13 c7c28af0
       c7c28c80 c265c100 10710883 000000a3 00000000 c0157c10 c7cc1180 00200046
       c7ce3ea0 c3a80504 00000000 00000000 00000000 00000007 c7ce3eb8 c0157c3d
Call Trace:
 [<c0157c3d>] refrigerator+0xcb/0xda
 [<c0138d38>] get_signal_to_deliver+0x33/0x463
 [<c01077ea>] do_notify_resume+0x94/0x732
 [<c01082f9>] work_notifysig+0x13/0x1a
 [<ffffe410>] 0xffffe410
 =======================
INFO: lockdep is turned off.
esd           D 000000A3     0  3619   3618 (NOTLB)
       c8fd3eac 00200096 1070fc2d 000000a3 00000000 c8fd3e94 c0216c13 c7c2e270
       c7c2e400 c265c100 1070fc2d 000000a3 00000000 c0157c10 c7cc2300 00200046
       c8fd3ea0 c3a85784 00000000 00000000 00000000 00000000 c8fd3eb8 c0157c3d
Call Trace:
 [<c0157c3d>] refrigerator+0xcb/0xda
 [<c0138d38>] get_signal_to_deliver+0x33/0x463
 [<c01077ea>] do_notify_resume+0x94/0x732
 [<c01082f9>] work_notifysig+0x13/0x1a
 [<ffffe410>] 0xffffe410
 =======================
INFO: lockdep is turned off.
gnome-screens D 000000A3     0  3626      1 (NOTLB)
       c7d14eac 00200096 1070b3a2 000000a3 00000000 c7d14e94 c0216c13 c7c2b6b0
       c7c2b840 c265c100 1070b3a2 000000a3 00000000 c0157c10 c7cc1e00 00200046
       c7d14ea0 c3a83c04 0000dc82 00000000 0000dc82 b75f0ff4 c7d14eb8 c0157c3d
Call Trace:
 [<c0157c3d>] refrigerator+0xcb/0xda
 [<c0138d38>] get_signal_to_deliver+0x33/0x463
 [<c01077ea>] do_notify_resume+0x94/0x732
 [<c01082f9>] work_notifysig+0x13/0x1a
 [<ffffe410>] 0xffffe410
 =======================
INFO: lockdep is turned off.
gnome-panel   D 000000A3     0  3634   3555 (NOTLB)
       c7d0deac 00000096 10714011 000000a3 00000000 c7d0de94 c0216c13 c6ce41a0
       c6ce4330 c265c100 10714011 000000a3 00000000 c0157c10 c7cc2800 00000046
       c7d0dea0 c3a86284 00000031 00000000 00000031 b7511ff4 c7d0deb8 c0157c3d
Call Trace:
 [<c0157c3d>] refrigerator+0xcb/0xda
 [<c0138d38>] get_signal_to_deliver+0x33/0x463
 [<c01077ea>] do_notify_resume+0x94/0x732
 [<c01082f9>] work_notifysig+0x13/0x1a
 [<ffffe410>] 0xffffe410
 =======================
INFO: lockdep is turned off.
nautilus      D 000000A3     0  3637   3555 (NOTLB)
       c7d32eac 00200096 10707e2e 000000a3 00000000 c7d32e94 c0216c13 c7c2ed60
       c7c2eef0 c265c100 10707e2e 000000a3 00000000 c0157c10 c7cc3480 00200046
       c7d32ea0 c3a86d84 00000da8 00000000 00000da8 b7381ff4 c7d32eb8 c0157c3d
Call Trace:
 [<c0157c3d>] refrigerator+0xcb/0xda
 [<c0138d38>] get_signal_to_deliver+0x33/0x463
 [<c01077ea>] do_notify_resume+0x94/0x732
 [<c01082f9>] work_notifysig+0x13/0x1a
 [<ffffe410>] 0xffffe410
 =======================
INFO: lockdep is turned off.
gnome-volume- D 000000A3     0  3642      1 (NOTLB)
       c7d49eac 00200096 10703102 000000a3 00000000 c7d49e94 c0216c13 c327e270
       c327e400 c265c100 10703102 000000a3 00000000 c0157c10 c7cc2580 00200046
       c7d49ea0 c3a85d04 00001163 00000000 00001163 b73baff4 c7d49eb8 c0157c3d
Call Trace:
 [<c0157c3d>] refrigerator+0xcb/0xda
 [<c0138d38>] get_signal_to_deliver+0x33/0x463
 [<c01077ea>] do_notify_resume+0x94/0x732
 [<c01082f9>] work_notifysig+0x13/0x1a
 [<ffffe410>] 0xffffe410
 =======================
INFO: lockdep is turned off.
bonobo-activa D 000000A3     0  3648      1 (NOTLB)
       c7d96eac 00000096 106ff371 000000a3 00000000 c7d96e94 c0216c13 c7d78af0
       c7d78c80 c265c100 106ff371 000000a3 00000000 c0157c10 c32b8c80 00000046
       c7d96ea0 c29da084 ffffffff 00000000 ffffffff b7c27ff4 c7d96eb8 c0157c3d
Call Trace:
 [<c0157c3d>] refrigerator+0xcb/0xda
 [<c0138d38>] get_signal_to_deliver+0x33/0x463
 [<c01077ea>] do_notify_resume+0x94/0x732
 [<c01082f9>] work_notifysig+0x13/0x1a
 [<ffffe410>] 0xffffe410
 =======================
INFO: lockdep is turned off.
bonobo-activa D 000000A3     0  3649      1 (NOTLB)
       c7d8beac 00000096 106fe02a 000000a3 00000000 c7d8be94 c0216c13 c7d78000
       c7d78190 c265c100 106fe02a 000000a3 00000000 c0157c10 c32b8c80 00000046
       c7d8bea0 c29da084 ffffffff 00000000 ffffffff b7c27ff4 c7d8beb8 c0157c3d
Call Trace:
 [<c0157c3d>] refrigerator+0xcb/0xda
 [<c0138d38>] get_signal_to_deliver+0x33/0x463
 [<c01077ea>] do_notify_resume+0x94/0x732
 [<c01082f9>] work_notifysig+0x13/0x1a
 [<ffffe410>] 0xffffe410
 =======================
INFO: lockdep is turned off.
gnome-vfs-dae D 000000A3     0  3658      1 (NOTLB)
       c7d94eac 00200096 106f5efe 000000a3 00000000 c7d94e94 c0216c13 c7d7c1a0
       c7d7c330 c265c100 106f5efe 000000a3 00000000 c0157c10 c7cc2d00 00200046
       c7d94ea0 c3a87304 0000039c 00000000 0000039c b7d1fff4 c7d94eb8 c0157c3d
Call Trace:
 [<c0157c3d>] refrigerator+0xcb/0xda
 [<c0138d38>] get_signal_to_deliver+0x33/0x463
 [<c01077ea>] do_notify_resume+0x94/0x732
 [<c01082f9>] work_notifysig+0x13/0x1a
 [<ffffe410>] 0xffffe410
 =======================
INFO: lockdep is turned off.
trashapplet   D 000000A3     0  3696      1 (NOTLB)
       c7da4eac 00200096 106f29eb 000000a3 00000000 c7da4e94 c0216c13 c7d7e270
       c7d7e400 c265c100 106f29eb 000000a3 00000000 c0157c10 c7cc0a00 00200046
       c7da4ea0 c3a81004 ffffffff 00000000 ffffffff b76eaff4 c7da4eb8 c0157c3d
Call Trace:
 [<c0157c3d>] refrigerator+0xcb/0xda
 [<c0138d38>] get_signal_to_deliver+0x33/0x463
 [<c01077ea>] do_notify_resume+0x94/0x732
 [<c01082f9>] work_notifysig+0x13/0x1a
 [<ffffe410>] 0xffffe410
 =======================
INFO: lockdep is turned off.
cpufreq-apple D 000000A3     0  3717      1 (NOTLB)
       c7e09eac 00000096 106ee7b5 000000a3 00000000 c7e09e94 c0216c13 c7e041a0
       c7e04330 c265c100 106ee7b5 000000a3 00000000 c0157c10 c32ba300 00000046
       c7e09ea0 c338d784 000003e7 00000000 000003e7 b78ddff4 c7e09eb8 c0157c3d
Call Trace:
 [<c0157c3d>] refrigerator+0xcb/0xda
 [<c0138d38>] get_signal_to_deliver+0x33/0x463
 [<c01077ea>] do_notify_resume+0x94/0x732
 [<c01082f9>] work_notifysig+0x13/0x1a
 [<ffffe410>] 0xffffe410
 =======================
INFO: lockdep is turned off.
multiload-app D 000000A3     0  3719      1 (NOTLB)
       c7dfceac 00000096 106ea239 000000a3 00000000 c7dfce94 c0216c13 c7e05780
       c7e05910 c265c100 106ea239 000000a3 00000000 c0157c10 c7cc3700 00000046
       c7dfcea0 c29d8504 000001ef 00000000 000001ef b78aeff4 c7dfceb8 c0157c3d
Call Trace:
 [<c0157c3d>] refrigerator+0xcb/0xda
 [<c0138d38>] get_signal_to_deliver+0x33/0x463
 [<c01077ea>] do_notify_resume+0x94/0x732
 [<c01082f9>] work_notifysig+0x13/0x1a
 [<ffffe410>] 0xffffe410
 =======================
INFO: lockdep is turned off.
mapping-daemo D 000000A3     0  3729      1 (NOTLB)
       c7e52eac 00000096 106e68ac 000000a3 00000000 c7e52e94 c0216c13 c7e04c90
       c7e04e20 c265c100 106e68ac 000000a3 00000000 c0157c10 c398a300 00000046
       c7e52ea0 c39ddd04 00001388 00000000 00001388 b7ec3ff4 c7e52eb8 c0157c3d
Call Trace:
 [<c0157c3d>] refrigerator+0xcb/0xda
 [<c0138d38>] get_signal_to_deliver+0x33/0x463
 [<c01077ea>] do_notify_resume+0x94/0x732
 [<c01082f9>] work_notifysig+0x13/0x1a
 [<ffffe410>] 0xffffe410
 =======================
INFO: lockdep is turned off.
mixer_applet2 D 000000A3     0  3751      1 (NOTLB)
       c7d84eac 00000096 106e4f6f 000000a3 00000000 c7d84e94 c0216c13 c7e036b0
       c7e03840 c265c100 106e4f6f 000000a3 00000000 c0157c10 c7cc3980 00000046
       c7d84ea0 c39d9584 00000063 00000000 00000063 b77aeff4 c7d84eb8 c0157c3d
Call Trace:
 [<c0157c3d>] refrigerator+0xcb/0xda
 [<c0138d38>] get_signal_to_deliver+0x33/0x463
 [<c01077ea>] do_notify_resume+0x94/0x732
 [<c01082f9>] work_notifysig+0x13/0x1a
 [<ffffe410>] 0xffffe410
 =======================
INFO: lockdep is turned off.
beryl-manager D 000000A3     0  3779      1 (NOTLB)
       c7ecaeac 00200096 106e2ade 000000a3 00000000 c7ecae94 c0216c13 c7e06270
       c7e06400 c265c100 106e2ade 000000a3 00000000 c0157c10 c3988280 00200046
       c7ecaea0 c39dc704 ffffffff 00000000 ffffffff b775fff4 c7ecaeb8 c0157c3d
Call Trace:
 [<c0157c3d>] refrigerator+0xcb/0xda
 [<c0138d38>] get_signal_to_deliver+0x33/0x463
 [<c01077ea>] do_notify_resume+0x94/0x732
 [<c01082f9>] work_notifysig+0x13/0x1a
 [<ffffe410>] 0xffffe410
 =======================
INFO: lockdep is turned off.
beryl-manager D 000000A3     0  3848      1 (NOTLB)
       c7ee9eac 00200096 106e1459 000000a3 00000000 c7ee9e94 c0216c13 c7e020d0
       c7e02260 c265c100 106e1459 000000a3 00000000 c0157c10 c3988280 00200046
       c7ee9ea0 c39dc704 b71c52fc 00000000 b71c52fc ffffffff c7ee9eb8 c0157c3d
Call Trace:
 [<c0157c3d>] refrigerator+0xcb/0xda
 [<c0138d38>] get_signal_to_deliver+0x33/0x463
 [<c01077ea>] do_notify_resume+0x94/0x732
 [<c01082f9>] work_notifysig+0x13/0x1a
 [<ffffe410>] 0xffffe410
 =======================
INFO: lockdep is turned off.
beryl-manager D 000000A3     0  3853      1 (NOTLB)
       c7dc3eac 00200096 106e078b 000000a3 00000000 c7dc3e94 c0216c13 c7e00af0
       c7e00c80 c265c100 106e078b 000000a3 00000000 c0157c10 c3988280 00200046
       c7dc3ea0 c39dc704 b69c426c 00000000 b69c426c ffffffff c7dc3eb8 c0157c3d
Call Trace:
 [<c0157c3d>] refrigerator+0xcb/0xda
 [<c0138d38>] get_signal_to_deliver+0x33/0x463
 [<c01077ea>] do_notify_resume+0x94/0x732
 [<c01082f9>] work_notifysig+0x13/0x1a
 [<ffffe410>] 0xffffe410
 =======================
INFO: lockdep is turned off.
heliodor      D 000000A3     0  3850   3848 (NOTLB)
       c7e7deac 00000096 106df8e3 000000a3 00000000 c7e7de94 c0216c13 c7e02bc0
       c7e02d50 c265c100 106df8e3 000000a3 00000000 c0157c10 c7cc2a80 00000046
       c7e7dea0 c3a87e04 ffffffff 00000000 ffffffff b761bff4 c7e7deb8 c0157c3d
Call Trace:
 [<c0157c3d>] refrigerator+0xcb/0xda
 [<c0138d38>] get_signal_to_deliver+0x33/0x463
 [<c01077ea>] do_notify_resume+0x94/0x732
 [<c01082f9>] work_notifysig+0x13/0x1a
 [<ffffe410>] 0xffffe410
 =======================
INFO: lockdep is turned off.
beryl         D 000000A3     0  3859   3853 (NOTLB)
       c7d5beac 00200096 106eaec0 000000a3 00000000 c7d5be94 c0216c13 c2885780
       c2885910 c265c100 106eaec0 000000a3 00000000 c0157c10 c7cc3200 00200046
       c7d5bea0 c3a86804 00000004 00000000 00000004 b7e15ff4 c7d5beb8 c0157c3d
Call Trace:
 [<c0157c3d>] refrigerator+0xcb/0xda
 [<c0138d38>] get_signal_to_deliver+0x33/0x463
 [<c01077ea>] do_notify_resume+0x94/0x732
 [<c01082f9>] work_notifysig+0x13/0x1a
 [<ffffe410>] 0xffffe410
 =======================
INFO: lockdep is turned off.
vino-session  D 000000A3     0  3863   3555 (NOTLB)
       c67d8eac 00200096 106dcfd0 000000a3 00000000 c67d8e94 c0216c13 c293b6b0
       c293b840 c265c100 106dcfd0 000000a3 00000000 c0157c10 c7f10000 00200046
       c67d8ea0 c7ef8504 ffffffff 00000000 ffffffff b7858ff4 c67d8eb8 c0157c3d
Call Trace:
 [<c0157c3d>] refrigerator+0xcb/0xda
 [<c0138d38>] get_signal_to_deliver+0x33/0x463
 [<c01077ea>] do_notify_resume+0x94/0x732
 [<c01082f9>] work_notifysig+0x13/0x1a
 [<ffffe410>] 0xffffe410
 =======================
INFO: lockdep is turned off.
update-notifi D 000000A3     0  3867   3555 (NOTLB)
       c7f05eac 00200096 106da248 000000a3 00000000 c7f05e94 c0216c13 c7d7a0d0
       c7d7a260 c265c100 106da248 000000a3 00000000 c0157c10 c7f10a00 00200046
       c7f05ea0 c7ef9584 0000020f 00000000 0000020f b72b5ff4 c7f05eb8 c0157c3d
Call Trace:
 [<c0157c3d>] refrigerator+0xcb/0xda
 [<c0138d38>] get_signal_to_deliver+0x33/0x463
 [<c01077ea>] do_notify_resume+0x94/0x732
 [<c01082f9>] work_notifysig+0x13/0x1a
 [<ffffe410>] 0xffffe410
 =======================
INFO: lockdep is turned off.
evolution-ala D 000000A3     0  3877   3555 (NOTLB)
       c7f1aeac 00200096 106d65b4 000000a3 00000000 c7f1ae94 c0216c13 c7d7abc0
       c7d7ad50 c265c100 106d65b4 000000a3 00000000 c0157c10 c7f10f00 00200046
       c7f1aea0 c7efb684 0013ba77 00000000 0013ba77 b6e20ff4 c7f1aeb8 c0157c3d
Call Trace:
 [<c0157c3d>] refrigerator+0xcb/0xda
 [<c0138d38>] get_signal_to_deliver+0x33/0x463
 [<c01077ea>] do_notify_resume+0x94/0x732
 [<c01082f9>] work_notifysig+0x13/0x1a
 [<ffffe410>] 0xffffe410
 =======================
INFO: lockdep is turned off.
evolution-ala D 000000A3     0  3887   3555 (NOTLB)
       c7f36eac 00200096 106d3f59 000000a3 00000000 c7f36e94 c0216c13 c7d7ed60
       c7d7eef0 c265c100 106d3f59 000000a3 00000000 c0157c10 c7f10f00 00200046
       c7f36ea0 c7efb684 ffffffff 00000000 ffffffff b6e20ff4 c7f36eb8 c0157c3d
Call Trace:
 [<c0157c3d>] refrigerator+0xcb/0xda
 [<c0138d38>] get_signal_to_deliver+0x33/0x463
 [<c01077ea>] do_notify_resume+0x94/0x732
 [<c01082f9>] work_notifysig+0x13/0x1a
 [<ffffe410>] 0xffffe410
 =======================
INFO: lockdep is turned off.
evolution-ala D 000000A3     0  3923   3555 (NOTLB)
       c8016eac 00200096 106d0475 000000a3 00000000 c8016e94 c0216c13 c7fb20d0
       c7fb2260 c265c100 106d0475 000000a3 00000000 c0157c10 c7f10f00 00200046
       c8016ea0 c7efb684 00000000 00000000 00000000 00000007 c8016eb8 c0157c3d
Call Trace:
 [<c0157c3d>] refrigerator+0xcb/0xda
 [<c0138d38>] get_signal_to_deliver+0x33/0x463
 [<c01077ea>] do_notify_resume+0x94/0x732
 [<c01082f9>] work_notifysig+0x13/0x1a
 [<ffffe410>] 0xffffe410
 =======================
INFO: lockdep is turned off.
nm-applet     D 000000A3     0  3883   3555 (NOTLB)
       c7ebaeac 00000096 106cf5b3 000000a3 00000000 c7ebae94 c0216c13 c7d795e0
       c7d79770 c265c100 106cf5b3 000000a3 00000000 c0157c10 c7f10500 00000046
       c7ebaea0 c7ef9004 000003e8 00000000 000003e8 b7297ff4 c7ebaeb8 c0157c3d
Call Trace:
 [<c0157c3d>] refrigerator+0xcb/0xda
 [<c0138d38>] get_signal_to_deliver+0x33/0x463
 [<c01077ea>] do_notify_resume+0x94/0x732
 [<c01082f9>] work_notifysig+0x13/0x1a
 [<ffffe410>] 0xffffe410
 =======================
INFO: lockdep is turned off.
gnome-cups-ic D 000000A3     0  3884   3555 (NOTLB)
       c7f27eac 00200096 106ccf2e 000000a3 00000000 c7f27e94 c0216c13 c7d7cc90
       c7d7ce20 c265c100 106ccf2e 000000a3 00000000 c0157c10 c7f10c80 00200046
       c7f27ea0 c7ef8a84 00001388 00000000 00001388 b71f6ff4 c7f27eb8 c0157c3d
Call Trace:
 [<c0157c3d>] refrigerator+0xcb/0xda
 [<c0138d38>] get_signal_to_deliver+0x33/0x463
 [<c01077ea>] do_notify_resume+0x94/0x732
 [<c01082f9>] work_notifysig+0x13/0x1a
 [<ffffe410>] 0xffffe410
 =======================
INFO: lockdep is turned off.
gnome-power-m D 000000A3     0  3885      1 (NOTLB)
       c7f8ceac 00200096 106c988f 000000a3 00000000 c7f8ce94 c0216c13 c7d7d780
       c7d7d910 c265c100 106c988f 000000a3 00000000 c0157c10 c7f10780 00200046
       c7f8cea0 c7efab84 080de9a8 00000000 080de9a8 b717aff4 c7f8ceb8 c0157c3d
Call Trace:
 [<c0157c3d>] refrigerator+0xcb/0xda
 [<c0138d38>] get_signal_to_deliver+0x33/0x463
 [<c01077ea>] do_notify_resume+0x94/0x732
 [<c01082f9>] work_notifysig+0x13/0x1a
 [<ffffe410>] 0xffffe410
 =======================
INFO: lockdep is turned off.
evolution-exc D 000000A3     0  3899      1 (NOTLB)
       c7f85eac 00000096 106c8263 000000a3 00000000 c7f85e94 c0216c13 c7e9cc90
       c7e9ce20 c265c100 106c8263 000000a3 00000000 c0157c10 c7f11400 00000046
       c7f85ea0 c7ef9b04 ffffffff 00000000 ffffffff b6dc2ff4 c7f85eb8 c0157c3d
Call Trace:
 [<c0157c3d>] refrigerator+0xcb/0xda
 [<c0138d38>] get_signal_to_deliver+0x33/0x463
 [<c01077ea>] do_notify_resume+0x94/0x732
 [<c01082f9>] work_notifysig+0x13/0x1a
 [<ffffe410>] 0xffffe410
 =======================
INFO: lockdep is turned off.
evolution-exc D 000000A3     0  3902      1 (NOTLB)
       c7fcdeac 00000096 106c64bf 000000a3 00000000 c7fcde94 c0216c13 c7e995e0
       c7e99770 c265c100 106c64bf 000000a3 00000000 c0157c10 c7f11400 00000046
       c7fcdea0 c7ef9b04 ffffffff 00000000 ffffffff b6dc2ff4 c7fcdeb8 c0157c3d
Call Trace:
 [<c0157c3d>] refrigerator+0xcb/0xda
 [<c0138d38>] get_signal_to_deliver+0x33/0x463
 [<c01077ea>] do_notify_resume+0x94/0x732
 [<c01082f9>] work_notifysig+0x13/0x1a
 [<ffffe410>] 0xffffe410
 =======================
INFO: lockdep is turned off.
evolution-dat D 000000A3     0  3904      1 (NOTLB)
       c7cedeac 00000096 106c2f77 000000a3 00000000 c7cede94 c0216c13 c7e98000
       c7e98190 c265c100 106c2f77 000000a3 00000000 c0157c10 c7f10280 00000046
       c7cedea0 c7efa084 ffffffff 00000000 ffffffff b76bdff4 c7cedeb8 c0157c3d
Call Trace:
 [<c0157c3d>] refrigerator+0xcb/0xda
 [<c0138d38>] get_signal_to_deliver+0x33/0x463
 [<c01077ea>] do_notify_resume+0x94/0x732
 [<c01082f9>] work_notifysig+0x13/0x1a
 [<ffffe410>] 0xffffe410
 =======================
INFO: lockdep is turned off.
evolution-dat D 000000A3     0  3910      1 (NOTLB)
       c7ffbeac 00000096 106c1c74 000000a3 00000000 c7ffbe94 c0216c13 c7e9e270
       c7e9e400 c265c100 106c1c74 000000a3 00000000 c0157c10 c7f10280 00000046
       c7ffbea0 c7efa084 ffffffff 00000000 ffffffff b76bdff4 c7ffbeb8 c0157c3d
Call Trace:
 [<c0157c3d>] refrigerator+0xcb/0xda
 [<c0138d38>] get_signal_to_deliver+0x33/0x463
 [<c01077ea>] do_notify_resume+0x94/0x732
 [<c01082f9>] work_notifysig+0x13/0x1a
 [<ffffe410>] 0xffffe410
 =======================
INFO: lockdep is turned off.
evolution-dat D 000000A3     0  3920      1 (NOTLB)
       c7ea6eac 00000096 106beaf1 000000a3 00000000 c7ea6e94 c0216c13 c7fb0000
       c7fb0190 c265c100 106beaf1 000000a3 00000000 c0157c10 c7f10280 00000046
       c7ea6ea0 c7efa084 ffffffff 00000000 ffffffff b76bdff4 c7ea6eb8 c0157c3d
Call Trace:
 [<c0157c3d>] refrigerator+0xcb/0xda
 [<c0138d38>] get_signal_to_deliver+0x33/0x463
 [<c01077ea>] do_notify_resume+0x94/0x732
 [<c01082f9>] work_notifysig+0x13/0x1a
 [<ffffe410>] 0xffffe410
 =======================
INFO: lockdep is turned off.
gnome-termina D 000000A3     0  4604      1 (NOTLB)
       c8024eac 00200096 106bd53a 000000a3 00000000 c8024e94 c0216c13 c7fb15e0
       c7fb1770 c265c100 106bd53a 000000a3 00000000 c0157c10 c7f12080 00200046
       c8024ea0 c7efc184 00000257 00000000 00000257 b7528ff4 c8024eb8 c0157c3d
Call Trace:
 [<c0157c3d>] refrigerator+0xcb/0xda
 [<c0138d38>] get_signal_to_deliver+0x33/0x463
 [<c01077ea>] do_notify_resume+0x94/0x732
 [<c01082f9>] work_notifysig+0x13/0x1a
 [<ffffe410>] 0xffffe410
 =======================
INFO: lockdep is turned off.
gnome-termina D 000000A3     0  4610      1 (NOTLB)
       c809beac 00000096 106b6f3d 000000a3 00000000 c809be94 c0216c13 c7fb0af0
       c7fb0c80 c265c100 106b6f3d 000000a3 00000000 c0157c10 c7f12080 00000046
       c809bea0 c7efc184 b7535b70 00000000 b7535b70 b76f8874 c809beb8 c0157c3d
Call Trace:
 [<c0157c3d>] refrigerator+0xcb/0xda
 [<c0138d38>] get_signal_to_deliver+0x33/0x463
 [<c01077ea>] do_notify_resume+0x94/0x732
 [<c01082f9>] work_notifysig+0x13/0x1a
 [<ffffe410>] 0xffffe410
 =======================
INFO: lockdep is turned off.
gnome-pty-hel D 000000A3     0  4608   4604 (NOTLB)
       c8099eac 00000096 106b5c10 000000a3 00000000 c8099e94 c0216c13 c7fb6270
       c7fb6400 c265c100 106b5c10 000000a3 00000000 c0157c10 c7f11180 00000046
       c8099ea0 c7efa604 00000004 00000000 00000004 bfa30d24 c8099eb8 c0157c3d
Call Trace:
 [<c0157c3d>] refrigerator+0xcb/0xda
 [<c0138d38>] get_signal_to_deliver+0x33/0x463
 [<c01077ea>] do_notify_resume+0x94/0x732
 [<c01082f9>] work_notifysig+0x13/0x1a
 [<ffffe410>] 0xffffe410
 =======================
INFO: lockdep is turned off.
bash          D 000000A3     0  4609   4604 (NOTLB)
       c8092eac 00000096 106b48cf 000000a3 00000000 c8092e94 c0216c13 c7fb41a0
       c7fb4330 c265c100 106b48cf 000000a3 00000000 c0157c10 c7f11900 00000046
       c8092ea0 c7efc704 b7f63420 00000000 b7f63420 082a0008 c8092eb8 c0157c3d
Call Trace:
 [<c0157c3d>] refrigerator+0xcb/0xda
 [<c0138d38>] get_signal_to_deliver+0x33/0x463
 [<c01077ea>] do_notify_resume+0x94/0x732
 [<c01082f9>] work_notifysig+0x13/0x1a
 [<ffffe410>] 0xffffe410
 =======================
INFO: lockdep is turned off.
firefox       D 000000A3     0  5249      1 (NOTLB)
       c7e8deac 00200096 106b3602 000000a3 00000000 c7e8de94 c0216c13 c80e36b0
       c80e3840 c265c100 106b3602 000000a3 00000000 c0157c10 c7f12580 00200046
       c7e8dea0 c7efb104 00000000 00000000 00000000 00000002 c7e8deb8 c0157c3d
Call Trace:
 [<c0157c3d>] refrigerator+0xcb/0xda
 [<c0138d38>] get_signal_to_deliver+0x33/0x463
 [<c01077ea>] do_notify_resume+0x94/0x732
 [<c01082f9>] work_notifysig+0x13/0x1a
 [<ffffe410>] 0xffffe410
 =======================
INFO: lockdep is turned off.
run-mozilla.s D 000000A3     0  5261   5249 (NOTLB)
       c7fe2eac 00200096 106b0b8d 000000a3 00000000 c7fe2e94 c0216c13 c80e20d0
       c80e2260 c265c100 106b0b8d 000000a3 00000000 c0157c10 c7f13700 00200046
       c7fe2ea0 c7efdd04 00000000 00000000 00000000 00000001 c7fe2eb8 c0157c3d
Call Trace:
 [<c0157c3d>] refrigerator+0xcb/0xda
 [<c0138d38>] get_signal_to_deliver+0x33/0x463
 [<c01077ea>] do_notify_resume+0x94/0x732
 [<c01082f9>] work_notifysig+0x13/0x1a
 [<ffffe410>] 0xffffe410
 =======================
INFO: lockdep is turned off.
firefox-bin   D 000000A3     0  5265   5261 (NOTLB)
       c7fdbeac 00000096 106b285b 000000a3 00000000 c7fdbe94 c0216c13 c80e41a0
       c80e4330 c265c100 106b285b 000000a3 00000000 c0157c10 c7f13c00 00000046
       c7fdbea0 c7eff304 00000009 00000000 00000009 b76fcff4 c7fdbeb8 c0157c3d
Call Trace:
 [<c0157c3d>] refrigerator+0xcb/0xda
 [<c0138d38>] get_signal_to_deliver+0x33/0x463
 [<c01077ea>] do_notify_resume+0x94/0x732
 [<c01082f9>] work_notifysig+0x13/0x1a
 [<ffffe410>] 0xffffe410
 =======================
INFO: lockdep is turned off.
firefox-bin   D 000000A3     0  5266   5261 (NOTLB)
       c8075eac 00200096 106afd43 000000a3 00000000 c8075e94 c0216c13 c80e2bc0
       c80e2d50 c265c100 106afd43 000000a3 00000000 c0157c10 c7f13c00 00200046
       c8075ea0 c7eff304 03e7fc18 00000000 03e7fc18 b76fcff4 c8075eb8 c0157c3d
Call Trace:
 [<c0157c3d>] refrigerator+0xcb/0xda
 [<c0138d38>] get_signal_to_deliver+0x33/0x463
 [<c01077ea>] do_notify_resume+0x94/0x732
 [<c01082f9>] work_notifysig+0x13/0x1a
 [<ffffe410>] 0xffffe410
 =======================
INFO: lockdep is turned off.
firefox-bin   D 000000A3     0  5267   5261 (NOTLB)
       c7ccaeac 00200096 106ae437 000000a3 00000000 c7ccae94 c0216c13 c80e0000
       c80e0190 c265c100 106ae437 000000a3 00000000 c0157c10 c7f13c00 00200046
       c7ccaea0 c7eff304 b66962d8 00000000 b66962d8 0000b987 c7ccaeb8 c0157c3d
Call Trace:
 [<c0157c3d>] refrigerator+0xcb/0xda
 [<c0138d38>] get_signal_to_deliver+0x33/0x463
 [<c01077ea>] do_notify_resume+0x94/0x732
 [<c01082f9>] work_notifysig+0x13/0x1a
 [<ffffe410>] 0xffffe410
 =======================
INFO: lockdep is turned off.
firefox-bin   D 000000A3     0  5289   5261 (NOTLB)
       c80f7eac 00000096 106ad6a3 000000a3 00000000 c80f7e94 c0216c13 c7e9d780
       c7e9d910 c265c100 106ad6a3 000000a3 00000000 c0157c10 c7f13c00 00000046
       c80f7ea0 c7eff304 b2a982d8 00000000 b2a982d8 00004de3 c80f7eb8 c0157c3d
Call Trace:
 [<c0157c3d>] refrigerator+0xcb/0xda
 [<c0138d38>] get_signal_to_deliver+0x33/0x463
 [<c01077ea>] do_notify_resume+0x94/0x732
 [<c01082f9>] work_notifysig+0x13/0x1a
 [<ffffe410>] 0xffffe410
 =======================
INFO: lockdep is turned off.
firefox-bin   D 000000A3     0  5290   5261 (NOTLB)
       c80edeac 00000096 106abd8a 000000a3 00000000 c80ede94 c0216c13 c7e9abc0
       c7e9ad50 c265c100 106abd8a 000000a3 00000000 c0157c10 c7f13c00 00000046
       c80edea0 c7eff304 b22972e8 00000000 b22972e8 00003e81 c80edeb8 c0157c3d
Call Trace:
 [<c0157c3d>] refrigerator+0xcb/0xda
 [<c0138d38>] get_signal_to_deliver+0x33/0x463
 [<c01077ea>] do_notify_resume+0x94/0x732
 [<c01082f9>] work_notifysig+0x13/0x1a
 [<ffffe410>] 0xffffe410
 =======================
INFO: lockdep is turned off.
firefox-bin   D 000000A3     0  5291   5261 (NOTLB)
       c80eceac 00000096 106aca86 000000a3 00000000 c80ece94 c0216c13 c7e9c1a0
       c7e9c330 c265c100 106aca86 000000a3 00000000 c0157c10 c7f13c00 00000046
       c80ecea0 c7eff304 00000000 00000000 00000000 00000007 c80eceb8 c0157c3d
Call Trace:
 [<c0157c3d>] refrigerator+0xcb/0xda
 [<c0138d38>] get_signal_to_deliver+0x33/0x463
 [<c01077ea>] do_notify_resume+0x94/0x732
 [<c01082f9>] work_notifysig+0x13/0x1a
 [<ffffe410>] 0xffffe410
 =======================
INFO: lockdep is turned off.
firefox-bin   D 000000A3     0  5299   5261 (NOTLB)
       c8089eac 00000096 106ab0b6 000000a3 00000000 c8089e94 c0216c13 c80e5780
       c80e5910 c265c100 106ab0b6 000000a3 00000000 c0157c10 c7f13c00 00000046
       c8089ea0 c7eff304 00000000 00000000 00000000 0000047b c8089eb8 c0157c3d
Call Trace:
 [<c0157c3d>] refrigerator+0xcb/0xda
 [<c0138d38>] get_signal_to_deliver+0x33/0x463
 [<c01077ea>] do_notify_resume+0x94/0x732
 [<c01082f9>] work_notifysig+0x13/0x1a
 [<ffffe410>] 0xffffe410
 =======================
INFO: lockdep is turned off.
firefox-bin   D 000000A3     0  5320   5261 (NOTLB)
       c80fceac 00000096 106aa480 000000a3 00000000 c80fce94 c0216c13 c7e98af0
       c7e98c80 c265c100 106aa480 000000a3 00000000 c0157c10 c7f13c00 00000046
       c80fcea0 c7eff304 00000000 00000000 00000000 ae04dcec c80fceb8 c0157c3d
Call Trace:
 [<c0157c3d>] refrigerator+0xcb/0xda
 [<c0138d38>] get_signal_to_deliver+0x33/0x463
 [<c01077ea>] do_notify_resume+0x94/0x732
 [<c01082f9>] work_notifysig+0x13/0x1a
 [<ffffe410>] 0xffffe410
 =======================
INFO: lockdep is turned off.
cat           D 0000002B     0  5603      1 (NOTLB)
       c8102e4c 00000096 80cc15ad 0000002b c1176c2c c8102e38 00000046 c7fb2bc0
       c7fb2d50 c265c100 80cc15ad 0000002b 00000000 c8102e4c c7f12d00 c014b438
       00000001 c036759c c63b6914 c8102e68 c63b68e0 00000246 c8102e88 c0367416
Call Trace:
 [<c0367416>] __mutex_lock_slowpath+0x1c7/0x32c
 [<c036759c>] mutex_lock+0x21/0x24
 [<f8ac10ca>] drm_vma_info+0x1f/0x310 [drm]
 [<c01b514d>] proc_file_read+0x108/0x222
 [<c01b19ed>] proc_reg_read+0x63/0x76
 [<c01834aa>] vfs_read+0xb0/0x139
 [<c018390e>] sys_read+0x3d/0x72
 [<c0108162>] sysenter_past_esp+0x6b/0xb5
 [<ffffe410>] 0xffffe410
 =======================
INFO: lockdep is turned off.
tail          D 0000002C     0  5646      1 (NOTLB)
       c811ce4c 00000096 7137dc36 0000002c c1175f98 c811ce38 00000046 c80e15e0
       c80e1770 c265c100 7137dc36 0000002c 00000000 c811ce4c c7f11e00 c014b438
       00000001 c036759c c63b6914 c811ce68 c63b68e0 00000246 c811ce88 c0367416
Call Trace:
 [<c0367416>] __mutex_lock_slowpath+0x1c7/0x32c
 [<c036759c>] mutex_lock+0x21/0x24
 [<f8ac10ca>] drm_vma_info+0x1f/0x310 [drm]
 [<c01b514d>] proc_file_read+0x108/0x222
 [<c01b19ed>] proc_reg_read+0x63/0x76
 [<c01834aa>] vfs_read+0xb0/0x139
 [<c018390e>] sys_read+0x3d/0x72
 [<c0108162>] sysenter_past_esp+0x6b/0xb5
 [<ffffe410>] 0xffffe410
 =======================
INFO: lockdep is turned off.
cat           D 00000033     0  5910      1 (NOTLB)
       c8107e4c 00000096 24ccdd52 00000033 c014b438 00000001 c8107e14 c7e9ed60
       c7e9eef0 c265c100 24ccdd52 00000033 00000000 c8107e4c c7f11b80 c014b438
       00000001 c036759c c63b6914 c8107e68 c63b68e0 00000246 c8107e88 c0367416
Call Trace:
 [<c0367416>] __mutex_lock_slowpath+0x1c7/0x32c
 [<c036759c>] mutex_lock+0x21/0x24
 [<f8ac10ca>] drm_vma_info+0x1f/0x310 [drm]
 [<c01b514d>] proc_file_read+0x108/0x222
 [<c01b19ed>] proc_reg_read+0x63/0x76
 [<c01834aa>] vfs_read+0xb0/0x139
 [<c018390e>] sys_read+0x3d/0x72
 [<c0108162>] sysenter_past_esp+0x6b/0xb5
 [<ffffe410>] 0xffffe410
 =======================
INFO: lockdep is turned off.
cat           D 00000033     0  5926      1 (NOTLB)
       c8160e4c 00000096 8cc85f27 00000033 c117483c c8160e38 00000046 c80e0af0
       c80e0c80 c265c100 8cc85f27 00000033 00000000 c8160e4c c7f13480 c014b438
       00000001 c036759c c63b6914 c8160e68 c63b68e0 00000246 c8160e88 c0367416
Call Trace:
 [<c0367416>] __mutex_lock_slowpath+0x1c7/0x32c
 [<c036759c>] mutex_lock+0x21/0x24
 [<f8ac10ca>] drm_vma_info+0x1f/0x310 [drm]
 [<c01b514d>] proc_file_read+0x108/0x222
 [<c01b19ed>] proc_reg_read+0x63/0x76
 [<c01834aa>] vfs_read+0xb0/0x139
 [<c018390e>] sys_read+0x3d/0x72
 [<c0108162>] sysenter_past_esp+0x6b/0xb5
 [<ffffe410>] 0xffffe410
 =======================
INFO: lockdep is turned off.
cat           D 00000034     0  5950      1 (NOTLB)
       c8084e4c 00000096 39b9c536 00000034 c117afbc c8084e38 00000046 c6ce15e0
       c6ce1770 c265c100 39b9c536 00000034 00000000 c8084e4c c7f13200 c014b438
       00000001 c036759c c63b6914 c8084e68 c63b68e0 00000246 c8084e88 c0367416
Call Trace:
 [<c0367416>] __mutex_lock_slowpath+0x1c7/0x32c
 [<c036759c>] mutex_lock+0x21/0x24
 [<f8ac10ca>] drm_vma_info+0x1f/0x310 [drm]
 [<c01b514d>] proc_file_read+0x108/0x222
 [<c01b19ed>] proc_reg_read+0x63/0x76
 [<c01834aa>] vfs_read+0xb0/0x139
 [<c018390e>] sys_read+0x3d/0x72
 [<c0108162>] sysenter_past_esp+0x6b/0xb5
 [<ffffe410>] 0xffffe410
 =======================
INFO: lockdep is turned off.
bash          D 000000A3     0  6106   4604 (NOTLB)
       c8150eac 00200096 106a977d 000000a3 00000000 c8150e94 c0216c13 c7fb6d60
       c7fb6ef0 c265c100 106a977d 000000a3 00000000 c0157c10 c7f11680 00200046
       c8150ea0 c7eff884 b7f32420 00000000 b7f32420 082ae008 c8150eb8 c0157c3d
Call Trace:
 [<c0157c3d>] refrigerator+0xcb/0xda
 [<c0138d38>] get_signal_to_deliver+0x33/0x463
 [<c01077ea>] do_notify_resume+0x94/0x732
 [<c01082f9>] work_notifysig+0x13/0x1a
 [<ffffe410>] 0xffffe410
 =======================
INFO: lockdep is turned off.
bash          D 000000A3     0  6149   4604 (NOTLB)
       c7ed1eac 00200096 106a83b5 000000a3 00000000 c7ed1e94 c0216c13 c81e2bc0
       c81e2d50 c265c100 106a83b5 000000a3 00000000 c0157c10 c7cc3c00 00200046
       c7ed1ea0 c81c1584 b7e9d420 00000000 b7e9d420 082ae008 c7ed1eb8 c0157c3d
Call Trace:
 [<c0157c3d>] refrigerator+0xcb/0xda
 [<c0138d38>] get_signal_to_deliver+0x33/0x463
 [<c01077ea>] do_notify_resume+0x94/0x732
 [<c01082f9>] work_notifysig+0x13/0x1a
 [<ffffe410>] 0xffffe410
 =======================
INFO: lockdep is turned off.
bash          D 000000A3     0  8615   2611 (NOTLB)
       c8159eac 00000096 106a7174 000000a3 00000000 c8159e94 c0216c13 c81e15e0
       c81e1770 c265c100 106a7174 000000a3 00000000 c0157c10 c8204280 00000046
       c8159ea0 c81c2604 0810ad88 00000000 0810ad88 00000000 c8159eb8 c0157c3d
Call Trace:
 [<c0157c3d>] refrigerator+0xcb/0xda
 [<c0138d38>] get_signal_to_deliver+0x33/0x463
 [<c01077ea>] do_notify_resume+0x94/0x732
 [<c01082f9>] work_notifysig+0x13/0x1a
 [<ffffe410>] 0xffffe410
 =======================
INFO: lockdep is turned off.
bash          D 000000A3     0  8642   8615 (NOTLB)
       c7dedeac 00000096 106a343b 000000a3 00000000 c7dede94 c0216c13 c81e36b0
       c81e3840 c265c100 106a343b 000000a3 00000000 c0157c10 c8204780 00000046
       c7dedea0 c81c2b84 b7e9f420 00000000 b7e9f420 0821f008 c7dedeb8 c0157c3d
Call Trace:
 [<c0157c3d>] refrigerator+0xcb/0xda
 [<c0138d38>] get_signal_to_deliver+0x33/0x463
 [<c01077ea>] do_notify_resume+0x94/0x732
 [<c01082f9>] work_notifysig+0x13/0x1a
 [<ffffe410>] 0xffffe410
 =======================
INFO: lockdep is turned off.
bash          D 000000A3     0  8711   2609 (NOTLB)
       c8116eac 00000096 106a4b19 000000a3 00000000 c8116e94 c0216c13 c81e0000
       c81e0190 c265c100 106a4b19 000000a3 00000000 c0157c10 c8205180 00000046
       c8116ea0 c81c2084 b7ee8420 00000000 b7ee8420 0829f008 c8116eb8 c0157c3d
Call Trace:
 [<c0157c3d>] refrigerator+0xcb/0xda
 [<c0138d38>] get_signal_to_deliver+0x33/0x463
 [<c01077ea>] do_notify_resume+0x94/0x732
 [<c01082f9>] work_notifysig+0x13/0x1a
 [<ffffe410>] 0xffffe410
 =======================
INFO: lockdep is turned off.
bash          D 000000A3     0  8747   2610 (NOTLB)
       cd090eac 00000096 106a62b1 000000a3 00000000 cd090e94 c0216c13 c81e6d60
       c81e6ef0 c265c100 106a62b1 000000a3 00000000 c0157c10 c8205b80 00000046
       cd090ea0 c81c1b04 b7efc420 00000000 b7efc420 0829f008 cd090eb8 c0157c3d
Call Trace:
 [<c0157c3d>] refrigerator+0xcb/0xda
 [<c0138d38>] get_signal_to_deliver+0x33/0x463
 [<c01077ea>] do_notify_resume+0x94/0x732
 [<c01082f9>] work_notifysig+0x13/0x1a
 [<ffffe410>] 0xffffe410
 =======================
INFO: lockdep is turned off.
gnome-help    D 000000A3     0  8809      1 (NOTLB)
       ce47deac 00000096 106a0fe4 000000a3 00000000 ce47de94 c0216c13 c39415e0
       c3941770 c265c100 106a0fe4 000000a3 00000000 c0157c10 c8205680 00000046
       ce47dea0 c81c3684 ffffffff 00000000 ffffffff b74e5ff4 ce47deb8 c0157c3d
Call Trace:
 [<c0157c3d>] refrigerator+0xcb/0xda
 [<c0138d38>] get_signal_to_deliver+0x33/0x463
 [<c01077ea>] do_notify_resume+0x94/0x732
 [<c01082f9>] work_notifysig+0x13/0x1a
 [<ffffe410>] 0xffffe410
 =======================
INFO: lockdep is turned off.
gnome-help    D 000000A3     0  8813      1 (NOTLB)
       cf26beac 00200096 1069dbc8 000000a3 00000000 cf26be94 c0216c13 c81e0af0
       c81e0c80 c265c100 1069dbc8 000000a3 00000000 c0157c10 c8205680 00200046
       cf26bea0 c81c3684 ffffffff 00000000 ffffffff b74e5ff4 cf26beb8 c0157c3d
Call Trace:
 [<c0157c3d>] refrigerator+0xcb/0xda
 [<c0138d38>] get_signal_to_deliver+0x33/0x463
 [<c01077ea>] do_notify_resume+0x94/0x732
 [<c01082f9>] work_notifysig+0x13/0x1a
 [<ffffe410>] 0xffffe410
 =======================
INFO: lockdep is turned off.
gnome-help    D 000000A3     0  8832      1 (NOTLB)
       cf3c5eac 00000096 1069ca98 000000a3 00000000 cf3c5e94 c0216c13 c80e4c90
       c80e4e20 c265c100 1069ca98 000000a3 00000000 c0157c10 c8205680 00000046
       cf3c5ea0 c81c3684 b4eda2d8 00000000 b4eda2d8 00000017 cf3c5eb8 c0157c3d
Call Trace:
 [<c0157c3d>] refrigerator+0xcb/0xda
 [<c0138d38>] get_signal_to_deliver+0x33/0x463
 [<c01077ea>] do_notify_resume+0x94/0x732
 [<c01082f9>] work_notifysig+0x13/0x1a
 [<ffffe410>] 0xffffe410
 =======================
INFO: lockdep is turned off.
gnome-help    D 000000A3     0  8866      1 (NOTLB)
       d020aeac 00000096 1069bc8b 000000a3 00000000 d020ae94 c0216c13 c7c295e0
       c7c29770 c265c100 1069bc8b 000000a3 00000000 c0157c10 c8205680 00000046
       d020aea0 c81c3684 b46b82f8 00000000 b46b82f8 0000000e d020aeb8 c0157c3d
Call Trace:
 [<c0157c3d>] refrigerator+0xcb/0xda
 [<c0138d38>] get_signal_to_deliver+0x33/0x463
 [<c01077ea>] do_notify_resume+0x94/0x732
 [<c01082f9>] work_notifysig+0x13/0x1a
 [<ffffe410>] 0xffffe410
 =======================
INFO: lockdep is turned off.
gnome-help    D 000000A3     0  8871      1 (NOTLB)
       d023deac 00000096 1069ad01 000000a3 00000000 d023de94 c0216c13 c80e6270
       c80e6400 c265c100 1069ad01 000000a3 00000000 c0157c10 c8205680 00000046
       d023dea0 c81c3684 b3eb72f8 00000000 b3eb72f8 0000000c d023deb8 c0157c3d
Call Trace:
 [<c0157c3d>] refrigerator+0xcb/0xda
 [<c0138d38>] get_signal_to_deliver+0x33/0x463
 [<c01077ea>] do_notify_resume+0x94/0x732
 [<c01082f9>] work_notifysig+0x13/0x1a
 [<ffffe410>] 0xffffe410
 =======================
INFO: lockdep is turned off.
gnome-help    D 000000A3     0  8872      1 (NOTLB)
       d0210eac 00000096 1069a016 000000a3 00000000 d0210e94 c0216c13 c81e41a0
       c81e4330 c265c100 1069a016 000000a3 00000000 c0157c10 c8205680 00000046
       d0210ea0 c81c3684 b36b62f8 00000000 b36b62f8 0000000a d0210eb8 c0157c3d
Call Trace:
 [<c0157c3d>] refrigerator+0xcb/0xda
 [<c0138d38>] get_signal_to_deliver+0x33/0x463
 [<c01077ea>] do_notify_resume+0x94/0x732
 [<c01082f9>] work_notifysig+0x13/0x1a
 [<ffffe410>] 0xffffe410
 =======================
INFO: lockdep is turned off.
gnome-help    D 000000A3     0  8873      1 (NOTLB)
       d0037eac 00000096 10699021 000000a3 00000000 d0037e94 c0216c13 c7fb4c90
       c7fb4e20 c265c100 10699021 000000a3 00000000 c0157c10 c8205680 00000046
       d0037ea0 c81c3684 b2eb52f8 00000000 b2eb52f8 0000000b d0037eb8 c0157c3d
Call Trace:
 [<c0157c3d>] refrigerator+0xcb/0xda
 [<c0138d38>] get_signal_to_deliver+0x33/0x463
 [<c01077ea>] do_notify_resume+0x94/0x732
 [<c01082f9>] work_notifysig+0x13/0x1a
 [<ffffe410>] 0xffffe410
 =======================
INFO: lockdep is turned off.
gnome-help    D 000000A3     0  8811      1 (NOTLB)
       c81feeac 00000096 10697dc8 000000a3 00000000 c81fee94 c0216c13 c81e6270
       c81e6400 c265c100 10697dc8 000000a3 00000000 c0157c10 c8204a00 00000046
       c81feea0 c81c4c84 ffffffff 00000000 ffffffff b7537ff4 c81feeb8 c0157c3d
Call Trace:
 [<c0157c3d>] refrigerator+0xcb/0xda
 [<c0138d38>] get_signal_to_deliver+0x33/0x463
 [<c01077ea>] do_notify_resume+0x94/0x732
 [<c01082f9>] work_notifysig+0x13/0x1a
 [<ffffe410>] 0xffffe410
 =======================
INFO: lockdep is turned off.
gnome-help    D 000000A3     0  8812      1 (NOTLB)
       cf26ceac 00200096 10694954 000000a3 00000000 cf26ce94 c0216c13 c81e20d0
       c81e2260 c265c100 10694954 000000a3 00000000 c0157c10 c8204a00 00200046
       cf26cea0 c81c4c84 ffffffff 00000000 ffffffff b7537ff4 cf26ceb8 c0157c3d
Call Trace:
 [<c0157c3d>] refrigerator+0xcb/0xda
 [<c0138d38>] get_signal_to_deliver+0x33/0x463
 [<c01077ea>] do_notify_resume+0x94/0x732
 [<c01082f9>] work_notifysig+0x13/0x1a
 [<ffffe410>] 0xffffe410
 =======================
INFO: lockdep is turned off.
gnome-help    D 000000A3     0  8831      1 (NOTLB)
       cf3a8eac 00000096 106936e7 000000a3 00000000 cf3a8e94 c0216c13 c80e6d60
       c80e6ef0 c265c100 106936e7 000000a3 00000000 c0157c10 c8204a00 00000046
       cf3a8ea0 c81c4c84 b4f2c2d8 00000000 b4f2c2d8 0000001b cf3a8eb8 c0157c3d
Call Trace:
 [<c0157c3d>] refrigerator+0xcb/0xda
 [<c0138d38>] get_signal_to_deliver+0x33/0x463
 [<c01077ea>] do_notify_resume+0x94/0x732
 [<c01082f9>] work_notifysig+0x13/0x1a
 [<ffffe410>] 0xffffe410
 =======================
INFO: lockdep is turned off.
gnome-help    D 000000A3     0  8874      1 (NOTLB)
       d026beac 00000096 1069271b 000000a3 00000000 d026be94 c0216c13 c7fb5780
       c7fb5910 c265c100 1069271b 000000a3 00000000 c0157c10 c8204a00 00000046
       d026bea0 c81c4c84 b470a2f8 00000000 b470a2f8 0000000b d026beb8 c0157c3d
Call Trace:
 [<c0157c3d>] refrigerator+0xcb/0xda
 [<c0138d38>] get_signal_to_deliver+0x33/0x463
 [<c01077ea>] do_notify_resume+0x94/0x732
 [<c01082f9>] work_notifysig+0x13/0x1a
 [<ffffe410>] 0xffffe410
 =======================
INFO: lockdep is turned off.
hal-system-po D 000000A3     0  8947   3270 (NOTLB)
       c38f8eac 00000096 10690b20 000000a3 00000000 c38f8e94 c0216c13 d02ac1a0
       d02ac330 c265c100 10690b20 000000a3 00000000 c0157c10 c8206f80 00000046
       c38f8ea0 c81c3c04 00000000 00000000 00000000 00000002 c38f8eb8 c0157c3d
Call Trace:
 [<c0157c3d>] refrigerator+0xcb/0xda
 [<c0138d38>] get_signal_to_deliver+0x33/0x463
 [<c01077ea>] do_notify_resume+0x94/0x732
 [<c01082f9>] work_notifysig+0x13/0x1a
 [<ffffe410>] 0xffffe410
 =======================
INFO: lockdep is turned off.
sleep.sh      R running     0  8950   8947 (NOTLB)
sleep         D 000000A3     0  9179   3138 (NOTLB)
       d0290eac 00000096 1068fae7 000000a3 00000000 d0290e94 c0216c13 c7e06d60
       c7e06ef0 c265c100 1068fae7 000000a3 00000000 c0157c10 c8206a80 00000046
       d0290ea0 c81c0504 00003800 00000000 00003800 bfe51b84 d0290eb8 c0157c3d
Call Trace:
 [<c0157c3d>] refrigerator+0xcb/0xda
 [<c0138d38>] get_signal_to_deliver+0x33/0x463
 [<c01077ea>] do_notify_resume+0x94/0x732
 [<c01082f9>] work_notifysig+0x13/0x1a
 [<ffffe410>] 0xffffe410
 =======================
INFO: lockdep is turned off.
Sched Debug Version: v0.03, cfs-v18, 2.6.22-rc6-mm1 #5
now at 2497717146522 nsecs

cpu#0, 1695.816 MHz
  .nr_running                    : 3
  .load                          : 7274
  .ls.delta_fair                 : 0
  .ls.delta_exec                 : 0
  .nr_switches                   : 4289589
  .nr_load_updates               : 540286
  .nr_uninterruptible            : 122
  .jiffies                       : 659315
  .next_balance                  : 659316
  .curr->pid                     : 8950
  .clock                         : 720611929165
  .prev_clock_raw                : 2497653753083
  .clock_warps                   : 4
  .clock_overflows               : 2011
  .clock_unstable_events         : 790682
  .clock_max_delta               : 6658663
  .cfs.fair_clock                : 509996739129
  .cfs.exec_clock                : 687440516127
  .cfs.wait_runtime              : -32985396
  .cfs.wait_runtime_overruns     : 0
  .cfs.wait_runtime_underruns    : 0
  .cpu_load[0]                   : 7273
  .cpu_load[1]                   : 7257
  .cpu_load[2]                   : 7231
  .cpu_load[3]                   : 7201
  .cpu_load[4]                   : 7142
  .wait_runtime_rq_sum           : 26666664

runnable tasks:
            task   PID        tree-key         delta       waiting
switches  prio        sum-exec        sum-wait       sum-sleep
wait-overrun   wait-underrun
------------------------------------------------------------------------------------------------------------------------------------------------------------------
        events/0     6    509880268636    -116965572      26666664
60076   115      1211907516               0               0
   0               0
     kondemand/0   479    509880268886    -116965322      26666664
35704   115       643532080               0               0
   0               0
R       sleep.sh  8950    510023900872      26666664     -26666664
  474   120     20281432459               0               0
   0               0

 cat
 tail
 cat
 cat
 cat
Restarting tasks ... done.
8139too Fast Ethernet driver 0.9.28
ACPI: PCI Interrupt 0000:01:00.0[A] -> GSI 16 (level, low) -> IRQ 19
eth0 renamed to eth2
eth2: link down
ADDRCONF(NETDEV_UP): eth2: link is not ready
eth2: RealTek RTL8139 at 0xf894e800, 00:c0:9f:95:18:1b, IRQ 19
eth2:  Identified 8139 chip type 'RTL-8100B/8139D'
ieee80211: 802.11 data/management/control stack, git-1.1.13
ieee80211: Copyright (C) 2004-2005 Intel Corporation <jketreno@linux.intel.com>
ipw2200: Intel(R) PRO/Wireless 2200/2915 Network Driver, 1.2.0kd
ipw2200: Copyright(c) 2003-2006 Intel Corporation
ACPI: PCI Interrupt 0000:01:06.0[A] -> GSI 18 (level, low) -> IRQ 18
ipw2200: Detected Intel PRO/Wireless 2200BG Network Connection
eth0 renamed to eth3
ipw2200: Detected geography ZZM (11 802.11bg channels, 0 802.11a channels)
input: Power Button (FF) as /devices/virtual/input/input5
ACPI: Power Button (FF) [PWRF]
input: Lid Switch as /devices/virtual/input/input6
ACPI: Lid Switch [LID0]
input: Sleep Button (CM) as /devices/virtual/input/input7
ACPI: Sleep Button (CM) [SLPB]
ACPI: AC Adapter [ACAD] (off-line)
ACPI: Battery Slot [BAT0] (battery present)
ACPI: PCI interrupt for device 0000:01:00.0 disabled
ACPI: PCI interrupt for device 0000:01:06.0 disabled
Stopping tasks ...
Freezing of user space  timed out after 20 seconds (5 tasks refusing to freeze):

                         free                        sibling
  task             PC    stack   pid father child younger older
init          D 000000AA     0     1      0 (NOTLB)
       c2848eac 00000096 356994f4 000000aa 00000000 c2848e94 c0216c13 c2858000
       c2858190 c265c100 356994f4 000000aa 00000000 c0157c10 c32b8780 00000046
       c2848ea0 c338ab84 bfc9e11c 00000000 bfc9e11c 00000000 c2848eb8 c0157c3d
Call Trace:
 [<c0157c3d>] refrigerator+0xcb/0xda
 [<c0138d38>] get_signal_to_deliver+0x33/0x463
 [<c01077ea>] do_notify_resume+0x94/0x732
 [<c01082f9>] work_notifysig+0x13/0x1a
 [<ffffe410>] 0xffffe410
 =======================
INFO: lockdep is turned off.
kthreadd      S 000000A9     0     2      0 (L-TLB)
       c2847fcc 00000092 de1b8d90 000000a9 00000000 c2847fb4 c0216c13 c2858af0
       c2858c80 c265c100 de1b8d90 000000a9 00000000 c013fac1 c8206800 00000246
       c2847fc0 c0216abf c0520d48 c0520d40 0000296a d0290e64 c2847fe0 c013fa29
Call Trace:
 [<c013fa29>] kthreadd+0x37/0xd4
 [<c0108eab>] kernel_thread_helper+0x7/0x10
 =======================
INFO: lockdep is turned off.
migration/0   S 00000000     0     3      2 (L-TLB)
       c2846fa0 00000086 0923af1f 00000000 c2859ba8 c28595e0 c2859ba0 c28595e0
       c2859770 c265c100 0923af1f 00000000 00000000 c0129aa0 c0514180 00000046
       c2846f94 c265c100 c265c100 c265c53c c265c100 00000000 c2846fd0 c0129aa5
Call Trace:
 [<c0129aa5>] migration_thread+0x178/0x204
 [<c013fba7>] kthread+0x3b/0x64
 [<c0108eab>] kernel_thread_helper+0x7/0x10
 =======================
INFO: lockdep is turned off.
ksoftirqd/0   S 000000AE     0     4      2 (L-TLB)
       c2845fc4 00000096 b94a62a9 000000ae c0366252 c2845fa0 c014b438 c285a0d0
       c285a260 c265c100 b94a62a9 000000ae 00000000 c2845fc4 c8204f00 00000000
       c0132be9 00000000 c2845fbc 00000000 c0132be9 00000000 c2845fd0 c0132c0e
Call Trace:
 [<c0132c0e>] ksoftirqd+0x25/0xbd
 [<c013fba7>] kthread+0x3b/0x64
 [<c0108eab>] kernel_thread_helper+0x7/0x10
 =======================
INFO: lockdep is turned off.
watchdog/0    S 00000000     0     5      2 (L-TLB)
       c2844fc4 00000096 0923b057 00000000 c010e74a c2844f90 00000292 c285abc0
       c285ad50 c265c100 0923b057 00000000 00000000 c05c4108 c0514180 00000000
       c2844fb4 c015d367 c2844fc4 00000000 c015d4a9 00000000 c2844fd0 c015d4e8
Call Trace:
 [<c015d4e8>] watchdog+0x3f/0x4f
 [<c013fba7>] kthread+0x3b/0x64
 [<c0108eab>] kernel_thread_helper+0x7/0x10
 =======================
INFO: lockdep is turned off.
events/0      S 000000AE     0     6      2 (L-TLB)
       c2842fac 00000096 ccda6867 000000ae c2842f84 c014b438 c013fdee c285b6b0
       c285b840 c265c100 ccda6867 000000ae 00000000 00000282 c8204f00 c2813394
       c2842fac c013fdee 00000282 c2813370 c013d0c1 c2842fc8 c2842fd0 c013d149
Call Trace:
 [<c013d149>] worker_thread+0x88/0xc7
 [<c013fba7>] kthread+0x3b/0x64
 [<c0108eab>] kernel_thread_helper+0x7/0x10
 =======================
INFO: lockdep is turned off.
khelper       S 000000A9     0     7      2 (L-TLB)
       c2841fac 00000096 eb784b6c 000000a9 c2841f84 c014b438 c013fdee c285c1a0
       c285c330 c265c100 eb784b6c 000000a9 00000000 00000282 c398aa80 c2813444
       c2841fac c013fdee 00000282 c2813420 c013d0c1 c2841fc8 c2841fd0 c013d149
Call Trace:
 [<c013d149>] worker_thread+0x88/0xc7
 [<c013fba7>] kthread+0x3b/0x64
 [<c0108eab>] kernel_thread_helper+0x7/0x10
 =======================
INFO: lockdep is turned off.
kblockd/0     S 000000A9     0    52      2 (L-TLB)
       c28c9fac 00000096 c95b5d5c 000000a9 c28c9f84 c014b438 c013fdee c28815e0
       c2881770 c265c100 c95b5d5c 000000a9 00000000 00000282 c8205e00 c283b2e4
       c28c9fac c013fdee 00000282 c283b2c0 c013d0c1 c28c9fc8 c28c9fd0 c013d149
Call Trace:
 [<c013d149>] worker_thread+0x88/0xc7
 [<c013fba7>] kthread+0x3b/0x64
 [<c0108eab>] kernel_thread_helper+0x7/0x10
 =======================
INFO: lockdep is turned off.
kacpid        S 000000AC     0    55      2 (L-TLB)
       c28c6fac 00000096 067c7599 000000ac c28c6f84 c014b438 c013fdee c285ed60
       c285eef0 c265c100 067c7599 000000ac 00000000 00000282 c8204f00 c283b4f4
       c28c6fac c013fdee 00000282 c283b4d0 c013d0c1 c28c6fc8 c28c6fd0 c013d149
Call Trace:
 [<c013d149>] worker_thread+0x88/0xc7
 [<c013fba7>] kthread+0x3b/0x64
 [<c0108eab>] kernel_thread_helper+0x7/0x10
 =======================
INFO: lockdep is turned off.
kacpi_notify  S 000000AC     0    56      2 (L-TLB)
       c28c5fac 00000096 067c6cab 000000ac c28c5f84 c014b438 c013fdee c285e270
       c285e400 c265c100 067c6cab 000000ac 00000000 00000282 c8204f00 c283b5a4
       c28c5fac c013fdee 00000282 c283b580 c013d0c1 c28c5fc8 c28c5fd0 c013d149
Call Trace:
 [<c013d149>] worker_thread+0x88/0xc7
 [<c013fba7>] kthread+0x3b/0x64
 [<c0108eab>] kernel_thread_helper+0x7/0x10
 =======================
INFO: lockdep is turned off.
ata/0         S 000000AA     0   153      2 (L-TLB)
       c2917fac 00000096 32e2d397 000000aa c2917f84 c014b438 c013fdee c29395e0
       c2939770 c265c100 32e2d397 000000aa 00000000 00000282 c3988c80 c283bc84
       c2917fac c013fdee 00000282 c283bc60 c013d0c1 c2917fc8 c2917fd0 c013d149
Call Trace:
 [<c013d149>] worker_thread+0x88/0xc7
 [<c013fba7>] kthread+0x3b/0x64
 [<c0108eab>] kernel_thread_helper+0x7/0x10
 =======================
INFO: lockdep is turned off.
ata_aux       S 00000000     0   154      2 (L-TLB)
       c2915fac 00000096 0f06bdb4 00000000 c2915f84 c014b598 c013fdee c293a0d0
       c293a260 c265c100 0f06bdb4 00000000 00000000 00000282 c0514180 c283bd34
       c2915fac c013fdee 00000282 c283bd10 c013d0c1 c2915fc8 c2915fd0 c013d149
Call Trace:
 [<c013d149>] worker_thread+0x88/0xc7
 [<c013fba7>] kthread+0x3b/0x64
 [<c0108eab>] kernel_thread_helper+0x7/0x10
 =======================
INFO: lockdep is turned off.
kseriod       S 00000000     0   158      2 (L-TLB)
       c290ff94 00000096 599fa437 00000000 c290ff6c c014b598 c013fdee c293cc90
       c293ce20 c265c100 599fa437 00000000 00000000 00000292 c329c280 c054a900
       c290ff94 c013fdee 00000292 c3381370 c3381320 c290ffc4 c290ffd0 c02bcc79
Call Trace:
 [<c02bcc79>] serio_thread+0x279/0x2c4
 [<c013fba7>] kthread+0x3b/0x64
 [<c0108eab>] kernel_thread_helper+0x7/0x10
 =======================
INFO: lockdep is turned off.
rt-test-0     S 00000000     0   193      2 (L-TLB)
       c291afc0 00000086 21528113 00000000 00000000 c2938000 c0368f94 c2938000
       c2938190 c265c100 21528113 00000000 00000000 c291afa8 c0514180 c084e760
       c291afb4 c0368f94 00000001 00000001 c084e760 00000000 c291afd0 c0151222
Call Trace:
 [<c0151222>] test_func+0x63/0xb8
 [<c013fba7>] kthread+0x3b/0x64
 [<c0108eab>] kernel_thread_helper+0x7/0x10
 =======================
INFO: lockdep is turned off.
rt-test-1     S 00000000     0   195      2 (L-TLB)
       c290efc0 00000086 2155ed84 00000000 00000000 c285d780 c0368f94 c285d780
       c285d910 c265c100 2155ed84 00000000 00000000 c290efa8 c0514180 c084e7f0
       c290efb4 c0368f94 00000001 00000001 c084e7f0 00000000 c290efd0 c0151222
Call Trace:
 [<c0151222>] test_func+0x63/0xb8
 [<c013fba7>] kthread+0x3b/0x64
 [<c0108eab>] kernel_thread_helper+0x7/0x10
 =======================
INFO: lockdep is turned off.
rt-test-2     S 00000000     0   197      2 (L-TLB)
       c2891fc0 00000086 215959ed 00000000 00000000 c2880af0 c0368f94 c2880af0
       c2880c80 c265c100 215959ed 00000000 00000000 c2891fa8 c0514180 c084e880
       c2891fb4 c0368f94 00000001 00000001 c084e880 00000000 c2891fd0 c0151222
Call Trace:
 [<c0151222>] test_func+0x63/0xb8
 [<c013fba7>] kthread+0x3b/0x64
 [<c0108eab>] kernel_thread_helper+0x7/0x10
 =======================
INFO: lockdep is turned off.
rt-test-3     S 00000000     0   199      2 (L-TLB)
       c2905fc0 00000086 215d4fbb 00000000 00000000 c2882bc0 c0368f94 c2882bc0
       c2882d50 c265c100 215d4fbb 00000000 00000000 c2905fa8 c0514180 c084e910
       c2905fb4 c0368f94 00000001 00000001 c084e910 00000000 c2905fd0 c0151222
Call Trace:
 [<c0151222>] test_func+0x63/0xb8
 [<c013fba7>] kthread+0x3b/0x64
 [<c0108eab>] kernel_thread_helper+0x7/0x10
 =======================
INFO: lockdep is turned off.
rt-test-4     S 00000000     0   201      2 (L-TLB)
       c335afc0 00000086 2160dc86 00000000 00000000 c2884c90 c0368f94 c2884c90
       c2884e20 c265c100 2160dc86 00000000 00000000 c335afa8 c0514180 c084e9a0
       c335afb4 c0368f94 00000001 00000001 c084e9a0 00000000 c335afd0 c0151222
Call Trace:
 [<c0151222>] test_func+0x63/0xb8
 [<c013fba7>] kthread+0x3b/0x64
 [<c0108eab>] kernel_thread_helper+0x7/0x10
 =======================
INFO: lockdep is turned off.
rt-test-5     S 00000000     0   203      2 (L-TLB)
       c3358fc0 00000086 216421f8 00000000 00000000 c2886270 c0368f94 c2886270
       c2886400 c265c100 216421f8 00000000 00000000 c3358fa8 c0514180 c084ea30
       c3358fb4 c0368f94 00000001 00000001 c084ea30 00000000 c3358fd0 c0151222
Call Trace:
 [<c0151222>] test_func+0x63/0xb8
 [<c013fba7>] kthread+0x3b/0x64
 [<c0108eab>] kernel_thread_helper+0x7/0x10
 =======================
INFO: lockdep is turned off.
rt-test-6     S 00000000     0   205      2 (L-TLB)
       c3356fc0 00000086 2167cafd 00000000 00000000 c28841a0 c0368f94 c28841a0
       c2884330 c265c100 2167cafd 00000000 00000000 c3356fa8 c0514180 c084eac0
       c3356fb4 c0368f94 00000001 00000001 c084eac0 00000000 c3356fd0 c0151222
Call Trace:
 [<c0151222>] test_func+0x63/0xb8
 [<c013fba7>] kthread+0x3b/0x64
 [<c0108eab>] kernel_thread_helper+0x7/0x10
 =======================
INFO: lockdep is turned off.
rt-test-7     S 00000000     0   207      2 (L-TLB)
       c3354fc0 00000086 216b1fe3 00000000 00000000 c33c0af0 c0368f94 c33c0af0
       c33c0c80 c265c100 216b1fe3 00000000 00000000 c3354fa8 c0514180 c084eb50
       c3354fb4 c0368f94 00000001 00000001 c084eb50 00000000 c3354fd0 c0151222
Call Trace:
 [<c0151222>] test_func+0x63/0xb8
 [<c013fba7>] kthread+0x3b/0x64
 [<c0108eab>] kernel_thread_helper+0x7/0x10
 =======================
INFO: lockdep is turned off.
pdflush       S 000000AA     0   210      2 (L-TLB)
       c3350fa8 00000096 16e6cb7a 000000aa 00000000 c3350f90 c0216c13 c33c2bc0
       c33c2d50 c265c100 16e6cb7a 000000aa 00000000 c01670e4 c7f13c00 00000046
       c3350f9c c05277e4 c0167042 c3350fc0 c0167042 00000000 c3350fd0 c01670e9
Call Trace:
 [<c01670e9>] pdflush+0xa7/0x194
 [<c013fba7>] kthread+0x3b/0x64
 [<c0108eab>] kernel_thread_helper+0x7/0x10
 =======================
INFO: lockdep is turned off.
pdflush       S 000000AA     0   211      2 (L-TLB)
       c33effa8 00000096 1a93f278 000000aa 00000000 c33eff90 c0216c13 c33c36b0
       c33c3840 c265c100 1a93f278 000000aa 00000000 c01670e4 c8205e00 00000046
       c33eff9c c05277e4 c0167042 c33effc0 c0167042 00000000 c33effd0 c01670e9
Call Trace:
 [<c01670e9>] pdflush+0xa7/0x194
 [<c013fba7>] kthread+0x3b/0x64
 [<c0108eab>] kernel_thread_helper+0x7/0x10
 =======================
INFO: lockdep is turned off.
kswapd0       S 000000A1     0   212      2 (L-TLB)
       c33eef44 00000092 cb3a0bc8 000000a1 c33eef1c c014b438 c013fdee c33c41a0
       c33c4330 c265c100 cb3a0bc8 000000a1 00000000 00000296 c3988a00 c0526efc
       c33eef44 c013fdee 00000296 00000001 ffffffff c0526700 c33eefd0 c016a3b1
Call Trace:
 [<c016a3b1>] kswapd+0xc7/0x3fa
 [<c013fba7>] kthread+0x3b/0x64
 [<c0108eab>] kernel_thread_helper+0x7/0x10
 =======================
INFO: lockdep is turned off.
kprefetchd    S 00000000     0   213      2 (L-TLB)
       c3370fa4 00000092 2181b982 00000000 c3370f6c 00000296 c265c100 c33c4c90
       c33c4e20 c265c100 2181b982 00000000 00000000 c33c4c90 c0514180 c265c100
       c265c138 c265c138 00000296 00000000 c0178f82 00000000 c3370fd0 c017900a
Call Trace:
 [<c017900a>] kprefetchd+0x88/0x34e
 [<c013fba7>] kthread+0x3b/0x64
 [<c0108eab>] kernel_thread_helper+0x7/0x10
 =======================
INFO: lockdep is turned off.
aio/0         S 00000000     0   306      2 (L-TLB)
       c33fafac 00000096 230b2f58 00000000 c33faf84 c014b598 c013fdee c33c15e0
       c33c1770 c265c100 230b2f58 00000000 00000000 00000282 c0514180 c33ff7b4
       c33fafac c013fdee 00000282 c33ff790 c013d0c1 c33fafc8 c33fafd0 c013d149
Call Trace:
 [<c013d149>] worker_thread+0x88/0xc7
 [<c013fba7>] kthread+0x3b/0x64
 [<c0108eab>] kernel_thread_helper+0x7/0x10
 =======================
INFO: lockdep is turned off.
khvcd         S 00000000     0   403      2 (L-TLB)
       c3325fc0 00000086 247bd613 00000000 c327d258 c327cc90 c327d250 c327cc90
       c327ce20 c265c100 247bd613 00000000 00000000 c0275212 c0514180 00000246
       c3325fb4 c0216abf c0540a00 c05409d4 00000000 00000000 c3325fd0 c027524a
Call Trace:
 [<c027524a>] khvcd+0xb7/0x101
 [<c013fba7>] kthread+0x3b/0x64
 [<c0108eab>] kernel_thread_helper+0x7/0x10
 =======================
INFO: lockdep is turned off.
scsi_eh_0     S 00000000     0   442      2 (L-TLB)
       c333af7c 00000096 301304b3 00000000 c333af40 c33b8040 00000296 c33c0000
       c33c0190 c265c100 301304b3 00000000 00000000 00000000 c0514180 00000292
       c33b8000 00000000 c333af7c 00000292 c33b8000 00000000 c333afd0 c0295125
Call Trace:
 [<c0295125>] scsi_error_handler+0x30/0x27d
 [<c013fba7>] kthread+0x3b/0x64
 [<c0108eab>] kernel_thread_helper+0x7/0x10
 =======================
INFO: lockdep is turned off.
scsi_eh_1     S 000000AA     0   444      2 (L-TLB)
       c333cf7c 00000096 32e17b02 000000aa c020406b c333cf40 c02872f1 c33c5780
       c33c5910 c265c100 32e17b02 000000aa 00000000 c33b94f0 c8204c80 c33b94f0
       c33b8430 00000000 c333cf7c 00000292 c33b8430 00000000 c333cfd0 c0295125
Call Trace:
 [<c0295125>] scsi_error_handler+0x30/0x27d
 [<c013fba7>] kthread+0x3b/0x64
 [<c0108eab>] kernel_thread_helper+0x7/0x10
 =======================
INFO: lockdep is turned off.
kpsmoused     S 00000000     0   472      2 (L-TLB)
       c33a9fac 00000096 347350c3 00000000 c33a9f84 c014b598 c013fdee c285cc90
       c285ce20 c265c100 347350c3 00000000 00000000 00000282 c0514180 c3283024
       c33a9fac c013fdee 00000282 c3283000 c013d0c1 c33a9fc8 c33a9fd0 c013d149
Call Trace:
 [<c013d149>] worker_thread+0x88/0xc7
 [<c013fba7>] kthread+0x3b/0x64
 [<c0108eab>] kernel_thread_helper+0x7/0x10
 =======================
INFO: lockdep is turned off.
kondemand/0   R running     0   479      2 (L-TLB)
ksuspend_usbd S 00000034     0  1067      2 (L-TLB)
       c299ffac 00000096 3d64711b 00000034 c299ff84 c014b438 c013fdee c29f4c90
       c29f4e20 c265c100 3d64711b 00000034 00000000 00000282 c32bb700 c3365914
       c299ffac c013fdee 00000282 c33658f0 c013d0c1 c299ffc8 c299ffd0 c013d149
Call Trace:
 [<c013d149>] worker_thread+0x88/0xc7
 [<c013fba7>] kthread+0x3b/0x64
 [<c0108eab>] kernel_thread_helper+0x7/0x10
 =======================
INFO: lockdep is turned off.
khubd         S 00000034     0  1073      2 (L-TLB)
       c3839f34 00000092 1484c7e3 00000034 c3839f0c c014b438 c013fdee c29f6d60
       c29f6ef0 c265c100 1484c7e3 00000034 00000000 00000292 c7f13200 f8874c40
       c3839f34 c013fdee 00000292 f8874c1c c32af6b0 c3839fb8 c3839fd0 f8859ab4
Call Trace:
 [<f8859ab4>] hub_thread+0x9ec/0xa57 [usbcore]
 [<c013fba7>] kthread+0x3b/0x64
 [<c0108eab>] kernel_thread_helper+0x7/0x10
 =======================
INFO: lockdep is turned off.
kjournald     S 000000AA     0  1348      2 (L-TLB)
       c2994fa0 00000086 1a00fd86 000000aa c2994f78 c014b438 c013fdee c29f41a0
       c29f4330 c265c100 1a00fd86 000000aa 00000000 c01d61d7 c32b8000 00000246
       c2994f94 c0216abf c38a90d4 c38a90d4 c38a90c0 c2994fc4 c2994fd0 c01d61dc
Call Trace:
 [<c01d61dc>] kjournald+0x169/0x1e8
 [<c013fba7>] kthread+0x3b/0x64
 [<c0108eab>] kernel_thread_helper+0x7/0x10
 =======================
INFO: lockdep is turned off.
udevd         D 000000AA     0  1510      1 (NOTLB)
       c388feac 00000096 355a672e 000000aa 00000000 c388fe94 c0216c13 c29f20d0
       c29f2260 c265c100 355a672e 000000aa 00000000 c0157c10 c32b8000 00000046
       c388fea0 c29dbc04 00000000 00000000 00000000 00000000 c388feb8 c0157c3d
Call Trace:
 [<c0157c3d>] refrigerator+0xcb/0xda
 [<c0138d38>] get_signal_to_deliver+0x33/0x463
 [<c01077ea>] do_notify_resume+0x94/0x732
 [<c01082f9>] work_notifysig+0x13/0x1a
 [<ffffe410>] 0xffffe410
 =======================
INFO: lockdep is turned off.
tifm          S 00000002     0  1912      2 (L-TLB)
       c32b1fac 00000096 328602e7 00000002 c32b1f84 c014b598 c013fdee c3942bc0
       c3942d50 c265c100 328602e7 00000002 00000000 00000282 c32b8f00 c325fd34
       c32b1fac c013fdee 00000282 c325fd10 c013d0c1 c32b1fc8 c32b1fd0 c013d149
Call Trace:
 [<c013d149>] worker_thread+0x88/0xc7
 [<c013fba7>] kthread+0x3b/0x64
 [<c0108eab>] kernel_thread_helper+0x7/0x10
 =======================
INFO: lockdep is turned off.
kmmcd         S 00000002     0  1939      2 (L-TLB)
       c395ffac 00000096 590b1ca2 00000002 c395ff84 c014b598 c013fdee c3944c90
       c3944e20 c265c100 590b1ca2 00000002 00000000 00000282 c398b200 c325fc84
       c395ffac c013fdee 00000282 c325fc60 c013d0c1 c395ffc8 c395ffd0 c013d149
Call Trace:
 [<c013d149>] worker_thread+0x88/0xc7
 [<c013fba7>] kthread+0x3b/0x64
 [<c0108eab>] kernel_thread_helper+0x7/0x10
 =======================
INFO: lockdep is turned off.
pccardd       S 00000002     0  2019      2 (L-TLB)
       c39aff9c 00000092 566b6848 00000002 c39441a0 c3944760 00000000 c39441a0
       c3944330 c265c100 566b6848 00000002 00000000 c38a74d0 c32ba800 c39aff8c
       c38a74c0 00000296 c39aff9c c38a74c0 c38a72e0 00000000 c39affd0 f897ab30
Call Trace:
 [<f897ab30>] pccardd+0x1a7/0x1f3 [pcmcia_core]
 [<c013fba7>] kthread+0x3b/0x64
 [<c0108eab>] kernel_thread_helper+0x7/0x10
 =======================
INFO: lockdep is turned off.
kjournald     S 00000049     0  2291      2 (L-TLB)
       c39a7fa0 00000086 76a760f1 00000049 c39a7f78 c014b438 c013fdee c3976270
       c3976400 c265c100 76a760f1 00000049 00000000 c01d61d7 c7f12080 00000246
       c39a7f94 c0216abf c3a2e494 c3a2e494 c3a2e480 c39a7fc4 c39a7fd0 c01d61dc
Call Trace:
 [<c01d61dc>] kjournald+0x169/0x1e8
 [<c013fba7>] kthread+0x3b/0x64
 [<c0108eab>] kernel_thread_helper+0x7/0x10
 =======================
INFO: lockdep is turned off.
kjournald     S 0000004C     0  2292      2 (L-TLB)
       c3a6dfa0 00000086 3f284f6c 0000004c c3a6df78 c014b438 c013fdee c39720d0
       c3972260 c265c100 3f284f6c 0000004c 00000000 c01d61d7 c8204a00 00000246
       c3a6df94 c0216abf c3a2ecf4 c3a2ecf4 c3a2ece0 c3a6dfc4 c3a6dfd0 c01d61dc
Call Trace:
 [<c01d61dc>] kjournald+0x169/0x1e8
 [<c013fba7>] kthread+0x3b/0x64
 [<c0108eab>] kernel_thread_helper+0x7/0x10
 =======================
INFO: lockdep is turned off.
kjournald     S 000000A1     0  2295      2 (L-TLB)
       c3929fa0 00000086 783f7bac 000000a1 c3929f78 c014b438 c013fdee c3975780
       c3975910 c265c100 783f7bac 000000a1 00000000 c01d61d7 c7cc2800 00000246
       c3929f94 c0216abf c3a2f984 c3a2f984 c3a2f970 c3929fc4 c3929fd0 c01d61dc
Call Trace:
 [<c01d61dc>] kjournald+0x169/0x1e8
 [<c013fba7>] kthread+0x3b/0x64
 [<c0108eab>] kernel_thread_helper+0x7/0x10
 =======================
INFO: lockdep is turned off.
kjournald     S 00000004     0  2296      2 (L-TLB)
       c3867fa0 00000086 9dc344ae 00000004 c3971ba8 c39715e0 c3971ba0 c39715e0
       c3971770 c265c100 9dc344ae 00000004 00000000 c01d61d7 c3988c80 00000246
       c3867f94 c0216abf c38aa5c4 c38aa5c4 c38aa5b0 c3867fc4 c3867fd0 c01d61dc
Call Trace:
 [<c01d61dc>] kjournald+0x169/0x1e8
 [<c013fba7>] kthread+0x3b/0x64
 [<c0108eab>] kernel_thread_helper+0x7/0x10
 =======================
INFO: lockdep is turned off.
getty         D 000000AA     0  2604      1 (NOTLB)
       c3a02eac 00000096 356975f4 000000aa 00000000 c3a02e94 c0216c13 c293d780
       c293d910 c265c100 356975f4 000000aa 00000000 c0157c10 c398b980 00000046
       c3a02ea0 c39de284 0804b214 00000000 0804b214 bfb5d8f8 c3a02eb8 c0157c3d
Call Trace:
 [<c0157c3d>] refrigerator+0xcb/0xda
 [<c0138d38>] get_signal_to_deliver+0x33/0x463
 [<c01077ea>] do_notify_resume+0x94/0x732
 [<c01082f9>] work_notifysig+0x13/0x1a
 [<ffffe410>] 0xffffe410
 =======================
INFO: lockdep is turned off.
getty         D 000000AA     0  2605      1 (NOTLB)
       c84f6eac 00000096 35695fb8 000000aa 00000000 c84f6e94 c0216c13 c293abc0
       c293ad50 c265c100 35695fb8 000000aa 00000000 c0157c10 c3988780 00000046
       c84f6ea0 c39ded84 0804b214 00000000 0804b214 bf8e2678 c84f6eb8 c0157c3d
Call Trace:
 [<c0157c3d>] refrigerator+0xcb/0xda
 [<c0138d38>] get_signal_to_deliver+0x33/0x463
 [<c01077ea>] do_notify_resume+0x94/0x732
 [<c01082f9>] work_notifysig+0x13/0x1a
 [<ffffe410>] 0xffffe410
 =======================
INFO: lockdep is turned off.
login         D 000000AA     0  2609      1 (NOTLB)
       c339beac 00000096 35694a5f 000000aa 00000000 c339be94 c0216c13 c3946d60
       c3946ef0 c265c100 35694a5f 000000aa 00000000 c0157c10 c8205400 00000046
       c339bea0 c39dbc04 00000000 00000000 00000000 b7ee3ff4 c339beb8 c0157c3d
Call Trace:
 [<c0157c3d>] refrigerator+0xcb/0xda
 [<c0138d38>] get_signal_to_deliver+0x33/0x463
 [<c01077ea>] do_notify_resume+0x94/0x732
 [<c01082f9>] work_notifysig+0x13/0x1a
 [<ffffe410>] 0xffffe410
 =======================
INFO: lockdep is turned off.
login         D 000000AA     0  2610      1 (NOTLB)
       c39e5eac 00000096 356938fb 000000aa 00000000 c39e5e94 c0216c13 c3940000
       c3940190 c265c100 356938fb 000000aa 00000000 c0157c10 c8204000 00000046
       c39e5ea0 c39da084 00000000 00000000 00000000 b7f7dff4 c39e5eb8 c0157c3d
Call Trace:
 [<c0157c3d>] refrigerator+0xcb/0xda
 [<c0138d38>] get_signal_to_deliver+0x33/0x463
 [<c01077ea>] do_notify_resume+0x94/0x732
 [<c01082f9>] work_notifysig+0x13/0x1a
 [<ffffe410>] 0xffffe410
 =======================
INFO: lockdep is turned off.
login         D 000000AA     0  2611      1 (NOTLB)
       c39a3eac 00000096 356929ab 000000aa 00000000 c39a3e94 c0216c13 c3945780
       c3945910 c265c100 356929ab 000000aa 00000000 c0157c10 c8204500 00000046
       c39a3ea0 c39da604 00000000 00000000 00000000 b7eb9ff4 c39a3eb8 c0157c3d
Call Trace:
 [<c0157c3d>] refrigerator+0xcb/0xda
 [<c0138d38>] get_signal_to_deliver+0x33/0x463
 [<c01077ea>] do_notify_resume+0x94/0x732
 [<c01082f9>] work_notifysig+0x13/0x1a
 [<ffffe410>] 0xffffe410
 =======================
INFO: lockdep is turned off.
getty         D 000000AA     0  2612      1 (NOTLB)
       c903ceac 00000096 3568f9ea 000000aa 00000000 c903ce94 c0216c13 c293ed60
       c293eef0 c265c100 3568f9ea 000000aa 00000000 c0157c10 c398b700 00000046
       c903cea0 c39dd784 0804b214 00000000 0804b214 bfd4b2d8 c903ceb8 c0157c3d
Call Trace:
 [<c0157c3d>] refrigerator+0xcb/0xda
 [<c0138d38>] get_signal_to_deliver+0x33/0x463
 [<c01077ea>] do_notify_resume+0x94/0x732
 [<c01082f9>] work_notifysig+0x13/0x1a
 [<ffffe410>] 0xffffe410
 =======================
INFO: lockdep is turned off.
acpid         D 000000AA     0  2777      1 (NOTLB)
       c3998eac 00000096 35691890 000000aa 00000000 c3998e94 c0216c13 c327abc0
       c327ad50 c265c100 35691890 000000aa 00000000 c0157c10 c398ad00 00000046
       c3998ea0 c29dc184 b7fd5ce0 00000000 b7fd5ce0 b7fa5ff4 c3998eb8 c0157c3d
Call Trace:
 [<c0157c3d>] refrigerator+0xcb/0xda
 [<c0138d38>] get_signal_to_deliver+0x33/0x463
 [<c01077ea>] do_notify_resume+0x94/0x732
 [<c01082f9>] work_notifysig+0x13/0x1a
 [<ffffe410>] 0xffffe410
 =======================
INFO: lockdep is turned off.
syslogd       D 000000AA     0  2851      1 (NOTLB)
       c3955eac 00000096 3568df26 000000aa 00000000 c3955e94 c0216c13 c327d780
       c327d910 c265c100 3568df26 000000aa 00000000 c0157c10 c398a080 00000046
       c3955ea0 c29dab84 00000000 00000000 00000000 00000000 c3955eb8 c0157c3d
Call Trace:
 [<c0157c3d>] refrigerator+0xcb/0xda
 [<c0138d38>] get_signal_to_deliver+0x33/0x463
 [<c01077ea>] do_notify_resume+0x94/0x732
 [<c01082f9>] work_notifysig+0x13/0x1a
 [<ffffe410>] 0xffffe410
 =======================
INFO: lockdep is turned off.
dd            D 000000AA     0  2901      1 (NOTLB)
       c3b72eac 00000096 3569b298 000000aa 00000000 c3b72e94 c0216c13 c3970af0
       c3970c80 c265c100 3569b298 000000aa 00000000 c0157c10 c398b200 00000046
       c3b72ea0 c29df304 00000001 00000000 00000001 08053000 c3b72eb8 c0157c3d
Call Trace:
 [<c0157c3d>] refrigerator+0xcb/0xda
 [<c0138d38>] get_signal_to_deliver+0x33/0x463
 [<c01077ea>] do_notify_resume+0x94/0x732
 [<c01082f9>] work_notifysig+0x13/0x1a
 [<ffffe410>] 0xffffe410
 =======================
INFO: lockdep is turned off.
klogd         D 000000AA     0  2903      1 (NOTLB)
       c903deac 00000096 3568cb4e 000000aa 00000000 c903de94 c0216c13 c327b6b0
       c327b840 c265c100 3568cb4e 000000aa 00000000 c0157c10 c398a580 00000046
       c903dea0 c29df884 00000400 00000000 00000400 00000000 c903deb8 c0157c3d
Call Trace:
 [<c0157c3d>] refrigerator+0xcb/0xda
 [<c0138d38>] get_signal_to_deliver+0x33/0x463
 [<c01077ea>] do_notify_resume+0x94/0x732
 [<c01082f9>] work_notifysig+0x13/0x1a
 [<ffffe410>] 0xffffe410
 =======================
INFO: lockdep is turned off.
dbus-daemon   D 000000AA     0  2924      1 (NOTLB)
       c3b73eac 00000096 3568b705 000000aa 00000000 c3b73e94 c0216c13 c327a0d0
       c327a260 c265c100 3568b705 000000aa 00000000 c0157c10 c3989b80 00000046
       c3b73ea0 c29dd784 080c0b30 00000000 080c0b30 b7eb4ff4 c3b73eb8 c0157c3d
Call Trace:
 [<c0157c3d>] refrigerator+0xcb/0xda
 [<c0138d38>] get_signal_to_deliver+0x33/0x463
 [<c01077ea>] do_notify_resume+0x94/0x732
 [<c01082f9>] work_notifysig+0x13/0x1a
 [<ffffe410>] 0xffffe410
 =======================
INFO: lockdep is turned off.
NetworkManage D 000000AA     0  2943      1 (NOTLB)
       c39c8eac 00000096 35685b45 000000aa 00000000 c39c8e94 c0216c13 c3972bc0
       c3972d50 c265c100 35685b45 000000aa 00000000 c0157c10 c398aa80 00000046
       c39c8ea0 c29dc704 00013c0e 00000000 00013c0e b7ccfff4 c39c8eb8 c0157c3d
Call Trace:
 [<c0157c3d>] refrigerator+0xcb/0xda
 [<c0138d38>] get_signal_to_deliver+0x33/0x463
 [<c01077ea>] do_notify_resume+0x94/0x732
 [<c01082f9>] work_notifysig+0x13/0x1a
 [<ffffe410>] 0xffffe410
 =======================
INFO: lockdep is turned off.
NetworkManage D 000000AA     0  4536      1 (NOTLB)
       c7f2eeac 00000096 3568311c 000000aa 00000000 c7f2ee94 c0216c13 c7fb36b0
       c7fb3840 c265c100 3568311c 000000aa 00000000 c0157c10 c398aa80 00000046
       c7f2eea0 c29dc704 b7cddb70 00000000 b7cddb70 0808e958 c7f2eeb8 c0157c3d
Call Trace:
 [<c0157c3d>] refrigerator+0xcb/0xda
 [<c0138d38>] get_signal_to_deliver+0x33/0x463
 [<c01077ea>] do_notify_resume+0x94/0x732
 [<c01082f9>] work_notifysig+0x13/0x1a
 [<ffffe410>] 0xffffe410
 =======================
INFO: lockdep is turned off.
NetworkManage D 000000AA     0  2956      1 (NOTLB)
       c63e1eac 00000096 35681df1 000000aa 00000000 c63e1e94 c0216c13 c2938af0
       c2938c80 c265c100 35681df1 000000aa 00000000 c0157c10 c398bc00 00000046
       c63e1ea0 c29da604 ffffffff 00000000 ffffffff b7df3ff4 c63e1eb8 c0157c3d
Call Trace:
 [<c0157c3d>] refrigerator+0xcb/0xda
 [<c0138d38>] get_signal_to_deliver+0x33/0x463
 [<c01077ea>] do_notify_resume+0x94/0x732
 [<c01082f9>] work_notifysig+0x13/0x1a
 [<ffffe410>] 0xffffe410
 =======================
INFO: lockdep is turned off.
system-tools- D 000000AA     0  2969      1 (NOTLB)
       c84feeac 00000096 3568023f 000000aa 00000000 c84fee94 c0216c13 c293c1a0
       c293c330 c265c100 3568023f 000000aa 00000000 c0157c10 c398a800 00000046
       c84feea0 c29d9584 ffffffff 00000000 ffffffff b7dfbff4 c84feeb8 c0157c3d
Call Trace:
 [<c0157c3d>] refrigerator+0xcb/0xda
 [<c0138d38>] get_signal_to_deliver+0x33/0x463
 [<c01077ea>] do_notify_resume+0x94/0x732
 [<c01082f9>] work_notifysig+0x13/0x1a
 [<ffffe410>] 0xffffe410
 =======================
INFO: lockdep is turned off.
dbus-daemon   D 000000AA     0  2970   2969 (NOTLB)
       c84ffeac 00000096 3567e960 000000aa 00000000 c84ffe94 c0216c13 c3278af0
       c3278c80 c265c100 3567e960 000000aa 00000000 c0157c10 c3988500 00000046
       c84ffea0 c29db684 08093650 00000000 08093650 b7f31ff4 c84ffeb8 c0157c3d
Call Trace:
 [<c0157c3d>] refrigerator+0xcb/0xda
 [<c0138d38>] get_signal_to_deliver+0x33/0x463
 [<c01077ea>] do_notify_resume+0x94/0x732
 [<c01082f9>] work_notifysig+0x13/0x1a
 [<ffffe410>] 0xffffe410
 =======================
INFO: lockdep is turned off.
gdm           D 000000AA     0  2992      1 (NOTLB)
       c3a23eac 00000096 3567cd08 000000aa 00000000 c3a23e94 c0216c13 c32795e0
       c3279770 c265c100 3567cd08 000000aa 00000000 c0157c10 c3989680 00000046
       c3a23ea0 c29de804 ffffffff 00000000 ffffffff b7740ff4 c3a23eb8 c0157c3d
Call Trace:
 [<c0157c3d>] refrigerator+0xcb/0xda
 [<c0138d38>] get_signal_to_deliver+0x33/0x463
 [<c01077ea>] do_notify_resume+0x94/0x732
 [<c01082f9>] work_notifysig+0x13/0x1a
 [<ffffe410>] 0xffffe410
 =======================
INFO: lockdep is turned off.
gdm           D 000000AA     0  2993   2992 (NOTLB)
       c8feeeac 00000096 3567ab96 000000aa 00000000 c8feee94 c0216c13 c327ed60
       c327eef0 c265c100 3567ab96 000000aa 00000000 c0157c10 c398b480 00000046
       c8feeea0 c29dd204 00000000 00000000 00000000 00000000 c8feeeb8 c0157c3d
Call Trace:
 [<c0157c3d>] refrigerator+0xcb/0xda
 [<c0138d38>] get_signal_to_deliver+0x33/0x463
 [<c01077ea>] do_notify_resume+0x94/0x732
 [<c01082f9>] work_notifysig+0x13/0x1a
 [<ffffe410>] 0xffffe410
 =======================
INFO: lockdep is turned off.
Xorg          D 000000AA     0  3008   2993 (NOTLB)
       c329eeac 00000096 35678fd2 000000aa 00000000 c329ee94 c0216c13 c39436b0
       c3943840 c265c100 35678fd2 000000aa 00000000 c0157c10 c3988a00 00000046
       c329eea0 c29de284 00000000 00000000 00000000 00000000 c329eeb8 c0157c3d
Call Trace:
 [<c0157c3d>] refrigerator+0xcb/0xda
 [<c0138d38>] get_signal_to_deliver+0x33/0x463
 [<c01077ea>] do_notify_resume+0x94/0x732
 [<c01082f9>] work_notifysig+0x13/0x1a
 [<ffffe410>] 0xffffe410
 =======================
INFO: lockdep is turned off.
cupsd         D 000000AA     0  3029      1 (NOTLB)
       c329feac 00000096 3567392c 000000aa 00000000 c329fe94 c0216c13 c29f2bc0
       c29f2d50 c265c100 3567392c 000000aa 00000000 c0157c10 c3989e00 00000046
       c329fea0 c29d9004 00000000 00000000 00000000 bfec498c c329feb8 c0157c3d
Call Trace:
 [<c0157c3d>] refrigerator+0xcb/0xda
 [<c0138d38>] get_signal_to_deliver+0x33/0x463
 [<c01077ea>] do_notify_resume+0x94/0x732
 [<c01082f9>] work_notifysig+0x13/0x1a
 [<ffffe410>] 0xffffe410
 =======================
INFO: lockdep is turned off.
hpiod         D 000000AA     0  3057      1 (NOTLB)
       c3987eac 00200096 356710de 000000aa 00000000 c3987e94 c0216c13 c29f6270
       c29f6400 c265c100 356710de 000000aa 00000000 c0157c10 c32b8a00 00200046
       c3987ea0 c29db104 08063190 00000000 08063190 00000000 c3987eb8 c0157c3d
Call Trace:
 [<c0157c3d>] refrigerator+0xcb/0xda
 [<c0138d38>] get_signal_to_deliver+0x33/0x463
 [<c01077ea>] do_notify_resume+0x94/0x732
 [<c01082f9>] work_notifysig+0x13/0x1a
 [<ffffe410>] 0xffffe410
 =======================
INFO: lockdep is turned off.
python        D 000000AA     0  3060      1 (NOTLB)
       c6cedeac 00200096 3566b8ce 000000aa 00000000 c6cede94 c0216c13 c29f5780
       c29f5910 c265c100 3566b8ce 000000aa 00000000 c0157c10 c32ba800 00200046
       c6cedea0 c29ded84 bf8e2428 00000000 bf8e2428 bf8e25a8 c6cedeb8 c0157c3d
Call Trace:
 [<c0157c3d>] refrigerator+0xcb/0xda
 [<c0138d38>] get_signal_to_deliver+0x33/0x463
 [<c01077ea>] do_notify_resume+0x94/0x732
 [<c01082f9>] work_notifysig+0x13/0x1a
 [<ffffe410>] 0xffffe410
 =======================
INFO: lockdep is turned off.
ledd          D 000000AA     0  3136      1 (NOTLB)
       c67e4eac 00000096 35669e1c 000000aa 00000000 c67e4e94 c0216c13 c3970000
       c3970190 c265c100 35669e1c 000000aa 00000000 c0157c10 c32bb700 00000046
       c67e4ea0 c39dd204 080504c8 00000000 080504c8 b7ebdff4 c67e4eb8 c0157c3d
Call Trace:
 [<c0157c3d>] refrigerator+0xcb/0xda
 [<c0138d38>] get_signal_to_deliver+0x33/0x463
 [<c01077ea>] do_notify_resume+0x94/0x732
 [<c01082f9>] work_notifysig+0x13/0x1a
 [<ffffe410>] 0xffffe410
 =======================
INFO: lockdep is turned off.
sh            D 000000AA     0  3137   3136 (NOTLB)
       c67e3eac 00000096 35668cf5 000000aa 00000000 c67e3e94 c0216c13 c39736b0
       c3973840 c265c100 35668cf5 000000aa 00000000 c0157c10 c32b9680 00000046
       c67e3ea0 c39df304 00000000 00000000 00000000 00000001 c67e3eb8 c0157c3d
Call Trace:
 [<c0157c3d>] refrigerator+0xcb/0xda
 [<c0138d38>] get_signal_to_deliver+0x33/0x463
 [<c01077ea>] do_notify_resume+0x94/0x732
 [<c01082f9>] work_notifysig+0x13/0x1a
 [<ffffe410>] 0xffffe410
 =======================
INFO: lockdep is turned off.
startup.sh    D 000000AA     0  3138   3137 (NOTLB)
       c67e2eac 00000096 35667f5c 000000aa 00000000 c67e2e94 c0216c13 c33c6270
       c33c6400 c265c100 35667f5c 000000aa 00000000 c0157c10 c32b9b80 00000046
       c67e2ea0 c39dab84 00000000 00000000 00000000 00000002 c67e2eb8 c0157c3d
Call Trace:
 [<c0157c3d>] refrigerator+0xcb/0xda
 [<c0138d38>] get_signal_to_deliver+0x33/0x463
 [<c01077ea>] do_notify_resume+0x94/0x732
 [<c01082f9>] work_notifysig+0x13/0x1a
 [<ffffe410>] 0xffffe410
 =======================
INFO: lockdep is turned off.
nasd          D 000000AA     0  3149      1 (NOTLB)
       c9010eac 00000096 355a3dd5 000000aa 00000000 c9010e94 c0216c13 c3974c90
       c3974e20 c265c100 355a3dd5 000000aa 00000000 c0157c10 c32b9400 00000046
       c9010ea0 c29dfe04 00000000 00000000 00000000 00000000 c9010eb8 c0157c3d
Call Trace:
 [<c0157c3d>] refrigerator+0xcb/0xda
 [<c0138d38>] get_signal_to_deliver+0x33/0x463
 [<c01077ea>] do_notify_resume+0x94/0x732
 [<c01082f9>] work_notifysig+0x13/0x1a
 [<ffffe410>] 0xffffe410
 =======================
INFO: lockdep is turned off.
powernowd     D 000000AA     0  3186      1 (NOTLB)
       c67e0eac 00000096 356a0971 000000aa 00000000 c67e0e94 c0216c13 c33c20d0
       c33c2260 c265c100 356a0971 000000aa 00000000 c0157c10 c32bbc00 00000046
       c67e0ea0 c29dcc84 0000003e 00000000 0000003e 00000000 c67e0eb8 c0157c3d
Call Trace:
 [<c0157c3d>] refrigerator+0xcb/0xda
 [<c0138d38>] get_signal_to_deliver+0x33/0x463
 [<c01077ea>] do_notify_resume+0x94/0x732
 [<c01082f9>] work_notifysig+0x13/0x1a
 [<ffffe410>] 0xffffe410
 =======================
INFO: lockdep is turned off.
avahi-daemon  D 000000AA     0  3238      1 (NOTLB)
       c67e1eac 00000096 35666da2 000000aa 00000000 c67e1e94 c0216c13 c39741a0
       c3974330 c265c100 35666da2 000000aa 00000000 c0157c10 c32bb200 00000046
       c67e1ea0 c338b684 08065fc0 00000000 08065fc0 b7eb6ff4 c67e1eb8 c0157c3d
Call Trace:
 [<c0157c3d>] refrigerator+0xcb/0xda
 [<c0138d38>] get_signal_to_deliver+0x33/0x463
 [<c01077ea>] do_notify_resume+0x94/0x732
 [<c01082f9>] work_notifysig+0x13/0x1a
 [<ffffe410>] 0xffffe410
 =======================
INFO: lockdep is turned off.
avahi-daemon  D 000000AA     0  3239   3238 (NOTLB)
       c67cdeac 00000096 356632cb 000000aa 00000000 c67cde94 c0216c13 c293e270
       c293e400 c265c100 356632cb 000000aa 00000000 c0157c10 c32b8f00 00000046
       c67cdea0 c338ed84 00000007 00000000 00000007 00000003 c67cdeb8 c0157c3d
Call Trace:
 [<c0157c3d>] refrigerator+0xcb/0xda
 [<c0138d38>] get_signal_to_deliver+0x33/0x463
 [<c01077ea>] do_notify_resume+0x94/0x732
 [<c01082f9>] work_notifysig+0x13/0x1a
 [<ffffe410>] 0xffffe410
 =======================
INFO: lockdep is turned off.
dhcdbd        D 000000AA     0  3253      1 (NOTLB)
       c67dbeac 00000096 35661f8e 000000aa 00000000 c67dbe94 c0216c13 c2886d60
       c2886ef0 c265c100 35661f8e 000000aa 00000000 c0157c10 c32b9900 00000046
       c67dbea0 c338e804 08067288 00000000 08067288 bf9a1674 c67dbeb8 c0157c3d
Call Trace:
 [<c0157c3d>] refrigerator+0xcb/0xda
 [<c0138d38>] get_signal_to_deliver+0x33/0x463
 [<c01077ea>] do_notify_resume+0x94/0x732
 [<c01082f9>] work_notifysig+0x13/0x1a
 [<ffffe410>] 0xffffe410
 =======================
INFO: lockdep is turned off.
hald          D 000000AA     0  3269      1 (NOTLB)
       c67d2eac 00000096 356604ff 000000aa 00000000 c67d2e94 c0216c13 c29f36b0
       c29f3840 c265c100 356604ff 000000aa 00000000 c0157c10 c32ba080 00000046
       c67d2ea0 c338e284 00002f42 00000000 00002f42 b7e32ff4 c67d2eb8 c0157c3d
Call Trace:
 [<c0157c3d>] refrigerator+0xcb/0xda
 [<c0138d38>] get_signal_to_deliver+0x33/0x463
 [<c01077ea>] do_notify_resume+0x94/0x732
 [<c01082f9>] work_notifysig+0x13/0x1a
 [<ffffe410>] 0xffffe410
 =======================
INFO: lockdep is turned off.
hald-runner   D 000000AA     0  3270   3269 (NOTLB)
       c67d1eac 00000096 3565b11b 000000aa 00000000 c67d1e94 c0216c13 c29f0af0
       c29f0c80 c265c100 3565b11b 000000aa 00000000 c0157c10 c32baf80 00000046
       c67d1ea0 c338dd04 ffffffff 00000000 ffffffff b7e2dff4 c67d1eb8 c0157c3d
Call Trace:
 [<c0157c3d>] refrigerator+0xcb/0xda
 [<c0138d38>] get_signal_to_deliver+0x33/0x463
 [<c01077ea>] do_notify_resume+0x94/0x732
 [<c01082f9>] work_notifysig+0x13/0x1a
 [<ffffe410>] 0xffffe410
 =======================
INFO: lockdep is turned off.
hald-addon-ke D 000000AA     0  3287   3270 (NOTLB)
       c7c1eeac 00000096 35659e23 000000aa 00000000 c7c1ee94 c0216c13 c28820d0
       c2882260 c265c100 35659e23 000000aa 00000000 c0157c10 c32bb480 00000046
       c7c1eea0 c338c704 0804e590 00000000 0804e590 0804e590 c7c1eeb8 c0157c3d
Call Trace:
 [<c0157c3d>] refrigerator+0xcb/0xda
 [<c0138d38>] get_signal_to_deliver+0x33/0x463
 [<c01077ea>] do_notify_resume+0x94/0x732
 [<c01082f9>] work_notifysig+0x13/0x1a
 [<ffffe410>] 0xffffe410
 =======================
INFO: lockdep is turned off.
hald-addon-cp D 000000AA     0  3289   3270 (NOTLB)
       c7c1aeac 00000096 3565908f 000000aa 00000000 c7c1ae94 c0216c13 c2880000
       c2880190 c265c100 3565908f 000000aa 00000000 c0157c10 c32b8500 00000046
       c7c1aea0 c338c184 ffffffff 00000000 ffffffff b7eb4ff4 c7c1aeb8 c0157c3d
Call Trace:
 [<c0157c3d>] refrigerator+0xcb/0xda
 [<c0138d38>] get_signal_to_deliver+0x33/0x463
 [<c01077ea>] do_notify_resume+0x94/0x732
 [<c01082f9>] work_notifysig+0x13/0x1a
 [<ffffe410>] 0xffffe410
 =======================
INFO: lockdep is turned off.
hald-addon-ac D 000000AA     0  3290   3270 (NOTLB)
       c67d7eac 00000096 356577c1 000000aa 00000000 c67d7e94 c0216c13 c327c1a0
       c327c330 c265c100 356577c1 000000aa 00000000 c0157c10 c32b9180 00000046
       c67d7ea0 c338fe04 08050888 00000000 08050888 b7f46022 c67d7eb8 c0157c3d
Call Trace:
 [<c0157c3d>] refrigerator+0xcb/0xda
 [<c0138d38>] get_signal_to_deliver+0x33/0x463
 [<c01077ea>] do_notify_resume+0x94/0x732
 [<c01082f9>] work_notifysig+0x13/0x1a
 [<ffffe410>] 0xffffe410
 =======================
INFO: lockdep is turned off.
hald-addon-st D 000000AA     0  3309   3270 (NOTLB)
       c7c9deac 00000096 356563aa 000000aa 00000000 c7c9de94 c0216c13 c7c28000
       c7c28190 c265c100 356563aa 000000aa 00000000 c0157c10 c3988c80 00000046
       c7c9dea0 c338cc84 000007bd 00000000 000007bd b7e12ff4 c7c9deb8 c0157c3d
Call Trace:
 [<c0157c3d>] refrigerator+0xcb/0xda
 [<c0138d38>] get_signal_to_deliver+0x33/0x463
 [<c01077ea>] do_notify_resume+0x94/0x732
 [<c01082f9>] work_notifysig+0x13/0x1a
 [<ffffe410>] 0xffffe410
 =======================
INFO: lockdep is turned off.
hcid          D 000000AA     0  3333      1 (NOTLB)
       c67ddeac 00000096 356552be 000000aa 00000000 c67dde94 c0216c13 c7c2d780
       c7c2d910 c265c100 356552be 000000aa 00000000 c0157c10 c32b8280 00000046
       c67ddea0 c338b104 ffffffff 00000000 ffffffff b7e56ff4 c67ddeb8 c0157c3d
Call Trace:
 [<c0157c3d>] refrigerator+0xcb/0xda
 [<c0138d38>] get_signal_to_deliver+0x33/0x463
 [<c01077ea>] do_notify_resume+0x94/0x732
 [<c01082f9>] work_notifysig+0x13/0x1a
 [<ffffe410>] 0xffffe410
 =======================
INFO: lockdep is turned off.
atd           D 000000AA     0  3405      1 (NOTLB)
       c39cceac 00000096 35652827 000000aa 00000000 c39cce94 c0216c13 c6ce2bc0
       c6ce2d50 c265c100 35652827 000000aa 00000000 c0157c10 c7cc0280 00000046
       c39ccea0 c3a81b04 bfe23314 00000000 bfe23314 00000000 c39cceb8 c0157c3d
Call Trace:
 [<c0157c3d>] refrigerator+0xcb/0xda
 [<c0138d38>] get_signal_to_deliver+0x33/0x463
 [<c01077ea>] do_notify_resume+0x94/0x732
 [<c01082f9>] work_notifysig+0x13/0x1a
 [<ffffe410>] 0xffffe410
 =======================
INFO: lockdep is turned off.
cron          D 000000AA     0  3425      1 (NOTLB)
       c7c70eac 00000096 3565148e 000000aa 00000000 c7c70e94 c0216c13 c29f15e0
       c29f1770 c265c100 3565148e 000000aa 00000000 c0157c10 c7cc0c80 00000046
       c7c70ea0 c3a83104 bf9080e4 00000000 bf9080e4 00000000 c7c70eb8 c0157c3d
Call Trace:
 [<c0157c3d>] refrigerator+0xcb/0xda
 [<c0138d38>] get_signal_to_deliver+0x33/0x463
 [<c01077ea>] do_notify_resume+0x94/0x732
 [<c01082f9>] work_notifysig+0x13/0x1a
 [<ffffe410>] 0xffffe410
 =======================
INFO: lockdep is turned off.
x-session-man D 000000AA     0  3555   2993 (NOTLB)
       c32b3eac 00200096 3564ff81 000000aa 00000000 c32b3e94 c0216c13 c29f0000
       c29f0190 c265c100 3564ff81 000000aa 00000000 c0157c10 c7cc2080 00200046
       c32b3ea0 c3a82b84 ffffffff 00000000 ffffffff b76d9ff4 c32b3eb8 c0157c3d
Call Trace:
 [<c0157c3d>] refrigerator+0xcb/0xda
 [<c0138d38>] get_signal_to_deliver+0x33/0x463
 [<c01077ea>] do_notify_resume+0x94/0x732
 [<c01082f9>] work_notifysig+0x13/0x1a
 [<ffffe410>] 0xffffe410
 =======================
INFO: lockdep is turned off.
x-session-man D 000000AA     0  3633   2993 (NOTLB)
       c7d03eac 00200096 35649034 000000aa 00000000 c7d03e94 c0216c13 c7c2a0d0
       c7c2a260 c265c100 35649034 000000aa 00000000 c0157c10 c7cc2080 00200046
       c7d03ea0 c3a82b84 b76e6b70 00000000 b76e6b70 b77b7874 c7d03eb8 c0157c3d
Call Trace:
 [<c0157c3d>] refrigerator+0xcb/0xda
 [<c0138d38>] get_signal_to_deliver+0x33/0x463
 [<c01077ea>] do_notify_resume+0x94/0x732
 [<c01082f9>] work_notifysig+0x13/0x1a
 [<ffffe410>] 0xffffe410
 =======================
INFO: lockdep is turned off.
ssh-agent     D 000000AA     0  3593   3555 (NOTLB)
       c7c4eeac 00200096 35647e2d 000000aa 00000000 c7c4ee94 c0216c13 c6ce0af0
       c6ce0c80 c265c100 35647e2d 000000aa 00000000 c0157c10 c7cc1680 00200046
       c7c4eea0 c3a84184 00000000 00000000 00000000 bfbfdc2c c7c4eeb8 c0157c3d
Call Trace:
 [<c0157c3d>] refrigerator+0xcb/0xda
 [<c0138d38>] get_signal_to_deliver+0x33/0x463
 [<c01077ea>] do_notify_resume+0x94/0x732
 [<c01082f9>] work_notifysig+0x13/0x1a
 [<ffffe410>] 0xffffe410
 =======================
INFO: lockdep is turned off.
gconfd-2      D 000000AA     0  3595      1 (NOTLB)
       c7c3feac 00200096 3564663e 000000aa 00000000 c7c3fe94 c0216c13 c6ce5780
       c6ce5910 c265c100 3564663e 000000aa 00000000 c0157c10 c7cc1900 00200046
       c7c3fea0 c3a81584 000052a5 00000000 000052a5 b7e25ff4 c7c3feb8 c0157c3d
Call Trace:
 [<c0157c3d>] refrigerator+0xcb/0xda
 [<c0138d38>] get_signal_to_deliver+0x33/0x463
 [<c01077ea>] do_notify_resume+0x94/0x732
 [<c01082f9>] work_notifysig+0x13/0x1a
 [<ffffe410>] 0xffffe410
 =======================
INFO: lockdep is turned off.
gnome-keyring D 000000AA     0  3598      1 (NOTLB)
       c7c5beac 00200096 3563750e 000000aa 00000000 c7c5be94 c0216c13 c6ce0000
       c6ce0190 c265c100 3563750e 000000aa 00000000 c0157c10 c7cc1b80 00200046
       c7c5bea0 c3a83684 ffffffff 00000000 ffffffff b7da6ff4 c7c5beb8 c0157c3d
Call Trace:
 [<c0157c3d>] refrigerator+0xcb/0xda
 [<c0138d38>] get_signal_to_deliver+0x33/0x463
 [<c01077ea>] do_notify_resume+0x94/0x732
 [<c01082f9>] work_notifysig+0x13/0x1a
 [<ffffe410>] 0xffffe410
 =======================
INFO: lockdep is turned off.
dbus-daemon   D 000000AA     0  3600      1 (NOTLB)
       c7c40eac 00200096 35635996 000000aa 00000000 c7c40e94 c0216c13 c6ce6270
       c6ce6400 c265c100 35635996 000000aa 00000000 c0157c10 c7cc0000 00200046
       c7c40ea0 c3a84c84 080b06f0 00000000 080b06f0 b7f0fff4 c7c40eb8 c0157c3d
Call Trace:
 [<c0157c3d>] refrigerator+0xcb/0xda
 [<c0138d38>] get_signal_to_deliver+0x33/0x463
 [<c01077ea>] do_notify_resume+0x94/0x732
 [<c01082f9>] work_notifysig+0x13/0x1a
 [<ffffe410>] 0xffffe410
 =======================
INFO: lockdep is turned off.
gnome-setting D 000000AA     0  3602      1 (NOTLB)
       c7c19eac 00000096 356306cd 000000aa 00000000 c7c19e94 c0216c13 c6ce4c90
       c6ce4e20 c265c100 356306cd 000000aa 00000000 c0157c10 c7cc1400 00000046
       c7c19ea0 c3a84704 00000d06 00000000 00000d06 b75cbff4 c7c19eb8 c0157c3d
Call Trace:
 [<c0157c3d>] refrigerator+0xcb/0xda
 [<c0138d38>] get_signal_to_deliver+0x33/0x463
 [<c01077ea>] do_notify_resume+0x94/0x732
 [<c01082f9>] work_notifysig+0x13/0x1a
 [<ffffe410>] 0xffffe410
 =======================
INFO: lockdep is turned off.
gnome-setting D 000000AA     0  3605      1 (NOTLB)
       c7ce2eac 00200096 3562cdca 000000aa 00000000 c7ce2e94 c0216c13 c3976d60
       c3976ef0 c265c100 3562cdca 000000aa 00000000 c0157c10 c7cc1400 00200046
       c7ce2ea0 c3a84704 b75d8b70 00000000 b75d8b70 b77e4874 c7ce2eb8 c0157c3d
Call Trace:
 [<c0157c3d>] refrigerator+0xcb/0xda
 [<c0138d38>] get_signal_to_deliver+0x33/0x463
 [<c01077ea>] do_notify_resume+0x94/0x732
 [<c01082f9>] work_notifysig+0x13/0x1a
 [<ffffe410>] 0xffffe410
 =======================
INFO: lockdep is turned off.
sh            D 000000AA     0  3618      1 (NOTLB)
       c7ce3eac 00200096 3562b8e1 000000aa 00000000 c7ce3e94 c0216c13 c7c28af0
       c7c28c80 c265c100 3562b8e1 000000aa 00000000 c0157c10 c7cc1180 00200046
       c7ce3ea0 c3a80504 00000000 00000000 00000000 00000007 c7ce3eb8 c0157c3d
Call Trace:
 [<c0157c3d>] refrigerator+0xcb/0xda
 [<c0138d38>] get_signal_to_deliver+0x33/0x463
 [<c01077ea>] do_notify_resume+0x94/0x732
 [<c01082f9>] work_notifysig+0x13/0x1a
 [<ffffe410>] 0xffffe410
 =======================
INFO: lockdep is turned off.
esd           D 000000AA     0  3619   3618 (NOTLB)
       c8fd3eac 00200096 3562aa63 000000aa 00000000 c8fd3e94 c0216c13 c7c2e270
       c7c2e400 c265c100 3562aa63 000000aa 00000000 c0157c10 c7cc2300 00200046
       c8fd3ea0 c3a85784 00000000 00000000 00000000 00000000 c8fd3eb8 c0157c3d
Call Trace:
 [<c0157c3d>] refrigerator+0xcb/0xda
 [<c0138d38>] get_signal_to_deliver+0x33/0x463
 [<c01077ea>] do_notify_resume+0x94/0x732
 [<c01082f9>] work_notifysig+0x13/0x1a
 [<ffffe410>] 0xffffe410
 =======================
INFO: lockdep is turned off.
gnome-screens D 000000AA     0  3626      1 (NOTLB)
       c7d14eac 00200096 35625d3d 000000aa 00000000 c7d14e94 c0216c13 c7c2b6b0
       c7c2b840 c265c100 35625d3d 000000aa 00000000 c0157c10 c7cc1e00 00200046
       c7d14ea0 c3a83c04 000047d3 00000000 000047d3 b75f0ff4 c7d14eb8 c0157c3d
Call Trace:
 [<c0157c3d>] refrigerator+0xcb/0xda
 [<c0138d38>] get_signal_to_deliver+0x33/0x463
 [<c01077ea>] do_notify_resume+0x94/0x732
 [<c01082f9>] work_notifysig+0x13/0x1a
 [<ffffe410>] 0xffffe410
 =======================
INFO: lockdep is turned off.
gnome-panel   D 000000AA     0  3634   3555 (NOTLB)
       c7d0deac 00000096 35622a51 000000aa 00000000 c7d0de94 c0216c13 c6ce41a0
       c6ce4330 c265c100 35622a51 000000aa 00000000 c0157c10 c7cc2800 00000046
       c7d0dea0 c3a86284 00000031 00000000 00000031 b7511ff4 c7d0deb8 c0157c3d
Call Trace:
 [<c0157c3d>] refrigerator+0xcb/0xda
 [<c0138d38>] get_signal_to_deliver+0x33/0x463
 [<c01077ea>] do_notify_resume+0x94/0x732
 [<c01082f9>] work_notifysig+0x13/0x1a
 [<ffffe410>] 0xffffe410
 =======================
INFO: lockdep is turned off.
nautilus      D 000000AA     0  3637   3555 (NOTLB)
       c7d32eac 00200096 3561f46c 000000aa 00000000 c7d32e94 c0216c13 c7c2ed60
       c7c2eef0 c265c100 3561f46c 000000aa 00000000 c0157c10 c7cc3480 00200046
       c7d32ea0 c3a86d84 00000fa0 00000000 00000fa0 b7381ff4 c7d32eb8 c0157c3d
Call Trace:
 [<c0157c3d>] refrigerator+0xcb/0xda
 [<c0138d38>] get_signal_to_deliver+0x33/0x463
 [<c01077ea>] do_notify_resume+0x94/0x732
 [<c01082f9>] work_notifysig+0x13/0x1a
 [<ffffe410>] 0xffffe410
 =======================
INFO: lockdep is turned off.
gnome-volume- D 000000AA     0  3642      1 (NOTLB)
       c7d49eac 00200096 3561a4da 000000aa 00000000 c7d49e94 c0216c13 c327e270
       c327e400 c265c100 3561a4da 000000aa 00000000 c0157c10 c7cc2580 00200046
       c7d49ea0 c3a85d04 000037e2 00000000 000037e2 b73baff4 c7d49eb8 c0157c3d
Call Trace:
 [<c0157c3d>] refrigerator+0xcb/0xda
 [<c0138d38>] get_signal_to_deliver+0x33/0x463
 [<c01077ea>] do_notify_resume+0x94/0x732
 [<c01082f9>] work_notifysig+0x13/0x1a
 [<ffffe410>] 0xffffe410
 =======================
INFO: lockdep is turned off.
bonobo-activa D 000000AA     0  3648      1 (NOTLB)
       c7d96eac 00000096 356168a7 000000aa 00000000 c7d96e94 c0216c13 c7d78af0
       c7d78c80 c265c100 356168a7 000000aa 00000000 c0157c10 c32b8c80 00000046
       c7d96ea0 c29da084 ffffffff 00000000 ffffffff b7c27ff4 c7d96eb8 c0157c3d
Call Trace:
 [<c0157c3d>] refrigerator+0xcb/0xda
 [<c0138d38>] get_signal_to_deliver+0x33/0x463
 [<c01077ea>] do_notify_resume+0x94/0x732
 [<c01082f9>] work_notifysig+0x13/0x1a
 [<ffffe410>] 0xffffe410
 =======================
INFO: lockdep is turned off.
bonobo-activa D 000000AA     0  3649      1 (NOTLB)
       c7d8beac 00000096 356153c0 000000aa 00000000 c7d8be94 c0216c13 c7d78000
       c7d78190 c265c100 356153c0 000000aa 00000000 c0157c10 c32b8c80 00000046
       c7d8bea0 c29da084 ffffffff 00000000 ffffffff b7c27ff4 c7d8beb8 c0157c3d
Call Trace:
 [<c0157c3d>] refrigerator+0xcb/0xda
 [<c0138d38>] get_signal_to_deliver+0x33/0x463
 [<c01077ea>] do_notify_resume+0x94/0x732
 [<c01082f9>] work_notifysig+0x13/0x1a
 [<ffffe410>] 0xffffe410
 =======================
INFO: lockdep is turned off.
gnome-vfs-dae D 000000AA     0  3658      1 (NOTLB)
       c7d94eac 00200096 3560cf67 000000aa 00000000 c7d94e94 c0216c13 c7d7c1a0
       c7d7c330 c265c100 3560cf67 000000aa 00000000 c0157c10 c7cc2d00 00200046
       c7d94ea0 c3a87304 ffffffff 00000000 ffffffff b7d1fff4 c7d94eb8 c0157c3d
Call Trace:
 [<c0157c3d>] refrigerator+0xcb/0xda
 [<c0138d38>] get_signal_to_deliver+0x33/0x463
 [<c01077ea>] do_notify_resume+0x94/0x732
 [<c01082f9>] work_notifysig+0x13/0x1a
 [<ffffe410>] 0xffffe410
 =======================
INFO: lockdep is turned off.
trashapplet   D 000000AA     0  3696      1 (NOTLB)
       c7da4eac 00200096 35609c78 000000aa 00000000 c7da4e94 c0216c13 c7d7e270
       c7d7e400 c265c100 35609c78 000000aa 00000000 c0157c10 c7cc0a00 00200046
       c7da4ea0 c3a81004 ffffffff 00000000 ffffffff b76eaff4 c7da4eb8 c0157c3d
Call Trace:
 [<c0157c3d>] refrigerator+0xcb/0xda
 [<c0138d38>] get_signal_to_deliver+0x33/0x463
 [<c01077ea>] do_notify_resume+0x94/0x732
 [<c01082f9>] work_notifysig+0x13/0x1a
 [<ffffe410>] 0xffffe410
 =======================
INFO: lockdep is turned off.
cpufreq-apple D 000000AA     0  3717      1 (NOTLB)
       c7e09eac 00000096 356058e7 000000aa 00000000 c7e09e94 c0216c13 c7e041a0
       c7e04330 c265c100 356058e7 000000aa 00000000 c0157c10 c32ba300 00000046
       c7e09ea0 c338d784 000003e8 00000000 000003e8 b78ddff4 c7e09eb8 c0157c3d
Call Trace:
 [<c0157c3d>] refrigerator+0xcb/0xda
 [<c0138d38>] get_signal_to_deliver+0x33/0x463
 [<c01077ea>] do_notify_resume+0x94/0x732
 [<c01082f9>] work_notifysig+0x13/0x1a
 [<ffffe410>] 0xffffe410
 =======================
INFO: lockdep is turned off.
multiload-app D 000000AA     0  3719      1 (NOTLB)
       c7dfceac 00000096 35601fb4 000000aa 00000000 c7dfce94 c0216c13 c7e05780
       c7e05910 c265c100 35601fb4 000000aa 00000000 c0157c10 c7cc3700 00000046
       c7dfcea0 c29d8504 000001e3 00000000 000001e3 b78aeff4 c7dfceb8 c0157c3d
Call Trace:
 [<c0157c3d>] refrigerator+0xcb/0xda
 [<c0138d38>] get_signal_to_deliver+0x33/0x463
 [<c01077ea>] do_notify_resume+0x94/0x732
 [<c01082f9>] work_notifysig+0x13/0x1a
 [<ffffe410>] 0xffffe410
 =======================
INFO: lockdep is turned off.
mapping-daemo D 000000AA     0  3729      1 (NOTLB)
       c7e52eac 00000096 355fe1cd 000000aa 00000000 c7e52e94 c0216c13 c7e04c90
       c7e04e20 c265c100 355fe1cd 000000aa 00000000 c0157c10 c398a300 00000046
       c7e52ea0 c39ddd04 00001388 00000000 00001388 b7ec3ff4 c7e52eb8 c0157c3d
Call Trace:
 [<c0157c3d>] refrigerator+0xcb/0xda
 [<c0138d38>] get_signal_to_deliver+0x33/0x463
 [<c01077ea>] do_notify_resume+0x94/0x732
 [<c01082f9>] work_notifysig+0x13/0x1a
 [<ffffe410>] 0xffffe410
 =======================
INFO: lockdep is turned off.
mixer_applet2 D 000000AA     0  3751      1 (NOTLB)
       c7d84eac 00000096 355fc6dd 000000aa 00000000 c7d84e94 c0216c13 c7e036b0
       c7e03840 c265c100 355fc6dd 000000aa 00000000 c0157c10 c7cc3980 00000046
       c7d84ea0 c39d9584 00000063 00000000 00000063 b77aeff4 c7d84eb8 c0157c3d
Call Trace:
 [<c0157c3d>] refrigerator+0xcb/0xda
 [<c0138d38>] get_signal_to_deliver+0x33/0x463
 [<c01077ea>] do_notify_resume+0x94/0x732
 [<c01082f9>] work_notifysig+0x13/0x1a
 [<ffffe410>] 0xffffe410
 =======================
INFO: lockdep is turned off.
beryl-manager D 000000AA     0  3779      1 (NOTLB)
       c7ecaeac 00200096 355fa0e1 000000aa 00000000 c7ecae94 c0216c13 c7e06270
       c7e06400 c265c100 355fa0e1 000000aa 00000000 c0157c10 c3988280 00200046
       c7ecaea0 c39dc704 ffffffff 00000000 ffffffff b775fff4 c7ecaeb8 c0157c3d
Call Trace:
 [<c0157c3d>] refrigerator+0xcb/0xda
 [<c0138d38>] get_signal_to_deliver+0x33/0x463
 [<c01077ea>] do_notify_resume+0x94/0x732
 [<c01082f9>] work_notifysig+0x13/0x1a
 [<ffffe410>] 0xffffe410
 =======================
INFO: lockdep is turned off.
beryl-manager D 000000AA     0  3848      1 (NOTLB)
       c7ee9eac 00200096 355f89cc 000000aa 00000000 c7ee9e94 c0216c13 c7e020d0
       c7e02260 c265c100 355f89cc 000000aa 00000000 c0157c10 c3988280 00200046
       c7ee9ea0 c39dc704 b71c52fc 00000000 b71c52fc ffffffff c7ee9eb8 c0157c3d
Call Trace:
 [<c0157c3d>] refrigerator+0xcb/0xda
 [<c0138d38>] get_signal_to_deliver+0x33/0x463
 [<c01077ea>] do_notify_resume+0x94/0x732
 [<c01082f9>] work_notifysig+0x13/0x1a
 [<ffffe410>] 0xffffe410
 =======================
INFO: lockdep is turned off.
beryl-manager D 000000AA     0  3853      1 (NOTLB)
       c7dc3eac 00200096 355f7e89 000000aa 00000000 c7dc3e94 c0216c13 c7e00af0
       c7e00c80 c265c100 355f7e89 000000aa 00000000 c0157c10 c3988280 00200046
       c7dc3ea0 c39dc704 b69c426c 00000000 b69c426c ffffffff c7dc3eb8 c0157c3d
Call Trace:
 [<c0157c3d>] refrigerator+0xcb/0xda
 [<c0138d38>] get_signal_to_deliver+0x33/0x463
 [<c01077ea>] do_notify_resume+0x94/0x732
 [<c01082f9>] work_notifysig+0x13/0x1a
 [<ffffe410>] 0xffffe410
 =======================
INFO: lockdep is turned off.
heliodor      D 000000AA     0  3850   3848 (NOTLB)
       c7e7deac 00000096 355f7071 000000aa 00000000 c7e7de94 c0216c13 c7e02bc0
       c7e02d50 c265c100 355f7071 000000aa 00000000 c0157c10 c7cc2a80 00000046
       c7e7dea0 c3a87e04 ffffffff 00000000 ffffffff b761bff4 c7e7deb8 c0157c3d
Call Trace:
 [<c0157c3d>] refrigerator+0xcb/0xda
 [<c0138d38>] get_signal_to_deliver+0x33/0x463
 [<c01077ea>] do_notify_resume+0x94/0x732
 [<c01082f9>] work_notifysig+0x13/0x1a
 [<ffffe410>] 0xffffe410
 =======================
INFO: lockdep is turned off.
beryl         D 000000AA     0  3859   3853 (NOTLB)
       c7d5beac 00200096 355f4350 000000aa 00000000 c7d5be94 c0216c13 c2885780
       c2885910 c265c100 355f4350 000000aa 00000000 c0157c10 c7cc3200 00200046
       c7d5bea0 c3a86804 00000004 00000000 00000004 b7e15ff4 c7d5beb8 c0157c3d
Call Trace:
 [<c0157c3d>] refrigerator+0xcb/0xda
 [<c0138d38>] get_signal_to_deliver+0x33/0x463
 [<c01077ea>] do_notify_resume+0x94/0x732
 [<c01082f9>] work_notifysig+0x13/0x1a
 [<ffffe410>] 0xffffe410
 =======================
INFO: lockdep is turned off.
vino-session  D 000000AA     0  3863   3555 (NOTLB)
       c67d8eac 00200096 355ef96c 000000aa 00000000 c67d8e94 c0216c13 c293b6b0
       c293b840 c265c100 355ef96c 000000aa 00000000 c0157c10 c7f10000 00200046
       c67d8ea0 c7ef8504 ffffffff 00000000 ffffffff b7858ff4 c67d8eb8 c0157c3d
Call Trace:
 [<c0157c3d>] refrigerator+0xcb/0xda
 [<c0138d38>] get_signal_to_deliver+0x33/0x463
 [<c01077ea>] do_notify_resume+0x94/0x732
 [<c01082f9>] work_notifysig+0x13/0x1a
 [<ffffe410>] 0xffffe410
 =======================
INFO: lockdep is turned off.
update-notifi D 000000AA     0  3867   3555 (NOTLB)
       c7f05eac 00200096 355f3683 000000aa 00000000 c7f05e94 c0216c13 c7d7a0d0
       c7d7a260 c265c100 355f3683 000000aa 00000000 c0157c10 c7f10a00 00200046
       c7f05ea0 c7ef9584 00000ea7 00000000 00000ea7 b72b5ff4 c7f05eb8 c0157c3d
Call Trace:
 [<c0157c3d>] refrigerator+0xcb/0xda
 [<c0138d38>] get_signal_to_deliver+0x33/0x463
 [<c01077ea>] do_notify_resume+0x94/0x732
 [<c01082f9>] work_notifysig+0x13/0x1a
 [<ffffe410>] 0xffffe410
 =======================
INFO: lockdep is turned off.
evolution-ala D 000000AA     0  3877   3555 (NOTLB)
       c7f1aeac 00200096 355ecc1f 000000aa 00000000 c7f1ae94 c0216c13 c7d7abc0
       c7d7ad50 c265c100 355ecc1f 000000aa 00000000 c0157c10 c7f10f00 00200046
       c7f1aea0 c7efb684 001292d7 00000000 001292d7 b6e20ff4 c7f1aeb8 c0157c3d
Call Trace:
 [<c0157c3d>] refrigerator+0xcb/0xda
 [<c0138d38>] get_signal_to_deliver+0x33/0x463
 [<c01077ea>] do_notify_resume+0x94/0x732
 [<c01082f9>] work_notifysig+0x13/0x1a
 [<ffffe410>] 0xffffe410
 =======================
INFO: lockdep is turned off.
evolution-ala D 000000AA     0  3887   3555 (NOTLB)
       c7f36eac 00200096 355ea29c 000000aa 00000000 c7f36e94 c0216c13 c7d7ed60
       c7d7eef0 c265c100 355ea29c 000000aa 00000000 c0157c10 c7f10f00 00200046
       c7f36ea0 c7efb684 ffffffff 00000000 ffffffff b6e20ff4 c7f36eb8 c0157c3d
Call Trace:
 [<c0157c3d>] refrigerator+0xcb/0xda
 [<c0138d38>] get_signal_to_deliver+0x33/0x463
 [<c01077ea>] do_notify_resume+0x94/0x732
 [<c01082f9>] work_notifysig+0x13/0x1a
 [<ffffe410>] 0xffffe410
 =======================
INFO: lockdep is turned off.
evolution-ala D 000000AA     0  3923   3555 (NOTLB)
       c8016eac 00200096 355e6654 000000aa 00000000 c8016e94 c0216c13 c7fb20d0
       c7fb2260 c265c100 355e6654 000000aa 00000000 c0157c10 c7f10f00 00200046
       c8016ea0 c7efb684 00000000 00000000 00000000 00000007 c8016eb8 c0157c3d
Call Trace:
 [<c0157c3d>] refrigerator+0xcb/0xda
 [<c0138d38>] get_signal_to_deliver+0x33/0x463
 [<c01077ea>] do_notify_resume+0x94/0x732
 [<c01082f9>] work_notifysig+0x13/0x1a
 [<ffffe410>] 0xffffe410
 =======================
INFO: lockdep is turned off.
nm-applet     D 000000AA     0  3883   3555 (NOTLB)
       c7ebaeac 00000096 355e582a 000000aa 00000000 c7ebae94 c0216c13 c7d795e0
       c7d79770 c265c100 355e582a 000000aa 00000000 c0157c10 c7f10500 00000046
       c7ebaea0 c7ef9004 000003e8 00000000 000003e8 b7297ff4 c7ebaeb8 c0157c3d
Call Trace:
 [<c0157c3d>] refrigerator+0xcb/0xda
 [<c0138d38>] get_signal_to_deliver+0x33/0x463
 [<c01077ea>] do_notify_resume+0x94/0x732
 [<c01082f9>] work_notifysig+0x13/0x1a
 [<ffffe410>] 0xffffe410
 =======================
INFO: lockdep is turned off.
gnome-cups-ic D 000000AA     0  3884   3555 (NOTLB)
       c7f27eac 00200096 355e3421 000000aa 00000000 c7f27e94 c0216c13 c7d7cc90
       c7d7ce20 c265c100 355e3421 000000aa 00000000 c0157c10 c7f10c80 00200046
       c7f27ea0 c7ef8a84 00000d1c 00000000 00000d1c b71f6ff4 c7f27eb8 c0157c3d
Call Trace:
 [<c0157c3d>] refrigerator+0xcb/0xda
 [<c0138d38>] get_signal_to_deliver+0x33/0x463
 [<c01077ea>] do_notify_resume+0x94/0x732
 [<c01082f9>] work_notifysig+0x13/0x1a
 [<ffffe410>] 0xffffe410
 =======================
INFO: lockdep is turned off.
gnome-power-m D 000000AA     0  3885      1 (NOTLB)
       c7f8ceac 00200096 355dfb44 000000aa 00000000 c7f8ce94 c0216c13 c7d7d780
       c7d7d910 c265c100 355dfb44 000000aa 00000000 c0157c10 c7f10780 00200046
       c7f8cea0 c7efab84 080de9a8 00000000 080de9a8 b717aff4 c7f8ceb8 c0157c3d
Call Trace:
 [<c0157c3d>] refrigerator+0xcb/0xda
 [<c0138d38>] get_signal_to_deliver+0x33/0x463
 [<c01077ea>] do_notify_resume+0x94/0x732
 [<c01082f9>] work_notifysig+0x13/0x1a
 [<ffffe410>] 0xffffe410
 =======================
INFO: lockdep is turned off.
evolution-exc D 000000AA     0  3899      1 (NOTLB)
       c7f85eac 00000096 355de3ed 000000aa 00000000 c7f85e94 c0216c13 c7e9cc90
       c7e9ce20 c265c100 355de3ed 000000aa 00000000 c0157c10 c7f11400 00000046
       c7f85ea0 c7ef9b04 ffffffff 00000000 ffffffff b6dc2ff4 c7f85eb8 c0157c3d
Call Trace:
 [<c0157c3d>] refrigerator+0xcb/0xda
 [<c0138d38>] get_signal_to_deliver+0x33/0x463
 [<c01077ea>] do_notify_resume+0x94/0x732
 [<c01082f9>] work_notifysig+0x13/0x1a
 [<ffffe410>] 0xffffe410
 =======================
INFO: lockdep is turned off.
evolution-exc D 000000AA     0  3902      1 (NOTLB)
       c7fcdeac 00000096 355dc50c 000000aa 00000000 c7fcde94 c0216c13 c7e995e0
       c7e99770 c265c100 355dc50c 000000aa 00000000 c0157c10 c7f11400 00000046
       c7fcdea0 c7ef9b04 ffffffff 00000000 ffffffff b6dc2ff4 c7fcdeb8 c0157c3d
Call Trace:
 [<c0157c3d>] refrigerator+0xcb/0xda
 [<c0138d38>] get_signal_to_deliver+0x33/0x463
 [<c01077ea>] do_notify_resume+0x94/0x732
 [<c01082f9>] work_notifysig+0x13/0x1a
 [<ffffe410>] 0xffffe410
 =======================
INFO: lockdep is turned off.
evolution-dat D 000000AA     0  3904      1 (NOTLB)
       c7cedeac 00000096 355d91cf 000000aa 00000000 c7cede94 c0216c13 c7e98000
       c7e98190 c265c100 355d91cf 000000aa 00000000 c0157c10 c7f10280 00000046
       c7cedea0 c7efa084 ffffffff 00000000 ffffffff b76bdff4 c7cedeb8 c0157c3d
Call Trace:
 [<c0157c3d>] refrigerator+0xcb/0xda
 [<c0138d38>] get_signal_to_deliver+0x33/0x463
 [<c01077ea>] do_notify_resume+0x94/0x732
 [<c01082f9>] work_notifysig+0x13/0x1a
 [<ffffe410>] 0xffffe410
 =======================
INFO: lockdep is turned off.
evolution-dat D 000000AA     0  3910      1 (NOTLB)
       c7ffbeac 00000096 355d7e09 000000aa 00000000 c7ffbe94 c0216c13 c7e9e270
       c7e9e400 c265c100 355d7e09 000000aa 00000000 c0157c10 c7f10280 00000046
       c7ffbea0 c7efa084 ffffffff 00000000 ffffffff b76bdff4 c7ffbeb8 c0157c3d
Call Trace:
 [<c0157c3d>] refrigerator+0xcb/0xda
 [<c0138d38>] get_signal_to_deliver+0x33/0x463
 [<c01077ea>] do_notify_resume+0x94/0x732
 [<c01082f9>] work_notifysig+0x13/0x1a
 [<ffffe410>] 0xffffe410
 =======================
INFO: lockdep is turned off.
evolution-dat D 000000AA     0  3920      1 (NOTLB)
       c7ea6eac 00000096 355d4868 000000aa 00000000 c7ea6e94 c0216c13 c7fb0000
       c7fb0190 c265c100 355d4868 000000aa 00000000 c0157c10 c7f10280 00000046
       c7ea6ea0 c7efa084 ffffffff 00000000 ffffffff b76bdff4 c7ea6eb8 c0157c3d
Call Trace:
 [<c0157c3d>] refrigerator+0xcb/0xda
 [<c0138d38>] get_signal_to_deliver+0x33/0x463
 [<c01077ea>] do_notify_resume+0x94/0x732
 [<c01082f9>] work_notifysig+0x13/0x1a
 [<ffffe410>] 0xffffe410
 =======================
INFO: lockdep is turned off.
gnome-termina D 000000AA     0  4604      1 (NOTLB)
       c8024eac 00200096 355d0c6b 000000aa 00000000 c8024e94 c0216c13 c7fb15e0
       c7fb1770 c265c100 355d0c6b 000000aa 00000000 c0157c10 c7f12080 00200046
       c8024ea0 c7efc184 00000258 00000000 00000258 b7528ff4 c8024eb8 c0157c3d
Call Trace:
 [<c0157c3d>] refrigerator+0xcb/0xda
 [<c0138d38>] get_signal_to_deliver+0x33/0x463
 [<c01077ea>] do_notify_resume+0x94/0x732
 [<c01082f9>] work_notifysig+0x13/0x1a
 [<ffffe410>] 0xffffe410
 =======================
INFO: lockdep is turned off.
gnome-termina D 000000AA     0  4610      1 (NOTLB)
       c809beac 00000096 355d3221 000000aa 00000000 c809be94 c0216c13 c7fb0af0
       c7fb0c80 c265c100 355d3221 000000aa 00000000 c0157c10 c7f12080 00000046
       c809bea0 c7efc184 b7535b70 00000000 b7535b70 b76f8874 c809beb8 c0157c3d
Call Trace:
 [<c0157c3d>] refrigerator+0xcb/0xda
 [<c0138d38>] get_signal_to_deliver+0x33/0x463
 [<c01077ea>] do_notify_resume+0x94/0x732
 [<c01082f9>] work_notifysig+0x13/0x1a
 [<ffffe410>] 0xffffe410
 =======================
INFO: lockdep is turned off.
gnome-pty-hel D 000000AA     0  4608   4604 (NOTLB)
       c8099eac 00000096 355d2122 000000aa 00000000 c8099e94 c0216c13 c7fb6270
       c7fb6400 c265c100 355d2122 000000aa 00000000 c0157c10 c7f11180 00000046
       c8099ea0 c7efa604 00000004 00000000 00000004 bfa30d24 c8099eb8 c0157c3d
Call Trace:
 [<c0157c3d>] refrigerator+0xcb/0xda
 [<c0138d38>] get_signal_to_deliver+0x33/0x463
 [<c01077ea>] do_notify_resume+0x94/0x732
 [<c01082f9>] work_notifysig+0x13/0x1a
 [<ffffe410>] 0xffffe410
 =======================
INFO: lockdep is turned off.
bash          D 000000AA     0  4609   4604 (NOTLB)
       c8092eac 00000096 355cb7c5 000000aa 00000000 c8092e94 c0216c13 c7fb41a0
       c7fb4330 c265c100 355cb7c5 000000aa 00000000 c0157c10 c7f11900 00000046
       c8092ea0 c7efc704 b7f63420 00000000 b7f63420 082a0008 c8092eb8 c0157c3d
Call Trace:
 [<c0157c3d>] refrigerator+0xcb/0xda
 [<c0138d38>] get_signal_to_deliver+0x33/0x463
 [<c01077ea>] do_notify_resume+0x94/0x732
 [<c01082f9>] work_notifysig+0x13/0x1a
 [<ffffe410>] 0xffffe410
 =======================
INFO: lockdep is turned off.
firefox       D 000000AA     0  5249      1 (NOTLB)
       c7e8deac 00200096 355ca1d7 000000aa 00000000 c7e8de94 c0216c13 c80e36b0
       c80e3840 c265c100 355ca1d7 000000aa 00000000 c0157c10 c7f12580 00200046
       c7e8dea0 c7efb104 00000000 00000000 00000000 00000002 c7e8deb8 c0157c3d
Call Trace:
 [<c0157c3d>] refrigerator+0xcb/0xda
 [<c0138d38>] get_signal_to_deliver+0x33/0x463
 [<c01077ea>] do_notify_resume+0x94/0x732
 [<c01082f9>] work_notifysig+0x13/0x1a
 [<ffffe410>] 0xffffe410
 =======================
INFO: lockdep is turned off.
run-mozilla.s D 000000AA     0  5261   5249 (NOTLB)
       c7fe2eac 00200096 355c948d 000000aa 00000000 c7fe2e94 c0216c13 c80e20d0
       c80e2260 c265c100 355c948d 000000aa 00000000 c0157c10 c7f13700 00200046
       c7fe2ea0 c7efdd04 00000000 00000000 00000000 00000001 c7fe2eb8 c0157c3d
Call Trace:
 [<c0157c3d>] refrigerator+0xcb/0xda
 [<c0138d38>] get_signal_to_deliver+0x33/0x463
 [<c01077ea>] do_notify_resume+0x94/0x732
 [<c01082f9>] work_notifysig+0x13/0x1a
 [<ffffe410>] 0xffffe410
 =======================
INFO: lockdep is turned off.
firefox-bin   D 000000AA     0  5265   5261 (NOTLB)
       c7fdbeac 00000096 355c85ab 000000aa 00000000 c7fdbe94 c0216c13 c80e41a0
       c80e4330 c265c100 355c85ab 000000aa 00000000 c0157c10 c7f13c00 00000046
       c7fdbea0 c7eff304 00000008 00000000 00000008 b76fcff4 c7fdbeb8 c0157c3d
Call Trace:
 [<c0157c3d>] refrigerator+0xcb/0xda
 [<c0138d38>] get_signal_to_deliver+0x33/0x463
 [<c01077ea>] do_notify_resume+0x94/0x732
 [<c01082f9>] work_notifysig+0x13/0x1a
 [<ffffe410>] 0xffffe410
 =======================
INFO: lockdep is turned off.
firefox-bin   D 000000AA     0  5266   5261 (NOTLB)
       c8075eac 00200096 355c6bf8 000000aa 00000000 c8075e94 c0216c13 c80e2bc0
       c80e2d50 c265c100 355c6bf8 000000aa 00000000 c0157c10 c7f13c00 00200046
       c8075ea0 c7eff304 03e7fc18 00000000 03e7fc18 b76fcff4 c8075eb8 c0157c3d
Call Trace:
 [<c0157c3d>] refrigerator+0xcb/0xda
 [<c0138d38>] get_signal_to_deliver+0x33/0x463
 [<c01077ea>] do_notify_resume+0x94/0x732
 [<c01082f9>] work_notifysig+0x13/0x1a
 [<ffffe410>] 0xffffe410
 =======================
INFO: lockdep is turned off.
firefox-bin   D 000000AA     0  5267   5261 (NOTLB)
       c7ccaeac 00200096 355c5365 000000aa 00000000 c7ccae94 c0216c13 c80e0000
       c80e0190 c265c100 355c5365 000000aa 00000000 c0157c10 c7f13c00 00200046
       c7ccaea0 c7eff304 b66962d8 00000000 b66962d8 0000b9d5 c7ccaeb8 c0157c3d
Call Trace:
 [<c0157c3d>] refrigerator+0xcb/0xda
 [<c0138d38>] get_signal_to_deliver+0x33/0x463
 [<c01077ea>] do_notify_resume+0x94/0x732
 [<c01082f9>] work_notifysig+0x13/0x1a
 [<ffffe410>] 0xffffe410
 =======================
INFO: lockdep is turned off.
firefox-bin   D 000000AA     0  5289   5261 (NOTLB)
       c80f7eac 00000096 355c4670 000000aa 00000000 c80f7e94 c0216c13 c7e9d780
       c7e9d910 c265c100 355c4670 000000aa 00000000 c0157c10 c7f13c00 00000046
       c80f7ea0 c7eff304 b2a982d8 00000000 b2a982d8 00004e73 c80f7eb8 c0157c3d
Call Trace:
 [<c0157c3d>] refrigerator+0xcb/0xda
 [<c0138d38>] get_signal_to_deliver+0x33/0x463
 [<c01077ea>] do_notify_resume+0x94/0x732
 [<c01082f9>] work_notifysig+0x13/0x1a
 [<ffffe410>] 0xffffe410
 =======================
INFO: lockdep is turned off.
firefox-bin   D 000000AA     0  5290   5261 (NOTLB)
       c80edeac 00000096 355c3ad3 000000aa 00000000 c80ede94 c0216c13 c7e9abc0
       c7e9ad50 c265c100 355c3ad3 000000aa 00000000 c0157c10 c7f13c00 00000046
       c80edea0 c7eff304 b22972e8 00000000 b22972e8 00003f11 c80edeb8 c0157c3d
Call Trace:
 [<c0157c3d>] refrigerator+0xcb/0xda
 [<c0138d38>] get_signal_to_deliver+0x33/0x463
 [<c01077ea>] do_notify_resume+0x94/0x732
 [<c01082f9>] work_notifysig+0x13/0x1a
 [<ffffe410>] 0xffffe410
 =======================
INFO: lockdep is turned off.
firefox-bin   D 000000AA     0  5291   5261 (NOTLB)
       c80eceac 00000096 355c2e06 000000aa 00000000 c80ece94 c0216c13 c7e9c1a0
       c7e9c330 c265c100 355c2e06 000000aa 00000000 c0157c10 c7f13c00 00000046
       c80ecea0 c7eff304 00000000 00000000 00000000 00000007 c80eceb8 c0157c3d
Call Trace:
 [<c0157c3d>] refrigerator+0xcb/0xda
 [<c0138d38>] get_signal_to_deliver+0x33/0x463
 [<c01077ea>] do_notify_resume+0x94/0x732
 [<c01082f9>] work_notifysig+0x13/0x1a
 [<ffffe410>] 0xffffe410
 =======================
INFO: lockdep is turned off.
firefox-bin   D 000000AA     0  5299   5261 (NOTLB)
       c8089eac 00000096 355c1f8c 000000aa 00000000 c8089e94 c0216c13 c80e5780
       c80e5910 c265c100 355c1f8c 000000aa 00000000 c0157c10 c7f13c00 00000046
       c8089ea0 c7eff304 00000000 00000000 00000000 0000047b c8089eb8 c0157c3d
Call Trace:
 [<c0157c3d>] refrigerator+0xcb/0xda
 [<c0138d38>] get_signal_to_deliver+0x33/0x463
 [<c01077ea>] do_notify_resume+0x94/0x732
 [<c01082f9>] work_notifysig+0x13/0x1a
 [<ffffe410>] 0xffffe410
 =======================
INFO: lockdep is turned off.
firefox-bin   D 000000AA     0  5320   5261 (NOTLB)
       c80fceac 00000096 355c129f 000000aa 00000000 c80fce94 c0216c13 c7e98af0
       c7e98c80 c265c100 355c129f 000000aa 00000000 c0157c10 c7f13c00 00000046
       c80fcea0 c7eff304 00000000 00000000 00000000 ae04dcec c80fceb8 c0157c3d
Call Trace:
 [<c0157c3d>] refrigerator+0xcb/0xda
 [<c0138d38>] get_signal_to_deliver+0x33/0x463
 [<c01077ea>] do_notify_resume+0x94/0x732
 [<c01082f9>] work_notifysig+0x13/0x1a
 [<ffffe410>] 0xffffe410
 =======================
INFO: lockdep is turned off.
firefox-bin   D 000000AA     0 10655   5261 (NOTLB)
       c80a6eac 00200096 355bf40b 000000aa 00000000 c80a6e94 c0216c13 c81e4c90
       c81e4e20 c265c100 355bf40b 000000aa 00000000 c0157c10 c7f13c00 00200046
       c80a6ea0 c7eff304 b4fb82b8 00000000 b4fb82b8 0000008f c80a6eb8 c0157c3d
Call Trace:
 [<c0157c3d>] refrigerator+0xcb/0xda
 [<c0138d38>] get_signal_to_deliver+0x33/0x463
 [<c01077ea>] do_notify_resume+0x94/0x732
 [<c01082f9>] work_notifysig+0x13/0x1a
 [<ffffe410>] 0xffffe410
 =======================
INFO: lockdep is turned off.
cat           D 0000002B     0  5603      1 (NOTLB)
       c8102e4c 00000096 80cc15ad 0000002b c1176c2c c8102e38 00000046 c7fb2bc0
       c7fb2d50 c265c100 80cc15ad 0000002b 00000000 c8102e4c c7f12d00 c014b438
       00000001 c036759c c63b6914 c8102e68 c63b68e0 00000246 c8102e88 c0367416
Call Trace:
 [<c0367416>] __mutex_lock_slowpath+0x1c7/0x32c
 [<c036759c>] mutex_lock+0x21/0x24
 [<f8ac10ca>] drm_vma_info+0x1f/0x310 [drm]
 [<c01b514d>] proc_file_read+0x108/0x222
 [<c01b19ed>] proc_reg_read+0x63/0x76
 [<c01834aa>] vfs_read+0xb0/0x139
 [<c018390e>] sys_read+0x3d/0x72
 [<c0108162>] sysenter_past_esp+0x6b/0xb5
 [<ffffe410>] 0xffffe410
 =======================
INFO: lockdep is turned off.
tail          D 0000002C     0  5646      1 (NOTLB)
       c811ce4c 00000096 7137dc36 0000002c c1175f98 c811ce38 00000046 c80e15e0
       c80e1770 c265c100 7137dc36 0000002c 00000000 c811ce4c c7f11e00 c014b438
       00000001 c036759c c63b6914 c811ce68 c63b68e0 00000246 c811ce88 c0367416
Call Trace:
 [<c0367416>] __mutex_lock_slowpath+0x1c7/0x32c
 [<c036759c>] mutex_lock+0x21/0x24
 [<f8ac10ca>] drm_vma_info+0x1f/0x310 [drm]
 [<c01b514d>] proc_file_read+0x108/0x222
 [<c01b19ed>] proc_reg_read+0x63/0x76
 [<c01834aa>] vfs_read+0xb0/0x139
 [<c018390e>] sys_read+0x3d/0x72
 [<c0108162>] sysenter_past_esp+0x6b/0xb5
 [<ffffe410>] 0xffffe410
 =======================
INFO: lockdep is turned off.
cat           D 00000033     0  5910      1 (NOTLB)
       c8107e4c 00000096 24ccdd52 00000033 c014b438 00000001 c8107e14 c7e9ed60
       c7e9eef0 c265c100 24ccdd52 00000033 00000000 c8107e4c c7f11b80 c014b438
       00000001 c036759c c63b6914 c8107e68 c63b68e0 00000246 c8107e88 c0367416
Call Trace:
 [<c0367416>] __mutex_lock_slowpath+0x1c7/0x32c
 [<c036759c>] mutex_lock+0x21/0x24
 [<f8ac10ca>] drm_vma_info+0x1f/0x310 [drm]
 [<c01b514d>] proc_file_read+0x108/0x222
 [<c01b19ed>] proc_reg_read+0x63/0x76
 [<c01834aa>] vfs_read+0xb0/0x139
 [<c018390e>] sys_read+0x3d/0x72
 [<c0108162>] sysenter_past_esp+0x6b/0xb5
 [<ffffe410>] 0xffffe410
 =======================
INFO: lockdep is turned off.
cat           D 00000033     0  5926      1 (NOTLB)
       c8160e4c 00000096 8cc85f27 00000033 c117483c c8160e38 00000046 c80e0af0
       c80e0c80 c265c100 8cc85f27 00000033 00000000 c8160e4c c7f13480 c014b438
       00000001 c036759c c63b6914 c8160e68 c63b68e0 00000246 c8160e88 c0367416
Call Trace:
 [<c0367416>] __mutex_lock_slowpath+0x1c7/0x32c
 [<c036759c>] mutex_lock+0x21/0x24
 [<f8ac10ca>] drm_vma_info+0x1f/0x310 [drm]
 [<c01b514d>] proc_file_read+0x108/0x222
 [<c01b19ed>] proc_reg_read+0x63/0x76
 [<c01834aa>] vfs_read+0xb0/0x139
 [<c018390e>] sys_read+0x3d/0x72
 [<c0108162>] sysenter_past_esp+0x6b/0xb5
 [<ffffe410>] 0xffffe410
 =======================
INFO: lockdep is turned off.
cat           D 00000034     0  5950      1 (NOTLB)
       c8084e4c 00000096 39b9c536 00000034 c117afbc c8084e38 00000046 c6ce15e0
       c6ce1770 c265c100 39b9c536 00000034 00000000 c8084e4c c7f13200 c014b438
       00000001 c036759c c63b6914 c8084e68 c63b68e0 00000246 c8084e88 c0367416
Call Trace:
 [<c0367416>] __mutex_lock_slowpath+0x1c7/0x32c
 [<c036759c>] mutex_lock+0x21/0x24
 [<f8ac10ca>] drm_vma_info+0x1f/0x310 [drm]
 [<c01b514d>] proc_file_read+0x108/0x222
 [<c01b19ed>] proc_reg_read+0x63/0x76
 [<c01834aa>] vfs_read+0xb0/0x139
 [<c018390e>] sys_read+0x3d/0x72
 [<c0108162>] sysenter_past_esp+0x6b/0xb5
 [<ffffe410>] 0xffffe410
 =======================
INFO: lockdep is turned off.
bash          D 000000AA     0  6106   4604 (NOTLB)
       c8150eac 00200096 355c05dc 000000aa 00000000 c8150e94 c0216c13 c7fb6d60
       c7fb6ef0 c265c100 355c05dc 000000aa 00000000 c0157c10 c7f11680 00200046
       c8150ea0 c7eff884 b7f32420 00000000 b7f32420 082ae008 c8150eb8 c0157c3d
Call Trace:
 [<c0157c3d>] refrigerator+0xcb/0xda
 [<c0138d38>] get_signal_to_deliver+0x33/0x463
 [<c01077ea>] do_notify_resume+0x94/0x732
 [<c01082f9>] work_notifysig+0x13/0x1a
 [<ffffe410>] 0xffffe410
 =======================
INFO: lockdep is turned off.
bash          D 000000AA     0  6149   4604 (NOTLB)
       c7ed1eac 00200096 355be42f 000000aa 00000000 c7ed1e94 c0216c13 c81e2bc0
       c81e2d50 c265c100 355be42f 000000aa 00000000 c0157c10 c7cc3c00 00200046
       c7ed1ea0 c81c1584 b7e9d420 00000000 b7e9d420 082ae008 c7ed1eb8 c0157c3d
Call Trace:
 [<c0157c3d>] refrigerator+0xcb/0xda
 [<c0138d38>] get_signal_to_deliver+0x33/0x463
 [<c01077ea>] do_notify_resume+0x94/0x732
 [<c01082f9>] work_notifysig+0x13/0x1a
 [<ffffe410>] 0xffffe410
 =======================
INFO: lockdep is turned off.
bash          D 000000AA     0  8615   2611 (NOTLB)
       c8159eac 00000096 355bd260 000000aa 00000000 c8159e94 c0216c13 c81e15e0
       c81e1770 c265c100 355bd260 000000aa 00000000 c0157c10 c8204280 00000046
       c8159ea0 c81c2604 0810ad88 00000000 0810ad88 00000000 c8159eb8 c0157c3d
Call Trace:
 [<c0157c3d>] refrigerator+0xcb/0xda
 [<c0138d38>] get_signal_to_deliver+0x33/0x463
 [<c01077ea>] do_notify_resume+0x94/0x732
 [<c01082f9>] work_notifysig+0x13/0x1a
 [<ffffe410>] 0xffffe410
 =======================
INFO: lockdep is turned off.
bash          D 000000AA     0  8642   8615 (NOTLB)
       c7dedeac 00000096 355bc33a 000000aa 00000000 c7dede94 c0216c13 c81e36b0
       c81e3840 c265c100 355bc33a 000000aa 00000000 c0157c10 c8204780 00000046
       c7dedea0 c81c2b84 b7e9f420 00000000 b7e9f420 0821f008 c7dedeb8 c0157c3d
Call Trace:
 [<c0157c3d>] refrigerator+0xcb/0xda
 [<c0138d38>] get_signal_to_deliver+0x33/0x463
 [<c01077ea>] do_notify_resume+0x94/0x732
 [<c01082f9>] work_notifysig+0x13/0x1a
 [<ffffe410>] 0xffffe410
 =======================
INFO: lockdep is turned off.
bash          D 000000AA     0  8711   2609 (NOTLB)
       c8116eac 00000096 355bb03d 000000aa 00000000 c8116e94 c0216c13 c81e0000
       c81e0190 c265c100 355bb03d 000000aa 00000000 c0157c10 c8205180 00000046
       c8116ea0 c81c2084 b7ee8420 00000000 b7ee8420 0829f008 c8116eb8 c0157c3d
Call Trace:
 [<c0157c3d>] refrigerator+0xcb/0xda
 [<c0138d38>] get_signal_to_deliver+0x33/0x463
 [<c01077ea>] do_notify_resume+0x94/0x732
 [<c01082f9>] work_notifysig+0x13/0x1a
 [<ffffe410>] 0xffffe410
 =======================
INFO: lockdep is turned off.
bash          D 000000AA     0  8747   2610 (NOTLB)
       cd090eac 00000096 355b9c7d 000000aa 00000000 cd090e94 c0216c13 c81e6d60
       c81e6ef0 c265c100 355b9c7d 000000aa 00000000 c0157c10 c8205b80 00000046
       cd090ea0 c81c1b04 b7efc420 00000000 b7efc420 0829f008 cd090eb8 c0157c3d
Call Trace:
 [<c0157c3d>] refrigerator+0xcb/0xda
 [<c0138d38>] get_signal_to_deliver+0x33/0x463
 [<c01077ea>] do_notify_resume+0x94/0x732
 [<c01082f9>] work_notifysig+0x13/0x1a
 [<ffffe410>] 0xffffe410
 =======================
INFO: lockdep is turned off.
gnome-help    D 000000AA     0  8809      1 (NOTLB)
       ce47deac 00000096 355b7daf 000000aa 00000000 ce47de94 c0216c13 c39415e0
       c3941770 c265c100 355b7daf 000000aa 00000000 c0157c10 c8205680 00000046
       ce47dea0 c81c3684 ffffffff 00000000 ffffffff b74e5ff4 ce47deb8 c0157c3d
Call Trace:
 [<c0157c3d>] refrigerator+0xcb/0xda
 [<c0138d38>] get_signal_to_deliver+0x33/0x463
 [<c01077ea>] do_notify_resume+0x94/0x732
 [<c01082f9>] work_notifysig+0x13/0x1a
 [<ffffe410>] 0xffffe410
 =======================
INFO: lockdep is turned off.
gnome-help    D 000000AA     0  8813      1 (NOTLB)
       cf26beac 00200096 355b49a7 000000aa 00000000 cf26be94 c0216c13 c81e0af0
       c81e0c80 c265c100 355b49a7 000000aa 00000000 c0157c10 c8205680 00200046
       cf26bea0 c81c3684 ffffffff 00000000 ffffffff b74e5ff4 cf26beb8 c0157c3d
Call Trace:
 [<c0157c3d>] refrigerator+0xcb/0xda
 [<c0138d38>] get_signal_to_deliver+0x33/0x463
 [<c01077ea>] do_notify_resume+0x94/0x732
 [<c01082f9>] work_notifysig+0x13/0x1a
 [<ffffe410>] 0xffffe410
 =======================
INFO: lockdep is turned off.
gnome-help    D 000000AA     0  8832      1 (NOTLB)
       cf3c5eac 00000096 355b37c5 000000aa 00000000 cf3c5e94 c0216c13 c80e4c90
       c80e4e20 c265c100 355b37c5 000000aa 00000000 c0157c10 c8205680 00000046
       cf3c5ea0 c81c3684 b4eda2d8 00000000 b4eda2d8 0000001f cf3c5eb8 c0157c3d
Call Trace:
 [<c0157c3d>] refrigerator+0xcb/0xda
 [<c0138d38>] get_signal_to_deliver+0x33/0x463
 [<c01077ea>] do_notify_resume+0x94/0x732
 [<c01082f9>] work_notifysig+0x13/0x1a
 [<ffffe410>] 0xffffe410
 =======================
INFO: lockdep is turned off.
gnome-help    D 000000AA     0  8811      1 (NOTLB)
       c81feeac 00000096 355b2469 000000aa 00000000 c81fee94 c0216c13 c81e6270
       c81e6400 c265c100 355b2469 000000aa 00000000 c0157c10 c8204a00 00000046
       c81feea0 c81c4c84 ffffffff 00000000 ffffffff b7537ff4 c81feeb8 c0157c3d
Call Trace:
 [<c0157c3d>] refrigerator+0xcb/0xda
 [<c0138d38>] get_signal_to_deliver+0x33/0x463
 [<c01077ea>] do_notify_resume+0x94/0x732
 [<c01082f9>] work_notifysig+0x13/0x1a
 [<ffffe410>] 0xffffe410
 =======================
INFO: lockdep is turned off.
gnome-help    D 000000AA     0  8812      1 (NOTLB)
       cf26ceac 00200096 355aeba0 000000aa 00000000 cf26ce94 c0216c13 c81e20d0
       c81e2260 c265c100 355aeba0 000000aa 00000000 c0157c10 c8204a00 00200046
       cf26cea0 c81c4c84 ffffffff 00000000 ffffffff b7537ff4 cf26ceb8 c0157c3d
Call Trace:
 [<c0157c3d>] refrigerator+0xcb/0xda
 [<c0138d38>] get_signal_to_deliver+0x33/0x463
 [<c01077ea>] do_notify_resume+0x94/0x732
 [<c01082f9>] work_notifysig+0x13/0x1a
 [<ffffe410>] 0xffffe410
 =======================
INFO: lockdep is turned off.
gnome-help    D 000000AA     0  8831      1 (NOTLB)
       cf3a8eac 00000096 355ad7f2 000000aa 00000000 cf3a8e94 c0216c13 c80e6d60
       c80e6ef0 c265c100 355ad7f2 000000aa 00000000 c0157c10 c8204a00 00000046
       cf3a8ea0 c81c4c84 b4f2c2d8 00000000 b4f2c2d8 00000023 cf3a8eb8 c0157c3d
Call Trace:
 [<c0157c3d>] refrigerator+0xcb/0xda
 [<c0138d38>] get_signal_to_deliver+0x33/0x463
 [<c01077ea>] do_notify_resume+0x94/0x732
 [<c01082f9>] work_notifysig+0x13/0x1a
 [<ffffe410>] 0xffffe410
 =======================
INFO: lockdep is turned off.
hald-addon-ke D 000000AA     0 10071   3270 (NOTLB)
       d03bbeac 00000096 355abe13 000000aa 00000000 d03bbe94 c0216c13 c6ce6d60
       c6ce6ef0 c265c100 355abe13 000000aa 00000000 c0157c10 c8207700 00000046
       d03bbea0 c3a85204 0804e4a8 00000000 0804e4a8 0804e4a8 d03bbeb8 c0157c3d
Call Trace:
 [<c0157c3d>] refrigerator+0xcb/0xda
 [<c0138d38>] get_signal_to_deliver+0x33/0x463
 [<c01077ea>] do_notify_resume+0x94/0x732
 [<c01082f9>] work_notifysig+0x13/0x1a
 [<ffffe410>] 0xffffe410
 =======================
INFO: lockdep is turned off.
hald-addon-ke D 000000AA     0 10073   3270 (NOTLB)
       cd1e2eac 00000096 355aaa8d 000000aa 00000000 cd1e2e94 c0216c13 c3946270
       c3946400 c265c100 355aaa8d 000000aa 00000000 c0157c10 c8206580 00000046
       cd1e2ea0 c3a82084 0804e488 00000000 0804e488 0804e488 cd1e2eb8 c0157c3d
Call Trace:
 [<c0157c3d>] refrigerator+0xcb/0xda
 [<c0138d38>] get_signal_to_deliver+0x33/0x463
 [<c01077ea>] do_notify_resume+0x94/0x732
 [<c01082f9>] work_notifysig+0x13/0x1a
 [<ffffe410>] 0xffffe410
 =======================
INFO: lockdep is turned off.
hald-addon-ke D 000000AA     0 10080   3270 (NOTLB)
       c7c05eac 00000096 355a9b6e 000000aa 00000000 c7c05e94 c0216c13 c3b16270
       c3b16400 c265c100 355a9b6e 000000aa 00000000 c0157c10 c8205900 00000046
       c7c05ea0 c81c7e04 0804e488 00000000 0804e488 0804e488 c7c05eb8 c0157c3d
Call Trace:
 [<c0157c3d>] refrigerator+0xcb/0xda
 [<c0138d38>] get_signal_to_deliver+0x33/0x463
 [<c01077ea>] do_notify_resume+0x94/0x732
 [<c01082f9>] work_notifysig+0x13/0x1a
 [<ffffe410>] 0xffffe410
 =======================
INFO: lockdep is turned off.
hal-system-po D 000000AA     0 10471   3270 (NOTLB)
       c7c13eac 00000096 355a8a26 000000aa 00000000 c7c13e94 c0216c13 c7c2c1a0
       c7c2c330 c265c100 355a8a26 000000aa 00000000 c0157c10 c8206f80 00000046
       c7c13ea0 c81c3104 00000000 00000000 00000000 00000002 c7c13eb8 c0157c3d
Call Trace:
 [<c0157c3d>] refrigerator+0xcb/0xda
 [<c0138d38>] get_signal_to_deliver+0x33/0x463
 [<c01077ea>] do_notify_resume+0x94/0x732
 [<c01082f9>] work_notifysig+0x13/0x1a
 [<ffffe410>] 0xffffe410
 =======================
INFO: lockdep is turned off.
sleep.sh      R running     0 10472  10471 (NOTLB)
sleep         D 000000AA     0 10538   3138 (NOTLB)
       cd3caeac 00000096 355a7b22 000000aa 00000000 cd3cae94 c0216c13 c7e015e0
       c7e01770 c265c100 355a7b22 000000aa 00000000 c0157c10 c8207980 00000046
       cd3caea0 c81c0504 00003800 00000000 00003800 bfdbe2e4 cd3caeb8 c0157c3d
Call Trace:
 [<c0157c3d>] refrigerator+0xcb/0xda
 [<c0138d38>] get_signal_to_deliver+0x33/0x463
 [<c01077ea>] do_notify_resume+0x94/0x732
 [<c01082f9>] work_notifysig+0x13/0x1a
 [<ffffe410>] 0xffffe410
 =======================
INFO: lockdep is turned off.
Sched Debug Version: v0.03, cfs-v18, 2.6.22-rc6-mm1 #5
now at 2535947769678 nsecs

cpu#0, 1695.816 MHz
  .nr_running                    : 3
  .load                          : 7274
  .ls.delta_fair                 : 0
  .ls.delta_exec                 : 0
  .nr_switches                   : 4531912
  .nr_load_updates               : 550906
  .nr_uninterruptible            : 118
  .jiffies                       : 670784
  .next_balance                  : 670792
  .curr->pid                     : 10472
  .clock                         : 751284868597
  .prev_clock_raw                : 2535883825675
  .clock_warps                   : 4
  .clock_overflows               : 2021
  .clock_unstable_events         : 793853
  .clock_max_delta               : 6658663
  .cfs.fair_clock                : 533327495256
  .cfs.exec_clock                : 717938453608
  .cfs.wait_runtime              : -50799679
  .cfs.wait_runtime_overruns     : 0
  .cfs.wait_runtime_underruns    : 0
  .cpu_load[0]                   : 7119
  .cpu_load[1]                   : 7179
  .cpu_load[2]                   : 7223
  .cpu_load[3]                   : 7210
  .cpu_load[4]                   : 7126
  .wait_runtime_rq_sum           : 26666664

runnable tasks:
            task   PID        tree-key         delta       waiting
switches  prio        sum-exec        sum-wait       sum-sleep
wait-overrun   wait-underrun
------------------------------------------------------------------------------------------------------------------------------------------------------------------
        events/0     6    533214774255    -113196631      26666664
60672   115      1237041798               0               0
   0               0
     kondemand/0   479    533200829791    -127141095      26666664
36274   115       647267229               0               0
   0               0
R       sleep.sh 10472    533354637550      26666664     -26666664
  436   120     20278438313               0               0
   0               0

 cat
 tail
 cat
 cat
 cat
