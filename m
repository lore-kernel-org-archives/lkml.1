Return-Path: <linux-kernel-owner+w=401wt.eu-S1751961AbZHRD72@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751961AbZHRD72 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Aug 2009 23:59:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751241AbZHRD71
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Aug 2009 23:59:27 -0400
Received: from mail-yx0-f175.google.com ([209.85.210.175]:51659 "EHLO
	mail-yx0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751145AbZHRD7R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Aug 2009 23:59:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type
         :content-transfer-encoding;
        b=nUQdqo3D/XZn0Yo8Xz8LRjD+nmURVsUApcLmndNS2oPkI+79ZWYesLJl8suz+vqFFK
         4P1lG8huXeH3CtqEBgzb1ZkEjvbekcEwZVvUofcu5qARr3XWpUKQPQ+c2ZMTsmQQeu+Q
         B5AeappNHkN5yF24j8qweu0saEv5d1g2eN2xg=
MIME-Version: 1.0
Date: Mon, 17 Aug 2009 23:59:17 -0400
Message-ID: <a44ae5cd0908172059mba5121rdcea6af86d9f85ab@mail.gmail.com>
Subject: 2.6.31-rc6-git2 -- PM: Preparing system for mem sleep -- [<10af497>] 
	? sync_buffer+0x0/0x37
From: Miles Lane <miles.lane@gmail.com>
To: Jens Axboe <jens.axboe@oracle.com>, Greg Kroah-Hartman <gregkh@suse.de>,
       Thomas Gleixner <tglx@linutronix.de>,
       "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>,
       Matt Helsley <matthltc@us.ibm.com>, Oren Laadan <orenl@cs.columbia.edu>,
       Cedric Le Goater <legoater@free.fr>, Paul Menage <menage@google.com>,
       Li Zefan <lizf@cn.fujitsu.com>, Pavel Machek <pavel@ucw.cz>,
       Miklos Szeredi <miklos@szeredi.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, "Rafael J. Wysocki" <rjw@sisk.pl>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'll send my .config file separately.  I am afraid that including it
in this message might cause VGER to reject it.

Aug 17 21:26:30 ubuntu kernel: [26618.878526] PM: Syncing filesystems ... done.
Aug 17 21:26:30 ubuntu kernel: [26618.930235] PM: Preparing system for mem sleep
Aug 17 21:26:50 ubuntu kernel: <10af497>] ? sync_buffer+0x0/0x37
Aug 17 21:26:50 ubuntu kernel: [26639.162016]  [<c13ed28d>]
out_of_line_wait_on_bit+0x57/0x5f
Aug 17 21:26:50 ubuntu kernel: [26639.162025]  [<c10af497>] ?
sync_buffer+0x0/0x37
Aug 17 21:26:50 ubuntu kernel: [26639.162035]  [<c103cce4>] ?
wake_bit_function+0x0/0x37
Aug 17 21:26:50 ubuntu kernel: [26639.162044]  [<c10af42a>]
__wait_on_buffer+0x19/0x1c
Aug 17 21:26:50 ubuntu kernel: [26639.162055]  [<c110afc3>]
wait_on_buffer+0x28/0x2b
Aug 17 21:26:50 ubuntu kernel: [26639.162065]  [<c110b9ce>]
journal_commit_transaction+0x96c/0xed6
Aug 17 21:26:50 ubuntu kernel: [26639.162076]  [<c104a803>] ?
trace_hardirqs_on+0xb/0xd
Aug 17 21:26:50 ubuntu kernel: [26639.162086]  [<c103407a>] ?
try_to_del_timer_sync+0x3e/0x46
Aug 17 21:26:50 ubuntu kernel: [26639.162096]  [<c110ed5e>]
kjournald+0x134/0x31e
Aug 17 21:26:50 ubuntu kernel: [26639.162107]  [<c103ccb5>] ?
autoremove_wake_function+0x0/0x2f
Aug 17 21:26:50 ubuntu kernel: [26639.162116]  [<c110ec2a>] ?
kjournald+0x0/0x31e
Aug 17 21:26:50 ubuntu kernel: [26639.162125]  [<c103ca2e>] kthread+0x6b/0x70
Aug 17 21:26:50 ubuntu kernel: [26639.162135]  [<c103c9c3>] ? kthread+0x0/0x70
Aug 17 21:26:50 ubuntu kernel: [26639.162144]  [<c100385b>]
kernel_thread_helper+0x7/0x1a
Aug 17 21:26:50 ubuntu kernel: [26639.162152] udevd         D 00001835
 1936  1334      1 0x00000000
Aug 17 21:26:50 ubuntu kernel: [26639.162165]  eee52e8c 00000046
c174bf15 00001835 c1042993 f62fb674 c1689a00 00000046
Aug 17 21:26:50 ubuntu kernel: [26639.162186]  c1685eb8 c1689a00
f62fb674 c1689a00 c1042993 00000007 f62fb3e0 c13ee6c2
Aug 17 21:26:50 ubuntu kernel: [26639.162207]  c1478fca 00001835
f62fb3e0 f6309584 00000002 eee52e80 c104a803 00000000
Aug 17 21:26:50 ubuntu kernel: [26639.162227] Call Trace:
Aug 17 21:26:50 ubuntu kernel: [26639.162236]  [<c1042993>] ?
refrigerator+0x72/0xdb
Aug 17 21:26:50 ubuntu kernel: [26639.162246]  [<c1042993>] ?
refrigerator+0x72/0xdb
Aug 17 21:26:50 ubuntu kernel: [26639.162256]  [<c13ee6c2>] ?
_spin_unlock_irq+0x22/0x45
Aug 17 21:26:50 ubuntu kernel: [26639.162266]  [<c104a803>] ?
trace_hardirqs_on+0xb/0xd
Aug 17 21:26:50 ubuntu kernel: [26639.162276]  [<c10429e5>]
refrigerator+0xc4/0xdb
Aug 17 21:26:50 ubuntu kernel: [26639.162285]  [<c1035b74>]
try_to_freeze+0x19/0x20
Aug 17 21:26:50 ubuntu kernel: [26639.162294]  [<c10371f0>]
get_signal_to_deliver+0x36/0x32e
Aug 17 21:26:50 ubuntu kernel: [26639.162304]  [<c1001fcd>]
do_notify_resume+0x77/0x735
Aug 17 21:26:50 ubuntu kernel: [26639.162314]  [<c104bac2>] ?
__lock_acquire+0xad3/0xae2
Aug 17 21:26:50 ubuntu kernel: [26639.162324]  [<c107e7e3>] ?
might_fault+0x4b/0x88
Aug 17 21:26:50 ubuntu kernel: [26639.162334]  [<c107e7e3>] ?
might_fault+0x4b/0x88
Aug 17 21:26:50 ubuntu kernel: [26639.162344]  [<c131280b>] ?
sys_socketcall+0x15a/0x185
Aug 17 21:26:50 ubuntu kernel: [26639.162354]  [<c10a0e1a>] ? sys_poll+0x42/0x8b
Aug 17 21:26:50 ubuntu kernel: [26639.162363]  [<c1002d96>]
work_notifysig+0x13/0x19
Aug 17 21:26:50 ubuntu kernel: [26639.162371] udevd         D 00001835
 2048  1521   1334 0x00000000
Aug 17 21:26:50 ubuntu kernel: [26639.162385]  eeafae8c 00000046
c2841df5 00001835 c1042993 eea7d594 c1689a00 00000046
Aug 17 21:26:50 ubuntu kernel: [26639.162405]  c1685eb8 c1689a00
eea7d594 c1689a00 c1042993 00000007 eea7d300 c13ee6c2
Aug 17 21:26:50 ubuntu kernel: [26639.162426]  c28366cd 00001835
eea7d300 eebf4704 00000002 eeafae80 c104a803 00000000
Aug 17 21:26:50 ubuntu kernel: [26639.162446] Call Trace:
Aug 17 21:26:50 ubuntu kernel: [26639.162456]  [<c1042993>] ?
refrigerator+0x72/0xdb
Aug 17 21:26:50 ubuntu kernel: [26639.162466]  [<c1042993>] ?
refrigerator+0x72/0xdb
Aug 17 21:26:50 ubuntu kernel: [26639.162475]  [<c13ee6c2>] ?
_spin_unlock_irq+0x22/0x45
Aug 17 21:26:50 ubuntu kernel: [26639.162485]  [<c104a803>] ?
trace_hardirqs_on+0xb/0xd
Aug 17 21:26:50 ubuntu kernel: [26639.162495]  [<c10429e5>]
refrigerator+0xc4/0xdb
Aug 17 21:26:50 ubuntu kernel: [26639.162504]  [<c1035b74>]
try_to_freeze+0x19/0x20
Aug 17 21:26:50 ubuntu kernel: [26639.162513]  [<c10371f0>]
get_signal_to_deliver+0x36/0x32e
Aug 17 21:26:50 ubuntu kernel: [26639.162524]  [<c101a42d>] ?
do_page_fault+0x0/0x20b
Aug 17 21:26:50 ubuntu kernel: [26639.162533]  [<c1001fcd>]
do_notify_resume+0x77/0x735
Aug 17 21:26:50 ubuntu kernel: [26639.162543]  [<c108986e>] ?
swap_info_get+0x4a/0x80
Aug 17 21:26:50 ubuntu kernel: [26639.162556]  [<c1040143>] ? up_read+0x16/0x2b
Aug 17 21:26:50 ubuntu kernel: [26639.162565]  [<c101a611>] ?
do_page_fault+0x1e4/0x20b
Aug 17 21:26:50 ubuntu kernel: [26639.162575]  [<c101a42d>] ?
do_page_fault+0x0/0x20b
Aug 17 21:26:50 ubuntu kernel: [26639.162584]  [<c1002d96>]
work_notifysig+0x13/0x19
Aug 17 21:26:50 ubuntu kernel: [26639.162591] udevd         D 00001835
 1916  1523   1334 0x00000000
Aug 17 21:26:50 ubuntu kernel: [26639.162605]  ee97ce8c 00000046
c20520de 00001835 c1042993 f72574b4 c1689a00 00000046
Aug 17 21:26:50 ubuntu kernel: [26639.162625]  c1685eb8 c1689a00
f72574b4 c1689a00 c1042993 00000007 f7257220 c13ee6c2
Aug 17 21:26:50 ubuntu kernel: [26639.162646]  c2046e6e 00001835
f7257220 eebf4c84 00000002 ee97ce80 c104a803 00000000
Aug 17 21:26:50 ubuntu kernel: [26639.162666] Call Trace:
Aug 17 21:26:50 ubuntu kernel: [26639.162676]  [<c1042993>] ?
refrigerator+0x72/0xdb
Aug 17 21:26:50 ubuntu kernel: [26639.162686]  [<c1042993>] ?
refrigerator+0x72/0xdb
Aug 17 21:26:50 ubuntu kernel: [26639.162695]  [<c13ee6c2>] ?
_spin_unlock_irq+0x22/0x45
Aug 17 21:26:50 ubuntu kernel: [26639.162705]  [<c104a803>] ?
trace_hardirqs_on+0xb/0xd
Aug 17 21:26:50 ubuntu kernel: [26639.162715]  [<c10429e5>]
refrigerator+0xc4/0xdb
Aug 17 21:26:50 ubuntu kernel: [26639.162724]  [<c1035b74>]
try_to_freeze+0x19/0x20
Aug 17 21:26:50 ubuntu kernel: [26639.162733]  [<c10371f0>]
get_signal_to_deliver+0x36/0x32e
Aug 17 21:26:50 ubuntu kernel: [26639.162743]  [<c101a42d>] ?
do_page_fault+0x0/0x20b
Aug 17 21:26:50 ubuntu kernel: [26639.162752]  [<c1001fcd>]
do_notify_resume+0x77/0x735
Aug 17 21:26:50 ubuntu kernel: [26639.162761]  [<c108986e>] ?
swap_info_get+0x4a/0x80
Aug 17 21:26:50 ubuntu kernel: [26639.162774]  [<c1040143>] ? up_read+0x16/0x2b
Aug 17 21:26:50 ubuntu kernel: [26639.162783]  [<c101a611>] ?
do_page_fault+0x1e4/0x20b
Aug 17 21:26:50 ubuntu kernel: [26639.162793]  [<c101a42d>] ?
do_page_fault+0x0/0x20b
Aug 17 21:26:50 ubuntu kernel: [26639.162802]  [<c1002d96>]
work_notifysig+0x13/0x19
Aug 17 21:26:50 ubuntu kernel: [26639.162810] phy0          S 00001835
 2224  1565      2 0x00000000
Aug 17 21:26:50 ubuntu kernel: [26639.162823]  ede68f54 00000046
88d3232d 00001835 00000000 ee202c14 c1689a00 ee202980
Aug 17 21:26:50 ubuntu kernel: [26639.162844]  c1685eb8 c1689a00
ee202c14 c1689a00 c2c92fa4 007879a6 c2c89eb8 00000000
Aug 17 21:26:50 ubuntu kernel: [26639.162865]  88d2ca5b 00001835
ee202980 ede68f80 00000000 00000001 00000000 c2c92f80
Aug 17 21:26:50 ubuntu kernel: [26639.162885] Call Trace:
Aug 17 21:26:50 ubuntu kernel: [26639.162896]  [<c103975b>]
worker_thread+0xa0/0x29a
Aug 17 21:26:50 ubuntu kernel: [26639.162907]  [<c13cc235>] ?
ieee80211_sta_work+0x0/0xd29
Aug 17 21:26:50 ubuntu kernel: [26639.162917]  [<c103ccb5>] ?
autoremove_wake_function+0x0/0x2f
Aug 17 21:26:50 ubuntu kernel: [26639.162927]  [<c10396bb>] ?
worker_thread+0x0/0x29a
Aug 17 21:26:50 ubuntu kernel: [26639.162936]  [<c103ca2e>] kthread+0x6b/0x70
Aug 17 21:26:50 ubuntu kernel: [26639.162946]  [<c103c9c3>] ? kthread+0x0/0x70
Aug 17 21:26:50 ubuntu kernel: [26639.162956]  [<c100385b>]
kernel_thread_helper+0x7/0x1a
Aug 17 21:26:50 ubuntu kernel: [26639.162962] getty         D 00001835
 2576  2089      1 0x00000000
Aug 17 21:26:51 ubuntu kernel: [26639.162976]  eea67e8c 00000046
c156d5ef 00001835 c1042993 ee923674 c1689a00 00000046
Aug 17 21:26:51 ubuntu kernel: [26639.162997]  c1685eb8 c1689a00
ee923674 c1689a00 c1042993 00000007 ee9233e0 c13ee6c2
Aug 17 21:26:51 ubuntu kernel: [26639.163017]  c1349de8 00001835
ee9233e0 ee402084 00000002 eea67e80 c104a803 00000000
Aug 17 21:26:51 ubuntu kernel: [26639.163038] Call Trace:
Aug 17 21:26:51 ubuntu kernel: [26639.163047]  [<c1042993>] ?
refrigerator+0x72/0xdb
Aug 17 21:26:51 ubuntu kernel: [26639.163057]  [<c1042993>] ?
refrigerator+0x72/0xdb
Aug 17 21:26:51 ubuntu kernel: [26639.163066]  [<c13ee6c2>] ?
_spin_unlock_irq+0x22/0x45
Aug 17 21:26:51 ubuntu kernel: [26639.163076]  [<c1349de8>] ?
ip_append_data+0x156/0x814
Aug 17 21:26:51 ubuntu kernel: [26639.163086]  [<c104a803>] ?
trace_hardirqs_on+0xb/0xd
Aug 17 21:26:51 ubuntu kernel: [26639.163096]  [<c10429e5>]
refrigerator+0xc4/0xdb
Aug 17 21:26:51 ubuntu kernel: [26639.163106]  [<c1035b74>]
try_to_freeze+0x19/0x20
Aug 17 21:26:51 ubuntu kernel: [26639.163114]  [<c10371f0>]
get_signal_to_deliver+0x36/0x32e
Aug 17 21:26:51 ubuntu kernel: [26639.163124]  [<c104a803>] ?
trace_hardirqs_on+0xb/0xd
Aug 17 21:26:51 ubuntu kernel: [26639.163133]  [<c1001fcd>]
do_notify_resume+0x77/0x735
Aug 17 21:26:51 ubuntu kernel: [26639.163144]  [<c11e7b62>] ?
n_tty_read+0x516/0x5b7
Aug 17 21:26:51 ubuntu kernel: [26639.163154]  [<c11e9d45>] ?
put_ldisc+0x7d/0x83
Aug 17 21:26:51 ubuntu kernel: [26639.163163]  [<c104a7d0>] ?
trace_hardirqs_on_caller+0x108/0x130
Aug 17 21:26:51 ubuntu kernel: [26639.163173]  [<c104a803>] ?
trace_hardirqs_on+0xb/0xd
Aug 17 21:26:51 ubuntu kernel: [26639.163182]  [<c11e9d53>] ?
tty_ldisc_deref+0x8/0xa
Aug 17 21:26:51 ubuntu kernel: [26639.163191]  [<c11e4037>] ? tty_read+0x72/0x9e
Aug 17 21:26:51 ubuntu kernel: [26639.163201]  [<c11e764c>] ?
n_tty_read+0x0/0x5b7
Aug 17 21:26:51 ubuntu kernel: [26639.163210]  [<c11e3fc5>] ? tty_read+0x0/0x9e
Aug 17 21:26:51 ubuntu kernel: [26639.163218]  [<c1094e62>] ? vfs_read+0x7d/0xdc
Aug 17 21:26:51 ubuntu kernel: [26639.163228]  [<c1094f6d>] ? sys_read+0x53/0x5d
Aug 17 21:26:51 ubuntu kernel: [26639.163237]  [<c1002d96>]
work_notifysig+0x13/0x19
Aug 17 21:26:51 ubuntu kernel: [26639.163245] getty         D 00001835
 2620  2091      1 0x00000000
Aug 17 21:26:51 ubuntu kernel: [26639.163259]  eea65e8c 00000046
c1572853 00001835 c1042993 ee200294 c1689a00 00000046
Aug 17 21:26:51 ubuntu kernel: [26639.163280]  c1685eb8 c1689a00
ee200294 c1689a00 c1042993 00000007 ee200000 c13ee6c2
Aug 17 21:26:51 ubuntu kernel: [26639.163300]  c1349de8 00001835
ee200000 eebf4184 00000002 eea65e80 c104a803 00000000
Aug 17 21:26:51 ubuntu kernel: [26639.163321] Call Trace:
Aug 17 21:26:51 ubuntu kernel: [26639.163330]  [<c1042993>] ?
refrigerator+0x72/0xdb
Aug 17 21:26:51 ubuntu kernel: [26639.163340]  [<c1042993>] ?
refrigerator+0x72/0xdb
Aug 17 21:26:51 ubuntu kernel: [26639.163349]  [<c13ee6c2>] ?
_spin_unlock_irq+0x22/0x45
Aug 17 21:26:51 ubuntu kernel: [26639.163359]  [<c1349de8>] ?
ip_append_data+0x156/0x814
Aug 17 21:26:51 ubuntu kernel: [26639.163369]  [<c104a803>] ?
trace_hardirqs_on+0xb/0xd
Aug 17 21:26:51 ubuntu kernel: [26639.163378]  [<c10429e5>]
refrigerator+0xc4/0xdb
Aug 17 21:26:51 ubuntu kernel: [26639.163388]  [<c1035b74>]
try_to_freeze+0x19/0x20
Aug 17 21:26:51 ubuntu kernel: [26639.163397]  [<c10371f0>]
get_signal_to_deliver+0x36/0x32e
Aug 17 21:26:51 ubuntu kernel: [26639.163406]  [<c104a803>] ?
trace_hardirqs_on+0xb/0xd
Aug 17 21:26:51 ubuntu kernel: [26639.163416]  [<c1001fcd>]
do_notify_resume+0x77/0x735
Aug 17 21:26:51 ubuntu kernel: [26639.163426]  [<c11e7b62>] ?
n_tty_read+0x516/0x5b7
Aug 17 21:26:51 ubuntu kernel: [26639.163435]  [<c11e9d45>] ?
put_ldisc+0x7d/0x83
Aug 17 21:26:51 ubuntu kernel: [26639.163445]  [<c104a7d0>] ?
trace_hardirqs_on_caller+0x108/0x130
Aug 17 21:26:51 ubuntu kernel: [26639.163455]  [<c104a803>] ?
trace_hardirqs_on+0xb/0xd
Aug 17 21:26:51 ubuntu kernel: [26639.163464]  [<c11e9d53>] ?
tty_ldisc_deref+0x8/0xa
Aug 17 21:26:51 ubuntu kernel: [26639.163473]  [<c11e4037>] ? tty_read+0x72/0x9e
Aug 17 21:26:51 ubuntu kernel: [26639.163482]  [<c11e764c>] ?
n_tty_read+0x0/0x5b7
Aug 17 21:26:51 ubuntu kernel: [26639.163491]  [<c11e3fc5>] ? tty_read+0x0/0x9e
Aug 17 21:26:51 ubuntu kernel: [26639.163500]  [<c1094e62>] ? vfs_read+0x7d/0xdc
Aug 17 21:26:51 ubuntu kernel: [26639.163509]  [<c1094f6d>] ? sys_read+0x53/0x5d
Aug 17 21:26:51 ubuntu kernel: [26639.163518]  [<c1002d96>]
work_notifysig+0x13/0x19
Aug 17 21:26:51 ubuntu kernel: [26639.163526] getty         D 00001835
 2768  2092      1 0x00000000
Aug 17 21:26:51 ubuntu kernel: [26639.163540]  f5995e8c 00000046
c1577ab2 00001835 c1042993 ee9240d4 c1689a00 00000046
Aug 17 21:26:51 ubuntu kernel: [26639.163561]  c1685eb8 c1689a00
ee9240d4 c1689a00 c1042993 00000007 ee923e40 c13ee6c2
Aug 17 21:26:51 ubuntu kernel: [26639.163581]  c1349de8 00001835
ee923e40 ee403684 00000002 f5995e80 c104a803 00000000
Aug 17 21:26:51 ubuntu kernel: [26639.163602] Call Trace:
Aug 17 21:26:51 ubuntu kernel: [26639.163611]  [<c1042993>] ?
refrigerator+0x72/0xdb
Aug 17 21:26:51 ubuntu kernel: [26639.163621]  [<c1042993>] ?
refrigerator+0x72/0xdb
Aug 17 21:26:51 ubuntu kernel: [26639.163631]  [<c13ee6c2>] ?
_spin_unlock_irq+0x22/0x45
Aug 17 21:26:51 ubuntu kernel: [26639.163640]  [<c1349de8>] ?
ip_append_data+0x156/0x814
Aug 17 21:26:51 ubuntu kernel: [26639.163650]  [<c104a803>] ?
trace_hardirqs_on+0xb/0xd
Aug 17 21:26:51 ubuntu kernel: [26639.163660]  [<c10429e5>]
refrigerator+0xc4/0xdb
Aug 17 21:26:51 ubuntu kernel: [26639.163669]  [<c1035b74>]
try_to_freeze+0x19/0x20
Aug 17 21:26:51 ubuntu kernel: [26639.163678]  [<c10371f0>]
get_signal_to_deliver+0x36/0x32e
Aug 17 21:26:51 ubuntu kernel: [26639.163688]  [<c104a803>] ?
trace_hardirqs_on+0xb/0xd
Aug 17 21:26:51 ubuntu kernel: [26639.163697]  [<c1001fcd>]
do_notify_resume+0x77/0x735
Aug 17 21:26:51 ubuntu kernel: [26639.163707]  [<c11e7b62>] ?
n_tty_read+0x516/0x5b7
Aug 17 21:26:51 ubuntu kernel: [26639.163717]  [<c11e9d45>] ?
put_ldisc+0x7d/0x83
Aug 17 21:26:51 ubuntu kernel: [26639.163726]  [<c104a7d0>] ?
trace_hardirqs_on_caller+0x108/0x130
Aug 17 21:26:51 ubuntu kernel: [26639.163736]  [<c104a803>] ?
trace_hardirqs_on+0xb/0xd
Aug 17 21:26:51 ubuntu kernel: [26639.163745]  [<c11e9d53>] ?
tty_ldisc_deref+0x8/0xa
Aug 17 21:26:51 ubuntu kernel: [26639.163754]  [<c11e4037>] ? tty_read+0x72/0x9e
Aug 17 21:26:51 ubuntu kernel: [26639.163763]  [<c11e764c>] ?
n_tty_read+0x0/0x5b7
Aug 17 21:26:51 ubuntu kernel: [26639.163772]  [<c11e3fc5>] ? tty_read+0x0/0x9e
Aug 17 21:26:51 ubuntu kernel: [26639.163781]  [<c1094e62>] ? vfs_read+0x7d/0xdc
Aug 17 21:26:51 ubuntu kernel: [26639.163790]  [<c1094f6d>] ? sys_read+0x53/0x5d
Aug 17 21:26:51 ubuntu kernel: [26639.163800]  [<c1002d96>]
work_notifysig+0x13/0x19
Aug 17 21:26:51 ubuntu kernel: [26639.163807] getty         D 00001835
 2808  2094      1 0x00000000
Aug 17 21:26:51 ubuntu kernel: [26639.163821]  eebb1e8c 00000046
c157ca70 00001835 c1042993 ee921754 c1689a00 00000046
Aug 17 21:26:51 ubuntu kernel: [26639.163842]  c1685eb8 c1689a00
ee921754 c1689a00 c1042993 00000007 ee9214c0 c13ee6c2
Aug 17 21:26:51 ubuntu kernel: [26639.163863]  c1350d16 00001835
ee9214c0 ee401004 00000002 eebb1e80 c104a803 00000000
Aug 17 21:26:51 ubuntu kernel: [26639.163883] Call Trace:
Aug 17 21:26:51 ubuntu kernel: [26639.163892]  [<c1042993>] ?
refrigerator+0x72/0xdb
Aug 17 21:26:51 ubuntu kernel: [26639.163902]  [<c1042993>] ?
refrigerator+0x72/0xdb
Aug 17 21:26:51 ubuntu kernel: [26639.163912]  [<c13ee6c2>] ?
_spin_unlock_irq+0x22/0x45
Aug 17 21:26:51 ubuntu kernel: [26639.163921]  [<c1350d16>] ?
tcp_sendpage+0x49/0x360
Aug 17 21:26:51 ubuntu kernel: [26639.163931]  [<c104a803>] ?
trace_hardirqs_on+0xb/0xd
Aug 17 21:26:51 ubuntu kernel: [26639.163941]  [<c10429e5>]
refrigerator+0xc4/0xdb
Aug 17 21:26:51 ubuntu kernel: [26639.163950]  [<c1035b74>]
try_to_freeze+0x19/0x20
Aug 17 21:26:51 ubuntu kernel: [26639.163959]  [<c10371f0>]
get_signal_to_deliver+0x36/0x32e
Aug 17 21:26:51 ubuntu kernel: [26639.163968]  [<c104a803>] ?
trace_hardirqs_on+0xb/0xd
Aug 17 21:26:51 ubuntu kernel: [26639.163978]  [<c1001fcd>]
do_notify_resume+0x77/0x735
Aug 17 21:26:51 ubuntu kernel: [26639.163988]  [<c11e7b62>] ?
n_tty_read+0x516/0x5b7
Aug 17 21:26:51 ubuntu kernel: [26639.163997]  [<c11e9d45>] ?
put_ldisc+0x7d/0x83
Aug 17 21:26:51 ubuntu kernel: [26639.164045]  [<c104a7d0>] ?
trace_hardirqs_on_caller+0x108/0x130
Aug 17 21:26:51 ubuntu kernel: [26639.164055]  [<c104a803>] ?
trace_hardirqs_on+0xb/0xd
Aug 17 21:26:51 ubuntu kernel: [26639.164064]  [<c11e9d53>] ?
tty_ldisc_deref+0x8/0xa
Aug 17 21:26:51 ubuntu kernel: [26639.164073]  [<c11e4037>] ? tty_read+0x72/0x9e
Aug 17 21:26:51 ubuntu kernel: [26639.164083]  [<c11e764c>] ?
n_tty_read+0x0/0x5b7
Aug 17 21:26:51 ubuntu kernel: [26639.164092]  [<c11e3fc5>] ? tty_read+0x0/0x9e
Aug 17 21:26:51 ubuntu kernel: [26639.164100]  [<c1094e62>] ? vfs_read+0x7d/0xdc
Aug 17 21:26:51 ubuntu kernel: [26639.164109]  [<c1094f6d>] ? sys_read+0x53/0x5d
Aug 17 21:26:51 ubuntu kernel: [26639.164119]  [<c1002d96>]
work_notifysig+0x13/0x19
Aug 17 21:26:51 ubuntu kernel: [26639.164127] getty         D 00001835
 2808  2096      1 0x00000000
Aug 17 21:26:51 ubuntu kernel: [26639.164141]  eea5be8c 00000046
c1581d52 00001835 c1042993 ee920294 c1689a00 00000046
Aug 17 21:26:51 ubuntu kernel: [26639.164162]  c1685eb8 c1689a00
ee920294 c1689a00 c1042993 00000007 ee920000 c13ee6c2
Aug 17 21:26:51 ubuntu kernel: [26639.164183]  c1352e7e 00001835
ee920000 ee400504 00000002 eea5be80 c104a803 00000000
Aug 17 21:26:51 ubuntu kernel: [26639.164203] Call Trace:
Aug 17 21:26:51 ubuntu kernel: [26639.164212]  [<c1042993>] ?
refrigerator+0x72/0xdb
Aug 17 21:26:51 ubuntu kernel: [26639.164222]  [<c1042993>] ?
refrigerator+0x72/0xdb
Aug 17 21:26:51 ubuntu kernel: [26639.164232]  [<c13ee6c2>] ?
_spin_unlock_irq+0x22/0x45
Aug 17 21:26:51 ubuntu kernel: [26639.164241]  [<c1352e7e>] ?
tcp_init_metrics+0x6f/0x207
Aug 17 21:26:51 ubuntu kernel: [26639.164251]  [<c104a803>] ?
trace_hardirqs_on+0xb/0xd
Aug 17 21:26:51 ubuntu kernel: [26639.164261]  [<c10429e5>]
refrigerator+0xc4/0xdb
Aug 17 21:26:51 ubuntu kernel: [26639.164270]  [<c1035b74>]
try_to_freeze+0x19/0x20
Aug 17 21:26:51 ubuntu kernel: [26639.164279]  [<c10371f0>]
get_signal_to_deliver+0x36/0x32e
Aug 17 21:26:51 ubuntu kernel: [26639.164289]  [<c104a803>] ?
trace_hardirqs_on+0xb/0xd
Aug 17 21:26:51 ubuntu kernel: [26639.164298]  [<c1001fcd>]
do_notify_resume+0x77/0x735
Aug 17 21:26:51 ubuntu kernel: [26639.164308]  [<c11e7b62>] ?
n_tty_read+0x516/0x5b7
Aug 17 21:26:51 ubuntu kernel: [26639.164318]  [<c11e9d45>] ?
put_ldisc+0x7d/0x83
Aug 17 21:26:52 ubuntu kernel: [26639.164327]  [<c104a7d0>] ?
trace_hardirqs_on_caller+0x108/0x130
Aug 17 21:26:52 ubuntu kernel: [26639.164337]  [<c104a803>] ?
trace_hardirqs_on+0xb/0xd
Aug 17 21:26:52 ubuntu kernel: [26639.164346]  [<c11e9d53>] ?
tty_ldisc_deref+0x8/0xa
Aug 17 21:26:52 ubuntu kernel: [26639.164355]  [<c11e4037>] ? tty_read+0x72/0x9e
Aug 17 21:26:52 ubuntu kernel: [26639.164364]  [<c11e764c>] ?
n_tty_read+0x0/0x5b7
Aug 17 21:26:52 ubuntu kernel: [26639.164373]  [<c11e3fc5>] ? tty_read+0x0/0x9e
Aug 17 21:26:52 ubuntu kernel: [26639.164382]  [<c1094e62>] ? vfs_read+0x7d/0xdc
Aug 17 21:26:52 ubuntu kernel: [26639.164391]  [<c1094f6d>] ? sys_read+0x53/0x5d
Aug 17 21:26:52 ubuntu kernel: [26639.164400]  [<c1002d96>]
work_notifysig+0x13/0x19
Aug 17 21:26:52 ubuntu kernel: [26639.164408] acpid         D 00001835
 2328  2119      1 0x00000000
Aug 17 21:26:52 ubuntu kernel: [26639.164421]  ed986e8c 00000046
c1588444 00001835 c1042993 ee200cf4 c1689a00 00000046
Aug 17 21:26:52 ubuntu kernel: [26639.164442]  c1685eb8 c1689a00
ee200cf4 c1689a00 c1042993 00000007 ee200a60 c13ee6c2
Aug 17 21:26:52 ubuntu kernel: [26639.164463]  c13553f6 00001835
ee200a60 eebf2084 00000002 ed986e80 c104a803 00000000
Aug 17 21:26:52 ubuntu kernel: [26639.164483] Call Trace:
Aug 17 21:26:52 ubuntu kernel: [26639.164492]  [<c1042993>] ?
refrigerator+0x72/0xdb
Aug 17 21:26:52 ubuntu kernel: [26639.164502]  [<c1042993>] ?
refrigerator+0x72/0xdb
Aug 17 21:26:52 ubuntu kernel: [26639.164512]  [<c13ee6c2>] ?
_spin_unlock_irq+0x22/0x45
Aug 17 21:26:52 ubuntu kernel: [26639.164521]  [<c13553f6>] ?
tcp_simple_retransmit+0x166/0x1d5
Aug 17 21:26:52 ubuntu kernel: [26639.164531]  [<c104a803>] ?
trace_hardirqs_on+0xb/0xd
Aug 17 21:26:52 ubuntu kernel: [26639.164541]  [<c10429e5>]
refrigerator+0xc4/0xdb
Aug 17 21:26:52 ubuntu kernel: [26639.164550]  [<c1035b74>]
try_to_freeze+0x19/0x20
Aug 17 21:26:52 ubuntu kernel: [26639.164559]  [<c10371f0>]
get_signal_to_deliver+0x36/0x32e
Aug 17 21:26:52 ubuntu kernel: [26639.164569]  [<c1001fcd>]
do_notify_resume+0x77/0x735
Aug 17 21:26:52 ubuntu kernel: [26639.164579]  [<c104bac2>] ?
__lock_acquire+0xad3/0xae2
Aug 17 21:26:52 ubuntu kernel: [26639.164588]  [<c104bac2>] ?
__lock_acquire+0xad3/0xae2
Aug 17 21:26:52 ubuntu kernel: [26639.164597]  [<c101dbe2>] ?
kunmap_atomic+0x64/0x7a
Aug 17 21:26:52 ubuntu kernel: [26639.164607]  [<c1034a12>] ?
sigprocmask+0x22/0xc1
Aug 17 21:26:52 ubuntu kernel: [26639.164617]  [<c1034a12>] ?
sigprocmask+0x22/0xc1
Aug 17 21:26:52 ubuntu kernel: [26639.164626]  [<c13ee6c2>] ?
_spin_unlock_irq+0x22/0x45
Aug 17 21:26:52 ubuntu kernel: [26639.164635]  [<c104a7d0>] ?
trace_hardirqs_on_caller+0x108/0x130
Aug 17 21:26:52 ubuntu kernel: [26639.164645]  [<c104a803>] ?
trace_hardirqs_on+0xb/0xd
Aug 17 21:26:52 ubuntu kernel: [26639.164654]  [<c13ee6d9>] ?
_spin_unlock_irq+0x39/0x45
Aug 17 21:26:52 ubuntu kernel: [26639.164664]  [<c10a0e1a>] ? sys_poll+0x42/0x8b
Aug 17 21:26:52 ubuntu kernel: [26639.164673]  [<c1002d96>]
work_notifysig+0x13/0x19
Aug 17 21:26:52 ubuntu kernel: [26639.164681] dd            D 00001835
 2652  2150      1 0x00000000
Aug 17 21:26:52 ubuntu kernel: [26639.164695]  eeb2fe8c 00000046
c158e739 00001835 c1042993 ee925594 c1689a00 00000046
Aug 17 21:26:52 ubuntu kernel: [26639.164715]  c1685eb8 c1689a00
ee925594 c1689a00 c1042993 00000007 ee925300 c13ee6c2
Aug 17 21:26:52 ubuntu kernel: [26639.164736]  c1357696 00001835
ee925300 ee400a84 00000002 eeb2fe80 c104a803 00000000
Aug 17 21:26:52 ubuntu kernel: [26639.164757] Call Trace:
Aug 17 21:26:52 ubuntu kernel: [26639.164766]  [<c1042993>] ?
refrigerator+0x72/0xdb
Aug 17 21:26:52 ubuntu kernel: [26639.164776]  [<c1042993>] ?
refrigerator+0x72/0xdb
Aug 17 21:26:52 ubuntu kernel: [26639.164785]  [<c13ee6c2>] ?
_spin_unlock_irq+0x22/0x45
Aug 17 21:26:52 ubuntu kernel: [26639.164795]  [<c1357696>] ?
tcp_rcv_established+0x2c2/0x4b2
Aug 17 21:26:52 ubuntu kernel: [26639.164805]  [<c104a803>] ?
trace_hardirqs_on+0xb/0xd
Aug 17 21:26:52 ubuntu kernel: [26639.164814]  [<c10429e5>]
refrigerator+0xc4/0xdb
Aug 17 21:26:52 ubuntu kernel: [26639.164824]  [<c1035b74>]
try_to_freeze+0x19/0x20
Aug 17 21:26:52 ubuntu kernel: [26639.164832]  [<c10371f0>]
get_signal_to_deliver+0x36/0x32e
Aug 17 21:26:52 ubuntu kernel: [26639.164855]  [<c1001fcd>]
do_notify_resume+0x77/0x735
Aug 17 21:26:52 ubuntu kernel: [26639.164872]  [<c10c91d5>] ?
pde_users_dec+0x11/0x33
Aug 17 21:26:52 ubuntu kernel: [26639.164888]  [<c10c91d5>] ?
pde_users_dec+0x11/0x33
Aug 17 21:26:52 ubuntu kernel: [26639.164903]  [<c1094538>] ?
fsnotify_access+0x4f/0x5a
Aug 17 21:26:52 ubuntu kernel: [26639.164916]  [<c10c9433>] ?
proc_reg_read+0x0/0x84
Aug 17 21:26:52 ubuntu kernel: [26639.164924]  [<c1094e82>] ? vfs_read+0x9d/0xdc
Aug 17 21:26:52 ubuntu kernel: [26639.164933]  [<c1094f6d>] ? sys_read+0x53/0x5d
Aug 17 21:26:52 ubuntu kernel: [26639.164943]  [<c1002d96>]
work_notifysig+0x13/0x19
Aug 17 21:26:52 ubuntu kernel: [26639.164951] rsyslogd      D 00001835
 2212  2152      1 0x00000000
Aug 17 21:26:52 ubuntu kernel: [26639.164964]  eeac1e8c 00000046
c159594f 00001835 c1042993 ee203674 c1689a00 00000046
Aug 17 21:26:52 ubuntu kernel: [26639.164985]  c1685eb8 c1689a00
ee203674 c1689a00 c1042993 00000007 ee2033e0 c13ee6c2
Aug 17 21:26:52 ubuntu kernel: [26639.165006]  c1357696 00001835
ee2033e0 eebf1584 00000002 eeac1e80 c104a803 00000000
Aug 17 21:26:52 ubuntu kernel: [26639.165026] Call Trace:
Aug 17 21:26:52 ubuntu kernel: [26639.165036]  [<c1042993>] ?
refrigerator+0x72/0xdb
Aug 17 21:26:52 ubuntu kernel: [26639.165045]  [<c1042993>] ?
refrigerator+0x72/0xdb
Aug 17 21:26:52 ubuntu kernel: [26639.165055]  [<c13ee6c2>] ?
_spin_unlock_irq+0x22/0x45
Aug 17 21:26:52 ubuntu kernel: [26639.165064]  [<c1357696>] ?
tcp_rcv_established+0x2c2/0x4b2
Aug 17 21:26:52 ubuntu kernel: [26639.165074]  [<c104a803>] ?
trace_hardirqs_on+0xb/0xd
Aug 17 21:26:52 ubuntu kernel: [26639.165084]  [<c10429e5>]
refrigerator+0xc4/0xdb
Aug 17 21:26:52 ubuntu kernel: [26639.165094]  [<c1035b74>]
try_to_freeze+0x19/0x20
Aug 17 21:26:52 ubuntu kernel: [26639.165102]  [<c10371f0>]
get_signal_to_deliver+0x36/0x32e
Aug 17 21:26:52 ubuntu kernel: [26639.165112]  [<c104bac2>] ?
__lock_acquire+0xad3/0xae2
Aug 17 21:26:52 ubuntu kernel: [26639.165121]  [<c104bac2>] ?
__lock_acquire+0xad3/0xae2
Aug 17 21:26:52 ubuntu kernel: [26639.165131]  [<c1001fcd>]
do_notify_resume+0x77/0x735
Aug 17 21:26:52 ubuntu kernel: [26639.165140]  [<c107e7e3>] ?
might_fault+0x4b/0x88
Aug 17 21:26:52 ubuntu kernel: [26639.165149]  [<c107e7e3>] ?
might_fault+0x4b/0x88
Aug 17 21:26:52 ubuntu kernel: [26639.165159]  [<c107e81e>] ?
might_fault+0x86/0x88
Aug 17 21:26:52 ubuntu kernel: [26639.165169]  [<c1187e37>] ?
copy_to_user+0x2f/0x106
Aug 17 21:26:53 ubuntu kernel: [26639.165179]  [<c109fcfb>] ?
poll_select_copy_remaining+0xa2/0xbe
Aug 17 21:26:53 ubuntu kernel: [26639.165189]  [<c10a0913>] ?
sys_select+0x7c/0x86
Aug 17 21:26:53 ubuntu kernel: [26639.165199]  [<c1002d96>]
work_notifysig+0x13/0x19
Aug 17 21:26:53 ubuntu kernel: [26639.165207] rsyslogd      D 00001835
 2024  2155      1 0x00000000
Aug 17 21:26:53 ubuntu kernel: [26639.165220]  edbbde8c 00000046
c159a113 00001835 c1042993 ee9274b4 c1689a00 00000046
Aug 17 21:26:53 ubuntu kernel: [26639.165241]  c1685eb8 c1689a00
ee9274b4 c1689a00 c1042993 00000007 ee927220 c13ee6c2
Aug 17 21:26:53 ubuntu kernel: [26639.165262]  c135c245 00001835
ee927220 eebf1584 00000002 edbbde80 c104a803 00000000
Aug 17 21:26:53 ubuntu kernel: [26639.165282] Call Trace:
Aug 17 21:26:53 ubuntu kernel: [26639.165291]  [<c1042993>] ?
refrigerator+0x72/0xdb
Aug 17 21:26:53 ubuntu kernel: [26639.165301]  [<c1042993>] ?
refrigerator+0x72/0xdb
Aug 17 21:26:53 ubuntu kernel: [26639.165311]  [<c13ee6c2>] ?
_spin_unlock_irq+0x22/0x45
Aug 17 21:26:53 ubuntu kernel: [26639.165321]  [<c135c245>] ?
tcp_v4_send_ack+0x117/0x16d
Aug 17 21:26:53 ubuntu kernel: [26639.165331]  [<c104a803>] ?
trace_hardirqs_on+0xb/0xd
Aug 17 21:26:53 ubuntu kernel: [26639.165340]  [<c10429e5>]
refrigerator+0xc4/0xdb
Aug 17 21:26:53 ubuntu kernel: [26639.165350]  [<c1035b74>]
try_to_freeze+0x19/0x20
Aug 17 21:26:53 ubuntu kernel: [26639.165359]  [<c10371f0>]
get_signal_to_deliver+0x36/0x32e
Aug 17 21:26:53 ubuntu kernel: [26639.165369]  [<c1001fcd>]
do_notify_resume+0x77/0x735
Aug 17 21:26:53 ubuntu kernel: [26639.165378]  [<c13ee6c2>] ?
_spin_unlock_irq+0x22/0x45
Aug 17 21:26:53 ubuntu kernel: [26639.165388]  [<c104a7d0>] ?
trace_hardirqs_on_caller+0x108/0x130
Aug 17 21:26:53 ubuntu kernel: [26639.165398]  [<c13ee6d9>] ?
_spin_unlock_irq+0x39/0x45
Aug 17 21:26:53 ubuntu kernel: [26639.165408]  [<c10242ea>] ?
finish_task_switch+0x65/0x9b
Aug 17 21:26:53 ubuntu kernel: [26639.165417]  [<c10242b1>] ?
finish_task_switch+0x2c/0x9b
Aug 17 21:26:53 ubuntu kernel: [26639.165427]  [<c1020716>] ?
need_resched+0x14/0x1e
Aug 17 21:26:53 ubuntu kernel: [26639.165436]  [<c13eceba>] ?
schedule+0x777/0x795
Aug 17 21:26:53 ubuntu kernel: [26639.165446]  [<c10a0913>] ?
sys_select+0x7c/0x86
Aug 17 21:26:53 ubuntu kernel: [26639.165456]  [<c1002d96>]
work_notifysig+0x13/0x19
Aug 17 21:26:53 ubuntu kernel: [26639.165464] rsyslogd      D 00001835
 2656  2156      1 0x00000000
Aug 17 21:26:53 ubuntu kernel: [26639.165477]  edbbce8c 00000046
c159e6c7 00001835 c1042993 ee924b34 c1689a00 00000046
Aug 17 21:26:53 ubuntu kernel: [26639.165498]  c1685eb8 c1689a00
ee924b34 c1689a00 c1042993 00000007 ee9248a0 c13ee6c2
Aug 17 21:26:53 ubuntu kernel: [26639.165519]  c1360f08 00001835
ee9248a0 eebf1584 00000002 edbbce80 c104a803 00000000
Aug 17 21:26:53 ubuntu kernel: [26639.165539] Call Trace:
Aug 17 21:26:53 ubuntu kernel: [26639.165549]  [<c1042993>] ?
refrigerator+0x72/0xdb
Aug 17 21:26:53 ubuntu kernel: [26639.165558]  [<c1042993>] ?
refrigerator+0x72/0xdb
Aug 17 21:26:53 ubuntu kernel: [26639.165568]  [<c13ee6c2>] ?
_spin_unlock_irq+0x22/0x45
Aug 17 21:26:53 ubuntu kernel: [26639.165577]  [<c1360f08>] ?
raw_seq_show+0xad/0xc0
Aug 17 21:26:53 ubuntu kernel: [26639.165587]  [<c104a803>] ?
trace_hardirqs_on+0xb/0xd
Aug 17 21:26:53 ubuntu kernel: [26639.165596]  [<c10429e5>]
refrigerator+0xc4/0xdb
Aug 17 21:26:53 ubuntu kernel: [26639.165606]  [<c1035b74>]
try_to_freeze+0x19/0x20
Aug 17 21:26:53 ubuntu kernel: [26639.165614]  [<c10371f0>]
get_signal_to_deliver+0x36/0x32e
Aug 17 21:26:53 ubuntu kernel: [26639.165624]  [<c1001fcd>]
do_notify_resume+0x77/0x735
Aug 17 21:26:53 ubuntu kernel: [26639.165634]  [<c1157a57>] ?
file_has_perm+0x87/0xa1
Aug 17 21:26:53 ubuntu kernel: [26639.165645]  [<c103ccb5>] ?
autoremove_wake_function+0x0/0x2f
Aug 17 21:26:53 ubuntu kernel: [26639.165655]  [<c1157ce4>] ?
selinux_file_permission+0x44/0x48
Aug 17 21:26:53 ubuntu kernel: [26639.165666]  [<c1154346>] ?
security_file_permission+0xf/0x11
Aug 17 21:26:53 ubuntu kernel: [26639.165675]  [<c109490a>] ?
rw_verify_area+0x98/0xbb
Aug 17 21:26:53 ubuntu kernel: [26639.165684]  [<c109478e>] ?
do_sync_read+0x0/0xe4
Aug 17 21:26:53 ubuntu kernel: [26639.165693]  [<c1094e62>] ? vfs_read+0x7d/0xdc
Aug 17 21:26:53 ubuntu kernel: [26639.165701]  [<c1094463>] ? fput_light+0xc/0xe
Aug 17 21:26:53 ubuntu kernel: [26639.165710]  [<c1094f6d>] ? sys_read+0x53/0x5d
Aug 17 21:26:53 ubuntu kernel: [26639.165719]  [<c1002d96>]
work_notifysig+0x13/0x19
Aug 17 21:26:53 ubuntu kernel: [26639.165727] rsyslogd      D 00001835
 2320 11083      1 0x00000000
Aug 17 21:26:53 ubuntu kernel: [26639.165741]  eeca7e8c 00000046
c1729e97 00001835 c1042993 c79021b4 c1689a00 00000046
Aug 17 21:26:53 ubuntu kernel: [26639.165761]  c1685eb8 c1689a00
c79021b4 c1689a00 c1042993 00000007 c7901f20 c13ee6c2
Aug 17 21:26:53 ubuntu kernel: [26639.165782]  c143073a 00001835
c7901f20 eebf1584 00000002 eeca7e80 c104a803 00000000
Aug 17 21:26:53 ubuntu kernel: [26639.165802] Call Trace:
Aug 17 21:26:53 ubuntu kernel: [26639.165812]  [<c1042993>] ?
refrigerator+0x72/0xdb
Aug 17 21:26:53 ubuntu kernel: [26639.165821]  [<c1042993>] ?
refrigerator+0x72/0xdb
Aug 17 21:26:53 ubuntu kernel: [26639.165831]  [<c13ee6c2>] ?
_spin_unlock_irq+0x22/0x45
Aug 17 21:26:53 ubuntu kernel: [26639.165841]  [<c104a803>] ?
trace_hardirqs_on+0xb/0xd
Aug 17 21:26:53 ubuntu kernel: [26639.165851]  [<c10429e5>]
refrigerator+0xc4/0xdb
Aug 17 21:26:53 ubuntu kernel: [26639.165860]  [<c1035b74>]
try_to_freeze+0x19/0x20
Aug 17 21:26:53 ubuntu kernel: [26639.165869]  [<c10371f0>]
get_signal_to_deliver+0x36/0x32e
Aug 17 21:26:53 ubuntu kernel: [26639.165879]  [<c1001fcd>]
do_notify_resume+0x77/0x735
Aug 17 21:26:53 ubuntu kernel: [26639.165889]  [<c107e7e3>] ?
might_fault+0x4b/0x88
Aug 17 21:26:53 ubuntu kernel: [26639.165899]  [<c1043079>] ?
clocksource_read+0x9/0xc
Aug 17 21:26:53 ubuntu kernel: [26639.165908]  [<c1043382>] ?
getnstimeofday+0x4d/0xd7
Aug 17 21:26:53 ubuntu kernel: [26639.165918]  [<c103fd87>] ?
ktime_get_ts+0x40/0x44
Aug 17 21:26:54 ubuntu kernel: [26639.165928]  [<c104f07c>] ?
sys_futex+0xe1/0xf5
Aug 17 21:26:54 ubuntu kernel: [26639.165940]  [<c1002bfa>] ?
sysenter_exit+0xf/0x1a
Aug 17 21:26:54 ubuntu kernel: [26639.165949]  [<c1002d96>]
work_notifysig+0x13/0x19
Aug 17 21:26:54 ubuntu kernel: [26639.165957] dbus-daemon   D 00001835
 1888  2191      1 0x00000000
Aug 17 21:26:54 ubuntu kernel: [26639.165970]  ed4b8e8c 00000046
c15c1e1e 00001835 c1042993 ee920cf4 c1689a00 00000046
Aug 17 21:26:54 ubuntu kernel: [26639.165991]  c1685eb8 c1689a00
ee920cf4 c1689a00 c1042993 00000007 ee920a60 c13ee6c2
Aug 17 21:26:54 ubuntu kernel: [26639.166012]  c13632db 00001835
ee920a60 ee404704 00000002 ed4b8e80 c104a803 00000000
Aug 17 21:26:54 ubuntu kernel: [26639.166032] Call Trace:
Aug 17 21:26:54 ubuntu kernel: [26639.166041]  [<c1042993>] ?
refrigerator+0x72/0xdb
Aug 17 21:26:54 ubuntu kernel: [26639.166051]  [<c1042993>] ?
refrigerator+0x72/0xdb
Aug 17 21:26:54 ubuntu kernel: [26639.166061]  [<c13ee6c2>] ?
_spin_unlock_irq+0x22/0x45
Aug 17 21:26:54 ubuntu kernel: [26639.166070]  [<c13632db>] ?
udp_sendmsg+0x5a/0x5a0
Aug 17 21:26:54 ubuntu kernel: [26639.166079]  [<c104a803>] ?
trace_hardirqs_on+0xb/0xd
Aug 17 21:26:54 ubuntu kernel: [26639.166089]  [<c10429e5>]
refrigerator+0xc4/0xdb
Aug 17 21:26:54 ubuntu kernel: [26639.166098]  [<c1035b74>]
try_to_freeze+0x19/0x20
Aug 17 21:26:54 ubuntu kernel: [26639.166107]  [<c10371f0>]
get_signal_to_deliver+0x36/0x32e
Aug 17 21:26:54 ubuntu kernel: [26639.166117]  [<c1001fcd>]
do_notify_resume+0x77/0x735
Aug 17 21:26:54 ubuntu kernel: [26639.166130]  [<c107e81e>] ?
might_fault+0x86/0x88
Aug 17 21:26:54 ubuntu kernel: [26639.166139]  [<c10a0e1a>] ? sys_poll+0x42/0x8b
Aug 17 21:26:54 ubuntu kernel: [26639.166149]  [<c1002d96>]
work_notifysig+0x13/0x19
Aug 17 21:26:54 ubuntu kernel: [26639.166157] winbindd      D 00001835
 2024  2231      1 0x00000000
Aug 17 21:26:54 ubuntu kernel: [26639.166170]  ecec4e8c 00000046
c15cbe54 00001835 c1042993 ee2074b4 c1689a00 00000046
Aug 17 21:26:54 ubuntu kernel: [26639.166190]  c1685eb8 c1689a00
ee2074b4 c1689a00 c1042993 00000007 ee207220 c13ee6c2
Aug 17 21:26:54 ubuntu kernel: [26639.166211]  c13655f4 00001835
ee207220 eebf0504 00000002 ecec4e80 c104a803 00000000
Aug 17 21:26:54 ubuntu kernel: [26639.166231] Call Trace:
Aug 17 21:26:54 ubuntu kernel: [26639.166241]  [<c1042993>] ?
refrigerator+0x72/0xdb
Aug 17 21:26:54 ubuntu kernel: [26639.166251]  [<c1042993>] ?
refrigerator+0x72/0xdb
Aug 17 21:26:54 ubuntu kernel: [26639.166260]  [<c13ee6c2>] ?
_spin_unlock_irq+0x22/0x45
Aug 17 21:26:54 ubuntu kernel: [26639.166269]  [<c13655f4>] ?
icmp_reply+0x15f/0x179
Aug 17 21:26:54 ubuntu kernel: [26639.166279]  [<c104a803>] ?
trace_hardirqs_on+0xb/0xd
Aug 17 21:26:54 ubuntu kernel: [26639.166289]  [<c10429e5>]
refrigerator+0xc4/0xdb
Aug 17 21:26:54 ubuntu kernel: [26639.166298]  [<c1035b74>]
try_to_freeze+0x19/0x20
Aug 17 21:26:54 ubuntu kernel: [26639.166307]  [<c10371f0>]
get_signal_to_deliver+0x36/0x32e
Aug 17 21:26:54 ubuntu kernel: [26639.166316]  [<c104bac2>] ?
__lock_acquire+0xad3/0xae2
Aug 17 21:26:54 ubuntu kernel: [26639.166326]  [<c1001fcd>]
do_notify_resume+0x77/0x735
Aug 17 21:26:54 ubuntu kernel: [26639.166335]  [<c107e7e3>] ?
might_fault+0x4b/0x88
Aug 17 21:26:54 ubuntu kernel: [26639.166345]  [<c107e7e3>] ?
might_fault+0x4b/0x88
Aug 17 21:26:54 ubuntu kernel: [26639.166354]  [<c107e81e>] ?
might_fault+0x86/0x88
Aug 17 21:26:54 ubuntu kernel: [26639.166363]  [<c1187e37>] ?
copy_to_user+0x2f/0x106
Aug 17 21:26:54 ubuntu kernel: [26639.166373]  [<c109fcfb>] ?
poll_select_copy_remaining+0xa2/0xbe
Aug 17 21:26:54 ubuntu kernel: [26639.166383]  [<c10a0913>] ?
sys_select+0x7c/0x86
Aug 17 21:26:54 ubuntu kernel: [26639.166393]  [<c1002d96>]
work_notifysig+0x13/0x19
Aug 17 21:26:54 ubuntu kernel: [26639.166401] winbindd      D 00001835
 2024  2237   2231 0x00000000
Aug 17 21:26:54 ubuntu kernel: [26639.166414]  ecf7fe8c 00000046
c15d18d1 00001835 c1042993 eea7cb34 c1689a00 00000046
Aug 17 21:26:54 ubuntu kernel: [26639.166435]  c1685eb8 c1689a00
eea7cb34 c1689a00 c1042993 00000007 eea7c8a0 c13ee6c2
Aug 17 21:26:54 ubuntu kernel: [26639.166455]  c13655f4 00001835
eea7c8a0 ee401b04 00000002 ecf7fe80 c104a803 00000000
Aug 17 21:26:54 ubuntu kernel: [26639.166476] Call Trace:
Aug 17 21:26:54 ubuntu kernel: [26639.166485]  [<c1042993>] ?
refrigerator+0x72/0xdb
Aug 17 21:26:54 ubuntu kernel: [26639.166495]  [<c1042993>] ?
refrigerator+0x72/0xdb
Aug 17 21:26:54 ubuntu kernel: [26639.166504]  [<c13ee6c2>] ?
_spin_unlock_irq+0x22/0x45
Aug 17 21:26:54 ubuntu kernel: [26639.166514]  [<c13655f4>] ?
icmp_reply+0x15f/0x179
Aug 17 21:26:54 ubuntu kernel: [26639.166523]  [<c104a803>] ?
trace_hardirqs_on+0xb/0xd
Aug 17 21:26:54 ubuntu kernel: [26639.166533]  [<c10429e5>]
refrigerator+0xc4/0xdb
Aug 17 21:26:54 ubuntu kernel: [26639.166542]  [<c1035b74>]
try_to_freeze+0x19/0x20
Aug 17 21:26:54 ubuntu kernel: [26639.166551]  [<c10371f0>]
get_signal_to_deliver+0x36/0x32e
Aug 17 21:26:54 ubuntu kernel: [26639.166560]  [<c107e7e3>] ?
might_fault+0x4b/0x88
Aug 17 21:26:54 ubuntu kernel: [26639.166570]  [<c1001fcd>]
do_notify_resume+0x77/0x735
Aug 17 21:26:54 ubuntu kernel: [26639.166579]  [<c104bac2>] ?
__lock_acquire+0xad3/0xae2
Aug 17 21:26:54 ubuntu kernel: [26639.166588]  [<c1094592>] ?
fsnotify_modify+0x4f/0x5a
Aug 17 21:26:54 ubuntu kernel: [26639.166598]  [<c107e7e3>] ?
might_fault+0x4b/0x88
Aug 17 21:26:54 ubuntu kernel: [26639.166608]  [<c107e7e3>] ?
might_fault+0x4b/0x88
Aug 17 21:26:54 ubuntu kernel: [26639.166618]  [<c10a0913>] ?
sys_select+0x7c/0x86
Aug 17 21:26:54 ubuntu kernel: [26639.166628]  [<c1002d96>]
work_notifysig+0x13/0x19
Aug 17 21:26:54 ubuntu kernel: [26639.166635] console-kit-d D 00001835
 2080  2258      1 0x00000000
Aug 17 21:26:54 ubuntu kernel: [26639.166648]  eca66e8c 00000046
c15d844a 00001835 c1042993 eea7c0d4 c1689a00 00000046
Aug 17 21:26:54 ubuntu kernel: [26639.166669]  c1685eb8 c1689a00
eea7c0d4 c1689a00 c1042993 00000007 eea7be40 c13ee6c2
Aug 17 21:26:54 ubuntu kernel: [26639.166690]  c13655f4 00001835
eea7be40 ee404c84 00000002 eca66e80 c104a803 00000000
Aug 17 21:26:54 ubuntu kernel: [26639.166710] Call Trace:
Aug 17 21:26:54 ubuntu kernel: [26639.166720]  [<c1042993>] ?
refrigerator+0x72/0xdb
Aug 17 21:26:54 ubuntu kernel: [26639.166729]  [<c1042993>] ?
refrigerator+0x72/0xdb
Aug 17 21:26:54 ubuntu kernel: [26639.166739]  [<c13ee6c2>] ?
_spin_unlock_irq+0x22/0x45
Aug 17 21:26:54 ubuntu kernel: [26639.166748]  [<c13655f4>] ?
icmp_reply+0x15f/0x179
Aug 17 21:26:54 ubuntu kernel: [26639.166758]  [<c104a803>] ?
trace_hardirqs_on+0xb/0xd
Aug 17 21:26:54 ubuntu kernel: [26639.166767]  [<c10429e5>]
refrigerator+0xc4/0xdb
Aug 17 21:26:54 ubuntu kernel: [26639.166777]  [<c1035b74>]
try_to_freeze+0x19/0x20
Aug 17 21:26:54 ubuntu kernel: [26639.166786]  [<c10371f0>]
get_signal_to_deliver+0x36/0x32e
Aug 17 21:26:54 ubuntu kernel: [26639.166796]  [<c1001fcd>]
do_notify_resume+0x77/0x735
Aug 17 21:26:54 ubuntu kernel: [26639.166805]  [<c1157a57>] ?
file_has_perm+0x87/0xa1
Aug 17 21:26:54 ubuntu kernel: [26639.166816]  [<c103ccb5>] ?
autoremove_wake_function+0x0/0x2f
Aug 17 21:26:54 ubuntu kernel: [26639.166827]  [<c1157ce4>] ?
selinux_file_permission+0x44/0x48
Aug 17 21:26:54 ubuntu kernel: [26639.166836]  [<c1154346>] ?
security_file_permission+0xf/0x11
Aug 17 21:26:54 ubuntu kernel: [26639.166845]  [<c109490a>] ?
rw_verify_area+0x98/0xbb
Aug 17 21:26:54 ubuntu kernel: [26639.166855]  [<c1094e70>] ? vfs_read+0x8b/0xdc
Aug 17 21:26:54 ubuntu kernel: [26639.166864]  [<c10a0e1a>] ? sys_poll+0x42/0x8b
Aug 17 21:26:54 ubuntu kernel: [26639.166873]  [<c1002d96>]
work_notifysig+0x13/0x19
Aug 17 21:26:54 ubuntu kernel: [26639.166881] console-kit-d D 00001835
 2320  2259      1 0x00000000
Aug 17 21:26:54 ubuntu kernel: [26639.166895]  eceb3e8c 00000046
c15db89b 00001835 c1042993 eea7b674 c1689a00 00000046
Aug 17 21:26:54 ubuntu kernel: [26639.166916]  c1685eb8 c1689a00
eea7b674 c1689a00 c1042993 00000007 eea7b3e0 c13ee6c2
Aug 17 21:26:55 ubuntu kernel: [26639.166936]  c13d29f9 00001835
eea7b3e0 ee404c84 00000002 eceb3e80 c104a803 00000000
Aug 17 21:26:55 ubuntu kernel: [26639.166957] Call Trace:
Aug 17 21:26:55 ubuntu kernel: [26639.166966]  [<c1042993>] ?
refrigerator+0x72/0xdb
Aug 17 21:26:55 ubuntu kernel: [26639.166976]  [<c1042993>] ?
refrigerator+0x72/0xdb
Aug 17 21:26:55 ubuntu kernel: [26639.166985]  [<c13ee6c2>] ?
_spin_unlock_irq+0x22/0x45
Aug 17 21:26:55 ubuntu kernel: [26639.166994]  [<c13d29f9>] ?
__ieee80211_rx+0x522/0x525
Aug 17 21:26:55 ubuntu kernel: [26639.167004]  [<c104a803>] ?
trace_hardirqs_on+0xb/0xd
Aug 17 21:26:55 ubuntu kernel: [26639.167014]  [<c10429e5>]
refrigerator+0xc4/0xdb
Aug 17 21:26:55 ubuntu kernel: [26639.167024]  [<c1035b74>]
try_to_freeze+0x19/0x20
Aug 17 21:26:55 ubuntu kernel: [26639.167032]  [<c10371f0>]
get_signal_to_deliver+0x36/0x32e
Aug 17 21:26:55 ubuntu kernel: [26639.167042]  [<c1001fcd>]
do_notify_resume+0x77/0x735
Aug 17 21:26:55 ubuntu kernel: [26639.167052]  [<c1157a57>] ?
file_has_perm+0x87/0xa1
Aug 17 21:26:55 ubuntu kernel: [26639.167063]  [<c103ccb5>] ?
autoremove_wake_function+0x0/0x2f
Aug 17 21:26:55 ubuntu kernel: [26639.167073]  [<c1094592>] ?
fsnotify_modify+0x4f/0x5a
Aug 17 21:26:55 ubuntu kernel: [26639.167083]  [<c104f07c>] ?
sys_futex+0xe1/0xf5
Aug 17 21:26:55 ubuntu kernel: [26639.167092]  [<c1002bfa>] ?
sysenter_exit+0xf/0x1a
Aug 17 21:26:55 ubuntu kernel: [26639.167102]  [<c104a7d0>] ?
trace_hardirqs_on_caller+0x108/0x130
Aug 17 21:26:55 ubuntu kernel: [26639.167112]  [<c1002d96>]
work_notifysig+0x13/0x19
Aug 17 21:26:55 ubuntu kernel: [26639.167119] console-kit-d D 00001835
 2824  2261      1 0x00000000
Aug 17 21:26:55 ubuntu kernel: [26639.167133]  eceb6e8c 00000046
c172489a 00001835 c1042993 eea7a1b4 c1689a00 00000046
Aug 17 21:26:55 ubuntu kernel: [26639.167154]  c1685eb8 c1689a00
eea7a1b4 c1689a00 c1042993 00000007 eea79f20 c13ee6c2
Aug 17 21:26:55 ubuntu kernel: [26639.167174]  c17219f7 00001835
eea79f20 ee404c84 00000002 eceb6e80 c104a803 00000000
Aug 17 21:26:55 ubuntu kernel: [26639.167195] Call Trace:
Aug 17 21:26:55 ubuntu kernel: [26639.167204]  [<c1042993>] ?
refrigerator+0x72/0xdb
Aug 17 21:26:55 ubuntu kernel: [26639.167214]  [<c1042993>] ?
refrigerator+0x72/0xdb
Aug 17 21:26:55 ubuntu kernel: [26639.167223]  [<c13ee6c2>] ?
_spin_unlock_irq+0x22/0x45
Aug 17 21:26:55 ubuntu kernel: [26639.167233]  [<c104a803>] ?
trace_hardirqs_on+0xb/0xd
Aug 17 21:26:55 ubuntu kernel: [26639.167243]  [<c10429e5>]
refrigerator+0xc4/0xdb
Aug 17 21:26:55 ubuntu kernel: [26639.167252]  [<c1035b74>]
try_to_freeze+0x19/0x20
Aug 17 21:26:55 ubuntu kernel: [26639.167261]  [<c10371f0>]
get_signal_to_deliver+0x36/0x32e
Aug 17 21:26:55 ubuntu kernel: [26639.167271]  [<c1001fcd>]
do_notify_resume+0x77/0x735
Aug 17 21:26:55 ubuntu kernel: [26639.167282]  [<c11e5350>] ?
tty_ioctl+0x0/0x750
Aug 17 21:26:55 ubuntu kernel: [26639.167291]  [<c109ee36>] ?
vfs_ioctl+0x18/0x71
Aug 17 21:26:55 ubuntu kernel: [26639.167300]  [<c109f3af>] ?
do_vfs_ioctl+0x481/0x4bf
Aug 17 21:26:55 ubuntu kernel: [26639.167312]  [<c1157c9d>] ?
selinux_file_ioctl+0x3e/0x41
Aug 17 21:26:55 ubuntu kernel: [26639.167321]  [<c109f441>] ?
sys_ioctl+0x54/0x61
Aug 17 21:26:55 ubuntu kernel: [26639.167331]  [<c1002d96>]
work_notifysig+0x13/0x19
Aug 17 21:26:55 ubuntu kernel: [26639.167381] console-kit-d D 00001835
 2824  2262      1 0x00000000
Aug 17 21:26:55 ubuntu kernel: [26639.167396]  ecaa2e8c 00000046
c1720330 00001835 c1042993 eea78cf4 c1689a00 00000046
Aug 17 21:26:55 ubuntu kernel: [26639.167417]  c1685eb8 c1689a00
eea78cf4 c1689a00 c1042993 00000007 eea78a60 c13ee6c2
Aug 17 21:26:55 ubuntu kernel: [26639.167437]  c15574c2 00001835
eea78a60 ee404c84 00000002 ecaa2e80 c104a803 00000000
Aug 17 21:26:55 ubuntu kernel: [26639.167458] Call Trace:
Aug 17 21:26:55 ubuntu kernel: [26639.167468]  [<c1042993>] ?
refrigerator+0x72/0xdb
Aug 17 21:26:55 ubuntu kernel: [26639.167478]  [<c1042993>] ?
refrigerator+0x72/0xdb
Aug 17 21:26:55 ubuntu kernel: [26639.167487]  [<c13ee6c2>] ?
_spin_unlock_irq+0x22/0x45
Aug 17 21:26:55 ubuntu kernel: [26639.167497]  [<c104a803>] ?
trace_hardirqs_on+0xb/0xd
Aug 17 21:26:55 ubuntu kernel: [26639.167507]  [<c10429e5>]
refrigerator+0xc4/0xdb
Aug 17 21:26:55 ubuntu kernel: [26639.167517]  [<c1035b74>]
try_to_freeze+0x19/0x20
Aug 17 21:26:55 ubuntu kernel: [26639.167525]  [<c10371f0>]
get_signal_to_deliver+0x36/0x32e
Aug 17 21:26:55 ubuntu kernel: [26639.167535]  [<c1001fcd>]
do_notify_resume+0x77/0x735
Aug 17 21:26:55 ubuntu kernel: [26639.167546]  [<c11e5350>] ?
tty_ioctl+0x0/0x750
Aug 17 21:26:55 ubuntu kernel: [26639.167555]  [<c109ee36>] ?
vfs_ioctl+0x18/0x71
Aug 17 21:26:55 ubuntu kernel: [26639.167564]  [<c109f3af>] ?
do_vfs_ioctl+0x481/0x4bf
Aug 17 21:26:55 ubuntu kernel: [26639.167576]  [<c1157c9d>] ?
selinux_file_ioctl+0x3e/0x41
Aug 17 21:26:55 ubuntu kernel: [26639.167585]  [<c109f441>] ?
sys_ioctl+0x54/0x61
Aug 17 21:26:55 ubuntu kernel: [26639.167595]  [<c1002d96>]
work_notifysig+0x13/0x19
Aug 17 21:26:55 ubuntu kernel: [26639.167602] console-kit-d D 00001835
 2824  2263      1 0x00000000
Aug 17 21:26:55 ubuntu kernel: [26639.167616]  ecaa1e8c 00000046
c1853865 00001835 c1042993 eea79754 c1689a00 00000400
Aug 17 21:26:55 ubuntu kernel: [26639.167637]  c1685eb8 c1689a00
eea79754 c1689a00 c13f6b10 00787ac3 c2c99eb8 00000001
Aug 17 21:26:55 ubuntu kernel: [26639.167657]  c1853865 00001835
eea794c0 00000078 00000000 00000000 00000400 00000000
Aug 17 21:26:55 ubuntu kernel: [26639.167678] Call Trace:
Aug 17 21:26:55 ubuntu kernel: [26639.167687]  [<c1042993>] ?
refrigerator+0x72/0xdb
Aug 17 21:26:55 ubuntu kernel: [26639.167699]  [<c10429e5>]
refrigerator+0xc4/0xdb
Aug 17 21:26:55 ubuntu kernel: [26639.167708]  [<c1035b74>]
try_to_freeze+0x19/0x20
Aug 17 21:26:55 ubuntu kernel: [26639.167717]  [<c10371f0>]
get_signal_to_deliver+0x36/0x32e
Aug 17 21:26:55 ubuntu kernel: [26639.167727]  [<c1001fcd>]
do_notify_resume+0x77/0x735
Aug 17 21:26:55 ubuntu kernel: [26639.167737]  [<c11e5350>] ?
tty_ioctl+0x0/0x750
Aug 17 21:26:55 ubuntu kernel: [26639.167746]  [<c109ee36>] ?
vfs_ioctl+0x18/0x71
Aug 17 21:26:55 ubuntu kernel: [26639.167755]  [<c109f3af>] ?
do_vfs_ioctl+0x481/0x4bf
Aug 17 21:26:55 ubuntu kernel: [26639.167767]  [<c1157c9d>] ?
selinux_file_ioctl+0x3e/0x41
Aug 17 21:26:55 ubuntu kernel: [26639.167776]  [<c109f441>] ?
sys_ioctl+0x54/0x61
Aug 17 21:26:55 ubuntu kernel: [26639.167786]  [<c1002d96>]
work_notifysig+0x13/0x19
Aug 17 21:26:55 ubuntu kernel: [26639.167793] console-kit-d D 00001835
 2824  2264      1 0x00000000
Aug 17 21:26:55 ubuntu kernel: [26639.167807]  ecaa0e8c 00000046
c184cc02 00001835 c1042993 eea78294 c1689a00 00000046
Aug 17 21:26:55 ubuntu kernel: [26639.167828]  c1685eb8 c1689a00
eea78294 c1689a00 c1042993 00000007 eea78000 c13ee6c2
Aug 17 21:26:55 ubuntu kernel: [26639.167849]  c184a7d5 00001835
eea78000 ee404c84 00000002 ecaa0e80 c104a803 00000000
Aug 17 21:26:55 ubuntu kernel: [26639.167869] Call Trace:
Aug 17 21:26:55 ubuntu kernel: [26639.167878]  [<c1042993>] ?
refrigerator+0x72/0xdb
Aug 17 21:26:55 ubuntu kernel: [26639.167888]  [<c1042993>] ?
refrigerator+0x72/0xdb
Aug 17 21:26:55 ubuntu kernel: [26639.167897]  [<c13ee6c2>] ?
_spin_unlock_irq+0x22/0x45
Aug 17 21:26:55 ubuntu kernel: [26639.167907]  [<c104a803>] ?
trace_hardirqs_on+0xb/0xd
Aug 17 21:26:55 ubuntu kernel: [26639.167917]  [<c10429e5>]
refrigerator+0xc4/0xdb
Aug 17 21:26:55 ubuntu kernel: [26639.167927]  [<c1035b74>]
try_to_freeze+0x19/0x20
Aug 17 21:26:55 ubuntu kernel: [26639.167935]  [<c10371f0>]
get_signal_to_deliver+0x36/0x32e
Aug 17 21:26:55 ubuntu kernel: [26639.167945]  [<c1001fcd>]
do_notify_resume+0x77/0x735
Aug 17 21:26:55 ubuntu kernel: [26639.167956]  [<c11e5350>] ?
tty_ioctl+0x0/0x750
Aug 17 21:26:55 ubuntu kernel: [26639.167965]  [<c109ee36>] ?
vfs_ioctl+0x18/0x71
Aug 17 21:26:55 ubuntu kernel: [26639.167974]  [<c109f3af>] ?
do_vfs_ioctl+0x481/0x4bf
Aug 17 21:26:55 ubuntu kernel: [26639.167986]  [<c1157c9d>] ?
selinux_file_ioctl+0x3e/0x41
Aug 17 21:26:55 ubuntu kernel: [26639.167995]  [<c109f441>] ?
sys_ioctl+0x54/0x61
Aug 17 21:26:55 ubuntu kernel: [26639.168004]  [<c1002d96>]
work_notifysig+0x13/0x19
Aug 17 21:26:55 ubuntu kernel: [26639.168012] console-kit-d D 00001835
 2824  2265      1 0x00000000
Aug 17 21:26:55 ubuntu kernel: [26639.168026]  eca9fe8c 00000046
c184863d 00001835 c1042993 eea7f4b4 c1689a00 00000046
Aug 17 21:26:55 ubuntu kernel: [26639.168047]  c1685eb8 c1689a00
eea7f4b4 c1689a00 c1042993 00000007 eea7f220 c13ee6c2
Aug 17 21:26:55 ubuntu kernel: [26639.168067]  c1846342 00001835
eea7f220 ee404c84 00000002 eca9fe80 c104a803 00000000
Aug 17 21:26:55 ubuntu kernel: [26639.168088] Call Trace:
Aug 17 21:26:55 ubuntu kernel: [26639.168097]  [<c1042993>] ?
refrigerator+0x72/0xdb
Aug 17 21:26:55 ubuntu kernel: [26639.168107]  [<c1042993>] ?
refrigerator+0x72/0xdb
Aug 17 21:26:55 ubuntu kernel: [26639.168116]  [<c13ee6c2>] ?
_spin_unlock_irq+0x22/0x45
Aug 17 21:26:55 ubuntu kernel: [26639.168126]  [<c104a803>] ?
trace_hardirqs_on+0xb/0xd
Aug 17 21:26:55 ubuntu kernel: [26639.168136]  [<c10429e5>]
refrigerator+0xc4/0xdb
Aug 17 21:26:55 ubuntu kernel: [26639.168145]  [<c1035b74>]
try_to_freeze+0x19/0x20
Aug 17 21:26:55 ubuntu kernel: [26639.168154]  [<c10371f0>]
get_signal_to_deliver+0x36/0x32e
Aug 17 21:26:55 ubuntu kernel: [26639.168164]  [<c1001fcd>]
do_notify_resume+0x77/0x735
Aug 17 21:26:55 ubuntu kernel: [26639.168187]  [<c11e5350>] ?
tty_ioctl+0x0/0x750
Aug 17 21:26:55 ubuntu kernel: [26639.168200]  [<c109ee36>] ?
vfs_ioctl+0x18/0x71
Aug 17 21:26:55 ubuntu kernel: [26639.168214]  [<c109f3af>] ?
do_vfs_ioctl+0x481/0x4bf
Aug 17 21:26:55 ubuntu kernel: [26639.168231]  [<c1157c9d>] ?
selinux_file_ioctl+0x3e/0x41
Aug 17 21:26:55 ubuntu kernel: [26639.168245]  [<c109f441>] ?
sys_ioctl+0x54/0x61
Aug 17 21:26:55 ubuntu kernel: [26639.168255]  [<c1002d96>]
work_notifysig+0x13/0x19
Aug 17 21:26:55 ubuntu kernel: [26639.168263] console-kit-d D 00001835
 2824  2267      1 0x00000000
Aug 17 21:26:55 ubuntu kernel: [26639.168277]  eca9de8c 00000046
c184417f 00001835 c1042993 eea7ea54 c1689a00 00000046
Aug 17 21:26:55 ubuntu kernel: [26639.168298]  c1685eb8 c1689a00
eea7ea54 c1689a00 c1042993 00000007 eea7e7c0 c13ee6c2
Aug 17 21:26:55 ubuntu kernel: [26639.168318]  c1841aac 00001835
eea7e7c0 ee404c84 00000002 eca9de80 c104a803 00000000
Aug 17 21:26:55 ubuntu kernel: [26639.168339] Call Trace:
Aug 17 21:26:55 ubuntu kernel: [26639.168348]  [<c1042993>] ?
refrigerator+0x72/0xdb
Aug 17 21:26:55 ubuntu kernel: [26639.168358]  [<c1042993>] ?
refrigerator+0x72/0xdb
Aug 17 21:26:55 ubuntu kernel: [26639.168367]  [<c13ee6c2>] ?
_spin_unlock_irq+0x22/0x45
Aug 17 21:26:55 ubuntu kernel: [26639.168378]  [<c104a803>] ?
trace_hardirqs_on+0xb/0xd
Aug 17 21:26:55 ubuntu kernel: [26639.168387]  [<c10429e5>]
refrigerator+0xc4/0xdb
Aug 17 21:26:56 ubuntu kernel: [26639.168397]  [<c1035b74>]
try_to_freeze+0x19/0x20
Aug 17 21:26:56 ubuntu kernel: [26639.168405]  [<c10371f0>]
get_signal_to_deliver+0x36/0x32e
Aug 17 21:26:56 ubuntu kernel: [26639.168416]  [<c1001fcd>]
do_notify_resume+0x77/0x735
Aug 17 21:26:56 ubuntu kernel: [26639.168426]  [<c11e5350>] ?
tty_ioctl+0x0/0x750
Aug 17 21:26:56 ubuntu kernel: [26639.168435]  [<c109ee36>] ?
vfs_ioctl+0x18/0x71
Aug 17 21:26:56 ubuntu kernel: [26639.168444]  [<c109f3af>] ?
do_vfs_ioctl+0x481/0x4bf
Aug 17 21:26:56 ubuntu kernel: [26639.168456]  [<c1157c9d>] ?
selinux_file_ioctl+0x3e/0x41
Aug 17 21:26:56 ubuntu kernel: [26639.168465]  [<c109f441>] ?
sys_ioctl+0x54/0x61
Aug 17 21:26:56 ubuntu kernel: [26639.168475]  [<c1002d96>]
work_notifysig+0x13/0x19
Aug 17 21:26:56 ubuntu kernel: [26639.168482] console-kit-d D 00001835
 2824  2268      1 0x00000000
Aug 17 21:26:56 ubuntu kernel: [26639.168496]  eca9ce8c 00000046
c183f528 00001835 c1042993 f7255594 c1689a00 00000046
Aug 17 21:26:56 ubuntu kernel: [26639.168517]  c1685eb8 c1689a00
f7255594 c1689a00 c1042993 00000007 f7255300 c13ee6c2
Aug 17 21:26:56 ubuntu kernel: [26639.168537]  c183cb90 00001835
f7255300 ee404c84 00000002 eca9ce80 c104a803 00000000
Aug 17 21:26:56 ubuntu kernel: [26639.168558] Call Trace:
Aug 17 21:26:56 ubuntu kernel: [26639.168567]  [<c1042993>] ?
refrigerator+0x72/0xdb
Aug 17 21:26:56 ubuntu kernel: [26639.168577]  [<c1042993>] ?
refrigerator+0x72/0xdb
Aug 17 21:26:56 ubuntu kernel: [26639.168586]  [<c13ee6c2>] ?
_spin_unlock_irq+0x22/0x45
Aug 17 21:26:56 ubuntu kernel: [26639.168596]  [<c104a803>] ?
trace_hardirqs_on+0xb/0xd
Aug 17 21:26:56 ubuntu kernel: [26639.168606]  [<c10429e5>]
refrigerator+0xc4/0xdb
Aug 17 21:26:56 ubuntu kernel: [26639.168615]  [<c1035b74>]
try_to_freeze+0x19/0x20
Aug 17 21:26:56 ubuntu kernel: [26639.168624]  [<c10371f0>]
get_signal_to_deliver+0x36/0x32e
Aug 17 21:26:56 ubuntu kernel: [26639.168634]  [<c1001fcd>]
do_notify_resume+0x77/0x735
Aug 17 21:26:56 ubuntu kernel: [26639.168644]  [<c11e5350>] ?
tty_ioctl+0x0/0x750
Aug 17 21:26:56 ubuntu kernel: [26639.168653]  [<c109ee36>] ?
vfs_ioctl+0x18/0x71
Aug 17 21:26:56 ubuntu kernel: [26639.168663]  [<c109f3af>] ?
do_vfs_ioctl+0x481/0x4bf
Aug 17 21:26:56 ubuntu kernel: [26639.168674]  [<c1157c9d>] ?
selinux_file_ioctl+0x3e/0x41
Aug 17 21:26:56 ubuntu kernel: [26639.168684]  [<c109f441>] ?
sys_ioctl+0x54/0x61
Aug 17 21:26:56 ubuntu kernel: [26639.168693]  [<c1002d96>]
work_notifysig+0x13/0x19
Aug 17 21:26:56 ubuntu kernel: [26639.168701] console-kit-d D 00001835
 2824  2269      1 0x00000000
Aug 17 21:26:56 ubuntu kernel: [26639.168714]  eca9be8c 00000046
c183a8c5 00001835 c1042993 f7252c14 c1689a00 00000046
Aug 17 21:26:56 ubuntu kernel: [26639.168735]  c1685eb8 c1689a00
f7252c14 c1689a00 c1042993 00000007 f7252980 c13ee6c2
Aug 17 21:26:56 ubuntu kernel: [26639.168756]  c183852e 00001835
f7252980 ee404c84 00000002 eca9be80 c104a803 00000000
Aug 17 21:26:56 ubuntu kernel: [26639.168776] Call Trace:
Aug 17 21:26:56 ubuntu kernel: [26639.168786]  [<c1042993>] ?
refrigerator+0x72/0xdb
Aug 17 21:26:56 ubuntu kernel: [26639.168795]  [<c1042993>] ?
refrigerator+0x72/0xdb
Aug 17 21:26:56 ubuntu kernel: [26639.168805]  [<c13ee6c2>] ?
_spin_unlock_irq+0x22/0x45
Aug 17 21:26:56 ubuntu kernel: [26639.168815]  [<c104a803>] ?
trace_hardirqs_on+0xb/0xd
Aug 17 21:26:56 ubuntu kernel: [26639.168825]  [<c10429e5>]
refrigerator+0xc4/0xdb
Aug 17 21:26:56 ubuntu kernel: [26639.168834]  [<c1035b74>]
try_to_freeze+0x19/0x20
Aug 17 21:26:56 ubuntu kernel: [26639.168843]  [<c10371f0>]
get_signal_to_deliver+0x36/0x32e
Aug 17 21:26:56 ubuntu kernel: [26639.168853]  [<c1001fcd>]
do_notify_resume+0x77/0x735
Aug 17 21:26:56 ubuntu kernel: [26639.168863]  [<c11e5350>] ?
tty_ioctl+0x0/0x750
Aug 17 21:26:56 ubuntu kernel: [26639.168872]  [<c109ee36>] ?
vfs_ioctl+0x18/0x71
Aug 17 21:26:56 ubuntu kernel: [26639.168881]  [<c109f3af>] ?
do_vfs_ioctl+0x481/0x4bf
Aug 17 21:26:56 ubuntu kernel: [26639.168893]  [<c1157c9d>] ?
selinux_file_ioctl+0x3e/0x41
Aug 17 21:26:56 ubuntu kernel: [26639.168903]  [<c109f441>] ?
sys_ioctl+0x54/0x61
Aug 17 21:26:56 ubuntu kernel: [26639.168912]  [<c1002d96>]
work_notifysig+0x13/0x19
Aug 17 21:26:56 ubuntu kernel: [26639.168919] console-kit-d D 00001835
 2824  2270      1 0x00000000
Aug 17 21:26:56 ubuntu kernel: [26639.168933]  eca9ae8c 00000046
c1836065 00001835 c1042993 f7255ff4 c1689a00 00000046
Aug 17 21:26:56 ubuntu kernel: [26639.168954]  c1685eb8 c1689a00
f7255ff4 c1689a00 c1042993 00000007 f7255d60 c13ee6c2
Aug 17 21:26:56 ubuntu kernel: [26639.168975]  c183399d 00001835
f7255d60 ee404c84 00000002 eca9ae80 c104a803 00000000
Aug 17 21:26:56 ubuntu kernel: [26639.168995] Call Trace:
Aug 17 21:26:56 ubuntu kernel: [26639.169004]  [<c1042993>] ?
refrigerator+0x72/0xdb
Aug 17 21:26:56 ubuntu kernel: [26639.169014]  [<c1042993>] ?
refrigerator+0x72/0xdb
Aug 17 21:26:56 ubuntu kernel: [26639.169024]  [<c13ee6c2>] ?
_spin_unlock_irq+0x22/0x45
Aug 17 21:26:56 ubuntu kernel: [26639.169034]  [<c104a803>] ?
trace_hardirqs_on+0xb/0xd
Aug 17 21:26:56 ubuntu kernel: [26639.169043]  [<c10429e5>]
refrigerator+0xc4/0xdb
Aug 17 21:26:56 ubuntu kernel: [26639.169053]  [<c1035b74>]
try_to_freeze+0x19/0x20
Aug 17 21:26:56 ubuntu kernel: [26639.169062]  [<c10371f0>]
get_signal_to_deliver+0x36/0x32e
Aug 17 21:26:56 ubuntu kernel: [26639.169072]  [<c1001fcd>]
do_notify_resume+0x77/0x735
Aug 17 21:26:56 ubuntu kernel: [26639.169082]  [<c11e5350>] ?
tty_ioctl+0x0/0x750
Aug 17 21:26:56 ubuntu kernel: [26639.169091]  [<c109ee36>] ?
vfs_ioctl+0x18/0x71
Aug 17 21:26:56 ubuntu kernel: [26639.169100]  [<c109f3af>] ?
do_vfs_ioctl+0x481/0x4bf
Aug 17 21:26:56 ubuntu kernel: [26639.169112]  [<c1157c9d>] ?
selinux_file_ioctl+0x3e/0x41
Aug 17 21:26:56 ubuntu kernel: [26639.169121]  [<c109f441>] ?
sys_ioctl+0x54/0x61
Aug 17 21:26:56 ubuntu kernel: [26639.169131]  [<c1002d96>]
work_notifysig+0x13/0x19
Aug 17 21:26:56 ubuntu kernel: [26639.169138] console-kit-d D 00001835
 2824  2271      1 0x00000000
Aug 17 21:26:56 ubuntu kernel: [26639.169152]  eca99e8c 00000046
c183155e 00001835 c1042993 f7250294 c1689a00 00000046
Aug 17 21:26:56 ubuntu kernel: [26639.169173]  c1685eb8 c1689a00
f7250294 c1689a00 c1042993 00000007 f7250000 c13ee6c2
Aug 17 21:26:56 ubuntu kernel: [26639.169193]  c182f26a 00001835
f7250000 ee404c84 00000002 eca99e80 c104a803 00000000
Aug 17 21:26:56 ubuntu kernel: [26639.169214] Call Trace:
Aug 17 21:26:56 ubuntu kernel: [26639.169223]  [<c1042993>] ?
refrigerator+0x72/0xdb
Aug 17 21:26:56 ubuntu kernel: [26639.169233]  [<c1042993>] ?
refrigerator+0x72/0xdb
Aug 17 21:26:56 ubuntu kernel: [26639.169242]  [<c13ee6c2>] ?
_spin_unlock_irq+0x22/0x45
Aug 17 21:26:56 ubuntu kernel: [26639.169252]  [<c104a803>] ?
trace_hardirqs_on+0xb/0xd
Aug 17 21:26:56 ubuntu kernel: [26639.169262]  [<c10429e5>]
refrigerator+0xc4/0xdb
Aug 17 21:26:56 ubuntu kernel: [26639.169271]  [<c1035b74>]
try_to_freeze+0x19/0x20
Aug 17 21:26:56 ubuntu kernel: [26639.169280]  [<c10371f0>]
get_signal_to_deliver+0x36/0x32e
Aug 17 21:26:56 ubuntu kernel: [26639.169290]  [<c1001fcd>]
do_notify_resume+0x77/0x735
Aug 17 21:26:56 ubuntu kernel: [26639.169300]  [<c11e5350>] ?
tty_ioctl+0x0/0x750
Aug 17 21:26:56 ubuntu kernel: [26639.169309]  [<c109ee36>] ?
vfs_ioctl+0x18/0x71
Aug 17 21:26:56 ubuntu kernel: [26639.169319]  [<c109f3af>] ?
do_vfs_ioctl+0x481/0x4bf
Aug 17 21:26:56 ubuntu kernel: [26639.169330]  [<c1157c9d>] ?
selinux_file_ioctl+0x3e/0x41
Aug 17 21:26:56 ubuntu kernel: [26639.169340]  [<c109f441>] ?
sys_ioctl+0x54/0x61
Aug 17 21:26:56 ubuntu kernel: [26639.169349]  [<c1002d96>]
work_notifysig+0x13/0x19
Aug 17 21:26:56 ubuntu kernel: [26639.169357] console-kit-d D 00001835
 2824  2272      1 0x00000000
Aug 17 21:26:56 ubuntu kernel: [26639.169371]  eca98e8c 00000046
c182ce43 00001835 c1042993 f62fc0d4 c1689a00 00000046
Aug 17 21:26:56 ubuntu kernel: [26639.169392]  c1685eb8 c1689a00
f62fc0d4 c1689a00 c1042993 00000007 f62fbe40 c13ee6c2
Aug 17 21:26:56 ubuntu kernel: [26639.169412]  c182a5d1 00001835
f62fbe40 ee404c84 00000002 eca98e80 c104a803 00000000
Aug 17 21:26:56 ubuntu kernel: [26639.169433] Call Trace:
Aug 17 21:26:56 ubuntu kernel: [26639.169442]  [<c1042993>] ?
refrigerator+0x72/0xdb
Aug 17 21:26:56 ubuntu kernel: [26639.169452]  [<c1042993>] ?
refrigerator+0x72/0xdb
Aug 17 21:26:56 ubuntu kernel: [26639.169461]  [<c13ee6c2>] ?
_spin_unlock_irq+0x22/0x45
Aug 17 21:26:56 ubuntu kernel: [26639.169471]  [<c104a803>] ?
trace_hardirqs_on+0xb/0xd
Aug 17 21:26:56 ubuntu kernel: [26639.169481]  [<c10429e5>]
refrigerator+0xc4/0xdb
Aug 17 21:26:56 ubuntu kernel: [26639.169490]  [<c1035b74>]
try_to_freeze+0x19/0x20
Aug 17 21:26:56 ubuntu kernel: [26639.169499]  [<c10371f0>]
get_signal_to_deliver+0x36/0x32e
Aug 17 21:26:56 ubuntu kernel: [26639.169509]  [<c1001fcd>]
do_notify_resume+0x77/0x735
Aug 17 21:26:56 ubuntu kernel: [26639.169519]  [<c11e5350>] ?
tty_ioctl+0x0/0x750
Aug 17 21:26:56 ubuntu kernel: [26639.169528]  [<c109ee36>] ?
vfs_ioctl+0x18/0x71
Aug 17 21:26:56 ubuntu kernel: [26639.169538]  [<c109f3af>] ?
do_vfs_ioctl+0x481/0x4bf
Aug 17 21:26:56 ubuntu kernel: [26639.169549]  [<c1157c9d>] ?
selinux_file_ioctl+0x3e/0x41
Aug 17 21:26:56 ubuntu kernel: [26639.169559]  [<c109f441>] ?
sys_ioctl+0x54/0x61
Aug 17 21:26:56 ubuntu kernel: [26639.169568]  [<c1002d96>]
work_notifysig+0x13/0x19
Aug 17 21:26:56 ubuntu kernel: [26639.169576] console-kit-d D 00001835
 2824  2273      1 0x00000000
Aug 17 21:26:56 ubuntu kernel: [26639.169589]  eca97e8c 00000046
c1828113 00001835 c1042993 f62f9754 c1689a00 00000046
Aug 17 21:26:56 ubuntu kernel: [26639.169610]  c1685eb8 c1689a00
f62f9754 c1689a00 c1042993 00000007 f62f94c0 c13ee6c2
Aug 17 21:26:56 ubuntu kernel: [26639.169631]  c1825c1a 00001835
f62f94c0 ee404c84 00000002 eca97e80 c104a803 00000000
Aug 17 21:26:56 ubuntu kernel: [26639.169651] Call Trace:
Aug 17 21:26:56 ubuntu kernel: [26639.169660]  [<c1042993>] ?
refrigerator+0x72/0xdb
Aug 17 21:26:56 ubuntu kernel: [26639.169670]  [<c1042993>] ?
refrigerator+0x72/0xdb
Aug 17 21:26:56 ubuntu kernel: [26639.169680]  [<c13ee6c2>] ?
_spin_unlock_irq+0x22/0x45
Aug 17 21:26:56 ubuntu kernel: [26639.169690]  [<c104a803>] ?
trace_hardirqs_on+0xb/0xd
Aug 17 21:26:56 ubuntu kernel: [26639.169699]  [<c10429e5>]
refrigerator+0xc4/0xdb
Aug 17 21:26:56 ubuntu kernel: [26639.169709]  [<c1035b74>]
try_to_freeze+0x19/0x20
Aug 17 21:26:56 ubuntu kernel: [26639.169718]  [<c10371f0>]
get_signal_to_deliver+0x36/0x32e
Aug 17 21:26:56 ubuntu kernel: [26639.169728]  [<c1001fcd>]
do_notify_resume+0x77/0x735
Aug 17 21:26:56 ubuntu kernel: [26639.169738]  [<c11e5350>] ?
tty_ioctl+0x0/0x750
Aug 17 21:26:56 ubuntu kernel: [26639.169747]  [<c109ee36>] ?
vfs_ioctl+0x18/0x71
Aug 17 21:26:56 ubuntu kernel: [26639.169756]  [<c109f3af>] ?
do_vfs_ioctl+0x481/0x4bf
Aug 17 21:26:56 ubuntu kernel: [26639.169768]  [<c1157c9d>] ?
selinux_file_ioctl+0x3e/0x41
Aug 17 21:26:56 ubuntu kernel: [26639.169777]  [<c109f441>] ?
sys_ioctl+0x54/0x61
Aug 17 21:26:56 ubuntu kernel: [26639.169787]  [<c1002d96>]
work_notifysig+0x13/0x19
Aug 17 21:26:56 ubuntu kernel: [26639.169794] console-kit-d D 00001835
 2824  2274      1 0x00000000
Aug 17 21:26:56 ubuntu kernel: [26639.169808]  eca96e8c 00000046
c18239ce 00001835 c1042993 f62fea54 c1689a00 00000046
Aug 17 21:26:56 ubuntu kernel: [26639.169829]  c1685eb8 c1689a00
f62fea54 c1689a00 c1042993 00000007 f62fe7c0 c13ee6c2
Aug 17 21:26:56 ubuntu kernel: [26639.169849]  c182133c 00001835
f62fe7c0 ee404c84 00000002 eca96e80 c104a803 00000000
Aug 17 21:26:56 ubuntu kernel: [26639.169870] Call Trace:
Aug 17 21:26:56 ubuntu kernel: [26639.169879]  [<c1042993>] ?
refrigerator+0x72/0xdb
Aug 17 21:26:57 ubuntu kernel: [26639.169889]  [<c1042993>] ?
refrigerator+0x72/0xdb
Aug 17 21:26:57 ubuntu kernel: [26639.169898]  [<c13ee6c2>] ?
_spin_unlock_irq+0x22/0x45
Aug 17 21:26:57 ubuntu kernel: [26639.169908]  [<c104a803>] ?
trace_hardirqs_on+0xb/0xd
Aug 17 21:26:57 ubuntu kernel: [26639.169918]  [<c10429e5>]
refrigerator+0xc4/0xdb
Aug 17 21:26:57 ubuntu kernel: [26639.169928]  [<c1035b74>]
try_to_freeze+0x19/0x20
Aug 17 21:26:57 ubuntu kernel: [26639.169936]  [<c10371f0>]
get_signal_to_deliver+0x36/0x32e
Aug 17 21:26:57 ubuntu kernel: [26639.169946]  [<c1001fcd>]
do_notify_resume+0x77/0x735
Aug 17 21:26:57 ubuntu kernel: [26639.169957]  [<c11e5350>] ?
tty_ioctl+0x0/0x750
Aug 17 21:26:57 ubuntu kernel: [26639.169966]  [<c109ee36>] ?
vfs_ioctl+0x18/0x71
Aug 17 21:26:57 ubuntu kernel: [26639.169975]  [<c109f3af>] ?
do_vfs_ioctl+0x481/0x4bf
Aug 17 21:26:57 ubuntu kernel: [26639.169987]  [<c1157c9d>] ?
selinux_file_ioctl+0x3e/0x41
Aug 17 21:26:57 ubuntu kernel: [26639.169996]  [<c109f441>] ?
sys_ioctl+0x54/0x61
Aug 17 21:26:57 ubuntu kernel: [26639.170005]  [<c1002d96>]
work_notifysig+0x13/0x19
Aug 17 21:26:57 ubuntu kernel: [26639.170013] console-kit-d D 00001835
 2824  2275      1 0x00000000
Aug 17 21:26:57 ubuntu kernel: [26639.170027]  eca95e8c 00000046
c181f00b 00001835 c1042993 f62fd594 c1689a00 00000046
Aug 17 21:26:57 ubuntu kernel: [26639.170047]  c1685eb8 c1689a00
f62fd594 c1689a00 c1042993 00000007 f62fd300 c13ee6c2
Aug 17 21:26:57 ubuntu kernel: [26639.170068]  c181ca88 00001835
f62fd300 ee404c84 00000002 eca95e80 c104a803 00000000
Aug 17 21:26:57 ubuntu kernel: [26639.170088] Call Trace:
Aug 17 21:26:57 ubuntu kernel: [26639.170098]  [<c1042993>] ?
refrigerator+0x72/0xdb
Aug 17 21:26:57 ubuntu kernel: [26639.170108]  [<c1042993>] ?
refrigerator+0x72/0xdb
Aug 17 21:26:57 ubuntu kernel: [26639.170117]  [<c13ee6c2>] ?
_spin_unlock_irq+0x22/0x45
Aug 17 21:26:57 ubuntu kernel: [26639.170127]  [<c104a803>] ?
trace_hardirqs_on+0xb/0xd
Aug 17 21:26:57 ubuntu kernel: [26639.170137]  [<c10429e5>]
refrigerator+0xc4/0xdb
Aug 17 21:26:57 ubuntu kernel: [26639.170146]  [<c1035b74>]
try_to_freeze+0x19/0x20
Aug 17 21:26:57 ubuntu kernel: [26639.170155]  [<c10371f0>]
get_signal_to_deliver+0x36/0x32e
Aug 17 21:26:57 ubuntu kernel: [26639.170165]  [<c1001fcd>]
do_notify_resume+0x77/0x735
Aug 17 21:26:57 ubuntu kernel: [26639.170175]  [<c11e5350>] ?
tty_ioctl+0x0/0x750
Aug 17 21:26:57 ubuntu kernel: [26639.170184]  [<c109ee36>] ?
vfs_ioctl+0x18/0x71
Aug 17 21:26:57 ubuntu kernel: [26639.170194]  [<c109f3af>] ?
do_vfs_ioctl+0x481/0x4bf
Aug 17 21:26:57 ubuntu kernel: [26639.170205]  [<c1157c9d>] ?
selinux_file_ioctl+0x3e/0x41
Aug 17 21:26:57 ubuntu kernel: [26639.170215]  [<c109f441>] ?
sys_ioctl+0x54/0x61
Aug 17 21:26:57 ubuntu kernel: [26639.170224]  [<c1002d96>]
work_notifysig+0x13/0x19
Aug 17 21:26:57 ubuntu kernel: [26639.170232] console-kit-d D 00001835
 2824  2276      1 0x00000000
Aug 17 21:26:57 ubuntu kernel: [26639.170245]  eca94e8c 00000046
c181a75d 00001835 c1042993 f62f8294 c1689a00 00000046
Aug 17 21:26:57 ubuntu kernel: [26639.170266]  c1685eb8 c1689a00
f62f8294 c1689a00 c1042993 00000007 f62f8000 c13ee6c2
Aug 17 21:26:57 ubuntu kernel: [26639.170287]  c1817bc6 00001835
f62f8000 ee404c84 00000002 eca94e80 c104a803 00000000
Aug 17 21:26:57 ubuntu kernel: [26639.170307] Call Trace:
Aug 17 21:26:57 ubuntu kernel: [26639.170316]  [<c1042993>] ?
refrigerator+0x72/0xdb
Aug 17 21:26:57 ubuntu kernel: [26639.170326]  [<c1042993>] ?
refrigerator+0x72/0xdb
Aug 17 21:26:57 ubuntu kernel: [26639.170336]  [<c13ee6c2>] ?
_spin_unlock_irq+0x22/0x45
Aug 17 21:26:57 ubuntu kernel: [26639.170346]  [<c104a803>] ?
trace_hardirqs_on+0xb/0xd
Aug 17 21:26:57 ubuntu kernel: [26639.170355]  [<c10429e5>]
refrigerator+0xc4/0xdb
Aug 17 21:26:57 ubuntu kernel: [26639.170365]  [<c1035b74>]
try_to_freeze+0x19/0x20
Aug 17 21:26:57 ubuntu kernel: [26639.170374]  [<c10371f0>]
get_signal_to_deliver+0x36/0x32e
Aug 17 21:26:57 ubuntu kernel: [26639.170384]  [<c1001fcd>]
do_notify_resume+0x77/0x735
Aug 17 21:26:57 ubuntu kernel: [26639.170394]  [<c11e5350>] ?
tty_ioctl+0x0/0x750
Aug 17 21:26:57 ubuntu kernel: [26639.170403]  [<c109ee36>] ?
vfs_ioctl+0x18/0x71
Aug 17 21:26:57 ubuntu kernel: [26639.170412]  [<c109f3af>] ?
do_vfs_ioctl+0x481/0x4bf
Aug 17 21:26:57 ubuntu kernel: [26639.170424]  [<c1157c9d>] ?
selinux_file_ioctl+0x3e/0x41
Aug 17 21:26:57 ubuntu kernel: [26639.170434]  [<c109f441>] ?
sys_ioctl+0x54/0x61
Aug 17 21:26:57 ubuntu kernel: [26639.170443]  [<c1002d96>]
work_notifysig+0x13/0x19
Aug 17 21:26:57 ubuntu kernel: [26639.170450] console-kit-d D 00001835
 2824  2277      1 0x00000000
Aug 17 21:26:57 ubuntu kernel: [26639.170464]  eca93e8c 00000046
c18158b9 00001835 c1042993 f62fa1b4 c1689a00 00000046
Aug 17 21:26:57 ubuntu kernel: [26639.170485]  c1685eb8 c1689a00
f62fa1b4 c1689a00 c1042993 00000007 f62f9f20 c13ee6c2
Aug 17 21:26:57 ubuntu kernel: [26639.170506]  c1813559 00001835
f62f9f20 ee404c84 00000002 eca93e80 c104a803 00000000
Aug 17 21:26:57 ubuntu kernel: [26639.170526] Call Trace:
Aug 17 21:26:57 ubuntu kernel: [26639.170535]  [<c1042993>] ?
refrigerator+0x72/0xdb
Aug 17 21:26:57 ubuntu kernel: [26639.170545]  [<c1042993>] ?
refrigerator+0x72/0xdb
Aug 17 21:26:57 ubuntu kernel: [26639.170555]  [<c13ee6c2>] ?
_spin_unlock_irq+0x22/0x45
Aug 17 21:26:57 ubuntu kernel: [26639.170565]  [<c104a803>] ?
trace_hardirqs_on+0xb/0xd
Aug 17 21:26:57 ubuntu kernel: [26639.170574]  [<c10429e5>]
refrigerator+0xc4/0xdb
Aug 17 21:26:57 ubuntu kernel: [26639.170584]  [<c1035b74>]
try_to_freeze+0x19/0x20
Aug 17 21:26:57 ubuntu kernel: [26639.170593]  [<c10371f0>]
get_signal_to_deliver+0x36/0x32e
Aug 17 21:26:57 ubuntu kernel: [26639.170603]  [<c1001fcd>]
do_notify_resume+0x77/0x735
Aug 17 21:26:57 ubuntu kernel: [26639.170613]  [<c11e5350>] ?
tty_ioctl+0x0/0x750
Aug 17 21:26:57 ubuntu kernel: [26639.170622]  [<c109ee36>] ?
vfs_ioctl+0x18/0x71
Aug 17 21:26:57 ubuntu kernel: [26639.170631]  [<c109f3af>] ?
do_vfs_ioctl+0x481/0x4bf
Aug 17 21:26:57 ubuntu kernel: [26639.170643]  [<c1157c9d>] ?
selinux_file_ioctl+0x3e/0x41
Aug 17 21:26:57 ubuntu kernel: [26639.170652]  [<c109f441>] ?
sys_ioctl+0x54/0x61
Aug 17 21:26:57 ubuntu kernel: [26639.170662]  [<c1002d96>]
work_notifysig+0x13/0x19
Aug 17 21:26:57 ubuntu kernel: [26639.170704] console-kit-d D 00001835
 2824  2278      1 0x00000000
Aug 17 21:26:57 ubuntu kernel: [26639.170719]  eca92e8c 00000046
c1810f4b 00001835 c1042993 f62f8cf4 c1689a00 00000046
Aug 17 21:26:57 ubuntu kernel: [26639.170740]  c1685eb8 c1689a00
f62f8cf4 c1689a00 c1042993 00000007 f62f8a60 c13ee6c2
Aug 17 21:26:57 ubuntu kernel: [26639.170761]  c180e829 00001835
f62f8a60 ee404c84 00000002 eca92e80 c104a803 00000000
Aug 17 21:26:57 ubuntu kernel: [26639.170781] Call Trace:
Aug 17 21:26:57 ubuntu kernel: [26639.170791]  [<c1042993>] ?
refrigerator+0x72/0xdb
Aug 17 21:26:57 ubuntu kernel: [26639.170801]  [<c1042993>] ?
refrigerator+0x72/0xdb
Aug 17 21:26:57 ubuntu kernel: [26639.170810]  [<c13ee6c2>] ?
_spin_unlock_irq+0x22/0x45
Aug 17 21:26:57 ubuntu kernel: [26639.170820]  [<c104a803>] ?
trace_hardirqs_on+0xb/0xd
Aug 17 21:26:57 ubuntu kernel: [26639.170830]  [<c10429e5>]
refrigerator+0xc4/0xdb
Aug 17 21:26:57 ubuntu kernel: [26639.170840]  [<c1035b74>]
try_to_freeze+0x19/0x20
Aug 17 21:26:57 ubuntu kernel: [26639.170849]  [<c10371f0>]
get_signal_to_deliver+0x36/0x32e
Aug 17 21:26:57 ubuntu kernel: [26639.170859]  [<c1001fcd>]
do_notify_resume+0x77/0x735
Aug 17 21:26:57 ubuntu kernel: [26639.170869]  [<c11e5350>] ?
tty_ioctl+0x0/0x750
Aug 17 21:26:57 ubuntu kernel: [26639.170878]  [<c109ee36>] ?
vfs_ioctl+0x18/0x71
Aug 17 21:26:57 ubuntu kernel: [26639.170887]  [<c109f3af>] ?
do_vfs_ioctl+0x481/0x4bf
Aug 17 21:26:57 ubuntu kernel: [26639.170899]  [<c1157c9d>] ?
selinux_file_ioctl+0x3e/0x41
Aug 17 21:26:57 ubuntu kernel: [26639.170908]  [<c109f441>] ?
sys_ioctl+0x54/0x61
Aug 17 21:26:57 ubuntu kernel: [26639.170918]  [<c1002d96>]
work_notifysig+0x13/0x19
Aug 17 21:26:57 ubuntu kernel: [26639.170925] console-kit-d D 00001835
 2824  2279      1 0x00000000
Aug 17 21:26:57 ubuntu kernel: [26639.170939]  eca91e8c 00000046
c180c59b 00001835 c1042993 f62fac14 c1689a00 00000046
Aug 17 21:26:57 ubuntu kernel: [26639.170960]  c1685eb8 c1689a00
f62fac14 c1689a00 c1042993 00000007 f62fa980 c13ee6c2
Aug 17 21:26:57 ubuntu kernel: [26639.170980]  c180a144 00001835
f62fa980 ee404c84 00000002 eca91e80 c104a803 00000000
Aug 17 21:26:57 ubuntu kernel: [26639.171001] Call Trace:
Aug 17 21:26:57 ubuntu kernel: [26639.171010]  [<c1042993>] ?
refrigerator+0x72/0xdb
Aug 17 21:26:57 ubuntu kernel: [26639.171020]  [<c1042993>] ?
refrigerator+0x72/0xdb
Aug 17 21:26:57 ubuntu kernel: [26639.171029]  [<c13ee6c2>] ?
_spin_unlock_irq+0x22/0x45
Aug 17 21:26:57 ubuntu kernel: [26639.171039]  [<c104a803>] ?
trace_hardirqs_on+0xb/0xd
Aug 17 21:26:57 ubuntu kernel: [26639.171049]  [<c10429e5>]
refrigerator+0xc4/0xdb
Aug 17 21:26:57 ubuntu kernel: [26639.171058]  [<c1035b74>]
try_to_freeze+0x19/0x20
Aug 17 21:26:57 ubuntu kernel: [26639.171067]  [<c10371f0>]
get_signal_to_deliver+0x36/0x32e
Aug 17 21:26:57 ubuntu kernel: [26639.171077]  [<c1001fcd>]
do_notify_resume+0x77/0x735
Aug 17 21:26:57 ubuntu kernel: [26639.171087]  [<c11e5350>] ?
tty_ioctl+0x0/0x750
Aug 17 21:26:57 ubuntu kernel: [26639.171096]  [<c109ee36>] ?
vfs_ioctl+0x18/0x71
Aug 17 21:26:57 ubuntu kernel: [26639.171106]  [<c109f3af>] ?
do_vfs_ioctl+0x481/0x4bf
Aug 17 21:26:57 ubuntu kernel: [26639.171117]  [<c1157c9d>] ?
selinux_file_ioctl+0x3e/0x41
Aug 17 21:26:57 ubuntu kernel: [26639.171127]  [<c109f441>] ?
sys_ioctl+0x54/0x61
Aug 17 21:26:57 ubuntu kernel: [26639.171136]  [<c1002d96>]
work_notifysig+0x13/0x19
Aug 17 21:26:57 ubuntu kernel: [26639.171144] console-kit-d D 00001835
 2824  2280      1 0x00000000
Aug 17 21:26:57 ubuntu kernel: [26639.171157]  ecaa6e8c 00000046
c1807ef1 00001835 c1042993 f62fdff4 c1689a00 00000046
Aug 17 21:26:57 ubuntu kernel: [26639.171178]  c1685eb8 c1689a00
f62fdff4 c1689a00 c1042993 00000007 f62fdd60 c13ee6c2
Aug 17 21:26:57 ubuntu kernel: [26639.171199]  c1805204 00001835
f62fdd60 ee404c84 00000002 ecaa6e80 c104a803 00000000
Aug 17 21:26:57 ubuntu kernel: [26639.171219] Call Trace:
Aug 17 21:26:57 ubuntu kernel: [26639.171228]  [<c1042993>] ?
refrigerator+0x72/0xdb
Aug 17 21:26:57 ubuntu kernel: [26639.171238]  [<c1042993>] ?
refrigerator+0x72/0xdb
Aug 17 21:26:57 ubuntu kernel: [26639.171248]  [<c13ee6c2>] ?
_spin_unlock_irq+0x22/0x45
Aug 17 21:26:57 ubuntu kernel: [26639.171258]  [<c104a803>] ?
trace_hardirqs_on+0xb/0xd
Aug 17 21:26:57 ubuntu kernel: [26639.171267]  [<c10429e5>]
refrigerator+0xc4/0xdb
Aug 17 21:26:57 ubuntu kernel: [26639.171277]  [<c1035b74>]
try_to_freeze+0x19/0x20
Aug 17 21:26:57 ubuntu kernel: [26639.171285]  [<c10371f0>]
get_signal_to_deliver+0x36/0x32e
Aug 17 21:26:57 ubuntu kernel: [26639.171296]  [<c1001fcd>]
do_notify_resume+0x77/0x735
Aug 17 21:26:57 ubuntu kernel: [26639.171306]  [<c11e5350>] ?
tty_ioctl+0x0/0x750
Aug 17 21:26:57 ubuntu kernel: [26639.171315]  [<c109ee36>] ?
vfs_ioctl+0x18/0x71
Aug 17 21:26:57 ubuntu kernel: [26639.171324]  [<c109f3af>] ?
do_vfs_ioctl+0x481/0x4bf
Aug 17 21:26:57 ubuntu kernel: [26639.171336]  [<c1157c9d>] ?
selinux_file_ioctl+0x3e/0x41
Aug 17 21:26:57 ubuntu kernel: [26639.171345]  [<c109f441>] ?
sys_ioctl+0x54/0x61
Aug 17 21:26:57 ubuntu kernel: [26639.171354]  [<c1002d96>]
work_notifysig+0x13/0x19
Aug 17 21:26:57 ubuntu kernel: [26639.171362] console-kit-d D 00001835
 2824  2281      1 0x00000000
Aug 17 21:26:57 ubuntu kernel: [26639.171376]  ecaa7e8c 00000046
c1802d53 00001835 c1042993 f6b774b4 c1689a00 00000046
Aug 17 21:26:57 ubuntu kernel: [26639.171396]  c1685eb8 c1689a00
f6b774b4 c1689a00 c1042993 00000007 f6b77220 c13ee6c2
Aug 17 21:26:57 ubuntu kernel: [26639.171417]  c18008e3 00001835
f6b77220 ee404c84 00000002 ecaa7e80 c104a803 00000000
Aug 17 21:26:57 ubuntu kernel: [26639.171437] Call Trace:
Aug 17 21:26:57 ubuntu kernel: [26639.171447]  [<c1042993>] ?
refrigerator+0x72/0xdb
Aug 17 21:26:57 ubuntu kernel: [26639.171457]  [<c1042993>] ?
refrigerator+0x72/0xdb
Aug 17 21:26:57 ubuntu kernel: [26639.171466]  [<c13ee6c2>] ?
_spin_unlock_irq+0x22/0x45
Aug 17 21:26:57 ubuntu kernel: [26639.171476]  [<c104a803>] ?
trace_hardirqs_on+0xb/0xd
Aug 17 21:26:57 ubuntu kernel: [26639.171486]  [<c10429e5>]
refrigerator+0xc4/0xdb
Aug 17 21:26:57 ubuntu kernel: [26639.171495]  [<c1035b74>]
try_to_freeze+0x19/0x20
Aug 17 21:26:57 ubuntu kernel: [26639.171504]  [<c10371f0>]
get_signal_to_deliver+0x36/0x32e
Aug 17 21:26:57 ubuntu kernel: [26639.171529]  [<c1001fcd>]
do_notify_resume+0x77/0x735
Aug 17 21:26:57 ubuntu kernel: [26639.171544]  [<c11e5350>] ?
tty_ioctl+0x0/0x750
Aug 17 21:26:57 ubuntu kernel: [26639.171557]  [<c109ee36>] ?
vfs_ioctl+0x18/0x71
Aug 17 21:26:57 ubuntu kernel: [26639.171571]  [<c109f3af>] ?
do_vfs_ioctl+0x481/0x4bf
Aug 17 21:26:57 ubuntu kernel: [26639.171587]  [<c1157c9d>] ?
selinux_file_ioctl+0x3e/0x41
Aug 17 21:26:57 ubuntu kernel: [26639.171597]  [<c109f441>] ?
sys_ioctl+0x54/0x61
Aug 17 21:26:57 ubuntu kernel: [26639.171606]  [<c1002d96>]
work_notifysig+0x13/0x19
Aug 17 21:26:57 ubuntu kernel: [26639.171614] console-kit-d D 00001835
 2824  2282      1 0x00000000
Aug 17 21:26:57 ubuntu kernel: [26639.171629]  ecaa8e8c 00000046
c17fe6a3 00001835 c1042993 f657b674 c1689a00 00000046
Aug 17 21:26:57 ubuntu kernel: [26639.171650]  c1685eb8 c1689a00
f657b674 c1689a00 c1042993 00000007 f657b3e0 c13ee6c2
Aug 17 21:26:57 ubuntu kernel: [26639.171670]  c17fbee5 00001835
f657b3e0 ee404c84 00000002 ecaa8e80 c104a803 00000000
Aug 17 21:26:57 ubuntu kernel: [26639.171691] Call Trace:
Aug 17 21:26:57 ubuntu kernel: [26639.171700]  [<c1042993>] ?
refrigerator+0x72/0xdb
Aug 17 21:26:57 ubuntu kernel: [26639.171710]  [<c1042993>] ?
refrigerator+0x72/0xdb
Aug 17 21:26:57 ubuntu kernel: [26639.171720]  [<c13ee6c2>] ?
_spin_unlock_irq+0x22/0x45
Aug 17 21:26:57 ubuntu kernel: [26639.171730]  [<c104a803>] ?
trace_hardirqs_on+0xb/0xd
Aug 17 21:26:57 ubuntu kernel: [26639.171739]  [<c10429e5>]
refrigerator+0xc4/0xdb
Aug 17 21:26:57 ubuntu kernel: [26639.171749]  [<c1035b74>]
try_to_freeze+0x19/0x20
Aug 17 21:26:57 ubuntu kernel: [26639.171758]  [<c10371f0>]
get_signal_to_deliver+0x36/0x32e
Aug 17 21:26:57 ubuntu kernel: [26639.171768]  [<c1001fcd>]
do_notify_resume+0x77/0x735
Aug 17 21:26:57 ubuntu kernel: [26639.171778]  [<c11e5350>] ?
tty_ioctl+0x0/0x750
Aug 17 21:26:57 ubuntu kernel: [26639.171787]  [<c109ee36>] ?
vfs_ioctl+0x18/0x71
Aug 17 21:26:57 ubuntu kernel: [26639.171796]  [<c109f3af>] ?
do_vfs_ioctl+0x481/0x4bf
Aug 17 21:26:57 ubuntu kernel: [26639.171808]  [<c1157c9d>] ?
selinux_file_ioctl+0x3e/0x41
Aug 17 21:26:57 ubuntu kernel: [26639.171817]  [<c109f441>] ?
sys_ioctl+0x54/0x61
Aug 17 21:26:57 ubuntu kernel: [26639.171827]  [<c1002d96>]
work_notifysig+0x13/0x19
Aug 17 21:26:58 ubuntu kernel: [26639.171835] console-kit-d D 00001835
 2824  2283      1 0x00000000
Aug 17 21:26:58 ubuntu kernel: [26639.171849]  ecaa9e8c 00000046
c17f9b1e 00001835 c1042993 f657c0d4 c1689a00 00000046
Aug 17 21:26:58 ubuntu kernel: [26639.171869]  c1685eb8 c1689a00
f657c0d4 c1689a00 c1042993 00000007 f657be40 c13ee6c2
Aug 17 21:26:58 ubuntu kernel: [26639.171890]  c17f75b3 00001835
f657be40 ee404c84 00000002 ecaa9e80 c104a803 00000000
Aug 17 21:26:58 ubuntu kernel: [26639.171910] Call Trace:
Aug 17 21:26:58 ubuntu kernel: [26639.171919]  [<c1042993>] ?
refrigerator+0x72/0xdb
Aug 17 21:26:58 ubuntu kernel: [26639.171929]  [<c1042993>] ?
refrigerator+0x72/0xdb
Aug 17 21:26:58 ubuntu kernel: [26639.171939]  [<c13ee6c2>] ?
_spin_unlock_irq+0x22/0x45
Aug 17 21:26:58 ubuntu kernel: [26639.171949]  [<c104a803>] ?
trace_hardirqs_on+0xb/0xd
Aug 17 21:26:58 ubuntu kernel: [26639.171958]  [<c10429e5>]
refrigerator+0xc4/0xdb
Aug 17 21:26:58 ubuntu kernel: [26639.171968]  [<c1035b74>]
try_to_freeze+0x19/0x20
Aug 17 21:26:58 ubuntu kernel: [26639.171977]  [<c10371f0>]
get_signal_to_deliver+0x36/0x32e
Aug 17 21:26:58 ubuntu kernel: [26639.171987]  [<c1001fcd>]
do_notify_resume+0x77/0x735
Aug 17 21:26:58 ubuntu kernel: [26639.171997]  [<c11e5350>] ?
tty_ioctl+0x0/0x750
Aug 17 21:26:58 ubuntu kernel: [26639.172006]  [<c109ee36>] ?
vfs_ioctl+0x18/0x71
Aug 17 21:26:58 ubuntu kernel: [26639.172015]  [<c109f3af>] ?
do_vfs_ioctl+0x481/0x4bf
Aug 17 21:26:58 ubuntu kernel: [26639.172027]  [<c1157c9d>] ?
selinux_file_ioctl+0x3e/0x41
Aug 17 21:26:58 ubuntu kernel: [26639.172036]  [<c109f441>] ?
sys_ioctl+0x54/0x61
Aug 17 21:26:58 ubuntu kernel: [26639.172046]  [<c1002d96>]
work_notifysig+0x13/0x19
Aug 17 21:26:58 ubuntu kernel: [26639.172053] console-kit-d D 00001835
 2824  2284      1 0x00000000
Aug 17 21:26:58 ubuntu kernel: [26639.172067]  ecaaae8c 00000046
c17f52b8 00001835 c1042993 f6578294 c1689a00 00000046
Aug 17 21:26:58 ubuntu kernel: [26639.172088]  c1685eb8 c1689a00
f6578294 c1689a00 c1042993 00000007 f6578000 c13ee6c2
Aug 17 21:26:58 ubuntu kernel: [26639.172109]  c17f28ad 00001835
f6578000 ee404c84 00000002 ecaaae80 c104a803 00000000
Aug 17 21:26:58 ubuntu kernel: [26639.172129] Call Trace:
Aug 17 21:26:58 ubuntu kernel: [26639.172138]  [<c1042993>] ?
refrigerator+0x72/0xdb
Aug 17 21:26:58 ubuntu kernel: [26639.172148]  [<c1042993>] ?
refrigerator+0x72/0xdb
Aug 17 21:26:58 ubuntu kernel: [26639.172158]  [<c13ee6c2>] ?
_spin_unlock_irq+0x22/0x45
Aug 17 21:26:58 ubuntu kernel: [26639.172167]  [<c104a803>] ?
trace_hardirqs_on+0xb/0xd
Aug 17 21:26:58 ubuntu kernel: [26639.172177]  [<c10429e5>]
refrigerator+0xc4/0xdb
Aug 17 21:26:58 ubuntu kernel: [26639.172187]  [<c1035b74>]
try_to_freeze+0x19/0x20
Aug 17 21:26:58 ubuntu kernel: [26639.172195]  [<c10371f0>]
get_signal_to_deliver+0x36/0x32e
Aug 17 21:26:58 ubuntu kernel: [26639.172205]  [<c1001fcd>]
do_notify_resume+0x77/0x735
Aug 17 21:26:58 ubuntu kernel: [26639.172216]  [<c11e5350>] ?
tty_ioctl+0x0/0x750
Aug 17 21:26:58 ubuntu kernel: [26639.172225]  [<c109ee36>] ?
vfs_ioctl+0x18/0x71
Aug 17 21:26:58 ubuntu kernel: [26639.172234]  [<c109f3af>] ?
do_vfs_ioctl+0x481/0x4bf
Aug 17 21:26:58 ubuntu kernel: [26639.172246]  [<c1157c9d>] ?
selinux_file_ioctl+0x3e/0x41
Aug 17 21:26:58 ubuntu kernel: [26639.172255]  [<c109f441>] ?
sys_ioctl+0x54/0x61
Aug 17 21:26:58 ubuntu kernel: [26639.172265]  [<c1002d96>]
work_notifysig+0x13/0x19
Aug 17 21:26:58 ubuntu kernel: [26639.172272] console-kit-d D 00001835
 2824  2285      1 0x00000000
Aug 17 21:26:58 ubuntu kernel: [26639.172286]  ecaabe8c 00000046
c17f061f 00001835 c1042993 f657ea54 c1689a00 00000046
Aug 17 21:26:58 ubuntu kernel: [26639.172307]  c1685eb8 c1689a00
f657ea54 c1689a00 c1042993 00000007 f657e7c0 c13ee6c2
Aug 17 21:26:58 ubuntu kernel: [26639.172327]  c17ee3ae 00001835
f657e7c0 ee404c84 00000002 ecaabe80 c104a803 00000000
Aug 17 21:26:58 ubuntu kernel: [26639.172348] Call Trace:
Aug 17 21:26:58 ubuntu kernel: [26639.172357]  [<c1042993>] ?
refrigerator+0x72/0xdb
Aug 17 21:26:58 ubuntu kernel: [26639.172367]  [<c1042993>] ?
refrigerator+0x72/0xdb
Aug 17 21:26:58 ubuntu kernel: [26639.172376]  [<c13ee6c2>] ?
_spin_unlock_irq+0x22/0x45
Aug 17 21:26:58 ubuntu kernel: [26639.172386]  [<c104a803>] ?
trace_hardirqs_on+0xb/0xd
Aug 17 21:26:58 ubuntu kernel: [26639.172396]  [<c10429e5>]
refrigerator+0xc4/0xdb
Aug 17 21:26:58 ubuntu kernel: [26639.172406]  [<c1035b74>]
try_to_freeze+0x19/0x20
Aug 17 21:26:58 ubuntu kernel: [26639.172414]  [<c10371f0>]
get_signal_to_deliver+0x36/0x32e
Aug 17 21:26:58 ubuntu kernel: [26639.172424]  [<c1001fcd>]
do_notify_resume+0x77/0x735
Aug 17 21:26:58 ubuntu kernel: [26639.172435]  [<c11e5350>] ?
tty_ioctl+0x0/0x750
Aug 17 21:26:58 ubuntu kernel: [26639.172444]  [<c109ee36>] ?
vfs_ioctl+0x18/0x71
Aug 17 21:26:58 ubuntu kernel: [26639.172453]  [<c109f3af>] ?
do_vfs_ioctl+0x481/0x4bf
Aug 17 21:26:58 ubuntu kernel: [26639.172465]  [<c1157c9d>] ?
selinux_file_ioctl+0x3e/0x41
Aug 17 21:26:58 ubuntu kernel: [26639.172474]  [<c109f441>] ?
sys_ioctl+0x54/0x61
Aug 17 21:26:58 ubuntu kernel: [26639.172483]  [<c1002d96>]
work_notifysig+0x13/0x19
Aug 17 21:26:58 ubuntu kernel: [26639.172491] console-kit-d D 00001835
 2824  2286      1 0x00000000
Aug 17 21:26:58 ubuntu kernel: [26639.172505]  ecaace8c 00000046
c17ec07d 00001835 c1042993 f6579754 c1689a00 00000046
Aug 17 21:26:58 ubuntu kernel: [26639.172525]  c1685eb8 c1689a00
f6579754 c1689a00 c1042993 00000007 f65794c0 c13ee6c2
Aug 17 21:26:58 ubuntu kernel: [26639.172546]  c17e9c86 00001835
f65794c0 ee404c84 00000002 ecaace80 c104a803 00000000
Aug 17 21:26:58 ubuntu kernel: [26639.172566] Call Trace:
Aug 17 21:26:58 ubuntu kernel: [26639.172576]  [<c1042993>] ?
refrigerator+0x72/0xdb
Aug 17 21:26:58 ubuntu kernel: [26639.172586]  [<c1042993>] ?
refrigerator+0x72/0xdb
Aug 17 21:26:58 ubuntu kernel: [26639.172595]  [<c13ee6c2>] ?
_spin_unlock_irq+0x22/0x45
Aug 17 21:26:58 ubuntu kernel: [26639.172605]  [<c104a803>] ?
trace_hardirqs_on+0xb/0xd
Aug 17 21:26:58 ubuntu kernel: [26639.172615]  [<c10429e5>]
refrigerator+0xc4/0xdb
Aug 17 21:26:58 ubuntu kernel: [26639.172624]  [<c1035b74>]
try_to_freeze+0x19/0x20
Aug 17 21:26:58 ubuntu kernel: [26639.172633]  [<c10371f0>]
get_signal_to_deliver+0x36/0x32e
Aug 17 21:26:58 ubuntu kernel: [26639.172643]  [<c1001fcd>]
do_notify_resume+0x77/0x735
Aug 17 21:26:58 ubuntu kernel: [26639.172653]  [<c11e5350>] ?
tty_ioctl+0x0/0x750
Aug 17 21:26:58 ubuntu kernel: [26639.172662]  [<c109ee36>] ?
vfs_ioctl+0x18/0x71
Aug 17 21:26:58 ubuntu kernel: [26639.172672]  [<c109f3af>] ?
do_vfs_ioctl+0x481/0x4bf
Aug 17 21:26:58 ubuntu kernel: [26639.172683]  [<c1157c9d>] ?
selinux_file_ioctl+0x3e/0x41
Aug 17 21:26:58 ubuntu kernel: [26639.172693]  [<c109f441>] ?
sys_ioctl+0x54/0x61
Aug 17 21:26:58 ubuntu kernel: [26639.172702]  [<c1002d96>]
work_notifysig+0x13/0x19
Aug 17 21:26:58 ubuntu kernel: [26639.172709] console-kit-d D 00001835
 2824  2287      1 0x00000000
Aug 17 21:26:58 ubuntu kernel: [26639.172723]  ecaade8c 00000046
c17e783b 00001835 c1042993 f6578cf4 c1689a00 00000046
Aug 17 21:26:58 ubuntu kernel: [26639.172744]  c1685eb8 c1689a00
f6578cf4 c1689a00 c1042993 00000007 f6578a60 c13ee6c2
Aug 17 21:26:58 ubuntu kernel: [26639.172765]  c17e5276 00001835
f6578a60 ee404c84 00000002 ecaade80 c104a803 00000000
Aug 17 21:26:58 ubuntu kernel: [26639.172785] Call Trace:
Aug 17 21:26:58 ubuntu kernel: [26639.172794]  [<c1042993>] ?
refrigerator+0x72/0xdb
Aug 17 21:26:58 ubuntu kernel: [26639.172804]  [<c1042993>] ?
refrigerator+0x72/0xdb
Aug 17 21:26:58 ubuntu kernel: [26639.172813]  [<c13ee6c2>] ?
_spin_unlock_irq+0x22/0x45
Aug 17 21:26:58 ubuntu kernel: [26639.172823]  [<c104a803>] ?
trace_hardirqs_on+0xb/0xd
Aug 17 21:26:58 ubuntu kernel: [26639.172833]  [<c10429e5>]
refrigerator+0xc4/0xdb
Aug 17 21:26:58 ubuntu kernel: [26639.172843]  [<c1035b74>]
try_to_freeze+0x19/0x20
Aug 17 21:26:58 ubuntu kernel: [26639.172851]  [<c10371f0>]
get_signal_to_deliver+0x36/0x32e
Aug 17 21:26:58 ubuntu kernel: [26639.172861]  [<c1001fcd>]
do_notify_resume+0x77/0x735
Aug 17 21:26:58 ubuntu kernel: [26639.172872]  [<c11e5350>] ?
tty_ioctl+0x0/0x750
Aug 17 21:26:58 ubuntu kernel: [26639.172881]  [<c109ee36>] ?
vfs_ioctl+0x18/0x71
Aug 17 21:26:58 ubuntu kernel: [26639.172890]  [<c109f3af>] ?
do_vfs_ioctl+0x481/0x4bf
Aug 17 21:26:58 ubuntu kernel: [26639.172902]  [<c1157c9d>] ?
selinux_file_ioctl+0x3e/0x41
Aug 17 21:26:58 ubuntu kernel: [26639.172911]  [<c109f441>] ?
sys_ioctl+0x54/0x61
Aug 17 21:26:58 ubuntu kernel: [26639.172920]  [<c1002d96>]
work_notifysig+0x13/0x19
Aug 17 21:26:58 ubuntu kernel: [26639.172928] console-kit-d D 00001835
 2824  2288      1 0x00000000
Aug 17 21:26:58 ubuntu kernel: [26639.172942]  ecaaee8c 00000046
c17e2ef1 00001835 c1042993 f70a74b4 c1689a00 00000046
Aug 17 21:26:58 ubuntu kernel: [26639.172963]  c1685eb8 c1689a00
f70a74b4 c1689a00 c1042993 00000007 f70a7220 c13ee6c2
Aug 17 21:26:58 ubuntu kernel: [26639.172983]  c17e059b 00001835
f70a7220 ee404c84 00000002 ecaaee80 c104a803 00000000
Aug 17 21:26:58 ubuntu kernel: [26639.173004] Call Trace:
Aug 17 21:26:58 ubuntu kernel: [26639.173013]  [<c1042993>] ?
refrigerator+0x72/0xdb
Aug 17 21:26:58 ubuntu kernel: [26639.173023]  [<c1042993>] ?
refrigerator+0x72/0xdb
Aug 17 21:26:58 ubuntu kernel: [26639.173032]  [<c13ee6c2>] ?
_spin_unlock_irq+0x22/0x45
Aug 17 21:26:58 ubuntu kernel: [26639.173042]  [<c104a803>] ?
trace_hardirqs_on+0xb/0xd
Aug 17 21:26:58 ubuntu kernel: [26639.173052]  [<c10429e5>]
refrigerator+0xc4/0xdb
Aug 17 21:26:58 ubuntu kernel: [26639.173061]  [<c1035b74>]
try_to_freeze+0x19/0x20
Aug 17 21:26:58 ubuntu kernel: [26639.173070]  [<c10371f0>]
get_signal_to_deliver+0x36/0x32e
Aug 17 21:26:58 ubuntu kernel: [26639.173080]  [<c1001fcd>]
do_notify_resume+0x77/0x735
Aug 17 21:26:58 ubuntu kernel: [26639.173090]  [<c11e5350>] ?
tty_ioctl+0x0/0x750
Aug 17 21:26:58 ubuntu kernel: [26639.173100]  [<c109ee36>] ?
vfs_ioctl+0x18/0x71
Aug 17 21:26:58 ubuntu kernel: [26639.173109]  [<c109f3af>] ?
do_vfs_ioctl+0x481/0x4bf
Aug 17 21:26:58 ubuntu kernel: [26639.173121]  [<c1157c9d>] ?
selinux_file_ioctl+0x3e/0x41
Aug 17 21:26:58 ubuntu kernel: [26639.173130]  [<c109f441>] ?
sys_ioctl+0x54/0x61
Aug 17 21:26:58 ubuntu kernel: [26639.173139]  [<c1002d96>]
work_notifysig+0x13/0x19
Aug 17 21:26:58 ubuntu kernel: [26639.173147] console-kit-d D 00001835
 2824  2289      1 0x00000000
Aug 17 21:26:58 ubuntu kernel: [26639.173161]  ecaafe8c 00000046
c17ddea9 00001835 c1042993 f70a6a54 c1689a00 00000046
Aug 17 21:26:58 ubuntu kernel: [26639.173181]  c1685eb8 c1689a00
f70a6a54 c1689a00 c1042993 00000007 f70a67c0 c13ee6c2
Aug 17 21:26:58 ubuntu kernel: [26639.173202]  c17db980 00001835
f70a67c0 ee404c84 00000002 ecaafe80 c104a803 00000000
Aug 17 21:26:58 ubuntu kernel: [26639.173222] Call Trace:
Aug 17 21:26:58 ubuntu kernel: [26639.173232]  [<c1042993>] ?
refrigerator+0x72/0xdb
Aug 17 21:26:58 ubuntu kernel: [26639.173242]  [<c1042993>] ?
refrigerator+0x72/0xdb
Aug 17 21:26:58 ubuntu kernel: [26639.173251]  [<c13ee6c2>] ?
_spin_unlock_irq+0x22/0x45
Aug 17 21:26:58 ubuntu kernel: [26639.173261]  [<c104a803>] ?
trace_hardirqs_on+0xb/0xd
Aug 17 21:26:58 ubuntu kernel: [26639.173271]  [<c10429e5>]
refrigerator+0xc4/0xdb
Aug 17 21:26:58 ubuntu kernel: [26639.173280]  [<c1035b74>]
try_to_freeze+0x19/0x20
Aug 17 21:26:58 ubuntu kernel: [26639.173289]  [<c10371f0>]
get_signal_to_deliver+0x36/0x32e
Aug 17 21:26:58 ubuntu kernel: [26639.173299]  [<c1001fcd>]
do_notify_resume+0x77/0x735
Aug 17 21:26:58 ubuntu kernel: [26639.173309]  [<c11e5350>] ?
tty_ioctl+0x0/0x750
Aug 17 21:26:58 ubuntu kernel: [26639.173318]  [<c109ee36>] ?
vfs_ioctl+0x18/0x71
Aug 17 21:26:58 ubuntu kernel: [26639.173328]  [<c109f3af>] ?
do_vfs_ioctl+0x481/0x4bf
Aug 17 21:26:58 ubuntu kernel: [26639.173339]  [<c1157c9d>] ?
selinux_file_ioctl+0x3e/0x41
Aug 17 21:26:58 ubuntu kernel: [26639.173349]  [<c109f441>] ?
sys_ioctl+0x54/0x61
Aug 17 21:26:58 ubuntu kernel: [26639.173358]  [<c1002d96>]
work_notifysig+0x13/0x19
Aug 17 21:26:58 ubuntu kernel: [26639.173366] console-kit-d D 00001835
 2824  2290      1 0x00000000
Aug 17 21:26:58 ubuntu kernel: [26639.173380]  ecab0e8c 00000046
c17d9529 00001835 c1042993 f70a5ff4 c1689a00 00000046
Aug 17 21:26:58 ubuntu kernel: [26639.173400]  c1685eb8 c1689a00
f70a5ff4 c1689a00 c1042993 00000007 f70a5d60 c13ee6c2
Aug 17 21:26:58 ubuntu kernel: [26639.173421]  c17d6fd5 00001835
f70a5d60 ee404c84 00000002 ecab0e80 c104a803 00000000
Aug 17 21:26:58 ubuntu kernel: [26639.173441] Call Trace:
Aug 17 21:26:58 ubuntu kernel: [26639.173450]  [<c1042993>] ?
refrigerator+0x72/0xdb
Aug 17 21:26:58 ubuntu kernel: [26639.173460]  [<c1042993>] ?
refrigerator+0x72/0xdb
Aug 17 21:26:58 ubuntu kernel: [26639.173470]  [<c13ee6c2>] ?
_spin_unlock_irq+0x22/0x45
Aug 17 21:26:58 ubuntu kernel: [26639.173480]  [<c104a803>] ?
trace_hardirqs_on+0xb/0xd
Aug 17 21:26:58 ubuntu kernel: [26639.173489]  [<c10429e5>]
refrigerator+0xc4/0xdb
Aug 17 21:26:58 ubuntu kernel: [26639.173499]  [<c1035b74>]
try_to_freeze+0x19/0x20
Aug 17 21:26:58 ubuntu kernel: [26639.173508]  [<c10371f0>]
get_signal_to_deliver+0x36/0x32e
Aug 17 21:26:58 ubuntu kernel: [26639.173518]  [<c1001fcd>]
do_notify_resume+0x77/0x735
Aug 17 21:26:58 ubuntu kernel: [26639.173528]  [<c11e5350>] ?
tty_ioctl+0x0/0x750
Aug 17 21:26:58 ubuntu kernel: [26639.173537]  [<c109ee36>] ?
vfs_ioctl+0x18/0x71
Aug 17 21:26:58 ubuntu kernel: [26639.173546]  [<c109f3af>] ?
do_vfs_ioctl+0x481/0x4bf
Aug 17 21:26:58 ubuntu kernel: [26639.173558]  [<c1157c9d>] ?
selinux_file_ioctl+0x3e/0x41
Aug 17 21:26:58 ubuntu kernel: [26639.173567]  [<c109f441>] ?
sys_ioctl+0x54/0x61
Aug 17 21:26:58 ubuntu kernel: [26639.173577]  [<c1002d96>]
work_notifysig+0x13/0x19
Aug 17 21:26:58 ubuntu kernel: [26639.173585] console-kit-d D 00001835
 2824  2291      1 0x00000000
Aug 17 21:26:58 ubuntu kernel: [26639.173598]  ecab1e8c 00000046
c17d4b3c 00001835 c1042993 f6001754 c1689a00 00000046
Aug 17 21:26:58 ubuntu kernel: [26639.173619]  c1685eb8 c1689a00
f6001754 c1689a00 c1042993 00000007 f60014c0 c13ee6c2
Aug 17 21:26:58 ubuntu kernel: [26639.173640]  c17d24f9 00001835
f60014c0 ee404c84 00000002 ecab1e80 c104a803 00000000
Aug 17 21:26:58 ubuntu kernel: [26639.173660] Call Trace:
Aug 17 21:26:58 ubuntu kernel: [26639.173669]  [<c1042993>] ?
refrigerator+0x72/0xdb
Aug 17 21:26:58 ubuntu kernel: [26639.173679]  [<c1042993>] ?
refrigerator+0x72/0xdb
Aug 17 21:26:58 ubuntu kernel: [26639.173689]  [<c13ee6c2>] ?
_spin_unlock_irq+0x22/0x45
Aug 17 21:26:58 ubuntu kernel: [26639.173699]  [<c104a803>] ?
trace_hardirqs_on+0xb/0xd
Aug 17 21:26:58 ubuntu kernel: [26639.173708]  [<c10429e5>]
refrigerator+0xc4/0xdb
Aug 17 21:26:58 ubuntu kernel: [26639.173718]  [<c1035b74>]
try_to_freeze+0x19/0x20
Aug 17 21:26:58 ubuntu kernel: [26639.173727]  [<c10371f0>]
get_signal_to_deliver+0x36/0x32e
Aug 17 21:26:58 ubuntu kernel: [26639.173737]  [<c1001fcd>]
do_notify_resume+0x77/0x735
Aug 17 21:26:58 ubuntu kernel: [26639.173747]  [<c11e5350>] ?
tty_ioctl+0x0/0x750
Aug 17 21:26:58 ubuntu kernel: [26639.173756]  [<c109ee36>] ?
vfs_ioctl+0x18/0x71
Aug 17 21:26:58 ubuntu kernel: [26639.173765]  [<c109f3af>] ?
do_vfs_ioctl+0x481/0x4bf
Aug 17 21:26:58 ubuntu kernel: [26639.173777]  [<c1157c9d>] ?
selinux_file_ioctl+0x3e/0x41
Aug 17 21:26:58 ubuntu kernel: [26639.173786]  [<c109f441>] ?
sys_ioctl+0x54/0x61
Aug 17 21:26:58 ubuntu kernel: [26639.173796]  [<c1002d96>]
work_notifysig+0x13/0x19
Aug 17 21:26:58 ubuntu kernel: [26639.173803] console-kit-d D 00001835
 2824  2292      1 0x00000000
Aug 17 21:26:58 ubuntu kernel: [26639.173818]  ecab2e8c 00000046
c17d00f0 00001835 c1042993 f60040d4 c1689a00 00000046
Aug 17 21:26:58 ubuntu kernel: [26639.173838]  c1685eb8 c1689a00
f60040d4 c1689a00 c1042993 00000007 f6003e40 c13ee6c2
Aug 17 21:26:58 ubuntu kernel: [26639.173859]  c17cd830 00001835
f6003e40 ee404c84 00000002 ecab2e80 c104a803 00000000
Aug 17 21:26:58 ubuntu kernel: [26639.173879] Call Trace:
Aug 17 21:26:58 ubuntu kernel: [26639.173888]  [<c1042993>] ?
refrigerator+0x72/0xdb
Aug 17 21:26:58 ubuntu kernel: [26639.173898]  [<c1042993>] ?
refrigerator+0x72/0xdb
Aug 17 21:26:58 ubuntu kernel: [26639.173908]  [<c13ee6c2>] ?
_spin_unlock_irq+0x22/0x45
Aug 17 21:26:58 ubuntu kernel: [26639.173918]  [<c104a803>] ?
trace_hardirqs_on+0xb/0xd
Aug 17 21:26:58 ubuntu kernel: [26639.173927]  [<c10429e5>]
refrigerator+0xc4/0xdb
Aug 17 21:26:58 ubuntu kernel: [26639.173937]  [<c1035b74>]
try_to_freeze+0x19/0x20
Aug 17 21:26:58 ubuntu kernel: [26639.173946]  [<c10371f0>]
get_signal_to_deliver+0x36/0x32e
Aug 17 21:26:58 ubuntu kernel: [26639.173956]  [<c1001fcd>]
do_notify_resume+0x77/0x735
Aug 17 21:26:58 ubuntu kernel: [26639.173966]  [<c11e5350>] ?
tty_ioctl+0x0/0x750
Aug 17 21:26:58 ubuntu kernel: [26639.173975]  [<c109ee36>] ?
vfs_ioctl+0x18/0x71
Aug 17 21:26:58 ubuntu kernel: [26639.173984]  [<c109f3af>] ?
do_vfs_ioctl+0x481/0x4bf
Aug 17 21:26:58 ubuntu kernel: [26639.173996]  [<c1157c9d>] ?
selinux_file_ioctl+0x3e/0x41
Aug 17 21:26:58 ubuntu kernel: [26639.174041]  [<c109f441>] ?
sys_ioctl+0x54/0x61
Aug 17 21:26:58 ubuntu kernel: [26639.174051]  [<c1002d96>]
work_notifysig+0x13/0x19
Aug 17 21:26:58 ubuntu kernel: [26639.174059] console-kit-d D 00001835
 2824  2293      1 0x00000000
Aug 17 21:26:58 ubuntu kernel: [26639.174073]  ecab3e8c 00000046
c17cb0e4 00001835 c1042993 f6005594 c1689a00 00000046
Aug 17 21:26:58 ubuntu kernel: [26639.174094]  c1685eb8 c1689a00
f6005594 c1689a00 c1042993 00000007 f6005300 c13ee6c2
Aug 17 21:26:59 ubuntu kernel: [26639.174114]  c17c8ccf 00001835
f6005300 ee404c84 00000002 ecab3e80 c104a803 00000000
Aug 17 21:26:59 ubuntu kernel: [26639.174135] Call Trace:
Aug 17 21:26:59 ubuntu kernel: [26639.174144]  [<c1042993>] ?
refrigerator+0x72/0xdb
Aug 17 21:26:59 ubuntu kernel: [26639.174154]  [<c1042993>] ?
refrigerator+0x72/0xdb
Aug 17 21:26:59 ubuntu kernel: [26639.174163]  [<c13ee6c2>] ?
_spin_unlock_irq+0x22/0x45
Aug 17 21:26:59 ubuntu kernel: [26639.174174]  [<c104a803>] ?
trace_hardirqs_on+0xb/0xd
Aug 17 21:26:59 ubuntu kernel: [26639.174183]  [<c10429e5>]
refrigerator+0xc4/0xdb
Aug 17 21:26:59 ubuntu kernel: [26639.174193]  [<c1035b74>]
try_to_freeze+0x19/0x20
Aug 17 21:26:59 ubuntu kernel: [26639.174202]  [<c10371f0>]
get_signal_to_deliver+0x36/0x32e
Aug 17 21:26:59 ubuntu kernel: [26639.174212]  [<c1001fcd>]
do_notify_resume+0x77/0x735
Aug 17 21:26:59 ubuntu kernel: [26639.174222]  [<c11e5350>] ?
tty_ioctl+0x0/0x750
Aug 17 21:26:59 ubuntu kernel: [26639.174231]  [<c109ee36>] ?
vfs_ioctl+0x18/0x71
Aug 17 21:26:59 ubuntu kernel: [26639.174240]  [<c109f3af>] ?
do_vfs_ioctl+0x481/0x4bf
Aug 17 21:26:59 ubuntu kernel: [26639.174252]  [<c1157c9d>] ?
selinux_file_ioctl+0x3e/0x41
Aug 17 21:26:59 ubuntu kernel: [26639.174261]  [<c109f441>] ?
sys_ioctl+0x54/0x61
Aug 17 21:26:59 ubuntu kernel: [26639.174271]  [<c1002d96>]
work_notifysig+0x13/0x19
Aug 17 21:26:59 ubuntu kernel: [26639.174278] console-kit-d D 00001835
 2824  2294      1 0x00000000
Aug 17 21:26:59 ubuntu kernel: [26639.174292]  ecab4e8c 00000046
c17c680c 00001835 c1042993 f6000cf4 c1689a00 00000046
Aug 17 21:26:59 ubuntu kernel: [26639.174313]  c1685eb8 c1689a00
f6000cf4 c1689a00 c1042993 00000007 f6000a60 c13ee6c2
Aug 17 21:26:59 ubuntu kernel: [26639.174334]  c17c43ba 00001835
f6000a60 ee404c84 00000002 ecab4e80 c104a803 00000000
Aug 17 21:26:59 ubuntu kernel: [26639.174354] Call Trace:
Aug 17 21:26:59 ubuntu kernel: [26639.174363]  [<c1042993>] ?
refrigerator+0x72/0xdb
Aug 17 21:26:59 ubuntu kernel: [26639.174373]  [<c1042993>] ?
refrigerator+0x72/0xdb
Aug 17 21:26:59 ubuntu kernel: [26639.174383]  [<c13ee6c2>] ?
_spin_unlock_irq+0x22/0x45
Aug 17 21:26:59 ubuntu kernel: [26639.174393]  [<c104a803>] ?
trace_hardirqs_on+0xb/0xd
Aug 17 21:26:59 ubuntu kernel: [26639.174402]  [<c10429e5>]
refrigerator+0xc4/0xdb
Aug 17 21:26:59 ubuntu kernel: [26639.174412]  [<c1035b74>]
try_to_freeze+0x19/0x20
Aug 17 21:26:59 ubuntu kernel: [26639.174420]  [<c10371f0>]
get_signal_to_deliver+0x36/0x32e
Aug 17 21:26:59 ubuntu kernel: [26639.174431]  [<c1001fcd>]
do_notify_resume+0x77/0x735
Aug 17 21:26:59 ubuntu kernel: [26639.174441]  [<c11e5350>] ?
tty_ioctl+0x0/0x750
Aug 17 21:26:59 ubuntu kernel: [26639.174450]  [<c109ee36>] ?
vfs_ioctl+0x18/0x71
Aug 17 21:26:59 ubuntu kernel: [26639.174459]  [<c109f3af>] ?
do_vfs_ioctl+0x481/0x4bf
Aug 17 21:26:59 ubuntu kernel: [26639.174471]  [<c1157c9d>] ?
selinux_file_ioctl+0x3e/0x41
Aug 17 21:26:59 ubuntu kernel: [26639.174480]  [<c109f441>] ?
sys_ioctl+0x54/0x61
Aug 17 21:26:59 ubuntu kernel: [26639.174490]  [<c1002d96>]
work_notifysig+0x13/0x19
Aug 17 21:26:59 ubuntu kernel: [26639.174497] console-kit-d D 00001835
 2824  2295      1 0x00000000
Aug 17 21:26:59 ubuntu kernel: [26639.174511]  ecab5e8c 00000046
c17c2156 00001835 c1042993 f6005ff4 c1689a00 00000046
Aug 17 21:26:59 ubuntu kernel: [26639.174532]  c1685eb8 c1689a00
f6005ff4 c1689a00 c1042993 00000007 f6005d60 c13ee6c2
Aug 17 21:26:59 ubuntu kernel: [26639.174553]  c17bf67f 00001835
f6005d60 ee404c84 00000002 ecab5e80 c104a803 00000000
Aug 17 21:26:59 ubuntu kernel: [26639.174573] Call Trace:
Aug 17 21:26:59 ubuntu kernel: [26639.174582]  [<c1042993>] ?
refrigerator+0x72/0xdb
Aug 17 21:26:59 ubuntu kernel: [26639.174592]  [<c1042993>] ?
refrigerator+0x72/0xdb
Aug 17 21:26:59 ubuntu kernel: [26639.174602]  [<c13ee6c2>] ?
_spin_unlock_irq+0x22/0x45
Aug 17 21:26:59 ubuntu kernel: [26639.174612]  [<c104a803>] ?
trace_hardirqs_on+0xb/0xd
Aug 17 21:26:59 ubuntu kernel: [26639.174621]  [<c10429e5>]
refrigerator+0xc4/0xdb
Aug 17 21:26:59 ubuntu kernel: [26639.174631]  [<c1035b74>]
try_to_freeze+0x19/0x20
Aug 17 21:26:59 ubuntu kernel: [26639.174639]  [<c10371f0>]
get_signal_to_deliver+0x36/0x32e
Aug 17 21:26:59 ubuntu kernel: [26639.174650]  [<c1001fcd>]
do_notify_resume+0x77/0x735
Aug 17 21:26:59 ubuntu kernel: [26639.174660]  [<c11e5350>] ?
tty_ioctl+0x0/0x750
Aug 17 21:26:59 ubuntu kernel: [26639.174669]  [<c109ee36>] ?
vfs_ioctl+0x18/0x71
Aug 17 21:26:59 ubuntu kernel: [26639.174678]  [<c109f3af>] ?
do_vfs_ioctl+0x481/0x4bf
Aug 17 21:26:59 ubuntu kernel: [26639.174690]  [<c1157c9d>] ?
selinux_file_ioctl+0x3e/0x41
Aug 17 21:26:59 ubuntu kernel: [26639.174699]  [<c109f441>] ?
sys_ioctl+0x54/0x61
Aug 17 21:26:59 ubuntu kernel: [26639.174709]  [<c1002d96>]
work_notifysig+0x13/0x19
Aug 17 21:26:59 ubuntu kernel: [26639.174716] console-kit-d D 00001835
 2824  2296      1 0x00000000
Aug 17 21:26:59 ubuntu kernel: [26639.174730]  ecab6e8c 00000046
c17bca1c 00001835 c1042993 f6006a54 c1689a00 00000046
Aug 17 21:26:59 ubuntu kernel: [26639.174751]  c1685eb8 c1689a00
f6006a54 c1689a00 c1042993 00000007 f60067c0 c13ee6c2
Aug 17 21:26:59 ubuntu kernel: [26639.174771]  c17ba246 00001835
f60067c0 ee404c84 00000002 ecab6e80 c104a803 00000000
Aug 17 21:26:59 ubuntu kernel: [26639.174792] Call Trace:
Aug 17 21:26:59 ubuntu kernel: [26639.174801]  [<c1042993>] ?
refrigerator+0x72/0xdb
Aug 17 21:26:59 ubuntu kernel: [26639.174811]  [<c1042993>] ?
refrigerator+0x72/0xdb
Aug 17 21:26:59 ubuntu kernel: [26639.174820]  [<c13ee6c2>] ?
_spin_unlock_irq+0x22/0x45
Aug 17 21:26:59 ubuntu kernel: [26639.174830]  [<c104a803>] ?
trace_hardirqs_on+0xb/0xd
Aug 17 21:26:59 ubuntu kernel: [26639.174840]  [<c10429e5>]
refrigerator+0xc4/0xdb
Aug 17 21:26:59 ubuntu kernel: [26639.174862]  [<c1035b74>]
try_to_freeze+0x19/0x20
Aug 17 21:26:59 ubuntu kernel: [26639.174875]  [<c10371f0>]
get_signal_to_deliver+0x36/0x32e
Aug 17 21:26:59 ubuntu kernel: [26639.174891]  [<c1001fcd>]
do_notify_resume+0x77/0x735
Aug 17 21:26:59 ubuntu kernel: [26639.174906]  [<c11e5350>] ?
tty_ioctl+0x0/0x750
Aug 17 21:26:59 ubuntu kernel: [26639.174919]  [<c109ee36>] ?
vfs_ioctl+0x18/0x71
Aug 17 21:26:59 ubuntu kernel: [26639.174929]  [<c109f3af>] ?
do_vfs_ioctl+0x481/0x4bf
Aug 17 21:26:59 ubuntu kernel: [26639.174941]  [<c1157c9d>] ?
selinux_file_ioctl+0x3e/0x41
Aug 17 21:26:59 ubuntu kernel: [26639.174950]  [<c109f441>] ?
sys_ioctl+0x54/0x61
Aug 17 21:26:59 ubuntu kernel: [26639.174959]  [<c1002d96>]
work_notifysig+0x13/0x19
Aug 17 21:26:59 ubuntu kernel: [26639.174967] console-kit-d D 00001835
 2824  2297      1 0x00000000
Aug 17 21:26:59 ubuntu kernel: [26639.174981]  ecab7e8c 00000046
c17b7950 00001835 c1042993 f6002c14 c1689a00 00000046
Aug 17 21:26:59 ubuntu kernel: [26639.175002]  c1685eb8 c1689a00
f6002c14 c1689a00 c1042993 00000007 f6002980 c13ee6c2
Aug 17 21:26:59 ubuntu kernel: [26639.175022]  c17b54b1 00001835
f6002980 ee404c84 00000002 ecab7e80 c104a803 00000000
Aug 17 21:26:59 ubuntu kernel: [26639.175043] Call Trace:
Aug 17 21:26:59 ubuntu kernel: [26639.175052]  [<c1042993>] ?
refrigerator+0x72/0xdb
Aug 17 21:26:59 ubuntu kernel: [26639.175062]  [<c1042993>] ?
refrigerator+0x72/0xdb
Aug 17 21:26:59 ubuntu kernel: [26639.175072]  [<c13ee6c2>] ?
_spin_unlock_irq+0x22/0x45
Aug 17 21:26:59 ubuntu kernel: [26639.175081]  [<c104a803>] ?
trace_hardirqs_on+0xb/0xd
Aug 17 21:26:59 ubuntu kernel: [26639.175091]  [<c10429e5>]
refrigerator+0xc4/0xdb
Aug 17 21:26:59 ubuntu kernel: [26639.175101]  [<c1035b74>]
try_to_freeze+0x19/0x20
Aug 17 21:26:59 ubuntu kernel: [26639.175109]  [<c10371f0>]
get_signal_to_deliver+0x36/0x32e
Aug 17 21:26:59 ubuntu kernel: [26639.175119]  [<c1001fcd>]
do_notify_resume+0x77/0x735
Aug 17 21:26:59 ubuntu kernel: [26639.175130]  [<c11e5350>] ?
tty_ioctl+0x0/0x750
Aug 17 21:26:59 ubuntu kernel: [26639.175139]  [<c109ee36>] ?
vfs_ioctl+0x18/0x71
Aug 17 21:26:59 ubuntu kernel: [26639.175148]  [<c109f3af>] ?
do_vfs_ioctl+0x481/0x4bf
Aug 17 21:26:59 ubuntu kernel: [26639.175160]  [<c1157c9d>] ?
selinux_file_ioctl+0x3e/0x41
Aug 17 21:26:59 ubuntu kernel: [26639.175169]  [<c109f441>] ?
sys_ioctl+0x54/0x61
Aug 17 21:26:59 ubuntu kernel: [26639.175179]  [<c1002d96>]
work_notifysig+0x13/0x19
Aug 17 21:26:59 ubuntu kernel: [26639.175186] console-kit-d D 00001835
 2824  2298      1 0x00000000
Aug 17 21:26:59 ubuntu kernel: [26639.175200]  ecab8e8c 00000046
c17b3198 00001835 c1042993 f6004b34 c1689a00 00000046
Aug 17 21:26:59 ubuntu kernel: [26639.175221]  c1685eb8 c1689a00
f6004b34 c1689a00 c1042993 00000007 f60048a0 c13ee6c2
Aug 17 21:26:59 ubuntu kernel: [26639.175242]  c17b0cab 00001835
f60048a0 ee404c84 00000002 ecab8e80 c104a803 00000000
Aug 17 21:26:59 ubuntu kernel: [26639.175262] Call Trace:
Aug 17 21:26:59 ubuntu kernel: [26639.175271]  [<c1042993>] ?
refrigerator+0x72/0xdb
Aug 17 21:26:59 ubuntu kernel: [26639.175281]  [<c1042993>] ?
refrigerator+0x72/0xdb
Aug 17 21:26:59 ubuntu kernel: [26639.175290]  [<c13ee6c2>] ?
_spin_unlock_irq+0x22/0x45
Aug 17 21:26:59 ubuntu kernel: [26639.175300]  [<c104a803>] ?
trace_hardirqs_on+0xb/0xd
Aug 17 21:26:59 ubuntu kernel: [26639.175310]  [<c10429e5>]
refrigerator+0xc4/0xdb
Aug 17 21:26:59 ubuntu kernel: [26639.175320]  [<c1035b74>]
try_to_freeze+0x19/0x20
Aug 17 21:26:59 ubuntu kernel: [26639.175328]  [<c10371f0>]
get_signal_to_deliver+0x36/0x32e
Aug 17 21:26:59 ubuntu kernel: [26639.175339]  [<c1001fcd>]
do_notify_resume+0x77/0x735
Aug 17 21:26:59 ubuntu kernel: [26639.175349]  [<c11e5350>] ?
tty_ioctl+0x0/0x750
Aug 17 21:26:59 ubuntu kernel: [26639.175358]  [<c109ee36>] ?
vfs_ioctl+0x18/0x71
Aug 17 21:26:59 ubuntu kernel: [26639.175367]  [<c109f3af>] ?
do_vfs_ioctl+0x481/0x4bf
Aug 17 21:26:59 ubuntu kernel: [26639.175379]  [<c1157c9d>] ?
selinux_file_ioctl+0x3e/0x41
Aug 17 21:26:59 ubuntu kernel: [26639.175388]  [<c109f441>] ?
sys_ioctl+0x54/0x61
Aug 17 21:26:59 ubuntu kernel: [26639.175398]  [<c1002d96>]
work_notifysig+0x13/0x19
Aug 17 21:26:59 ubuntu kernel: [26639.175405] console-kit-d D 00001835
 2824  2299      1 0x00000000
Aug 17 21:26:59 ubuntu kernel: [26639.175419]  ecab9e8c 00000046
c17aeba9 00001835 c1042993 f6003674 c1689a00 00000046
Aug 17 21:26:59 ubuntu kernel: [26639.175440]  c1685eb8 c1689a00
f6003674 c1689a00 c1042993 00000007 f60033e0 c13ee6c2
Aug 17 21:26:59 ubuntu kernel: [26639.175460]  c17ac703 00001835
f60033e0 ee404c84 00000002 ecab9e80 c104a803 00000000
Aug 17 21:26:59 ubuntu kernel: [26639.175481] Call Trace:
Aug 17 21:26:59 ubuntu kernel: [26639.175490]  [<c1042993>] ?
refrigerator+0x72/0xdb
Aug 17 21:26:59 ubuntu kernel: [26639.175500]  [<c1042993>] ?
refrigerator+0x72/0xdb
Aug 17 21:26:59 ubuntu kernel: [26639.175509]  [<c13ee6c2>] ?
_spin_unlock_irq+0x22/0x45
Aug 17 21:26:59 ubuntu kernel: [26639.175519]  [<c104a803>] ?
trace_hardirqs_on+0xb/0xd
Aug 17 21:26:59 ubuntu kernel: [26639.175529]  [<c10429e5>]
refrigerator+0xc4/0xdb
Aug 17 21:26:59 ubuntu kernel: [26639.175538]  [<c1035b74>]
try_to_freeze+0x19/0x20
Aug 17 21:26:59 ubuntu kernel: [26639.175547]  [<c10371f0>]
get_signal_to_deliver+0x36/0x32e
Aug 17 21:26:59 ubuntu kernel: [26639.175557]  [<c1001fcd>]
do_notify_resume+0x77/0x735
Aug 17 21:26:59 ubuntu kernel: [26639.175567]  [<c11e5350>] ?
tty_ioctl+0x0/0x750
Aug 17 21:26:59 ubuntu kernel: [26639.175576]  [<c109ee36>] ?
vfs_ioctl+0x18/0x71
Aug 17 21:26:59 ubuntu kernel: [26639.175586]  [<c109f3af>] ?
do_vfs_ioctl+0x481/0x4bf
Aug 17 21:26:59 ubuntu kernel: [26639.175597]  [<c1157c9d>] ?
selinux_file_ioctl+0x3e/0x41
Aug 17 21:26:59 ubuntu kernel: [26639.175607]  [<c109f441>] ?
sys_ioctl+0x54/0x61
Aug 17 21:26:59 ubuntu kernel: [26639.175616]  [<c1002d96>]
work_notifysig+0x13/0x19
Aug 17 21:26:59 ubuntu kernel: [26639.175624] console-kit-d D 00001835
 2824  2300      1 0x00000000
Aug 17 21:26:59 ubuntu kernel: [26639.175638]  ecabae8c 00000046
c17aa156 00001835 c1042993 f60021b4 c1689a00 00000046
Aug 17 21:26:59 ubuntu kernel: [26639.175658]  c1685eb8 c1689a00
f60021b4 c1689a00 c1042993 00000007 f6001f20 c13ee6c2
Aug 17 21:26:59 ubuntu kernel: [26639.175679]  c17a7a16 00001835
f6001f20 ee404c84 00000002 ecabae80 c104a803 00000000
Aug 17 21:26:59 ubuntu kernel: [26639.175699] Call Trace:
Aug 17 21:26:59 ubuntu kernel: [26639.175709]  [<c1042993>] ?
refrigerator+0x72/0xdb
Aug 17 21:26:59 ubuntu kernel: [26639.175719]  [<c1042993>] ?
refrigerator+0x72/0xdb
Aug 17 21:26:59 ubuntu kernel: [26639.175728]  [<c13ee6c2>] ?
_spin_unlock_irq+0x22/0x45
Aug 17 21:26:59 ubuntu kernel: [26639.175738]  [<c104a803>] ?
trace_hardirqs_on+0xb/0xd
Aug 17 21:26:59 ubuntu kernel: [26639.175748]  [<c10429e5>]
refrigerator+0xc4/0xdb
Aug 17 21:26:59 ubuntu kernel: [26639.175757]  [<c1035b74>]
try_to_freeze+0x19/0x20
Aug 17 21:26:59 ubuntu kernel: [26639.175766]  [<c10371f0>]
get_signal_to_deliver+0x36/0x32e
Aug 17 21:26:59 ubuntu kernel: [26639.175776]  [<c1001fcd>]
do_notify_resume+0x77/0x735
Aug 17 21:26:59 ubuntu kernel: [26639.175786]  [<c11e5350>] ?
tty_ioctl+0x0/0x750
Aug 17 21:26:59 ubuntu kernel: [26639.175795]  [<c109ee36>] ?
vfs_ioctl+0x18/0x71
Aug 17 21:26:59 ubuntu kernel: [26639.175805]  [<c109f3af>] ?
do_vfs_ioctl+0x481/0x4bf
Aug 17 21:26:59 ubuntu kernel: [26639.175816]  [<c1157c9d>] ?
selinux_file_ioctl+0x3e/0x41
Aug 17 21:26:59 ubuntu kernel: [26639.175826]  [<c109f441>] ?
sys_ioctl+0x54/0x61
Aug 17 21:26:59 ubuntu kernel: [26639.175835]  [<c1002d96>]
work_notifysig+0x13/0x19
Aug 17 21:26:59 ubuntu kernel: [26639.175843] console-kit-d D 00001835
 2824  2301      1 0x00000000
Aug 17 21:26:59 ubuntu kernel: [26639.175856]  ecabbe8c 00000046
c17a5216 00001835 c1042993 ee9221b4 c1689a00 00000046
Aug 17 21:26:59 ubuntu kernel: [26639.175877]  c1685eb8 c1689a00
ee9221b4 c1689a00 c1042993 00000007 ee921f20 c13ee6c2
Aug 17 21:26:59 ubuntu kernel: [26639.175898]  c17a2a4c 00001835
ee921f20 ee404c84 00000002 ecabbe80 c104a803 00000000
Aug 17 21:26:59 ubuntu kernel: [26639.175918] Call Trace:
Aug 17 21:26:59 ubuntu kernel: [26639.175927]  [<c1042993>] ?
refrigerator+0x72/0xdb
Aug 17 21:26:59 ubuntu kernel: [26639.175937]  [<c1042993>] ?
refrigerator+0x72/0xdb
Aug 17 21:26:59 ubuntu kernel: [26639.175947]  [<c13ee6c2>] ?
_spin_unlock_irq+0x22/0x45
Aug 17 21:26:59 ubuntu kernel: [26639.175957]  [<c104a803>] ?
trace_hardirqs_on+0xb/0xd
Aug 17 21:26:59 ubuntu kernel: [26639.175966]  [<c10429e5>]
refrigerator+0xc4/0xdb
Aug 17 21:26:59 ubuntu kernel: [26639.175976]  [<c1035b74>]
try_to_freeze+0x19/0x20
Aug 17 21:26:59 ubuntu kernel: [26639.175985]  [<c10371f0>]
get_signal_to_deliver+0x36/0x32e
Aug 17 21:26:59 ubuntu kernel: [26639.175995]  [<c1001fcd>]
do_notify_resume+0x77/0x735
Aug 17 21:26:59 ubuntu kernel: [26639.176005]  [<c11e5350>] ?
tty_ioctl+0x0/0x750
Aug 17 21:26:59 ubuntu kernel: [26639.176014]  [<c109ee36>] ?
vfs_ioctl+0x18/0x71
Aug 17 21:26:59 ubuntu kernel: [26639.176023]  [<c109f3af>] ?
do_vfs_ioctl+0x481/0x4bf
Aug 17 21:26:59 ubuntu kernel: [26639.176035]  [<c1157c9d>] ?
selinux_file_ioctl+0x3e/0x41
Aug 17 21:26:59 ubuntu kernel: [26639.176045]  [<c109f441>] ?
sys_ioctl+0x54/0x61
Aug 17 21:26:59 ubuntu kernel: [26639.176054]  [<c1002d96>]
work_notifysig+0x13/0x19
Aug 17 21:26:59 ubuntu kernel: [26639.176062] console-kit-d D 00001835
 2824  2302      1 0x00000000
Aug 17 21:26:59 ubuntu kernel: [26639.176075]  ecabde8c 00000046
c17a04cf 00001835 c1042993 ee922c14 c1689a00 00000046
Aug 17 21:26:59 ubuntu kernel: [26639.176096]  c1685eb8 c1689a00
ee922c14 c1689a00 c1042993 00000007 ee922980 c13ee6c2
Aug 17 21:26:59 ubuntu kernel: [26639.176117]  c179e102 00001835
ee922980 ee404c84 00000002 ecabde80 c104a803 00000000
Aug 17 21:26:59 ubuntu kernel: [26639.176137] Call Trace:
Aug 17 21:26:59 ubuntu kernel: [26639.176146]  [<c1042993>] ?
refrigerator+0x72/0xdb
Aug 17 21:26:59 ubuntu kernel: [26639.176156]  [<c1042993>] ?
refrigerator+0x72/0xdb
Aug 17 21:26:59 ubuntu kernel: [26639.176166]  [<c13ee6c2>] ?
_spin_unlock_irq+0x22/0x45
Aug 17 21:26:59 ubuntu kernel: [26639.176176]  [<c104a803>] ?
trace_hardirqs_on+0xb/0xd
Aug 17 21:26:59 ubuntu kernel: [26639.176185]  [<c10429e5>]
refrigerator+0xc4/0xdb
Aug 17 21:26:59 ubuntu kernel: [26639.176195]  [<c1035b74>]
try_to_freeze+0x19/0x20
Aug 17 21:26:59 ubuntu kernel: [26639.176204]  [<c10371f0>]
get_signal_to_deliver+0x36/0x32e
Aug 17 21:26:59 ubuntu kernel: [26639.176214]  [<c1001fcd>]
do_notify_resume+0x77/0x735
Aug 17 21:26:59 ubuntu kernel: [26639.176224]  [<c11e5350>] ?
tty_ioctl+0x0/0x750
Aug 17 21:26:59 ubuntu kernel: [26639.176233]  [<c109ee36>] ?
vfs_ioctl+0x18/0x71
Aug 17 21:26:59 ubuntu kernel: [26639.176242]  [<c109f3af>] ?
do_vfs_ioctl+0x481/0x4bf
Aug 17 21:26:59 ubuntu kernel: [26639.176254]  [<c1157c9d>] ?
selinux_file_ioctl+0x3e/0x41
Aug 17 21:26:59 ubuntu kernel: [26639.176263]  [<c109f441>] ?
sys_ioctl+0x54/0x61
Aug 17 21:26:59 ubuntu kernel: [26639.176273]  [<c1002d96>]
work_notifysig+0x13/0x19
Aug 17 21:26:59 ubuntu kernel: [26639.176280] console-kit-d D 00001835
 2824  2303      1 0x00000000
Aug 17 21:26:59 ubuntu kernel: [26639.176294]  ecabee8c 00000046
c179bf57 00001835 c1042993 ecac8294 c1689a00 00000046
Aug 17 21:26:59 ubuntu kernel: [26639.176315]  c1685eb8 c1689a00
ecac8294 c1689a00 c1042993 00000007 ecac8000 c13ee6c2
Aug 17 21:26:59 ubuntu kernel: [26639.176335]  c1799ccf 00001835
ecac8000 ee404c84 00000002 ecabee80 c104a803 00000000
Aug 17 21:26:59 ubuntu kernel: [26639.176356] Call Trace:
Aug 17 21:26:59 ubuntu kernel: [26639.176365]  [<c1042993>] ?
refrigerator+0x72/0xdb
Aug 17 21:26:59 ubuntu kernel: [26639.176375]  [<c1042993>] ?
refrigerator+0x72/0xdb
Aug 17 21:26:59 ubuntu kernel: [26639.176384]  [<c13ee6c2>] ?
_spin_unlock_irq+0x22/0x45
Aug 17 21:26:59 ubuntu kernel: [26639.176394]  [<c104a803>] ?
trace_hardirqs_on+0xb/0xd
Aug 17 21:26:59 ubuntu kernel: [26639.176404]  [<c10429e5>]
refrigerator+0xc4/0xdb
Aug 17 21:26:59 ubuntu kernel: [26639.176413]  [<c1035b74>]
try_to_freeze+0x19/0x20
Aug 17 21:26:59 ubuntu kernel: [26639.176422]  [<c10371f0>]
get_signal_to_deliver+0x36/0x32e
Aug 17 21:26:59 ubuntu kernel: [26639.176432]  [<c1001fcd>]
do_notify_resume+0x77/0x735
Aug 17 21:26:59 ubuntu kernel: [26639.176442]  [<c11e5350>] ?
tty_ioctl+0x0/0x750
Aug 17 21:26:59 ubuntu kernel: [26639.176452]  [<c109ee36>] ?
vfs_ioctl+0x18/0x71
Aug 17 21:26:59 ubuntu kernel: [26639.176461]  [<c109f3af>] ?
do_vfs_ioctl+0x481/0x4bf
Aug 17 21:26:59 ubuntu kernel: [26639.176473]  [<c1157c9d>] ?
selinux_file_ioctl+0x3e/0x41
Aug 17 21:26:59 ubuntu kernel: [26639.176482]  [<c109f441>] ?
sys_ioctl+0x54/0x61
Aug 17 21:26:59 ubuntu kernel: [26639.176491]  [<c1002d96>]
work_notifysig+0x13/0x19
Aug 17 21:26:59 ubuntu kernel: [26639.176499] console-kit-d D 00001835
 2824  2304      1 0x00000000
Aug 17 21:26:59 ubuntu kernel: [26639.176513]  ecabfe8c 00000046
c17976cd 00001835 c1042993 ecac8cf4 c1689a00 00000046
Aug 17 21:26:59 ubuntu kernel: [26639.176533]  c1685eb8 c1689a00
ecac8cf4 c1689a00 c1042993 00000007 ecac8a60 c13ee6c2
Aug 17 21:26:59 ubuntu kernel: [26639.176554]  c1795018 00001835
ecac8a60 ee404c84 00000002 ecabfe80 c104a803 00000000
Aug 17 21:26:59 ubuntu kernel: [26639.176574] Call Trace:
Aug 17 21:26:59 ubuntu kernel: [26639.176583]  [<c1042993>] ?
refrigerator+0x72/0xdb
Aug 17 21:26:59 ubuntu kernel: [26639.176593]  [<c1042993>] ?
refrigerator+0x72/0xdb
Aug 17 21:26:59 ubuntu kernel: [26639.176603]  [<c13ee6c2>] ?
_spin_unlock_irq+0x22/0x45
Aug 17 21:26:59 ubuntu kernel: [26639.176613]  [<c104a803>] ?
trace_hardirqs_on+0xb/0xd
Aug 17 21:26:59 ubuntu kernel: [26639.176622]  [<c10429e5>]
refrigerator+0xc4/0xdb
Aug 17 21:26:59 ubuntu kernel: [26639.176632]  [<c1035b74>]
try_to_freeze+0x19/0x20
Aug 17 21:26:59 ubuntu kernel: [26639.176641]  [<c10371f0>]
get_signal_to_deliver+0x36/0x32e
Aug 17 21:26:59 ubuntu kernel: [26639.176651]  [<c1001fcd>]
do_notify_resume+0x77/0x735
Aug 17 21:26:59 ubuntu kernel: [26639.176661]  [<c11e5350>] ?
tty_ioctl+0x0/0x750
Aug 17 21:26:59 ubuntu kernel: [26639.176670]  [<c109ee36>] ?
vfs_ioctl+0x18/0x71
Aug 17 21:26:59 ubuntu kernel: [26639.176679]  [<c109f3af>] ?
do_vfs_ioctl+0x481/0x4bf
Aug 17 21:26:59 ubuntu kernel: [26639.176691]  [<c1157c9d>] ?
selinux_file_ioctl+0x3e/0x41
Aug 17 21:26:59 ubuntu kernel: [26639.176700]  [<c109f441>] ?
sys_ioctl+0x54/0x61
Aug 17 21:26:59 ubuntu kernel: [26639.176710]  [<c1002d96>]
work_notifysig+0x13/0x19
Aug 17 21:26:59 ubuntu kernel: [26639.176717] console-kit-d D 00001835
 2824  2305      1 0x00000000
Aug 17 21:26:59 ubuntu kernel: [26639.176731]  ecac0e8c 00000046
c1792d6b 00001835 c1042993 ecac9754 c1689a00 00000046
Aug 17 21:26:59 ubuntu kernel: [26639.176752]  c1685eb8 c1689a00
ecac9754 c1689a00 c1042993 00000007 ecac94c0 c13ee6c2
Aug 17 21:26:59 ubuntu kernel: [26639.176773]  c178fa58 00001835
ecac94c0 ee404c84 00000002 ecac0e80 c104a803 00000000
Aug 17 21:26:59 ubuntu kernel: [26639.176793] Call Trace:
Aug 17 21:26:59 ubuntu kernel: [26639.176802]  [<c1042993>] ?
refrigerator+0x72/0xdb
Aug 17 21:26:59 ubuntu kernel: [26639.176812]  [<c1042993>] ?
refrigerator+0x72/0xdb
Aug 17 21:26:59 ubuntu kernel: [26639.176822]  [<c13ee6c2>] ?
_spin_unlock_irq+0x22/0x45
Aug 17 21:26:59 ubuntu kernel: [26639.176832]  [<c104a803>] ?
trace_hardirqs_on+0xb/0xd
Aug 17 21:26:59 ubuntu kernel: [26639.176841]  [<c10429e5>]
refrigerator+0xc4/0xdb
Aug 17 21:26:59 ubuntu kernel: [26639.176851]  [<c1035b74>]
try_to_freeze+0x19/0x20
Aug 17 21:26:59 ubuntu kernel: [26639.176859]  [<c10371f0>]
get_signal_to_deliver+0x36/0x32e
Aug 17 21:26:59 ubuntu kernel: [26639.176869]  [<c1001fcd>]
do_notify_resume+0x77/0x735
Aug 17 21:26:59 ubuntu kernel: [26639.176880]  [<c11e5350>] ?
tty_ioctl+0x0/0x750
Aug 17 21:26:59 ubuntu kernel: [26639.176889]  [<c109ee36>] ?
vfs_ioctl+0x18/0x71
Aug 17 21:26:59 ubuntu kernel: [26639.176898]  [<c109f3af>] ?
do_vfs_ioctl+0x481/0x4bf
Aug 17 21:26:59 ubuntu kernel: [26639.176910]  [<c1157c9d>] ?
selinux_file_ioctl+0x3e/0x41
Aug 17 21:26:59 ubuntu kernel: [26639.176919]  [<c109f441>] ?
sys_ioctl+0x54/0x61
Aug 17 21:26:59 ubuntu kernel: [26639.176928]  [<c1002d96>]
work_notifysig+0x13/0x19
Aug 17 21:26:59 ubuntu kernel: [26639.176936] console-kit-d D 00001835
 2824  2306      1 0x00000000
Aug 17 21:26:59 ubuntu kernel: [26639.176950]  ecac1e8c 00000046
c178c896 00001835 c1042993 ecaca1b4 c1689a00 00000046
Aug 17 21:26:59 ubuntu kernel: [26639.176971]  c1685eb8 c1689a00
ecaca1b4 c1689a00 c1042993 00000007 ecac9f20 c13ee6c2
Aug 17 21:27:00 ubuntu kernel: [26639.176991]  c1778455 00001835
ecac9f20 ee404c84 00000002 ecac1e80 c104a803 00000000
Aug 17 21:27:00 ubuntu kernel: [26639.177012] Call Trace:
Aug 17 21:27:00 ubuntu kernel: [26639.177021]  [<c1042993>] ?
refrigerator+0x72/0xdb
Aug 17 21:27:00 ubuntu kernel: [26639.177031]  [<c1042993>] ?
refrigerator+0x72/0xdb
Aug 17 21:27:00 ubuntu kernel: [26639.177040]  [<c13ee6c2>] ?
_spin_unlock_irq+0x22/0x45
Aug 17 21:27:00 ubuntu kernel: [26639.177050]  [<c104a803>] ?
trace_hardirqs_on+0xb/0xd
Aug 17 21:27:00 ubuntu kernel: [26639.177060]  [<c10429e5>]
refrigerator+0xc4/0xdb
Aug 17 21:27:00 ubuntu kernel: [26639.177069]  [<c1035b74>]
try_to_freeze+0x19/0x20
Aug 17 21:27:00 ubuntu kernel: [26639.177078]  [<c10371f0>]
get_signal_to_deliver+0x36/0x32e
Aug 17 21:27:00 ubuntu kernel: [26639.177088]  [<c1001fcd>]
do_notify_resume+0x77/0x735
Aug 17 21:27:00 ubuntu kernel: [26639.177098]  [<c11e5350>] ?
tty_ioctl+0x0/0x750
Aug 17 21:27:00 ubuntu kernel: [26639.177107]  [<c109ee36>] ?
vfs_ioctl+0x18/0x71
Aug 17 21:27:00 ubuntu kernel: [26639.177117]  [<c109f3af>] ?
do_vfs_ioctl+0x481/0x4bf
Aug 17 21:27:00 ubuntu kernel: [26639.177128]  [<c1157c9d>] ?
selinux_file_ioctl+0x3e/0x41
Aug 17 21:27:00 ubuntu kernel: [26639.177138]  [<c109f441>] ?
sys_ioctl+0x54/0x61
Aug 17 21:27:00 ubuntu kernel: [26639.177147]  [<c1002d96>]
work_notifysig+0x13/0x19
Aug 17 21:27:00 ubuntu kernel: [26639.177155] console-kit-d D 00001835
 2824  2307      1 0x00000000
Aug 17 21:27:00 ubuntu kernel: [26639.177169]  ecac2e8c 00000046
c1776046 00001835 c1042993 ecacac14 c1689a00 00000046
Aug 17 21:27:00 ubuntu kernel: [26639.177189]  c1685eb8 c1689a00
ecacac14 c1689a00 c1042993 00000007 ecaca980 c13ee6c2
Aug 17 21:27:00 ubuntu kernel: [26639.177210]  c1773dbd 00001835
ecaca980 ee404c84 00000002 ecac2e80 c104a803 00000000
Aug 17 21:27:00 ubuntu kernel: [26639.177230] Call Trace:
Aug 17 21:27:00 ubuntu kernel: [26639.177239]  [<c1042993>] ?
refrigerator+0x72/0xdb
Aug 17 21:27:00 ubuntu kernel: [26639.177249]  [<c1042993>] ?
refrigerator+0x72/0xdb
Aug 17 21:27:00 ubuntu kernel: [26639.177259]  [<c13ee6c2>] ?
_spin_unlock_irq+0x22/0x45
Aug 17 21:27:00 ubuntu kernel: [26639.177269]  [<c104a803>] ?
trace_hardirqs_on+0xb/0xd
Aug 17 21:27:00 ubuntu kernel: [26639.177278]  [<c10429e5>]
refrigerator+0xc4/0xdb
Aug 17 21:27:00 ubuntu kernel: [26639.177288]  [<c1035b74>]
try_to_freeze+0x19/0x20
Aug 17 21:27:00 ubuntu kernel: [26639.177297]  [<c10371f0>]
get_signal_to_deliver+0x36/0x32e
Aug 17 21:27:00 ubuntu kernel: [26639.177307]  [<c1001fcd>]
do_notify_resume+0x77/0x735
Aug 17 21:27:00 ubuntu kernel: [26639.177317]  [<c11e5350>] ?
tty_ioctl+0x0/0x750
Aug 17 21:27:00 ubuntu kernel: [26639.177326]  [<c109ee36>] ?
vfs_ioctl+0x18/0x71
Aug 17 21:27:00 ubuntu kernel: [26639.177370]  [<c109f3af>] ?
do_vfs_ioctl+0x481/0x4bf
Aug 17 21:27:00 ubuntu kernel: [26639.177383]  [<c1157c9d>] ?
selinux_file_ioctl+0x3e/0x41
Aug 17 21:27:00 ubuntu kernel: [26639.177393]  [<c109f441>] ?
sys_ioctl+0x54/0x61
Aug 17 21:27:00 ubuntu kernel: [26639.177402]  [<c1002d96>]
work_notifysig+0x13/0x19
Aug 17 21:27:00 ubuntu kernel: [26639.177410] console-kit-d D 00001835
 2824  2308      1 0x00000000
Aug 17 21:27:00 ubuntu kernel: [26639.177424]  ecac3e8c 00000046
c1771b23 00001835 c1042993 ecacb674 c1689a00 00000046
Aug 17 21:27:00 ubuntu kernel: [26639.177445]  c1685eb8 c1689a00
ecacb674 c1689a00 c1042993 00000007 ecacb3e0 c13ee6c2
Aug 17 21:27:00 ubuntu kernel: [26639.177465]  c176f4e5 00001835
ecacb3e0 ee404c84 00000002 ecac3e80 c104a803 00000000
Aug 17 21:27:00 ubuntu kernel: [26639.177486] Call Trace:
Aug 17 21:27:00 ubuntu kernel: [26639.177495]  [<c1042993>] ?
refrigerator+0x72/0xdb
Aug 17 21:27:00 ubuntu kernel: [26639.177505]  [<c1042993>] ?
refrigerator+0x72/0xdb
Aug 17 21:27:00 ubuntu kernel: [26639.177514]  [<c13ee6c2>] ?
_spin_unlock_irq+0x22/0x45
Aug 17 21:27:00 ubuntu kernel: [26639.177524]  [<c104a803>] ?
trace_hardirqs_on+0xb/0xd
Aug 17 21:27:00 ubuntu kernel: [26639.177534]  [<c10429e5>]
refrigerator+0xc4/0xdb
Aug 17 21:27:00 ubuntu kernel: [26639.177544]  [<c1035b74>]
try_to_freeze+0x19/0x20
Aug 17 21:27:00 ubuntu kernel: [26639.177553]  [<c10371f0>]
get_signal_to_deliver+0x36/0x32e
Aug 17 21:27:00 ubuntu kernel: [26639.177563]  [<c1001fcd>]
do_notify_resume+0x77/0x735
Aug 17 21:27:00 ubuntu kernel: [26639.177573]  [<c11e5350>] ?
tty_ioctl+0x0/0x750
Aug 17 21:27:00 ubuntu kernel: [26639.177582]  [<c109ee36>] ?
vfs_ioctl+0x18/0x71
Aug 17 21:27:00 ubuntu kernel: [26639.177591]  [<c109f3af>] ?
do_vfs_ioctl+0x481/0x4bf
Aug 17 21:27:00 ubuntu kernel: [26639.177603]  [<c1157c9d>] ?
selinux_file_ioctl+0x3e/0x41
Aug 17 21:27:00 ubuntu kernel: [26639.177613]  [<c109f441>] ?
sys_ioctl+0x54/0x61
Aug 17 21:27:00 ubuntu kernel: [26639.177622]  [<c1002d96>]
work_notifysig+0x13/0x19
Aug 17 21:27:00 ubuntu kernel: [26639.177630] console-kit-d D 00001835
 2824  2309      1 0x00000000
Aug 17 21:27:00 ubuntu kernel: [26639.177643]  ecac4e8c 00000046
c176d16c 00001835 c1042993 ecacc0d4 c1689a00 00000046
Aug 17 21:27:00 ubuntu kernel: [26639.177664]  c1685eb8 c1689a00
ecacc0d4 c1689a00 c1042993 00000007 ecacbe40 c13ee6c2
Aug 17 21:27:00 ubuntu kernel: [26639.177685]  c176abcb 00001835
ecacbe40 ee404c84 00000002 ecac4e80 c104a803 00000000
Aug 17 21:27:00 ubuntu kernel: [26639.177705] Call Trace:
Aug 17 21:27:00 ubuntu kernel: [26639.177714]  [<c1042993>] ?
refrigerator+0x72/0xdb
Aug 17 21:27:00 ubuntu kernel: [26639.177724]  [<c1042993>] ?
refrigerator+0x72/0xdb
Aug 17 21:27:00 ubuntu kernel: [26639.177734]  [<c13ee6c2>] ?
_spin_unlock_irq+0x22/0x45
Aug 17 21:27:00 ubuntu kernel: [26639.177744]  [<c104a803>] ?
trace_hardirqs_on+0xb/0xd
Aug 17 21:27:00 ubuntu kernel: [26639.177753]  [<c10429e5>]
refrigerator+0xc4/0xdb
Aug 17 21:27:00 ubuntu kernel: [26639.177763]  [<c1035b74>]
try_to_freeze+0x19/0x20
Aug 17 21:27:00 ubuntu kernel: [26639.177772]  [<c10371f0>]
get_signal_to_deliver+0x36/0x32e
Aug 17 21:27:00 ubuntu kernel: [26639.177782]  [<c1001fcd>]
do_notify_resume+0x77/0x735
Aug 17 21:27:00 ubuntu kernel: [26639.177792]  [<c11e5350>] ?
tty_ioctl+0x0/0x750
Aug 17 21:27:00 ubuntu kernel: [26639.177801]  [<c109ee36>] ?
vfs_ioctl+0x18/0x71
Aug 17 21:27:00 ubuntu kernel: [26639.177810]  [<c109f3af>] ?
do_vfs_ioctl+0x481/0x4bf
Aug 17 21:27:00 ubuntu kernel: [26639.177822]  [<c1157c9d>] ?
selinux_file_ioctl+0x3e/0x41
Aug 17 21:27:00 ubuntu kernel: [26639.177831]  [<c109f441>] ?
sys_ioctl+0x54/0x61
Aug 17 21:27:00 ubuntu kernel: [26639.177841]  [<c1002d96>]
work_notifysig+0x13/0x19
Aug 17 21:27:00 ubuntu kernel: [26639.177848] console-kit-d D 00001835
 2824  2310      1 0x00000000
Aug 17 21:27:00 ubuntu kernel: [26639.177862]  ecac6e8c 00000046
c176854b 00001835 c1042993 ecaccb34 c1689a00 00000046
Aug 17 21:27:00 ubuntu kernel: [26639.177883]  c1685eb8 c1689a00
ecaccb34 c1689a00 c1042993 00000007 ecacc8a0 c13ee6c2
Aug 17 21:27:00 ubuntu kernel: [26639.177903]  c17660d0 00001835
ecacc8a0 ee404c84 00000002 ecac6e80 c104a803 00000000
Aug 17 21:27:00 ubuntu kernel: [26639.177924] Call Trace:
Aug 17 21:27:00 ubuntu kernel: [26639.177933]  [<c1042993>] ?
refrigerator+0x72/0xdb
Aug 17 21:27:00 ubuntu kernel: [26639.177943]  [<c1042993>] ?
refrigerator+0x72/0xdb
Aug 17 21:27:00 ubuntu kernel: [26639.177952]  [<c13ee6c2>] ?
_spin_unlock_irq+0x22/0x45
Aug 17 21:27:00 ubuntu kernel: [26639.177962]  [<c104a803>] ?
trace_hardirqs_on+0xb/0xd
Aug 17 21:27:00 ubuntu kernel: [26639.177972]  [<c10429e5>]
refrigerator+0xc4/0xdb
Aug 17 21:27:00 ubuntu kernel: [26639.177981]  [<c1035b74>]
try_to_freeze+0x19/0x20
Aug 17 21:27:00 ubuntu kernel: [26639.177990]  [<c10371f0>]
get_signal_to_deliver+0x36/0x32e
Aug 17 21:27:00 ubuntu kernel: [26639.178000]  [<c1001fcd>]
do_notify_resume+0x77/0x735
Aug 17 21:27:00 ubuntu kernel: [26639.178010]  [<c11e5350>] ?
tty_ioctl+0x0/0x750
Aug 17 21:27:00 ubuntu kernel: [26639.178020]  [<c109ee36>] ?
vfs_ioctl+0x18/0x71
Aug 17 21:27:00 ubuntu kernel: [26639.178029]  [<c109f3af>] ?
do_vfs_ioctl+0x481/0x4bf
Aug 17 21:27:00 ubuntu kernel: [26639.178041]  [<c1157c9d>] ?
selinux_file_ioctl+0x3e/0x41
Aug 17 21:27:00 ubuntu kernel: [26639.178050]  [<c109f441>] ?
sys_ioctl+0x54/0x61
Aug 17 21:27:00 ubuntu kernel: [26639.178059]  [<c1002d96>]
work_notifysig+0x13/0x19
Aug 17 21:27:00 ubuntu kernel: [26639.178067] console-kit-d D 00001835
 2824  2311      1 0x00000000
Aug 17 21:27:00 ubuntu kernel: [26639.178081]  ecac7e8c 00000046
c1763bad 00001835 c1042993 ecacd594 c1689a00 00000046
Aug 17 21:27:00 ubuntu kernel: [26639.178101]  c1685eb8 c1689a00
ecacd594 c1689a00 c1042993 00000007 ecacd300 c13ee6c2
Aug 17 21:27:00 ubuntu kernel: [26639.178122]  c1761232 00001835
ecacd300 ee404c84 00000002 ecac7e80 c104a803 00000000
Aug 17 21:27:00 ubuntu kernel: [26639.178142] Call Trace:
Aug 17 21:27:00 ubuntu kernel: [26639.178152]  [<c1042993>] ?
refrigerator+0x72/0xdb
Aug 17 21:27:00 ubuntu kernel: [26639.178161]  [<c1042993>] ?
refrigerator+0x72/0xdb
Aug 17 21:27:00 ubuntu kernel: [26639.178171]  [<c13ee6c2>] ?
_spin_unlock_irq+0x22/0x45
Aug 17 21:27:00 ubuntu kernel: [26639.178194]  [<c104a803>] ?
trace_hardirqs_on+0xb/0xd
Aug 17 21:27:00 ubuntu kernel: [26639.178208]  [<c10429e5>]
refrigerator+0xc4/0xdb
Aug 17 21:27:00 ubuntu kernel: [26639.178223]  [<c1035b74>]
try_to_freeze+0x19/0x20
Aug 17 21:27:00 ubuntu kernel: [26639.178236]  [<c10371f0>]
get_signal_to_deliver+0x36/0x32e
Aug 17 21:27:00 ubuntu kernel: [26639.178251]  [<c1001fcd>]
do_notify_resume+0x77/0x735
Aug 17 21:27:00 ubuntu kernel: [26639.178261]  [<c11e5350>] ?
tty_ioctl+0x0/0x750
Aug 17 21:27:00 ubuntu kernel: [26639.178270]  [<c109ee36>] ?
vfs_ioctl+0x18/0x71
Aug 17 21:27:00 ubuntu kernel: [26639.178279]  [<c109f3af>] ?
do_vfs_ioctl+0x481/0x4bf
Aug 17 21:27:00 ubuntu kernel: [26639.178291]  [<c1157c9d>] ?
selinux_file_ioctl+0x3e/0x41
Aug 17 21:27:00 ubuntu kernel: [26639.178300]  [<c109f441>] ?
sys_ioctl+0x54/0x61
Aug 17 21:27:00 ubuntu kernel: [26639.178310]  [<c1002d96>]
work_notifysig+0x13/0x19
Aug 17 21:27:00 ubuntu kernel: [26639.178317] console-kit-d D 00001835
 2824  2312      1 0x00000000
Aug 17 21:27:00 ubuntu kernel: [26639.178331]  ecad0e8c 00000046
c175ea87 00001835 c1042993 ecacdff4 c1689a00 00000046
Aug 17 21:27:00 ubuntu kernel: [26639.178352]  c1685eb8 c1689a00
ecacdff4 c1689a00 c1042993 00000007 ecacdd60 c13ee6c2
Aug 17 21:27:00 ubuntu kernel: [26639.178373]  c175c0e8 00001835
ecacdd60 ee404c84 00000002 ecad0e80 c104a803 00000000
Aug 17 21:27:00 ubuntu kernel: [26639.178393] Call Trace:
Aug 17 21:27:00 ubuntu kernel: [26639.178403]  [<c1042993>] ?
refrigerator+0x72/0xdb
Aug 17 21:27:00 ubuntu kernel: [26639.178413]  [<c1042993>] ?
refrigerator+0x72/0xdb
Aug 17 21:27:00 ubuntu kernel: [26639.178422]  [<c13ee6c2>] ?
_spin_unlock_irq+0x22/0x45
Aug 17 21:27:00 ubuntu kernel: [26639.178432]  [<c104a803>] ?
trace_hardirqs_on+0xb/0xd
Aug 17 21:27:00 ubuntu kernel: [26639.178442]  [<c10429e5>]
refrigerator+0xc4/0xdb
Aug 17 21:27:00 ubuntu kernel: [26639.178451]  [<c1035b74>]
try_to_freeze+0x19/0x20
Aug 17 21:27:00 ubuntu kernel: [26639.178460]  [<c10371f0>]
get_signal_to_deliver+0x36/0x32e
Aug 17 21:27:00 ubuntu kernel: [26639.178470]  [<c1001fcd>]
do_notify_resume+0x77/0x735
Aug 17 21:27:00 ubuntu kernel: [26639.178480]  [<c11e5350>] ?
tty_ioctl+0x0/0x750
Aug 17 21:27:00 ubuntu kernel: [26639.178489]  [<c109ee36>] ?
vfs_ioctl+0x18/0x71
Aug 17 21:27:00 ubuntu kernel: [26639.178499]  [<c109f3af>] ?
do_vfs_ioctl+0x481/0x4bf
Aug 17 21:27:00 ubuntu kernel: [26639.178510]  [<c1157c9d>] ?
selinux_file_ioctl+0x3e/0x41
Aug 17 21:27:00 ubuntu kernel: [26639.178520]  [<c109f441>] ?
sys_ioctl+0x54/0x61
Aug 17 21:27:00 ubuntu kernel: [26639.178529]  [<c1002d96>]
work_notifysig+0x13/0x19
Aug 17 21:27:00 ubuntu kernel: [26639.178537] console-kit-d D 00001835
 2824  2313      1 0x00000000
Aug 17 21:27:00 ubuntu kernel: [26639.178551]  ecad1e8c 00000046
c175968a 00001835 c1042993 ecacea54 c1689a00 00000046
Aug 17 21:27:00 ubuntu kernel: [26639.178571]  c1685eb8 c1689a00
ecacea54 c1689a00 c1042993 00000007 ecace7c0 c13ee6c2
Aug 17 21:27:00 ubuntu kernel: [26639.178592]  c1756a63 00001835
ecace7c0 ee404c84 00000002 ecad1e80 c104a803 00000000
Aug 17 21:27:00 ubuntu kernel: [26639.178612] Call Trace:
Aug 17 21:27:00 ubuntu kernel: [26639.178621]  [<c1042993>] ?
refrigerator+0x72/0xdb
Aug 17 21:27:00 ubuntu kernel: [26639.178631]  [<c1042993>] ?
refrigerator+0x72/0xdb
Aug 17 21:27:00 ubuntu kernel: [26639.178641]  [<c13ee6c2>] ?
_spin_unlock_irq+0x22/0x45
Aug 17 21:27:00 ubuntu kernel: [26639.178651]  [<c104a803>] ?
trace_hardirqs_on+0xb/0xd
Aug 17 21:27:00 ubuntu kernel: [26639.178660]  [<c10429e5>]
refrigerator+0xc4/0xdb
Aug 17 21:27:00 ubuntu kernel: [26639.178670]  [<c1035b74>]
try_to_freeze+0x19/0x20
Aug 17 21:27:00 ubuntu kernel: [26639.178679]  [<c10371f0>]
get_signal_to_deliver+0x36/0x32e
Aug 17 21:27:00 ubuntu kernel: [26639.178689]  [<c1001fcd>]
do_notify_resume+0x77/0x735
Aug 17 21:27:00 ubuntu kernel: [26639.178699]  [<c11e5350>] ?
tty_ioctl+0x0/0x750
Aug 17 21:27:00 ubuntu kernel: [26639.178708]  [<c109ee36>] ?
vfs_ioctl+0x18/0x71
Aug 17 21:27:00 ubuntu kernel: [26639.178717]  [<c109f3af>] ?
do_vfs_ioctl+0x481/0x4bf
Aug 17 21:27:00 ubuntu kernel: [26639.178729]  [<c1157c9d>] ?
selinux_file_ioctl+0x3e/0x41
Aug 17 21:27:00 ubuntu kernel: [26639.178738]  [<c109f441>] ?
sys_ioctl+0x54/0x61
Aug 17 21:27:00 ubuntu kernel: [26639.178748]  [<c1002d96>]
work_notifysig+0x13/0x19
Aug 17 21:27:00 ubuntu kernel: [26639.178755] console-kit-d D 00001835
 2824  2314      1 0x00000000
Aug 17 21:27:00 ubuntu kernel: [26639.178769]  ecad2e8c 00000046
c1754160 00001835 c1042993 ecacf4b4 c1689a00 00000046
Aug 17 21:27:00 ubuntu kernel: [26639.178790]  c1685eb8 c1689a00
ecacf4b4 c1689a00 c1042993 00000007 ecacf220 c13ee6c2
Aug 17 21:27:00 ubuntu kernel: [26639.178810]  c17517d4 00001835
ecacf220 ee404c84 00000002 ecad2e80 c104a803 00000000
Aug 17 21:27:00 ubuntu kernel: [26639.178831] Call Trace:
Aug 17 21:27:00 ubuntu kernel: [26639.178840]  [<c1042993>] ?
refrigerator+0x72/0xdb
Aug 17 21:27:00 ubuntu kernel: [26639.178850]  [<c1042993>] ?
refrigerator+0x72/0xdb
Aug 17 21:27:00 ubuntu kernel: [26639.178859]  [<c13ee6c2>] ?
_spin_unlock_irq+0x22/0x45
Aug 17 21:27:00 ubuntu kernel: [26639.178869]  [<c104a803>] ?
trace_hardirqs_on+0xb/0xd
Aug 17 21:27:00 ubuntu kernel: [26639.178879]  [<c10429e5>]
refrigerator+0xc4/0xdb
Aug 17 21:27:00 ubuntu kernel: [26639.178888]  [<c1035b74>]
try_to_freeze+0x19/0x20
Aug 17 21:27:00 ubuntu kernel: [26639.178897]  [<c10371f0>]
get_signal_to_deliver+0x36/0x32e
Aug 17 21:27:00 ubuntu kernel: [26639.178907]  [<c1001fcd>]
do_notify_resume+0x77/0x735
Aug 17 21:27:00 ubuntu kernel: [26639.178917]  [<c11e5350>] ?
tty_ioctl+0x0/0x750
Aug 17 21:27:00 ubuntu kernel: [26639.178926]  [<c109ee36>] ?
vfs_ioctl+0x18/0x71
Aug 17 21:27:00 ubuntu kernel: [26639.178936]  [<c109f3af>] ?
do_vfs_ioctl+0x481/0x4bf
Aug 17 21:27:00 ubuntu kernel: [26639.178947]  [<c1157c9d>] ?
selinux_file_ioctl+0x3e/0x41
Aug 17 21:27:00 ubuntu kernel: [26639.178957]  [<c109f441>] ?
sys_ioctl+0x54/0x61
Aug 17 21:27:00 ubuntu kernel: [26639.178966]  [<c1002d96>]
work_notifysig+0x13/0x19
Aug 17 21:27:00 ubuntu kernel: [26639.178974] console-kit-d D 00001835
 2824  2315      1 0x00000000
Aug 17 21:27:00 ubuntu kernel: [26639.178988]  ecad3e8c 00000046
c174f1a8 00001835 c1042993 ecaf0294 c1689a00 00000046
Aug 17 21:27:00 ubuntu kernel: [26639.179008]  c1685eb8 c1689a00
ecaf0294 c1689a00 c1042993 00000007 ecaf0000 c13ee6c2
Aug 17 21:27:00 ubuntu kernel: [26639.179029]  c174c214 00001835
ecaf0000 ee404c84 00000002 ecad3e80 c104a803 00000000
Aug 17 21:27:00 ubuntu kernel: [26639.179049] Call Trace:
Aug 17 21:27:00 ubuntu kernel: [26639.179059]  [<c1042993>] ?
refrigerator+0x72/0xdb
Aug 17 21:27:00 ubuntu kernel: [26639.179068]  [<c1042993>] ?
refrigerator+0x72/0xdb
Aug 17 21:27:00 ubuntu kernel: [26639.179078]  [<c13ee6c2>] ?
_spin_unlock_irq+0x22/0x45
Aug 17 21:27:00 ubuntu kernel: [26639.179088]  [<c104a803>] ?
trace_hardirqs_on+0xb/0xd
Aug 17 21:27:00 ubuntu kernel: [26639.179097]  [<c10429e5>]
refrigerator+0xc4/0xdb
Aug 17 21:27:00 ubuntu kernel: [26639.179107]  [<c1035b74>]
try_to_freeze+0x19/0x20
Aug 17 21:27:00 ubuntu kernel: [26639.179116]  [<c10371f0>]
get_signal_to_deliver+0x36/0x32e
Aug 17 21:27:00 ubuntu kernel: [26639.179126]  [<c1001fcd>]
do_notify_resume+0x77/0x735
Aug 17 21:27:00 ubuntu kernel: [26639.179136]  [<c11e5350>] ?
tty_ioctl+0x0/0x750
Aug 17 21:27:00 ubuntu kernel: [26639.179145]  [<c109ee36>] ?
vfs_ioctl+0x18/0x71
Aug 17 21:27:00 ubuntu kernel: [26639.179154]  [<c109f3af>] ?
do_vfs_ioctl+0x481/0x4bf
Aug 17 21:27:00 ubuntu kernel: [26639.179166]  [<c1157c9d>] ?
selinux_file_ioctl+0x3e/0x41
Aug 17 21:27:01 ubuntu kernel: [26639.179175]  [<c109f441>] ?
sys_ioctl+0x54/0x61
Aug 17 21:27:01 ubuntu kernel: [26639.179185]  [<c1002d96>]
work_notifysig+0x13/0x19
Aug 17 21:27:01 ubuntu kernel: [26639.179192] console-kit-d D 00001835
 2824  2316      1 0x00000000
Aug 17 21:27:01 ubuntu kernel: [26639.179206]  ecad4e8c 00000046
c17497ec 00001835 c1042993 ecaf0cf4 c1689a00 00000046
Aug 17 21:27:01 ubuntu kernel: [26639.179227]  c1685eb8 c1689a00
ecaf0cf4 c1689a00 c1042993 00000007 ecaf0a60 c13ee6c2
Aug 17 21:27:01 ubuntu kernel: [26639.179247]  c1746df9 00001835
ecaf0a60 ee404c84 00000002 ecad4e80 c104a803 00000000
Aug 17 21:27:01 ubuntu kernel: [26639.179268] Call Trace:
Aug 17 21:27:01 ubuntu kernel: [26639.179277]  [<c1042993>] ?
refrigerator+0x72/0xdb
Aug 17 21:27:01 ubuntu kernel: [26639.179287]  [<c1042993>] ?
refrigerator+0x72/0xdb
Aug 17 21:27:01 ubuntu kernel: [26639.179296]  [<c13ee6c2>] ?
_spin_unlock_irq+0x22/0x45
Aug 17 21:27:01 ubuntu kernel: [26639.179306]  [<c104a803>] ?
trace_hardirqs_on+0xb/0xd
Aug 17 21:27:01 ubuntu kernel: [26639.179316]  [<c10429e5>]
refrigerator+0xc4/0xdb
Aug 17 21:27:01 ubuntu kernel: [26639.179325]  [<c1035b74>]
try_to_freeze+0x19/0x20
Aug 17 21:27:01 ubuntu kernel: [26639.179334]  [<c10371f0>]
get_signal_to_deliver+0x36/0x32e
Aug 17 21:27:01 ubuntu kernel: [26639.179344]  [<c1001fcd>]
do_notify_resume+0x77/0x735
Aug 17 21:27:01 ubuntu kernel: [26639.179354]  [<c11e5350>] ?
tty_ioctl+0x0/0x750
Aug 17 21:27:01 ubuntu kernel: [26639.179363]  [<c109ee36>] ?
vfs_ioctl+0x18/0x71
Aug 17 21:27:01 ubuntu kernel: [26639.179373]  [<c109f3af>] ?
do_vfs_ioctl+0x481/0x4bf
Aug 17 21:27:01 ubuntu kernel: [26639.179384]  [<c1157c9d>] ?
selinux_file_ioctl+0x3e/0x41
Aug 17 21:27:01 ubuntu kernel: [26639.179394]  [<c109f441>] ?
sys_ioctl+0x54/0x61
Aug 17 21:27:01 ubuntu kernel: [26639.179403]  [<c1002d96>]
work_notifysig+0x13/0x19
Aug 17 21:27:01 ubuntu kernel: [26639.179411] console-kit-d D 00001835
 2824  2317      1 0x00000000
Aug 17 21:27:01 ubuntu kernel: [26639.179424]  ecad5e8c 00000046
c1744726 00001835 c1042993 ecaf1754 c1689a00 00000046
Aug 17 21:27:01 ubuntu kernel: [26639.179445]  c1685eb8 c1689a00
ecaf1754 c1689a00 c1042993 00000007 ecaf14c0 c13ee6c2
Aug 17 21:27:01 ubuntu kernel: [26639.179466]  c174174a 00001835
ecaf14c0 ee404c84 00000002 ecad5e80 c104a803 00000000
Aug 17 21:27:01 ubuntu kernel: [26639.179486] Call Trace:
Aug 17 21:27:01 ubuntu kernel: [26639.179495]  [<c1042993>] ?
refrigerator+0x72/0xdb
Aug 17 21:27:01 ubuntu kernel: [26639.179505]  [<c1042993>] ?
refrigerator+0x72/0xdb
Aug 17 21:27:01 ubuntu kernel: [26639.179515]  [<c13ee6c2>] ?
_spin_unlock_irq+0x22/0x45
Aug 17 21:27:01 ubuntu kernel: [26639.179525]  [<c104a803>] ?
trace_hardirqs_on+0xb/0xd
Aug 17 21:27:01 ubuntu kernel: [26639.179534]  [<c10429e5>]
refrigerator+0xc4/0xdb
Aug 17 21:27:01 ubuntu kernel: [26639.179544]  [<c1035b74>]
try_to_freeze+0x19/0x20
Aug 17 21:27:01 ubuntu kernel: [26639.179553]  [<c10371f0>]
get_signal_to_deliver+0x36/0x32e
Aug 17 21:27:01 ubuntu kernel: [26639.179563]  [<c1001fcd>]
do_notify_resume+0x77/0x735
Aug 17 21:27:01 ubuntu kernel: [26639.179573]  [<c11e5350>] ?
tty_ioctl+0x0/0x750
Aug 17 21:27:01 ubuntu kernel: [26639.179582]  [<c109ee36>] ?
vfs_ioctl+0x18/0x71
Aug 17 21:27:01 ubuntu kernel: [26639.179591]  [<c109f3af>] ?
do_vfs_ioctl+0x481/0x4bf
Aug 17 21:27:01 ubuntu kernel: [26639.179603]  [<c1157c9d>] ?
selinux_file_ioctl+0x3e/0x41
Aug 17 21:27:01 ubuntu kernel: [26639.179612]  [<c109f441>] ?
sys_ioctl+0x54/0x61
Aug 17 21:27:01 ubuntu kernel: [26639.179622]  [<c1002d96>]
work_notifysig+0x13/0x19
Aug 17 21:27:01 ubuntu kernel: [26639.179629] console-kit-d D 00001835
 2824  2318      1 0x00000000
Aug 17 21:27:01 ubuntu kernel: [26639.179643]  ecad7e8c 00000046
c173ee7e 00001835 c1042993 ecaf21b4 c1689a00 00000046
Aug 17 21:27:01 ubuntu kernel: [26639.179664]  c1685eb8 c1689a00
ecaf21b4 c1689a00 c1042993 00000007 ecaf1f20 c13ee6c2
Aug 17 21:27:01 ubuntu kernel: [26639.179684]  c173c401 00001835
ecaf1f20 ee404c84 00000002 ecad7e80 c104a803 00000000
Aug 17 21:27:01 ubuntu kernel: [26639.179705] Call Trace:
Aug 17 21:27:01 ubuntu kernel: [26639.179714]  [<c1042993>] ?
refrigerator+0x72/0xdb
Aug 17 21:27:01 ubuntu kernel: [26639.179724]  [<c1042993>] ?
refrigerator+0x72/0xdb
Aug 17 21:27:01 ubuntu kernel: [26639.179733]  [<c13ee6c2>] ?
_spin_unlock_irq+0x22/0x45
Aug 17 21:27:01 ubuntu kernel: [26639.179743]  [<c104a803>] ?
trace_hardirqs_on+0xb/0xd
Aug 17 21:27:01 ubuntu kernel: [26639.179753]  [<c10429e5>]
refrigerator+0xc4/0xdb
Aug 17 21:27:01 ubuntu kernel: [26639.179762]  [<c1035b74>]
try_to_freeze+0x19/0x20
Aug 17 21:27:01 ubuntu kernel: [26639.179771]  [<c10371f0>]
get_signal_to_deliver+0x36/0x32e
Aug 17 21:27:01 ubuntu kernel: [26639.179781]  [<c1001fcd>]
do_notify_resume+0x77/0x735
Aug 17 21:27:01 ubuntu kernel: [26639.179791]  [<c11e5350>] ?
tty_ioctl+0x0/0x750
Aug 17 21:27:01 ubuntu kernel: [26639.179800]  [<c109ee36>] ?
vfs_ioctl+0x18/0x71
Aug 17 21:27:01 ubuntu kernel: [26639.179810]  [<c109f3af>] ?
do_vfs_ioctl+0x481/0x4bf
Aug 17 21:27:01 ubuntu kernel: [26639.179821]  [<c1157c9d>] ?
selinux_file_ioctl+0x3e/0x41
Aug 17 21:27:01 ubuntu kernel: [26639.179831]  [<c109f441>] ?
sys_ioctl+0x54/0x61
Aug 17 21:27:01 ubuntu kernel: [26639.179840]  [<c1002d96>]
work_notifysig+0x13/0x19
Aug 17 21:27:01 ubuntu kernel: [26639.179848] console-kit-d D 00001835
 2824  2319      1 0x00000000
Aug 17 21:27:01 ubuntu kernel: [26639.179861]  ecad8e8c 00000046
c1739c97 00001835 c1042993 ecaf2c14 c1689a00 00000046
Aug 17 21:27:01 ubuntu kernel: [26639.179882]  c1685eb8 c1689a00
ecaf2c14 c1689a00 c1042993 00000007 ecaf2980 c13ee6c2
Aug 17 21:27:01 ubuntu kernel: [26639.179903]  c17370fa 00001835
ecaf2980 ee404c84 00000002 ecad8e80 c104a803 00000000
Aug 17 21:27:01 ubuntu kernel: [26639.179923] Call Trace:
Aug 17 21:27:01 ubuntu kernel: [26639.179932]  [<c1042993>] ?
refrigerator+0x72/0xdb
Aug 17 21:27:01 ubuntu kernel: [26639.179942]  [<c1042993>] ?
refrigerator+0x72/0xdb
Aug 17 21:27:01 ubuntu kernel: [26639.179952]  [<c13ee6c2>] ?
_spin_unlock_irq+0x22/0x45
Aug 17 21:27:01 ubuntu kernel: [26639.179962]  [<c104a803>] ?
trace_hardirqs_on+0xb/0xd
Aug 17 21:27:01 ubuntu kernel: [26639.179971]  [<c10429e5>]
refrigerator+0xc4/0xdb
Aug 17 21:27:01 ubuntu kernel: [26639.179981]  [<c1035b74>]
try_to_freeze+0x19/0x20
Aug 17 21:27:01 ubuntu kernel: [26639.179990]  [<c10371f0>]
get_signal_to_deliver+0x36/0x32e
Aug 17 21:27:01 ubuntu kernel: [26639.180000]  [<c1001fcd>]
do_notify_resume+0x77/0x735
Aug 17 21:27:01 ubuntu kernel: [26639.180010]  [<c11e5350>] ?
tty_ioctl+0x0/0x750
Aug 17 21:27:01 ubuntu kernel: [26639.180019]  [<c109ee36>] ?
vfs_ioctl+0x18/0x71
Aug 17 21:27:01 ubuntu kernel: [26639.180028]  [<c109f3af>] ?
do_vfs_ioctl+0x481/0x4bf
Aug 17 21:27:01 ubuntu kernel: [26639.180040]  [<c1157c9d>] ?
selinux_file_ioctl+0x3e/0x41
Aug 17 21:27:01 ubuntu kernel: [26639.180049]  [<c109f441>] ?
sys_ioctl+0x54/0x61
Aug 17 21:27:01 ubuntu kernel: [26639.180059]  [<c1002d96>]
work_notifysig+0x13/0x19
Aug 17 21:27:01 ubuntu kernel: [26639.180066] console-kit-d D 00001835
 2824  2320      1 0x00000000
Aug 17 21:27:01 ubuntu kernel: [26639.180080]  ecad9e8c 00000046
c1734a99 00001835 c1042993 ecaf3674 c1689a00 00000046
Aug 17 21:27:01 ubuntu kernel: [26639.180101]  c1685eb8 c1689a00
ecaf3674 c1689a00 c1042993 00000007 ecaf33e0 c13ee6c2
Aug 17 21:27:01 ubuntu kernel: [26639.180122]  c1731f44 00001835
ecaf33e0 ee404c84 00000002 ecad9e80 c104a803 00000000
Aug 17 21:27:01 ubuntu kernel: [26639.180142] Call Trace:
Aug 17 21:27:01 ubuntu kernel: [26639.180151]  [<c1042993>] ?
refrigerator+0x72/0xdb
Aug 17 21:27:01 ubuntu kernel: [26639.180161]  [<c1042993>] ?
refrigerator+0x72/0xdb
Aug 17 21:27:01 ubuntu kernel: [26639.180170]  [<c13ee6c2>] ?
_spin_unlock_irq+0x22/0x45
Aug 17 21:27:01 ubuntu kernel: [26639.180180]  [<c104a803>] ?
trace_hardirqs_on+0xb/0xd
Aug 17 21:27:01 ubuntu kernel: [26639.180190]  [<c10429e5>]
refrigerator+0xc4/0xdb
Aug 17 21:27:01 ubuntu kernel: [26639.180200]  [<c1035b74>]
try_to_freeze+0x19/0x20
Aug 17 21:27:01 ubuntu kernel: [26639.180208]  [<c10371f0>]
get_signal_to_deliver+0x36/0x32e
Aug 17 21:27:01 ubuntu kernel: [26639.180218]  [<c1001fcd>]
do_notify_resume+0x77/0x735
Aug 17 21:27:01 ubuntu kernel: [26639.180229]  [<c11e5350>] ?
tty_ioctl+0x0/0x750
Aug 17 21:27:01 ubuntu kernel: [26639.180238]  [<c109ee36>] ?
vfs_ioctl+0x18/0x71
Aug 17 21:27:01 ubuntu kernel: [26639.180247]  [<c109f3af>] ?
do_vfs_ioctl+0x481/0x4bf
Aug 17 21:27:01 ubuntu kernel: [26639.180259]  [<c1157c9d>] ?
selinux_file_ioctl+0x3e/0x41
Aug 17 21:27:01 ubuntu kernel: [26639.180268]  [<c109f441>] ?
sys_ioctl+0x54/0x61
Aug 17 21:27:01 ubuntu kernel: [26639.180277]  [<c1002d96>]
work_notifysig+0x13/0x19
Aug 17 21:27:01 ubuntu kernel: [26639.180285] console-kit-d D 00001835
 2824  2439      1 0x00000000
Aug 17 21:27:01 ubuntu kernel: [26639.180299]  ec7e8e8c 00000046
c172f7da 00001835 c1042993 ec520cf4 c1689a00 00000046
Aug 17 21:27:01 ubuntu kernel: [26639.180320]  c1685eb8 c1689a00
ec520cf4 c1689a00 c1042993 00000007 ec520a60 c13ee6c2
Aug 17 21:27:01 ubuntu kernel: [26639.180340]  c172cc01 00001835
ec520a60 ee404c84 00000002 ec7e8e80 c104a803 00000000
Aug 17 21:27:01 ubuntu kernel: [26639.180361] Call Trace:
Aug 17 21:27:01 ubuntu kernel: [26639.180370]  [<c1042993>] ?
refrigerator+0x72/0xdb
Aug 17 21:27:01 ubuntu kernel: [26639.180380]  [<c1042993>] ?
refrigerator+0x72/0xdb
Aug 17 21:27:01 ubuntu kernel: [26639.180389]  [<c13ee6c2>] ?
_spin_unlock_irq+0x22/0x45
Aug 17 21:27:01 ubuntu kernel: [26639.180399]  [<c104a803>] ?
trace_hardirqs_on+0xb/0xd
Aug 17 21:27:01 ubuntu kernel: [26639.180409]  [<c10429e5>]
refrigerator+0xc4/0xdb
Aug 17 21:27:01 ubuntu kernel: [26639.180418]  [<c1035b74>]
try_to_freeze+0x19/0x20
Aug 17 21:27:01 ubuntu kernel: [26639.180427]  [<c10371f0>]
get_signal_to_deliver+0x36/0x32e
Aug 17 21:27:01 ubuntu kernel: [26639.180437]  [<c1001fcd>]
do_notify_resume+0x77/0x735
Aug 17 21:27:01 ubuntu kernel: [26639.180447]  [<c11e5350>] ?
tty_ioctl+0x0/0x750
Aug 17 21:27:01 ubuntu kernel: [26639.180456]  [<c109ee36>] ?
vfs_ioctl+0x18/0x71
Aug 17 21:27:01 ubuntu kernel: [26639.180466]  [<c109f3af>] ?
do_vfs_ioctl+0x481/0x4bf
Aug 17 21:27:01 ubuntu kernel: [26639.180477]  [<c1157c9d>] ?
selinux_file_ioctl+0x3e/0x41
Aug 17 21:27:01 ubuntu kernel: [26639.180487]  [<c109f441>] ?
sys_ioctl+0x54/0x61
Aug 17 21:27:01 ubuntu kernel: [26639.180496]  [<c1002d96>]
work_notifysig+0x13/0x19
Aug 17 21:27:01 ubuntu kernel: [26639.180504] console-kit-d D 00001835
 2812  2725      1 0x00000000
Aug 17 21:27:01 ubuntu kernel: [26639.180518]  eabbee8c 00000046
c13d56b4 00001835 c1042993 ec4f21b4 c1689a00 00000046
Aug 17 21:27:01 ubuntu kernel: [26639.180539]  c1685eb8 c1689a00
ec4f21b4 c1689a00 c1042993 00000007 ec4f1f20 c13ee6c2
Aug 17 21:27:01 ubuntu kernel: [26639.180559]  c13d5344 00001835
ec4f1f20 ee404c84 00000002 eabbee80 c104a803 00000000
Aug 17 21:27:01 ubuntu kernel: [26639.180579] Call Trace:
Aug 17 21:27:01 ubuntu kernel: [26639.180589]  [<c13d56b4>] ?
ieee80211_get_bssid+0x80/0x85
Aug 17 21:27:01 ubuntu kernel: [26639.180599]  [<c1042993>] ?
refrigerator+0x72/0xdb
Aug 17 21:27:01 ubuntu kernel: [26639.180609]  [<c1042993>] ?
refrigerator+0x72/0xdb
Aug 17 21:27:01 ubuntu kernel: [26639.180618]  [<c13ee6c2>] ?
_spin_unlock_irq+0x22/0x45
Aug 17 21:27:01 ubuntu kernel: [26639.180627]  [<c13d5344>] ? T.699+0x14/0x26
Aug 17 21:27:01 ubuntu kernel: [26639.180636]  [<c104a803>] ?
trace_hardirqs_on+0xb/0xd
Aug 17 21:27:01 ubuntu kernel: [26639.180646]  [<c10429e5>]
refrigerator+0xc4/0xdb
Aug 17 21:27:01 ubuntu kernel: [26639.180655]  [<c1035b74>]
try_to_freeze+0x19/0x20
Aug 17 21:27:01 ubuntu kernel: [26639.180664]  [<c10371f0>]
get_signal_to_deliver+0x36/0x32e
Aug 17 21:27:01 ubuntu kernel: [26639.180710]  [<c1001fcd>]
do_notify_resume+0x77/0x735
Aug 17 21:27:01 ubuntu kernel: [26639.180720]  [<c1157a57>] ?
file_has_perm+0x87/0xa1
Aug 17 21:27:01 ubuntu kernel: [26639.180731]  [<c103ccb5>] ?
autoremove_wake_function+0x0/0x2f
Aug 17 21:27:01 ubuntu kernel: [26639.180742]  [<c1157ce4>] ?
selinux_file_permission+0x44/0x48
Aug 17 21:27:01 ubuntu kernel: [26639.180752]  [<c1154346>] ?
security_file_permission+0xf/0x11
Aug 17 21:27:01 ubuntu kernel: [26639.180762]  [<c109490a>] ?
rw_verify_area+0x98/0xbb
Aug 17 21:27:01 ubuntu kernel: [26639.180771]  [<c109478e>] ?
do_sync_read+0x0/0xe4
Aug 17 21:27:01 ubuntu kernel: [26639.180780]  [<c1094e62>] ? vfs_read+0x7d/0xdc
Aug 17 21:27:01 ubuntu kernel: [26639.180788]  [<c1094463>] ? fput_light+0xc/0xe
Aug 17 21:27:01 ubuntu kernel: [26639.180797]  [<c1094f6d>] ? sys_read+0x53/0x5d
Aug 17 21:27:01 ubuntu kernel: [26639.180807]  [<c1002d96>]
work_notifysig+0x13/0x19
Aug 17 21:27:01 ubuntu kernel: [26639.180814] console-kit-d D 00001835
 2824 11089      1 0x00000000
Aug 17 21:27:01 ubuntu kernel: [26639.180829]  f2d0de8c 00000046
c172a09a 00001835 c1042993 df3f0294 c1689a00 00000046
Aug 17 21:27:01 ubuntu kernel: [26639.180849]  c1685eb8 c1689a00
df3f0294 c1689a00 c1042993 00000007 df3f0000 c13ee6c2
Aug 17 21:27:01 ubuntu kernel: [26639.180870]  c172722d 00001835
df3f0000 ee404c84 00000002 f2d0de80 c104a803 00000000
Aug 17 21:27:01 ubuntu kernel: [26639.180890] Call Trace:
Aug 17 21:27:01 ubuntu kernel: [26639.180900]  [<c1042993>] ?
refrigerator+0x72/0xdb
Aug 17 21:27:01 ubuntu kernel: [26639.180910]  [<c1042993>] ?
refrigerator+0x72/0xdb
Aug 17 21:27:01 ubuntu kernel: [26639.180919]  [<c13ee6c2>] ?
_spin_unlock_irq+0x22/0x45
Aug 17 21:27:01 ubuntu kernel: [26639.180929]  [<c104a803>] ?
trace_hardirqs_on+0xb/0xd
Aug 17 21:27:01 ubuntu kernel: [26639.180939]  [<c10429e5>]
refrigerator+0xc4/0xdb
Aug 17 21:27:01 ubuntu kernel: [26639.180948]  [<c1035b74>]
try_to_freeze+0x19/0x20
Aug 17 21:27:01 ubuntu kernel: [26639.180957]  [<c10371f0>]
get_signal_to_deliver+0x36/0x32e
Aug 17 21:27:01 ubuntu kernel: [26639.180967]  [<c1001fcd>]
do_notify_resume+0x77/0x735
Aug 17 21:27:01 ubuntu kernel: [26639.180978]  [<c11e5350>] ?
tty_ioctl+0x0/0x750
Aug 17 21:27:01 ubuntu kernel: [26639.180987]  [<c109ee36>] ?
vfs_ioctl+0x18/0x71
Aug 17 21:27:01 ubuntu kernel: [26639.180996]  [<c109f3af>] ?
do_vfs_ioctl+0x481/0x4bf
Aug 17 21:27:01 ubuntu kernel: [26639.181008]  [<c1157c9d>] ?
selinux_file_ioctl+0x3e/0x41
Aug 17 21:27:01 ubuntu kernel: [26639.181017]  [<c109f441>] ?
sys_ioctl+0x54/0x61
Aug 17 21:27:01 ubuntu kernel: [26639.181026]  [<c1002d96>]
work_notifysig+0x13/0x19
Aug 17 21:27:01 ubuntu kernel: [26639.181034] gdm-binary    D 00001835
 2096  2434      1 0x00000000
Aug 17 21:27:01 ubuntu kernel: [26639.181048]  ec614e8c 00000046
c15e077b 00001835 c1042993 ec523674 c1689a00 00000046
Aug 17 21:27:01 ubuntu kernel: [26639.181068]  c1685eb8 c1689a00
ec523674 c1689a00 c1042993 00000007 ec5233e0 c13ee6c2
Aug 17 21:27:01 ubuntu kernel: [26639.181089]  c13d9753 00001835
ec5233e0 eebf0a84 00000002 ec614e80 c104a803 00000000
Aug 17 21:27:01 ubuntu kernel: [26639.181109] Call Trace:
Aug 17 21:27:01 ubuntu kernel: [26639.181119]  [<c1042993>] ?
refrigerator+0x72/0xdb
Aug 17 21:27:01 ubuntu kernel: [26639.181129]  [<c1042993>] ?
refrigerator+0x72/0xdb
Aug 17 21:27:01 ubuntu kernel: [26639.181138]  [<c13ee6c2>] ?
_spin_unlock_irq+0x22/0x45
Aug 17 21:27:01 ubuntu kernel: [26639.181147]  [<c13d9753>] ?
trace_kmalloc+0x36/0x63
Aug 17 21:27:01 ubuntu kernel: [26639.181157]  [<c104a803>] ?
trace_hardirqs_on+0xb/0xd
Aug 17 21:27:01 ubuntu kernel: [26639.181167]  [<c10429e5>]
refrigerator+0xc4/0xdb
Aug 17 21:27:01 ubuntu kernel: [26639.181176]  [<c1035b74>]
try_to_freeze+0x19/0x20
Aug 17 21:27:01 ubuntu kernel: [26639.181185]  [<c10371f0>]
get_signal_to_deliver+0x36/0x32e
Aug 17 21:27:01 ubuntu kernel: [26639.181195]  [<c1001fcd>]
do_notify_resume+0x77/0x735
Aug 17 21:27:01 ubuntu kernel: [26639.181204]  [<c1157a57>] ?
file_has_perm+0x87/0xa1
Aug 17 21:27:01 ubuntu kernel: [26639.181215]  [<c103ccb5>] ?
autoremove_wake_function+0x0/0x2f
Aug 17 21:27:01 ubuntu kernel: [26639.181226]  [<c1157ce4>] ?
selinux_file_permission+0x44/0x48
Aug 17 21:27:01 ubuntu kernel: [26639.181235]  [<c1154346>] ?
security_file_permission+0xf/0x11
Aug 17 21:27:01 ubuntu kernel: [26639.181244]  [<c109490a>] ?
rw_verify_area+0x98/0xbb
Aug 17 21:27:01 ubuntu kernel: [26639.181254]  [<c1094e70>] ? vfs_read+0x8b/0xdc
Aug 17 21:27:01 ubuntu kernel: [26639.181264]  [<c10a0e1a>] ? sys_poll+0x42/0x8b
Aug 17 21:27:01 ubuntu kernel: [26639.181273]  [<c1002d96>]
work_notifysig+0x13/0x19
Aug 17 21:27:01 ubuntu kernel: [26639.181281] gdm-simple-sl D 00001835
 2044  2437   2434 0x00000000
Aug 17 21:27:01 ubuntu kernel: [26639.181294]  ec653e8c 00000046
c13dc570 00001835 c1042993 ec530294 c1689a00 00000046
Aug 17 21:27:01 ubuntu kernel: [26639.181315]  c1685eb8 c1689a00
ec530294 c1689a00 c1042993 00000007 ec530000 c13ee6c2
Aug 17 21:27:01 ubuntu kernel: [26639.181336]  c13db819 00001835
ec530000 f630d204 00000002 ec653e80 c104a803 00000000
Aug 17 21:27:01 ubuntu kernel: [26639.181356] Call Trace:
Aug 17 21:27:01 ubuntu kernel: [26639.181365]  [<c13dc570>] ?
rfkill_dev_uevent+0x14/0xad
Aug 17 21:27:01 ubuntu kernel: [26639.181374]  [<c1042993>] ?
refrigerator+0x72/0xdb
Aug 17 21:27:01 ubuntu kernel: [26639.181384]  [<c1042993>] ?
refrigerator+0x72/0xdb
Aug 17 21:27:01 ubuntu kernel: [26639.181394]  [<c13ee6c2>] ?
_spin_unlock_irq+0x22/0x45
Aug 17 21:27:01 ubuntu kernel: [26639.181404]  [<c13db819>] ?
netlbl_cipsov4_list+0x255/0x32a
Aug 17 21:27:01 ubuntu kernel: [26639.181413]  [<c104a803>] ?
trace_hardirqs_on+0xb/0xd
Aug 17 21:27:01 ubuntu kernel: [26639.181423]  [<c10429e5>]
refrigerator+0xc4/0xdb
Aug 17 21:27:01 ubuntu kernel: [26639.181433]  [<c1035b74>]
try_to_freeze+0x19/0x20
Aug 17 21:27:01 ubuntu kernel: [26639.181441]  [<c10371f0>]
get_signal_to_deliver+0x36/0x32e
Aug 17 21:27:01 ubuntu kernel: [26639.181452]  [<c1001fcd>]
do_notify_resume+0x77/0x735
Aug 17 21:27:01 ubuntu kernel: [26639.181461]  [<c1157a57>] ?
file_has_perm+0x87/0xa1
Aug 17 21:27:01 ubuntu kernel: [26639.181472]  [<c103ccb5>] ?
autoremove_wake_function+0x0/0x2f
Aug 17 21:27:01 ubuntu kernel: [26639.181482]  [<c1157ce4>] ?
selinux_file_permission+0x44/0x48
Aug 17 21:27:01 ubuntu kernel: [26639.181492]  [<c1154346>] ?
security_file_permission+0xf/0x11
Aug 17 21:27:01 ubuntu kernel: [26639.181501]  [<c109490a>] ?
rw_verify_area+0x98/0xbb
Aug 17 21:27:01 ubuntu kernel: [26639.181524]  [<c1094e70>] ? vfs_read+0x8b/0xdc
Aug 17 21:27:01 ubuntu kernel: [26639.181538]  [<c10a0e1a>] ? sys_poll+0x42/0x8b
Aug 17 21:27:01 ubuntu kernel: [26639.181552]  [<c1002d96>]
work_notifysig+0x13/0x19
Aug 17 21:27:01 ubuntu kernel: [26639.181563] Xorg          D 00001835
 1684  2438   2437 0x00400000
Aug 17 21:27:01 ubuntu kernel: [26639.181580]  ec4cde8c 00000046
c15fe276 00001835 c1042993 ec522c14 c1689a00 00000046
Aug 17 21:27:01 ubuntu kernel: [26639.181601]  c1685eb8 c1689a00
ec522c14 c1689a00 c1042993 00000007 ec522980 c13ee6c2
Aug 17 21:27:01 ubuntu kernel: [26639.181622]  c1530102 00001835
ec522980 eebf5204 00000002 ec4cde80 c104a803 00000000
Aug 17 21:27:01 ubuntu kernel: [26639.181642] Call Trace:
Aug 17 21:27:01 ubuntu kernel: [26639.181652]  [<c1042993>] ?
refrigerator+0x72/0xdb
Aug 17 21:27:01 ubuntu kernel: [26639.181662]  [<c1042993>] ?
refrigerator+0x72/0xdb
Aug 17 21:27:01 ubuntu kernel: [26639.181672]  [<c13ee6c2>] ?
_spin_unlock_irq+0x22/0x45
Aug 17 21:27:01 ubuntu kernel: [26639.181682]  [<c104a803>] ?
trace_hardirqs_on+0xb/0xd
Aug 17 21:27:01 ubuntu kernel: [26639.181692]  [<c10429e5>]
refrigerator+0xc4/0xdb
Aug 17 21:27:01 ubuntu kernel: [26639.181701]  [<c1035b74>]
try_to_freeze+0x19/0x20
Aug 17 21:27:01 ubuntu kernel: [26639.181710]  [<c10371f0>]
get_signal_to_deliver+0x36/0x32e
Aug 17 21:27:01 ubuntu kernel: [26639.181720]  [<c1001fcd>]
do_notify_resume+0x77/0x735
Aug 17 21:27:01 ubuntu kernel: [26639.181731]  [<c104a803>] ?
trace_hardirqs_on+0xb/0xd
Aug 17 21:27:01 ubuntu kernel: [26639.181741]  [<c13ee6d9>] ?
_spin_unlock_irq+0x39/0x45
Aug 17 21:27:01 ubuntu kernel: [26639.181751]  [<c102f361>] ?
do_setitimer+0x161/0x2ac
Aug 17 21:27:01 ubuntu kernel: [26639.181762]  [<c10a0913>] ?
sys_select+0x7c/0x86
Aug 17 21:27:01 ubuntu kernel: [26639.181772]  [<c1002d96>]
work_notifysig+0x13/0x19
Aug 17 21:27:01 ubuntu kernel: [26639.181779] NetworkManage D 00001835
 1880  2455      1 0x00000000
Aug 17 21:27:01 ubuntu kernel: [26639.181792]  ebebbe8c 00000046
c15ebf56 00001835 c1042993 ec520294 c1689a00 00000046
Aug 17 21:27:01 ubuntu kernel: [26639.181813]  c1685eb8 c1689a00
ec520294 c1689a00 c1042993 00000007 ec520000 c13ee6c2
Aug 17 21:27:01 ubuntu kernel: [26639.181834]  c13ddeda 00001835
ec520000 eebf2604 00000002 ebebbe80 c104a803 00000000
Aug 17 21:27:01 ubuntu kernel: [26639.181854] Call Trace:
Aug 17 21:27:01 ubuntu kernel: [26639.181863]  [<c1042993>] ?
refrigerator+0x72/0xdb
Aug 17 21:27:01 ubuntu kernel: [26639.181873]  [<c1042993>] ?
refrigerator+0x72/0xdb
Aug 17 21:27:01 ubuntu kernel: [26639.181883]  [<c13ee6c2>] ?
_spin_unlock_irq+0x22/0x45
Aug 17 21:27:01 ubuntu kernel: [26639.181892]  [<c13ddeda>] ?
init_memory_mapping+0x234/0x2e5
Aug 17 21:27:01 ubuntu kernel: [26639.181902]  [<c104a803>] ?
trace_hardirqs_on+0xb/0xd
Aug 17 21:27:01 ubuntu kernel: [26639.181912]  [<c10429e5>]
refrigerator+0xc4/0xdb
Aug 17 21:27:02 ubuntu kernel: [26639.181921]  [<c1035b74>]
try_to_freeze+0x19/0x20
Aug 17 21:27:02 ubuntu kernel: [26639.181930]  [<c10371f0>]
get_signal_to_deliver+0x36/0x32e
Aug 17 21:27:02 ubuntu kernel: [26639.181940]  [<c1001fcd>]
do_notify_resume+0x77/0x735
Aug 17 21:27:02 ubuntu kernel: [26639.181950]  [<c1094592>] ?
fsnotify_modify+0x4f/0x5a
Aug 17 21:27:02 ubuntu kernel: [26639.181960]  [<c10952f9>] ?
do_readv_writev+0xd2/0xdf
Aug 17 21:27:02 ubuntu kernel: [26639.181970]  [<c1095813>] ?
__rcu_read_lock+0x0/0x2b
Aug 17 21:27:02 ubuntu kernel: [26639.181981]  [<c10a0e1a>] ? sys_poll+0x42/0x8b
Aug 17 21:27:02 ubuntu kernel: [26639.181990]  [<c1002d96>]
work_notifysig+0x13/0x19
Aug 17 21:27:02 ubuntu kernel: [26639.181998] NetworkManage D 00001835
 3080  3207      1 0x00000000
Aug 17 21:27:02 ubuntu kernel: [26639.182012]  e196ce8c 00000046
c13e0b35 00001835 c1042993 e2791754 c1689a00 00000046
Aug 17 21:27:02 ubuntu kernel: [26639.182033]  c1685eb8 c1689a00
e2791754 c1689a00 c1042993 00000007 e27914c0 c13ee6c2
Aug 17 21:27:02 ubuntu kernel: [26639.182053]  c13ce66c 00001835
e27914c0 eebf2604 00000002 e196ce80 c104a803 00000000
Aug 17 21:27:02 ubuntu kernel: [26639.182073] Call Trace:
Aug 17 21:27:02 ubuntu kernel: [26639.182083]  [<c13e0b35>] ?
quirk_e100_interrupt+0x121/0x145
Aug 17 21:27:02 ubuntu kernel: [26639.182092]  [<c1042993>] ?
refrigerator+0x72/0xdb
Aug 17 21:27:02 ubuntu kernel: [26639.182102]  [<c1042993>] ?
refrigerator+0x72/0xdb
Aug 17 21:27:02 ubuntu kernel: [26639.182112]  [<c13ee6c2>] ?
_spin_unlock_irq+0x22/0x45
Aug 17 21:27:02 ubuntu kernel: [26639.182122]  [<c13ce66c>] ?
michael_block+0x44/0x4b
Aug 17 21:27:02 ubuntu kernel: [26639.182131]  [<c104a803>] ?
trace_hardirqs_on+0xb/0xd
Aug 17 21:27:02 ubuntu kernel: [26639.182141]  [<c10429e5>]
refrigerator+0xc4/0xdb
Aug 17 21:27:02 ubuntu kernel: [26639.182151]  [<c1035b74>]
try_to_freeze+0x19/0x20
Aug 17 21:27:02 ubuntu kernel: [26639.182159]  [<c10371f0>]
get_signal_to_deliver+0x36/0x32e
Aug 17 21:27:02 ubuntu kernel: [26639.182169]  [<c1001fcd>]
do_notify_resume+0x77/0x735
Aug 17 21:27:02 ubuntu kernel: [26639.182179]  [<c1157a57>] ?
file_has_perm+0x87/0xa1
Aug 17 21:27:02 ubuntu kernel: [26639.182190]  [<c103ccb5>] ?
autoremove_wake_function+0x0/0x2f
Aug 17 21:27:02 ubuntu kernel: [26639.182200]  [<c1157ce4>] ?
selinux_file_permission+0x44/0x48
Aug 17 21:27:02 ubuntu kernel: [26639.182210]  [<c1154346>] ?
security_file_permission+0xf/0x11
Aug 17 21:27:02 ubuntu kernel: [26639.182219]  [<c109490a>] ?
rw_verify_area+0x98/0xbb
Aug 17 21:27:02 ubuntu kernel: [26639.182228]  [<c109478e>] ?
do_sync_read+0x0/0xe4
Aug 17 21:27:02 ubuntu kernel: [26639.182237]  [<c1094e62>] ? vfs_read+0x7d/0xdc
Aug 17 21:27:02 ubuntu kernel: [26639.182245]  [<c1094463>] ? fput_light+0xc/0xe
Aug 17 21:27:02 ubuntu kernel: [26639.182254]  [<c1094f6d>] ? sys_read+0x53/0x5d
Aug 17 21:27:02 ubuntu kernel: [26639.182263]  [<c1002d96>]
work_notifysig+0x13/0x19
Aug 17 21:27:02 ubuntu kernel: [26639.182271] modem-manager D 00001835
 2096  2459      1 0x00000000
Aug 17 21:27:02 ubuntu kernel: [26639.182284]  ec7dde8c 00000046
c15f73f0 00001835 c1042993 ec525594 c1689a00 00000046
Aug 17 21:27:02 ubuntu kernel: [26639.182305]  c1685eb8 c1689a00
ec525594 c1689a00 c1042993 00000007 ec525300 c13ee6c2
Aug 17 21:27:02 ubuntu kernel: [26639.182326]  c13e033d 00001835
ec525300 eebf2b84 00000002 ec7dde80 c104a803 00000000
Aug 17 21:27:02 ubuntu kernel: [26639.182346] Call Trace:
Aug 17 21:27:02 ubuntu kernel: [26639.182355]  [<c1042993>] ?
refrigerator+0x72/0xdb
Aug 17 21:27:02 ubuntu kernel: [26639.182365]  [<c1042993>] ?
refrigerator+0x72/0xdb
Aug 17 21:27:02 ubuntu kernel: [26639.182375]  [<c13ee6c2>] ?
_spin_unlock_irq+0x22/0x45
Aug 17 21:27:02 ubuntu kernel: [26639.182384]  [<c13e033d>] ?
quirk_p64h2_1k_io+0x7c/0x85
Aug 17 21:27:02 ubuntu kernel: [26639.182393]  [<c104a803>] ?
trace_hardirqs_on+0xb/0xd
Aug 17 21:27:02 ubuntu kernel: [26639.182403]  [<c10429e5>]
refrigerator+0xc4/0xdb
Aug 17 21:27:02 ubuntu kernel: [26639.182413]  [<c1035b74>]
try_to_freeze+0x19/0x20
Aug 17 21:27:02 ubuntu kernel: [26639.182421]  [<c10371f0>]
get_signal_to_deliver+0x36/0x32e
Aug 17 21:27:02 ubuntu kernel: [26639.182432]  [<c1001fcd>]
do_notify_resume+0x77/0x735
Aug 17 21:27:02 ubuntu kernel: [26639.182443]  [<c103ccb5>] ?
autoremove_wake_function+0x0/0x2f
Aug 17 21:27:02 ubuntu kernel: [26639.182453]  [<c1157ce4>] ?
selinux_file_permission+0x44/0x48
Aug 17 21:27:02 ubuntu kernel: [26639.182463]  [<c1154346>] ?
security_file_permission+0xf/0x11
Aug 17 21:27:02 ubuntu kernel: [26639.182472]  [<c109490a>] ?
rw_verify_area+0x98/0xbb
Aug 17 21:27:02 ubuntu kernel: [26639.182481]  [<c1094e70>] ? vfs_read+0x8b/0xdc
Aug 17 21:27:02 ubuntu kernel: [26639.182491]  [<c10a0e1a>] ? sys_poll+0x42/0x8b
Aug 17 21:27:02 ubuntu kernel: [26639.182500]  [<c1002d96>]
work_notifysig+0x13/0x19
Aug 17 21:27:02 ubuntu kernel: [26639.182508] wpa_supplican D 00001835
 1908  2469      1 0x00000000
Aug 17 21:27:02 ubuntu kernel: [26639.182521]  ed4bde8c 00200046
c15fbb1d 00001835 c1042993 ec535ff4 c1689a00 00200046
Aug 17 21:27:02 ubuntu kernel: [26639.182542]  c1685eb8 c1689a00
ec535ff4 c1689a00 c1042993 00000007 ec535d60 c13ee6c2
Aug 17 21:27:02 ubuntu kernel: [26639.182562]  c13e27f5 00001835
ec535d60 f630dd04 00000002 ed4bde80 c104a803 00000000
Aug 17 21:27:02 ubuntu kernel: [26639.182583] Call Trace:
Aug 17 21:27:02 ubuntu kernel: [26639.182592]  [<c1042993>] ?
refrigerator+0x72/0xdb
Aug 17 21:27:02 ubuntu kernel: [26639.182602]  [<c1042993>] ?
refrigerator+0x72/0xdb
Aug 17 21:27:02 ubuntu kernel: [26639.182611]  [<c13ee6c2>] ?
_spin_unlock_irq+0x22/0x45
Aug 17 21:27:02 ubuntu kernel: [26639.182621]  [<c13e27f5>] ?
piix_init_one+0x3c8/0x613
Aug 17 21:27:02 ubuntu kernel: [26639.182631]  [<c104a803>] ?
trace_hardirqs_on+0xb/0xd
Aug 17 21:27:02 ubuntu kernel: [26639.182640]  [<c10429e5>]
refrigerator+0xc4/0xdb
Aug 17 21:27:02 ubuntu kernel: [26639.182650]  [<c1035b74>]
try_to_freeze+0x19/0x20
Aug 17 21:27:02 ubuntu kernel: [26639.182658]  [<c10371f0>]
get_signal_to_deliver+0x36/0x32e
Aug 17 21:27:02 ubuntu kernel: [26639.182669]  [<c1001fcd>]
do_notify_resume+0x77/0x735
Aug 17 21:27:02 ubuntu kernel: [26639.182679]  [<c10905be>] ?
kmem_cache_free+0x98/0xea
Aug 17 21:27:02 ubuntu kernel: [26639.182688]  [<c10a145e>] ? __d_free+0x38/0x3b
Aug 17 21:27:02 ubuntu kernel: [26639.182697]  [<c104a7d0>] ?
trace_hardirqs_on_caller+0x108/0x130
Aug 17 21:27:02 ubuntu kernel: [26639.182706]  [<c104a803>] ?
trace_hardirqs_on+0xb/0xd
Aug 17 21:27:02 ubuntu kernel: [26639.182716]  [<c10a145e>] ? __d_free+0x38/0x3b
Aug 17 21:27:02 ubuntu kernel: [26639.182725]  [<c10a145e>] ? __d_free+0x38/0x3b
Aug 17 21:27:02 ubuntu kernel: [26639.182734]  [<c10a1486>] ? d_free+0x25/0x37
Aug 17 21:27:02 ubuntu kernel: [26639.182744]  [<c10a67e3>] ?
mntput_no_expire+0x19/0x8d
Aug 17 21:27:02 ubuntu kernel: [26639.182754]  [<c10a0913>] ?
sys_select+0x7c/0x86
Aug 17 21:27:02 ubuntu kernel: [26639.182764]  [<c1002d96>]
work_notifysig+0x13/0x19
Aug 17 21:27:02 ubuntu kernel: [26639.182772] avahi-daemon  D 00001835
 1768  2481      1 0x00000000
Aug 17 21:27:02 ubuntu kernel: [26639.182785]  ebfa8e8c 00000046
c1605053 00001835 c1042993 ec526a54 c1689a00 00000046
Aug 17 21:27:02 ubuntu kernel: [26639.182805]  c1685eb8 c1689a00
ec526a54 c1689a00 c1042993 00000007 ec5267c0 c13ee6c2
Aug 17 21:27:02 ubuntu kernel: [26639.182826]  c13e4c2e 00001835
ec5267c0 eebf5784 00000002 ebfa8e80 c104a803 00000000
Aug 17 21:27:02 ubuntu kernel: [26639.182846] Call Trace:
Aug 17 21:27:02 ubuntu kernel: [26639.182856]  [<c1042993>] ?
refrigerator+0x72/0xdb
Aug 17 21:27:02 ubuntu kernel: [26639.182866]  [<c1042993>] ?
refrigerator+0x72/0xdb
Aug 17 21:27:02 ubuntu kernel: [26639.182875]  [<c13ee6c2>] ?
_spin_unlock_irq+0x22/0x45
Aug 17 21:27:02 ubuntu kernel: [26639.182885]  [<c13e4c2e>] ?
pci_fixup_umc_ide+0x9/0x44
Aug 17 21:27:02 ubuntu kernel: [26639.182894]  [<c104a803>] ?
trace_hardirqs_on+0xb/0xd
Aug 17 21:27:02 ubuntu kernel: [26639.182904]  [<c10429e5>]
refrigerator+0xc4/0xdb
Aug 17 21:27:02 ubuntu kernel: [26639.182914]  [<c1035b74>]
try_to_freeze+0x19/0x20
Aug 17 21:27:02 ubuntu kernel: [26639.182922]  [<c10371f0>]
get_signal_to_deliver+0x36/0x32e
Aug 17 21:27:02 ubuntu kernel: [26639.182932]  [<c1001fcd>]
do_notify_resume+0x77/0x735
Aug 17 21:27:02 ubuntu kernel: [26639.182942]  [<c1157a57>] ?
file_has_perm+0x87/0xa1
Aug 17 21:27:02 ubuntu kernel: [26639.182953]  [<c103ccb5>] ?
autoremove_wake_function+0x0/0x2f
Aug 17 21:27:02 ubuntu kernel: [26639.182963]  [<c1094538>] ?
fsnotify_access+0x4f/0x5a
Aug 17 21:27:02 ubuntu kernel: [26639.182973]  [<c109478e>] ?
do_sync_read+0x0/0xe4
Aug 17 21:27:02 ubuntu kernel: [26639.182981]  [<c1094e82>] ? vfs_read+0x9d/0xdc
Aug 17 21:27:02 ubuntu kernel: [26639.182991]  [<c10a0e1a>] ? sys_poll+0x42/0x8b
Aug 17 21:27:02 ubuntu kernel: [26639.183000]  [<c1002d96>]
work_notifysig+0x13/0x19
Aug 17 21:27:02 ubuntu kernel: [26639.183008] avahi-daemon  D 00001835
 2712  2482   2481 0x00000000
Aug 17 21:27:02 ubuntu kernel: [26639.183021]  ebfabe8c 00000046
c160b4b6 00001835 c1042993 ec525ff4 c1689a00 00000046
Aug 17 21:27:02 ubuntu kernel: [26639.183042]  c1685eb8 c1689a00
ec525ff4 c1689a00 c1042993 00000007 ec525d60 c13ee6c2
Aug 17 21:27:02 ubuntu kernel: [26639.183063]  c13fae74 00001835
ec525d60 eebf1b04 00000002 ebfabe80 c104a803 00000000
Aug 17 21:27:02 ubuntu kernel: [26639.183083] Call Trace:
Aug 17 21:27:02 ubuntu kernel: [26639.183093]  [<c1042993>] ?
refrigerator+0x72/0xdb
Aug 17 21:27:02 ubuntu kernel: [26639.183103]  [<c1042993>] ?
refrigerator+0x72/0xdb
Aug 17 21:27:02 ubuntu kernel: [26639.183112]  [<c13ee6c2>] ?
_spin_unlock_irq+0x22/0x45
Aug 17 21:27:02 ubuntu kernel: [26639.183122]  [<c104a803>] ?
trace_hardirqs_on+0xb/0xd
Aug 17 21:27:02 ubuntu kernel: [26639.183132]  [<c10429e5>]
refrigerator+0xc4/0xdb
Aug 17 21:27:02 ubuntu kernel: [26639.183141]  [<c1035b74>]
try_to_freeze+0x19/0x20
Aug 17 21:27:02 ubuntu kernel: [26639.183150]  [<c10371f0>]
get_signal_to_deliver+0x36/0x32e
Aug 17 21:27:02 ubuntu kernel: [26639.183160]  [<c1001fcd>]
do_notify_resume+0x77/0x735
Aug 17 21:27:02 ubuntu kernel: [26639.183169]  [<c1157a57>] ?
file_has_perm+0x87/0xa1
Aug 17 21:27:02 ubuntu kernel: [26639.183180]  [<c103ccb5>] ?
autoremove_wake_function+0x0/0x2f
Aug 17 21:27:02 ubuntu kernel: [26639.183191]  [<c1157ce4>] ?
selinux_file_permission+0x44/0x48
Aug 17 21:27:02 ubuntu kernel: [26639.183200]  [<c1154346>] ?
security_file_permission+0xf/0x11
Aug 17 21:27:02 ubuntu kernel: [26639.183209]  [<c109490a>] ?
rw_verify_area+0x98/0xbb
Aug 17 21:27:02 ubuntu kernel: [26639.183219]  [<c1094e70>] ? vfs_read+0x8b/0xdc
Aug 17 21:27:02 ubuntu kernel: [26639.183228]  [<c1094f6d>] ? sys_read+0x53/0x5d
Aug 17 21:27:02 ubuntu kernel: [26639.183237]  [<c1002d96>]
work_notifysig+0x13/0x19
Aug 17 21:27:02 ubuntu kernel: [26639.183245] cupsd         D 00001835
 2108  2507      1 0x00000000
Aug 17 21:27:02 ubuntu kernel: [26639.183258]  eb52fe8c 00000046
c13eb7c2 00001835 c1042993 ec5374b4 c1689a00 00000046
Aug 17 21:27:02 ubuntu kernel: [26639.183279]  c1685eb8 c1689a00
ec5374b4 c1689a00 c1042993 00000007 ec537220 c13ee6c2
Aug 17 21:27:02 ubuntu kernel: [26639.183300]  c13ea488 00001835
ec537220 f630bc04 00000002 eb52fe80 c104a803 00000000
Aug 17 21:27:02 ubuntu kernel: [26639.183320] Call Trace:
Aug 17 21:27:02 ubuntu kernel: [26639.183329]  [<c13eb7c2>] ?
slab_cpuup_callback+0xf2/0x105
Aug 17 21:27:02 ubuntu kernel: [26639.183339]  [<c1042993>] ?
refrigerator+0x72/0xdb
Aug 17 21:27:02 ubuntu kernel: [26639.183348]  [<c1042993>] ?
refrigerator+0x72/0xdb
Aug 17 21:27:02 ubuntu kernel: [26639.183358]  [<c13ee6c2>] ?
_spin_unlock_irq+0x22/0x45
Aug 17 21:27:02 ubuntu kernel: [26639.183366]  [<c13ea488>] ?
init_smp_flush+0x26/0x2a
Aug 17 21:27:02 ubuntu kernel: [26639.183376]  [<c104a803>] ?
trace_hardirqs_on+0xb/0xd
Aug 17 21:27:02 ubuntu kernel: [26639.183386]  [<c10429e5>]
refrigerator+0xc4/0xdb
Aug 17 21:27:02 ubuntu kernel: [26639.183395]  [<c1035b74>]
try_to_freeze+0x19/0x20
Aug 17 21:27:02 ubuntu kernel: [26639.183404]  [<c10371f0>]
get_signal_to_deliver+0x36/0x32e
Aug 17 21:27:02 ubuntu kernel: [26639.183414]  [<c1020716>] ?
need_resched+0x14/0x1e
Aug 17 21:27:02 ubuntu kernel: [26639.183423]  [<c1001fcd>]
do_notify_resume+0x77/0x735
Aug 17 21:27:02 ubuntu kernel: [26639.183434]  [<c118b700>] ?
debug_object_activate+0xca/0xe6
Aug 17 21:27:02 ubuntu kernel: [26639.183445]  [<c10b956f>] ?
sys_epoll_wait+0x152/0x1dc
Aug 17 21:27:02 ubuntu kernel: [26639.183455]  [<c10b956f>] ?
sys_epoll_wait+0x152/0x1dc
Aug 17 21:27:02 ubuntu kernel: [26639.183464]  [<c13ee67b>] ?
_spin_unlock_irqrestore+0x36/0x5b
Aug 17 21:27:02 ubuntu kernel: [26639.183474]  [<c104a7d0>] ?
trace_hardirqs_on_caller+0x108/0x130
Aug 17 21:27:02 ubuntu kernel: [26639.183484]  [<c104a803>] ?
trace_hardirqs_on+0xb/0xd
Aug 17 21:27:02 ubuntu kernel: [26639.183493]  [<c13ee693>] ?
_spin_unlock_irqrestore+0x4e/0x5b
Aug 17 21:27:02 ubuntu kernel: [26639.183503]  [<c10b95ef>] ?
sys_epoll_wait+0x1d2/0x1dc
Aug 17 21:27:02 ubuntu kernel: [26639.183513]  [<c10252f5>] ?
default_wake_function+0x0/0xd
Aug 17 21:27:02 ubuntu kernel: [26639.183523]  [<c1002d96>]
work_notifysig+0x13/0x19
Aug 17 21:27:02 ubuntu kernel: [26639.183530] atd           D 00001835
 2816  2605      1 0x00000000
Aug 17 21:27:02 ubuntu kernel: [26639.183544]  eb2b3e8c 00000046
c13f217f 00001835 c1042993 ec524b34 c1689a00 00000046
Aug 17 21:27:02 ubuntu kernel: [26639.183565]  c1685eb8 c1689a00
ec524b34 c1689a00 c1042993 00000007 ec5248a0 c13ee6c2
Aug 17 21:27:02 ubuntu kernel: [26639.183585]  c13f08c1 00001835
ec5248a0 eebf3684 00000002 eb2b3e80 c104a803 00000000
Aug 17 21:27:02 ubuntu kernel: [26639.183606] Call Trace:
Aug 17 21:27:02 ubuntu kernel: [26639.183615]  [<c1042993>] ?
refrigerator+0x72/0xdb
Aug 17 21:27:02 ubuntu kernel: [26639.183625]  [<c1042993>] ?
refrigerator+0x72/0xdb
Aug 17 21:27:02 ubuntu kernel: [26639.183634]  [<c13ee6c2>] ?
_spin_unlock_irq+0x22/0x45
Aug 17 21:27:02 ubuntu kernel: [26639.183644]  [<c104a803>] ?
trace_hardirqs_on+0xb/0xd
Aug 17 21:27:02 ubuntu kernel: [26639.183654]  [<c10429e5>]
refrigerator+0xc4/0xdb
Aug 17 21:27:02 ubuntu kernel: [26639.183663]  [<c1035b74>]
try_to_freeze+0x19/0x20
Aug 17 21:27:02 ubuntu kernel: [26639.183672]  [<c10371f0>]
get_signal_to_deliver+0x36/0x32e
Aug 17 21:27:02 ubuntu kernel: [26639.183682]  [<c1001fcd>]
do_notify_resume+0x77/0x735
Aug 17 21:27:02 ubuntu kernel: [26639.183692]  [<c118b78a>] ?
free_object+0x6e/0x81
Aug 17 21:27:02 ubuntu kernel: [26639.183702]  [<c103f087>] ?
destroy_hrtimer_on_stack+0xd/0xf
Aug 17 21:27:02 ubuntu kernel: [26639.183712]  [<c103fcdb>] ?
hrtimer_nanosleep+0xcb/0xe6
Aug 17 21:27:02 ubuntu kernel: [26639.183721]  [<c107e7e3>] ?
might_fault+0x4b/0x88
Aug 17 21:27:02 ubuntu kernel: [26639.183731]  [<c103f35c>] ?
hrtimer_wakeup+0x0/0x1c
Aug 17 21:27:02 ubuntu kernel: [26639.183742]  [<c1002d96>]
work_notifysig+0x13/0x19
Aug 17 21:27:02 ubuntu kernel: [26639.183750] cron          D 00001835
 2696  2637      1 0x00000000
Aug 17 21:27:02 ubuntu kernel: [26639.183763]  eafb3e8c 00000046
c14b9187 00001835 c1042993 ec4f74b4 c1689a00 00000046
Aug 17 21:27:02 ubuntu kernel: [26639.183784]  c1685eb8 c1689a00
ec4f74b4 c1689a00 c1042993 00000007 ec4f7220 c13ee6c2
Aug 17 21:27:02 ubuntu kernel: [26639.183805]  c1410e9e 00001835
ec4f7220 f6308504 00000002 eafb3e80 c104a803 00000000
Aug 17 21:27:02 ubuntu kernel: [26639.183825] Call Trace:
Aug 17 21:27:02 ubuntu kernel: [26639.183834]  [<c1042993>] ?
refrigerator+0x72/0xdb
Aug 17 21:27:02 ubuntu kernel: [26639.183844]  [<c1042993>] ?
refrigerator+0x72/0xdb
Aug 17 21:27:02 ubuntu kernel: [26639.183854]  [<c13ee6c2>] ?
_spin_unlock_irq+0x22/0x45
Aug 17 21:27:02 ubuntu kernel: [26639.183864]  [<c104a803>] ?
trace_hardirqs_on+0xb/0xd
Aug 17 21:27:02 ubuntu kernel: [26639.183873]  [<c10429e5>]
refrigerator+0xc4/0xdb
Aug 17 21:27:02 ubuntu kernel: [26639.183883]  [<c1035b74>]
try_to_freeze+0x19/0x20
Aug 17 21:27:02 ubuntu kernel: [26639.183892]  [<c10371f0>]
get_signal_to_deliver+0x36/0x32e
Aug 17 21:27:02 ubuntu kernel: [26639.183902]  [<c1001fcd>]
do_notify_resume+0x77/0x735
Aug 17 21:27:02 ubuntu kernel: [26639.183911]  [<c118b78a>] ?
free_object+0x6e/0x81
Aug 17 21:27:02 ubuntu kernel: [26639.183921]  [<c103f087>] ?
destroy_hrtimer_on_stack+0xd/0xf
Aug 17 21:27:02 ubuntu kernel: [26639.183931]  [<c103fcdb>] ?
hrtimer_nanosleep+0xcb/0xe6
Aug 17 21:27:02 ubuntu kernel: [26639.183941]  [<c107e7e3>] ?
might_fault+0x4b/0x88
Aug 17 21:27:02 ubuntu kernel: [26639.183951]  [<c103f35c>] ?
hrtimer_wakeup+0x0/0x1c
Aug 17 21:27:02 ubuntu kernel: [26639.183962]  [<c1002d96>]
work_notifysig+0x13/0x19
Aug 17 21:27:02 ubuntu kernel: [26639.183970] dbus-launch   D 00001835
 2212  2808      1 0x00000000
Aug 17 21:27:02 ubuntu kernel: [26639.183983]  eab8ce8c 00000046
c13f5f9e 00001835 c1042993 ec535594 c1689a00 00000046
Aug 17 21:27:02 ubuntu kernel: [26639.184041]  c1685eb8 c1689a00
ec535594 c1689a00 c1042993 00000007 ec535300 c13ee6c2
Aug 17 21:27:02 ubuntu kernel: [26639.184062]  c13f4813 00001835
ec535300 f600f304 00000002 eab8ce80 c104a803 00000000
Aug 17 21:27:02 ubuntu kernel: [26639.184083] Call Trace:
Aug 17 21:27:02 ubuntu kernel: [26639.184093]  [<c1042993>] ?
refrigerator+0x72/0xdb
Aug 17 21:27:02 ubuntu kernel: [26639.184103]  [<c1042993>] ?
refrigerator+0x72/0xdb
Aug 17 21:27:02 ubuntu kernel: [26639.184112]  [<c13ee6c2>] ?
_spin_unlock_irq+0x22/0x45
Aug 17 21:27:02 ubuntu kernel: [26639.184122]  [<c104a803>] ?
trace_hardirqs_on+0xb/0xd
Aug 17 21:27:02 ubuntu kernel: [26639.184132]  [<c10429e5>]
refrigerator+0xc4/0xdb
Aug 17 21:27:02 ubuntu kernel: [26639.184142]  [<c1035b74>]
try_to_freeze+0x19/0x20
Aug 17 21:27:02 ubuntu kernel: [26639.184150]  [<c10371f0>]
get_signal_to_deliver+0x36/0x32e
Aug 17 21:27:02 ubuntu kernel: [26639.184161]  [<c1001fcd>]
do_notify_resume+0x77/0x735
Aug 17 21:27:02 ubuntu kernel: [26639.184170]  [<c1157a57>] ?
file_has_perm+0x87/0xa1
Aug 17 21:27:02 ubuntu kernel: [26639.184181]  [<c103ccb5>] ?
autoremove_wake_function+0x0/0x2f
Aug 17 21:27:02 ubuntu kernel: [26639.184191]  [<c1157ce4>] ?
selinux_file_permission+0x44/0x48
Aug 17 21:27:02 ubuntu kernel: [26639.184201]  [<c1154346>] ?
security_file_permission+0xf/0x11
Aug 17 21:27:02 ubuntu kernel: [26639.184210]  [<c109490a>] ?
rw_verify_area+0x98/0xbb
Aug 17 21:27:02 ubuntu kernel: [26639.184220]  [<c10a0913>] ?
sys_select+0x7c/0x86
Aug 17 21:27:02 ubuntu kernel: [26639.184230]  [<c1002d96>]
work_notifysig+0x13/0x19
Aug 17 21:27:02 ubuntu kernel: [26639.184238] getty         D 00001835
 2808  2814      1 0x00000000
Aug 17 21:27:02 ubuntu kernel: [26639.184252]  eab93e8c 00000046
c13fc1bb 00001835 c1042993 ec533674 c1689a00 00000046
Aug 17 21:27:02 ubuntu kernel: [26639.184273]  c1685eb8 c1689a00
ec533674 c1689a00 c1042993 00000007 ec5333e0 c13ee6c2
Aug 17 21:27:02 ubuntu kernel: [26639.184293]  c13f8782 00001835
ec5333e0 f6009b04 00000002 eab93e80 c104a803 00000000
Aug 17 21:27:02 ubuntu kernel: [26639.184314] Call Trace:
Aug 17 21:27:02 ubuntu kernel: [26639.184323]  [<c1042993>] ?
refrigerator+0x72/0xdb
Aug 17 21:27:02 ubuntu kernel: [26639.184333]  [<c1042993>] ?
refrigerator+0x72/0xdb
Aug 17 21:27:02 ubuntu kernel: [26639.184342]  [<c13ee6c2>] ?
_spin_unlock_irq+0x22/0x45
Aug 17 21:27:02 ubuntu kernel: [26639.184352]  [<c104a803>] ?
trace_hardirqs_on+0xb/0xd
Aug 17 21:27:02 ubuntu kernel: [26639.184362]  [<c10429e5>]
refrigerator+0xc4/0xdb
Aug 17 21:27:02 ubuntu kernel: [26639.184372]  [<c1035b74>]
try_to_freeze+0x19/0x20
Aug 17 21:27:02 ubuntu kernel: [26639.184380]  [<c10371f0>]
get_signal_to_deliver+0x36/0x32e
Aug 17 21:27:02 ubuntu kernel: [26639.184390]  [<c104a803>] ?
trace_hardirqs_on+0xb/0xd
Aug 17 21:27:02 ubuntu kernel: [26639.184399]  [<c1001fcd>]
do_notify_resume+0x77/0x735
Aug 17 21:27:02 ubuntu kernel: [26639.184410]  [<c11e7b62>] ?
n_tty_read+0x516/0x5b7
Aug 17 21:27:02 ubuntu kernel: [26639.184419]  [<c11e9d45>] ?
put_ldisc+0x7d/0x83
Aug 17 21:27:02 ubuntu kernel: [26639.184429]  [<c104a7d0>] ?
trace_hardirqs_on_caller+0x108/0x130
Aug 17 21:27:02 ubuntu kernel: [26639.184438]  [<c104a803>] ?
trace_hardirqs_on+0xb/0xd
Aug 17 21:27:02 ubuntu kernel: [26639.184448]  [<c11e9d53>] ?
tty_ldisc_deref+0x8/0xa
Aug 17 21:27:02 ubuntu kernel: [26639.184457]  [<c11e4037>] ? tty_read+0x72/0x9e
Aug 17 21:27:02 ubuntu kernel: [26639.184466]  [<c11e764c>] ?
n_tty_read+0x0/0x5b7
Aug 17 21:27:02 ubuntu kernel: [26639.184475]  [<c11e3fc5>] ? tty_read+0x0/0x9e
Aug 17 21:27:02 ubuntu kernel: [26639.184483]  [<c1094e62>] ? vfs_read+0x7d/0xdc
Aug 17 21:27:02 ubuntu kernel: [26639.184492]  [<c1094f6d>] ? sys_read+0x53/0x5d
Aug 17 21:27:02 ubuntu kernel: [26639.184502]  [<c1002d96>]
work_notifysig+0x13/0x19
Aug 17 21:27:02 ubuntu kernel: [26639.184510] devkit-power- D 00001835
 2080  2819      1 0x00000000
Aug 17 21:27:02 ubuntu kernel: [26639.184523]  e9fa4e8c 00000046
c140263c 00001835 c1042993 ec4f2c14 c1689a00 00000046
Aug 17 21:27:02 ubuntu kernel: [26639.184544]  c1685eb8 c1689a00
ec4f2c14 c1689a00 c1042993 00000007 ec4f2980 c13ee6c2
Aug 17 21:27:02 ubuntu kernel: [26639.184565]  c13ff8a3 00001835
ec4f2980 f630f884 00000002 e9fa4e80 c104a803 00000000
Aug 17 21:27:02 ubuntu kernel: [26639.184585] Call Trace:
Aug 17 21:27:03 ubuntu kernel: [26639.184594]  [<c1042993>] ?
refrigerator+0x72/0xdb
Aug 17 21:27:03 ubuntu kernel: [26639.184604]  [<c1042993>] ?
refrigerator+0x72/0xdb
Aug 17 21:27:03 ubuntu kernel: [26639.184614]  [<c13ee6c2>] ?
_spin_unlock_irq+0x22/0x45
Aug 17 21:27:03 ubuntu kernel: [26639.184624]  [<c104a803>] ?
trace_hardirqs_on+0xb/0xd
Aug 17 21:27:03 ubuntu kernel: [26639.184633]  [<c10429e5>]
refrigerator+0xc4/0xdb
Aug 17 21:27:03 ubuntu kernel: [26639.184643]  [<c1035b74>]
try_to_freeze+0x19/0x20
Aug 17 21:27:03 ubuntu kernel: [26639.184651]  [<c10371f0>]
get_signal_to_deliver+0x36/0x32e
Aug 17 21:27:03 ubuntu kernel: [26639.184661]  [<c1001fcd>]
do_notify_resume+0x77/0x735
Aug 17 21:27:03 ubuntu kernel: [26639.184671]  [<c103cec4>] ?
remove_wait_queue+0xf/0x27
Aug 17 21:27:03 ubuntu kernel: [26639.184681]  [<c13ee67b>] ?
_spin_unlock_irqrestore+0x36/0x5b
Aug 17 21:27:03 ubuntu kernel: [26639.184690]  [<c104a7d0>] ?
trace_hardirqs_on_caller+0x108/0x130
Aug 17 21:27:03 ubuntu kernel: [26639.184700]  [<c104a803>] ?
trace_hardirqs_on+0xb/0xd
Aug 17 21:27:03 ubuntu kernel: [26639.184709]  [<c13ee693>] ?
_spin_unlock_irqrestore+0x4e/0x5b
Aug 17 21:27:03 ubuntu kernel: [26639.184719]  [<c103ced7>] ?
remove_wait_queue+0x22/0x27
Aug 17 21:27:03 ubuntu kernel: [26639.184729]  [<c102e8e1>] ?
do_wait+0x1d9/0x290
Aug 17 21:27:03 ubuntu kernel: [26639.184738]  [<c10252f5>] ?
default_wake_function+0x0/0xd
Aug 17 21:27:03 ubuntu kernel: [26639.184748]  [<c102ea2c>] ?
sys_wait4+0x94/0xa1
Aug 17 21:27:03 ubuntu kernel: [26639.184759]  [<c1002d96>]
work_notifysig+0x13/0x19
Aug 17 21:27:03 ubuntu kernel: [26639.184766] gdm-session-w D 00001835
 2172  2888   2437 0x00000000
Aug 17 21:27:03 ubuntu kernel: [26639.184780]  e9d85e8c 00000046
c16109a9 00001835 c1042993 ec532c14 c1689a00 00000046
Aug 17 21:27:03 ubuntu kernel: [26639.184800]  c1685eb8 c1689a00
ec532c14 c1689a00 c1042993 00000007 ec532980 c13ee6c2
Aug 17 21:27:03 ubuntu kernel: [26639.184821]  c13fd4be 00001835
ec532980 f600fe04 00000002 e9d85e80 c104a803 00000000
Aug 17 21:27:03 ubuntu kernel: [26639.184854] Call Trace:
Aug 17 21:27:03 ubuntu kernel: [26639.184868]  [<c1042993>] ?
refrigerator+0x72/0xdb
Aug 17 21:27:03 ubuntu kernel: [26639.184883]  [<c1042993>] ?
refrigerator+0x72/0xdb
Aug 17 21:27:03 ubuntu kernel: [26639.184897]  [<c13ee6c2>] ?
_spin_unlock_irq+0x22/0x45
Aug 17 21:27:03 ubuntu kernel: [26639.184911]  [<c104a803>] ?
trace_hardirqs_on+0xb/0xd
Aug 17 21:27:03 ubuntu kernel: [26639.184922]  [<c10429e5>]
refrigerator+0xc4/0xdb
Aug 17 21:27:03 ubuntu kernel: [26639.184932]  [<c1035b74>]
try_to_freeze+0x19/0x20
Aug 17 21:27:03 ubuntu kernel: [26639.184940]  [<c10371f0>]
get_signal_to_deliver+0x36/0x32e
Aug 17 21:27:03 ubuntu kernel: [26639.184950]  [<c1001fcd>]
do_notify_resume+0x77/0x735
Aug 17 21:27:03 ubuntu kernel: [26639.184960]  [<c103cec4>] ?
remove_wait_queue+0xf/0x27
Aug 17 21:27:03 ubuntu kernel: [26639.184970]  [<c13ee67b>] ?
_spin_unlock_irqrestore+0x36/0x5b
Aug 17 21:27:03 ubuntu kernel: [26639.184980]  [<c104a7d0>] ?
trace_hardirqs_on_caller+0x108/0x130
Aug 17 21:27:03 ubuntu kernel: [26639.184989]  [<c104a803>] ?
trace_hardirqs_on+0xb/0xd
Aug 17 21:27:03 ubuntu kernel: [26639.184998]  [<c13ee693>] ?
_spin_unlock_irqrestore+0x4e/0x5b
Aug 17 21:27:03 ubuntu kernel: [26639.185008]  [<c103ced7>] ?
remove_wait_queue+0x22/0x27
Aug 17 21:27:03 ubuntu kernel: [26639.185018]  [<c102e8e1>] ?
do_wait+0x1d9/0x290
Aug 17 21:27:03 ubuntu kernel: [26639.185027]  [<c10252f5>] ?
default_wake_function+0x0/0xd
Aug 17 21:27:03 ubuntu kernel: [26639.185037]  [<c102ea2c>] ?
sys_wait4+0x94/0xa1
Aug 17 21:27:03 ubuntu kernel: [26639.185047]  [<c10a0e1a>] ? sys_poll+0x42/0x8b
Aug 17 21:27:03 ubuntu kernel: [26639.185056]  [<c1002d96>]
work_notifysig+0x13/0x19
Aug 17 21:27:03 ubuntu kernel: [26639.185064] gnome-keyring D 00001835
 2080  2968      1 0x00000000
Aug 17 21:27:03 ubuntu kernel: [26639.185078]  e5f06e8c 00000046
c161d480 00001835 c1042993 ee205594 c1689a00 00000046
Aug 17 21:27:03 ubuntu kernel: [26639.185099]  c1685eb8 c1689a00
ee205594 c1689a00 c1042993 00000007 ee205300 c13ee6c2
Aug 17 21:27:03 ubuntu kernel: [26639.185119]  c1402157 00001835
ee205300 f630a604 00000002 e5f06e80 c104a803 00000000
Aug 17 21:27:03 ubuntu kernel: [26639.185140] Call Trace:
Aug 17 21:27:03 ubuntu kernel: [26639.185149]  [<c1042993>] ?
refrigerator+0x72/0xdb
Aug 17 21:27:03 ubuntu kernel: [26639.185159]  [<c1042993>] ?
refrigerator+0x72/0xdb
Aug 17 21:27:03 ubuntu kernel: [26639.185169]  [<c13ee6c2>] ?
_spin_unlock_irq+0x22/0x45
Aug 17 21:27:03 ubuntu kernel: [26639.185178]  [<c104a803>] ?
trace_hardirqs_on+0xb/0xd
Aug 17 21:27:03 ubuntu kernel: [26639.185188]  [<c10429e5>]
refrigerator+0xc4/0xdb
Aug 17 21:27:03 ubuntu kernel: [26639.185198]  [<c1035b74>]
try_to_freeze+0x19/0x20
Aug 17 21:27:03 ubuntu kernel: [26639.185206]  [<c10371f0>]
get_signal_to_deliver+0x36/0x32e
Aug 17 21:27:03 ubuntu kernel: [26639.185216]  [<c1001fcd>]
do_notify_resume+0x77/0x735
Aug 17 21:27:03 ubuntu kernel: [26639.185226]  [<c1157a57>] ?
file_has_perm+0x87/0xa1
Aug 17 21:27:03 ubuntu kernel: [26639.185237]  [<c103ccb5>] ?
autoremove_wake_function+0x0/0x2f
Aug 17 21:27:03 ubuntu kernel: [26639.185247]  [<c1157ce4>] ?
selinux_file_permission+0x44/0x48
Aug 17 21:27:03 ubuntu kernel: [26639.185257]  [<c1154346>] ?
security_file_permission+0xf/0x11
Aug 17 21:27:03 ubuntu kernel: [26639.185266]  [<c109490a>] ?
rw_verify_area+0x98/0xbb
Aug 17 21:27:03 ubuntu kernel: [26639.185275]  [<c109478e>] ?
do_sync_read+0x0/0xe4
Aug 17 21:27:03 ubuntu kernel: [26639.185284]  [<c1094e62>] ? vfs_read+0x7d/0xdc
Aug 17 21:27:03 ubuntu kernel: [26639.185293]  [<c10a0e1a>] ? sys_poll+0x42/0x8b
Aug 17 21:27:03 ubuntu kernel: [26639.185303]  [<c1002d96>]
work_notifysig+0x13/0x19
Aug 17 21:27:03 ubuntu kernel: [26639.185310] gnome-keyring D 00001835
 2824  3077      1 0x00000000
Aug 17 21:27:03 ubuntu kernel: [26639.185324]  e94d5e8c 00000046
c1406720 00001835 c1042993 ecaf6a54 c1689a00 00000046
Aug 17 21:27:03 ubuntu kernel: [26639.185345]  c1685eb8 c1689a00
ecaf6a54 c1689a00 c1042993 00000007 ecaf67c0 c13ee6c2
Aug 17 21:27:03 ubuntu kernel: [26639.185366]  c1404ece 00001835
ecaf67c0 f630a604 00000002 e94d5e80 c104a803 00000000
Aug 17 21:27:03 ubuntu kernel: [26639.185386] Call Trace:
Aug 17 21:27:03 ubuntu kernel: [26639.185395]  [<c1042993>] ?
refrigerator+0x72/0xdb
Aug 17 21:27:03 ubuntu kernel: [26639.185405]  [<c1042993>] ?
refrigerator+0x72/0xdb
Aug 17 21:27:03 ubuntu kernel: [26639.185415]  [<c13ee6c2>] ?
_spin_unlock_irq+0x22/0x45
Aug 17 21:27:03 ubuntu kernel: [26639.185425]  [<c104a803>] ?
trace_hardirqs_on+0xb/0xd
Aug 17 21:27:03 ubuntu kernel: [26639.185434]  [<c10429e5>]
refrigerator+0xc4/0xdb
Aug 17 21:27:03 ubuntu kernel: [26639.185444]  [<c1035b74>]
try_to_freeze+0x19/0x20
Aug 17 21:27:03 ubuntu kernel: [26639.185453]  [<c10371f0>]
get_signal_to_deliver+0x36/0x32e
Aug 17 21:27:03 ubuntu kernel: [26639.185463]  [<c1001fcd>]
do_notify_resume+0x77/0x735
Aug 17 21:27:03 ubuntu kernel: [26639.185475]  [<c10242b1>] ?
finish_task_switch+0x2c/0x9b
Aug 17 21:27:03 ubuntu kernel: [26639.185485]  [<c13ee6c2>] ?
_spin_unlock_irq+0x22/0x45
Aug 17 21:27:03 ubuntu kernel: [26639.185494]  [<c104a7d0>] ?
trace_hardirqs_on_caller+0x108/0x130
Aug 17 21:27:03 ubuntu kernel: [26639.185505]  [<c104f07c>] ?
sys_futex+0xe1/0xf5
Aug 17 21:27:03 ubuntu kernel: [26639.185514]  [<c1002bfa>] ?
sysenter_exit+0xf/0x1a
Aug 17 21:27:03 ubuntu kernel: [26639.185523]  [<c104a7d0>] ?
trace_hardirqs_on_caller+0x108/0x130
Aug 17 21:27:03 ubuntu kernel: [26639.185533]  [<c1002d96>]
work_notifysig+0x13/0x19
Aug 17 21:27:03 ubuntu kernel: [26639.185541] gnome-session D 00001835
 2080  2982   2888 0x00000000
Aug 17 21:27:03 ubuntu kernel: [26639.185554]  ea58fe8c 00000046
c1632052 00001835 c1042993 ee205ff4 c1689a00 00000046
Aug 17 21:27:03 ubuntu kernel: [26639.185575]  c1685eb8 c1689a00
ee205ff4 c1689a00 c1042993 00000007 ee205d60 c13ee6c2
Aug 17 21:27:03 ubuntu kernel: [26639.185595]  c1407506 00001835
ee205d60 f6309004 00000002 ea58fe80 c104a803 00000000
Aug 17 21:27:03 ubuntu kernel: [26639.185616] Call Trace:
Aug 17 21:27:03 ubuntu kernel: [26639.185626]  [<c1632052>] ?
x86_get_mtrr_mem_range+0x156/0x1df
Aug 17 21:27:03 ubuntu kernel: [26639.185636]  [<c1042993>] ?
refrigerator+0x72/0xdb
Aug 17 21:27:03 ubuntu kernel: [26639.185646]  [<c1042993>] ?
refrigerator+0x72/0xdb
Aug 17 21:27:03 ubuntu kernel: [26639.185655]  [<c13ee6c2>] ?
_spin_unlock_irq+0x22/0x45
Aug 17 21:27:03 ubuntu kernel: [26639.185665]  [<c104a803>] ?
trace_hardirqs_on+0xb/0xd
Aug 17 21:27:03 ubuntu kernel: [26639.185675]  [<c10429e5>]
refrigerator+0xc4/0xdb
Aug 17 21:27:03 ubuntu kernel: [26639.185684]  [<c1035b74>]
try_to_freeze+0x19/0x20
Aug 17 21:27:03 ubuntu kernel: [26639.185693]  [<c10371f0>]
get_signal_to_deliver+0x36/0x32e
Aug 17 21:27:03 ubuntu kernel: [26639.185703]  [<c1001fcd>]
do_notify_resume+0x77/0x735
Aug 17 21:27:03 ubuntu kernel: [26639.185714]  [<c103ccb5>] ?
autoremove_wake_function+0x0/0x2f
Aug 17 21:27:03 ubuntu kernel: [26639.185725]  [<c1157ce4>] ?
selinux_file_permission+0x44/0x48
Aug 17 21:27:03 ubuntu kernel: [26639.185735]  [<c1154346>] ?
security_file_permission+0xf/0x11
Aug 17 21:27:03 ubuntu kernel: [26639.185744]  [<c109490a>] ?
rw_verify_area+0x98/0xbb
Aug 17 21:27:03 ubuntu kernel: [26639.185753]  [<c1094e70>] ? vfs_read+0x8b/0xdc
Aug 17 21:27:03 ubuntu kernel: [26639.185763]  [<c10a0e1a>] ? sys_poll+0x42/0x8b
Aug 17 21:27:03 ubuntu kernel: [26639.185772]  [<c1002d96>]
work_notifysig+0x13/0x19
Aug 17 21:27:03 ubuntu kernel: [26639.185780] gnome-session D 00001835
 2824  3072   2888 0x00000000
Aug 17 21:27:03 ubuntu kernel: [26639.185794]  e53fce8c 00000046
c140acd3 00001835 c1042993 eea7dff4 c1689a00 00000046
Aug 17 21:27:03 ubuntu kernel: [26639.185815]  c1685eb8 c1689a00
eea7dff4 c1689a00 c1042993 00000007 eea7dd60 c13ee6c2
Aug 17 21:27:03 ubuntu kernel: [26639.185835]  c1409a05 00001835
eea7dd60 f6309004 00000002 e53fce80 c104a803 00000000
Aug 17 21:27:03 ubuntu kernel: [26639.185856] Call Trace:
Aug 17 21:27:03 ubuntu kernel: [26639.185865]  [<c1042993>] ?
refrigerator+0x72/0xdb
Aug 17 21:27:03 ubuntu kernel: [26639.185875]  [<c1042993>] ?
refrigerator+0x72/0xdb
Aug 17 21:27:03 ubuntu kernel: [26639.185884]  [<c13ee6c2>] ?
_spin_unlock_irq+0x22/0x45
Aug 17 21:27:03 ubuntu kernel: [26639.185894]  [<c104a803>] ?
trace_hardirqs_on+0xb/0xd
Aug 17 21:27:03 ubuntu kernel: [26639.185904]  [<c10429e5>]
refrigerator+0xc4/0xdb
Aug 17 21:27:03 ubuntu kernel: [26639.185913]  [<c1035b74>]
try_to_freeze+0x19/0x20
Aug 17 21:27:03 ubuntu kernel: [26639.185922]  [<c10371f0>]
get_signal_to_deliver+0x36/0x32e
Aug 17 21:27:03 ubuntu kernel: [26639.185932]  [<c1001fcd>]
do_notify_resume+0x77/0x735
Aug 17 21:27:03 ubuntu kernel: [26639.185941]  [<c1157a57>] ?
file_has_perm+0x87/0xa1
Aug 17 21:27:03 ubuntu kernel: [26639.185952]  [<c103ccb5>] ?
autoremove_wake_function+0x0/0x2f
Aug 17 21:27:03 ubuntu kernel: [26639.185963]  [<c1157ce4>] ?
selinux_file_permission+0x44/0x48
Aug 17 21:27:03 ubuntu kernel: [26639.185972]  [<c1154346>] ?
security_file_permission+0xf/0x11
Aug 17 21:27:03 ubuntu kernel: [26639.185982]  [<c109490a>] ?
rw_verify_area+0x98/0xbb
Aug 17 21:27:03 ubuntu kernel: [26639.185991]  [<c109478e>] ?
do_sync_read+0x0/0xe4
Aug 17 21:27:03 ubuntu kernel: [26639.185999]  [<c1094e62>] ? vfs_read+0x7d/0xdc
Aug 17 21:27:03 ubuntu kernel: [26639.186008]  [<c1094463>] ? fput_light+0xc/0xe
Aug 17 21:27:03 ubuntu kernel: [26639.186017]  [<c1094f6d>] ? sys_read+0x53/0x5d
Aug 17 21:27:03 ubuntu kernel: [26639.186026]  [<c1002d96>]
work_notifysig+0x13/0x19
Aug 17 21:27:03 ubuntu kernel: [26639.186034] ssh-agent     D 00001835
 1952  3019   2982 0x00000000
Aug 17 21:27:03 ubuntu kernel: [26639.186047]  e9512e8c 00000046
c163c2e1 00001835 c1042993 ec4f3674 c1689a00 00000046
Aug 17 21:27:03 ubuntu kernel: [26639.186068]  c1685eb8 c1689a00
ec4f3674 c1689a00 c1042993 00000007 ec4f33e0 c13ee6c2
Aug 17 21:27:03 ubuntu kernel: [26639.186088]  c1413632 00001835
ec4f33e0 f600c704 00000002 e9512e80 c104a803 00000000
Aug 17 21:27:03 ubuntu kernel: [26639.186109] Call Trace:
Aug 17 21:27:03 ubuntu kernel: [26639.186118]  [<c163c2e1>] ?
log_buf_len_setup+0x43/0xfe
Aug 17 21:27:03 ubuntu kernel: [26639.186128]  [<c1042993>] ?
refrigerator+0x72/0xdb
Aug 17 21:27:03 ubuntu kernel: [26639.186138]  [<c1042993>] ?
refrigerator+0x72/0xdb
Aug 17 21:27:03 ubuntu kernel: [26639.186147]  [<c13ee6c2>] ?
_spin_unlock_irq+0x22/0x45
Aug 17 21:27:03 ubuntu kernel: [26639.186157]  [<c104a803>] ?
trace_hardirqs_on+0xb/0xd
Aug 17 21:27:03 ubuntu kernel: [26639.186167]  [<c10429e5>]
refrigerator+0xc4/0xdb
Aug 17 21:27:03 ubuntu kernel: [26639.186176]  [<c1035b74>]
try_to_freeze+0x19/0x20
Aug 17 21:27:03 ubuntu kernel: [26639.186185]  [<c10371f0>]
get_signal_to_deliver+0x36/0x32e
Aug 17 21:27:03 ubuntu kernel: [26639.186194]  [<c104bac2>] ?
__lock_acquire+0xad3/0xae2
Aug 17 21:27:03 ubuntu kernel: [26639.186204]  [<c1001fcd>]
do_notify_resume+0x77/0x735
Aug 17 21:27:03 ubuntu kernel: [26639.186213]  [<c107e7e3>] ?
might_fault+0x4b/0x88
Aug 17 21:27:03 ubuntu kernel: [26639.186222]  [<c107e7e3>] ?
might_fault+0x4b/0x88
Aug 17 21:27:03 ubuntu kernel: [26639.186232]  [<c107e81e>] ?
might_fault+0x86/0x88
Aug 17 21:27:03 ubuntu kernel: [26639.186242]  [<c1187e37>] ?
copy_to_user+0x2f/0x106
Aug 17 21:27:03 ubuntu kernel: [26639.186252]  [<c109fcfb>] ?
poll_select_copy_remaining+0xa2/0xbe
Aug 17 21:27:03 ubuntu kernel: [26639.186262]  [<c10a0913>] ?
sys_select+0x7c/0x86
Aug 17 21:27:03 ubuntu kernel: [26639.186272]  [<c1002d96>]
work_notifysig+0x13/0x19
Aug 17 21:27:03 ubuntu kernel: [26639.186280] dbus-launch   D 00001835
 2212  3022      1 0x00000000
Aug 17 21:27:03 ubuntu kernel: [26639.186293]  e5871e8c 00000046
c140e7aa 00001835 c1042993 ec5321b4 c1689a00 00000046
Aug 17 21:27:03 ubuntu kernel: [26639.186314]  c1685eb8 c1689a00
ec5321b4 c1689a00 c1042993 00000007 ec531f20 c13ee6c2
Aug 17 21:27:03 ubuntu kernel: [26639.186334]  c140d36d 00001835
ec531f20 f630b684 00000002 e5871e80 c104a803 00000000
Aug 17 21:27:03 ubuntu kernel: [26639.186355] Call Trace:
Aug 17 21:27:03 ubuntu kernel: [26639.186364]  [<c1042993>] ?
refrigerator+0x72/0xdb
Aug 17 21:27:03 ubuntu kernel: [26639.186374]  [<c1042993>] ?
refrigerator+0x72/0xdb
Aug 17 21:27:03 ubuntu kernel: [26639.186384]  [<c13ee6c2>] ?
_spin_unlock_irq+0x22/0x45
Aug 17 21:27:03 ubuntu kernel: [26639.186394]  [<c104a803>] ?
trace_hardirqs_on+0xb/0xd
Aug 17 21:27:03 ubuntu kernel: [26639.186403]  [<c10429e5>]
refrigerator+0xc4/0xdb
Aug 17 21:27:03 ubuntu kernel: [26639.186413]  [<c1035b74>]
try_to_freeze+0x19/0x20
Aug 17 21:27:03 ubuntu kernel: [26639.186421]  [<c10371f0>]
get_signal_to_deliver+0x36/0x32e
Aug 17 21:27:03 ubuntu kernel: [26639.186431]  [<c1001fcd>]
do_notify_resume+0x77/0x735
Aug 17 21:27:03 ubuntu kernel: [26639.186441]  [<c1157a57>] ?
file_has_perm+0x87/0xa1
Aug 17 21:27:03 ubuntu kernel: [26639.186452]  [<c103ccb5>] ?
autoremove_wake_function+0x0/0x2f
Aug 17 21:27:03 ubuntu kernel: [26639.186462]  [<c1157ce4>] ?
selinux_file_permission+0x44/0x48
Aug 17 21:27:03 ubuntu kernel: [26639.186472]  [<c1154346>] ?
security_file_permission+0xf/0x11
Aug 17 21:27:03 ubuntu kernel: [26639.186481]  [<c109490a>] ?
rw_verify_area+0x98/0xbb
Aug 17 21:27:03 ubuntu kernel: [26639.186491]  [<c10a0913>] ?
sys_select+0x7c/0x86
Aug 17 21:27:03 ubuntu kernel: [26639.186501]  [<c1002d96>]
work_notifysig+0x13/0x19
Aug 17 21:27:03 ubuntu kernel: [26639.186509] dbus-daemon   D 00001835
 2152  3023      1 0x00000000
Aug 17 21:27:03 ubuntu kernel: [26639.186522]  e94cbe8c 00000046
c14420f4 00001835 c1042993 ec4f5594 c1689a00 00000046
Aug 17 21:27:03 ubuntu kernel: [26639.186543]  c1685eb8 c1689a00
ec4f5594 c1689a00 c1042993 00000007 ec4f5300 c13ee6c2
Aug 17 21:27:03 ubuntu kernel: [26639.186563]  c1441963 00001835
ec4f5300 f600b684 00000002 e94cbe80 c104a803 00000000
Aug 17 21:27:03 ubuntu kernel: [26639.186584] Call Trace:
Aug 17 21:27:03 ubuntu kernel: [26639.186593]  [<c1042993>] ?
refrigerator+0x72/0xdb
Aug 17 21:27:03 ubuntu kernel: [26639.186603]  [<c1042993>] ?
refrigerator+0x72/0xdb
Aug 17 21:27:03 ubuntu kernel: [26639.186612]  [<c13ee6c2>] ?
_spin_unlock_irq+0x22/0x45
Aug 17 21:27:03 ubuntu kernel: [26639.186622]  [<c104a803>] ?
trace_hardirqs_on+0xb/0xd
Aug 17 21:27:03 ubuntu kernel: [26639.186632]  [<c10429e5>]
refrigerator+0xc4/0xdb
Aug 17 21:27:03 ubuntu kernel: [26639.186642]  [<c1035b74>]
try_to_freeze+0x19/0x20
Aug 17 21:27:03 ubuntu kernel: [26639.186650]  [<c10371f0>]
get_signal_to_deliver+0x36/0x32e
Aug 17 21:27:03 ubuntu kernel: [26639.186660]  [<c1001fcd>]
do_notify_resume+0x77/0x735
Aug 17 21:27:03 ubuntu kernel: [26639.186673]  [<c107e81e>] ?
might_fault+0x86/0x88
Aug 17 21:27:03 ubuntu kernel: [26639.186683]  [<c10a0e1a>] ? sys_poll+0x42/0x8b
Aug 17 21:27:03 ubuntu kernel: [26639.186692]  [<c1002d96>]
work_notifysig+0x13/0x19
Aug 17 21:27:03 ubuntu kernel: [26639.186700] pulseaudio    D 00001835
 1972  3044      1 0x00000000
Aug 17 21:27:03 ubuntu kernel: [26639.186713]  e592ce8c 00000046
c150cdf6 00001835 c1042993 ecaf5594 c1689a00 00000046
Aug 17 21:27:03 ubuntu kernel: [26639.186734]  c1685eb8 c1689a00
ecaf5594 c1689a00 c1042993 00000007 ecaf5300 c13ee6c2
Aug 17 21:27:03 ubuntu kernel: [26639.186754]  c14bba16 00001835
ecaf5300 f600c184 00000002 e592ce80 c104a803 00000000
Aug 17 21:27:03 ubuntu kernel: [26639.186775] Call Trace:
Aug 17 21:27:03 ubuntu kernel: [26639.186784]  [<c1042993>] ?
refrigerator+0x72/0xdb
Aug 17 21:27:03 ubuntu kernel: [26639.186794]  [<c1042993>] ?
refrigerator+0x72/0xdb
Aug 17 21:27:03 ubuntu kernel: [26639.186803]  [<c13ee6c2>] ?
_spin_unlock_irq+0x22/0x45
Aug 17 21:27:03 ubuntu kernel: [26639.186813]  [<c104a803>] ?
trace_hardirqs_on+0xb/0xd
Aug 17 21:27:03 ubuntu kernel: [26639.186823]  [<c10429e5>]
refrigerator+0xc4/0xdb
Aug 17 21:27:03 ubuntu kernel: [26639.186832]  [<c1035b74>]
try_to_freeze+0x19/0x20
Aug 17 21:27:03 ubuntu kernel: [26639.186841]  [<c10371f0>]
get_signal_to_deliver+0x36/0x32e
Aug 17 21:27:03 ubuntu kernel: [26639.186851]  [<c1001fcd>]
do_notify_resume+0x77/0x735
Aug 17 21:27:03 ubuntu kernel: [26639.186865]  [<c10a0e1a>] ? sys_poll+0x42/0x8b
Aug 17 21:27:03 ubuntu kernel: [26639.186874]  [<c1002d96>]
work_notifysig+0x13/0x19
Aug 17 21:27:03 ubuntu kernel: [26639.186882] pulseaudio    D 00001835
 2092  3045      1 0x00000000
Aug 17 21:27:03 ubuntu kernel: [26639.186895]  eab9ee8c 00000046
c1644d3a 00001835 c1042993 ecaf4b34 c1689a00 00000046
Aug 17 21:27:03 ubuntu kernel: [26639.186916]  c1685eb8 c1689a00
ecaf4b34 c1689a00 c1042993 00000007 ecaf48a0 c13ee6c2
Aug 17 21:27:03 ubuntu kernel: [26639.186937]  c1415722 00001835
ecaf48a0 f600c184 00000002 eab9ee80 c104a803 00000000
Aug 17 21:27:03 ubuntu kernel: [26639.186957] Call Trace:
Aug 17 21:27:03 ubuntu kernel: [26639.186967]  [<c1644d3a>] ? unlzma+0x194/0x9aa
Aug 17 21:27:03 ubuntu kernel: [26639.186976]  [<c1042993>] ?
refrigerator+0x72/0xdb
Aug 17 21:27:03 ubuntu kernel: [26639.186986]  [<c1042993>] ?
refrigerator+0x72/0xdb
Aug 17 21:27:03 ubuntu kernel: [26639.186996]  [<c13ee6c2>] ?
_spin_unlock_irq+0x22/0x45
Aug 17 21:27:03 ubuntu kernel: [26639.187005]  [<c104a803>] ?
trace_hardirqs_on+0xb/0xd
Aug 17 21:27:03 ubuntu kernel: [26639.187015]  [<c10429e5>]
refrigerator+0xc4/0xdb
Aug 17 21:27:03 ubuntu kernel: [26639.187025]  [<c1035b74>]
try_to_freeze+0x19/0x20
Aug 17 21:27:03 ubuntu kernel: [26639.187033]  [<c10371f0>]
get_signal_to_deliver+0x36/0x32e
Aug 17 21:27:03 ubuntu kernel: [26639.187042]  [<c104bac2>] ?
__lock_acquire+0xad3/0xae2
Aug 17 21:27:03 ubuntu kernel: [26639.187052]  [<c104bac2>] ?
__lock_acquire+0xad3/0xae2
Aug 17 21:27:03 ubuntu kernel: [26639.187061]  [<c1001fcd>]
do_notify_resume+0x77/0x735
Aug 17 21:27:03 ubuntu kernel: [26639.187070]  [<c107e7e3>] ?
might_fault+0x4b/0x88
Aug 17 21:27:03 ubuntu kernel: [26639.187080]  [<c107e7e3>] ?
might_fault+0x4b/0x88
Aug 17 21:27:03 ubuntu kernel: [26639.187090]  [<c1094538>] ?
fsnotify_access+0x4f/0x5a
Aug 17 21:27:03 ubuntu kernel: [26639.187100]  [<c10a0dc1>] ?
sys_ppoll+0xe1/0xf8
Aug 17 21:27:03 ubuntu kernel: [26639.187109]  [<c1002bfa>] ?
sysenter_exit+0xf/0x1a
Aug 17 21:27:03 ubuntu kernel: [26639.187119]  [<c104a7d0>] ?
trace_hardirqs_on_caller+0x108/0x130
Aug 17 21:27:03 ubuntu kernel: [26639.187128]  [<c1002d96>]
work_notifysig+0x13/0x19
Aug 17 21:27:03 ubuntu kernel: [26639.187136] pulseaudio    D 00001835
 2320  3046      1 0x00000000
Aug 17 21:27:03 ubuntu kernel: [26639.187149]  e9d82e8c 00000046
c164a979 00001835 c1042993 ecaf5ff4 c1689a00 00000046
Aug 17 21:27:03 ubuntu kernel: [26639.187170]  c1685eb8 c1689a00
ecaf5ff4 c1689a00 c1042993 00000007 ecaf5d60 c13ee6c2
Aug 17 21:27:03 ubuntu kernel: [26639.187191]  c1417548 00001835
ecaf5d60 f600c184 00000002 e9d82e80 c104a803 00000000
Aug 17 21:27:03 ubuntu kernel: [26639.187211] Call Trace:
Aug 17 21:27:03 ubuntu kernel: [26639.187220]  [<c164a979>] ? kbd_init+0x93/0x9b
Aug 17 21:27:03 ubuntu kernel: [26639.187230]  [<c1042993>] ?
refrigerator+0x72/0xdb
Aug 17 21:27:03 ubuntu kernel: [26639.187240]  [<c1042993>] ?
refrigerator+0x72/0xdb
Aug 17 21:27:03 ubuntu kernel: [26639.187249]  [<c13ee6c2>] ?
_spin_unlock_irq+0x22/0x45
Aug 17 21:27:03 ubuntu kernel: [26639.187259]  [<c104a803>] ?
trace_hardirqs_on+0xb/0xd
Aug 17 21:27:03 ubuntu kernel: [26639.187269]  [<c10429e5>]
refrigerator+0xc4/0xdb
Aug 17 21:27:03 ubuntu kernel: [26639.187278]  [<c1035b74>]
try_to_freeze+0x19/0x20
Aug 17 21:27:04 ubuntu kernel: [26639.187287]  [<c10371f0>]
get_signal_to_deliver+0x36/0x32e
Aug 17 21:27:04 ubuntu kernel: [26639.187296]  [<c104bac2>] ?
__lock_acquire+0xad3/0xae2
Aug 17 21:27:04 ubuntu kernel: [26639.187305]  [<c104bac2>] ?
__lock_acquire+0xad3/0xae2
Aug 17 21:27:04 ubuntu kernel: [26639.187315]  [<c1001fcd>]
do_notify_resume+0x77/0x735
Aug 17 21:27:04 ubuntu kernel: [26639.187324]  [<c107e7e3>] ?
might_fault+0x4b/0x88
Aug 17 21:27:04 ubuntu kernel: [26639.187334]  [<c107e7e3>] ?
might_fault+0x4b/0x88
Aug 17 21:27:04 ubuntu kernel: [26639.187381]  [<c1094538>] ?
fsnotify_access+0x4f/0x5a
Aug 17 21:27:04 ubuntu kernel: [26639.187392]  [<c10a0dc1>] ?
sys_ppoll+0xe1/0xf8
Aug 17 21:27:04 ubuntu kernel: [26639.187401]  [<c1002bfa>] ?
sysenter_exit+0xf/0x1a
Aug 17 21:27:04 ubuntu kernel: [26639.187410]  [<c104a7d0>] ?
trace_hardirqs_on_caller+0x108/0x130
Aug 17 21:27:04 ubuntu kernel: [26639.187420]  [<c1002d96>]
work_notifysig+0x13/0x19
Aug 17 21:27:04 ubuntu kernel: [26639.187428] gconf-helper  D 00001835
 2320  3047   3044 0x00000000
Aug 17 21:27:04 ubuntu kernel: [26639.187441]  e85f7e8c 00000046
c1651bc5 00001835 c1042993 ecaf74b4 c1689a00 00000046
Aug 17 21:27:04 ubuntu kernel: [26639.187462]  c1685eb8 c1689a00
ecaf74b4 c1689a00 c1042993 00000007 ecaf7220 c13ee6c2
Aug 17 21:27:04 ubuntu kernel: [26639.187483]  c141b818 00001835
ecaf7220 f600ed84 00000002 e85f7e80 c104a803 00000000
Aug 17 21:27:04 ubuntu kernel: [26639.187503] Call Trace:
Aug 17 21:27:04 ubuntu kernel: [26639.187513]  [<c1651bc5>] ?
pci_mmcfg_amd_fam10h+0xe8/0xf2
Aug 17 21:27:04 ubuntu kernel: [26639.187523]  [<c1042993>] ?
refrigerator+0x72/0xdb
Aug 17 21:27:04 ubuntu kernel: [26639.187533]  [<c1042993>] ?
refrigerator+0x72/0xdb
Aug 17 21:27:04 ubuntu kernel: [26639.187542]  [<c13ee6c2>] ?
_spin_unlock_irq+0x22/0x45
Aug 17 21:27:04 ubuntu kernel: [26639.187552]  [<c104a803>] ?
trace_hardirqs_on+0xb/0xd
Aug 17 21:27:04 ubuntu kernel: [26639.187562]  [<c10429e5>]
refrigerator+0xc4/0xdb
Aug 17 21:27:04 ubuntu kernel: [26639.187572]  [<c1035b74>]
try_to_freeze+0x19/0x20
Aug 17 21:27:04 ubuntu kernel: [26639.187580]  [<c10371f0>]
get_signal_to_deliver+0x36/0x32e
Aug 17 21:27:04 ubuntu kernel: [26639.187590]  [<c1001fcd>]
do_notify_resume+0x77/0x735
Aug 17 21:27:04 ubuntu kernel: [26639.187600]  [<c1157a57>] ?
file_has_perm+0x87/0xa1
Aug 17 21:27:04 ubuntu kernel: [26639.187611]  [<c103ccb5>] ?
autoremove_wake_function+0x0/0x2f
Aug 17 21:27:04 ubuntu kernel: [26639.187622]  [<c1094538>] ?
fsnotify_access+0x4f/0x5a
Aug 17 21:27:04 ubuntu kernel: [26639.187631]  [<c1094e82>] ? vfs_read+0x9d/0xdc
Aug 17 21:27:04 ubuntu kernel: [26639.187641]  [<c10a0e1a>] ? sys_poll+0x42/0x8b
Aug 17 21:27:04 ubuntu kernel: [26639.187650]  [<c1002d96>]
work_notifysig+0x13/0x19
Aug 17 21:27:04 ubuntu kernel: [26639.187658] gconfd-2      D 00001835
 1960  3049      1 0x00000000
Aug 17 21:27:04 ubuntu kernel: [26639.187671]  e57b7e8c 00000046
c153dfd0 00001835 c1042993 ec531754 c1689a00 00000046
Aug 17 21:27:04 ubuntu kernel: [26639.187692]  c1685eb8 c1689a00
ec531754 c1689a00 c1042993 00000007 ec5314c0 c13ee6c2
Aug 17 21:27:04 ubuntu kernel: [26639.187712]  c1536d77 00001835
ec5314c0 f630e284 00000002 e57b7e80 c104a803 00000000
Aug 17 21:27:04 ubuntu kernel: [26639.187733] Call Trace:
Aug 17 21:27:04 ubuntu kernel: [26639.187742]  [<c1042993>] ?
refrigerator+0x72/0xdb
Aug 17 21:27:04 ubuntu kernel: [26639.187752]  [<c1042993>] ?
refrigerator+0x72/0xdb
Aug 17 21:27:04 ubuntu kernel: [26639.187761]  [<c13ee6c2>] ?
_spin_unlock_irq+0x22/0x45
Aug 17 21:27:04 ubuntu kernel: [26639.187771]  [<c104a803>] ?
trace_hardirqs_on+0xb/0xd
Aug 17 21:27:04 ubuntu kernel: [26639.187781]  [<c10429e5>]
refrigerator+0xc4/0xdb
Aug 17 21:27:04 ubuntu kernel: [26639.187791]  [<c1035b74>]
try_to_freeze+0x19/0x20
Aug 17 21:27:04 ubuntu kernel: [26639.187799]  [<c10371f0>]
get_signal_to_deliver+0x36/0x32e
Aug 17 21:27:04 ubuntu kernel: [26639.187809]  [<c1001fcd>]
do_notify_resume+0x77/0x735
Aug 17 21:27:04 ubuntu kernel: [26639.187823]  [<c10a0e1a>] ? sys_poll+0x42/0x8b
Aug 17 21:27:04 ubuntu kernel: [26639.187833]  [<c1002d96>]
work_notifysig+0x13/0x19
Aug 17 21:27:04 ubuntu kernel: [26639.187841] seahorse-agen D 00001835
 2152  3059   2982 0x00000000
Aug 17 21:27:04 ubuntu kernel: [26639.187854]  e5221e8c 00000046
c165aecc 00001835 c1042993 ee2021b4 c1689a00 00000046
Aug 17 21:27:04 ubuntu kernel: [26639.187875]  c1685eb8 c1689a00
ee2021b4 c1689a00 c1042993 00000007 ee201f20 c13ee6c2
Aug 17 21:27:04 ubuntu kernel: [26639.187896]  c141d7b2 00001835
ee201f20 f600ab84 00000002 e5221e80 c104a803 00000000
Aug 17 21:27:04 ubuntu kernel: [26639.187916] Call Trace:
Aug 17 21:27:04 ubuntu kernel: [26639.187925]  [<c1042993>] ?
refrigerator+0x72/0xdb
Aug 17 21:27:04 ubuntu kernel: [26639.187935]  [<c1042993>] ?
refrigerator+0x72/0xdb
Aug 17 21:27:04 ubuntu kernel: [26639.187945]  [<c13ee6c2>] ?
_spin_unlock_irq+0x22/0x45
Aug 17 21:27:04 ubuntu kernel: [26639.187955]  [<c104a803>] ?
trace_hardirqs_on+0xb/0xd
Aug 17 21:27:04 ubuntu kernel: [26639.187964]  [<c10429e5>]
refrigerator+0xc4/0xdb
Aug 17 21:27:04 ubuntu kernel: [26639.187974]  [<c1035b74>]
try_to_freeze+0x19/0x20
Aug 17 21:27:04 ubuntu kernel: [26639.187982]  [<c10371f0>]
get_signal_to_deliver+0x36/0x32e
Aug 17 21:27:04 ubuntu kernel: [26639.187992]  [<c1001fcd>]
do_notify_resume+0x77/0x735
Aug 17 21:27:04 ubuntu kernel: [26639.188002]  [<c1157a57>] ?
file_has_perm+0x87/0xa1
Aug 17 21:27:04 ubuntu kernel: [26639.188013]  [<c103ccb5>] ?
autoremove_wake_function+0x0/0x2f
Aug 17 21:27:04 ubuntu kernel: [26639.188023]  [<c1157ce4>] ?
selinux_file_permission+0x44/0x48
Aug 17 21:27:04 ubuntu kernel: [26639.188033]  [<c1154346>] ?
security_file_permission+0xf/0x11
Aug 17 21:27:04 ubuntu kernel: [26639.188042]  [<c109490a>] ?
rw_verify_area+0x98/0xbb
Aug 17 21:27:04 ubuntu kernel: [26639.188051]  [<c1094e70>] ? vfs_read+0x8b/0xdc
Aug 17 21:27:04 ubuntu kernel: [26639.188061]  [<c10a0e1a>] ? sys_poll+0x42/0x8b
Aug 17 21:27:04 ubuntu kernel: [26639.188070]  [<c1002d96>]
work_notifysig+0x13/0x19
Aug 17 21:27:04 ubuntu kernel: [26639.188078] gvfsd         D 00001835
 2080  3062      1 0x00000000
Aug 17 21:27:04 ubuntu kernel: [26639.188092]  e488de8c 00000046
c1662d57 00001835 c1042993 ec5340d4 c1689a00 00000046
Aug 17 21:27:04 ubuntu kernel: [26639.188113]  c1685eb8 c1689a00
ec5340d4 c1689a00 c1042993 00000007 ec533e40 c13ee6c2
Aug 17 21:27:04 ubuntu kernel: [26639.188133]  c1429c51 00001835
ec533e40 f630cc84 00000002 e488de80 c104a803 00000000
Aug 17 21:27:04 ubuntu kernel: [26639.188154] Call Trace:
Aug 17 21:27:04 ubuntu kernel: [26639.188163]  [<c1042993>] ?
refrigerator+0x72/0xdb
Aug 17 21:27:04 ubuntu kernel: [26639.188173]  [<c1042993>] ?
refrigerator+0x72/0xdb
Aug 17 21:27:04 ubuntu kernel: [26639.188195]  [<c13ee6c2>] ?
_spin_unlock_irq+0x22/0x45
Aug 17 21:27:04 ubuntu kernel: [26639.188209]  [<c104a803>] ?
trace_hardirqs_on+0xb/0xd
Aug 17 21:27:04 ubuntu kernel: [26639.188224]  [<c10429e5>]
refrigerator+0xc4/0xdb
Aug 17 21:27:04 ubuntu kernel: [26639.188238]  [<c1035b74>]
try_to_freeze+0x19/0x20
Aug 17 21:27:04 ubuntu kernel: [26639.188250]  [<c10371f0>]
get_signal_to_deliver+0x36/0x32e
Aug 17 21:27:04 ubuntu kernel: [26639.188261]  [<c1001fcd>]
do_notify_resume+0x77/0x735
Aug 17 21:27:04 ubuntu kernel: [26639.188271]  [<c1157a57>] ?
file_has_perm+0x87/0xa1
Aug 17 21:27:04 ubuntu kernel: [26639.188282]  [<c103ccb5>] ?
autoremove_wake_function+0x0/0x2f
Aug 17 21:27:04 ubuntu kernel: [26639.188292]  [<c1157ce4>] ?
selinux_file_permission+0x44/0x48
Aug 17 21:27:04 ubuntu kernel: [26639.188302]  [<c1154346>] ?
security_file_permission+0xf/0x11
Aug 17 21:27:04 ubuntu kernel: [26639.188311]  [<c109490a>] ?
rw_verify_area+0x98/0xbb
Aug 17 21:27:04 ubuntu kernel: [26639.188320]  [<c1094e70>] ? vfs_read+0x8b/0xdc
Aug 17 21:27:04 ubuntu kernel: [26639.188330]  [<c10a0e1a>] ? sys_poll+0x42/0x8b
Aug 17 21:27:04 ubuntu kernel: [26639.188339]  [<c1002d96>]
work_notifysig+0x13/0x19
Aug 17 21:27:04 ubuntu kernel: [26639.188347] gvfs-fuse-dae D 00001835
 2824  3067      1 0x00000000
Aug 17 21:27:04 ubuntu kernel: [26639.188361]  e53f6e8c 00000046
c155957d 00001835 c1042993 ec5274b4 c1689a00 00000046
Aug 17 21:27:04 ubuntu kernel: [26639.188382]  c1685eb8 c1689a00
ec5274b4 c1689a00 c1042993 00000007 ec527220 c13ee6c2
Aug 17 21:27:04 ubuntu kernel: [26639.188402]  c1421494 00001835
ec527220 f630e804 00000002 e53f6e80 c104a803 00000000
Aug 17 21:27:04 ubuntu kernel: [26639.188423] Call Trace:
Aug 17 21:27:04 ubuntu kernel: [26639.188432]  [<c1042993>] ?
refrigerator+0x72/0xdb
Aug 17 21:27:04 ubuntu kernel: [26639.188442]  [<c1042993>] ?
refrigerator+0x72/0xdb
Aug 17 21:27:04 ubuntu kernel: [26639.188452]  [<c13ee6c2>] ?
_spin_unlock_irq+0x22/0x45
Aug 17 21:27:04 ubuntu kernel: [26639.188462]  [<c104a803>] ?
trace_hardirqs_on+0xb/0xd
Aug 17 21:27:04 ubuntu kernel: [26639.188471]  [<c10429e5>]
refrigerator+0xc4/0xdb
Aug 17 21:27:04 ubuntu kernel: [26639.188481]  [<c1035b74>]
try_to_freeze+0x19/0x20
Aug 17 21:27:04 ubuntu kernel: [26639.188490]  [<c10371f0>]
get_signal_to_deliver+0x36/0x32e
Aug 17 21:27:04 ubuntu kernel: [26639.188500]  [<c1001fcd>]
do_notify_resume+0x77/0x735
Aug 17 21:27:04 ubuntu kernel: [26639.188510]  [<c106f98b>] ?
unlock_page+0x47/0x4a
Aug 17 21:27:04 ubuntu kernel: [26639.188520]  [<c10812b6>] ?
__do_fault+0x2fb/0x327
Aug 17 21:27:04 ubuntu kernel: [26639.188532]  [<c104f07c>] ?
sys_futex+0xe1/0xf5
Aug 17 21:27:04 ubuntu kernel: [26639.188541]  [<c1002bfa>] ?
sysenter_exit+0xf/0x1a
Aug 17 21:27:04 ubuntu kernel: [26639.188551]  [<c104a7d0>] ?
trace_hardirqs_on_caller+0x108/0x130
Aug 17 21:27:04 ubuntu kernel: [26639.188560]  [<c1002d96>]
work_notifysig+0x13/0x19
Aug 17 21:27:04 ubuntu kernel: [26639.188568] gvfs-fuse-dae D 00001835
 2340  3068      1 0x00000000
Aug 17 21:27:04 ubuntu kernel: [26639.188582]  e4985e8c 00000046
c155dfd6 00001835 c1042993 ec4f4b34 c1689a00 00000046
Aug 17 21:27:04 ubuntu kernel: [26639.188603]  c1685eb8 c1689a00
ec4f4b34 c1689a00 c1042993 00000007 ec4f48a0 c13ee6c2
Aug 17 21:27:04 ubuntu kernel: [26639.188623]  c14232ef 00001835
ec4f48a0 f630e804 00000002 e4985e80 c104a803 00000000
Aug 17 21:27:04 ubuntu kernel: [26639.188644] Call Trace:
Aug 17 21:27:04 ubuntu kernel: [26639.188653]  [<c1042993>] ?
refrigerator+0x72/0xdb
Aug 17 21:27:04 ubuntu kernel: [26639.188663]  [<c1042993>] ?
refrigerator+0x72/0xdb
Aug 17 21:27:04 ubuntu kernel: [26639.188672]  [<c13ee6c2>] ?
_spin_unlock_irq+0x22/0x45
Aug 17 21:27:04 ubuntu kernel: [26639.188682]  [<c104a803>] ?
trace_hardirqs_on+0xb/0xd
Aug 17 21:27:04 ubuntu kernel: [26639.188692]  [<c10429e5>]
refrigerator+0xc4/0xdb
Aug 17 21:27:04 ubuntu kernel: [26639.188701]  [<c1035b74>]
try_to_freeze+0x19/0x20
Aug 17 21:27:04 ubuntu kernel: [26639.188710]  [<c10371f0>]
get_signal_to_deliver+0x36/0x32e
Aug 17 21:27:04 ubuntu kernel: [26639.188720]  [<c1001fcd>]
do_notify_resume+0x77/0x735
Aug 17 21:27:04 ubuntu kernel: [26639.188729]  [<c1157a57>] ?
file_has_perm+0x87/0xa1
Aug 17 21:27:04 ubuntu kernel: [26639.188741]  [<c103ccb5>] ?
autoremove_wake_function+0x0/0x2f
Aug 17 21:27:04 ubuntu kernel: [26639.188751]  [<c1157ce4>] ?
selinux_file_permission+0x44/0x48
Aug 17 21:27:04 ubuntu kernel: [26639.188760]  [<c1154346>] ?
security_file_permission+0xf/0x11
Aug 17 21:27:04 ubuntu kernel: [26639.188770]  [<c109490a>] ?
rw_verify_area+0x98/0xbb
Aug 17 21:27:04 ubuntu kernel: [26639.188779]  [<c109478e>] ?
do_sync_read+0x0/0xe4
Aug 17 21:27:04 ubuntu kernel: [26639.188787]  [<c1094e62>] ? vfs_read+0x7d/0xdc
Aug 17 21:27:04 ubuntu kernel: [26639.188796]  [<c1094463>] ? fput_light+0xc/0xe
Aug 17 21:27:04 ubuntu kernel: [26639.188805]  [<c1094f6d>] ? sys_read+0x53/0x5d
Aug 17 21:27:04 ubuntu kernel: [26639.188814]  [<c1002d96>]
work_notifysig+0x13/0x19
Aug 17 21:27:04 ubuntu kernel: [26639.188822] gvfs-fuse-dae D 00001835
 2996  3069      1 0x00000000
Aug 17 21:27:04 ubuntu kernel: [26639.188836]  e4987e8c 00000046
c1561746 00001835 c1042993 ec4f5ff4 c1689a00 00000046
Aug 17 21:27:04 ubuntu kernel: [26639.188857]  c1685eb8 c1689a00
ec4f5ff4 c1689a00 c1042993 00000007 ec4f5d60 c13ee6c2
Aug 17 21:27:04 ubuntu kernel: [26639.188877]  c14255f6 00001835
ec4f5d60 f630e804 00000002 e4987e80 c104a803 00000000
Aug 17 21:27:04 ubuntu kernel: [26639.188898] Call Trace:
Aug 17 21:27:04 ubuntu kernel: [26639.188907]  [<c1042993>] ?
refrigerator+0x72/0xdb
Aug 17 21:27:04 ubuntu kernel: [26639.188917]  [<c1042993>] ?
refrigerator+0x72/0xdb
Aug 17 21:27:04 ubuntu kernel: [26639.188926]  [<c13ee6c2>] ?
_spin_unlock_irq+0x22/0x45
Aug 17 21:27:04 ubuntu kernel: [26639.188936]  [<c104a803>] ?
trace_hardirqs_on+0xb/0xd
Aug 17 21:27:04 ubuntu kernel: [26639.188946]  [<c10429e5>]
refrigerator+0xc4/0xdb
Aug 17 21:27:04 ubuntu kernel: [26639.188955]  [<c1035b74>]
try_to_freeze+0x19/0x20
Aug 17 21:27:04 ubuntu kernel: [26639.188964]  [<c10371f0>]
get_signal_to_deliver+0x36/0x32e
Aug 17 21:27:04 ubuntu kernel: [26639.188974]  [<c1001fcd>]
do_notify_resume+0x77/0x735
Aug 17 21:27:04 ubuntu kernel: [26639.188983]  [<c1157a57>] ?
file_has_perm+0x87/0xa1
Aug 17 21:27:04 ubuntu kernel: [26639.188994]  [<c103ccb5>] ?
autoremove_wake_function+0x0/0x2f
Aug 17 21:27:04 ubuntu kernel: [26639.189005]  [<c1157ce4>] ?
selinux_file_permission+0x44/0x48
Aug 17 21:27:04 ubuntu kernel: [26639.189014]  [<c1154346>] ?
security_file_permission+0xf/0x11
Aug 17 21:27:04 ubuntu kernel: [26639.189023]  [<c109490a>] ?
rw_verify_area+0x98/0xbb
Aug 17 21:27:04 ubuntu kernel: [26639.189033]  [<c109478e>] ?
do_sync_read+0x0/0xe4
Aug 17 21:27:04 ubuntu kernel: [26639.189041]  [<c1094e62>] ? vfs_read+0x7d/0xdc
Aug 17 21:27:04 ubuntu kernel: [26639.189050]  [<c1094463>] ? fput_light+0xc/0xe
Aug 17 21:27:04 ubuntu kernel: [26639.189059]  [<c1094f6d>] ? sys_read+0x53/0x5d
Aug 17 21:27:04 ubuntu kernel: [26639.189068]  [<c1002d96>]
work_notifysig+0x13/0x19
Aug 17 21:27:04 ubuntu kernel: [26639.189076] gvfs-fuse-dae D 00001835
 2340  3070      1 0x00000000
Aug 17 21:27:04 ubuntu kernel: [26639.189089]  e53f8e8c 00000046
c15670e4 00001835 c1042993 ec4f0294 c1689a00 00000046
Aug 17 21:27:04 ubuntu kernel: [26639.189110]  c1685eb8 c1689a00
ec4f0294 c1689a00 c1042993 00000007 ec4f0000 c13ee6c2
Aug 17 21:27:04 ubuntu kernel: [26639.189130]  c1427a11 00001835
ec4f0000 f630e804 00000002 e53f8e80 c104a803 00000000
Aug 17 21:27:04 ubuntu kernel: [26639.189151] Call Trace:
Aug 17 21:27:04 ubuntu kernel: [26639.189160]  [<c1042993>] ?
refrigerator+0x72/0xdb
Aug 17 21:27:04 ubuntu kernel: [26639.189170]  [<c1042993>] ?
refrigerator+0x72/0xdb
Aug 17 21:27:04 ubuntu kernel: [26639.189179]  [<c13ee6c2>] ?
_spin_unlock_irq+0x22/0x45
Aug 17 21:27:04 ubuntu kernel: [26639.189189]  [<c104a803>] ?
trace_hardirqs_on+0xb/0xd
Aug 17 21:27:04 ubuntu kernel: [26639.189199]  [<c10429e5>]
refrigerator+0xc4/0xdb
Aug 17 21:27:04 ubuntu kernel: [26639.189209]  [<c1035b74>]
try_to_freeze+0x19/0x20
Aug 17 21:27:04 ubuntu kernel: [26639.189217]  [<c10371f0>]
get_signal_to_deliver+0x36/0x32e
Aug 17 21:27:04 ubuntu kernel: [26639.189227]  [<c1001fcd>]
do_notify_resume+0x77/0x735
Aug 17 21:27:04 ubuntu kernel: [26639.189237]  [<c1157a57>] ?
file_has_perm+0x87/0xa1
Aug 17 21:27:04 ubuntu kernel: [26639.189248]  [<c103ccb5>] ?
autoremove_wake_function+0x0/0x2f
Aug 17 21:27:04 ubuntu kernel: [26639.189258]  [<c1157ce4>] ?
selinux_file_permission+0x44/0x48
Aug 17 21:27:05 ubuntu kernel: [26639.189268]  [<c1154346>] ?
security_file_permission+0xf/0x11
Aug 17 21:27:05 ubuntu kernel: [26639.189277]  [<c109490a>] ?
rw_verify_area+0x98/0xbb
Aug 17 21:27:05 ubuntu kernel: [26639.189286]  [<c1094e70>] ? vfs_read+0x8b/0xdc
Aug 17 21:27:05 ubuntu kernel: [26639.189296]  [<c10a0e1a>] ? sys_poll+0x42/0x8b
Aug 17 21:27:05 ubuntu kernel: [26639.189305]  [<c1002d96>]
work_notifysig+0x13/0x19
Aug 17 21:27:05 ubuntu kernel: [26639.189313] seahorse-daem D 00001835
 2092  3079      1 0x00000000
Aug 17 21:27:05 ubuntu kernel: [26639.189326]  e782ce8c 00000046
c1571ffa 00001835 c1042993 ec5240d4 c1689a00 00000046
Aug 17 21:27:05 ubuntu kernel: [26639.189347]  c1685eb8 c1689a00
ec5240d4 c1689a00 c1042993 00000007 ec523e40 c13ee6c2
Aug 17 21:27:05 ubuntu kernel: [26639.189368]  c144afe8 00001835
ec523e40 f630ed84 00000002 e782ce80 c104a803 00000000
Aug 17 21:27:05 ubuntu kernel: [26639.189388] Call Trace:
Aug 17 21:27:05 ubuntu kernel: [26639.189397]  [<c1042993>] ?
refrigerator+0x72/0xdb
Aug 17 21:27:05 ubuntu kernel: [26639.189407]  [<c1042993>] ?
refrigerator+0x72/0xdb
Aug 17 21:27:05 ubuntu kernel: [26639.189417]  [<c13ee6c2>] ?
_spin_unlock_irq+0x22/0x45
Aug 17 21:27:05 ubuntu kernel: [26639.189427]  [<c104a803>] ?
trace_hardirqs_on+0xb/0xd
Aug 17 21:27:05 ubuntu kernel: [26639.189436]  [<c10429e5>]
refrigerator+0xc4/0xdb
Aug 17 21:27:05 ubuntu kernel: [26639.189446]  [<c1035b74>]
try_to_freeze+0x19/0x20
Aug 17 21:27:05 ubuntu kernel: [26639.189455]  [<c10371f0>]
get_signal_to_deliver+0x36/0x32e
Aug 17 21:27:05 ubuntu kernel: [26639.189465]  [<c1001fcd>]
do_notify_resume+0x77/0x735
Aug 17 21:27:05 ubuntu kernel: [26639.189474]  [<c1157a57>] ?
file_has_perm+0x87/0xa1
Aug 17 21:27:05 ubuntu kernel: [26639.189485]  [<c103ccb5>] ?
autoremove_wake_function+0x0/0x2f
Aug 17 21:27:05 ubuntu kernel: [26639.189495]  [<c1157ce4>] ?
selinux_file_permission+0x44/0x48
Aug 17 21:27:05 ubuntu kernel: [26639.189505]  [<c1154346>] ?
security_file_permission+0xf/0x11
Aug 17 21:27:05 ubuntu kernel: [26639.189514]  [<c109490a>] ?
rw_verify_area+0x98/0xbb
Aug 17 21:27:05 ubuntu kernel: [26639.189523]  [<c1094e70>] ? vfs_read+0x8b/0xdc
Aug 17 21:27:05 ubuntu kernel: [26639.189533]  [<c10a0e1a>] ? sys_poll+0x42/0x8b
Aug 17 21:27:05 ubuntu kernel: [26639.189542]  [<c1002d96>]
work_notifysig+0x13/0x19
Aug 17 21:27:05 ubuntu kernel: [26639.189550] notify-osd    D 00001835
 2080  3095      1 0x00000000
Aug 17 21:27:05 ubuntu kernel: [26639.189563]  e4555e8c 00200046
c166bc4f 00001835 c1042993 ee926a54 c1689a00 00200046
Aug 17 21:27:05 ubuntu kernel: [26639.189584]  c1685eb8 c1689a00
ee926a54 c1689a00 c1042993 00000007 ee9267c0 c13ee6c2
Aug 17 21:27:05 ubuntu kernel: [26639.189605]  c142c05a 00001835
ee9267c0 f600b104 00000002 e4555e80 c104a803 00000000
Aug 17 21:27:05 ubuntu kernel: [26639.189625] Call Trace:
Aug 17 21:27:05 ubuntu kernel: [26639.189635]  [<c1042993>] ?
refrigerator+0x72/0xdb
Aug 17 21:27:05 ubuntu kernel: [26639.189644]  [<c1042993>] ?
refrigerator+0x72/0xdb
Aug 17 21:27:05 ubuntu kernel: [26639.189654]  [<c13ee6c2>] ?
_spin_unlock_irq+0x22/0x45
Aug 17 21:27:05 ubuntu kernel: [26639.189664]  [<c104a803>] ?
trace_hardirqs_on+0xb/0xd
Aug 17 21:27:05 ubuntu kernel: [26639.189674]  [<c10429e5>]
refrigerator+0xc4/0xdb
Aug 17 21:27:05 ubuntu kernel: [26639.189683]  [<c1035b74>]
try_to_freeze+0x19/0x20
Aug 17 21:27:05 ubuntu kernel: [26639.189692]  [<c10371f0>]
get_signal_to_deliver+0x36/0x32e
Aug 17 21:27:05 ubuntu kernel: [26639.189702]  [<c1001fcd>]
do_notify_resume+0x77/0x735
Aug 17 21:27:05 ubuntu kernel: [26639.189711]  [<c1157a57>] ?
file_has_perm+0x87/0xa1
Aug 17 21:27:05 ubuntu kernel: [26639.189722]  [<c103ccb5>] ?
autoremove_wake_function+0x0/0x2f
Aug 17 21:27:05 ubuntu kernel: [26639.189733]  [<c1157ce4>] ?
selinux_file_permission+0x44/0x48
Aug 17 21:27:05 ubuntu kernel: [26639.189742]  [<c1154346>] ?
security_file_permission+0xf/0x11
Aug 17 21:27:05 ubuntu kernel: [26639.189751]  [<c109490a>] ?
rw_verify_area+0x98/0xbb
Aug 17 21:27:05 ubuntu kernel: [26639.189761]  [<c1094e70>] ? vfs_read+0x8b/0xdc
Aug 17 21:27:05 ubuntu kernel: [26639.189770]  [<c10a0e1a>] ? sys_poll+0x42/0x8b
Aug 17 21:27:05 ubuntu kernel: [26639.189779]  [<c1002d96>]
work_notifysig+0x13/0x19
Aug 17 21:27:05 ubuntu kernel: [26639.189787] compiz        D 00001835
 2500  3096   2982 0x00000000
Aug 17 21:27:05 ubuntu kernel: [26639.189801]  e9c36e8c 00000046
c167491e 00001835 c1042993 e4590cf4 c1689a00 00000046
Aug 17 21:27:05 ubuntu kernel: [26639.189821]  c1685eb8 c1689a00
e4590cf4 c1689a00 c1042993 00000007 e4590a60 c13ee6c2
Aug 17 21:27:05 ubuntu kernel: [26639.189842]  c1432957 00001835
e4590a60 f630a084 00000002 e9c36e80 c104a803 00000000
Aug 17 21:27:05 ubuntu kernel: [26639.189863] Call Trace:
Aug 17 21:27:05 ubuntu kernel: [26639.189872]  [<c1042993>] ?
refrigerator+0x72/0xdb
Aug 17 21:27:05 ubuntu kernel: [26639.189882]  [<c1042993>] ?
refrigerator+0x72/0xdb
Aug 17 21:27:05 ubuntu kernel: [26639.189891]  [<c13ee6c2>] ?
_spin_unlock_irq+0x22/0x45
Aug 17 21:27:05 ubuntu kernel: [26639.189901]  [<c104a803>] ?
trace_hardirqs_on+0xb/0xd
Aug 17 21:27:05 ubuntu kernel: [26639.189911]  [<c10429e5>]
refrigerator+0xc4/0xdb
Aug 17 21:27:05 ubuntu kernel: [26639.189920]  [<c1035b74>]
try_to_freeze+0x19/0x20
Aug 17 21:27:05 ubuntu kernel: [26639.189929]  [<c10371f0>]
get_signal_to_deliver+0x36/0x32e
Aug 17 21:27:05 ubuntu kernel: [26639.189939]  [<c1001fcd>]
do_notify_resume+0x77/0x735
Aug 17 21:27:05 ubuntu kernel: [26639.189950]  [<c103cec4>] ?
remove_wait_queue+0xf/0x27
Aug 17 21:27:05 ubuntu kernel: [26639.189959]  [<c13ee67b>] ?
_spin_unlock_irqrestore+0x36/0x5b
Aug 17 21:27:05 ubuntu kernel: [26639.189969]  [<c104a7d0>] ?
trace_hardirqs_on_caller+0x108/0x130
Aug 17 21:27:05 ubuntu kernel: [26639.189979]  [<c104a803>] ?
trace_hardirqs_on+0xb/0xd
Aug 17 21:27:05 ubuntu kernel: [26639.189988]  [<c13ee693>] ?
_spin_unlock_irqrestore+0x4e/0x5b
Aug 17 21:27:05 ubuntu kernel: [26639.189998]  [<c103ced7>] ?
remove_wait_queue+0x22/0x27
Aug 17 21:27:05 ubuntu kernel: [26639.190008]  [<c102e8e1>] ?
do_wait+0x1d9/0x290
Aug 17 21:27:05 ubuntu kernel: [26639.190017]  [<c10252f5>] ?
default_wake_function+0x0/0xd
Aug 17 21:27:05 ubuntu kernel: [26639.190027]  [<c102ea2c>] ?
sys_wait4+0x94/0xa1
Aug 17 21:27:05 ubuntu kernel: [26639.190037]  [<c1002d96>]
work_notifysig+0x13/0x19
Aug 17 21:27:05 ubuntu kernel: [26639.190044] compiz.real   D 00001835
 2056  3156   3096 0x00000000
Aug 17 21:27:05 ubuntu kernel: [26639.190059]  e41c2e8c 00200046
c15cc6df 00001835 c1042993 e4591754 c1689a00 00200046
Aug 17 21:27:05 ubuntu kernel: [26639.190080]  c1685eb8 c1689a00
e4591754 c1689a00 c1042993 00000007 e45914c0 c13ee6c2
Aug 17 21:27:05 ubuntu kernel: [26639.190100]  c147b517 00001835
e45914c0 f630f304 00000002 e41c2e80 c104a803 00000000
Aug 17 21:27:05 ubuntu kernel: [26639.190121] Call Trace:
Aug 17 21:27:05 ubuntu kernel: [26639.190130]  [<c1042993>] ?
refrigerator+0x72/0xdb
Aug 17 21:27:05 ubuntu kernel: [26639.190140]  [<c1042993>] ?
refrigerator+0x72/0xdb
Aug 17 21:27:05 ubuntu kernel: [26639.190149]  [<c13ee6c2>] ?
_spin_unlock_irq+0x22/0x45
Aug 17 21:27:05 ubuntu kernel: [26639.190159]  [<c104a803>] ?
trace_hardirqs_on+0xb/0xd
Aug 17 21:27:05 ubuntu kernel: [26639.190169]  [<c10429e5>]
refrigerator+0xc4/0xdb
Aug 17 21:27:05 ubuntu kernel: [26639.190178]  [<c1035b74>]
try_to_freeze+0x19/0x20
Aug 17 21:27:05 ubuntu kernel: [26639.190187]  [<c10371f0>]
get_signal_to_deliver+0x36/0x32e
Aug 17 21:27:05 ubuntu kernel: [26639.190197]  [<c1001fcd>]
do_notify_resume+0x77/0x735
Aug 17 21:27:05 ubuntu kernel: [26639.190207]  [<c1094592>] ?
fsnotify_modify+0x4f/0x5a
Aug 17 21:27:05 ubuntu kernel: [26639.190217]  [<c10952f9>] ?
do_readv_writev+0xd2/0xdf
Aug 17 21:27:05 ubuntu kernel: [26639.190227]  [<c1154346>] ?
security_file_permission+0xf/0x11
Aug 17 21:27:05 ubuntu kernel: [26639.190236]  [<c109490a>] ?
rw_verify_area+0x98/0xbb
Aug 17 21:27:05 ubuntu kernel: [26639.190247]  [<c10a0e1a>] ? sys_poll+0x42/0x8b
Aug 17 21:27:05 ubuntu kernel: [26639.190256]  [<c1002d96>]
work_notifysig+0x13/0x19
Aug 17 21:27:05 ubuntu kernel: [26639.190264] gnome-panel   D 00001835
 1960  3157   2982 0x00000000
Aug 17 21:27:05 ubuntu kernel: [26639.190277]  e43bfe8c 00000046
c174321c 00001835 c1042993 e45921b4 c1689a00 00000046
Aug 17 21:27:05 ubuntu kernel: [26639.190298]  c1685eb8 c1689a00
e45921b4 c1689a00 c1042993 00000007 e4591f20 c13ee6c2
Aug 17 21:27:05 ubuntu kernel: [26639.190318]  c1341b84 00001835
e4591f20 f6309b04 00000002 e43bfe80 c104a803 00000000
Aug 17 21:27:05 ubuntu kernel: [26639.190339] Call Trace:
Aug 17 21:27:05 ubuntu kernel: [26639.190348]  [<c1042993>] ?
refrigerator+0x72/0xdb
Aug 17 21:27:05 ubuntu kernel: [26639.190358]  [<c1042993>] ?
refrigerator+0x72/0xdb
Aug 17 21:27:05 ubuntu kernel: [26639.190368]  [<c13ee6c2>] ?
_spin_unlock_irq+0x22/0x45
Aug 17 21:27:05 ubuntu kernel: [26639.190378]  [<c1341b84>] ?
rt_set_nexthop+0xbf/0xe7
Aug 17 21:27:05 ubuntu kernel: [26639.190388]  [<c104a803>] ?
trace_hardirqs_on+0xb/0xd
Aug 17 21:27:05 ubuntu kernel: [26639.190397]  [<c10429e5>]
refrigerator+0xc4/0xdb
Aug 17 21:27:05 ubuntu kernel: [26639.190407]  [<c1035b74>]
try_to_freeze+0x19/0x20
Aug 17 21:27:05 ubuntu kernel: [26639.190415]  [<c10371f0>]
get_signal_to_deliver+0x36/0x32e
Aug 17 21:27:05 ubuntu kernel: [26639.190426]  [<c1001fcd>]
do_notify_resume+0x77/0x735
Aug 17 21:27:05 ubuntu kernel: [26639.190436]  [<c107e7e3>] ?
might_fault+0x4b/0x88
Aug 17 21:27:05 ubuntu kernel: [26639.190446]  [<c1043079>] ?
clocksource_read+0x9/0xc
Aug 17 21:27:05 ubuntu kernel: [26639.190456]  [<c1043382>] ?
getnstimeofday+0x4d/0xd7
Aug 17 21:27:05 ubuntu kernel: [26639.190466]  [<c10a0e1a>] ? sys_poll+0x42/0x8b
Aug 17 21:27:05 ubuntu kernel: [26639.190476]  [<c1002d96>]
work_notifysig+0x13/0x19
Aug 17 21:27:05 ubuntu kernel: [26639.190484] gnome-panel   D 00001835
 2152  3816   2982 0x00000000
Aug 17 21:27:05 ubuntu kernel: [26639.190497]  e84b1e8c 00000046
c167aa45 00001835 c1042993 d7c321b4 c1689a00 00000046
Aug 17 21:27:05 ubuntu kernel: [26639.190518]  c1685eb8 c1689a00
d7c321b4 c1689a00 c1042993 00000007 d7c31f20 c13ee6c2
Aug 17 21:27:05 ubuntu kernel: [26639.190539]  c1436f28 00001835
d7c31f20 f6309b04 00000002 e84b1e80 c104a803 00000000
Aug 17 21:27:05 ubuntu kernel: [26639.190559] Call Trace:
Aug 17 21:27:05 ubuntu kernel: [26639.190568]  [<c1042993>] ?
refrigerator+0x72/0xdb
Aug 17 21:27:05 ubuntu kernel: [26639.190578]  [<c1042993>] ?
refrigerator+0x72/0xdb
Aug 17 21:27:05 ubuntu kernel: [26639.190588]  [<c13ee6c2>] ?
_spin_unlock_irq+0x22/0x45
Aug 17 21:27:05 ubuntu kernel: [26639.190598]  [<c104a803>] ?
trace_hardirqs_on+0xb/0xd
Aug 17 21:27:05 ubuntu kernel: [26639.190607]  [<c10429e5>]
refrigerator+0xc4/0xdb
Aug 17 21:27:05 ubuntu kernel: [26639.190617]  [<c1035b74>]
try_to_freeze+0x19/0x20
Aug 17 21:27:05 ubuntu kernel: [26639.190625]  [<c10371f0>]
get_signal_to_deliver+0x36/0x32e
Aug 17 21:27:05 ubuntu kernel: [26639.190635]  [<c107e7e3>] ?
might_fault+0x4b/0x88
Aug 17 21:27:05 ubuntu kernel: [26639.190644]  [<c1001fcd>]
do_notify_resume+0x77/0x735
Aug 17 21:27:05 ubuntu kernel: [26639.190654]  [<c107e7e3>] ?
might_fault+0x4b/0x88
Aug 17 21:27:05 ubuntu kernel: [26639.190664]  [<c107e7e3>] ?
might_fault+0x4b/0x88
Aug 17 21:27:05 ubuntu kernel: [26639.190710]  [<c104f07c>] ?
sys_futex+0xe1/0xf5
Aug 17 21:27:05 ubuntu kernel: [26639.190720]  [<c10a0e1a>] ? sys_poll+0x42/0x8b
Aug 17 21:27:05 ubuntu kernel: [26639.190730]  [<c1002d96>]
work_notifysig+0x13/0x19
Aug 17 21:27:05 ubuntu kernel: [26639.190738] nautilus      D 00001835
 2080  3158   2982 0x00000000
Aug 17 21:27:05 ubuntu kernel: [26639.190752]  e3196e8c 00000046
c15f75f5 00001835 c1042993 e4590294 c1689a00 00000046
Aug 17 21:27:05 ubuntu kernel: [26639.190772]  c1685eb8 c1689a00
e4590294 c1689a00 c1042993 00000007 e4590000 c13ee6c2
Aug 17 21:27:05 ubuntu kernel: [26639.190793]  c13e7c07 00001835
e4590000 f630c704 00000002 e3196e80 c104a803 00000000
Aug 17 21:27:05 ubuntu kernel: [26639.190814] Call Trace:
Aug 17 21:27:05 ubuntu kernel: [26639.190823]  [<c1042993>] ?
refrigerator+0x72/0xdb
Aug 17 21:27:05 ubuntu kernel: [26639.190833]  [<c1042993>] ?
refrigerator+0x72/0xdb
Aug 17 21:27:05 ubuntu kernel: [26639.190842]  [<c13ee6c2>] ?
_spin_unlock_irq+0x22/0x45
Aug 17 21:27:05 ubuntu kernel: [26639.190851]  [<c13e7c07>] ?
early_init_amd+0x76/0xad
Aug 17 21:27:05 ubuntu kernel: [26639.190861]  [<c104a803>] ?
trace_hardirqs_on+0xb/0xd
Aug 17 21:27:05 ubuntu kernel: [26639.190871]  [<c10429e5>]
refrigerator+0xc4/0xdb
Aug 17 21:27:05 ubuntu kernel: [26639.190880]  [<c1035b74>]
try_to_freeze+0x19/0x20
Aug 17 21:27:05 ubuntu kernel: [26639.190889]  [<c10371f0>]
get_signal_to_deliver+0x36/0x32e
Aug 17 21:27:05 ubuntu kernel: [26639.190899]  [<c1001fcd>]
do_notify_resume+0x77/0x735
Aug 17 21:27:05 ubuntu kernel: [26639.190910]  [<c107e7e3>] ?
might_fault+0x4b/0x88
Aug 17 21:27:05 ubuntu kernel: [26639.190920]  [<c1043079>] ?
clocksource_read+0x9/0xc
Aug 17 21:27:05 ubuntu kernel: [26639.190929]  [<c1043382>] ?
getnstimeofday+0x4d/0xd7
Aug 17 21:27:05 ubuntu kernel: [26639.190940]  [<c10a0e1a>] ? sys_poll+0x42/0x8b
Aug 17 21:27:05 ubuntu kernel: [26639.190949]  [<c1002d96>]
work_notifysig+0x13/0x19
Aug 17 21:27:05 ubuntu kernel: [26639.190957] nautilus      D 00001835
 2220  6738   2982 0x00000000
Aug 17 21:27:05 ubuntu kernel: [26639.190970]  dbd52e8c 00000046
c167f798 00001835 c1042993 ec4f1754 c1689a00 00000046
Aug 17 21:27:05 ubuntu kernel: [26639.190991]  c1685eb8 c1689a00
ec4f1754 c1689a00 c1042993 00000007 ec4f14c0 c13ee6c2
Aug 17 21:27:05 ubuntu kernel: [26639.191012]  c1439072 00001835
ec4f14c0 f630c704 00000002 dbd52e80 c104a803 00000000
Aug 17 21:27:05 ubuntu kernel: [26639.191032] Call Trace:
Aug 17 21:27:05 ubuntu kernel: [26639.191041]  [<c1042993>] ?
refrigerator+0x72/0xdb
Aug 17 21:27:05 ubuntu kernel: [26639.191051]  [<c1042993>] ?
refrigerator+0x72/0xdb
Aug 17 21:27:05 ubuntu kernel: [26639.191061]  [<c13ee6c2>] ?
_spin_unlock_irq+0x22/0x45
Aug 17 21:27:05 ubuntu kernel: [26639.191071]  [<c104a803>] ?
trace_hardirqs_on+0xb/0xd
Aug 17 21:27:05 ubuntu kernel: [26639.191080]  [<c10429e5>]
refrigerator+0xc4/0xdb
Aug 17 21:27:05 ubuntu kernel: [26639.191090]  [<c1035b74>]
try_to_freeze+0x19/0x20
Aug 17 21:27:05 ubuntu kernel: [26639.191099]  [<c10371f0>]
get_signal_to_deliver+0x36/0x32e
Aug 17 21:27:05 ubuntu kernel: [26639.191108]  [<c107e7e3>] ?
might_fault+0x4b/0x88
Aug 17 21:27:05 ubuntu kernel: [26639.191117]  [<c1001fcd>]
do_notify_resume+0x77/0x735
Aug 17 21:27:05 ubuntu kernel: [26639.191128]  [<c107e7e3>] ?
might_fault+0x4b/0x88
Aug 17 21:27:05 ubuntu kernel: [26639.191137]  [<c107e7e3>] ?
might_fault+0x4b/0x88
Aug 17 21:27:05 ubuntu kernel: [26639.191148]  [<c131281a>] ?
sys_socketcall+0x169/0x185
Aug 17 21:27:05 ubuntu kernel: [26639.191158]  [<c10a0e1a>] ? sys_poll+0x42/0x8b
Aug 17 21:27:05 ubuntu kernel: [26639.191167]  [<c1002d96>]
work_notifysig+0x13/0x19
Aug 17 21:27:05 ubuntu kernel: [26639.191175] devkit-disks- D 00001835
 2096  3162      1 0x00000000
Aug 17 21:27:05 ubuntu kernel: [26639.191188]  e2a2fe8c 00000046
c168a0f4 00001835 c1042993 e4593674 c1689a00 00000046
Aug 17 21:27:05 ubuntu kernel: [26639.191209]  c1685eb8 c1689a00
e4593674 c1689a00 c1042993 00000007 e45933e0 c13ee6c2
Aug 17 21:27:05 ubuntu kernel: [26639.191229]  c143b307 00001835
e45933e0 f630c184 00000002 e2a2fe80 c104a803 00000000
Aug 17 21:27:05 ubuntu kernel: [26639.191250] Call Trace:
Aug 17 21:27:05 ubuntu kernel: [26639.191259]  [<c1042993>] ?
refrigerator+0x72/0xdb
Aug 17 21:27:05 ubuntu kernel: [26639.191269]  [<c1042993>] ?
refrigerator+0x72/0xdb
Aug 17 21:27:05 ubuntu kernel: [26639.191278]  [<c13ee6c2>] ?
_spin_unlock_irq+0x22/0x45
Aug 17 21:27:05 ubuntu kernel: [26639.191288]  [<c104a803>] ?
trace_hardirqs_on+0xb/0xd
Aug 17 21:27:05 ubuntu kernel: [26639.191298]  [<c10429e5>]
refrigerator+0xc4/0xdb
Aug 17 21:27:05 ubuntu kernel: [26639.191308]  [<c1035b74>]
try_to_freeze+0x19/0x20
Aug 17 21:27:05 ubuntu kernel: [26639.191316]  [<c10371f0>]
get_signal_to_deliver+0x36/0x32e
Aug 17 21:27:05 ubuntu kernel: [26639.191325]  [<c107e7e3>] ?
might_fault+0x4b/0x88
Aug 17 21:27:05 ubuntu kernel: [26639.191335]  [<c1001fcd>]
do_notify_resume+0x77/0x735
Aug 17 21:27:05 ubuntu kernel: [26639.191344]  [<c104bac2>] ?
__lock_acquire+0xad3/0xae2
Aug 17 21:27:05 ubuntu kernel: [26639.191354]  [<c107e7e3>] ?
might_fault+0x4b/0x88
Aug 17 21:27:05 ubuntu kernel: [26639.191364]  [<c1043079>] ?
clocksource_read+0x9/0xc
Aug 17 21:27:05 ubuntu kernel: [26639.191374]  [<c1043382>] ?
getnstimeofday+0x4d/0xd7
Aug 17 21:27:05 ubuntu kernel: [26639.191385]  [<c10a0e1a>] ? sys_poll+0x42/0x8b
Aug 17 21:27:05 ubuntu kernel: [26639.191394]  [<c1002d96>]
work_notifysig+0x13/0x19
Aug 17 21:27:05 ubuntu kernel: [26639.191402] devkit-disks- D 00001835
 2152  3163   3162 0x00000000
Aug 17 21:27:05 ubuntu kernel: [26639.191415]  e2440e8c 00000046
c168e4bb 00001835 c1042993 e4592c14 c1689a00 00000046
Aug 17 21:27:05 ubuntu kernel: [26639.191436]  c1685eb8 c1689a00
e4592c14 c1689a00 c1042993 00000007 e4592980 c13ee6c2
Aug 17 21:27:05 ubuntu kernel: [26639.191457]  c143d5d2 00001835
e4592980 f630d784 00000002 e2440e80 c104a803 00000000
Aug 17 21:27:05 ubuntu kernel: [26639.191477] Call Trace:
Aug 17 21:27:05 ubuntu kernel: [26639.191486]  [<c1042993>] ?
refrigerator+0x72/0xdb
Aug 17 21:27:05 ubuntu kernel: [26639.191496]  [<c1042993>] ?
refrigerator+0x72/0xdb
Aug 17 21:27:05 ubuntu kernel: [26639.191505]  [<c13ee6c2>] ?
_spin_unlock_irq+0x22/0x45
Aug 17 21:27:05 ubuntu kernel: [26639.191529]  [<c104a803>] ?
trace_hardirqs_on+0xb/0xd
Aug 17 21:27:05 ubuntu kernel: [26639.191544]  [<c10429e5>]
refrigerator+0xc4/0xdb
Aug 17 21:27:05 ubuntu kernel: [26639.191557]  [<c1035b74>]
try_to_freeze+0x19/0x20
Aug 17 21:27:05 ubuntu kernel: [26639.191571]  [<c10371f0>]
get_signal_to_deliver+0x36/0x32e
Aug 17 21:27:05 ubuntu kernel: [26639.191584]  [<c1001fcd>]
do_notify_resume+0x77/0x735
Aug 17 21:27:05 ubuntu kernel: [26639.191595]  [<c106f98b>] ?
unlock_page+0x47/0x4a
Aug 17 21:27:05 ubuntu kernel: [26639.191604]  [<c10812b6>] ?
__do_fault+0x2fb/0x327
Aug 17 21:27:05 ubuntu kernel: [26639.191617]  [<c10a0e1a>] ? sys_poll+0x42/0x8b
Aug 17 21:27:05 ubuntu kernel: [26639.191626]  [<c1002d96>]
work_notifysig+0x13/0x19
Aug 17 21:27:05 ubuntu kernel: [26639.191634] polkit-gnome- D 00001835
 2152  3165   2982 0x00000000
Aug 17 21:27:05 ubuntu kernel: [26639.191648]  e2574e8c 00000046
c1692ff2 00001835 c1042993 e41b21b4 c1689a00 00000046
Aug 17 21:27:06 ubuntu kernel: [26639.191668]  c1685eb8 c1689a00
e41b21b4 c1689a00 c1042993 00000007 e41b1f20 c13ee6c2
Aug 17 21:27:06 ubuntu kernel: [26639.191689]  c143f758 00001835
e41b1f20 f600a604 00000002 e2574e80 c104a803 00000000
Aug 17 21:27:06 ubuntu kernel: [26639.191710] Call Trace:
Aug 17 21:27:06 ubuntu kernel: [26639.191719]  [<c1042993>] ?
refrigerator+0x72/0xdb
Aug 17 21:27:06 ubuntu kernel: [26639.191729]  [<c1042993>] ?
refrigerator+0x72/0xdb
Aug 17 21:27:06 ubuntu kernel: [26639.191738]  [<c13ee6c2>] ?
_spin_unlock_irq+0x22/0x45
Aug 17 21:27:06 ubuntu kernel: [26639.191748]  [<c104a803>] ?
trace_hardirqs_on+0xb/0xd
Aug 17 21:27:06 ubuntu kernel: [26639.191758]  [<c10429e5>]
refrigerator+0xc4/0xdb
Aug 17 21:27:06 ubuntu kernel: [26639.191768]  [<c1035b74>]
try_to_freeze+0x19/0x20
Aug 17 21:27:06 ubuntu kernel: [26639.191776]  [<c10371f0>]
get_signal_to_deliver+0x36/0x32e
Aug 17 21:27:06 ubuntu kernel: [26639.191786]  [<c1001fcd>]
do_notify_resume+0x77/0x735
Aug 17 21:27:06 ubuntu kernel: [26639.191796]  [<c1157a57>] ?
file_has_perm+0x87/0xa1
Aug 17 21:27:06 ubuntu kernel: [26639.191807]  [<c103ccb5>] ?
autoremove_wake_function+0x0/0x2f
Aug 17 21:27:06 ubuntu kernel: [26639.191817]  [<c1157ce4>] ?
selinux_file_permission+0x44/0x48
Aug 17 21:27:06 ubuntu kernel: [26639.191827]  [<c1154346>] ?
security_file_permission+0xf/0x11
Aug 17 21:27:06 ubuntu kernel: [26639.191837]  [<c109490a>] ?
rw_verify_area+0x98/0xbb
Aug 17 21:27:06 ubuntu kernel: [26639.191846]  [<c1094e70>] ? vfs_read+0x8b/0xdc
Aug 17 21:27:06 ubuntu kernel: [26639.191855]  [<c10a0e1a>] ? sys_poll+0x42/0x8b
Aug 17 21:27:06 ubuntu kernel: [26639.191865]  [<c1002d96>]
work_notifysig+0x13/0x19
Aug 17 21:27:06 ubuntu kernel: [26639.191873] gdu-notificat D 00001835
 2152  3170   2982 0x00000000
Aug 17 21:27:06 ubuntu kernel: [26639.191886]  e25ade8c 00000046
c169875c 00001835 c1042993 e4595594 c1689a00 00000046
Aug 17 21:27:06 ubuntu kernel: [26639.191907]  c1685eb8 c1689a00
e4595594 c1689a00 c1042993 00000007 e4595300 c13ee6c2
Aug 17 21:27:06 ubuntu kernel: [26639.191927]  c1447758 00001835
e4595300 ee407e04 00000002 e25ade80 c104a803 00000000
Aug 17 21:27:06 ubuntu kernel: [26639.191948] Call Trace:
Aug 17 21:27:06 ubuntu kernel: [26639.191957]  [<c1042993>] ?
refrigerator+0x72/0xdb
Aug 17 21:27:06 ubuntu kernel: [26639.191967]  [<c1042993>] ?
refrigerator+0x72/0xdb
Aug 17 21:27:06 ubuntu kernel: [26639.191977]  [<c13ee6c2>] ?
_spin_unlock_irq+0x22/0x45
Aug 17 21:27:06 ubuntu kernel: [26639.191987]  [<c104a803>] ?
trace_hardirqs_on+0xb/0xd
Aug 17 21:27:06 ubuntu kernel: [26639.191996]  [<c10429e5>]
refrigerator+0xc4/0xdb
Aug 17 21:27:06 ubuntu kernel: [26639.192006]  [<c1035b74>]
try_to_freeze+0x19/0x20
Aug 17 21:27:06 ubuntu kernel: [26639.192014]  [<c10371f0>]
get_signal_to_deliver+0x36/0x32e
Aug 17 21:27:06 ubuntu kernel: [26639.192025]  [<c1001fcd>]
do_notify_resume+0x77/0x735
Aug 17 21:27:06 ubuntu kernel: [26639.192034]  [<c1157a57>] ?
file_has_perm+0x87/0xa1
Aug 17 21:27:06 ubuntu kernel: [26639.192045]  [<c103ccb5>] ?
autoremove_wake_function+0x0/0x2f
Aug 17 21:27:06 ubuntu kernel: [26639.192055]  [<c1157ce4>] ?
selinux_file_permission+0x44/0x48
Aug 17 21:27:06 ubuntu kernel: [26639.192065]  [<c1154346>] ?
security_file_permission+0xf/0x11
Aug 17 21:27:06 ubuntu kernel: [26639.192074]  [<c109490a>] ?
rw_verify_area+0x98/0xbb
Aug 17 21:27:06 ubuntu kernel: [26639.192083]  [<c1094e70>] ? vfs_read+0x8b/0xdc
Aug 17 21:27:06 ubuntu kernel: [26639.192093]  [<c10a0e1a>] ? sys_poll+0x42/0x8b
Aug 17 21:27:06 ubuntu kernel: [26639.192102]  [<c1002d96>]
work_notifysig+0x13/0x19
Aug 17 21:27:06 ubuntu kernel: [26639.192110] gnome-power-m D 00001835
 2080  3173   2982 0x00000000
Aug 17 21:27:06 ubuntu kernel: [26639.192123]  e2ba4e8c 00000046
c1448a81 00001835 c1042993 e45940d4 c1689a00 00000046
Aug 17 21:27:06 ubuntu kernel: [26639.192144]  c1685eb8 c1689a00
e45940d4 c1689a00 c1042993 00000007 e4593e40 c13ee6c2
Aug 17 21:27:06 ubuntu kernel: [26639.192164]  c1444d42 00001835
e4593e40 ee406804 00000002 e2ba4e80 c104a803 00000000
Aug 17 21:27:06 ubuntu kernel: [26639.192185] Call Trace:
Aug 17 21:27:06 ubuntu kernel: [26639.192194]  [<c1042993>] ?
refrigerator+0x72/0xdb
Aug 17 21:27:06 ubuntu kernel: [26639.192204]  [<c1042993>] ?
refrigerator+0x72/0xdb
Aug 17 21:27:06 ubuntu kernel: [26639.192213]  [<c13ee6c2>] ?
_spin_unlock_irq+0x22/0x45
Aug 17 21:27:06 ubuntu kernel: [26639.192223]  [<c104a803>] ?
trace_hardirqs_on+0xb/0xd
Aug 17 21:27:06 ubuntu kernel: [26639.192233]  [<c10429e5>]
refrigerator+0xc4/0xdb
Aug 17 21:27:06 ubuntu kernel: [26639.192242]  [<c1035b74>]
try_to_freeze+0x19/0x20
Aug 17 21:27:06 ubuntu kernel: [26639.192251]  [<c10371f0>]
get_signal_to_deliver+0x36/0x32e
Aug 17 21:27:06 ubuntu kernel: [26639.192260]  [<c107e7e3>] ?
might_fault+0x4b/0x88
Aug 17 21:27:06 ubuntu kernel: [26639.192270]  [<c1001fcd>]
do_notify_resume+0x77/0x735
Aug 17 21:27:06 ubuntu kernel: [26639.192279]  [<c104bac2>] ?
__lock_acquire+0xad3/0xae2
Aug 17 21:27:06 ubuntu kernel: [26639.192289]  [<c107e7e3>] ?
might_fault+0x4b/0x88
Aug 17 21:27:06 ubuntu kernel: [26639.192299]  [<c1043079>] ?
clocksource_read+0x9/0xc
Aug 17 21:27:06 ubuntu kernel: [26639.192309]  [<c1043382>] ?
getnstimeofday+0x4d/0xd7
Aug 17 21:27:06 ubuntu kernel: [26639.192320]  [<c10a0e1a>] ? sys_poll+0x42/0x8b
Aug 17 21:27:06 ubuntu kernel: [26639.192329]  [<c1002d96>]
work_notifysig+0x13/0x19
Aug 17 21:27:06 ubuntu kernel: [26639.192337] gnome-power-m D 00001835
 2340 11101   2982 0x00000000
Aug 17 21:27:06 ubuntu kernel: [26639.192350]  f4171e8c 00000046
c145b939 00001835 f4171000 df3f2c14 c1689a00 df3f2980
Aug 17 21:27:06 ubuntu kernel: [26639.192371]  c1685eb8 c1689a00
df3f2c14 c1689a00 00000007 00000002 f4171fb4 f4171e8c
Aug 17 21:27:06 ubuntu kernel: [26639.192392]  c1457eb6 00001835
df3f2980 ee4000d8 000000e0 ffffff10 c13ee6c8 00000000
Aug 17 21:27:06 ubuntu kernel: [26639.192412] Call Trace:
Aug 17 21:27:06 ubuntu kernel: [26639.192423]  [<c13ee6c8>] ?
_spin_unlock_irq+0x28/0x45
Aug 17 21:27:06 ubuntu kernel: [26639.192433]  [<c10429e5>]
refrigerator+0xc4/0xdb
Aug 17 21:27:06 ubuntu kernel: [26639.192443]  [<c1035b74>]
try_to_freeze+0x19/0x20
Aug 17 21:27:06 ubuntu kernel: [26639.192451]  [<c10371f0>]
get_signal_to_deliver+0x36/0x32e
Aug 17 21:27:06 ubuntu kernel: [26639.192460]  [<c107e7e3>] ?
might_fault+0x4b/0x88
Aug 17 21:27:06 ubuntu kernel: [26639.192470]  [<c1001fcd>]
do_notify_resume+0x77/0x735
Aug 17 21:27:06 ubuntu kernel: [26639.192480]  [<c107e7e3>] ?
might_fault+0x4b/0x88
Aug 17 21:27:06 ubuntu kernel: [26639.192490]  [<c107e7e3>] ?
might_fault+0x4b/0x88
Aug 17 21:27:06 ubuntu kernel: [26639.192500]  [<c131281a>] ?
sys_socketcall+0x169/0x185
Aug 17 21:27:06 ubuntu kernel: [26639.192510]  [<c10a0e1a>] ? sys_poll+0x42/0x8b
Aug 17 21:27:06 ubuntu kernel: [26639.192519]  [<c1002d96>]
work_notifysig+0x13/0x19
Aug 17 21:27:06 ubuntu kernel: [26639.192526] update-notifi D 00001835
 2080  3174   2982 0x00000000
Aug 17 21:27:06 ubuntu kernel: [26639.192540]  e2613e8c 00000046
c16a6ceb 00001835 c1042993 e4595ff4 c1689a00 00000046
Aug 17 21:27:06 ubuntu kernel: [26639.192560]  c1685eb8 c1689a00
e4595ff4 c1689a00 c1042993 00000007 e4595d60 c13ee6c2
Aug 17 21:27:06 ubuntu kernel: [26639.192581]  c1452048 00001835
e4595d60 ee406d84 00000002 e2613e80 c104a803 00000000
Aug 17 21:27:06 ubuntu kernel: [26639.192602] Call Trace:
Aug 17 21:27:06 ubuntu kernel: [26639.192611]  [<c1042993>] ?
refrigerator+0x72/0xdb
Aug 17 21:27:06 ubuntu kernel: [26639.192621]  [<c1042993>] ?
refrigerator+0x72/0xdb
Aug 17 21:27:06 ubuntu kernel: [26639.192630]  [<c13ee6c2>] ?
_spin_unlock_irq+0x22/0x45
Aug 17 21:27:06 ubuntu kernel: [26639.192640]  [<c104a803>] ?
trace_hardirqs_on+0xb/0xd
Aug 17 21:27:06 ubuntu kernel: [26639.192650]  [<c10429e5>]
refrigerator+0xc4/0xdb
Aug 17 21:27:06 ubuntu kernel: [26639.192659]  [<c1035b74>]
try_to_freeze+0x19/0x20
Aug 17 21:27:06 ubuntu kernel: [26639.192668]  [<c10371f0>]
get_signal_to_deliver+0x36/0x32e
Aug 17 21:27:06 ubuntu kernel: [26639.192678]  [<c1001fcd>]
do_notify_resume+0x77/0x735
Aug 17 21:27:06 ubuntu kernel: [26639.192688]  [<c104bac2>] ?
__lock_acquire+0xad3/0xae2
Aug 17 21:27:06 ubuntu kernel: [26639.192698]  [<c107e7e3>] ?
might_fault+0x4b/0x88
Aug 17 21:27:06 ubuntu kernel: [26639.192708]  [<c1043079>] ?
clocksource_read+0x9/0xc
Aug 17 21:27:06 ubuntu kernel: [26639.192717]  [<c1043382>] ?
getnstimeofday+0x4d/0xd7
Aug 17 21:27:06 ubuntu kernel: [26639.192728]  [<c10a0e1a>] ? sys_poll+0x42/0x8b
Aug 17 21:27:06 ubuntu kernel: [26639.192738]  [<c1002d96>]
work_notifysig+0x13/0x19
Aug 17 21:27:06 ubuntu kernel: [26639.192745] update-notifi D 00001835
 2152  9237   2982 0x00000000
Aug 17 21:27:06 ubuntu kernel: [26639.192758]  e0452e8c 00000046
c1577b0d 00001835 c1042993 c7901754 c1689a00 00000046
Aug 17 21:27:06 ubuntu kernel: [26639.192779]  c1685eb8 c1689a00
c7901754 c1689a00 c1042993 00000007 c79014c0 c13ee6c2
Aug 17 21:27:06 ubuntu kernel: [26639.192800]  c144fcb7 00001835
c79014c0 ee406d84 00000002 e0452e80 c104a803 00000000
Aug 17 21:27:06 ubuntu kernel: [26639.192820] Call Trace:
Aug 17 21:27:06 ubuntu kernel: [26639.192830]  [<c1042993>] ?
refrigerator+0x72/0xdb
Aug 17 21:27:06 ubuntu kernel: [26639.192839]  [<c1042993>] ?
refrigerator+0x72/0xdb
Aug 17 21:27:06 ubuntu kernel: [26639.192849]  [<c13ee6c2>] ?
_spin_unlock_irq+0x22/0x45
Aug 17 21:27:06 ubuntu kernel: [26639.192859]  [<c104a803>] ?
trace_hardirqs_on+0xb/0xd
Aug 17 21:27:06 ubuntu kernel: [26639.192868]  [<c10429e5>]
refrigerator+0xc4/0xdb
Aug 17 21:27:06 ubuntu kernel: [26639.192878]  [<c1035b74>]
try_to_freeze+0x19/0x20
Aug 17 21:27:06 ubuntu kernel: [26639.192887]  [<c10371f0>]
get_signal_to_deliver+0x36/0x32e
Aug 17 21:27:06 ubuntu kernel: [26639.192897]  [<c1001fcd>]
do_notify_resume+0x77/0x735
Aug 17 21:27:06 ubuntu kernel: [26639.192907]  [<c107e7e3>] ?
might_fault+0x4b/0x88
Aug 17 21:27:06 ubuntu kernel: [26639.192917]  [<c107e7e3>] ?
might_fault+0x4b/0x88
Aug 17 21:27:06 ubuntu kernel: [26639.192927]  [<c131281a>] ?
sys_socketcall+0x169/0x185
Aug 17 21:27:06 ubuntu kernel: [26639.192936]  [<c10a0e1a>] ? sys_poll+0x42/0x8b
Aug 17 21:27:06 ubuntu kernel: [26639.192946]  [<c1002d96>]
work_notifysig+0x13/0x19
Aug 17 21:27:06 ubuntu kernel: [26639.192953] gnome-volume- D 00001835
 2080  3176   2982 0x00000000
Aug 17 21:27:06 ubuntu kernel: [26639.192967]  e2632e8c 00000046
c15c8625 00001835 c1042993 e4596a54 c1689a00 00000046
Aug 17 21:27:06 ubuntu kernel: [26639.192987]  c1685eb8 c1689a00
e4596a54 c1689a00 c1042993 00000007 e45967c0 c13ee6c2
Aug 17 21:27:06 ubuntu kernel: [26639.193008]  c142e277 00001835
e45967c0 ee405784 00000002 e2632e80 c104a803 00000000
Aug 17 21:27:06 ubuntu kernel: [26639.193029] Call Trace:
Aug 17 21:27:06 ubuntu kernel: [26639.193038]  [<c1042993>] ?
refrigerator+0x72/0xdb
Aug 17 21:27:06 ubuntu kernel: [26639.193048]  [<c1042993>] ?
refrigerator+0x72/0xdb
Aug 17 21:27:06 ubuntu kernel: [26639.193057]  [<c13ee6c2>] ?
_spin_unlock_irq+0x22/0x45
Aug 17 21:27:06 ubuntu kernel: [26639.193067]  [<c104a803>] ?
trace_hardirqs_on+0xb/0xd
Aug 17 21:27:06 ubuntu kernel: [26639.193077]  [<c10429e5>]
refrigerator+0xc4/0xdb
Aug 17 21:27:06 ubuntu kernel: [26639.193086]  [<c1035b74>]
try_to_freeze+0x19/0x20
Aug 17 21:27:06 ubuntu kernel: [26639.193095]  [<c10371f0>]
get_signal_to_deliver+0x36/0x32e
Aug 17 21:27:06 ubuntu kernel: [26639.193105]  [<c1001fcd>]
do_notify_resume+0x77/0x735
Aug 17 21:27:06 ubuntu kernel: [26639.193114]  [<c1157a57>] ?
file_has_perm+0x87/0xa1
Aug 17 21:27:06 ubuntu kernel: [26639.193125]  [<c103ccb5>] ?
autoremove_wake_function+0x0/0x2f
Aug 17 21:27:06 ubuntu kernel: [26639.193136]  [<c1157ce4>] ?
selinux_file_permission+0x44/0x48
Aug 17 21:27:06 ubuntu kernel: [26639.193145]  [<c1154346>] ?
security_file_permission+0xf/0x11
Aug 17 21:27:06 ubuntu kernel: [26639.193154]  [<c109490a>] ?
rw_verify_area+0x98/0xbb
Aug 17 21:27:06 ubuntu kernel: [26639.193164]  [<c1094e70>] ? vfs_read+0x8b/0xdc
Aug 17 21:27:06 ubuntu kernel: [26639.193173]  [<c10a0e1a>] ? sys_poll+0x42/0x8b
Aug 17 21:27:06 ubuntu kernel: [26639.193183]  [<c1002d96>]
work_notifysig+0x13/0x19
Aug 17 21:27:06 ubuntu kernel: [26639.193190] python        D 00001835
 2220  3178   2982 0x00000000
Aug 17 21:27:06 ubuntu kernel: [26639.193204]  e26efe8c 00000046
c157e0ea 00001835 c1042993 ee925ff4 c1689a00 00000046
Aug 17 21:27:06 ubuntu kernel: [26639.193224]  c1685eb8 c1689a00
ee925ff4 c1689a00 c1042993 00000007 ee925d60 c13ee6c2
Aug 17 21:27:06 ubuntu kernel: [26639.193245]  c145d030 00001835
ee925d60 ee404184 00000002 e26efe80 c104a803 00000000
Aug 17 21:27:06 ubuntu kernel: [26639.193266] Call Trace:
Aug 17 21:27:06 ubuntu kernel: [26639.193275]  [<c1042993>] ?
refrigerator+0x72/0xdb
Aug 17 21:27:06 ubuntu kernel: [26639.193285]  [<c1042993>] ?
refrigerator+0x72/0xdb
Aug 17 21:27:06 ubuntu kernel: [26639.193294]  [<c13ee6c2>] ?
_spin_unlock_irq+0x22/0x45
Aug 17 21:27:06 ubuntu kernel: [26639.193304]  [<c104a803>] ?
trace_hardirqs_on+0xb/0xd
Aug 17 21:27:06 ubuntu kernel: [26639.193314]  [<c10429e5>]
refrigerator+0xc4/0xdb
Aug 17 21:27:06 ubuntu kernel: [26639.193323]  [<c1035b74>]
try_to_freeze+0x19/0x20
Aug 17 21:27:06 ubuntu kernel: [26639.193332]  [<c10371f0>]
get_signal_to_deliver+0x36/0x32e
Aug 17 21:27:06 ubuntu kernel: [26639.193342]  [<c1001fcd>]
do_notify_resume+0x77/0x735
Aug 17 21:27:06 ubuntu kernel: [26639.193351]  [<c1157a57>] ?
file_has_perm+0x87/0xa1
Aug 17 21:27:06 ubuntu kernel: [26639.193363]  [<c103ccb5>] ?
autoremove_wake_function+0x0/0x2f
Aug 17 21:27:06 ubuntu kernel: [26639.193373]  [<c1157ce4>] ?
selinux_file_permission+0x44/0x48
Aug 17 21:27:06 ubuntu kernel: [26639.193383]  [<c1154346>] ?
security_file_permission+0xf/0x11
Aug 17 21:27:06 ubuntu kernel: [26639.193392]  [<c109490a>] ?
rw_verify_area+0x98/0xbb
Aug 17 21:27:06 ubuntu kernel: [26639.193401]  [<c1094e70>] ? vfs_read+0x8b/0xdc
Aug 17 21:27:06 ubuntu kernel: [26639.193410]  [<c10a0e1a>] ? sys_poll+0x42/0x8b
Aug 17 21:27:06 ubuntu kernel: [26639.193420]  [<c1002d96>]
work_notifysig+0x13/0x19
Aug 17 21:27:06 ubuntu kernel: [26639.193428] evolution-ala D 00001835
 2204  3179   2982 0x00000000
Aug 17 21:27:06 ubuntu kernel: [26639.193441]  e26f5e8c 00000046
c16be691 00001835 c1042993 ec530cf4 c1689a00 00000046
Aug 17 21:27:06 ubuntu kernel: [26639.193462]  c1685eb8 c1689a00
ec530cf4 c1689a00 c1042993 00000007 ec530a60 c13ee6c2
Aug 17 21:27:06 ubuntu kernel: [26639.193483]  c1454638 00001835
ec530a60 ee407304 00000002 e26f5e80 c104a803 00000000
Aug 17 21:27:06 ubuntu kernel: [26639.193503] Call Trace:
Aug 17 21:27:06 ubuntu kernel: [26639.193512]  [<c1042993>] ?
refrigerator+0x72/0xdb
Aug 17 21:27:06 ubuntu kernel: [26639.193522]  [<c1042993>] ?
refrigerator+0x72/0xdb
Aug 17 21:27:06 ubuntu kernel: [26639.193532]  [<c13ee6c2>] ?
_spin_unlock_irq+0x22/0x45
Aug 17 21:27:06 ubuntu kernel: [26639.193542]  [<c104a803>] ?
trace_hardirqs_on+0xb/0xd
Aug 17 21:27:06 ubuntu kernel: [26639.193551]  [<c10429e5>]
refrigerator+0xc4/0xdb
Aug 17 21:27:06 ubuntu kernel: [26639.193561]  [<c1035b74>]
try_to_freeze+0x19/0x20
Aug 17 21:27:06 ubuntu kernel: [26639.193569]  [<c10371f0>]
get_signal_to_deliver+0x36/0x32e
Aug 17 21:27:06 ubuntu kernel: [26639.193578]  [<c107e7e3>] ?
might_fault+0x4b/0x88
Aug 17 21:27:06 ubuntu kernel: [26639.193588]  [<c1001fcd>]
do_notify_resume+0x77/0x735
Aug 17 21:27:06 ubuntu kernel: [26639.193598]  [<c104bac2>] ?
__lock_acquire+0xad3/0xae2
Aug 17 21:27:06 ubuntu kernel: [26639.193608]  [<c107e7e3>] ?
might_fault+0x4b/0x88
Aug 17 21:27:06 ubuntu kernel: [26639.193618]  [<c1043079>] ?
clocksource_read+0x9/0xc
Aug 17 21:27:06 ubuntu kernel: [26639.193627]  [<c1043382>] ?
getnstimeofday+0x4d/0xd7
Aug 17 21:27:06 ubuntu kernel: [26639.193638]  [<c10a0e1a>] ? sys_poll+0x42/0x8b
Aug 17 21:27:06 ubuntu kernel: [26639.193647]  [<c1002d96>]
work_notifysig+0x13/0x19
Aug 17 21:27:06 ubuntu kernel: [26639.193655] evolution-ala D 00001835
 2220  3369   2982 0x00000000
Aug 17 21:27:06 ubuntu kernel: [26639.193669]  dd735e8c 00000046
c16cbc7b 00001835 c1042993 df3e0294 c1689a00 00000046
Aug 17 21:27:06 ubuntu kernel: [26639.193689]  c1685eb8 c1689a00
df3e0294 c1689a00 c1042993 00000007 df3e0000 c13ee6c2
Aug 17 21:27:06 ubuntu kernel: [26639.193710]  c145a55a 00001835
df3e0000 ee407304 00000002 dd735e80 c104a803 00000000
Aug 17 21:27:06 ubuntu kernel: [26639.193730] Call Trace:
Aug 17 21:27:06 ubuntu kernel: [26639.193740]  [<c1042993>] ?
refrigerator+0x72/0xdb
Aug 17 21:27:06 ubuntu kernel: [26639.193749]  [<c1042993>] ?
refrigerator+0x72/0xdb
Aug 17 21:27:06 ubuntu kernel: [26639.193759]  [<c13ee6c2>] ?
_spin_unlock_irq+0x22/0x45
Aug 17 21:27:06 ubuntu kernel: [26639.193769]  [<c104a803>] ?
trace_hardirqs_on+0xb/0xd
Aug 17 21:27:06 ubuntu kernel: [26639.193778]  [<c10429e5>]
refrigerator+0xc4/0xdb
Aug 17 21:27:06 ubuntu kernel: [26639.193788]  [<c1035b74>]
try_to_freeze+0x19/0x20
Aug 17 21:27:06 ubuntu kernel: [26639.193797]  [<c10371f0>]
get_signal_to_deliver+0x36/0x32e
Aug 17 21:27:06 ubuntu kernel: [26639.193807]  [<c1001fcd>]
do_notify_resume+0x77/0x735
Aug 17 21:27:06 ubuntu kernel: [26639.193816]  [<c1157a57>] ?
file_has_perm+0x87/0xa1
Aug 17 21:27:06 ubuntu kernel: [26639.193827]  [<c103ccb5>] ?
autoremove_wake_function+0x0/0x2f
Aug 17 21:27:06 ubuntu kernel: [26639.193838]  [<c1094538>] ?
fsnotify_access+0x4f/0x5a
Aug 17 21:27:06 ubuntu kernel: [26639.193847]  [<c104f07c>] ?
sys_futex+0xe1/0xf5
Aug 17 21:27:06 ubuntu kernel: [26639.193857]  [<c10a0e1a>] ? sys_poll+0x42/0x8b
Aug 17 21:27:06 ubuntu kernel: [26639.193867]  [<c1002d96>]
work_notifysig+0x13/0x19
Aug 17 21:27:06 ubuntu kernel: [26639.193874] nm-applet     D 00001835
 2080  3182   2982 0x00800004
Aug 17 21:27:06 ubuntu kernel: [26639.193888]  e26ffe4c 00000046
bf375708 00001835 00000000 f60074b4 c1689a00 e26ffe0c
Aug 17 21:27:06 ubuntu kernel: [26639.193908]  c1685eb8 c1689a00
f60074b4 c1689a00 006d2b00 0f8ef215 00000000 e27260b0
Aug 17 21:27:06 ubuntu kernel: [26639.193929]  bf2aac4a 00001835
f6007220 c103fd87 c2c9da00 e4ee8540 e26ffe44 c2c9da00
Aug 17 21:27:06 ubuntu kernel: [26639.193950] Call Trace:
Aug 17 21:27:06 ubuntu kernel: [26639.193960]  [<c103fd87>] ?
ktime_get_ts+0x40/0x44
Aug 17 21:27:06 ubuntu kernel: [26639.193970]  [<c13ecefb>]
io_schedule+0x23/0x32
Aug 17 21:27:06 ubuntu kernel: [26639.193979]  [<c106f8a5>] sync_page+0x42/0x46
Aug 17 21:27:06 ubuntu kernel: [26639.193988]  [<c13ed140>]
__wait_on_bit_lock+0x34/0x70
Aug 17 21:27:06 ubuntu kernel: [26639.193997]  [<c106f863>] ? sync_page+0x0/0x46
Aug 17 21:27:06 ubuntu kernel: [26639.194043]  [<c106f825>]
__lock_page+0x6c/0x74
Aug 17 21:27:06 ubuntu kernel: [26639.194054]  [<c103cce4>] ?
wake_bit_function+0x0/0x37
Aug 17 21:27:06 ubuntu kernel: [26639.194063]  [<c106f854>] lock_page+0x27/0x2a
Aug 17 21:27:06 ubuntu kernel: [26639.194072]  [<c106f9ac>]
find_lock_page+0x1e/0x43
Aug 17 21:27:06 ubuntu kernel: [26639.194082]  [<c106ff68>]
filemap_fault+0x1ee/0x369
Aug 17 21:27:06 ubuntu kernel: [26639.194092]  [<c1080ff4>]
__do_fault+0x39/0x327
Aug 17 21:27:06 ubuntu kernel: [26639.194103]  [<c1081608>]
handle_mm_fault+0x326/0x705
Aug 17 21:27:06 ubuntu kernel: [26639.194115]  [<c101a629>]
do_page_fault+0x1fc/0x20b
Aug 17 21:27:06 ubuntu kernel: [26639.194124]  [<c101a42d>] ?
do_page_fault+0x0/0x20b
Aug 17 21:27:06 ubuntu kernel: [26639.194134]  [<c13eeab8>] error_code+0x78/0x80
Aug 17 21:27:06 ubuntu kernel: [26639.194142] nm-applet     D 00001835
 2152  3578   2982 0x00000000
Aug 17 21:27:06 ubuntu kernel: [26639.194155]  c928de8c 00000046
c1461368 00001835 c1042993 df3f40d4 c1689a00 00000046
Aug 17 21:27:06 ubuntu kernel: [26639.194176]  c1685eb8 c1689a00
df3f40d4 c1689a00 c1042993 00000007 df3f3e40 c13ee6c2
Aug 17 21:27:06 ubuntu kernel: [26639.194197]  c145f9c3 00001835
df3f3e40 ee407884 00000002 c928de80 c104a803 00000000
Aug 17 21:27:06 ubuntu kernel: [26639.194217] Call Trace:
Aug 17 21:27:07 ubuntu kernel: [26639.194227]  [<c1042993>] ?
refrigerator+0x72/0xdb
Aug 17 21:27:07 ubuntu kernel: [26639.194237]  [<c1042993>] ?
refrigerator+0x72/0xdb
Aug 17 21:27:07 ubuntu kernel: [26639.194246]  [<c13ee6c2>] ?
_spin_unlock_irq+0x22/0x45
Aug 17 21:27:07 ubuntu kernel: [26639.194256]  [<c104a803>] ?
trace_hardirqs_on+0xb/0xd
Aug 17 21:27:07 ubuntu kernel: [26639.194266]  [<c10429e5>]
refrigerator+0xc4/0xdb
Aug 17 21:27:07 ubuntu kernel: [26639.194275]  [<c1035b74>]
try_to_freeze+0x19/0x20
Aug 17 21:27:07 ubuntu kernel: [26639.194284]  [<c10371f0>]
get_signal_to_deliver+0x36/0x32e
Aug 17 21:27:07 ubuntu kernel: [26639.194293]  [<c107e7e3>] ?
might_fault+0x4b/0x88
Aug 17 21:27:07 ubuntu kernel: [26639.194303]  [<c1001fcd>]
do_notify_resume+0x77/0x735
Aug 17 21:27:07 ubuntu kernel: [26639.194312]  [<c1049cb7>] ?
trace_hardirqs_off+0xb/0xd
Aug 17 21:27:07 ubuntu kernel: [26639.194322]  [<c107e7e3>] ?
might_fault+0x4b/0x88
Aug 17 21:27:07 ubuntu kernel: [26639.194332]  [<c107e7e3>] ?
might_fault+0x4b/0x88
Aug 17 21:27:07 ubuntu kernel: [26639.194342]  [<c131281a>] ?
sys_socketcall+0x169/0x185
Aug 17 21:27:07 ubuntu kernel: [26639.194351]  [<c10a0e1a>] ? sys_poll+0x42/0x8b
Aug 17 21:27:07 ubuntu kernel: [26639.194361]  [<c1002d96>]
work_notifysig+0x13/0x19
Aug 17 21:27:07 ubuntu kernel: [26639.194368] bluetooth-app D 00001835
 2172  3184   2982 0x00000000
Aug 17 21:27:07 ubuntu kernel: [26639.194382]  e2774e8c 00000046
c16d5d8f 00001835 c1042993 e2790294 c1689a00 00000046
Aug 17 21:27:07 ubuntu kernel: [26639.194402]  c1685eb8 c1689a00
e2790294 c1689a00 c1042993 00000007 e2790000 c13ee6c2
Aug 17 21:27:07 ubuntu kernel: [26639.194423]  c146995c 00001835
e2790000 ee401584 00000002 e2774e80 c104a803 00000000
Aug 17 21:27:07 ubuntu kernel: [26639.194443] Call Trace:
Aug 17 21:27:07 ubuntu kernel: [26639.194453]  [<c1042993>] ?
refrigerator+0x72/0xdb
Aug 17 21:27:07 ubuntu kernel: [26639.194463]  [<c1042993>] ?
refrigerator+0x72/0xdb
Aug 17 21:27:07 ubuntu kernel: [26639.194472]  [<c13ee6c2>] ?
_spin_unlock_irq+0x22/0x45
Aug 17 21:27:07 ubuntu kernel: [26639.194482]  [<c104a803>] ?
trace_hardirqs_on+0xb/0xd
Aug 17 21:27:07 ubuntu kernel: [26639.194492]  [<c10429e5>]
refrigerator+0xc4/0xdb
Aug 17 21:27:07 ubuntu kernel: [26639.194501]  [<c1035b74>]
try_to_freeze+0x19/0x20
Aug 17 21:27:07 ubuntu kernel: [26639.194510]  [<c10371f0>]
get_signal_to_deliver+0x36/0x32e
Aug 17 21:27:07 ubuntu kernel: [26639.194520]  [<c1001fcd>]
do_notify_resume+0x77/0x735
Aug 17 21:27:07 ubuntu kernel: [26639.194529]  [<c1157a57>] ?
file_has_perm+0x87/0xa1
Aug 17 21:27:07 ubuntu kernel: [26639.194540]  [<c103ccb5>] ?
autoremove_wake_function+0x0/0x2f
Aug 17 21:27:07 ubuntu kernel: [26639.194551]  [<c1157ce4>] ?
selinux_file_permission+0x44/0x48
Aug 17 21:27:07 ubuntu kernel: [26639.194560]  [<c1154346>] ?
security_file_permission+0xf/0x11
Aug 17 21:27:07 ubuntu kernel: [26639.194570]  [<c109490a>] ?
rw_verify_area+0x98/0xbb
Aug 17 21:27:07 ubuntu kernel: [26639.194579]  [<c1094e70>] ? vfs_read+0x8b/0xdc
Aug 17 21:27:07 ubuntu kernel: [26639.194588]  [<c10a0e1a>] ? sys_poll+0x42/0x8b
Aug 17 21:27:07 ubuntu kernel: [26639.194598]  [<c1002d96>]
work_notifysig+0x13/0x19
Aug 17 21:27:07 ubuntu kernel: [26639.194606] polkitd-1     D 00001835
 2152  3194      1 0x00000000
Aug 17 21:27:07 ubuntu kernel: [26639.194620]  e20e0e8c 00000046
c1583920 00001835 c1042993 e41b5594 c1689a00 00000046
Aug 17 21:27:07 ubuntu kernel: [26639.194641]  c1685eb8 c1689a00
e41b5594 c1689a00 c1042993 00000007 e41b5300 c13ee6c2
Aug 17 21:27:07 ubuntu kernel: [26639.194661]  c1462860 00001835
e41b5300 f600dd04 00000002 e20e0e80 c104a803 00000000
Aug 17 21:27:07 ubuntu kernel: [26639.194682] Call Trace:
Aug 17 21:27:07 ubuntu kernel: [26639.194691]  [<c1042993>] ?
refrigerator+0x72/0xdb
Aug 17 21:27:07 ubuntu kernel: [26639.194701]  [<c1042993>] ?
refrigerator+0x72/0xdb
Aug 17 21:27:07 ubuntu kernel: [26639.194710]  [<c13ee6c2>] ?
_spin_unlock_irq+0x22/0x45
Aug 17 21:27:07 ubuntu kernel: [26639.194720]  [<c104a803>] ?
trace_hardirqs_on+0xb/0xd
Aug 17 21:27:07 ubuntu kernel: [26639.194730]  [<c10429e5>]
refrigerator+0xc4/0xdb
Aug 17 21:27:07 ubuntu kernel: [26639.194739]  [<c1035b74>]
try_to_freeze+0x19/0x20
Aug 17 21:27:07 ubuntu kernel: [26639.194748]  [<c10371f0>]
get_signal_to_deliver+0x36/0x32e
Aug 17 21:27:07 ubuntu kernel: [26639.194758]  [<c1001fcd>]
do_notify_resume+0x77/0x735
Aug 17 21:27:07 ubuntu kernel: [26639.194768]  [<c1043382>] ?
getnstimeofday+0x4d/0xd7
Aug 17 21:27:07 ubuntu kernel: [26639.194779]  [<c10131de>] ?
lapic_next_event+0xf/0x13
Aug 17 21:27:07 ubuntu kernel: [26639.194788]  [<c10463c3>] ?
clockevents_program_event+0xba/0xc8
Aug 17 21:27:07 ubuntu kernel: [26639.194797]  [<c10473ac>] ?
tick_dev_program_event+0x34/0xa2
Aug 17 21:27:07 ubuntu kernel: [26639.194807]  [<c1047475>] ?
tick_program_event+0x33/0x3b
Aug 17 21:27:07 ubuntu kernel: [26639.194817]  [<c103ff0f>] ?
hrtimer_interrupt+0x156/0x166
Aug 17 21:27:07 ubuntu kernel: [26639.194827]  [<c10a0e1a>] ? sys_poll+0x42/0x8b
Aug 17 21:27:07 ubuntu kernel: [26639.194837]  [<c1002d96>]
work_notifysig+0x13/0x19
Aug 17 21:27:07 ubuntu kernel: [26639.194859] gnome-screens D 00001835
 2080  3199      1 0x00000000
Aug 17 21:27:07 ubuntu kernel: [26639.194878]  e206fe8c 00000046
c146d001 00001835 c1042993 e41b4b34 c1689a00 00000046
Aug 17 21:27:07 ubuntu kernel: [26639.194910]  c1685eb8 c1689a00
e41b4b34 c1689a00 c1042993 00000007 e41b48a0 c13ee6c2
Aug 17 21:27:07 ubuntu kernel: [26639.194932]  c14673d3 00001835
e41b48a0 f600a084 00000002 e206fe80 c104a803 00000000
Aug 17 21:27:07 ubuntu kernel: [26639.194953] Call Trace:
Aug 17 21:27:07 ubuntu kernel: [26639.194964]  [<c1042993>] ?
refrigerator+0x72/0xdb
Aug 17 21:27:07 ubuntu kernel: [26639.194973]  [<c1042993>] ?
refrigerator+0x72/0xdb
Aug 17 21:27:07 ubuntu kernel: [26639.194983]  [<c13ee6c2>] ?
_spin_unlock_irq+0x22/0x45
Aug 17 21:27:07 ubuntu kernel: [26639.194993]  [<c104a803>] ?
trace_hardirqs_on+0xb/0xd
Aug 17 21:27:07 ubuntu kernel: [26639.195003]  [<c10429e5>]
refrigerator+0xc4/0xdb
Aug 17 21:27:07 ubuntu kernel: [26639.195012]  [<c1035b74>]
try_to_freeze+0x19/0x20
Aug 17 21:27:07 ubuntu kernel: [26639.195021]  [<c10371f0>]
get_signal_to_deliver+0x36/0x32e
Aug 17 21:27:07 ubuntu kernel: [26639.195031]  [<c1001fcd>]
do_notify_resume+0x77/0x735
Aug 17 21:27:07 ubuntu kernel: [26639.195041]  [<c104bac2>] ?
__lock_acquire+0xad3/0xae2
Aug 17 21:27:07 ubuntu kernel: [26639.195051]  [<c107e7e3>] ?
might_fault+0x4b/0x88
Aug 17 21:27:07 ubuntu kernel: [26639.195061]  [<c1043079>] ?
clocksource_read+0x9/0xc
Aug 17 21:27:07 ubuntu kernel: [26639.195071]  [<c1043382>] ?
getnstimeofday+0x4d/0xd7
Aug 17 21:27:07 ubuntu kernel: [26639.195081]  [<c10a0e1a>] ? sys_poll+0x42/0x8b
Aug 17 21:27:07 ubuntu kernel: [26639.195091]  [<c1002d96>]
work_notifysig+0x13/0x19
Aug 17 21:27:07 ubuntu kernel: [26639.195099] gnome-screens D 00001835
 2340 11113      1 0x00000000
Aug 17 21:27:07 ubuntu kernel: [26639.195113]  f4e6ce8c 00000046
c1588cdb 00001835 c1042993 d4415ff4 c1689a00 00000046
Aug 17 21:27:07 ubuntu kernel: [26639.195133]  c1685eb8 c1689a00
d4415ff4 c1689a00 c1042993 00000007 d4415d60 c13ee6c2
Aug 17 21:27:07 ubuntu kernel: [26639.195154]  c1464e4a 00001835
d4415d60 f600a084 00000002 f4e6ce80 c104a803 00000000
Aug 17 21:27:07 ubuntu kernel: [26639.195174] Call Trace:
Aug 17 21:27:07 ubuntu kernel: [26639.195184]  [<c1042993>] ?
refrigerator+0x72/0xdb
Aug 17 21:27:07 ubuntu kernel: [26639.195194]  [<c1042993>] ?
refrigerator+0x72/0xdb
Aug 17 21:27:07 ubuntu kernel: [26639.195203]  [<c13ee6c2>] ?
_spin_unlock_irq+0x22/0x45
Aug 17 21:27:07 ubuntu kernel: [26639.195213]  [<c104a803>] ?
trace_hardirqs_on+0xb/0xd
Aug 17 21:27:07 ubuntu kernel: [26639.195223]  [<c10429e5>]
refrigerator+0xc4/0xdb
Aug 17 21:27:07 ubuntu kernel: [26639.195232]  [<c1035b74>]
try_to_freeze+0x19/0x20
Aug 17 21:27:07 ubuntu kernel: [26639.195241]  [<c10371f0>]
get_signal_to_deliver+0x36/0x32e
Aug 17 21:27:07 ubuntu kernel: [26639.195251]  [<c1001fcd>]
do_notify_resume+0x77/0x735
Aug 17 21:27:07 ubuntu kernel: [26639.195261]  [<c106f98b>] ?
unlock_page+0x47/0x4a
Aug 17 21:27:07 ubuntu kernel: [26639.195270]  [<c10812b6>] ?
__do_fault+0x2fb/0x327
Aug 17 21:27:07 ubuntu kernel: [26639.195282]  [<c104f07c>] ?
sys_futex+0xe1/0xf5
Aug 17 21:27:07 ubuntu kernel: [26639.195292]  [<c10a0e1a>] ? sys_poll+0x42/0x8b
Aug 17 21:27:07 ubuntu kernel: [26639.195301]  [<c1002d96>]
work_notifysig+0x13/0x19
Aug 17 21:27:07 ubuntu kernel: [26639.195309] sh            D 00001835
 2664  3209   3156 0x00000000
Aug 17 21:27:07 ubuntu kernel: [26639.195323]  e1c2ce8c 00200046
c158ebc7 00001835 c1042993 e41b3674 c1689a00 00200046
Aug 17 21:27:07 ubuntu kernel: [26639.195344]  c1685eb8 c1689a00
e41b3674 c1689a00 c1042993 00000007 e41b33e0 c13ee6c2
Aug 17 21:27:07 ubuntu kernel: [26639.195364]  c146e8c6 00001835
e41b33e0 f600e804 00000002 e1c2ce80 c104a803 00000000
Aug 17 21:27:07 ubuntu kernel: [26639.195385] Call Trace:
Aug 17 21:27:07 ubuntu kernel: [26639.195394]  [<c1042993>] ?
refrigerator+0x72/0xdb
Aug 17 21:27:07 ubuntu kernel: [26639.195404]  [<c1042993>] ?
refrigerator+0x72/0xdb
Aug 17 21:27:07 ubuntu kernel: [26639.195413]  [<c13ee6c2>] ?
_spin_unlock_irq+0x22/0x45
Aug 17 21:27:07 ubuntu kernel: [26639.195423]  [<c104a803>] ?
trace_hardirqs_on+0xb/0xd
Aug 17 21:27:07 ubuntu kernel: [26639.195433]  [<c10429e5>]
refrigerator+0xc4/0xdb
Aug 17 21:27:07 ubuntu kernel: [26639.195442]  [<c1035b74>]
try_to_freeze+0x19/0x20
Aug 17 21:27:07 ubuntu kernel: [26639.195451]  [<c10371f0>]
get_signal_to_deliver+0x36/0x32e
Aug 17 21:27:07 ubuntu kernel: [26639.195461]  [<c1001fcd>]
do_notify_resume+0x77/0x735
Aug 17 21:27:07 ubuntu kernel: [26639.195472]  [<c103cec4>] ?
remove_wait_queue+0xf/0x27
Aug 17 21:27:07 ubuntu kernel: [26639.195481]  [<c13ee67b>] ?
_spin_unlock_irqrestore+0x36/0x5b
Aug 17 21:27:07 ubuntu kernel: [26639.195491]  [<c104a7d0>] ?
trace_hardirqs_on_caller+0x108/0x130
Aug 17 21:27:07 ubuntu kernel: [26639.195501]  [<c104a803>] ?
trace_hardirqs_on+0xb/0xd
Aug 17 21:27:07 ubuntu kernel: [26639.195510]  [<c13ee693>] ?
_spin_unlock_irqrestore+0x4e/0x5b
Aug 17 21:27:07 ubuntu kernel: [26639.195520]  [<c103ced7>] ?
remove_wait_queue+0x22/0x27
Aug 17 21:27:07 ubuntu kernel: [26639.195530]  [<c102e8e1>] ?
do_wait+0x1d9/0x290
Aug 17 21:27:07 ubuntu kernel: [26639.195539]  [<c10252f5>] ?
default_wake_function+0x0/0xd
Aug 17 21:27:07 ubuntu kernel: [26639.195549]  [<c102ea2c>] ?
sys_wait4+0x94/0xa1
Aug 17 21:27:07 ubuntu kernel: [26639.195559]  [<c1002d96>]
work_notifysig+0x13/0x19
Aug 17 21:27:07 ubuntu kernel: [26639.195566] gtk-window-de D 00001835
 1940  3210   3209 0x00000000
Aug 17 21:27:07 ubuntu kernel: [26639.195580]  e1c35e8c 00000046
c1475488 00001835 c1042993 e41b5ff4 c1689a00 00000046
Aug 17 21:27:07 ubuntu kernel: [26639.195600]  c1685eb8 c1689a00
e41b5ff4 c1689a00 c1042993 00000007 e41b5d60 c13ee6c2
Aug 17 21:27:07 ubuntu kernel: [26639.195621]  c14734d5 00001835
e41b5d60 f600e284 00000002 e1c35e80 c104a803 00000000
Aug 17 21:27:07 ubuntu kernel: [26639.195641] Call Trace:
Aug 17 21:27:07 ubuntu kernel: [26639.195651]  [<c1042993>] ?
refrigerator+0x72/0xdb
Aug 17 21:27:07 ubuntu kernel: [26639.195661]  [<c1042993>] ?
refrigerator+0x72/0xdb
Aug 17 21:27:07 ubuntu kernel: [26639.195670]  [<c13ee6c2>] ?
_spin_unlock_irq+0x22/0x45
Aug 17 21:27:07 ubuntu kernel: [26639.195680]  [<c104a803>] ?
trace_hardirqs_on+0xb/0xd
Aug 17 21:27:07 ubuntu kernel: [26639.195690]  [<c10429e5>]
refrigerator+0xc4/0xdb
Aug 17 21:27:07 ubuntu kernel: [26639.195699]  [<c1035b74>]
try_to_freeze+0x19/0x20
Aug 17 21:27:07 ubuntu kernel: [26639.195708]  [<c10371f0>]
get_signal_to_deliver+0x36/0x32e
Aug 17 21:27:07 ubuntu kernel: [26639.195718]  [<c1001fcd>]
do_notify_resume+0x77/0x735
Aug 17 21:27:07 ubuntu kernel: [26639.195727]  [<c1157a57>] ?
file_has_perm+0x87/0xa1
Aug 17 21:27:07 ubuntu kernel: [26639.195738]  [<c103ccb5>] ?
autoremove_wake_function+0x0/0x2f
Aug 17 21:27:07 ubuntu kernel: [26639.195749]  [<c1157ce4>] ?
selinux_file_permission+0x44/0x48
Aug 17 21:27:07 ubuntu kernel: [26639.195758]  [<c1154346>] ?
security_file_permission+0xf/0x11
Aug 17 21:27:07 ubuntu kernel: [26639.195767]  [<c109490a>] ?
rw_verify_area+0x98/0xbb
Aug 17 21:27:07 ubuntu kernel: [26639.195777]  [<c1094e70>] ? vfs_read+0x8b/0xdc
Aug 17 21:27:07 ubuntu kernel: [26639.195786]  [<c10a0e1a>] ? sys_poll+0x42/0x8b
Aug 17 21:27:07 ubuntu kernel: [26639.195796]  [<c1002d96>]
work_notifysig+0x13/0x19
Aug 17 21:27:07 ubuntu kernel: [26639.195803] gtk-window-de D 00001835
 2220  4735   3209 0x00000000
Aug 17 21:27:07 ubuntu kernel: [26639.195817]  d2f8ee8c 00200046
c16db93e 00001835 c1042993 d7c35ff4 c1689a00 00200046
Aug 17 21:27:07 ubuntu kernel: [26639.195838]  c1685eb8 c1689a00
d7c35ff4 c1689a00 c1042993 00000007 d7c35d60 c13ee6c2
Aug 17 21:27:07 ubuntu kernel: [26639.195858]  c146c01e 00001835
d7c35d60 f600e284 00000002 d2f8ee80 c104a803 00000000
Aug 17 21:27:07 ubuntu kernel: [26639.195879] Call Trace:
Aug 17 21:27:07 ubuntu kernel: [26639.195888]  [<c1042993>] ?
refrigerator+0x72/0xdb
Aug 17 21:27:07 ubuntu kernel: [26639.195898]  [<c1042993>] ?
refrigerator+0x72/0xdb
Aug 17 21:27:07 ubuntu kernel: [26639.195907]  [<c13ee6c2>] ?
_spin_unlock_irq+0x22/0x45
Aug 17 21:27:07 ubuntu kernel: [26639.195917]  [<c104a803>] ?
trace_hardirqs_on+0xb/0xd
Aug 17 21:27:07 ubuntu kernel: [26639.195927]  [<c10429e5>]
refrigerator+0xc4/0xdb
Aug 17 21:27:07 ubuntu kernel: [26639.195936]  [<c1035b74>]
try_to_freeze+0x19/0x20
Aug 17 21:27:07 ubuntu kernel: [26639.195945]  [<c10371f0>]
get_signal_to_deliver+0x36/0x32e
Aug 17 21:27:07 ubuntu kernel: [26639.195954]  [<c107e7e3>] ?
might_fault+0x4b/0x88
Aug 17 21:27:07 ubuntu kernel: [26639.195964]  [<c1001fcd>]
do_notify_resume+0x77/0x735
Aug 17 21:27:07 ubuntu kernel: [26639.195974]  [<c107e7e3>] ?
might_fault+0x4b/0x88
Aug 17 21:27:07 ubuntu kernel: [26639.195984]  [<c107e7e3>] ?
might_fault+0x4b/0x88
Aug 17 21:27:07 ubuntu kernel: [26639.195994]  [<c131281a>] ?
sys_socketcall+0x169/0x185
Aug 17 21:27:07 ubuntu kernel: [26639.196004]  [<c10a0e1a>] ? sys_poll+0x42/0x8b
Aug 17 21:27:07 ubuntu kernel: [26639.196013]  [<c1002d96>]
work_notifysig+0x13/0x19
Aug 17 21:27:07 ubuntu kernel: [26639.196021] gvfsd-trash   D 00001835
 2112  3213      1 0x00000000
Aug 17 21:27:07 ubuntu kernel: [26639.196034]  e1394e8c 00000046
c16e4ca5 00001835 c1042993 e27940d4 c1689a00 00000046
Aug 17 21:27:07 ubuntu kernel: [26639.196055]  c1685eb8 c1689a00
e27940d4 c1689a00 c1042993 00000007 e2793e40 c13ee6c2
Aug 17 21:27:07 ubuntu kernel: [26639.196075]  c147dadd 00001835
e2793e40 eebf7e04 00000002 e1394e80 c104a803 00000000
Aug 17 21:27:07 ubuntu kernel: [26639.196096] Call Trace:
Aug 17 21:27:07 ubuntu kernel: [26639.196105]  [<c1042993>] ?
refrigerator+0x72/0xdb
Aug 17 21:27:07 ubuntu kernel: [26639.196115]  [<c1042993>] ?
refrigerator+0x72/0xdb
Aug 17 21:27:07 ubuntu kernel: [26639.196124]  [<c13ee6c2>] ?
_spin_unlock_irq+0x22/0x45
Aug 17 21:27:07 ubuntu kernel: [26639.196134]  [<c104a803>] ?
trace_hardirqs_on+0xb/0xd
Aug 17 21:27:07 ubuntu kernel: [26639.196144]  [<c10429e5>]
refrigerator+0xc4/0xdb
Aug 17 21:27:07 ubuntu kernel: [26639.196153]  [<c1035b74>]
try_to_freeze+0x19/0x20
Aug 17 21:27:07 ubuntu kernel: [26639.196162]  [<c10371f0>]
get_signal_to_deliver+0x36/0x32e
Aug 17 21:27:07 ubuntu kernel: [26639.196172]  [<c1001fcd>]
do_notify_resume+0x77/0x735
Aug 17 21:27:07 ubuntu kernel: [26639.196182]  [<c104bac2>] ?
__lock_acquire+0xad3/0xae2
Aug 17 21:27:07 ubuntu kernel: [26639.196191]  [<c13ee693>] ?
_spin_unlock_irqrestore+0x4e/0x5b
Aug 17 21:27:07 ubuntu kernel: [26639.196201]  [<c107e7e3>] ?
might_fault+0x4b/0x88
Aug 17 21:27:07 ubuntu kernel: [26639.196211]  [<c107e7e3>] ?
might_fault+0x4b/0x88
Aug 17 21:27:07 ubuntu kernel: [26639.196220]  [<c107e81e>] ?
might_fault+0x86/0x88
Aug 17 21:27:07 ubuntu kernel: [26639.196230]  [<c10a0e1a>] ? sys_poll+0x42/0x8b
Aug 17 21:27:07 ubuntu kernel: [26639.196239]  [<c1002d96>]
work_notifysig+0x13/0x19
Aug 17 21:27:07 ubuntu kernel: [26639.196247] gvfs-gphoto2- D 00001835
 2172  3217      1 0x00000000
Aug 17 21:27:07 ubuntu kernel: [26639.196260]  e3193e8c 00000046
c1594e7f 00001835 c1042993 e41b0cf4 c1689a00 00000046
Aug 17 21:27:07 ubuntu kernel: [26639.196281]  c1685eb8 c1689a00
e41b0cf4 c1689a00 c1042993 00000007 e41b0a60 c13ee6c2
Aug 17 21:27:07 ubuntu kernel: [26639.196301]  c1471054 00001835
e41b0a60 f600d204 00000002 e3193e80 c104a803 00000000
Aug 17 21:27:07 ubuntu kernel: [26639.196322] Call Trace:
Aug 17 21:27:07 ubuntu kernel: [26639.196331]  [<c1042993>] ?
refrigerator+0x72/0xdb
Aug 17 21:27:07 ubuntu kernel: [26639.196341]  [<c1042993>] ?
refrigerator+0x72/0xdb
Aug 17 21:27:07 ubuntu kernel: [26639.196350]  [<c13ee6c2>] ?
_spin_unlock_irq+0x22/0x45
Aug 17 21:27:07 ubuntu kernel: [26639.196360]  [<c104a803>] ?
trace_hardirqs_on+0xb/0xd
Aug 17 21:27:07 ubuntu kernel: [26639.196370]  [<c10429e5>]
refrigerator+0xc4/0xdb
Aug 17 21:27:07 ubuntu kernel: [26639.196379]  [<c1035b74>]
try_to_freeze+0x19/0x20
Aug 17 21:27:07 ubuntu kernel: [26639.196388]  [<c10371f0>]
get_signal_to_deliver+0x36/0x32e
Aug 17 21:27:07 ubuntu kernel: [26639.196398]  [<c1001fcd>]
do_notify_resume+0x77/0x735
Aug 17 21:27:07 ubuntu kernel: [26639.196408]  [<c1094592>] ?
fsnotify_modify+0x4f/0x5a
Aug 17 21:27:07 ubuntu kernel: [26639.196418]  [<c10952f9>] ?
do_readv_writev+0xd2/0xdf
Aug 17 21:27:07 ubuntu kernel: [26639.196428]  [<c1094592>] ?
fsnotify_modify+0x4f/0x5a
Aug 17 21:27:07 ubuntu kernel: [26639.196439]  [<c10a0e1a>] ? sys_poll+0x42/0x8b
Aug 17 21:27:07 ubuntu kernel: [26639.196448]  [<c1002d96>]
work_notifysig+0x13/0x19
Aug 17 21:27:07 ubuntu kernel: [26639.196456] bonobo-activa D 00001835
 2172  3221      1 0x00000000
Aug 17 21:27:07 ubuntu kernel: [26639.196469]  e0aa8e8c 00000046
c159b168 00001835 c1042993 e41b6a54 c1689a00 00000046
Aug 17 21:27:07 ubuntu kernel: [26639.196490]  c1685eb8 c1689a00
e41b6a54 c1689a00 c1042993 00000007 e41b67c0 c13ee6c2
Aug 17 21:27:07 ubuntu kernel: [26639.196511]  c1515f27 00001835
e41b67c0 f600d784 00000002 e0aa8e80 c104a803 00000000
Aug 17 21:27:07 ubuntu kernel: [26639.196531] Call Trace:
Aug 17 21:27:07 ubuntu kernel: [26639.196540]  [<c1042993>] ?
refrigerator+0x72/0xdb
Aug 17 21:27:07 ubuntu kernel: [26639.196550]  [<c1042993>] ?
refrigerator+0x72/0xdb
Aug 17 21:27:07 ubuntu kernel: [26639.196560]  [<c13ee6c2>] ?
_spin_unlock_irq+0x22/0x45
Aug 17 21:27:07 ubuntu kernel: [26639.196570]  [<c104a803>] ?
trace_hardirqs_on+0xb/0xd
Aug 17 21:27:07 ubuntu kernel: [26639.196579]  [<c10429e5>]
refrigerator+0xc4/0xdb
Aug 17 21:27:07 ubuntu kernel: [26639.196589]  [<c1035b74>]
try_to_freeze+0x19/0x20
Aug 17 21:27:07 ubuntu kernel: [26639.196598]  [<c10371f0>]
get_signal_to_deliver+0x36/0x32e
Aug 17 21:27:07 ubuntu kernel: [26639.196608]  [<c1001fcd>]
do_notify_resume+0x77/0x735
Aug 17 21:27:07 ubuntu kernel: [26639.196617]  [<c1157a57>] ?
file_has_perm+0x87/0xa1
Aug 17 21:27:07 ubuntu kernel: [26639.196629]  [<c1094592>] ?
fsnotify_modify+0x4f/0x5a
Aug 17 21:27:07 ubuntu kernel: [26639.196640]  [<c11e1efa>] ? write_null+0x0/0x7
Aug 17 21:27:07 ubuntu kernel: [26639.196648]  [<c1094cf0>] ?
vfs_write+0xa0/0xdf
Aug 17 21:27:07 ubuntu kernel: [26639.196657]  [<c10a0e1a>] ? sys_poll+0x42/0x8b
Aug 17 21:27:07 ubuntu kernel: [26639.196667]  [<c1002d96>]
work_notifysig+0x13/0x19
Aug 17 21:27:07 ubuntu kernel: [26639.196674] bonobo-activa D 00001835
 2152  3222      1 0x00000000
Aug 17 21:27:07 ubuntu kernel: [26639.196688]  e0aafe8c 00000046
c1485fd1 00001835 c1042993 e41b1754 c1689a00 00000046
Aug 17 21:27:07 ubuntu kernel: [26639.196708]  c1685eb8 c1689a00
e41b1754 c1689a00 c1042993 00000007 e41b14c0 c13ee6c2
Aug 17 21:27:07 ubuntu kernel: [26639.196729]  c147ff40 00001835
e41b14c0 f600d784 00000002 e0aafe80 c104a803 00000000
Aug 17 21:27:07 ubuntu kernel: [26639.196749] Call Trace:
Aug 17 21:27:07 ubuntu kernel: [26639.196759]  [<c1042993>] ?
refrigerator+0x72/0xdb
Aug 17 21:27:07 ubuntu kernel: [26639.196769]  [<c1042993>] ?
refrigerator+0x72/0xdb
Aug 17 21:27:07 ubuntu kernel: [26639.196778]  [<c13ee6c2>] ?
_spin_unlock_irq+0x22/0x45
Aug 17 21:27:07 ubuntu kernel: [26639.196788]  [<c104a803>] ?
trace_hardirqs_on+0xb/0xd
Aug 17 21:27:07 ubuntu kernel: [26639.196798]  [<c10429e5>]
refrigerator+0xc4/0xdb
Aug 17 21:27:07 ubuntu kernel: [26639.196807]  [<c1035b74>]
try_to_freeze+0x19/0x20
Aug 17 21:27:07 ubuntu kernel: [26639.196816]  [<c10371f0>]
get_signal_to_deliver+0x36/0x32e
Aug 17 21:27:07 ubuntu kernel: [26639.196826]  [<c1001fcd>]
do_notify_resume+0x77/0x735
Aug 17 21:27:07 ubuntu kernel: [26639.196836]  [<c10a145e>] ? __d_free+0x38/0x3b
Aug 17 21:27:07 ubuntu kernel: [26639.196846]  [<c10a145e>] ? __d_free+0x38/0x3b
Aug 17 21:27:07 ubuntu kernel: [26639.196855]  [<c10a1486>] ? d_free+0x25/0x37
Aug 17 21:27:07 ubuntu kernel: [26639.196864]  [<c10a67e3>] ?
mntput_no_expire+0x19/0x8d
Aug 17 21:27:07 ubuntu kernel: [26639.196874]  [<c1095ac1>] ? __fput+0x171/0x179
Aug 17 21:27:07 ubuntu kernel: [26639.196884]  [<c10a0e1a>] ? sys_poll+0x42/0x8b
Aug 17 21:27:07 ubuntu kernel: [26639.196894]  [<c1002d96>]
work_notifysig+0x13/0x19
Aug 17 21:27:07 ubuntu kernel: [26639.196901] cpufreq-apple D 00001835
 2080  3227      1 0x00000000
Aug 17 21:27:07 ubuntu kernel: [26639.196914]  e03bbe8c 00000046
c15e5c6e 00001835 c1042993 e2795594 c1689a00 00000046
Aug 17 21:27:07 ubuntu kernel: [26639.196935]  c1685eb8 c1689a00
e2795594 c1689a00 c1042993 00000007 e2795300 c13ee6c2
Aug 17 21:27:07 ubuntu kernel: [26639.196956]  c1434c6f 00001835
e2795300 eebf7884 00000002 e03bbe80 c104a803 00000000
Aug 17 21:27:07 ubuntu kernel: [26639.196976] Call Trace:
Aug 17 21:27:07 ubuntu kernel: [26639.196986]  [<c1042993>] ?
refrigerator+0x72/0xdb
Aug 17 21:27:07 ubuntu kernel: [26639.196995]  [<c1042993>] ?
refrigerator+0x72/0xdb
Aug 17 21:27:07 ubuntu kernel: [26639.197005]  [<c13ee6c2>] ?
_spin_unlock_irq+0x22/0x45
Aug 17 21:27:07 ubuntu kernel: [26639.197015]  [<c104a803>] ?
trace_hardirqs_on+0xb/0xd
Aug 17 21:27:07 ubuntu kernel: [26639.197025]  [<c10429e5>]
refrigerator+0xc4/0xdb
Aug 17 21:27:07 ubuntu kernel: [26639.197034]  [<c1035b74>]
try_to_freeze+0x19/0x20
Aug 17 21:27:07 ubuntu kernel: [26639.197043]  [<c10371f0>]
get_signal_to_deliver+0x36/0x32e
Aug 17 21:27:07 ubuntu kernel: [26639.197053]  [<c1001fcd>]
do_notify_resume+0x77/0x735
Aug 17 21:27:07 ubuntu kernel: [26639.197063]  [<c104bac2>] ?
__lock_acquire+0xad3/0xae2
Aug 17 21:27:07 ubuntu kernel: [26639.197073]  [<c107e7e3>] ?
might_fault+0x4b/0x88
Aug 17 21:27:07 ubuntu kernel: [26639.197083]  [<c1043079>] ?
clocksource_read+0x9/0xc
Aug 17 21:27:07 ubuntu kernel: [26639.197092]  [<c1043382>] ?
getnstimeofday+0x4d/0xd7
Aug 17 21:27:07 ubuntu kernel: [26639.197103]  [<c10a0e1a>] ? sys_poll+0x42/0x8b
Aug 17 21:27:07 ubuntu kernel: [26639.197113]  [<c1002d96>]
work_notifysig+0x13/0x19
Aug 17 21:27:07 ubuntu kernel: [26639.197120] gdm-user-swit D 00001835
 2080  3229      1 0x00000000
Aug 17 21:27:07 ubuntu kernel: [26639.197133]  dfc6fe8c 00000046
c175aad6 00001835 c1042993 e2796a54 c1689a00 00000046
Aug 17 21:27:07 ubuntu kernel: [26639.197154]  c1685eb8 c1689a00
e2796a54 c1689a00 c1042993 00000007 e27967c0 c13ee6c2
Aug 17 21:27:07 ubuntu kernel: [26639.197175]  c172423a 00001835
e27967c0 eebf6d84 00000002 dfc6fe80 c104a803 00000000
Aug 17 21:27:07 ubuntu kernel: [26639.197195] Call Trace:
Aug 17 21:27:07 ubuntu kernel: [26639.197204]  [<c1042993>] ?
refrigerator+0x72/0xdb
Aug 17 21:27:07 ubuntu kernel: [26639.197214]  [<c1042993>] ?
refrigerator+0x72/0xdb
Aug 17 21:27:07 ubuntu kernel: [26639.197224]  [<c13ee6c2>] ?
_spin_unlock_irq+0x22/0x45
Aug 17 21:27:07 ubuntu kernel: [26639.197234]  [<c104a803>] ?
trace_hardirqs_on+0xb/0xd
Aug 17 21:27:07 ubuntu kernel: [26639.197243]  [<c10429e5>]
refrigerator+0xc4/0xdb
Aug 17 21:27:07 ubuntu kernel: [26639.197253]  [<c1035b74>]
try_to_freeze+0x19/0x20
Aug 17 21:27:07 ubuntu kernel: [26639.197261]  [<c10371f0>]
get_signal_to_deliver+0x36/0x32e
Aug 17 21:27:07 ubuntu kernel: [26639.197272]  [<c1001fcd>]
do_notify_resume+0x77/0x735
Aug 17 21:27:07 ubuntu kernel: [26639.197281]  [<c104bac2>] ?
__lock_acquire+0xad3/0xae2
Aug 17 21:27:07 ubuntu kernel: [26639.197292]  [<c107e7e3>] ?
might_fault+0x4b/0x88
Aug 17 21:27:07 ubuntu kernel: [26639.197301]  [<c1043079>] ?
clocksource_read+0x9/0xc
Aug 17 21:27:07 ubuntu kernel: [26639.197311]  [<c1043382>] ?
getnstimeofday+0x4d/0xd7
Aug 17 21:27:07 ubuntu kernel: [26639.197322]  [<c10a0e1a>] ? sys_poll+0x42/0x8b
Aug 17 21:27:07 ubuntu kernel: [26639.197331]  [<c1002d96>]
work_notifysig+0x13/0x19
Aug 17 21:27:07 ubuntu kernel: [26639.197374] trashapplet   D 00001835
 2080  3232      1 0x00000000
Aug 17 21:27:08 ubuntu kernel: [26639.197389]  dfcebe8c 00000046
c15da835 00001835 c1042993 e41b74b4 c1689a00 00000046
Aug 17 21:27:08 ubuntu kernel: [26639.197409]  c1685eb8 c1689a00
e41b74b4 c1689a00 c1042993 00000007 e41b7220 c13ee6c2
Aug 17 21:27:08 ubuntu kernel: [26639.197430]  c14766d4 00001835
e41b7220 f7097884 00000002 dfcebe80 c104a803 00000000
Aug 17 21:27:08 ubuntu kernel: [26639.197450] Call Trace:
Aug 17 21:27:08 ubuntu kernel: [26639.197460]  [<c1042993>] ?
refrigerator+0x72/0xdb
Aug 17 21:27:08 ubuntu kernel: [26639.197470]  [<c1042993>] ?
refrigerator+0x72/0xdb
Aug 17 21:27:08 ubuntu kernel: [26639.197480]  [<c13ee6c2>] ?
_spin_unlock_irq+0x22/0x45
Aug 17 21:27:08 ubuntu kernel: [26639.197490]  [<c104a803>] ?
trace_hardirqs_on+0xb/0xd
Aug 17 21:27:08 ubuntu kernel: [26639.197500]  [<c10429e5>]
refrigerator+0xc4/0xdb
Aug 17 21:27:08 ubuntu kernel: [26639.197509]  [<c1035b74>]
try_to_freeze+0x19/0x20
Aug 17 21:27:08 ubuntu kernel: [26639.197518]  [<c10371f0>]
get_signal_to_deliver+0x36/0x32e
Aug 17 21:27:08 ubuntu kernel: [26639.197528]  [<c1001fcd>]
do_notify_resume+0x77/0x735
Aug 17 21:27:08 ubuntu kernel: [26639.197540]  [<c103ccb5>] ?
autoremove_wake_function+0x0/0x2f
Aug 17 21:27:08 ubuntu kernel: [26639.197551]  [<c1157ce4>] ?
selinux_file_permission+0x44/0x48
Aug 17 21:27:08 ubuntu kernel: [26639.197560]  [<c1154346>] ?
security_file_permission+0xf/0x11
Aug 17 21:27:08 ubuntu kernel: [26639.197569]  [<c109490a>] ?
rw_verify_area+0x98/0xbb
Aug 17 21:27:08 ubuntu kernel: [26639.197579]  [<c1094e70>] ? vfs_read+0x8b/0xdc
Aug 17 21:27:08 ubuntu kernel: [26639.197588]  [<c10a0e1a>] ? sys_poll+0x42/0x8b
Aug 17 21:27:08 ubuntu kernel: [26639.197598]  [<c1002d96>]
work_notifysig+0x13/0x19
Aug 17 21:27:08 ubuntu kernel: [26639.197606] trashapplet   D 00001835
 2220  6744      1 0x00000000
Aug 17 21:27:08 ubuntu kernel: [26639.197619]  dbf83e8c 00200046
c16eab1e 00001835 c1042993 ec4f0cf4 c1689a00 00200046
Aug 17 21:27:08 ubuntu kernel: [26639.197640]  c1685eb8 c1689a00
ec4f0cf4 c1689a00 c1042993 00000007 ec4f0a60 c13ee6c2
Aug 17 21:27:08 ubuntu kernel: [26639.197661]  c148214a 00001835
ec4f0a60 f7097884 00000002 dbf83e80 c104a803 00000000
Aug 17 21:27:08 ubuntu kernel: [26639.197681] Call Trace:
Aug 17 21:27:08 ubuntu kernel: [26639.197691]  [<c1042993>] ?
refrigerator+0x72/0xdb
Aug 17 21:27:08 ubuntu kernel: [26639.197701]  [<c1042993>] ?
refrigerator+0x72/0xdb
Aug 17 21:27:08 ubuntu kernel: [26639.197710]  [<c13ee6c2>] ?
_spin_unlock_irq+0x22/0x45
Aug 17 21:27:08 ubuntu kernel: [26639.197720]  [<c104a803>] ?
trace_hardirqs_on+0xb/0xd
Aug 17 21:27:08 ubuntu kernel: [26639.197730]  [<c10429e5>]
refrigerator+0xc4/0xdb
Aug 17 21:27:08 ubuntu kernel: [26639.197740]  [<c1035b74>]
try_to_freeze+0x19/0x20
Aug 17 21:27:08 ubuntu kernel: [26639.197748]  [<c10371f0>]
get_signal_to_deliver+0x36/0x32e
Aug 17 21:27:08 ubuntu kernel: [26639.197757]  [<c107e7e3>] ?
might_fault+0x4b/0x88
Aug 17 21:27:08 ubuntu kernel: [26639.197767]  [<c1001fcd>]
do_notify_resume+0x77/0x735
Aug 17 21:27:08 ubuntu kernel: [26639.197777]  [<c107e7e3>] ?
might_fault+0x4b/0x88
Aug 17 21:27:08 ubuntu kernel: [26639.197787]  [<c107e7e3>] ?
might_fault+0x4b/0x88
Aug 17 21:27:08 ubuntu kernel: [26639.197797]  [<c131281a>] ?
sys_socketcall+0x169/0x185
Aug 17 21:27:08 ubuntu kernel: [26639.197807]  [<c10a0e1a>] ? sys_poll+0x42/0x8b
Aug 17 21:27:08 ubuntu kernel: [26639.197816]  [<c1002d96>]
work_notifysig+0x13/0x19
Aug 17 21:27:08 ubuntu kernel: [26639.197824] gvfs-gdu-volu D 00001835
 2080  3239      1 0x00000000
Aug 17 21:27:08 ubuntu kernel: [26639.197837]  dfce6e8c 00000046
c148d789 00001835 c1042993 e41b0294 c1689a00 00000046
Aug 17 21:27:08 ubuntu kernel: [26639.197858]  c1685eb8 c1689a00
e41b0294 c1689a00 c1042993 00000007 e41b0000 c13ee6c2
Aug 17 21:27:08 ubuntu kernel: [26639.197879]  c148b493 00001835
e41b0000 f7097e04 00000002 dfce6e80 c104a803 00000000
Aug 17 21:27:08 ubuntu kernel: [26639.197899] Call Trace:
Aug 17 21:27:08 ubuntu kernel: [26639.197908]  [<c1042993>] ?
refrigerator+0x72/0xdb
Aug 17 21:27:08 ubuntu kernel: [26639.197918]  [<c1042993>] ?
refrigerator+0x72/0xdb
Aug 17 21:27:08 ubuntu kernel: [26639.197928]  [<c13ee6c2>] ?
_spin_unlock_irq+0x22/0x45
Aug 17 21:27:08 ubuntu kernel: [26639.197938]  [<c104a803>] ?
trace_hardirqs_on+0xb/0xd
Aug 17 21:27:08 ubuntu kernel: [26639.197947]  [<c10429e5>]
refrigerator+0xc4/0xdb
Aug 17 21:27:08 ubuntu kernel: [26639.197957]  [<c1035b74>]
try_to_freeze+0x19/0x20
Aug 17 21:27:08 ubuntu kernel: [26639.197966]  [<c10371f0>]
get_signal_to_deliver+0x36/0x32e
Aug 17 21:27:08 ubuntu kernel: [26639.197974]  [<c107e7e3>] ?
might_fault+0x4b/0x88
Aug 17 21:27:08 ubuntu kernel: [26639.197984]  [<c1001fcd>]
do_notify_resume+0x77/0x735
Aug 17 21:27:08 ubuntu kernel: [26639.197994]  [<c104bac2>] ?
__lock_acquire+0xad3/0xae2
Aug 17 21:27:08 ubuntu kernel: [26639.198004]  [<c107e7e3>] ?
might_fault+0x4b/0x88
Aug 17 21:27:08 ubuntu kernel: [26639.198014]  [<c107e7e3>] ?
might_fault+0x4b/0x88
Aug 17 21:27:08 ubuntu kernel: [26639.198023]  [<c107e81e>] ?
might_fault+0x86/0x88
Aug 17 21:27:08 ubuntu kernel: [26639.198033]  [<c10a0e1a>] ? sys_poll+0x42/0x8b
Aug 17 21:27:08 ubuntu kernel: [26639.198042]  [<c1002d96>]
work_notifysig+0x13/0x19
Aug 17 21:27:08 ubuntu kernel: [26639.198050] gvfsd-burn    D 00001835
 2172  3243      1 0x00000000
Aug 17 21:27:08 ubuntu kernel: [26639.198064]  df26de8c 00000046
c16f0030 00001835 c1042993 e4594b34 c1689a00 00000046
Aug 17 21:27:08 ubuntu kernel: [26639.198084]  c1685eb8 c1689a00
e4594b34 c1689a00 c1042993 00000007 e45948a0 c13ee6c2
Aug 17 21:27:08 ubuntu kernel: [26639.198105]  c1486a17 00001835
e45948a0 ee402b84 00000002 df26de80 c104a803 00000000
Aug 17 21:27:08 ubuntu kernel: [26639.198125] Call Trace:
Aug 17 21:27:08 ubuntu kernel: [26639.198135]  [<c1042993>] ?
refrigerator+0x72/0xdb
Aug 17 21:27:08 ubuntu kernel: [26639.198145]  [<c1042993>] ?
refrigerator+0x72/0xdb
Aug 17 21:27:08 ubuntu kernel: [26639.198154]  [<c13ee6c2>] ?
_spin_unlock_irq+0x22/0x45
Aug 17 21:27:08 ubuntu kernel: [26639.198164]  [<c104a803>] ?
trace_hardirqs_on+0xb/0xd
Aug 17 21:27:08 ubuntu kernel: [26639.198185]  [<c10429e5>]
refrigerator+0xc4/0xdb
Aug 17 21:27:08 ubuntu kernel: [26639.198200]  [<c1035b74>]
try_to_freeze+0x19/0x20
Aug 17 21:27:08 ubuntu kernel: [26639.198213]  [<c10371f0>]
get_signal_to_deliver+0x36/0x32e
Aug 17 21:27:08 ubuntu kernel: [26639.198228]  [<c1001fcd>]
do_notify_resume+0x77/0x735
Aug 17 21:27:08 ubuntu kernel: [26639.198244]  [<c106f98b>] ?
unlock_page+0x47/0x4a
Aug 17 21:27:08 ubuntu kernel: [26639.198253]  [<c10812b6>] ?
__do_fault+0x2fb/0x327
Aug 17 21:27:08 ubuntu kernel: [26639.198266]  [<c10a0e1a>] ? sys_poll+0x42/0x8b
Aug 17 21:27:08 ubuntu kernel: [26639.198276]  [<c1002d96>]
work_notifysig+0x13/0x19
Aug 17 21:27:08 ubuntu kernel: [26639.198284] gnome-termina D 00001835
 1968  3274      1 0x00000000
Aug 17 21:27:08 ubuntu kernel: [26639.198297]  df3d8e8c 00200046
c186c8e9 00001835 c1042993 df3e0cf4 c1689a00 00200046
Aug 17 21:27:08 ubuntu kernel: [26639.198318]  c1685eb8 c1689a00
df3e0cf4 c1689a00 c1042993 00787ac3 c2c99eb8 ffffffff
Aug 17 21:27:08 ubuntu kernel: [26639.198339]  c1853865 00001835
df3e0a60 f7097304 00000000 00000000 00000000 00000000
Aug 17 21:27:08 ubuntu kernel: [26639.198359] Call Trace:
Aug 17 21:27:08 ubuntu kernel: [26639.198368]  [<c1042993>] ?
refrigerator+0x72/0xdb
Aug 17 21:27:08 ubuntu kernel: [26639.198378]  [<c1042993>] ?
refrigerator+0x72/0xdb
Aug 17 21:27:08 ubuntu kernel: [26639.198389]  [<c10429e5>]
refrigerator+0xc4/0xdb
Aug 17 21:27:08 ubuntu kernel: [26639.198398]  [<c1035b74>]
try_to_freeze+0x19/0x20
Aug 17 21:27:08 ubuntu kernel: [26639.198407]  [<c10371f0>]
get_signal_to_deliver+0x36/0x32e
Aug 17 21:27:08 ubuntu kernel: [26639.198417]  [<c1001fcd>]
do_notify_resume+0x77/0x735
Aug 17 21:27:08 ubuntu kernel: [26639.198427]  [<c104bac2>] ?
__lock_acquire+0xad3/0xae2
Aug 17 21:27:08 ubuntu kernel: [26639.198437]  [<c107e7e3>] ?
might_fault+0x4b/0x88
Aug 17 21:27:08 ubuntu kernel: [26639.198447]  [<c1043079>] ?
clocksource_read+0x9/0xc
Aug 17 21:27:08 ubuntu kernel: [26639.198457]  [<c1043382>] ?
getnstimeofday+0x4d/0xd7
Aug 17 21:27:08 ubuntu kernel: [26639.198468]  [<c10a0e1a>] ? sys_poll+0x42/0x8b
Aug 17 21:27:08 ubuntu kernel: [26639.198477]  [<c1002d96>]
work_notifysig+0x13/0x19
Aug 17 21:27:08 ubuntu kernel: [26639.198485] gnome-termina D 00001835
 2824  3333      1 0x00000000
Aug 17 21:27:08 ubuntu kernel: [26639.198499]  ddd45e8c 00000046
c16f4ec7 00001835 c1042993 df3f4b34 c1689a00 00000046
Aug 17 21:27:08 ubuntu kernel: [26639.198520]  c1685eb8 c1689a00
df3f4b34 c1689a00 c1042993 00000007 df3f48a0 c13ee6c2
Aug 17 21:27:08 ubuntu kernel: [26639.198540]  c14890d2 00001835
df3f48a0 f7097304 00000002 ddd45e80 c104a803 00000000
Aug 17 21:27:08 ubuntu kernel: [26639.198561] Call Trace:
Aug 17 21:27:08 ubuntu kernel: [26639.198570]  [<c1042993>] ?
refrigerator+0x72/0xdb
Aug 17 21:27:08 ubuntu kernel: [26639.198580]  [<c1042993>] ?
refrigerator+0x72/0xdb
Aug 17 21:27:08 ubuntu kernel: [26639.198589]  [<c13ee6c2>] ?
_spin_unlock_irq+0x22/0x45
Aug 17 21:27:08 ubuntu kernel: [26639.198599]  [<c104a803>] ?
trace_hardirqs_on+0xb/0xd
Aug 17 21:27:08 ubuntu kernel: [26639.198609]  [<c10429e5>]
refrigerator+0xc4/0xdb
Aug 17 21:27:08 ubuntu kernel: [26639.198618]  [<c1035b74>]
try_to_freeze+0x19/0x20
Aug 17 21:27:08 ubuntu kernel: [26639.198627]  [<c10371f0>]
get_signal_to_deliver+0x36/0x32e
Aug 17 21:27:08 ubuntu kernel: [26639.198637]  [<c1001fcd>]
do_notify_resume+0x77/0x735
Aug 17 21:27:08 ubuntu kernel: [26639.198646]  [<c1157a57>] ?
file_has_perm+0x87/0xa1
Aug 17 21:27:08 ubuntu kernel: [26639.198658]  [<c103ccb5>] ?
autoremove_wake_function+0x0/0x2f
Aug 17 21:27:08 ubuntu kernel: [26639.198668]  [<c1157ce4>] ?
selinux_file_permission+0x44/0x48
Aug 17 21:27:08 ubuntu kernel: [26639.198678]  [<c1154346>] ?
security_file_permission+0xf/0x11
Aug 17 21:27:08 ubuntu kernel: [26639.198687]  [<c109490a>] ?
rw_verify_area+0x98/0xbb
Aug 17 21:27:08 ubuntu kernel: [26639.198696]  [<c109478e>] ?
do_sync_read+0x0/0xe4
Aug 17 21:27:08 ubuntu kernel: [26639.198704]  [<c1094e62>] ? vfs_read+0x7d/0xdc
Aug 17 21:27:08 ubuntu kernel: [26639.198713]  [<c1094463>] ? fput_light+0xc/0xe
Aug 17 21:27:08 ubuntu kernel: [26639.198722]  [<c1094f6d>] ? sys_read+0x53/0x5d
Aug 17 21:27:08 ubuntu kernel: [26639.198731]  [<c1002d96>]
work_notifysig+0x13/0x19
Aug 17 21:27:08 ubuntu kernel: [26639.198739] gnome-termina D 00001835
 2220  3396      1 0x00000000
Aug 17 21:27:08 ubuntu kernel: [26639.198752]  d8388e8c 00200046
c16f9b24 00001835 c1042993 df3e3674 c1689a00 00200046
Aug 17 21:27:08 ubuntu kernel: [26639.198773]  c1685eb8 c1689a00
df3e3674 c1689a00 c1042993 00000007 df3e33e0 c13ee6c2
Aug 17 21:27:08 ubuntu kernel: [26639.198794]  c148dc63 00001835
df3e33e0 f7097304 00000002 d8388e80 c104a803 00000000
Aug 17 21:27:08 ubuntu kernel: [26639.198814] Call Trace:
Aug 17 21:27:08 ubuntu kernel: [26639.198824]  [<c1042993>] ?
refrigerator+0x72/0xdb
Aug 17 21:27:08 ubuntu kernel: [26639.198834]  [<c1042993>] ?
refrigerator+0x72/0xdb
Aug 17 21:27:08 ubuntu kernel: [26639.198843]  [<c13ee6c2>] ?
_spin_unlock_irq+0x22/0x45
Aug 17 21:27:08 ubuntu kernel: [26639.198853]  [<c104a803>] ?
trace_hardirqs_on+0xb/0xd
Aug 17 21:27:08 ubuntu kernel: [26639.198863]  [<c10429e5>]
refrigerator+0xc4/0xdb
Aug 17 21:27:08 ubuntu kernel: [26639.198872]  [<c1035b74>]
try_to_freeze+0x19/0x20
Aug 17 21:27:08 ubuntu kernel: [26639.198881]  [<c10371f0>]
get_signal_to_deliver+0x36/0x32e
Aug 17 21:27:08 ubuntu kernel: [26639.198890]  [<c107e7e3>] ?
might_fault+0x4b/0x88
Aug 17 21:27:08 ubuntu kernel: [26639.198899]  [<c1001fcd>]
do_notify_resume+0x77/0x735
Aug 17 21:27:08 ubuntu kernel: [26639.198910]  [<c107e7e3>] ?
might_fault+0x4b/0x88
Aug 17 21:27:08 ubuntu kernel: [26639.198919]  [<c107e7e3>] ?
might_fault+0x4b/0x88
Aug 17 21:27:08 ubuntu kernel: [26639.198930]  [<c131281a>] ?
sys_socketcall+0x169/0x185
Aug 17 21:27:08 ubuntu kernel: [26639.198939]  [<c10a0e1a>] ? sys_poll+0x42/0x8b
Aug 17 21:27:08 ubuntu kernel: [26639.198949]  [<c1002d96>]
work_notifysig+0x13/0x19
Aug 17 21:27:08 ubuntu kernel: [26639.198956] gvfsd-metadat D 00001835
 2172  3299      1 0x00000000
Aug 17 21:27:08 ubuntu kernel: [26639.198970]  dea26e8c 00000046
c1491e44 00001835 c1042993 df3f1754 c1689a00 00000046
Aug 17 21:27:08 ubuntu kernel: [26639.198990]  c1685eb8 c1689a00
df3f1754 c1689a00 c1042993 00000007 df3f14c0 c13ee6c2
Aug 17 21:27:08 ubuntu kernel: [26639.199011]  c1490355 00001835
df3f14c0 df3e8a84 00000002 dea26e80 c104a803 00000000
Aug 17 21:27:08 ubuntu kernel: [26639.199032] Call Trace:
Aug 17 21:27:08 ubuntu kernel: [26639.199041]  [<c1042993>] ?
refrigerator+0x72/0xdb
Aug 17 21:27:08 ubuntu kernel: [26639.199051]  [<c1042993>] ?
refrigerator+0x72/0xdb
Aug 17 21:27:08 ubuntu kernel: [26639.199060]  [<c13ee6c2>] ?
_spin_unlock_irq+0x22/0x45
Aug 17 21:27:08 ubuntu kernel: [26639.199070]  [<c104a803>] ?
trace_hardirqs_on+0xb/0xd
Aug 17 21:27:08 ubuntu kernel: [26639.199080]  [<c10429e5>]
refrigerator+0xc4/0xdb
Aug 17 21:27:08 ubuntu kernel: [26639.199089]  [<c1035b74>]
try_to_freeze+0x19/0x20
Aug 17 21:27:08 ubuntu kernel: [26639.199098]  [<c10371f0>]
get_signal_to_deliver+0x36/0x32e
Aug 17 21:27:08 ubuntu kernel: [26639.199108]  [<c1001fcd>]
do_notify_resume+0x77/0x735
Aug 17 21:27:08 ubuntu kernel: [26639.199118]  [<c106f98b>] ?
unlock_page+0x47/0x4a
Aug 17 21:27:08 ubuntu kernel: [26639.199127]  [<c10812b6>] ?
__do_fault+0x2fb/0x327
Aug 17 21:27:08 ubuntu kernel: [26639.199140]  [<c10a0e1a>] ? sys_poll+0x42/0x8b
Aug 17 21:27:08 ubuntu kernel: [26639.199149]  [<c1002d96>]
work_notifysig+0x13/0x19
Aug 17 21:27:08 ubuntu kernel: [26639.199157] gnome-pty-hel D 00001835
 2576  3331   3274 0x00000000
Aug 17 21:27:08 ubuntu kernel: [26639.199171]  ee349e8c 00000046
c16fe79f 00001835 c1042993 df3f5594 c1689a00 00000046
Aug 17 21:27:08 ubuntu kernel: [26639.199191]  c1685eb8 c1689a00
df3f5594 c1689a00 c1042993 00000007 df3f5300 c13ee6c2
Aug 17 21:27:08 ubuntu kernel: [26639.199212]  c1495a3b 00001835
df3f5300 df3e9b04 00000002 ee349e80 c104a803 00000000
Aug 17 21:27:08 ubuntu kernel: [26639.199233] Call Trace:
Aug 17 21:27:08 ubuntu kernel: [26639.199242]  [<c1042993>] ?
refrigerator+0x72/0xdb
Aug 17 21:27:08 ubuntu kernel: [26639.199252]  [<c1042993>] ?
refrigerator+0x72/0xdb
Aug 17 21:27:08 ubuntu kernel: [26639.199261]  [<c13ee6c2>] ?
_spin_unlock_irq+0x22/0x45
Aug 17 21:27:08 ubuntu kernel: [26639.199271]  [<c104a803>] ?
trace_hardirqs_on+0xb/0xd
Aug 17 21:27:08 ubuntu kernel: [26639.199281]  [<c10429e5>]
refrigerator+0xc4/0xdb
Aug 17 21:27:08 ubuntu kernel: [26639.199290]  [<c1035b74>]
try_to_freeze+0x19/0x20
Aug 17 21:27:08 ubuntu kernel: [26639.199299]  [<c10371f0>]
get_signal_to_deliver+0x36/0x32e
Aug 17 21:27:08 ubuntu kernel: [26639.199309]  [<c1001fcd>]
do_notify_resume+0x77/0x735
Aug 17 21:27:08 ubuntu kernel: [26639.199318]  [<c1157a57>] ?
file_has_perm+0x87/0xa1
Aug 17 21:27:08 ubuntu kernel: [26639.199329]  [<c103ccb5>] ?
autoremove_wake_function+0x0/0x2f
Aug 17 21:27:08 ubuntu kernel: [26639.199340]  [<c1157ce4>] ?
selinux_file_permission+0x44/0x48
Aug 17 21:27:08 ubuntu kernel: [26639.199349]  [<c1154346>] ?
security_file_permission+0xf/0x11
Aug 17 21:27:08 ubuntu kernel: [26639.199358]  [<c109490a>] ?
rw_verify_area+0x98/0xbb
Aug 17 21:27:08 ubuntu kernel: [26639.199368]  [<c1094e70>] ? vfs_read+0x8b/0xdc
Aug 17 21:27:08 ubuntu kernel: [26639.199377]  [<c1094f6d>] ? sys_read+0x53/0x5d
Aug 17 21:27:08 ubuntu kernel: [26639.199386]  [<c1002d96>]
work_notifysig+0x13/0x19
Aug 17 21:27:08 ubuntu kernel: [26639.199394] bash          D 00001835
 2332  3332   3274 0x00000000
Aug 17 21:27:08 ubuntu kernel: [26639.199407]  ddd50e8c 00000046
c1496ef8 00001835 c1042993 df3f0cf4 c1689a00 00000046
Aug 17 21:27:08 ubuntu kernel: [26639.199428]  c1685eb8 c1689a00
df3f0cf4 c1689a00 c1042993 00000007 df3f0a60 c13ee6c2
Aug 17 21:27:08 ubuntu kernel: [26639.199449]  c14932bf 00001835
df3f0a60 df3e9004 00000002 ddd50e80 c104a803 00000000
Aug 17 21:27:08 ubuntu kernel: [26639.199469] Call Trace:
Aug 17 21:27:08 ubuntu kernel: [26639.199479]  [<c1042993>] ?
refrigerator+0x72/0xdb
Aug 17 21:27:08 ubuntu kernel: [26639.199489]  [<c1042993>] ?
refrigerator+0x72/0xdb
Aug 17 21:27:08 ubuntu kernel: [26639.199498]  [<c13ee6c2>] ?
_spin_unlock_irq+0x22/0x45
Aug 17 21:27:08 ubuntu kernel: [26639.199508]  [<c104a803>] ?
trace_hardirqs_on+0xb/0xd
Aug 17 21:27:08 ubuntu kernel: [26639.199518]  [<c10429e5>]
refrigerator+0xc4/0xdb
Aug 17 21:27:08 ubuntu kernel: [26639.199527]  [<c1035b74>]
try_to_freeze+0x19/0x20
Aug 17 21:27:08 ubuntu kernel: [26639.199536]  [<c10371f0>]
get_signal_to_deliver+0x36/0x32e
Aug 17 21:27:08 ubuntu kernel: [26639.199546]  [<c1001fcd>]
do_notify_resume+0x77/0x735
Aug 17 21:27:08 ubuntu kernel: [26639.199556]  [<c103cec4>] ?
remove_wait_queue+0xf/0x27
Aug 17 21:27:08 ubuntu kernel: [26639.199565]  [<c13ee67b>] ?
_spin_unlock_irqrestore+0x36/0x5b
Aug 17 21:27:08 ubuntu kernel: [26639.199575]  [<c104a7d0>] ?
trace_hardirqs_on_caller+0x108/0x130
Aug 17 21:27:08 ubuntu kernel: [26639.199585]  [<c104a803>] ?
trace_hardirqs_on+0xb/0xd
Aug 17 21:27:08 ubuntu kernel: [26639.199594]  [<c13ee693>] ?
_spin_unlock_irqrestore+0x4e/0x5b
Aug 17 21:27:08 ubuntu kernel: [26639.199604]  [<c103ced7>] ?
remove_wait_queue+0x22/0x27
Aug 17 21:27:08 ubuntu kernel: [26639.199614]  [<c102e8e1>] ?
do_wait+0x1d9/0x290
Aug 17 21:27:08 ubuntu kernel: [26639.199623]  [<c10252f5>] ?
default_wake_function+0x0/0xd
Aug 17 21:27:08 ubuntu kernel: [26639.199633]  [<c102ea2c>] ?
sys_wait4+0x94/0xa1
Aug 17 21:27:08 ubuntu kernel: [26639.199643]  [<c1002d96>]
work_notifysig+0x13/0x19
Aug 17 21:27:08 ubuntu kernel: [26639.199651] bash          D 00001835
 2172  3351   3332 0x00000000
Aug 17 21:27:08 ubuntu kernel: [26639.199664]  edf2ae8c 00000046
c149cc3a 00001835 c1042993 df3e1754 c1689a00 00000046
Aug 17 21:27:08 ubuntu kernel: [26639.199685]  c1685eb8 c1689a00
df3e1754 c1689a00 c1042993 00000007 df3e14c0 c13ee6c2
Aug 17 21:27:08 ubuntu kernel: [26639.199706]  c14983a9 00001835
df3e14c0 de4a0504 00000002 edf2ae80 c104a803 00000000
Aug 17 21:27:08 ubuntu kernel: [26639.199726] Call Trace:
Aug 17 21:27:08 ubuntu kernel: [26639.199736]  [<c1042993>] ?
refrigerator+0x72/0xdb
Aug 17 21:27:08 ubuntu kernel: [26639.199746]  [<c1042993>] ?
refrigerator+0x72/0xdb
Aug 17 21:27:08 ubuntu kernel: [26639.199755]  [<c13ee6c2>] ?
_spin_unlock_irq+0x22/0x45
Aug 17 21:27:08 ubuntu kernel: [26639.199765]  [<c104a803>] ?
trace_hardirqs_on+0xb/0xd
Aug 17 21:27:08 ubuntu kernel: [26639.199775]  [<c10429e5>]
refrigerator+0xc4/0xdb
Aug 17 21:27:08 ubuntu kernel: [26639.199784]  [<c1035b74>]
try_to_freeze+0x19/0x20
Aug 17 21:27:08 ubuntu kernel: [26639.199793]  [<c10371f0>]
get_signal_to_deliver+0x36/0x32e
Aug 17 21:27:08 ubuntu kernel: [26639.199802]  [<c104a803>] ?
trace_hardirqs_on+0xb/0xd
Aug 17 21:27:08 ubuntu kernel: [26639.199812]  [<c1001fcd>]
do_notify_resume+0x77/0x735
Aug 17 21:27:08 ubuntu kernel: [26639.199822]  [<c11e7b62>] ?
n_tty_read+0x516/0x5b7
Aug 17 21:27:08 ubuntu kernel: [26639.199832]  [<c11e9d45>] ?
put_ldisc+0x7d/0x83
Aug 17 21:27:08 ubuntu kernel: [26639.199841]  [<c104a7d0>] ?
trace_hardirqs_on_caller+0x108/0x130
Aug 17 21:27:08 ubuntu kernel: [26639.199851]  [<c104a803>] ?
trace_hardirqs_on+0xb/0xd
Aug 17 21:27:08 ubuntu kernel: [26639.199860]  [<c11e9d53>] ?
tty_ldisc_deref+0x8/0xa
Aug 17 21:27:08 ubuntu kernel: [26639.199869]  [<c11e4037>] ? tty_read+0x72/0x9e
Aug 17 21:27:08 ubuntu kernel: [26639.199878]  [<c11e764c>] ?
n_tty_read+0x0/0x5b7
Aug 17 21:27:08 ubuntu kernel: [26639.199887]  [<c11e3fc5>] ? tty_read+0x0/0x9e
Aug 17 21:27:08 ubuntu kernel: [26639.199896]  [<c1094e62>] ? vfs_read+0x7d/0xdc
Aug 17 21:27:08 ubuntu kernel: [26639.199905]  [<c1094f6d>] ? sys_read+0x53/0x5d
Aug 17 21:27:08 ubuntu kernel: [26639.199914]  [<c1002d96>]
work_notifysig+0x13/0x19
Aug 17 21:27:08 ubuntu kernel: [26639.199922] system-servic D 00001835
 2220  3571      1 0x00000000
Aug 17 21:27:08 ubuntu kernel: [26639.199935]  c9283e8c 00000046
c1702e55 00001835 c1042993 d7c31754 c1689a00 00000046
Aug 17 21:27:08 ubuntu kernel: [26639.199956]  c1685eb8 c1689a00
d7c31754 c1689a00 c1042993 00000007 d7c314c0 c13ee6c2
Aug 17 21:27:08 ubuntu kernel: [26639.199977]  c14a0932 00001835
d7c314c0 de4a2b84 00000002 c9283e80 c104a803 00000000
Aug 17 21:27:08 ubuntu kernel: [26639.199997] Call Trace:
Aug 17 21:27:08 ubuntu kernel: [26639.200007]  [<c1042993>] ?
refrigerator+0x72/0xdb
Aug 17 21:27:08 ubuntu kernel: [26639.200017]  [<c1042993>] ?
refrigerator+0x72/0xdb
Aug 17 21:27:08 ubuntu kernel: [26639.200026]  [<c13ee6c2>] ?
_spin_unlock_irq+0x22/0x45
Aug 17 21:27:08 ubuntu kernel: [26639.200036]  [<c104a803>] ?
trace_hardirqs_on+0xb/0xd
Aug 17 21:27:08 ubuntu kernel: [26639.200046]  [<c10429e5>]
refrigerator+0xc4/0xdb
Aug 17 21:27:08 ubuntu kernel: [26639.200055]  [<c1035b74>]
try_to_freeze+0x19/0x20
Aug 17 21:27:08 ubuntu kernel: [26639.200064]  [<c10371f0>]
get_signal_to_deliver+0x36/0x32e
Aug 17 21:27:08 ubuntu kernel: [26639.200074]  [<c1001fcd>]
do_notify_resume+0x77/0x735
Aug 17 21:27:08 ubuntu kernel: [26639.200084]  [<c10242b1>] ?
finish_task_switch+0x2c/0x9b
Aug 17 21:27:08 ubuntu kernel: [26639.200094]  [<c13ee6c2>] ?
_spin_unlock_irq+0x22/0x45
Aug 17 21:27:08 ubuntu kernel: [26639.200103]  [<c104a7d0>] ?
trace_hardirqs_on_caller+0x108/0x130
Aug 17 21:27:08 ubuntu kernel: [26639.200113]  [<c104a803>] ?
trace_hardirqs_on+0xb/0xd
Aug 17 21:27:08 ubuntu kernel: [26639.200122]  [<c13ee6d9>] ?
_spin_unlock_irq+0x39/0x45
Aug 17 21:27:08 ubuntu kernel: [26639.200132]  [<c10242ea>] ?
finish_task_switch+0x65/0x9b
Aug 17 21:27:08 ubuntu kernel: [26639.200141]  [<c102430a>] ?
finish_task_switch+0x85/0x9b
Aug 17 21:27:08 ubuntu kernel: [26639.200151]  [<c1020716>] ?
need_resched+0x14/0x1e
Aug 17 21:27:08 ubuntu kernel: [26639.200160]  [<c13eceba>] ?
schedule+0x777/0x795
Aug 17 21:27:08 ubuntu kernel: [26639.200171]  [<c10a0e1a>] ? sys_poll+0x42/0x8b
Aug 17 21:27:08 ubuntu kernel: [26639.200180]  [<c1002d96>]
work_notifysig+0x13/0x19
Aug 17 21:27:08 ubuntu kernel: [26639.200188] bash          D 00001835
 2096  3763   3274 0x00000000
Aug 17 21:27:08 ubuntu kernel: [26639.200201]  ead5de8c 00200046
c14a17a1 00001835 c1042993 df3e5594 c1689a00 00200046
Aug 17 21:27:08 ubuntu kernel: [26639.200222]  c1685eb8 c1689a00
df3e5594 c1689a00 c1042993 00000007 df3e5300 c13ee6c2
Aug 17 21:27:08 ubuntu kernel: [26639.200243]  c149e09c 00001835
df3e5300 df3eb104 00000002 ead5de80 c104a803 00000000
Aug 17 21:27:08 ubuntu kernel: [26639.200263] Call Trace:
Aug 17 21:27:08 ubuntu kernel: [26639.200273]  [<c1042993>] ?
refrigerator+0x72/0xdb
Aug 17 21:27:08 ubuntu kernel: [26639.200283]  [<c1042993>] ?
refrigerator+0x72/0xdb
Aug 17 21:27:08 ubuntu kernel: [26639.200292]  [<c13ee6c2>] ?
_spin_unlock_irq+0x22/0x45
Aug 17 21:27:08 ubuntu kernel: [26639.200302]  [<c104a803>] ?
trace_hardirqs_on+0xb/0xd
Aug 17 21:27:08 ubuntu kernel: [26639.200312]  [<c10429e5>]
refrigerator+0xc4/0xdb
Aug 17 21:27:08 ubuntu kernel: [26639.200321]  [<c1035b74>]
try_to_freeze+0x19/0x20
Aug 17 21:27:08 ubuntu kernel: [26639.200330]  [<c10371f0>]
get_signal_to_deliver+0x36/0x32e
Aug 17 21:27:08 ubuntu kernel: [26639.200340]  [<c1001fcd>]
do_notify_resume+0x77/0x735
Aug 17 21:27:08 ubuntu kernel: [26639.200350]  [<c103cec4>] ?
remove_wait_queue+0xf/0x27
Aug 17 21:27:08 ubuntu kernel: [26639.200359]  [<c13ee67b>] ?
_spin_unlock_irqrestore+0x36/0x5b
Aug 17 21:27:08 ubuntu kernel: [26639.200369]  [<c104a7d0>] ?
trace_hardirqs_on_caller+0x108/0x130
Aug 17 21:27:08 ubuntu kernel: [26639.200378]  [<c104a803>] ?
trace_hardirqs_on+0xb/0xd
Aug 17 21:27:08 ubuntu kernel: [26639.200388]  [<c13ee693>] ?
_spin_unlock_irqrestore+0x4e/0x5b
Aug 17 21:27:09 ubuntu kernel: [26639.200398]  [<c103ced7>] ?
remove_wait_queue+0x22/0x27
Aug 17 21:27:09 ubuntu kernel: [26639.200407]  [<c102e8e1>] ?
do_wait+0x1d9/0x290
Aug 17 21:27:09 ubuntu kernel: [26639.200416]  [<c10252f5>] ?
default_wake_function+0x0/0xd
Aug 17 21:27:09 ubuntu kernel: [26639.200426]  [<c102ea2c>] ?
sys_wait4+0x94/0xa1
Aug 17 21:27:09 ubuntu kernel: [26639.200437]  [<c1002d96>]
work_notifysig+0x13/0x19
Aug 17 21:27:09 ubuntu kernel: [26639.200445] firefox       D 00001835
 1972  3996      1 0x00000008
Aug 17 21:27:09 ubuntu kernel: [26639.200458]  e972be8c 00000046
c171db5f 00001835 c1042993 df3e74b4 c1689a00 00000ee2
Aug 17 21:27:09 ubuntu kernel: [26639.200479]  c1685eb8 c1689a00
df3e74b4 c1689a00 c13f6bd0 00787ac3 c2c99eb8 ffffffff
Aug 17 21:27:09 ubuntu kernel: [26639.200499]  c171b3d8 00001835
df3e7220 00000078 00000000 00000000 00000ee2 00000000
Aug 17 21:27:09 ubuntu kernel: [26639.200520] Call Trace:
Aug 17 21:27:09 ubuntu kernel: [26639.200529]  [<c1042993>] ?
refrigerator+0x72/0xdb
Aug 17 21:27:09 ubuntu kernel: [26639.200541]  [<c10429e5>]
refrigerator+0xc4/0xdb
Aug 17 21:27:09 ubuntu kernel: [26639.200550]  [<c1035b74>]
try_to_freeze+0x19/0x20
Aug 17 21:27:09 ubuntu kernel: [26639.200559]  [<c10371f0>]
get_signal_to_deliver+0x36/0x32e
Aug 17 21:27:09 ubuntu kernel: [26639.200569]  [<c1001fcd>]
do_notify_resume+0x77/0x735
Aug 17 21:27:09 ubuntu kernel: [26639.200579]  [<c1094592>] ?
fsnotify_modify+0x4f/0x5a
Aug 17 21:27:09 ubuntu kernel: [26639.200589]  [<c10952f9>] ?
do_readv_writev+0xd2/0xdf
Aug 17 21:27:09 ubuntu kernel: [26639.200599]  [<c1095813>] ?
__rcu_read_lock+0x0/0x2b
Aug 17 21:27:09 ubuntu kernel: [26639.200609]  [<c10a0e1a>] ? sys_poll+0x42/0x8b
Aug 17 21:27:09 ubuntu kernel: [26639.200619]  [<c1002d96>]
work_notifysig+0x13/0x19
Aug 17 21:27:09 ubuntu kernel: [26639.200627] firefox       D 00001835
 2564  3999      1 0x00000000
Aug 17 21:27:09 ubuntu kernel: [26639.200640]  e3982e8c 00200046
c14a7a11 00001835 e3982e4c df3e6a54 c1689a00 df3ec184
Aug 17 21:27:09 ubuntu kernel: [26639.200661]  c1685eb8 c1689a00
df3e6a54 c1689a00 e3982e70 00000007 df3e67c0 c13ee6c2
Aug 17 21:27:09 ubuntu kernel: [26639.200717]  c14a2de9 00001835
df3e67c0 df3ec184 00000002 e3982e80 c104a803 00000000
Aug 17 21:27:09 ubuntu kernel: [26639.200738] Call Trace:
Aug 17 21:27:09 ubuntu kernel: [26639.200749]  [<c13ee6c2>] ?
_spin_unlock_irq+0x22/0x45
Aug 17 21:27:09 ubuntu kernel: [26639.200760]  [<c104a803>] ?
trace_hardirqs_on+0xb/0xd
Aug 17 21:27:09 ubuntu kernel: [26639.200770]  [<c10429e5>]
refrigerator+0xc4/0xdb
Aug 17 21:27:09 ubuntu kernel: [26639.200779]  [<c1035b74>]
try_to_freeze+0x19/0x20
Aug 17 21:27:09 ubuntu kernel: [26639.200788]  [<c10371f0>]
get_signal_to_deliver+0x36/0x32e
Aug 17 21:27:09 ubuntu kernel: [26639.200796]  [<c107e7e3>] ?
might_fault+0x4b/0x88
Aug 17 21:27:09 ubuntu kernel: [26639.200806]  [<c1001fcd>]
do_notify_resume+0x77/0x735
Aug 17 21:27:09 ubuntu kernel: [26639.200816]  [<c107e7e3>] ?
might_fault+0x4b/0x88
Aug 17 21:27:09 ubuntu kernel: [26639.200826]  [<c1043079>] ?
clocksource_read+0x9/0xc
Aug 17 21:27:09 ubuntu kernel: [26639.200835]  [<c1043382>] ?
getnstimeofday+0x4d/0xd7
Aug 17 21:27:09 ubuntu kernel: [26639.200845]  [<c103fd87>] ?
ktime_get_ts+0x40/0x44
Aug 17 21:27:09 ubuntu kernel: [26639.200855]  [<c104f07c>] ?
sys_futex+0xe1/0xf5
Aug 17 21:27:09 ubuntu kernel: [26639.200864]  [<c1002bfa>] ?
sysenter_exit+0xf/0x1a
Aug 17 21:27:09 ubuntu kernel: [26639.200874]  [<c1002d96>]
work_notifysig+0x13/0x19
Aug 17 21:27:09 ubuntu kernel: [26639.200881] firefox       D 00001835
 1472  4000      1 0x00000000
Aug 17 21:27:09 ubuntu kernel: [26639.200894]  e3bdbe8c 00200046
c1709bd2 00001835 c1042993 df3e5ff4 c1689a00 00200046
Aug 17 21:27:09 ubuntu kernel: [26639.200915]  c1685eb8 c1689a00
df3e5ff4 c1689a00 c1042993 00000007 df3e5d60 c13ee6c2
Aug 17 21:27:09 ubuntu kernel: [26639.200936]  c14a5601 00001835
df3e5d60 df3ec184 00000002 e3bdbe80 c104a803 00000000
Aug 17 21:27:09 ubuntu kernel: [26639.200956] Call Trace:
Aug 17 21:27:09 ubuntu kernel: [26639.200965]  [<c1042993>] ?
refrigerator+0x72/0xdb
Aug 17 21:27:09 ubuntu kernel: [26639.200975]  [<c1042993>] ?
refrigerator+0x72/0xdb
Aug 17 21:27:09 ubuntu kernel: [26639.200985]  [<c13ee6c2>] ?
_spin_unlock_irq+0x22/0x45
Aug 17 21:27:09 ubuntu kernel: [26639.200994]  [<c104a803>] ?
trace_hardirqs_on+0xb/0xd
Aug 17 21:27:09 ubuntu kernel: [26639.201004]  [<c10429e5>]
refrigerator+0xc4/0xdb
Aug 17 21:27:09 ubuntu kernel: [26639.201014]  [<c1035b74>]
try_to_freeze+0x19/0x20
Aug 17 21:27:09 ubuntu kernel: [26639.201022]  [<c10371f0>]
get_signal_to_deliver+0x36/0x32e
Aug 17 21:27:09 ubuntu kernel: [26639.201031]  [<c107e7e3>] ?
might_fault+0x4b/0x88
Aug 17 21:27:09 ubuntu kernel: [26639.201041]  [<c1001fcd>]
do_notify_resume+0x77/0x735
Aug 17 21:27:09 ubuntu kernel: [26639.201050]  [<c104bac2>] ?
__lock_acquire+0xad3/0xae2
Aug 17 21:27:09 ubuntu kernel: [26639.201061]  [<c107e7e3>] ?
might_fault+0x4b/0x88
Aug 17 21:27:09 ubuntu kernel: [26639.201071]  [<c1043079>] ?
clocksource_read+0x9/0xc
Aug 17 21:27:09 ubuntu kernel: [26639.201080]  [<c1043382>] ?
getnstimeofday+0x4d/0xd7
Aug 17 21:27:09 ubuntu kernel: [26639.201091]  [<c10a0e1a>] ? sys_poll+0x42/0x8b
Aug 17 21:27:09 ubuntu kernel: [26639.201100]  [<c1002d96>]
work_notifysig+0x13/0x19
Aug 17 21:27:09 ubuntu kernel: [26639.201108] firefox       D 00001835
 2400  4001      1 0x00000000
Aug 17 21:27:09 ubuntu kernel: [26639.201121]  e3978e8c 00200046
c14ae2d1 00001835 e3978e4c e27974b4 c1689a00 df3ec184
Aug 17 21:27:09 ubuntu kernel: [26639.201142]  c1685eb8 c1689a00
e27974b4 c1689a00 e3978e70 00000007 e2797220 c13ee6c2
Aug 17 21:27:09 ubuntu kernel: [26639.201163]  c14a9cbd 00001835
e2797220 df3ec184 00000002 e3978e80 c104a803 00000000
Aug 17 21:27:09 ubuntu kernel: [26639.201183] Call Trace:
Aug 17 21:27:09 ubuntu kernel: [26639.201194]  [<c13ee6c2>] ?
_spin_unlock_irq+0x22/0x45
Aug 17 21:27:09 ubuntu kernel: [26639.201204]  [<c104a803>] ?
trace_hardirqs_on+0xb/0xd
Aug 17 21:27:09 ubuntu kernel: [26639.201214]  [<c10429e5>]
refrigerator+0xc4/0xdb
Aug 17 21:27:09 ubuntu kernel: [26639.201223]  [<c1035b74>]
try_to_freeze+0x19/0x20
Aug 17 21:27:09 ubuntu kernel: [26639.201232]  [<c10371f0>]
get_signal_to_deliver+0x36/0x32e
Aug 17 21:27:09 ubuntu kernel: [26639.201241]  [<c107e7e3>] ?
might_fault+0x4b/0x88
Aug 17 21:27:09 ubuntu kernel: [26639.201250]  [<c1001fcd>]
do_notify_resume+0x77/0x735
Aug 17 21:27:09 ubuntu kernel: [26639.201260]  [<c107e7e3>] ?
might_fault+0x4b/0x88
Aug 17 21:27:09 ubuntu kernel: [26639.201270]  [<c1043079>] ?
clocksource_read+0x9/0xc
Aug 17 21:27:09 ubuntu kernel: [26639.201279]  [<c1043382>] ?
getnstimeofday+0x4d/0xd7
Aug 17 21:27:09 ubuntu kernel: [26639.201289]  [<c103fd87>] ?
ktime_get_ts+0x40/0x44
Aug 17 21:27:09 ubuntu kernel: [26639.201299]  [<c104f07c>] ?
sys_futex+0xe1/0xf5
Aug 17 21:27:09 ubuntu kernel: [26639.201308]  [<c1002bfa>] ?
sysenter_exit+0xf/0x1a
Aug 17 21:27:09 ubuntu kernel: [26639.201318]  [<c1002d96>]
work_notifysig+0x13/0x19
Aug 17 21:27:09 ubuntu kernel: [26639.201325] firefox       D 00001835
 1520  4018      1 0x00000000
Aug 17 21:27:09 ubuntu kernel: [26639.201338]  e0411e8c 00200046
c170f084 00001835 c1042993 df3f21b4 c1689a00 00200046
Aug 17 21:27:09 ubuntu kernel: [26639.201359]  c1685eb8 c1689a00
df3f21b4 c1689a00 c1042993 00000007 df3f1f20 c13ee6c2
Aug 17 21:27:09 ubuntu kernel: [26639.201380]  c14a7ab9 00001835
df3f1f20 df3ec184 00000002 e0411e80 c104a803 00000000
Aug 17 21:27:09 ubuntu kernel: [26639.201400] Call Trace:
Aug 17 21:27:09 ubuntu kernel: [26639.201409]  [<c1042993>] ?
refrigerator+0x72/0xdb
Aug 17 21:27:09 ubuntu kernel: [26639.201419]  [<c1042993>] ?
refrigerator+0x72/0xdb
Aug 17 21:27:09 ubuntu kernel: [26639.201429]  [<c13ee6c2>] ?
_spin_unlock_irq+0x22/0x45
Aug 17 21:27:09 ubuntu kernel: [26639.201439]  [<c104a803>] ?
trace_hardirqs_on+0xb/0xd
Aug 17 21:27:09 ubuntu kernel: [26639.201448]  [<c10429e5>]
refrigerator+0xc4/0xdb
Aug 17 21:27:09 ubuntu kernel: [26639.201458]  [<c1035b74>]
try_to_freeze+0x19/0x20
Aug 17 21:27:09 ubuntu kernel: [26639.201466]  [<c10371f0>]
get_signal_to_deliver+0x36/0x32e
Aug 17 21:27:09 ubuntu kernel: [26639.201476]  [<c1001fcd>]
do_notify_resume+0x77/0x735
Aug 17 21:27:09 ubuntu kernel: [26639.201486]  [<c1157a57>] ?
file_has_perm+0x87/0xa1
Aug 17 21:27:09 ubuntu kernel: [26639.201497]  [<c103ccb5>] ?
autoremove_wake_function+0x0/0x2f
Aug 17 21:27:09 ubuntu kernel: [26639.201519]  [<c1094592>] ?
fsnotify_modify+0x4f/0x5a
Aug 17 21:27:09 ubuntu kernel: [26639.201534]  [<c104f07c>] ?
sys_futex+0xe1/0xf5
Aug 17 21:27:09 ubuntu kernel: [26639.201548]  [<c1002bfa>] ?
sysenter_exit+0xf/0x1a
Aug 17 21:27:09 ubuntu kernel: [26639.201564]  [<c104a7d0>] ?
trace_hardirqs_on_caller+0x108/0x130
Aug 17 21:27:09 ubuntu kernel: [26639.201577]  [<c1002d96>]
work_notifysig+0x13/0x19
Aug 17 21:27:09 ubuntu kernel: [26639.201586] firefox       D 00001835
 2824  4019      1 0x00000000
Aug 17 21:27:09 ubuntu kernel: [26639.201600]  e0410e8c 00200046
c1711e73 00001835 c1042993 df3f74b4 c1689a00 00200046
Aug 17 21:27:09 ubuntu kernel: [26639.201621]  c1685eb8 c1689a00
df3f74b4 c1689a00 c1042993 00000007 df3f7220 c13ee6c2
Aug 17 21:27:09 ubuntu kernel: [26639.201641]  c14ac1ec 00001835
df3f7220 df3ec184 00000002 e0410e80 c104a803 00000000
Aug 17 21:27:09 ubuntu kernel: [26639.201662] Call Trace:
Aug 17 21:27:09 ubuntu kernel: [26639.201671]  [<c1042993>] ?
refrigerator+0x72/0xdb
Aug 17 21:27:09 ubuntu kernel: [26639.201681]  [<c1042993>] ?
refrigerator+0x72/0xdb
Aug 17 21:27:09 ubuntu kernel: [26639.201691]  [<c13ee6c2>] ?
_spin_unlock_irq+0x22/0x45
Aug 17 21:27:09 ubuntu kernel: [26639.201701]  [<c104a803>] ?
trace_hardirqs_on+0xb/0xd
Aug 17 21:27:09 ubuntu kernel: [26639.201710]  [<c10429e5>]
refrigerator+0xc4/0xdb
Aug 17 21:27:09 ubuntu kernel: [26639.201720]  [<c1035b74>]
try_to_freeze+0x19/0x20
Aug 17 21:27:09 ubuntu kernel: [26639.201729]  [<c10371f0>]
get_signal_to_deliver+0x36/0x32e
Aug 17 21:27:09 ubuntu kernel: [26639.201739]  [<c1001fcd>]
do_notify_resume+0x77/0x735
Aug 17 21:27:09 ubuntu kernel: [26639.201751]  [<c100a01d>] ?
restore_i387_xstate+0x16c/0x1a3
Aug 17 21:27:09 ubuntu kernel: [26639.201762]  [<c104f07c>] ?
sys_futex+0xe1/0xf5
Aug 17 21:27:09 ubuntu kernel: [26639.201771]  [<c1002ce7>] ?
restore_all_notrace+0x0/0x18
Aug 17 21:27:09 ubuntu kernel: [26639.201781]  [<c104a7d0>] ?
trace_hardirqs_on_caller+0x108/0x130
Aug 17 21:27:09 ubuntu kernel: [26639.201790]  [<c1002d96>]
work_notifysig+0x13/0x19
Aug 17 21:27:09 ubuntu kernel: [26639.201798] firefox       D 00001835
 1916  4021      1 0x00000000
Aug 17 21:27:09 ubuntu kernel: [26639.201811]  e0425e8c 00200046
c14b2704 00001835 e0425e4c d7c30294 c1689a00 df3ec184
Aug 17 21:27:09 ubuntu kernel: [26639.201832]  c1685eb8 c1689a00
d7c30294 c1689a00 e0425e70 00000007 d7c30000 c13ee6c2
Aug 17 21:27:09 ubuntu kernel: [26639.201853]  c13ee11b 00001835
d7c30000 df3ec184 00000002 e0425e80 c104a803 00000000
Aug 17 21:27:09 ubuntu kernel: [26639.201873] Call Trace:
Aug 17 21:27:09 ubuntu kernel: [26639.201884]  [<c13ee6c2>] ?
_spin_unlock_irq+0x22/0x45
Aug 17 21:27:09 ubuntu kernel: [26639.201893]  [<c13ee11b>] ?
_spin_trylock_bh+0x3b/0x5b
Aug 17 21:27:09 ubuntu kernel: [26639.201903]  [<c104a803>] ?
trace_hardirqs_on+0xb/0xd
Aug 17 21:27:09 ubuntu kernel: [26639.201913]  [<c10429e5>]
refrigerator+0xc4/0xdb
Aug 17 21:27:09 ubuntu kernel: [26639.201922]  [<c1035b74>]
try_to_freeze+0x19/0x20
Aug 17 21:27:09 ubuntu kernel: [26639.201931]  [<c10371f0>]
get_signal_to_deliver+0x36/0x32e
Aug 17 21:27:09 ubuntu kernel: [26639.201941]  [<c1001fcd>]
do_notify_resume+0x77/0x735
Aug 17 21:27:09 ubuntu kernel: [26639.201952]  [<c10905be>] ?
kmem_cache_free+0x98/0xea
Aug 17 21:27:09 ubuntu kernel: [26639.201962]  [<c10bd6b5>] ?
locks_free_lock+0x3d/0x40
Aug 17 21:27:09 ubuntu kernel: [26639.201972]  [<c104a7d0>] ?
trace_hardirqs_on_caller+0x108/0x130
Aug 17 21:27:09 ubuntu kernel: [26639.201981]  [<c104a803>] ?
trace_hardirqs_on+0xb/0xd
Aug 17 21:27:09 ubuntu kernel: [26639.201991]  [<c10bd6b5>] ?
locks_free_lock+0x3d/0x40
Aug 17 21:27:09 ubuntu kernel: [26639.202000]  [<c10bd6b5>] ?
locks_free_lock+0x3d/0x40
Aug 17 21:27:09 ubuntu kernel: [26639.202010]  [<c104f07c>] ?
sys_futex+0xe1/0xf5
Aug 17 21:27:09 ubuntu kernel: [26639.202020]  [<c1002bfa>] ?
sysenter_exit+0xf/0x1a
Aug 17 21:27:09 ubuntu kernel: [26639.202029]  [<c104a7d0>] ?
trace_hardirqs_on_caller+0x108/0x130
Aug 17 21:27:09 ubuntu kernel: [26639.202039]  [<c1002d96>]
work_notifysig+0x13/0x19
Aug 17 21:27:09 ubuntu kernel: [26639.202046] firefox       D 00001835
 2144  4025      1 0x00000000
Aug 17 21:27:09 ubuntu kernel: [26639.202060]  e0bc5e8c 00200046
c17166df 00001835 c1042993 d7c36a54 c1689a00 00200046
Aug 17 21:27:09 ubuntu kernel: [26639.202081]  c1685eb8 c1689a00
d7c36a54 c1689a00 c1042993 00000007 d7c367c0 c13ee6c2
Aug 17 21:27:09 ubuntu kernel: [26639.202101]  c1314d2e 00001835
d7c367c0 df3ec184 00000002 e0bc5e80 c104a803 00000000
Aug 17 21:27:09 ubuntu kernel: [26639.202122] Call Trace:
Aug 17 21:27:09 ubuntu kernel: [26639.202131]  [<c1042993>] ?
refrigerator+0x72/0xdb
Aug 17 21:27:09 ubuntu kernel: [26639.202141]  [<c1042993>] ?
refrigerator+0x72/0xdb
Aug 17 21:27:09 ubuntu kernel: [26639.202150]  [<c13ee6c2>] ?
_spin_unlock_irq+0x22/0x45
Aug 17 21:27:09 ubuntu kernel: [26639.202160]  [<c1314d2e>] ?
sock_getsockopt+0x40a/0x437
Aug 17 21:27:09 ubuntu kernel: [26639.202170]  [<c104a803>] ?
trace_hardirqs_on+0xb/0xd
Aug 17 21:27:09 ubuntu kernel: [26639.202179]  [<c10429e5>]
refrigerator+0xc4/0xdb
Aug 17 21:27:09 ubuntu kernel: [26639.202189]  [<c1035b74>]
try_to_freeze+0x19/0x20
Aug 17 21:27:09 ubuntu kernel: [26639.202198]  [<c10371f0>]
get_signal_to_deliver+0x36/0x32e
Aug 17 21:27:09 ubuntu kernel: [26639.202207]  [<c107e7e3>] ?
might_fault+0x4b/0x88
Aug 17 21:27:09 ubuntu kernel: [26639.202216]  [<c1001fcd>]
do_notify_resume+0x77/0x735
Aug 17 21:27:09 ubuntu kernel: [26639.202227]  [<c107e7e3>] ?
might_fault+0x4b/0x88
Aug 17 21:27:09 ubuntu kernel: [26639.202236]  [<c107e7e3>] ?
might_fault+0x4b/0x88
Aug 17 21:27:09 ubuntu kernel: [26639.202246]  [<c104f07c>] ?
sys_futex+0xe1/0xf5
Aug 17 21:27:09 ubuntu kernel: [26639.202256]  [<c10a0e1a>] ? sys_poll+0x42/0x8b
Aug 17 21:27:09 ubuntu kernel: [26639.202265]  [<c1002d96>]
work_notifysig+0x13/0x19
Aug 17 21:27:09 ubuntu kernel: [26639.202273] firefox       D 00001835
 2824  4033      1 0x00000000
Aug 17 21:27:09 ubuntu kernel: [26639.202287]  dc804e8c 00200046
c1712bc5 00001835 c1042993 df3e2c14 c1689a00 000014e2
Aug 17 21:27:09 ubuntu kernel: [26639.202308]  c1685eb8 c1689a00
df3e2c14 c1689a00 c13f6b10 00787ac3 c2c99eb8 00000001
Aug 17 21:27:09 ubuntu kernel: [26639.202329]  c1712bc5 00001835
df3e2980 00000078 00000000 00000000 000014e2 00000000
Aug 17 21:27:09 ubuntu kernel: [26639.202349] Call Trace:
Aug 17 21:27:09 ubuntu kernel: [26639.202358]  [<c1042993>] ?
refrigerator+0x72/0xdb
Aug 17 21:27:09 ubuntu kernel: [26639.202370]  [<c10429e5>]
refrigerator+0xc4/0xdb
Aug 17 21:27:09 ubuntu kernel: [26639.202379]  [<c1035b74>]
try_to_freeze+0x19/0x20
Aug 17 21:27:09 ubuntu kernel: [26639.202388]  [<c10371f0>]
get_signal_to_deliver+0x36/0x32e
Aug 17 21:27:09 ubuntu kernel: [26639.202398]  [<c1001fcd>]
do_notify_resume+0x77/0x735
Aug 17 21:27:09 ubuntu kernel: [26639.202408]  [<c1043382>] ?
getnstimeofday+0x4d/0xd7
Aug 17 21:27:09 ubuntu kernel: [26639.202418]  [<c10131de>] ?
lapic_next_event+0xf/0x13
Aug 17 21:27:09 ubuntu kernel: [26639.202427]  [<c10463c3>] ?
clockevents_program_event+0xba/0xc8
Aug 17 21:27:09 ubuntu kernel: [26639.202437]  [<c10473ac>] ?
tick_dev_program_event+0x34/0xa2
Aug 17 21:27:09 ubuntu kernel: [26639.202447]  [<c1047475>] ?
tick_program_event+0x33/0x3b
Aug 17 21:27:09 ubuntu kernel: [26639.202457]  [<c104f07c>] ?
sys_futex+0xe1/0xf5
Aug 17 21:27:09 ubuntu kernel: [26639.202466]  [<c1002ce7>] ?
restore_all_notrace+0x0/0x18
Aug 17 21:27:09 ubuntu kernel: [26639.202476]  [<c104a7d0>] ?
trace_hardirqs_on_caller+0x108/0x130
Aug 17 21:27:09 ubuntu kernel: [26639.202486]  [<c1002d96>]
work_notifysig+0x13/0x19
Aug 17 21:27:09 ubuntu kernel: [26639.202493] firefox       D 00001835
 2824  4034      1 0x00000000
Aug 17 21:27:09 ubuntu kernel: [26639.202507]  dff8ae8c 00200046
c170ba1b 00001835 c1042993 e2795ff4 c1689a00 00001ae2
Aug 17 21:27:09 ubuntu kernel: [26639.202528]  c1685eb8 c1689a00
e2795ff4 c1689a00 c13f6b10 00787ac3 c2c99eb8 00000001
Aug 17 21:27:09 ubuntu kernel: [26639.202549]  c170ba1b 00001835
e2795d60 00000078 00000000 00000000 00001ae2 00000000
Aug 17 21:27:09 ubuntu kernel: [26639.202569] Call Trace:
Aug 17 21:27:09 ubuntu kernel: [26639.202578]  [<c1042993>] ?
refrigerator+0x72/0xdb
Aug 17 21:27:09 ubuntu kernel: [26639.202590]  [<c10429e5>]
refrigerator+0xc4/0xdb
Aug 17 21:27:09 ubuntu kernel: [26639.202599]  [<c1035b74>]
try_to_freeze+0x19/0x20
Aug 17 21:27:09 ubuntu kernel: [26639.202608]  [<c10371f0>]
get_signal_to_deliver+0x36/0x32e
Aug 17 21:27:09 ubuntu kernel: [26639.202618]  [<c1001fcd>]
do_notify_resume+0x77/0x735
Aug 17 21:27:09 ubuntu kernel: [26639.202630]  [<c10242b1>] ?
finish_task_switch+0x2c/0x9b
Aug 17 21:27:09 ubuntu kernel: [26639.202640]  [<c13ee6c2>] ?
_spin_unlock_irq+0x22/0x45
Aug 17 21:27:09 ubuntu kernel: [26639.202649]  [<c104a7d0>] ?
trace_hardirqs_on_caller+0x108/0x130
Aug 17 21:27:09 ubuntu kernel: [26639.202659]  [<c104f07c>] ?
sys_futex+0xe1/0xf5
Aug 17 21:27:09 ubuntu kernel: [26639.202669]  [<c1002bfa>] ?
sysenter_exit+0xf/0x1a
Aug 17 21:27:09 ubuntu kernel: [26639.202678]  [<c104a7d0>] ?
trace_hardirqs_on_caller+0x108/0x130
Aug 17 21:27:09 ubuntu kernel: [26639.202688]  [<c1002d96>]
work_notifysig+0x13/0x19
Aug 17 21:27:09 ubuntu kernel: [26639.202696] firefox       D 00001835
 1880  4042      1 0x00000000
Aug 17 21:27:09 ubuntu kernel: [26639.202709]  d7c4ce8c 00200046
c1704064 00001835 c1042993 d7c35594 c1689a00 00001ee2
Aug 17 21:27:09 ubuntu kernel: [26639.202729]  c1685eb8 c1689a00
d7c35594 c1689a00 c13f6b10 00787ac3 c2c99eb8 00000001
Aug 17 21:27:09 ubuntu kernel: [26639.202750]  c1704064 00001835
d7c35300 00000078 00000000 00000000 00001ee2 00000000
Aug 17 21:27:09 ubuntu kernel: [26639.202771] Call Trace:
Aug 17 21:27:09 ubuntu kernel: [26639.202780]  [<c1042993>] ?
refrigerator+0x72/0xdb
Aug 17 21:27:09 ubuntu kernel: [26639.202792]  [<c10429e5>]
refrigerator+0xc4/0xdb
Aug 17 21:27:09 ubuntu kernel: [26639.202801]  [<c1035b74>]
try_to_freeze+0x19/0x20
Aug 17 21:27:09 ubuntu kernel: [26639.202810]  [<c10371f0>]
get_signal_to_deliver+0x36/0x32e
Aug 17 21:27:09 ubuntu kernel: [26639.202820]  [<c1001fcd>]
do_notify_resume+0x77/0x735
Aug 17 21:27:09 ubuntu kernel: [26639.202830]  [<c13ed375>] ?
__mutex_unlock_slowpath+0xe0/0x101
Aug 17 21:27:09 ubuntu kernel: [26639.202840]  [<c104a7d0>] ?
trace_hardirqs_on_caller+0x108/0x130
Aug 17 21:27:09 ubuntu kernel: [26639.202849]  [<c104a803>] ?
trace_hardirqs_on+0xb/0xd
Aug 17 21:27:09 ubuntu kernel: [26639.202858]  [<c13ed388>] ?
__mutex_unlock_slowpath+0xf3/0x101
Aug 17 21:27:09 ubuntu kernel: [26639.202868]  [<c13ed39e>] ?
mutex_unlock+0x8/0xa
Aug 17 21:27:09 ubuntu kernel: [26639.202877]  [<c1093c88>] ?
do_truncate+0x6e/0x78
Aug 17 21:27:09 ubuntu kernel: [26639.202885]  [<c1095813>] ?
__rcu_read_lock+0x0/0x2b
Aug 17 21:27:09 ubuntu kernel: [26639.202896]  [<c104f07c>] ?
sys_futex+0xe1/0xf5
Aug 17 21:27:09 ubuntu kernel: [26639.202905]  [<c1002bfa>] ?
sysenter_exit+0xf/0x1a
Aug 17 21:27:09 ubuntu kernel: [26639.202914]  [<c104a7d0>] ?
trace_hardirqs_on_caller+0x108/0x130
Aug 17 21:27:09 ubuntu kernel: [26639.202924]  [<c1002d96>]
work_notifysig+0x13/0x19
Aug 17 21:27:09 ubuntu kernel: [26639.202932] firefox       D 00001835
 2340  7080      1 0x00000000
Aug 17 21:27:09 ubuntu kernel: [26639.202946]  ee8dce8c 00000046
c16fab2f 00001835 c1042993 c7903674 c1689a00 000024e2
Aug 17 21:27:09 ubuntu kernel: [26639.202966]  c1685eb8 c1689a00
c7903674 c1689a00 c13f6b10 00787ac3 c2c99eb8 00000001
Aug 17 21:27:09 ubuntu kernel: [26639.202987]  c16fab2f 00001835
c79033e0 00000078 00000000 00000000 000024e2 00000000
Aug 17 21:27:09 ubuntu kernel: [26639.203007] Call Trace:
Aug 17 21:27:09 ubuntu kernel: [26639.203017]  [<c1042993>] ?
refrigerator+0x72/0xdb
Aug 17 21:27:09 ubuntu kernel: [26639.203029]  [<c10429e5>]
refrigerator+0xc4/0xdb
Aug 17 21:27:09 ubuntu kernel: [26639.203039]  [<c1035b74>]
try_to_freeze+0x19/0x20
Aug 17 21:27:09 ubuntu kernel: [26639.203047]  [<c10371f0>]
get_signal_to_deliver+0x36/0x32e
Aug 17 21:27:09 ubuntu kernel: [26639.203058]  [<c1001fcd>]
do_notify_resume+0x77/0x735
Aug 17 21:27:09 ubuntu kernel: [26639.203067]  [<c103cec4>] ?
remove_wait_queue+0xf/0x27
Aug 17 21:27:09 ubuntu kernel: [26639.203077]  [<c13ee67b>] ?
_spin_unlock_irqrestore+0x36/0x5b
Aug 17 21:27:09 ubuntu kernel: [26639.203087]  [<c104a7d0>] ?
trace_hardirqs_on_caller+0x108/0x130
Aug 17 21:27:09 ubuntu kernel: [26639.203097]  [<c104a803>] ?
trace_hardirqs_on+0xb/0xd
Aug 17 21:27:09 ubuntu kernel: [26639.203106]  [<c13ee693>] ?
_spin_unlock_irqrestore+0x4e/0x5b
Aug 17 21:27:09 ubuntu kernel: [26639.203116]  [<c103ced7>] ?
remove_wait_queue+0x22/0x27
Aug 17 21:27:09 ubuntu kernel: [26639.203126]  [<c102e8e1>] ?
do_wait+0x1d9/0x290
Aug 17 21:27:09 ubuntu kernel: [26639.203135]  [<c10252f5>] ?
default_wake_function+0x0/0xd
Aug 17 21:27:09 ubuntu kernel: [26639.203145]  [<c102ea2c>] ?
sys_wait4+0x94/0xa1
Aug 17 21:27:09 ubuntu kernel: [26639.203155]  [<c10a0e1a>] ? sys_poll+0x42/0x8b
Aug 17 21:27:09 ubuntu kernel: [26639.203164]  [<c1002d96>]
work_notifysig+0x13/0x19
Aug 17 21:27:09 ubuntu kernel: [26639.203172] firefox       D 00001835
 1828  7696      1 0x00000000
Aug 17 21:27:09 ubuntu kernel: [26639.203185]  c71dee8c 00000046
c16f11eb 00001835 c1042993 c7902c14 c1689a00 00002ae2
Aug 17 21:27:09 ubuntu kernel: [26639.203206]  c1685eb8 c1689a00
c7902c14 c1689a00 c13f6b10 00787ac3 c2c99eb8 00000001
Aug 17 21:27:09 ubuntu kernel: [26639.203227]  c16f11eb 00001835
c7902980 00000078 00000000 00000000 00002ae2 00000000
Aug 17 21:27:09 ubuntu kernel: [26639.203248] Call Trace:
Aug 17 21:27:09 ubuntu kernel: [26639.203257]  [<c1042993>] ?
refrigerator+0x72/0xdb
Aug 17 21:27:09 ubuntu kernel: [26639.203269]  [<c10429e5>]
refrigerator+0xc4/0xdb
Aug 17 21:27:09 ubuntu kernel: [26639.203278]  [<c1035b74>]
try_to_freeze+0x19/0x20
Aug 17 21:27:09 ubuntu kernel: [26639.203287]  [<c10371f0>]
get_signal_to_deliver+0x36/0x32e
Aug 17 21:27:09 ubuntu kernel: [26639.203296]  [<c107e7e3>] ?
might_fault+0x4b/0x88
Aug 17 21:27:09 ubuntu kernel: [26639.203305]  [<c1001fcd>]
do_notify_resume+0x77/0x735
Aug 17 21:27:09 ubuntu kernel: [26639.203315]  [<c107e7e3>] ?
might_fault+0x4b/0x88
Aug 17 21:27:09 ubuntu kernel: [26639.203325]  [<c1043079>] ?
clocksource_read+0x9/0xc
Aug 17 21:27:09 ubuntu kernel: [26639.203335]  [<c1043382>] ?
getnstimeofday+0x4d/0xd7
Aug 17 21:27:09 ubuntu kernel: [26639.203344]  [<c103fd87>] ?
ktime_get_ts+0x40/0x44
Aug 17 21:27:09 ubuntu kernel: [26639.203354]  [<c104f07c>] ?
sys_futex+0xe1/0xf5
Aug 17 21:27:09 ubuntu kernel: [26639.203364]  [<c1002bfa>] ?
sysenter_exit+0xf/0x1a
Aug 17 21:27:09 ubuntu kernel: [26639.203373]  [<c1002d96>]
work_notifysig+0x13/0x19
Aug 17 21:27:09 ubuntu kernel: [26639.203381] firefox       D 00001835
 1764  7697      1 0x00000000
Aug 17 21:27:09 ubuntu kernel: [26639.203394]  ce38de8c 00000046
c16e7076 00001835 c1042993 c796ac14 c1689a00 000030e2
Aug 17 21:27:09 ubuntu kernel: [26639.203415]  c1685eb8 c1689a00
c796ac14 c1689a00 c13f6b10 00787ac3 c2c99eb8 00000001
Aug 17 21:27:09 ubuntu kernel: [26639.203436]  c16e7076 00001835
c796a980 00000078 00000000 00000000 000030e2 00000000
Aug 17 21:27:09 ubuntu kernel: [26639.203457] Call Trace:
Aug 17 21:27:09 ubuntu kernel: [26639.203466]  [<c1042993>] ?
refrigerator+0x72/0xdb
Aug 17 21:27:09 ubuntu kernel: [26639.203478]  [<c10429e5>]
refrigerator+0xc4/0xdb
Aug 17 21:27:09 ubuntu kernel: [26639.203487]  [<c1035b74>]
try_to_freeze+0x19/0x20
Aug 17 21:27:09 ubuntu kernel: [26639.203496]  [<c10371f0>]
get_signal_to_deliver+0x36/0x32e
Aug 17 21:27:09 ubuntu kernel: [26639.203504]  [<c107e7e3>] ?
might_fault+0x4b/0x88
Aug 17 21:27:09 ubuntu kernel: [26639.203514]  [<c1001fcd>]
do_notify_resume+0x77/0x735
Aug 17 21:27:09 ubuntu kernel: [26639.203524]  [<c107e7e3>] ?
might_fault+0x4b/0x88
Aug 17 21:27:09 ubuntu kernel: [26639.203534]  [<c1043079>] ?
clocksource_read+0x9/0xc
Aug 17 21:27:09 ubuntu kernel: [26639.203543]  [<c1043382>] ?
getnstimeofday+0x4d/0xd7
Aug 17 21:27:09 ubuntu kernel: [26639.203553]  [<c103fd87>] ?
ktime_get_ts+0x40/0x44
Aug 17 21:27:09 ubuntu kernel: [26639.203563]  [<c104f07c>] ?
sys_futex+0xe1/0xf5
Aug 17 21:27:09 ubuntu kernel: [26639.203572]  [<c1002bfa>] ?
sysenter_exit+0xf/0x1a
Aug 17 21:27:09 ubuntu kernel: [26639.203582]  [<c1002d96>]
work_notifysig+0x13/0x19
Aug 17 21:27:09 ubuntu kernel: [26639.203590] firefox       D 00001835
 1828 10917      1 0x00000000
Aug 17 21:27:10 ubuntu kernel: [26639.203603]  df15ce8c 00000046
c1513c87 00001835 c1042993 d7c340d4 c1689a00 00000046
Aug 17 21:27:10 ubuntu kernel: [26639.203624]  c1685eb8 c1689a00
d7c340d4 c1689a00 c1042993 00000007 d7c33e40 c13ee6c2
Aug 17 21:27:10 ubuntu kernel: [26639.203645]  c14194a6 00001835
d7c33e40 df3ec184 00000002 df15ce80 c104a803 00000000
Aug 17 21:27:10 ubuntu kernel: [26639.203665] Call Trace:
Aug 17 21:27:10 ubuntu kernel: [26639.203674]  [<c1042993>] ?
refrigerator+0x72/0xdb
Aug 17 21:27:10 ubuntu kernel: [26639.203684]  [<c1042993>] ?
refrigerator+0x72/0xdb
Aug 17 21:27:10 ubuntu kernel: [26639.203694]  [<c13ee6c2>] ?
_spin_unlock_irq+0x22/0x45
Aug 17 21:27:10 ubuntu kernel: [26639.203704]  [<c104a803>] ?
trace_hardirqs_on+0xb/0xd
Aug 17 21:27:10 ubuntu kernel: [26639.203713]  [<c10429e5>]
refrigerator+0xc4/0xdb
Aug 17 21:27:10 ubuntu kernel: [26639.203723]  [<c1035b74>]
try_to_freeze+0x19/0x20
Aug 17 21:27:10 ubuntu kernel: [26639.203732]  [<c10371f0>]
get_signal_to_deliver+0x36/0x32e
Aug 17 21:27:10 ubuntu kernel: [26639.203740]  [<c107e7e3>] ?
might_fault+0x4b/0x88
Aug 17 21:27:10 ubuntu kernel: [26639.203750]  [<c1001fcd>]
do_notify_resume+0x77/0x735
Aug 17 21:27:10 ubuntu kernel: [26639.203760]  [<c107e7e3>] ?
might_fault+0x4b/0x88
Aug 17 21:27:10 ubuntu kernel: [26639.203770]  [<c1043079>] ?
clocksource_read+0x9/0xc
Aug 17 21:27:10 ubuntu kernel: [26639.203779]  [<c1043382>] ?
getnstimeofday+0x4d/0xd7
Aug 17 21:27:10 ubuntu kernel: [26639.203789]  [<c103fd87>] ?
ktime_get_ts+0x40/0x44
Aug 17 21:27:10 ubuntu kernel: [26639.203799]  [<c104f07c>] ?
sys_futex+0xe1/0xf5
Aug 17 21:27:10 ubuntu kernel: [26639.203808]  [<c1002bfa>] ?
sysenter_exit+0xf/0x1a
Aug 17 21:27:10 ubuntu kernel: [26639.203818]  [<c1002d96>]
work_notifysig+0x13/0x19
Aug 17 21:27:10 ubuntu kernel: [26639.203826] firefox       D 00001835
 2240 11069      1 0x00000000
Aug 17 21:27:10 ubuntu kernel: [26639.203839]  d5c7ae8c 00000046
c16dd0ad 00001835 c1042993 df3f6a54 c1689a00 000034e2
Aug 17 21:27:10 ubuntu kernel: [26639.203860]  c1685eb8 c1689a00
df3f6a54 c1689a00 c13f6b10 00787ac3 c2c99eb8 00000001
Aug 17 21:27:10 ubuntu kernel: [26639.203881]  c16dd0ad 00001835
df3f67c0 00000078 00000000 00000000 000034e2 00000000
Aug 17 21:27:10 ubuntu kernel: [26639.203901] Call Trace:
Aug 17 21:27:10 ubuntu kernel: [26639.203910]  [<c1042993>] ?
refrigerator+0x72/0xdb
Aug 17 21:27:10 ubuntu kernel: [26639.203922]  [<c10429e5>]
refrigerator+0xc4/0xdb
Aug 17 21:27:10 ubuntu kernel: [26639.203932]  [<c1035b74>]
try_to_freeze+0x19/0x20
Aug 17 21:27:10 ubuntu kernel: [26639.203940]  [<c10371f0>]
get_signal_to_deliver+0x36/0x32e
Aug 17 21:27:10 ubuntu kernel: [26639.203950]  [<c107e7e3>] ?
might_fault+0x4b/0x88
Aug 17 21:27:10 ubuntu kernel: [26639.203959]  [<c1001fcd>]
do_notify_resume+0x77/0x735
Aug 17 21:27:10 ubuntu kernel: [26639.203969]  [<c107e7e3>] ?
might_fault+0x4b/0x88
Aug 17 21:27:10 ubuntu kernel: [26639.203979]  [<c107e7e3>] ?
might_fault+0x4b/0x88
Aug 17 21:27:10 ubuntu kernel: [26639.203989]  [<c131281a>] ?
sys_socketcall+0x169/0x185
Aug 17 21:27:10 ubuntu kernel: [26639.203999]  [<c10a0e1a>] ? sys_poll+0x42/0x8b
Aug 17 21:27:10 ubuntu kernel: [26639.204044]  [<c1002d96>]
work_notifysig+0x13/0x19
Aug 17 21:27:10 ubuntu kernel: [26639.204052] evolution-dat D 00001835
 2220  4837      1 0x00000000
Aug 17 21:27:10 ubuntu kernel: [26639.204066]  cede6e8c 00000046
c16d242b 00001835 c1042993 d4410294 c1689a00 00003ae2
Aug 17 21:27:10 ubuntu kernel: [26639.204087]  c1685eb8 c1689a00
d4410294 c1689a00 c13f6b10 00787ac3 c2c99eb8 00000001
Aug 17 21:27:10 ubuntu kernel: [26639.204108]  c16d242b 00001835
d4410000 00000078 00000000 00000000 00003ae2 00000000
Aug 17 21:27:10 ubuntu kernel: [26639.204128] Call Trace:
Aug 17 21:27:10 ubuntu kernel: [26639.204138]  [<c1042993>] ?
refrigerator+0x72/0xdb
Aug 17 21:27:10 ubuntu kernel: [26639.204150]  [<c10429e5>]
refrigerator+0xc4/0xdb
Aug 17 21:27:10 ubuntu kernel: [26639.204159]  [<c1035b74>]
try_to_freeze+0x19/0x20
Aug 17 21:27:10 ubuntu kernel: [26639.204168]  [<c10371f0>]
get_signal_to_deliver+0x36/0x32e
Aug 17 21:27:10 ubuntu kernel: [26639.204178]  [<c1001fcd>]
do_notify_resume+0x77/0x735
Aug 17 21:27:10 ubuntu kernel: [26639.204187]  [<c1157a57>] ?
file_has_perm+0x87/0xa1
Aug 17 21:27:10 ubuntu kernel: [26639.204198]  [<c103ccb5>] ?
autoremove_wake_function+0x0/0x2f
Aug 17 21:27:10 ubuntu kernel: [26639.204209]  [<c1094538>] ?
fsnotify_access+0x4f/0x5a
Aug 17 21:27:10 ubuntu kernel: [26639.204219]  [<c109478e>] ?
do_sync_read+0x0/0xe4
Aug 17 21:27:10 ubuntu kernel: [26639.204227]  [<c1094e82>] ? vfs_read+0x9d/0xdc
Aug 17 21:27:10 ubuntu kernel: [26639.204236]  [<c10a0e1a>] ? sys_poll+0x42/0x8b
Aug 17 21:27:10 ubuntu kernel: [26639.204246]  [<c1002d96>]
work_notifysig+0x13/0x19
Aug 17 21:27:10 ubuntu kernel: [26639.204254] evolution-dat D 00001835
 2080  4838      1 0x00000000
Aug 17 21:27:10 ubuntu kernel: [26639.204267]  cea65e8c 00000046
c16c8191 00001835 c1042993 d4414b34 c1689a00 00003ee2
Aug 17 21:27:10 ubuntu kernel: [26639.204288]  c1685eb8 c1689a00
d4414b34 c1689a00 c13f6b10 00787ac3 c2c99eb8 00000001
Aug 17 21:27:10 ubuntu kernel: [26639.204309]  c16c8191 00001835
d44148a0 00000078 00000000 00000000 00003ee2 00000000
Aug 17 21:27:10 ubuntu kernel: [26639.204329] Call Trace:
Aug 17 21:27:10 ubuntu kernel: [26639.204338]  [<c1042993>] ?
refrigerator+0x72/0xdb
Aug 17 21:27:10 ubuntu kernel: [26639.204350]  [<c10429e5>]
refrigerator+0xc4/0xdb
Aug 17 21:27:10 ubuntu kernel: [26639.204360]  [<c1035b74>]
try_to_freeze+0x19/0x20
Aug 17 21:27:10 ubuntu kernel: [26639.204368]  [<c10371f0>]
get_signal_to_deliver+0x36/0x32e
Aug 17 21:27:10 ubuntu kernel: [26639.204378]  [<c1001fcd>]
do_notify_resume+0x77/0x735
Aug 17 21:27:10 ubuntu kernel: [26639.204388]  [<c1157a57>] ?
file_has_perm+0x87/0xa1
Aug 17 21:27:10 ubuntu kernel: [26639.204399]  [<c103ccb5>] ?
autoremove_wake_function+0x0/0x2f
Aug 17 21:27:10 ubuntu kernel: [26639.204409]  [<c1094592>] ?
fsnotify_modify+0x4f/0x5a
Aug 17 21:27:10 ubuntu kernel: [26639.204419]  [<c10946aa>] ?
do_sync_write+0x0/0xe4
Aug 17 21:27:10 ubuntu kernel: [26639.204427]  [<c1094cf0>] ?
vfs_write+0xa0/0xdf
Aug 17 21:27:10 ubuntu kernel: [26639.204437]  [<c10a0e1a>] ? sys_poll+0x42/0x8b
Aug 17 21:27:10 ubuntu kernel: [26639.204446]  [<c1002d96>]
work_notifysig+0x13/0x19
Aug 17 21:27:10 ubuntu kernel: [26639.204454] evolution-dat D 00001835
 2340  4852      1 0x00000000
Aug 17 21:27:10 ubuntu kernel: [26639.204468]  ce373e8c 00000046
c159f962 00001835 c1042993 e41b40d4 c1689a00 00000046
Aug 17 21:27:10 ubuntu kernel: [26639.204489]  c1685eb8 c1689a00
e41b40d4 c1689a00 c1042993 00000007 e41b3e40 c13ee6c2
Aug 17 21:27:10 ubuntu kernel: [26639.204509]  c1520643 00001835
e41b3e40 de4a2604 00000002 ce373e80 c104a803 00000000
Aug 17 21:27:10 ubuntu kernel: [26639.204530] Call Trace:
Aug 17 21:27:10 ubuntu kernel: [26639.204539]  [<c1042993>] ?
refrigerator+0x72/0xdb
Aug 17 21:27:10 ubuntu kernel: [26639.204549]  [<c1042993>] ?
refrigerator+0x72/0xdb
Aug 17 21:27:10 ubuntu kernel: [26639.204559]  [<c13ee6c2>] ?
_spin_unlock_irq+0x22/0x45
Aug 17 21:27:10 ubuntu kernel: [26639.204569]  [<c104a803>] ?
trace_hardirqs_on+0xb/0xd
Aug 17 21:27:10 ubuntu kernel: [26639.204578]  [<c10429e5>]
refrigerator+0xc4/0xdb
Aug 17 21:27:10 ubuntu kernel: [26639.204588]  [<c1035b74>]
try_to_freeze+0x19/0x20
Aug 17 21:27:10 ubuntu kernel: [26639.204597]  [<c10371f0>]
get_signal_to_deliver+0x36/0x32e
Aug 17 21:27:10 ubuntu kernel: [26639.204607]  [<c1001fcd>]
do_notify_resume+0x77/0x735
Aug 17 21:27:10 ubuntu kernel: [26639.204616]  [<c1157a57>] ?
file_has_perm+0x87/0xa1
Aug 17 21:27:10 ubuntu kernel: [26639.204627]  [<c103ccb5>] ?
autoremove_wake_function+0x0/0x2f
Aug 17 21:27:10 ubuntu kernel: [26639.204638]  [<c1094592>] ?
fsnotify_modify+0x4f/0x5a
Aug 17 21:27:10 ubuntu kernel: [26639.204648]  [<c104f07c>] ?
sys_futex+0xe1/0xf5
Aug 17 21:27:10 ubuntu kernel: [26639.204658]  [<c10a0e1a>] ? sys_poll+0x42/0x8b
Aug 17 21:27:10 ubuntu kernel: [26639.204667]  [<c1002d96>]
work_notifysig+0x13/0x19
Aug 17 21:27:10 ubuntu kernel: [26639.204675] evolution-exc D 00001835
 2096  4842      1 0x00000000
Aug 17 21:27:10 ubuntu kernel: [26639.204689]  ce139e8c 00000046
c16b7fb0 00001835 c1042993 d7c32c14 c1689a00 000042e2
Aug 17 21:27:10 ubuntu kernel: [26639.204709]  c1685eb8 c1689a00
d7c32c14 c1689a00 c13f6b10 00787ac3 c2c99eb8 00000001
Aug 17 21:27:10 ubuntu kernel: [26639.204730]  c16b7fb0 00001835
d7c32980 00000078 00000000 00000000 000042e2 00000000
Aug 17 21:27:10 ubuntu kernel: [26639.204751] Call Trace:
Aug 17 21:27:10 ubuntu kernel: [26639.204760]  [<c1042993>] ?
refrigerator+0x72/0xdb
Aug 17 21:27:10 ubuntu kernel: [26639.204772]  [<c10429e5>]
refrigerator+0xc4/0xdb
Aug 17 21:27:10 ubuntu kernel: [26639.204781]  [<c1035b74>]
try_to_freeze+0x19/0x20
Aug 17 21:27:10 ubuntu kernel: [26639.204790]  [<c10371f0>]
get_signal_to_deliver+0x36/0x32e
Aug 17 21:27:10 ubuntu kernel: [26639.204800]  [<c1001fcd>]
do_notify_resume+0x77/0x735
Aug 17 21:27:10 ubuntu kernel: [26639.204809]  [<c1157a57>] ?
file_has_perm+0x87/0xa1
Aug 17 21:27:10 ubuntu kernel: [26639.204820]  [<c103ccb5>] ?
autoremove_wake_function+0x0/0x2f
Aug 17 21:27:10 ubuntu kernel: [26639.204831]  [<c1157ce4>] ?
selinux_file_permission+0x44/0x48
Aug 17 21:27:10 ubuntu kernel: [26639.204854]  [<c1154346>] ?
security_file_permission+0xf/0x11
Aug 17 21:27:10 ubuntu kernel: [26639.204868]  [<c109490a>] ?
rw_verify_area+0x98/0xbb
Aug 17 21:27:10 ubuntu kernel: [26639.204882]  [<c1094e70>] ? vfs_read+0x8b/0xdc
Aug 17 21:27:10 ubuntu kernel: [26639.204898]  [<c10a0e1a>] ? sys_poll+0x42/0x8b
Aug 17 21:27:10 ubuntu kernel: [26639.204911]  [<c1002d96>]
work_notifysig+0x13/0x19
Aug 17 21:27:10 ubuntu kernel: [26639.204919] evolution-exc D 00001835
 2340  4844      1 0x00000000
Aug 17 21:27:10 ubuntu kernel: [26639.204932]  ce146e8c 00000046
c16ac4fe 00001835 c1042993 d4415594 c1689a00 000044e2
Aug 17 21:27:10 ubuntu kernel: [26639.204953]  c1685eb8 c1689a00
d4415594 c1689a00 c13f6b10 00787ac3 c2c99eb8 00000001
Aug 17 21:27:10 ubuntu kernel: [26639.204974]  c16ac4fe 00001835
d4415300 00000078 00000000 00000000 000044e2 00000000
Aug 17 21:27:10 ubuntu kernel: [26639.204995] Call Trace:
Aug 17 21:27:10 ubuntu kernel: [26639.205004]  [<c1042993>] ?
refrigerator+0x72/0xdb
Aug 17 21:27:10 ubuntu kernel: [26639.205016]  [<c10429e5>]
refrigerator+0xc4/0xdb
Aug 17 21:27:10 ubuntu kernel: [26639.205026]  [<c1035b74>]
try_to_freeze+0x19/0x20
Aug 17 21:27:10 ubuntu kernel: [26639.205034]  [<c10371f0>]
get_signal_to_deliver+0x36/0x32e
Aug 17 21:27:10 ubuntu kernel: [26639.205045]  [<c1001fcd>]
do_notify_resume+0x77/0x735
Aug 17 21:27:10 ubuntu kernel: [26639.205054]  [<c1157a57>] ?
file_has_perm+0x87/0xa1
Aug 17 21:27:10 ubuntu kernel: [26639.205065]  [<c103ccb5>] ?
autoremove_wake_function+0x0/0x2f
Aug 17 21:27:10 ubuntu kernel: [26639.205076]  [<c1094592>] ?
fsnotify_modify+0x4f/0x5a
Aug 17 21:27:10 ubuntu kernel: [26639.205085]  [<c10946aa>] ?
do_sync_write+0x0/0xe4
Aug 17 21:27:10 ubuntu kernel: [26639.205094]  [<c1094cf0>] ?
vfs_write+0xa0/0xdf
Aug 17 21:27:10 ubuntu kernel: [26639.205103]  [<c10a0e1a>] ? sys_poll+0x42/0x8b
Aug 17 21:27:10 ubuntu kernel: [26639.205113]  [<c1002d96>]
work_notifysig+0x13/0x19
Aug 17 21:27:10 ubuntu kernel: [26639.205121] hald          D 00001835
 2080  5929      1 0x00000000
Aug 17 21:27:10 ubuntu kernel: [26639.205134]  c7705e8c 00000046
c169d931 00001835 c1042993 d4416a54 c1689a00 000048e2
Aug 17 21:27:10 ubuntu kernel: [26639.205155]  c1685eb8 c1689a00
d4416a54 c1689a00 c13f6b10 00787ac3 c2c99eb8 00000001
Aug 17 21:27:10 ubuntu kernel: [26639.205176]  c169d931 00001835
d44167c0 00000078 00000000 00000000 000048e2 00000000
Aug 17 21:27:10 ubuntu kernel: [26639.205197] Call Trace:
Aug 17 21:27:10 ubuntu kernel: [26639.205206]  [<c1042993>] ?
refrigerator+0x72/0xdb
Aug 17 21:27:10 ubuntu kernel: [26639.205218]  [<c10429e5>]
refrigerator+0xc4/0xdb
Aug 17 21:27:10 ubuntu kernel: [26639.205227]  [<c1035b74>]
try_to_freeze+0x19/0x20
Aug 17 21:27:10 ubuntu kernel: [26639.205236]  [<c10371f0>]
get_signal_to_deliver+0x36/0x32e
Aug 17 21:27:10 ubuntu kernel: [26639.205246]  [<c1001fcd>]
do_notify_resume+0x77/0x735
Aug 17 21:27:10 ubuntu kernel: [26639.205257]  [<c107e7e3>] ?
might_fault+0x4b/0x88
Aug 17 21:27:10 ubuntu kernel: [26639.205267]  [<c1043079>] ?
clocksource_read+0x9/0xc
Aug 17 21:27:10 ubuntu kernel: [26639.205276]  [<c1043382>] ?
getnstimeofday+0x4d/0xd7
Aug 17 21:27:10 ubuntu kernel: [26639.205287]  [<c10a0e1a>] ? sys_poll+0x42/0x8b
Aug 17 21:27:10 ubuntu kernel: [26639.205297]  [<c1002d96>]
work_notifysig+0x13/0x19
Aug 17 21:27:10 ubuntu kernel: [26639.205304] hald-runner   D 00001835
 2220  5930   5929 0x00000000
Aug 17 21:27:10 ubuntu kernel: [26639.205318]  ec4fae8c 00000046
c16862bd 00001835 c1042993 d4410cf4 c1689a00 000052e2
Aug 17 21:27:10 ubuntu kernel: [26639.205339]  c1685eb8 c1689a00
d4410cf4 c1689a00 c13f6b10 00787ac3 c2c99eb8 00000001
Aug 17 21:27:10 ubuntu kernel: [26639.205360]  c16862bd 00001835
d4410a60 00000078 00000000 00000000 000052e2 00000000
Aug 17 21:27:10 ubuntu kernel: [26639.205380] Call Trace:
Aug 17 21:27:10 ubuntu kernel: [26639.205389]  [<c1042993>] ?
refrigerator+0x72/0xdb
Aug 17 21:27:10 ubuntu kernel: [26639.205401]  [<c10429e5>]
refrigerator+0xc4/0xdb
Aug 17 21:27:10 ubuntu kernel: [26639.205411]  [<c1035b74>]
try_to_freeze+0x19/0x20
Aug 17 21:27:10 ubuntu kernel: [26639.205419]  [<c10371f0>]
get_signal_to_deliver+0x36/0x32e
Aug 17 21:27:10 ubuntu kernel: [26639.205429]  [<c1001fcd>]
do_notify_resume+0x77/0x735
Aug 17 21:27:10 ubuntu kernel: [26639.205439]  [<c101dbe2>] ?
kunmap_atomic+0x64/0x7a
Aug 17 21:27:10 ubuntu kernel: [26639.205449]  [<c1080f3a>] ?
do_wp_page+0x553/0x5d4
Aug 17 21:27:10 ubuntu kernel: [26639.205458]  [<c108193e>] ?
handle_mm_fault+0x65c/0x705
Aug 17 21:27:10 ubuntu kernel: [26639.205471]  [<c10a0e1a>] ? sys_poll+0x42/0x8b
Aug 17 21:27:10 ubuntu kernel: [26639.205480]  [<c1002d96>]
work_notifysig+0x13/0x19
Aug 17 21:27:10 ubuntu kernel: [26639.205488] hald-addon-rf D 00001835
 2340  5970   5930 0x00000000
Aug 17 21:27:10 ubuntu kernel: [26639.205501]  c533fe8c 00000046
c15a3dd1 00001835 c1042993 e2792c14 c1689a00 00000046
Aug 17 21:27:10 ubuntu kernel: [26639.205522]  c1685eb8 c1689a00
e2792c14 c1689a00 c1042993 00000007 e2792980 c13ee6c2
Aug 17 21:27:10 ubuntu kernel: [26639.205543]  c15269e0 00001835
e2792980 de4a6d84 00000002 c533fe80 c104a803 00000000
Aug 17 21:27:10 ubuntu kernel: [26639.205564] Call Trace:
Aug 17 21:27:10 ubuntu kernel: [26639.205573]  [<c1042993>] ?
refrigerator+0x72/0xdb
Aug 17 21:27:10 ubuntu kernel: [26639.205583]  [<c1042993>] ?
refrigerator+0x72/0xdb
Aug 17 21:27:10 ubuntu kernel: [26639.205592]  [<c13ee6c2>] ?
_spin_unlock_irq+0x22/0x45
Aug 17 21:27:10 ubuntu kernel: [26639.205602]  [<c104a803>] ?
trace_hardirqs_on+0xb/0xd
Aug 17 21:27:10 ubuntu kernel: [26639.205612]  [<c10429e5>]
refrigerator+0xc4/0xdb
Aug 17 21:27:10 ubuntu kernel: [26639.205622]  [<c1035b74>]
try_to_freeze+0x19/0x20
Aug 17 21:27:10 ubuntu kernel: [26639.205631]  [<c10371f0>]
get_signal_to_deliver+0x36/0x32e
Aug 17 21:27:10 ubuntu kernel: [26639.205641]  [<c1001fcd>]
do_notify_resume+0x77/0x735
Aug 17 21:27:10 ubuntu kernel: [26639.205651]  [<c1094592>] ?
fsnotify_modify+0x4f/0x5a
Aug 17 21:27:10 ubuntu kernel: [26639.205661]  [<c10952f9>] ?
do_readv_writev+0xd2/0xdf
Aug 17 21:27:10 ubuntu kernel: [26639.205671]  [<c1157ce4>] ?
selinux_file_permission+0x44/0x48
Aug 17 21:27:10 ubuntu kernel: [26639.205680]  [<c1154346>] ?
security_file_permission+0xf/0x11
Aug 17 21:27:10 ubuntu kernel: [26639.205689]  [<c109490a>] ?
rw_verify_area+0x98/0xbb
Aug 17 21:27:10 ubuntu kernel: [26639.205700]  [<c10a0e1a>] ? sys_poll+0x42/0x8b
Aug 17 21:27:10 ubuntu kernel: [26639.205709]  [<c1002d96>]
work_notifysig+0x13/0x19
Aug 17 21:27:10 ubuntu kernel: [26639.205717] hald-addon-le D 00001835
 2220  5971   5930 0x00000000
Aug 17 21:27:10 ubuntu kernel: [26639.205731]  c5294e8c 00000046
c167ce72 00001835 c1042993 e45974b4 c1689a00 000058e2
Aug 17 21:27:10 ubuntu kernel: [26639.205752]  c1685eb8 c1689a00
e45974b4 c1689a00 c13f6b10 00787ac3 c2c99eb8 00000001
Aug 17 21:27:10 ubuntu kernel: [26639.205772]  c167ce72 00001835
e4597220 00000078 00000000 00000000 000058e2 00000000
Aug 17 21:27:10 ubuntu kernel: [26639.205793] Call Trace:
Aug 17 21:27:10 ubuntu kernel: [26639.205802]  [<c1042993>] ?
refrigerator+0x72/0xdb
Aug 17 21:27:10 ubuntu kernel: [26639.205814]  [<c10429e5>]
refrigerator+0xc4/0xdb
Aug 17 21:27:10 ubuntu kernel: [26639.205824]  [<c1035b74>]
try_to_freeze+0x19/0x20
Aug 17 21:27:10 ubuntu kernel: [26639.205832]  [<c10371f0>]
get_signal_to_deliver+0x36/0x32e
Aug 17 21:27:10 ubuntu kernel: [26639.205843]  [<c1001fcd>]
do_notify_resume+0x77/0x735
Aug 17 21:27:10 ubuntu kernel: [26639.205852]  [<c1094592>] ?
fsnotify_modify+0x4f/0x5a
Aug 17 21:27:10 ubuntu kernel: [26639.205862]  [<c10952f9>] ?
do_readv_writev+0xd2/0xdf
Aug 17 21:27:10 ubuntu kernel: [26639.205872]  [<c1157ce4>] ?
selinux_file_permission+0x44/0x48
Aug 17 21:27:10 ubuntu kernel: [26639.205882]  [<c1154346>] ?
security_file_permission+0xf/0x11
Aug 17 21:27:10 ubuntu kernel: [26639.205891]  [<c109490a>] ?
rw_verify_area+0x98/0xbb
Aug 17 21:27:10 ubuntu kernel: [26639.205902]  [<c10a0e1a>] ? sys_poll+0x42/0x8b
Aug 17 21:27:10 ubuntu kernel: [26639.205911]  [<c1002d96>]
work_notifysig+0x13/0x19
Aug 17 21:27:10 ubuntu kernel: [26639.205919] hald-addon-ge D 00001835
 2220  5981   5930 0x00000000
Aug 17 21:27:10 ubuntu kernel: [26639.205932]  c7ad4e8c 00000046
c16723ae 00001835 c1042993 c7900294 c1689a00 00005ce2
Aug 17 21:27:10 ubuntu kernel: [26639.205953]  c1685eb8 c1689a00
c7900294 c1689a00 c13f6b10 00787ac3 c2c99eb8 00000001
Aug 17 21:27:10 ubuntu kernel: [26639.205974]  c16723ae 00001835
c7900000 00000078 00000000 00000000 00005ce2 00000000
Aug 17 21:27:10 ubuntu kernel: [26639.205995] Call Trace:
Aug 17 21:27:10 ubuntu kernel: [26639.206004]  [<c1042993>] ?
refrigerator+0x72/0xdb
Aug 17 21:27:10 ubuntu kernel: [26639.206016]  [<c10429e5>]
refrigerator+0xc4/0xdb
Aug 17 21:27:10 ubuntu kernel: [26639.206025]  [<c1035b74>]
try_to_freeze+0x19/0x20
Aug 17 21:27:10 ubuntu kernel: [26639.206034]  [<c10371f0>]
get_signal_to_deliver+0x36/0x32e
Aug 17 21:27:10 ubuntu kernel: [26639.206044]  [<c1001fcd>]
do_notify_resume+0x77/0x735
Aug 17 21:27:10 ubuntu kernel: [26639.206054]  [<c106f98b>] ?
unlock_page+0x47/0x4a
Aug 17 21:27:10 ubuntu kernel: [26639.206063]  [<c10812b6>] ?
__do_fault+0x2fb/0x327
Aug 17 21:27:10 ubuntu kernel: [26639.206076]  [<c10a0e1a>] ? sys_poll+0x42/0x8b
Aug 17 21:27:10 ubuntu kernel: [26639.206086]  [<c1002d96>]
work_notifysig+0x13/0x19
Aug 17 21:27:10 ubuntu kernel: [26639.206093] hald-addon-in D 00001835
 2056  5996   5930 0x00000000
Aug 17 21:27:10 ubuntu kernel: [26639.206107]  c7ab4e8c 00000046
c15ae6af 00001835 c1042993 c796a1b4 c1689a00 00000046
Aug 17 21:27:10 ubuntu kernel: [26639.206128]  c1685eb8 c1689a00
c796a1b4 c1689a00 c1042993 00000007 c7969f20 c13ee6c2
Aug 17 21:27:10 ubuntu kernel: [26639.206149]  c15291e6 00001835
c7969f20 ee403104 00000002 c7ab4e80 c104a803 00000000
Aug 17 21:27:10 ubuntu kernel: [26639.206169] Call Trace:
Aug 17 21:27:10 ubuntu kernel: [26639.206178]  [<c1042993>] ?
refrigerator+0x72/0xdb
Aug 17 21:27:10 ubuntu kernel: [26639.206188]  [<c1042993>] ?
refrigerator+0x72/0xdb
Aug 17 21:27:10 ubuntu kernel: [26639.206198]  [<c13ee6c2>] ?
_spin_unlock_irq+0x22/0x45
Aug 17 21:27:10 ubuntu kernel: [26639.206208]  [<c104a803>] ?
trace_hardirqs_on+0xb/0xd
Aug 17 21:27:10 ubuntu kernel: [26639.206218]  [<c10429e5>]
refrigerator+0xc4/0xdb
Aug 17 21:27:10 ubuntu kernel: [26639.206227]  [<c1035b74>]
try_to_freeze+0x19/0x20
Aug 17 21:27:10 ubuntu kernel: [26639.206236]  [<c10371f0>]
get_signal_to_deliver+0x36/0x32e
Aug 17 21:27:10 ubuntu kernel: [26639.206246]  [<c1001fcd>]
do_notify_resume+0x77/0x735
Aug 17 21:27:10 ubuntu kernel: [26639.206255]  [<c1157a57>] ?
file_has_perm+0x87/0xa1
Aug 17 21:27:10 ubuntu kernel: [26639.206268]  [<c1154346>] ?
security_file_permission+0xf/0x11
Aug 17 21:27:10 ubuntu kernel: [26639.206277]  [<c109490a>] ?
rw_verify_area+0x98/0xbb
Aug 17 21:27:10 ubuntu kernel: [26639.206288]  [<c129747a>] ?
evdev_read+0x0/0x18e
Aug 17 21:27:10 ubuntu kernel: [26639.206297]  [<c1094e62>] ? vfs_read+0x7d/0xdc
Aug 17 21:27:10 ubuntu kernel: [26639.206306]  [<c10a0e1a>] ? sys_poll+0x42/0x8b
Aug 17 21:27:10 ubuntu kernel: [26639.206316]  [<c1002d96>]
work_notifysig+0x13/0x19
Aug 17 21:27:10 ubuntu kernel: [26639.206323] hald-addon-cp D 00001835
 2340  6008   5930 0x00000000
Aug 17 21:27:10 ubuntu kernel: [26639.206337]  c7a96e8c 00000046
c15b2fab 00001835 c1042993 c79074b4 c1689a00 00000046
Aug 17 21:27:10 ubuntu kernel: [26639.206358]  c1685eb8 c1689a00
c79074b4 c1689a00 c1042993 00000007 c7907220 c13ee6c2
Aug 17 21:27:10 ubuntu kernel: [26639.206379]  c152b691 00001835
c7907220 df3edd04 00000002 c7a96e80 c104a803 00000000
Aug 17 21:27:10 ubuntu kernel: [26639.206399] Call Trace:
Aug 17 21:27:10 ubuntu kernel: [26639.206409]  [<c1042993>] ?
refrigerator+0x72/0xdb
Aug 17 21:27:10 ubuntu kernel: [26639.206419]  [<c1042993>] ?
refrigerator+0x72/0xdb
Aug 17 21:27:10 ubuntu kernel: [26639.206428]  [<c13ee6c2>] ?
_spin_unlock_irq+0x22/0x45
Aug 17 21:27:10 ubuntu kernel: [26639.206438]  [<c104a803>] ?
trace_hardirqs_on+0xb/0xd
Aug 17 21:27:11 ubuntu kernel: [26639.206448]  [<c10429e5>]
refrigerator+0xc4/0xdb
Aug 17 21:27:11 ubuntu kernel: [26639.206458]  [<c1035b74>]
try_to_freeze+0x19/0x20
Aug 17 21:27:11 ubuntu kernel: [26639.206466]  [<c10371f0>]
get_signal_to_deliver+0x36/0x32e
Aug 17 21:27:11 ubuntu kernel: [26639.206477]  [<c1001fcd>]
do_notify_resume+0x77/0x735
Aug 17 21:27:11 ubuntu kernel: [26639.206486]  [<c106f98b>] ?
unlock_page+0x47/0x4a
Aug 17 21:27:11 ubuntu kernel: [26639.206496]  [<c10812b6>] ?
__do_fault+0x2fb/0x327
Aug 17 21:27:11 ubuntu kernel: [26639.206508]  [<c10a0e1a>] ? sys_poll+0x42/0x8b
Aug 17 21:27:11 ubuntu kernel: [26639.206518]  [<c1002d96>]
work_notifysig+0x13/0x19
Aug 17 21:27:11 ubuntu kernel: [26639.206526] hald-addon-ac D 00001835
 2340  6009   5930 0x00000000
Aug 17 21:27:11 ubuntu kernel: [26639.206539]  c533de8c 00000046
c15b7d71 00001835 c1042993 ee206a54 c1689a00 00000046
Aug 17 21:27:11 ubuntu kernel: [26639.206560]  c1685eb8 c1689a00
ee206a54 c1689a00 c1042993 00000007 ee2067c0 c13ee6c2
Aug 17 21:27:11 ubuntu kernel: [26639.206581]  c152db84 00001835
ee2067c0 df3ee804 00000002 c533de80 c104a803 00000000
Aug 17 21:27:11 ubuntu kernel: [26639.206602] Call Trace:
Aug 17 21:27:11 ubuntu kernel: [26639.206611]  [<c1042993>] ?
refrigerator+0x72/0xdb
Aug 17 21:27:11 ubuntu kernel: [26639.206621]  [<c1042993>] ?
refrigerator+0x72/0xdb
Aug 17 21:27:11 ubuntu kernel: [26639.206630]  [<c13ee6c2>] ?
_spin_unlock_irq+0x22/0x45
Aug 17 21:27:11 ubuntu kernel: [26639.206640]  [<c104a803>] ?
trace_hardirqs_on+0xb/0xd
Aug 17 21:27:11 ubuntu kernel: [26639.206650]  [<c10429e5>]
refrigerator+0xc4/0xdb
Aug 17 21:27:11 ubuntu kernel: [26639.206660]  [<c1035b74>]
try_to_freeze+0x19/0x20
Aug 17 21:27:11 ubuntu kernel: [26639.206668]  [<c10371f0>]
get_signal_to_deliver+0x36/0x32e
Aug 17 21:27:11 ubuntu kernel: [26639.206679]  [<c1001fcd>]
do_notify_resume+0x77/0x735
Aug 17 21:27:11 ubuntu kernel: [26639.206688]  [<c1157a57>] ?
file_has_perm+0x87/0xa1
Aug 17 21:27:11 ubuntu kernel: [26639.206699]  [<c103ccb5>] ?
autoremove_wake_function+0x0/0x2f
Aug 17 21:27:11 ubuntu kernel: [26639.206709]  [<c1157ce4>] ?
selinux_file_permission+0x44/0x48
Aug 17 21:27:11 ubuntu kernel: [26639.206719]  [<c1154346>] ?
security_file_permission+0xf/0x11
Aug 17 21:27:11 ubuntu kernel: [26639.206728]  [<c109490a>] ?
rw_verify_area+0x98/0xbb
Aug 17 21:27:11 ubuntu kernel: [26639.206738]  [<c1094e70>] ? vfs_read+0x8b/0xdc
Aug 17 21:27:11 ubuntu kernel: [26639.206747]  [<c1094f6d>] ? sys_read+0x53/0x5d
Aug 17 21:27:11 ubuntu kernel: [26639.206756]  [<c1002d96>]
work_notifysig+0x13/0x19
Aug 17 21:27:11 ubuntu kernel: [26639.206764] monodevelop   D 00001835
 2512 10709   3763 0x00000000
Aug 17 21:27:11 ubuntu kernel: [26639.206778]  ea09de8c 00200046
c15bde43 00001835 c1042993 c7969754 c1689a00 00200046
Aug 17 21:27:11 ubuntu kernel: [26639.206799]  c1685eb8 c1689a00
c7969754 c1689a00 c1042993 00000007 c79694c0 c13ee6c2
Aug 17 21:27:11 ubuntu kernel: [26639.206820]  c15347ed 00001835
c79694c0 de4a0a84 00000002 ea09de80 c104a803 00000000
Aug 17 21:27:11 ubuntu kernel: [26639.206840] Call Trace:
Aug 17 21:27:11 ubuntu kernel: [26639.206849]  [<c1042993>] ?
refrigerator+0x72/0xdb
Aug 17 21:27:11 ubuntu kernel: [26639.206859]  [<c1042993>] ?
refrigerator+0x72/0xdb
Aug 17 21:27:11 ubuntu kernel: [26639.206869]  [<c13ee6c2>] ?
_spin_unlock_irq+0x22/0x45
Aug 17 21:27:11 ubuntu kernel: [26639.206879]  [<c104a803>] ?
trace_hardirqs_on+0xb/0xd
Aug 17 21:27:11 ubuntu kernel: [26639.206889]  [<c10429e5>]
refrigerator+0xc4/0xdb
Aug 17 21:27:11 ubuntu kernel: [26639.206898]  [<c1035b74>]
try_to_freeze+0x19/0x20
Aug 17 21:27:11 ubuntu kernel: [26639.206907]  [<c10371f0>]
get_signal_to_deliver+0x36/0x32e
Aug 17 21:27:11 ubuntu kernel: [26639.206917]  [<c1001fcd>]
do_notify_resume+0x77/0x735
Aug 17 21:27:11 ubuntu kernel: [26639.206927]  [<c103cec4>] ?
remove_wait_queue+0xf/0x27
Aug 17 21:27:11 ubuntu kernel: [26639.206936]  [<c13ee67b>] ?
_spin_unlock_irqrestore+0x36/0x5b
Aug 17 21:27:11 ubuntu kernel: [26639.206946]  [<c104a7d0>] ?
trace_hardirqs_on_caller+0x108/0x130
Aug 17 21:27:11 ubuntu kernel: [26639.206956]  [<c104a803>] ?
trace_hardirqs_on+0xb/0xd
Aug 17 21:27:11 ubuntu kernel: [26639.206965]  [<c13ee693>] ?
_spin_unlock_irqrestore+0x4e/0x5b
Aug 17 21:27:11 ubuntu kernel: [26639.206975]  [<c103ced7>] ?
remove_wait_queue+0x22/0x27
Aug 17 21:27:11 ubuntu kernel: [26639.206985]  [<c102e8e1>] ?
do_wait+0x1d9/0x290
Aug 17 21:27:11 ubuntu kernel: [26639.206994]  [<c10252f5>] ?
default_wake_function+0x0/0xd
Aug 17 21:27:11 ubuntu kernel: [26639.207004]  [<c102ea2c>] ?
sys_wait4+0x94/0xa1
Aug 17 21:27:11 ubuntu kernel: [26639.207015]  [<c1002d96>]
work_notifysig+0x13/0x19
Aug 17 21:27:11 ubuntu kernel: [26639.207022] monodevelop   D 00001835
 2056 10737  10709 0x00000008
Aug 17 21:27:11 ubuntu kernel: [26639.207036]  f2305e8c 00000046
c1607aa0 00001835 c1042993 c796f4b4 c1689a00 000086e2
Aug 17 21:27:11 ubuntu kernel: [26639.207057]  c1685eb8 c1689a00
c796f4b4 c1689a00 c13f6b10 00787ac3 c2c99eb8 00000001
Aug 17 21:27:11 ubuntu kernel: [26639.207078]  c1607aa0 00001835
c796f220 00000078 00000000 00000000 000086e2 00000000
Aug 17 21:27:11 ubuntu kernel: [26639.207098] Call Trace:
Aug 17 21:27:11 ubuntu kernel: [26639.207108]  [<c1042993>] ?
refrigerator+0x72/0xdb
Aug 17 21:27:11 ubuntu kernel: [26639.207119]  [<c10429e5>]
refrigerator+0xc4/0xdb
Aug 17 21:27:11 ubuntu kernel: [26639.207129]  [<c1035b74>]
try_to_freeze+0x19/0x20
Aug 17 21:27:11 ubuntu kernel: [26639.207138]  [<c10371f0>]
get_signal_to_deliver+0x36/0x32e
Aug 17 21:27:11 ubuntu kernel: [26639.207148]  [<c1001fcd>]
do_notify_resume+0x77/0x735
Aug 17 21:27:11 ubuntu kernel: [26639.207157]  [<c1094592>] ?
fsnotify_modify+0x4f/0x5a
Aug 17 21:27:11 ubuntu kernel: [26639.207167]  [<c10952f9>] ?
do_readv_writev+0xd2/0xdf
Aug 17 21:27:11 ubuntu kernel: [26639.207177]  [<c1095813>] ?
__rcu_read_lock+0x0/0x2b
Aug 17 21:27:11 ubuntu kernel: [26639.207188]  [<c10a0e1a>] ? sys_poll+0x42/0x8b
Aug 17 21:27:11 ubuntu kernel: [26639.207198]  [<c1002d96>]
work_notifysig+0x13/0x19
Aug 17 21:27:11 ubuntu kernel: [26639.207205] mono          D 00001835
 2580 10739  10709 0x00000000
Aug 17 21:27:11 ubuntu kernel: [26639.207219]  ed175e8c 00200046
c166975d 00001835 c1042993 c7968294 c1689a00 000060e2
Aug 17 21:27:11 ubuntu kernel: [26639.207240]  c1685eb8 c1689a00
c7968294 c1689a00 c13f6b10 00787ac3 c2c99eb8 00000001
Aug 17 21:27:11 ubuntu kernel: [26639.207261]  c166975d 00001835
c7968000 00000078 00000000 00000000 000060e2 00000000
Aug 17 21:27:11 ubuntu kernel: [26639.207282] Call Trace:
Aug 17 21:27:11 ubuntu kernel: [26639.207291]  [<c1042993>] ?
refrigerator+0x72/0xdb
Aug 17 21:27:11 ubuntu kernel: [26639.207302]  [<c10429e5>]
refrigerator+0xc4/0xdb
Aug 17 21:27:11 ubuntu kernel: [26639.207312]  [<c1035b74>]
try_to_freeze+0x19/0x20
Aug 17 21:27:11 ubuntu kernel: [26639.207321]  [<c10371f0>]
get_signal_to_deliver+0x36/0x32e
Aug 17 21:27:11 ubuntu kernel: [26639.207331]  [<c1001fcd>]
do_notify_resume+0x77/0x735
Aug 17 21:27:11 ubuntu kernel: [26639.207379]  [<c118b78a>] ?
free_object+0x6e/0x81
Aug 17 21:27:11 ubuntu kernel: [26639.207390]  [<c103f087>] ?
destroy_hrtimer_on_stack+0xd/0xf
Aug 17 21:27:11 ubuntu kernel: [26639.207399]  [<c103fcdb>] ?
hrtimer_nanosleep+0xcb/0xe6
Aug 17 21:27:11 ubuntu kernel: [26639.207409]  [<c107e7e3>] ?
might_fault+0x4b/0x88
Aug 17 21:27:11 ubuntu kernel: [26639.207418]  [<c103f35c>] ?
hrtimer_wakeup+0x0/0x1c
Aug 17 21:27:11 ubuntu kernel: [26639.207430]  [<c1002d96>]
work_notifysig+0x13/0x19
Aug 17 21:27:11 ubuntu kernel: [26639.207438] mono          D 00001835
 2428 10740  10709 0x00000000
Aug 17 21:27:11 ubuntu kernel: [26639.207452]  eb699e8c 00200046
c15c2024 00001835 c1042993 c796d594 c1689a00 00200046
Aug 17 21:27:11 ubuntu kernel: [26639.207473]  c1685eb8 c1689a00
c796d594 c1689a00 c1042993 00000007 c796d300 c13ee6c2
Aug 17 21:27:11 ubuntu kernel: [26639.207494]  c144d75e 00001835
c796d300 de4a3104 00000002 eb699e80 c104a803 00000000
Aug 17 21:27:11 ubuntu kernel: [26639.207514] Call Trace:
Aug 17 21:27:11 ubuntu kernel: [26639.207524]  [<c1042993>] ?
refrigerator+0x72/0xdb
Aug 17 21:27:11 ubuntu kernel: [26639.207534]  [<c1042993>] ?
refrigerator+0x72/0xdb
Aug 17 21:27:11 ubuntu kernel: [26639.207543]  [<c13ee6c2>] ?
_spin_unlock_irq+0x22/0x45
Aug 17 21:27:11 ubuntu kernel: [26639.207553]  [<c104a803>] ?
trace_hardirqs_on+0xb/0xd
Aug 17 21:27:11 ubuntu kernel: [26639.207563]  [<c10429e5>]
refrigerator+0xc4/0xdb
Aug 17 21:27:11 ubuntu kernel: [26639.207573]  [<c1035b74>]
try_to_freeze+0x19/0x20
Aug 17 21:27:11 ubuntu kernel: [26639.207581]  [<c10371f0>]
get_signal_to_deliver+0x36/0x32e
Aug 17 21:27:11 ubuntu kernel: [26639.207592]  [<c1001fcd>]
do_notify_resume+0x77/0x735
Aug 17 21:27:11 ubuntu kernel: [26639.207601]  [<c1157a57>] ?
file_has_perm+0x87/0xa1
Aug 17 21:27:11 ubuntu kernel: [26639.207612]  [<c103ccb5>] ?
autoremove_wake_function+0x0/0x2f
Aug 17 21:27:11 ubuntu kernel: [26639.207623]  [<c1094592>] ?
fsnotify_modify+0x4f/0x5a
Aug 17 21:27:11 ubuntu kernel: [26639.207633]  [<c104f07c>] ?
sys_futex+0xe1/0xf5
Aug 17 21:27:11 ubuntu kernel: [26639.207642]  [<c1002bfa>] ?
sysenter_exit+0xf/0x1a
Aug 17 21:27:11 ubuntu kernel: [26639.207651]  [<c104a7d0>] ?
trace_hardirqs_on_caller+0x108/0x130
Aug 17 21:27:11 ubuntu kernel: [26639.207661]  [<c1002d96>]
work_notifysig+0x13/0x19
Aug 17 21:27:11 ubuntu kernel: [26639.207669] monodevelop   D 00001835
 2824 10818  10709 0x00000000
Aug 17 21:27:11 ubuntu kernel: [26639.207683]  eb669e8c 00200046
c1544eb0 00001835 eb669e4c c796b674 c1689a00 de4a3104
Aug 17 21:27:11 ubuntu kernel: [26639.207704]  c1685eb8 c1689a00
c796b674 c1689a00 eb669e70 00000007 c796b3e0 c13ee6c2
Aug 17 21:27:11 ubuntu kernel: [26639.207725]  c15402be 00001835
c796b3e0 de4a3104 00000002 eb669e80 c104a803 00000000
Aug 17 21:27:11 ubuntu kernel: [26639.207745] Call Trace:
Aug 17 21:27:11 ubuntu kernel: [26639.207756]  [<c13ee6c2>] ?
_spin_unlock_irq+0x22/0x45
Aug 17 21:27:11 ubuntu kernel: [26639.207766]  [<c104a803>] ?
trace_hardirqs_on+0xb/0xd
Aug 17 21:27:11 ubuntu kernel: [26639.207776]  [<c10429e5>]
refrigerator+0xc4/0xdb
Aug 17 21:27:11 ubuntu kernel: [26639.207785]  [<c1035b74>]
try_to_freeze+0x19/0x20
Aug 17 21:27:11 ubuntu kernel: [26639.207794]  [<c10371f0>]
get_signal_to_deliver+0x36/0x32e
Aug 17 21:27:11 ubuntu kernel: [26639.207804]  [<c1001fcd>]
do_notify_resume+0x77/0x735
Aug 17 21:27:11 ubuntu kernel: [26639.207814]  [<c118b78a>] ?
free_object+0x6e/0x81
Aug 17 21:27:11 ubuntu kernel: [26639.207824]  [<c103f087>] ?
destroy_hrtimer_on_stack+0xd/0xf
Aug 17 21:27:11 ubuntu kernel: [26639.207834]  [<c103fcdb>] ?
hrtimer_nanosleep+0xcb/0xe6
Aug 17 21:27:11 ubuntu kernel: [26639.207843]  [<c107e7e3>] ?
might_fault+0x4b/0x88
Aug 17 21:27:11 ubuntu kernel: [26639.207852]  [<c103f35c>] ?
hrtimer_wakeup+0x0/0x1c
Aug 17 21:27:11 ubuntu kernel: [26639.207863]  [<c1002d96>]
work_notifysig+0x13/0x19
Aug 17 21:27:11 ubuntu kernel: [26639.207871] monodevelop   D 00001835
 2624 10852  10709 0x00000000
Aug 17 21:27:11 ubuntu kernel: [26639.207885]  efcb3e8c 00200046
c1660642 00001835 c1042993 c796cb34 c1689a00 000064e2
Aug 17 21:27:11 ubuntu kernel: [26639.207906]  c1685eb8 c1689a00
c796cb34 c1689a00 c13f6b10 00787ac3 c2c99eb8 00000001
Aug 17 21:27:11 ubuntu kernel: [26639.207927]  c1660642 00001835
c796c8a0 00000078 00000000 00000000 000064e2 00000000
Aug 17 21:27:11 ubuntu kernel: [26639.207947] Call Trace:
Aug 17 21:27:11 ubuntu kernel: [26639.207956]  [<c1042993>] ?
refrigerator+0x72/0xdb
Aug 17 21:27:11 ubuntu kernel: [26639.207968]  [<c10429e5>]
refrigerator+0xc4/0xdb
Aug 17 21:27:11 ubuntu kernel: [26639.207978]  [<c1035b74>]
try_to_freeze+0x19/0x20
Aug 17 21:27:11 ubuntu kernel: [26639.207987]  [<c10371f0>]
get_signal_to_deliver+0x36/0x32e
Aug 17 21:27:11 ubuntu kernel: [26639.207997]  [<c1001fcd>]
do_notify_resume+0x77/0x735
Aug 17 21:27:11 ubuntu kernel: [26639.208006]  [<c118b78a>] ?
free_object+0x6e/0x81
Aug 17 21:27:11 ubuntu kernel: [26639.208017]  [<c103f087>] ?
destroy_hrtimer_on_stack+0xd/0xf
Aug 17 21:27:11 ubuntu kernel: [26639.208026]  [<c103fcdb>] ?
hrtimer_nanosleep+0xcb/0xe6
Aug 17 21:27:11 ubuntu kernel: [26639.208035]  [<c107e7e3>] ?
might_fault+0x4b/0x88
Aug 17 21:27:11 ubuntu kernel: [26639.208044]  [<c103f35c>] ?
hrtimer_wakeup+0x0/0x1c
Aug 17 21:27:11 ubuntu kernel: [26639.208056]  [<c1002d96>]
work_notifysig+0x13/0x19
Aug 17 21:27:11 ubuntu kernel: [26639.208063] monodevelop   D 00001835
 2620 10861  10709 0x00000000
Aug 17 21:27:11 ubuntu kernel: [26639.208077]  efcb1e8c 00200046
c1655f4b 00001835 c1042993 c796c0d4 c1689a00 000068e2
Aug 17 21:27:11 ubuntu kernel: [26639.208098]  c1685eb8 c1689a00
c796c0d4 c1689a00 c13f6b10 00787ac3 c2c99eb8 00000001
Aug 17 21:27:11 ubuntu kernel: [26639.208119]  c1655f4b 00001835
c796be40 00000078 00000000 00000000 000068e2 00000000
Aug 17 21:27:11 ubuntu kernel: [26639.208139] Call Trace:
Aug 17 21:27:11 ubuntu kernel: [26639.208149]  [<c1655f4b>] ?
ip_auto_config+0x7c6/0xcc9
Aug 17 21:27:11 ubuntu kernel: [26639.208159]  [<c1042993>] ?
refrigerator+0x72/0xdb
Aug 17 21:27:11 ubuntu kernel: [26639.208169]  [<c1655f4b>] ?
ip_auto_config+0x7c6/0xcc9
Aug 17 21:27:11 ubuntu kernel: [26639.208195]  [<c10429e5>]
refrigerator+0xc4/0xdb
Aug 17 21:27:11 ubuntu kernel: [26639.208209]  [<c1035b74>]
try_to_freeze+0x19/0x20
Aug 17 21:27:11 ubuntu kernel: [26639.208222]  [<c10371f0>]
get_signal_to_deliver+0x36/0x32e
Aug 17 21:27:11 ubuntu kernel: [26639.208237]  [<c1001fcd>]
do_notify_resume+0x77/0x735
Aug 17 21:27:11 ubuntu kernel: [26639.208254]  [<c100a01d>] ?
restore_i387_xstate+0x16c/0x1a3
Aug 17 21:27:11 ubuntu kernel: [26639.208265]  [<c104f07c>] ?
sys_futex+0xe1/0xf5
Aug 17 21:27:11 ubuntu kernel: [26639.208274]  [<c1002ce7>] ?
restore_all_notrace+0x0/0x18
Aug 17 21:27:11 ubuntu kernel: [26639.208284]  [<c104a7d0>] ?
trace_hardirqs_on_caller+0x108/0x130
Aug 17 21:27:11 ubuntu kernel: [26639.208294]  [<c1002d96>]
work_notifysig+0x13/0x19
Aug 17 21:27:11 ubuntu kernel: [26639.208302] monodevelop   D 00001835
 2220 10863  10709 0x00000000
Aug 17 21:27:11 ubuntu kernel: [26639.208315]  c586ae8c 00200046
c164d949 00001835 c1042993 c796dff4 c1689a00 00006ee2
Aug 17 21:27:11 ubuntu kernel: [26639.208336]  c1685eb8 c1689a00
c796dff4 c1689a00 c13f6b10 00787ac3 c2c99eb8 00000001
Aug 17 21:27:11 ubuntu kernel: [26639.208357]  c164d949 00001835
c796dd60 00000078 00000000 00000000 00006ee2 00000000
Aug 17 21:27:11 ubuntu kernel: [26639.208378] Call Trace:
Aug 17 21:27:11 ubuntu kernel: [26639.208387]  [<c164d949>] ?
i8042_init+0x3a/0x344
Aug 17 21:27:11 ubuntu kernel: [26639.208397]  [<c1042993>] ?
refrigerator+0x72/0xdb
Aug 17 21:27:11 ubuntu kernel: [26639.208407]  [<c164d949>] ?
i8042_init+0x3a/0x344
Aug 17 21:27:11 ubuntu kernel: [26639.208417]  [<c10429e5>]
refrigerator+0xc4/0xdb
Aug 17 21:27:11 ubuntu kernel: [26639.208427]  [<c1035b74>]
try_to_freeze+0x19/0x20
Aug 17 21:27:11 ubuntu kernel: [26639.208436]  [<c10371f0>]
get_signal_to_deliver+0x36/0x32e
Aug 17 21:27:11 ubuntu kernel: [26639.208445]  [<c107e7e3>] ?
might_fault+0x4b/0x88
Aug 17 21:27:11 ubuntu kernel: [26639.208454]  [<c1001fcd>]
do_notify_resume+0x77/0x735
Aug 17 21:27:11 ubuntu kernel: [26639.208465]  [<c107e7e3>] ?
might_fault+0x4b/0x88
Aug 17 21:27:11 ubuntu kernel: [26639.208474]  [<c107e7e3>] ?
might_fault+0x4b/0x88
Aug 17 21:27:11 ubuntu kernel: [26639.208484]  [<c131281a>] ?
sys_socketcall+0x169/0x185
Aug 17 21:27:11 ubuntu kernel: [26639.208494]  [<c10a0e1a>] ? sys_poll+0x42/0x8b
Aug 17 21:27:11 ubuntu kernel: [26639.208503]  [<c1002d96>]
work_notifysig+0x13/0x19
Aug 17 21:27:11 ubuntu kernel: [26639.208511] monodevelop   D 00001835
 2636 10864  10709 0x00000000
Aug 17 21:27:12 ubuntu kernel: [26639.208525]  f53f5e8c 00200046
c154ada1 00001835 f53f5e4c c7906a54 c1689a00 de4a3104
Aug 17 21:27:12 ubuntu kernel: [26639.208546]  c1685eb8 c1689a00
c7906a54 c1689a00 f53f5e70 00000007 c79067c0 c13ee6c2
Aug 17 21:27:12 ubuntu kernel: [26639.208567]  c1546294 00001835
c79067c0 de4a3104 00000002 f53f5e80 c104a803 00000000
Aug 17 21:27:12 ubuntu kernel: [26639.208587] Call Trace:
Aug 17 21:27:12 ubuntu kernel: [26639.208598]  [<c13ee6c2>] ?
_spin_unlock_irq+0x22/0x45
Aug 17 21:27:12 ubuntu kernel: [26639.208608]  [<c104a803>] ?
trace_hardirqs_on+0xb/0xd
Aug 17 21:27:12 ubuntu kernel: [26639.208618]  [<c10429e5>]
refrigerator+0xc4/0xdb
Aug 17 21:27:12 ubuntu kernel: [26639.208627]  [<c1035b74>]
try_to_freeze+0x19/0x20
Aug 17 21:27:12 ubuntu kernel: [26639.208636]  [<c10371f0>]
get_signal_to_deliver+0x36/0x32e
Aug 17 21:27:12 ubuntu kernel: [26639.208645]  [<c107e7e3>] ?
might_fault+0x4b/0x88
Aug 17 21:27:12 ubuntu kernel: [26639.208655]  [<c1001fcd>]
do_notify_resume+0x77/0x735
Aug 17 21:27:12 ubuntu kernel: [26639.208665]  [<c107e7e3>] ?
might_fault+0x4b/0x88
Aug 17 21:27:12 ubuntu kernel: [26639.208674]  [<c1043079>] ?
clocksource_read+0x9/0xc
Aug 17 21:27:12 ubuntu kernel: [26639.208684]  [<c1043382>] ?
getnstimeofday+0x4d/0xd7
Aug 17 21:27:12 ubuntu kernel: [26639.208694]  [<c103fd87>] ?
ktime_get_ts+0x40/0x44
Aug 17 21:27:12 ubuntu kernel: [26639.208703]  [<c104f07c>] ?
sys_futex+0xe1/0xf5
Aug 17 21:27:12 ubuntu kernel: [26639.208713]  [<c1002bfa>] ?
sysenter_exit+0xf/0x1a
Aug 17 21:27:12 ubuntu kernel: [26639.208723]  [<c1002d96>]
work_notifysig+0x13/0x19
Aug 17 21:27:12 ubuntu kernel: [26639.208730] monodevelop   D 00001835
 2704 10867  10709 0x00000000
Aug 17 21:27:12 ubuntu kernel: [26639.208744]  e38e7e8c 00200046
c16422e2 00001835 c1042993 ec5221b4 c1689a00 000072e2
Aug 17 21:27:12 ubuntu kernel: [26639.208765]  c1685eb8 c1689a00
ec5221b4 c1689a00 c13f6b10 00787ac3 c2c99eb8 00000001
Aug 17 21:27:12 ubuntu kernel: [26639.208786]  c16422e2 00001835
ec521f20 00000078 00000000 00000000 000072e2 00000000
Aug 17 21:27:12 ubuntu kernel: [26639.208806] Call Trace:
Aug 17 21:27:12 ubuntu kernel: [26639.208816]  [<c16422e2>] ?
journal_init+0xa5/0xcb
Aug 17 21:27:12 ubuntu kernel: [26639.208825]  [<c1042993>] ?
refrigerator+0x72/0xdb
Aug 17 21:27:12 ubuntu kernel: [26639.208835]  [<c16422e2>] ?
journal_init+0xa5/0xcb
Aug 17 21:27:12 ubuntu kernel: [26639.208845]  [<c10429e5>]
refrigerator+0xc4/0xdb
Aug 17 21:27:12 ubuntu kernel: [26639.208855]  [<c1035b74>]
try_to_freeze+0x19/0x20
Aug 17 21:27:12 ubuntu kernel: [26639.208864]  [<c10371f0>]
get_signal_to_deliver+0x36/0x32e
Aug 17 21:27:12 ubuntu kernel: [26639.208874]  [<c1001fcd>]
do_notify_resume+0x77/0x735
Aug 17 21:27:12 ubuntu kernel: [26639.208885]  [<c100a01d>] ?
restore_i387_xstate+0x16c/0x1a3
Aug 17 21:27:12 ubuntu kernel: [26639.208896]  [<c104f07c>] ?
sys_futex+0xe1/0xf5
Aug 17 21:27:12 ubuntu kernel: [26639.208906]  [<c1002ce7>] ?
restore_all_notrace+0x0/0x18
Aug 17 21:27:12 ubuntu kernel: [26639.208915]  [<c104a7d0>] ?
trace_hardirqs_on_caller+0x108/0x130
Aug 17 21:27:12 ubuntu kernel: [26639.208925]  [<c1002d96>]
work_notifysig+0x13/0x19
Aug 17 21:27:12 ubuntu kernel: [26639.208933] monodevelop   D 00001835
 2824 10869  10709 0x00000000
Aug 17 21:27:12 ubuntu kernel: [26639.208947]  e3b99e8c 00200046
c154e3a3 00001835 c1042993 c7905594 c1689a00 00200046
Aug 17 21:27:12 ubuntu kernel: [26639.208968]  c1685eb8 c1689a00
c7905594 c1689a00 c1042993 00000007 c7905300 c13ee6c2
Aug 17 21:27:12 ubuntu kernel: [26639.208989]  c154bf5d 00001835
c7905300 de4a3104 00000002 e3b99e80 c104a803 00000000
Aug 17 21:27:12 ubuntu kernel: [26639.209009] Call Trace:
Aug 17 21:27:12 ubuntu kernel: [26639.209018]  [<c1042993>] ?
refrigerator+0x72/0xdb
Aug 17 21:27:12 ubuntu kernel: [26639.209028]  [<c1042993>] ?
refrigerator+0x72/0xdb
Aug 17 21:27:12 ubuntu kernel: [26639.209038]  [<c13ee6c2>] ?
_spin_unlock_irq+0x22/0x45
Aug 17 21:27:12 ubuntu kernel: [26639.209048]  [<c104a803>] ?
trace_hardirqs_on+0xb/0xd
Aug 17 21:27:12 ubuntu kernel: [26639.209057]  [<c10429e5>]
refrigerator+0xc4/0xdb
Aug 17 21:27:12 ubuntu kernel: [26639.209067]  [<c1035b74>]
try_to_freeze+0x19/0x20
Aug 17 21:27:12 ubuntu kernel: [26639.209076]  [<c10371f0>]
get_signal_to_deliver+0x36/0x32e
Aug 17 21:27:12 ubuntu kernel: [26639.209085]  [<c1020716>] ?
need_resched+0x14/0x1e
Aug 17 21:27:12 ubuntu kernel: [26639.209094]  [<c1001fcd>]
do_notify_resume+0x77/0x735
Aug 17 21:27:12 ubuntu kernel: [26639.209106]  [<c10b956f>] ?
sys_epoll_wait+0x152/0x1dc
Aug 17 21:27:12 ubuntu kernel: [26639.209116]  [<c10b956f>] ?
sys_epoll_wait+0x152/0x1dc
Aug 17 21:27:12 ubuntu kernel: [26639.209125]  [<c13ee67b>] ?
_spin_unlock_irqrestore+0x36/0x5b
Aug 17 21:27:12 ubuntu kernel: [26639.209135]  [<c104a7d0>] ?
trace_hardirqs_on_caller+0x108/0x130
Aug 17 21:27:12 ubuntu kernel: [26639.209145]  [<c104a803>] ?
trace_hardirqs_on+0xb/0xd
Aug 17 21:27:12 ubuntu kernel: [26639.209154]  [<c13ee693>] ?
_spin_unlock_irqrestore+0x4e/0x5b
Aug 17 21:27:12 ubuntu kernel: [26639.209164]  [<c10b95ef>] ?
sys_epoll_wait+0x1d2/0x1dc
Aug 17 21:27:12 ubuntu kernel: [26639.209173]  [<c10252f5>] ?
default_wake_function+0x0/0xd
Aug 17 21:27:12 ubuntu kernel: [26639.209183]  [<c1002d96>]
work_notifysig+0x13/0x19
Aug 17 21:27:12 ubuntu kernel: [26639.209191] monodevelop   D 00001835
 2824 10871  10709 0x00000000
Aug 17 21:27:12 ubuntu kernel: [26639.209205]  f2713e8c 00200046
c163993d 00001835 c1042993 ec521754 c1689a00 000076e2
Aug 17 21:27:12 ubuntu kernel: [26639.209226]  c1685eb8 c1689a00
ec521754 c1689a00 c13f6b10 00787ac3 c2c99eb8 00000001
Aug 17 21:27:12 ubuntu kernel: [26639.209247]  c163993d 00001835
ec5214c0 00000078 00000000 00000000 000076e2 00000000
Aug 17 21:27:12 ubuntu kernel: [26639.209267] Call Trace:
Aug 17 21:27:12 ubuntu kernel: [26639.209277]  [<c163993d>] ?
setup_early_printk+0x117/0x66d
Aug 17 21:27:12 ubuntu kernel: [26639.209287]  [<c1042993>] ?
refrigerator+0x72/0xdb
Aug 17 21:27:12 ubuntu kernel: [26639.209298]  [<c163993d>] ?
setup_early_printk+0x117/0x66d
Aug 17 21:27:12 ubuntu kernel: [26639.209309]  [<c10429e5>]
refrigerator+0xc4/0xdb
Aug 17 21:27:12 ubuntu kernel: [26639.209318]  [<c1035b74>]
try_to_freeze+0x19/0x20
Aug 17 21:27:12 ubuntu kernel: [26639.209327]  [<c10371f0>]
get_signal_to_deliver+0x36/0x32e
Aug 17 21:27:12 ubuntu kernel: [26639.209337]  [<c1001fcd>]
do_notify_resume+0x77/0x735
Aug 17 21:27:12 ubuntu kernel: [26639.209347]  [<c104bac2>] ?
__lock_acquire+0xad3/0xae2
Aug 17 21:27:12 ubuntu kernel: [26639.209357]  [<c107e7e3>] ?
might_fault+0x4b/0x88
Aug 17 21:27:12 ubuntu kernel: [26639.209366]  [<c107e7e3>] ?
might_fault+0x4b/0x88
Aug 17 21:27:12 ubuntu kernel: [26639.209376]  [<c131282c>] ?
sys_socketcall+0x17b/0x185
Aug 17 21:27:12 ubuntu kernel: [26639.209387]  [<c1002d96>]
work_notifysig+0x13/0x19
Aug 17 21:27:12 ubuntu kernel: [26639.209394] monodevelop   D 00001835
 2692 10872  10709 0x00000000
Aug 17 21:27:12 ubuntu kernel: [26639.209408]  f2714e8c 00200046
c1552ba3 00001835 f2714e4c d44174b4 c1689a00 de4a3104
Aug 17 21:27:12 ubuntu kernel: [26639.209429]  c1685eb8 c1689a00
d44174b4 c1689a00 f2714e70 00000007 d4417220 c13ee6c2
Aug 17 21:27:12 ubuntu kernel: [26639.209450]  c155098c 00001835
d4417220 de4a3104 00000002 f2714e80 c104a803 00000000
Aug 17 21:27:12 ubuntu kernel: [26639.209471] Call Trace:
Aug 17 21:27:12 ubuntu kernel: [26639.209481]  [<c13ee6c2>] ?
_spin_unlock_irq+0x22/0x45
Aug 17 21:27:12 ubuntu kernel: [26639.209491]  [<c104a803>] ?
trace_hardirqs_on+0xb/0xd
Aug 17 21:27:12 ubuntu kernel: [26639.209501]  [<c10429e5>]
refrigerator+0xc4/0xdb
Aug 17 21:27:12 ubuntu kernel: [26639.209511]  [<c1035b74>]
try_to_freeze+0x19/0x20
Aug 17 21:27:12 ubuntu kernel: [26639.209519]  [<c10371f0>]
get_signal_to_deliver+0x36/0x32e
Aug 17 21:27:12 ubuntu kernel: [26639.209530]  [<c1001fcd>]
do_notify_resume+0x77/0x735
Aug 17 21:27:12 ubuntu kernel: [26639.209541]  [<c100a01d>] ?
restore_i387_xstate+0x16c/0x1a3
Aug 17 21:27:12 ubuntu kernel: [26639.209552]  [<c104f07c>] ?
sys_futex+0xe1/0xf5
Aug 17 21:27:12 ubuntu kernel: [26639.209562]  [<c1002ce7>] ?
restore_all_notrace+0x0/0x18
Aug 17 21:27:12 ubuntu kernel: [26639.209571]  [<c104a7d0>] ?
trace_hardirqs_on_caller+0x108/0x130
Aug 17 21:27:12 ubuntu kernel: [26639.209581]  [<c1002d96>]
work_notifysig+0x13/0x19
Aug 17 21:27:12 ubuntu kernel: [26639.209589] monodevelop   D 00001835
 2824 10880  10709 0x00000000
Aug 17 21:27:12 ubuntu kernel: [26639.209603]  ec8a9e8c 00200046
c1620035 00001835 c1042993 d4412c14 c1689a00 00007ae2
Aug 17 21:27:12 ubuntu kernel: [26639.209624]  c1685eb8 c1689a00
d4412c14 c1689a00 c13f6b10 00787ac3 c2c99eb8 00000001
Aug 17 21:27:12 ubuntu kernel: [26639.209645]  c1620035 00001835
d4412980 00000078 00000000 00000000 00007ae2 00000000
Aug 17 21:27:12 ubuntu kernel: [26639.209665] Call Trace:
Aug 17 21:27:12 ubuntu kernel: [26639.209674]  [<c1042993>] ?
refrigerator+0x72/0xdb
Aug 17 21:27:12 ubuntu kernel: [26639.209686]  [<c10429e5>]
refrigerator+0xc4/0xdb
Aug 17 21:27:12 ubuntu kernel: [26639.209695]  [<c1035b74>]
try_to_freeze+0x19/0x20
Aug 17 21:27:12 ubuntu kernel: [26639.209704]  [<c10371f0>]
get_signal_to_deliver+0x36/0x32e
Aug 17 21:27:12 ubuntu kernel: [26639.209714]  [<c1001fcd>]
do_notify_resume+0x77/0x735
Aug 17 21:27:12 ubuntu kernel: [26639.209724]  [<c118b78a>] ?
free_object+0x6e/0x81
Aug 17 21:27:12 ubuntu kernel: [26639.209734]  [<c103f087>] ?
destroy_hrtimer_on_stack+0xd/0xf
Aug 17 21:27:12 ubuntu kernel: [26639.209743]  [<c103fcdb>] ?
hrtimer_nanosleep+0xcb/0xe6
Aug 17 21:27:12 ubuntu kernel: [26639.209752]  [<c107e7e3>] ?
might_fault+0x4b/0x88
Aug 17 21:27:12 ubuntu kernel: [26639.209762]  [<c103f35c>] ?
hrtimer_wakeup+0x0/0x1c
Aug 17 21:27:12 ubuntu kernel: [26639.209773]  [<c1002d96>]
work_notifysig+0x13/0x19
Aug 17 21:27:12 ubuntu kernel: [26639.209781] monodevelop   D 00001835
 2824 10892  10709 0x00000000
Aug 17 21:27:12 ubuntu kernel: [26639.209795]  f20c8e8c 00200046
c1555e3d 00001835 c1042993 d7c30cf4 c1689a00 00200046
Aug 17 21:27:12 ubuntu kernel: [26639.209816]  c1685eb8 c1689a00
d7c30cf4 c1689a00 c1042993 00000007 d7c30a60 c13ee6c2
Aug 17 21:27:12 ubuntu kernel: [26639.209837]  c141f51e 00001835
d7c30a60 de4a3104 00000002 f20c8e80 c104a803 00000000
Aug 17 21:27:12 ubuntu kernel: [26639.209857] Call Trace:
Aug 17 21:27:12 ubuntu kernel: [26639.209866]  [<c1042993>] ?
refrigerator+0x72/0xdb
Aug 17 21:27:12 ubuntu kernel: [26639.209876]  [<c1042993>] ?
refrigerator+0x72/0xdb
Aug 17 21:27:12 ubuntu kernel: [26639.209886]  [<c13ee6c2>] ?
_spin_unlock_irq+0x22/0x45
Aug 17 21:27:12 ubuntu kernel: [26639.209896]  [<c104a803>] ?
trace_hardirqs_on+0xb/0xd
Aug 17 21:27:12 ubuntu kernel: [26639.209905]  [<c10429e5>]
refrigerator+0xc4/0xdb
Aug 17 21:27:12 ubuntu kernel: [26639.209915]  [<c1035b74>]
try_to_freeze+0x19/0x20
Aug 17 21:27:12 ubuntu kernel: [26639.209924]  [<c10371f0>]
get_signal_to_deliver+0x36/0x32e
Aug 17 21:27:12 ubuntu kernel: [26639.209934]  [<c1001fcd>]
do_notify_resume+0x77/0x735
Aug 17 21:27:12 ubuntu kernel: [26639.209945]  [<c100a01d>] ?
restore_i387_xstate+0x16c/0x1a3
Aug 17 21:27:12 ubuntu kernel: [26639.209956]  [<c118751e>] ? __delay+0x9/0xb
Aug 17 21:27:12 ubuntu kernel: [26639.209966]  [<c104f07c>] ?
sys_futex+0xe1/0xf5
Aug 17 21:27:12 ubuntu kernel: [26639.209976]  [<c1002ce7>] ?
restore_all_notrace+0x0/0x18
Aug 17 21:27:12 ubuntu kernel: [26639.209985]  [<c104a7d0>] ?
trace_hardirqs_on_caller+0x108/0x130
Aug 17 21:27:12 ubuntu kernel: [26639.209995]  [<c1002d96>]
work_notifysig+0x13/0x19
Aug 17 21:27:12 ubuntu kernel: [26639.210003] tee           D 00001835
 2320 10738  10709 0x00000000
Aug 17 21:27:12 ubuntu kernel: [26639.210016]  f2306e8c 00200046
c16132d0 00001835 c1042993 c796ea54 c1689a00 00007ee2
Aug 17 21:27:12 ubuntu kernel: [26639.210037]  c1685eb8 c1689a00
c796ea54 c1689a00 c13f6b10 00787ac3 c2c99eb8 00000001
Aug 17 21:27:12 ubuntu kernel: [26639.210058]  c16132d0 00001835
c796e7c0 00000078 00000000 00000000 00007ee2 00000000
Aug 17 21:27:12 ubuntu kernel: [26639.210079] Call Trace:
Aug 17 21:27:12 ubuntu kernel: [26639.210088]  [<c1042993>] ?
refrigerator+0x72/0xdb
Aug 17 21:27:12 ubuntu kernel: [26639.210100]  [<c10429e5>]
refrigerator+0xc4/0xdb
Aug 17 21:27:12 ubuntu kernel: [26639.210109]  [<c1035b74>]
try_to_freeze+0x19/0x20
Aug 17 21:27:12 ubuntu kernel: [26639.210118]  [<c10371f0>]
get_signal_to_deliver+0x36/0x32e
Aug 17 21:27:12 ubuntu kernel: [26639.210128]  [<c1001fcd>]
do_notify_resume+0x77/0x735
Aug 17 21:27:12 ubuntu kernel: [26639.210137]  [<c1157a57>] ?
file_has_perm+0x87/0xa1
Aug 17 21:27:12 ubuntu kernel: [26639.210148]  [<c103ccb5>] ?
autoremove_wake_function+0x0/0x2f
Aug 17 21:27:12 ubuntu kernel: [26639.210159]  [<c1157ce4>] ?
selinux_file_permission+0x44/0x48
Aug 17 21:27:12 ubuntu kernel: [26639.210169]  [<c1154346>] ?
security_file_permission+0xf/0x11
Aug 17 21:27:12 ubuntu kernel: [26639.210178]  [<c109490a>] ?
rw_verify_area+0x98/0xbb
Aug 17 21:27:12 ubuntu kernel: [26639.210187]  [<c109478e>] ?
do_sync_read+0x0/0xe4
Aug 17 21:27:12 ubuntu kernel: [26639.210196]  [<c1094e62>] ? vfs_read+0x7d/0xdc
Aug 17 21:27:12 ubuntu kernel: [26639.210205]  [<c1094f6d>] ? sys_read+0x53/0x5d
Aug 17 21:27:12 ubuntu kernel: [26639.210214]  [<c1002d96>]
work_notifysig+0x13/0x19
Aug 17 21:27:12 ubuntu kernel: [26639.210222] pm-suspend    R running
 2188 11103   2819 0x00000000
Aug 17 21:27:12 ubuntu kernel: [26639.210235]  00000000 c14fa05e
c14fa05e 00000000 f30b5e3c df3f5d60 00000000 00000000
Aug 17 21:27:12 ubuntu kernel: [26639.210255]  f30b5e6c c10061b8
00000000 c152b0f7 f30b5e90 c10243bb c1502ca9 0000088c
Aug 17 21:27:12 ubuntu kernel: [26639.210276]  00002b5f 00000b03
00000000 df3f5d60 df3f5d60 f30b5ea4 c1024401 00000001
Aug 17 21:27:12 ubuntu kernel: [26639.210297] Call Trace:
Aug 17 21:27:12 ubuntu kernel: [26639.210307]  [<c10061b8>] ?
show_stack+0x13/0x17
Aug 17 21:27:12 ubuntu kernel: [26639.210317]  [<c10243bb>] ?
sched_show_task+0x9b/0xa5
Aug 17 21:27:12 ubuntu kernel: [26639.210327]  [<c1024401>] ?
show_state_filter+0x3c/0x81
Aug 17 21:27:12 ubuntu kernel: [26639.210337]  [<c10545f3>] ?
try_to_freeze_tasks+0x160/0x227
Aug 17 21:27:12 ubuntu kernel: [26639.210349]  [<c10546d2>] ?
freeze_processes+0x18/0x8e
Aug 17 21:27:12 ubuntu kernel: [26639.210358]  [<c10549ce>] ?
enter_state+0x90/0x114
Aug 17 21:27:12 ubuntu kernel: [26639.210367]  [<c1054221>] ?
state_store+0x93/0xa7
Aug 17 21:27:12 ubuntu kernel: [26639.210376]  [<c105418e>] ?
state_store+0x0/0xa7
Aug 17 21:27:12 ubuntu kernel: [26639.210385]  [<c1182709>] ?
kobj_attr_store+0x16/0x22
Aug 17 21:27:12 ubuntu kernel: [26639.210396]  [<c10d4da5>] ?
sysfs_write_file+0xc0/0xeb
Aug 17 21:27:12 ubuntu kernel: [26639.210406]  [<c10d4ce5>] ?
sysfs_write_file+0x0/0xeb
Aug 17 21:27:12 ubuntu kernel: [26639.210415]  [<c1094cd0>] ?
vfs_write+0x80/0xdf
Aug 17 21:27:12 ubuntu kernel: [26639.210424]  [<c1094dc3>] ?
sys_write+0x3b/0x5d
Aug 17 21:27:12 ubuntu kernel: [26639.210433]  [<c1002bcb>] ?
sysenter_do_call+0x12/0x32
Aug 17 21:27:12 ubuntu kernel: [26639.210441] nm-dispatcher D 00001835
 2220 11225      1 0x00000000
Aug 17 21:27:12 ubuntu kernel: [26639.210454]  eb922e8c 00000046
c155e00b 00001835 c1042993 d44121b4 c1689a00 00000046
Aug 17 21:27:12 ubuntu kernel: [26639.210475]  c1685eb8 c1689a00
d44121b4 c1689a00 c1042993 00000007 d4411f20 c13ee6c2
Aug 17 21:27:12 ubuntu kernel: [26639.210496]  c133802f 00001835
d4411f20 df3ed204 00000002 eb922e80 c104a803 00000000
Aug 17 21:27:12 ubuntu kernel: [26639.210517] Call Trace:
Aug 17 21:27:12 ubuntu kernel: [26639.210526]  [<c1042993>] ?
refrigerator+0x72/0xdb
Aug 17 21:27:12 ubuntu kernel: [26639.210536]  [<c1042993>] ?
refrigerator+0x72/0xdb
Aug 17 21:27:12 ubuntu kernel: [26639.210545]  [<c13ee6c2>] ?
_spin_unlock_irq+0x22/0x45
Aug 17 21:27:12 ubuntu kernel: [26639.210159]  [<c1157ce4>] ?
selinux_file_permission+0x44/0x48
Aug 17 21:27:12 ubuntu kernel: [26639.210169]  [<c1154346>] ?
security_file_permission+0xf/0x11
Aug 17 21:27:12 ubuntu kernel: [26639.210178]  [<c109490a>] ?
rw_verify_area+0x98/0xbb
Aug 17 21:27:12 ubuntu kernel: [26639.210187]  [<c109478e>] ?
do_sync_read+0x0/0xe4
Aug 17 21:27:12 ubuntu kernel: [26639.210196]  [<c1094e62>] ? vfs_read+0x7d/0xdc
Aug 17 21:27:12 ubuntu kernel: [26639.210205]  [<c1094f6d>] ? sys_read+0x53/0x5d
Aug 17 21:27:12 ubuntu kernel: [26639.210214]  [<c1002d96>]
work_notifysig+0x13/0x19
Aug 17 21:27:12 ubuntu kernel: [26639.210222] pm-suspend    R running
 2188 11103   2819 0x00000000
Aug 17 21:27:12 ubuntu kernel: [26639.210235]  00000000 c14fa05e
c14fa05e 00000000 f30b5e3c df3f5d60 00000000 00000000
Aug 17 21:27:12 ubuntu kernel: [26639.210255]  f30b5e6c c10061b8
00000000 c152b0f7 f30b5e90 c10243bb c1502ca9 0000088c
Aug 17 21:27:12 ubuntu kernel: [26639.210276]  00002b5f 00000b03
00000000 df3f5d60 df3f5d60 f30b5ea4 c1024401 00000001
Aug 17 21:27:12 ubuntu kernel: [26639.210297] Call Trace:
Aug 17 21:27:12 ubuntu kernel: [26639.210307]  [<c10061b8>] ?
show_stack+0x13/0x17
Aug 17 21:27:12 ubuntu kernel: [26639.210317]  [<c10243bb>] ?
sched_show_task+0x9b/0xa5
Aug 17 21:27:12 ubuntu kernel: [26639.210327]  [<c1024401>] ?
show_state_filter+0x3c/0x81
Aug 17 21:27:12 ubuntu kernel: [26639.210337]  [<c10545f3>] ?
try_to_freeze_tasks+0x160/0x227
Aug 17 21:27:12 ubuntu kernel: [26639.210349]  [<c10546d2>] ?
freeze_processes+0x18/0x8e
Aug 17 21:27:12 ubuntu kernel: [26639.210358]  [<c10549ce>] ?
enter_state+0x90/0x114
Aug 17 21:27:12 ubuntu kernel: [26639.210367]  [<c1054221>] ?
state_store+0x93/0xa7
Aug 17 21:27:12 ubuntu kernel: [26639.210376]  [<c105418e>] ?
state_store+0x0/0xa7
Aug 17 21:27:12 ubuntu kernel: [26639.210385]  [<c1182709>] ?
kobj_attr_store+0x16/0x22
Aug 17 21:27:12 ubuntu kernel: [26639.210396]  [<c10d4da5>] ?
sysfs_write_file+0xc0/0xeb
Aug 17 21:27:12 ubuntu kernel: [26639.210406]  [<c10d4ce5>] ?
sysfs_write_file+0x0/0xeb
Aug 17 21:27:12 ubuntu kernel: [26639.210415]  [<c1094cd0>] ?
vfs_write+0x80/0xdf
Aug 17 21:27:12 ubuntu kernel: [26639.210424]  [<c1094dc3>] ?
sys_write+0x3b/0x5d
Aug 17 21:27:12 ubuntu kernel: [26639.210433]  [<c1002bcb>] ?
sysenter_do_call+0x12/0x32
Aug 17 21:27:12 ubuntu kernel: [26639.210441] nm-dispatcher D 00001835
 2220 11225      1 0x00000000
Aug 17 21:27:12 ubuntu kernel: [26639.210454]  eb922e8c 00000046
c155e00b 00001835 c1042993 d44121b4 c1689a00 00000046
Aug 17 21:27:12 ubuntu kernel: [26639.210475]  c1685eb8 c1689a00
d44121b4 c1689a00 c1042993 00000007 d4411f20 c13ee6c2
Aug 17 21:27:12 ubuntu kernel: [26639.210496]  c133802f 00001835
d4411f20 df3ed204 00000002 eb922e80 c104a803 00000000
Aug 17 21:27:12 ubuntu kernel: [26639.210517] Call Trace:
Aug 17 21:27:12 ubuntu kernel: [26639.210526]  [<c1042993>] ?
refrigerator+0x72/0xdb
Aug 17 21:27:12 ubuntu kernel: [26639.210536]  [<c1042993>] ?
refrigerator+0x72/0xdb
Aug 17 21:27:12 ubuntu kernel: [26639.210545]  [<c13ee6c2>] ?
_spin_unlock_irq+0x22/0x45
Aug 17 21:27:12 ubuntu kernel: [26639.210555]  [<c133802f>] ?
ct_seq_start+0xb5/0xe4
Aug 17 21:27:12 ubuntu kernel: [26639.210565]  [<c104a803>] ?
trace_hardirqs_on+0xb/0xd
Aug 17 21:27:12 ubuntu kernel: [26639.210575]  [<c10429e5>]
refrigerator+0xc4/0xdb
Aug 17 21:27:12 ubuntu kernel: [26639.210584]  [<c1035b74>]
try_to_freeze+0x19/0x20
Aug 17 21:27:12 ubuntu kernel: [26639.210593]  [<c10371f0>]
get_signal_to_deliver+0x36/0x32e
Aug 17 21:27:12 ubuntu kernel: [26639.210602]  [<c107e7e3>] ?
might_fault+0x4b/0x88
Aug 17 21:27:12 ubuntu kernel: [26639.210612]  [<c1001fcd>]
do_notify_resume+0x77/0x735
Aug 17 21:27:12 ubuntu kernel: [26639.210621]  [<c104bac2>] ?
__lock_acquire+0xad3/0xae2
Aug 17 21:27:12 ubuntu kernel: [26639.210631]  [<c107e7e3>] ?
might_fault+0x4b/0x88
Aug 17 21:27:12 ubuntu kernel: [26639.210641]  [<c1043079>] ?
clocksource_read+0x9/0xc
Aug 17 21:27:12 ubuntu kernel: [26639.210651]  [<c1043382>] ?
getnstimeofday+0x4d/0xd7
Aug 17 21:27:12 ubuntu kernel: [26639.210662]  [<c10a0e1a>] ? sys_poll+0x42/0x8b
Aug 17 21:27:12 ubuntu kernel: [26639.210709]  [<c1002d96>]
work_notifysig+0x13/0x19
Aug 17 21:27:12 ubuntu kernel: [26639.211086]  nm-applet
Aug 17 21:27:12 ubuntu kernel: [26639.211360]
Aug 17 21:27:12 ubuntu kernel: [26639.211365] Restarting tasks ... done.
