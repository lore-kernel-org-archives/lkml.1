Return-Path: <linux-kernel-owner+w=401wt.eu-S1757560AbXISXBb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757560AbXISXBb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Sep 2007 19:01:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752612AbXISXBX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Sep 2007 19:01:23 -0400
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:52822 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750990AbXISXBT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Sep 2007 19:01:19 -0400
X-Sasl-enc: LZ0hvTcM3GF35IwnDDOWU7Uw03pK5UjNdtE/WWUPm6XA 1190242874
Message-ID: <46F1AA6E.1030708@imap.cc>
Date: Thu, 20 Sep 2007 01:02:06 +0200
From: Tilman Schmidt <tilman@imap.cc>
Organization: me - organized??
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.0; de-AT; rv:1.8.1.4) Gecko/20070509 SeaMonkey/1.1.2 Mnenhy/0.7.5.666
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: linux-kernel@vger.kernel.org, Greg Kroah-Hartman <gregkh@suse.de>
Subject: Re: 2.6.23-rc6-mm1
References: <20070918011841.2381bd93.akpm@linux-foundation.org>
In-Reply-To: <20070918011841.2381bd93.akpm@linux-foundation.org>
X-Enigmail-Version: 0.95.1
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig420DE9C8462E3CEFB672F964"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig420DE9C8462E3CEFB672F964
Content-Type: multipart/mixed;
 boundary="------------090208080409080002090402"

This is a multi-part message in MIME format.
--------------090208080409080002090402
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

I get several "duplicate file name" messages.
Hope Greg's the right one to cc on these.

<4>[   21.211942] Duplicate file names "rtc" detected. [dump_trace+100/49=
8] dump_trace+0x64/0x1f2
<4>[   21.216801]  [show_trace_log_lvl+26/47] show_trace_log_lvl+0x1a/0x2=
f
<4>[   21.221639]  [show_trace+18/20] show_trace+0x12/0x14
<4>[   21.226307]  [dump_stack+22/24] dump_stack+0x16/0x18
<4>[   21.231063]  [proc_register+315/332] proc_register+0x13b/0x14c
<4>[   21.235814]  [create_proc_entry+114/135] create_proc_entry+0x72/0x8=
7
<4>[   21.240562]  [<faa1d123>] rtc_proc_add_device+0x1d/0x39 [rtc_core]
<4>[   21.245304]  [<faa1c1f9>] rtc_device_register+0x170/0x207 [rtc_core=
]
<4>[   21.250077]  [<faa3c5db>] cmos_do_probe+0x8d/0x1ee [rtc_cmos]
<4>[   21.254715]  [<faa3c77d>] cmos_pnp_probe+0x41/0x44 [rtc_cmos]
<4>[   21.259477]  [pnp_device_probe+102/135] pnp_device_probe+0x66/0x87
<4>[   21.264206]  [driver_probe_device+233/362] driver_probe_device+0xe9=
/0x16a
<4>[   21.268738]  [__driver_attach+108/165] __driver_attach+0x6c/0xa5
<4>[   21.273387]  [bus_for_each_dev+54/91] bus_for_each_dev+0x36/0x5b
<4>[   21.277975]  [driver_attach+25/27] driver_attach+0x19/0x1b
<4>[   21.282501]  [bus_add_driver+115/429] bus_add_driver+0x73/0x1ad
<4>[   21.286984]  [driver_register+103/108] driver_register+0x67/0x6c
<4>[   21.291269]  [pnp_register_driver+23/25] pnp_register_driver+0x17/0=
x19
<4>[   21.295661]  [<faa4000d>] cmos_init+0xd/0xf [rtc_cmos]
<4>[   21.300044]  [sys_init_module+5544/5953] sys_init_module+0x15a8/0x1=
741
<4>[   21.304406]  [sysenter_past_esp+107/181] sysenter_past_esp+0x6b/0xb=
5
<4>[   21.308749]  [phys_startup_32+3085673488/3221225472] 0xb7fba410
<4>[   21.313108]  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D

<4>[   22.699930] sysfs: duplicate filename 'bInterfaceNumber' can not be=
 created
<4>[   22.704755] WARNING: at fs/sysfs/dir.c:433 sysfs_add_one()
<4>[   22.709606]  [dump_trace+100/498] dump_trace+0x64/0x1f2
<4>[   22.714323]  [show_trace_log_lvl+26/47] show_trace_log_lvl+0x1a/0x2=
f
<4>[   22.719203]  [show_trace+18/20] show_trace+0x12/0x14
<4>[   22.724040]  [dump_stack+22/24] dump_stack+0x16/0x18
<4>[   22.728890]  [sysfs_add_one+87/188] sysfs_add_one+0x57/0xbc
<4>[   22.733710]  [sysfs_add_file+73/135] sysfs_add_file+0x49/0x87
<4>[   22.738503]  [sysfs_create_group+138/240] sysfs_create_group+0x8a/0=
xf0
<4>[   22.743272]  [<fa99c20a>] usb_create_sysfs_intf_files+0x2d/0xa2 [us=
bcore]
<4>[   22.748043]  [<fa9989ed>] usb_set_configuration+0x450/0x48d [usbcor=
e]
<4>[   22.752591]  [<fa99fa9b>] generic_probe+0x53/0x94 [usbcore]
<4>[   22.757127]  [<fa99a00b>] usb_probe_device+0x35/0x3b [usbcore]
<4>[   22.761788]  [driver_probe_device+233/362] driver_probe_device+0xe9=
/0x16a
<4>[   22.766444]  [__device_attach+8/10] __device_attach+0x8/0xa
<4>[   22.771053]  [bus_for_each_drv+56/97] bus_for_each_drv+0x38/0x61
<4>[   22.775701]  [device_attach+112/133] device_attach+0x70/0x85
<4>[   22.780304]  [bus_attach_device+41/119] bus_attach_device+0x29/0x77=

<4>[   22.784900]  [device_add+795/1342] device_add+0x31b/0x53e
<4>[   22.789345]  [<fa993de7>] usb_new_device+0x5c/0x168 [usbcore]
<4>[   22.793968]  [<fa9954f9>] hub_thread+0x6b9/0xaa5 [usbcore]
<4>[   22.798452]  [kthread+59/100] kthread+0x3b/0x64
<4>[   22.803076]  [kernel_thread_helper+7/16] kernel_thread_helper+0x7/0=
x10
<4>[   22.807553]  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D

Then hwinfo triggers a few "sleeping function called from invalid context=
"
and "scheduling while atomic" messages of which I cannot make out the sou=
rce.
Greg?

Sep 20 00:05:54 xenon kernel: [   35.006948] hwinfo[4490]: segfault at b7=
dd2f10 eip b7dd2f10 esp bfeac9bc error 4
Sep 20 00:05:54 xenon kernel: [   35.011097] BUG: sleeping function calle=
d from invalid context at kernel/rwsem.c:47
Sep 20 00:05:54 xenon kernel: [   35.015276] in_atomic():1, irqs_disabled=
():0
Sep 20 00:05:54 xenon kernel: [   35.019439] no locks held by hwinfo/4490=
=2E
Sep 20 00:05:54 xenon kernel: [   35.023541]  [<c0108441>] dump_trace+0x6=
4/0x1f2
Sep 20 00:05:54 xenon kernel: [   35.027698]  [<c01085e9>] show_trace_log=
_lvl+0x1a/0x2f
Sep 20 00:05:54 xenon kernel: [   35.032006]  [<c010902b>] show_trace+0x1=
2/0x14
Sep 20 00:05:54 xenon kernel: [   35.036141]  [<c0109154>] dump_stack+0x1=
6/0x18
Sep 20 00:05:54 xenon kernel: [   35.040457]  [<c0123ecd>] __might_sleep+=
0xe5/0xeb
Sep 20 00:05:54 xenon kernel: [   35.044704]  [<c013f72d>] down_write+0x1=
8/0x54
Sep 20 00:05:54 xenon kernel: [   35.048762]  [<c01890d7>] do_coredump+0x=
94/0x77d
Sep 20 00:05:54 xenon kernel: [   35.052974]  [<c0135295>] get_signal_to_=
deliver+0x408/0x434
Sep 20 00:05:54 xenon kernel: [   35.057187]  [<c010673a>] do_notify_resu=
me+0x94/0x6a6
Sep 20 00:05:54 xenon kernel: [   35.061447]  [<c01072e5>] work_notifysig=
+0x13/0x1a
Sep 20 00:05:54 xenon kernel: [   35.065682]  [<b7dd2f10>] 0xb7dd2f10
Sep 20 00:05:54 xenon kernel: [   35.069818]  =3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
Sep 20 00:05:54 xenon kernel: [   35.074064] note: hwinfo[4490] exited wi=
th preempt_count 1
Sep 20 00:05:54 xenon kernel: [   35.078196] BUG: scheduling while atomic=
: hwinfo/4490/0x10000002
Sep 20 00:05:54 xenon kernel: [   35.082295] no locks held by hwinfo/4490=
=2E
Sep 20 00:05:54 xenon kernel: [   35.086568]  [<c0108441>] dump_trace+0x6=
4/0x1f2
Sep 20 00:05:54 xenon kernel: [   35.090883]  [<c01085e9>] show_trace_log=
_lvl+0x1a/0x2f
Sep 20 00:05:54 xenon kernel: [   35.095248]  [<c010902b>] show_trace+0x1=
2/0x14
Sep 20 00:05:54 xenon kernel: [   35.099541]  [<c0109154>] dump_stack+0x1=
6/0x18
Sep 20 00:05:54 xenon kernel: [   35.103861]  [<c012605c>] __schedule_bug=
+0x6e/0x75
Sep 20 00:05:54 xenon kernel: [   35.107854]  [<c030f65b>] __sched_text_s=
tart+0x83/0x59e
Sep 20 00:05:54 xenon kernel: [   35.112041]  [<c0126084>] __cond_resched=
+0x21/0x3b
Sep 20 00:05:54 xenon kernel: [   35.115965]  [<c031003b>] cond_resched+0=
x26/0x31
Sep 20 00:05:54 xenon kernel: [   35.119975]  [<c017059a>] unmap_vmas+0x4=
61/0x580
Sep 20 00:05:54 xenon kernel: [   35.123985]  [<c017351b>] exit_mmap+0x7f=
/0x10f
Sep 20 00:05:54 xenon kernel: [   35.128016]  [<c012807b>] mmput+0x4d/0xc=
b
Sep 20 00:05:54 xenon kernel: [   35.131781]  [<c012bea5>] exit_mm+0xd7/0=
xdc
Sep 20 00:05:54 xenon kernel: [   35.135519]  [<c012d3bb>] do_exit+0x224/=
0x76b
Sep 20 00:05:54 xenon kernel: [   35.139218]  [<c012d972>] sys_exit_group=
+0x0/0x11
Sep 20 00:05:54 xenon kernel: [   35.142903]  [<c013529c>] get_signal_to_=
deliver+0x40f/0x434
Sep 20 00:05:54 xenon kernel: [   35.146582]  [<c010673a>] do_notify_resu=
me+0x94/0x6a6
Sep 20 00:05:54 xenon kernel: [   35.150285]  [<c01072e5>] work_notifysig=
+0x13/0x1a
Sep 20 00:05:54 xenon kernel: [   35.153904]  [<b7dd2f10>] 0xb7dd2f10
Sep 20 00:05:54 xenon kernel: [   35.157444]  =3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
Sep 20 00:05:54 xenon kernel: [   35.161014] BUG: scheduling while atomic=
: hwinfo/4490/0x10000002
Sep 20 00:05:54 xenon kernel: [   35.164507] no locks held by hwinfo/4490=
=2E
Sep 20 00:05:54 xenon kernel: [   35.168011]  [<c0108441>] dump_trace+0x6=
4/0x1f2
Sep 20 00:05:54 xenon kernel: [   35.171522]  [<c01085e9>] show_trace_log=
_lvl+0x1a/0x2f
Sep 20 00:05:54 xenon kernel: [   35.175034]  [<c010902b>] show_trace+0x1=
2/0x14
Sep 20 00:05:54 xenon kernel: [   35.178541]  [<c0109154>] dump_stack+0x1=
6/0x18
Sep 20 00:05:54 xenon kernel: [   35.182055]  [<c012605c>] __schedule_bug=
+0x6e/0x75
Sep 20 00:05:54 xenon kernel: [   35.185571]  [<c030f65b>] __sched_text_s=
tart+0x83/0x59e
Sep 20 00:05:54 xenon kernel: [   35.189077]  [<c0126084>] __cond_resched=
+0x21/0x3b
Sep 20 00:05:54 xenon kernel: [   35.192563]  [<c031003b>] cond_resched+0=
x26/0x31
Sep 20 00:05:54 xenon kernel: [   35.196101]  [<c017059a>] unmap_vmas+0x4=
61/0x580
Sep 20 00:05:54 xenon kernel: [   35.199546]  [<c017351b>] exit_mmap+0x7f=
/0x10f
Sep 20 00:05:54 xenon kernel: [   35.202995]  [<c012807b>] mmput+0x4d/0xc=
b
Sep 20 00:05:54 xenon kernel: [   35.206500]  [<c012bea5>] exit_mm+0xd7/0=
xdc
Sep 20 00:05:54 xenon kernel: [   35.209894]  [<c012d3bb>] do_exit+0x224/=
0x76b
Sep 20 00:05:54 xenon kernel: [   35.213330]  [<c012d972>] sys_exit_group=
+0x0/0x11
Sep 20 00:05:54 xenon kernel: [   35.216680]  [<c013529c>] get_signal_to_=
deliver+0x40f/0x434
Sep 20 00:05:54 xenon kernel: [   35.220103]  [<c010673a>] do_notify_resu=
me+0x94/0x6a6
Sep 20 00:05:54 xenon kernel: [   35.223484]  [<c01072e5>] work_notifysig=
+0x13/0x1a
Sep 20 00:05:54 xenon kernel: [   35.226869]  [<b7dd2f10>] 0xb7dd2f10
Sep 20 00:05:54 xenon kernel: [   35.230247]  =3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
Sep 20 00:05:54 xenon kernel: [   35.233787] BUG: scheduling while atomic=
: hwinfo/4490/0x10000002
Sep 20 00:05:54 xenon kernel: [   35.237071] no locks held by hwinfo/4490=
=2E
Sep 20 00:05:54 xenon kernel: [   35.240305]  [<c0108441>] dump_trace+0x6=
4/0x1f2
Sep 20 00:05:54 xenon kernel: [   35.243567]  [<c01085e9>] show_trace_log=
_lvl+0x1a/0x2f
Sep 20 00:05:54 xenon kernel: [   35.246825]  [<c010902b>] show_trace+0x1=
2/0x14
Sep 20 00:05:54 xenon kernel: [   35.250075]  [<c0109154>] dump_stack+0x1=
6/0x18
Sep 20 00:05:54 xenon kernel: [   35.253366]  [<c012605c>] __schedule_bug=
+0x6e/0x75
Sep 20 00:05:54 xenon kernel: [   35.256631]  [<c030f65b>] __sched_text_s=
tart+0x83/0x59e
Sep 20 00:05:54 xenon kernel: [   35.259895]  [<c0126084>] __cond_resched=
+0x21/0x3b
Sep 20 00:05:54 xenon kernel: [   35.263173]  [<c031003b>] cond_resched+0=
x26/0x31
Sep 20 00:05:54 xenon kernel: [   35.266441]  [<c012c1ff>] put_files_stru=
ct+0x83/0xc0
Sep 20 00:05:54 xenon kernel: [   35.269722]  [<c012d3fc>] do_exit+0x265/=
0x76b
Sep 20 00:05:54 xenon kernel: [   35.272987]  [<c012d972>] sys_exit_group=
+0x0/0x11
Sep 20 00:05:54 xenon kernel: [   35.276248]  [<c013529c>] get_signal_to_=
deliver+0x40f/0x434
Sep 20 00:05:54 xenon kernel: [   35.279545]  [<c010673a>] do_notify_resu=
me+0x94/0x6a6
Sep 20 00:05:54 xenon kernel: [   35.282845]  [<c01072e5>] work_notifysig=
+0x13/0x1a
Sep 20 00:05:54 xenon kernel: [   35.286169]  [<b7dd2f10>] 0xb7dd2f10
Sep 20 00:05:54 xenon kernel: [   35.289474]  =3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D

And finally, X doesn't come up, it gets bogged down in a host of "sleepin=
g
function called from invalid context" and "scheduling while atomic" messa=
ges.
No idea whom to CC on that.

Sep 20 00:06:06 xenon kernel: [   53.742236] BUG: sleeping function calle=
d from invalid context at kernel/rwsem.c:47
Sep 20 00:06:06 xenon kernel: [   53.742247] in_atomic():1, irqs_disabled=
():0
Sep 20 00:06:06 xenon kernel: [   53.742251] no locks held by gdmgreeter/=
5809.
Sep 20 00:06:06 xenon kernel: [   53.742265]  [<c0108441>] dump_trace+0x6=
4/0x1f2
Sep 20 00:06:06 xenon kernel: [   53.742288]  [<c01085e9>] show_trace_log=
_lvl+0x1a/0x2f
Sep 20 00:06:06 xenon kernel: [   53.742305]  [<c010902b>] show_trace+0x1=
2/0x14
Sep 20 00:06:06 xenon kernel: [   53.742318]  [<c0109154>] dump_stack+0x1=
6/0x18
Sep 20 00:06:06 xenon kernel: [   53.742336]  [<c0123ecd>] __might_sleep+=
0xe5/0xeb
Sep 20 00:06:06 xenon kernel: [   53.742352]  [<c013f72d>] down_write+0x1=
8/0x54
Sep 20 00:06:06 xenon kernel: [   53.742366]  [<c01cf6b9>] do_shmat+0x216=
/0x384
Sep 20 00:06:06 xenon kernel: [   53.742382]  [<c010b491>] sys_ipc+0x148/=
0x1b5
Sep 20 00:06:06 xenon kernel: [   53.742395]  [<c010714e>] sysenter_past_=
esp+0x6b/0xb5
Sep 20 00:06:06 xenon kernel: [   53.742411]  [<b7fc0410>] 0xb7fc0410
Sep 20 00:06:06 xenon kernel: [   53.742439]  =3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
Sep 20 00:06:06 xenon kernel: [   53.742563] BUG: scheduling while atomic=
: gdmgreeter/5809/0x00000005
Sep 20 00:06:06 xenon kernel: [   53.742572] no locks held by gdmgreeter/=
5809.
Sep 20 00:06:06 xenon kernel: [   53.742579] irq event stamp: 84510
Sep 20 00:06:06 xenon kernel: [   53.742585] hardirqs last  enabled at (8=
4509): [<c031273f>] _spin_unlock_irqrestore+0x40/0x6d
Sep 20 00:06:06 xenon kernel: [   53.742607] hardirqs last disabled at (8=
4510): [<c0107167>] sysenter_past_esp+0x84/0xb5
Sep 20 00:06:06 xenon kernel: [   53.742622] softirqs last  enabled at (8=
4410): [<c012f084>] __do_softirq+0xf5/0xfb
Sep 20 00:06:06 xenon kernel: [   53.742640] softirqs last disabled at (8=
4405): [<c01099ee>] do_softirq+0x77/0xf8
Sep 20 00:06:06 xenon kernel: [   53.742660]  [<c0108441>] dump_trace+0x6=
4/0x1f2
Sep 20 00:06:06 xenon kernel: [   53.742675]  [<c01085e9>] show_trace_log=
_lvl+0x1a/0x2f
Sep 20 00:06:06 xenon kernel: [   53.742687]  [<c010902b>] show_trace+0x1=
2/0x14
Sep 20 00:06:06 xenon kernel: [   53.742694]  [<c0109154>] dump_stack+0x1=
6/0x18
Sep 20 00:06:06 xenon kernel: [   53.742702]  [<c012605c>] __schedule_bug=
+0x6e/0x75
Sep 20 00:06:06 xenon kernel: [   53.742716]  [<c030f65b>] __sched_text_s=
tart+0x83/0x59e
Sep 20 00:06:06 xenon kernel: [   53.742730]  [<c01072a6>] work_resched+0=
x5/0x31
Sep 20 00:06:06 xenon kernel: [   53.742745]  [<b7fc0410>] 0xb7fc0410
Sep 20 00:06:06 xenon kernel: [   53.742760]  =3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
Sep 20 00:06:06 xenon kernel: [   53.742976] X[5716]: segfault at b7e4a5e=
0 eip b7e4a5e0 esp bf8eb3a8 error 4
Sep 20 00:06:06 xenon kernel: [   53.742996] note: X[5716] exited with pr=
eempt_count 3
Sep 20 00:06:06 xenon kernel: [   53.743449] BUG: scheduling while atomic=
: gdmgreeter/5809/0x00000005
Sep 20 00:06:06 xenon kernel: [   53.743454] no locks held by gdmgreeter/=
5809.
Sep 20 00:06:06 xenon kernel: [   53.743464]  [<c0108441>] dump_trace+0x6=
4/0x1f2
Sep 20 00:06:06 xenon kernel: [   53.743476]  [<c01085e9>] show_trace_log=
_lvl+0x1a/0x2f
Sep 20 00:06:06 xenon kernel: [   53.743482]  [<c010902b>] show_trace+0x1=
2/0x14
Sep 20 00:06:06 xenon kernel: [   53.743488]  [<c0109154>] dump_stack+0x1=
6/0x18
Sep 20 00:06:06 xenon kernel: [   53.743493]  [<c012605c>] __schedule_bug=
+0x6e/0x75
Sep 20 00:06:06 xenon kernel: [   53.743500]  [<c030f65b>] __sched_text_s=
tart+0x83/0x59e
Sep 20 00:06:06 xenon kernel: [   53.743508]  [<c03102da>] schedule_timeo=
ut+0x16/0x8e
Sep 20 00:06:06 xenon kernel: [   53.743514]  [<c018f9ea>] do_sys_poll+0x=
27b/0x346
Sep 20 00:06:06 xenon kernel: [   53.743521]  [<c0190578>] sys_poll+0x39/=
0x6c
Sep 20 00:06:06 xenon kernel: [   53.743526]  [<c010714e>] sysenter_past_=
esp+0x6b/0xb5
Sep 20 00:06:06 xenon kernel: [   53.743535]  [<b7fc0410>] 0xb7fc0410
Sep 20 00:06:06 xenon kernel: [   53.743555]  =3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
Sep 20 00:06:06 xenon kernel: [   53.744705] BUG: scheduling while atomic=
: X/5716/0x10000004
Sep 20 00:06:06 xenon kernel: [   53.744710] no locks held by X/5716.
Sep 20 00:06:06 xenon kernel: [   53.744716]  [<c0108441>] dump_trace+0x6=
4/0x1f2
Sep 20 00:06:06 xenon kernel: [   53.744725]  [<c01085e9>] show_trace_log=
_lvl+0x1a/0x2f
Sep 20 00:06:06 xenon kernel: [   53.744732]  [<c010902b>] show_trace+0x1=
2/0x14
Sep 20 00:06:06 xenon kernel: [   53.744738]  [<c0109154>] dump_stack+0x1=
6/0x18
Sep 20 00:06:06 xenon kernel: [   53.744745]  [<c012605c>] __schedule_bug=
+0x6e/0x75
Sep 20 00:06:06 xenon kernel: [   53.744752]  [<c030f65b>] __sched_text_s=
tart+0x83/0x59e
Sep 20 00:06:06 xenon kernel: [   53.744759]  [<c0126084>] __cond_resched=
+0x21/0x3b
Sep 20 00:06:06 xenon kernel: [   53.744766]  [<c031003b>] cond_resched+0=
x26/0x31
Sep 20 00:06:06 xenon kernel: [   53.744772]  [<c017059a>] unmap_vmas+0x4=
61/0x580
Sep 20 00:06:06 xenon kernel: [   53.744780]  [<c017351b>] exit_mmap+0x7f=
/0x10f
Sep 20 00:06:06 xenon kernel: [   53.744789]  [<c012807b>] mmput+0x4d/0xc=
b
Sep 20 00:06:06 xenon kernel: [   53.744796]  [<c012bea5>] exit_mm+0xd7/0=
xdc
Sep 20 00:06:06 xenon kernel: [   53.744803]  [<c012d3bb>] do_exit+0x224/=
0x76b
Sep 20 00:06:06 xenon kernel: [   53.744810]  [<c012d972>] sys_exit_group=
+0x0/0x11
Sep 20 00:06:06 xenon kernel: [   53.744818]  [<c013529c>] get_signal_to_=
deliver+0x40f/0x434
Sep 20 00:06:06 xenon kernel: [   53.744826]  [<c010673a>] do_notify_resu=
me+0x94/0x6a6
Sep 20 00:06:06 xenon kernel: [   53.744833]  [<c01072e5>] work_notifysig=
+0x13/0x1a
Sep 20 00:06:06 xenon kernel: [   53.744841]  [<b7e4a5e0>] 0xb7e4a5e0
Sep 20 00:06:06 xenon kernel: [   53.744850]  =3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
Sep 20 00:06:06 xenon kernel: [   53.748072] BUG: scheduling while atomic=
: X/5716/0x00000005
Sep 20 00:06:06 xenon kernel: [   53.748076] no locks held by X/5716.
Sep 20 00:06:06 xenon kernel: [   53.748082]  [<c0108441>] dump_trace+0x6=
4/0x1f2
Sep 20 00:06:06 xenon kernel: [   53.748091]  [<c01085e9>] show_trace_log=
_lvl+0x1a/0x2f
Sep 20 00:06:06 xenon kernel: [   53.748098]  [<c010902b>] show_trace+0x1=
2/0x14
Sep 20 00:06:06 xenon kernel: [   53.748104]  [<c0109154>] dump_stack+0x1=
6/0x18
Sep 20 00:06:06 xenon kernel: [   53.748110]  [<c012605c>] __schedule_bug=
+0x6e/0x75
Sep 20 00:06:06 xenon kernel: [   53.748117]  [<c030f65b>] __sched_text_s=
tart+0x83/0x59e
Sep 20 00:06:06 xenon kernel: [   53.748125]  [<c030fc2a>] wait_for_compl=
etion+0x74/0xaa
Sep 20 00:06:06 xenon kernel: [   53.748131]  [<c013a422>] synchronize_rc=
u+0x2d/0x33
Sep 20 00:06:06 xenon kernel: [   53.748139]  [<c028b474>] mousedev_detac=
h_client+0x34/0x38
Sep 20 00:06:06 xenon kernel: [   53.748148]  [<c028b528>] mousedev_relea=
se+0x21/0x40
Sep 20 00:06:06 xenon kernel: [   53.748155]  [<c0185442>] __fput+0xb9/0x=
165
Sep 20 00:06:06 xenon kernel: [   53.748162]  [<c01855c6>] fput+0x32/0x36=

Sep 20 00:06:06 xenon kernel: [   53.748168]  [<c0182c62>] filp_close+0x5=
4/0x5c
Sep 20 00:06:06 xenon kernel: [   53.748176]  [<c012c1fa>] put_files_stru=
ct+0x7e/0xc0
Sep 20 00:06:06 xenon kernel: [   53.748183]  [<c012d3fc>] do_exit+0x265/=
0x76b
Sep 20 00:06:06 xenon kernel: [   53.748191]  [<c012d972>] sys_exit_group=
+0x0/0x11
Sep 20 00:06:06 xenon kernel: [   53.748198]  [<c013529c>] get_signal_to_=
deliver+0x40f/0x434
Sep 20 00:06:06 xenon kernel: [   53.748205]  [<c010673a>] do_notify_resu=
me+0x94/0x6a6
Sep 20 00:06:06 xenon kernel: [   53.748213]  [<c01072e5>] work_notifysig=
+0x13/0x1a
Sep 20 00:06:06 xenon kernel: [   53.748221]  [<b7e4a5e0>] 0xb7e4a5e0
Sep 20 00:06:06 xenon kernel: [   53.748229]  =3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
Sep 20 00:06:06 xenon kernel: [   53.753964] BUG: scheduling while atomic=
: X/5716/0x00000005
Sep 20 00:06:06 xenon kernel: [   53.753974] 3 locks held by X/5716:
Sep 20 00:06:06 xenon kernel: [   53.753977]  #0:  (&mousedev->mutex/31){=
--..}, at: [<c0310e02>] mutex_lock+0x1c/0x1f
Sep 20 00:06:06 xenon kernel: [   53.753992]  #1:  (&mousedev->mutex#2){-=
-..}, at: [<c0310e02>] mutex_lock+0x1c/0x1f
Sep 20 00:06:06 xenon kernel: [   53.754002]  #2:  (&dev->mutex){--..}, a=
t: [<c0310e02>] mutex_lock+0x1c/0x1f
Sep 20 00:06:06 xenon kernel: [   53.754019]  [<c0108441>] dump_trace+0x6=
4/0x1f2
Sep 20 00:06:06 xenon kernel: [   53.754029]  [<c01085e9>] show_trace_log=
_lvl+0x1a/0x2f
Sep 20 00:06:06 xenon kernel: [   53.754036]  [<c010902b>] show_trace+0x1=
2/0x14
Sep 20 00:06:06 xenon kernel: [   53.754044]  [<c0109154>] dump_stack+0x1=
6/0x18
Sep 20 00:06:06 xenon kernel: [   53.754051]  [<c012605c>] __schedule_bug=
+0x6e/0x75
Sep 20 00:06:06 xenon kernel: [   53.754059]  [<c030f65b>] __sched_text_s=
tart+0x83/0x59e
Sep 20 00:06:06 xenon kernel: [   53.754068]  [<fa997422>] usb_kill_urb+0=
xa1/0xcd [usbcore]
Sep 20 00:06:06 xenon kernel: [   53.754109]  [<faa758bd>] usbhid_close+0=
x23/0x2e [usbhid]
Sep 20 00:06:06 xenon kernel: [   53.754124]  [<c02a3119>] hidinput_close=
+0xd/0xf
Sep 20 00:06:06 xenon kernel: [   53.754132]  [<c0289499>] input_close_de=
vice+0x3e/0x5a
Sep 20 00:06:06 xenon kernel: [   53.754139]  [<c028b4fc>] mousedev_close=
_device+0x84/0x8f
Sep 20 00:06:06 xenon kernel: [   53.754145]  [<c028b4c4>] mousedev_close=
_device+0x4c/0x8f
Sep 20 00:06:06 xenon kernel: [   53.754150]  [<c028b536>] mousedev_relea=
se+0x2f/0x40
Sep 20 00:06:06 xenon kernel: [   53.754156]  [<c0185442>] __fput+0xb9/0x=
165
Sep 20 00:06:06 xenon kernel: [   53.754162]  [<c01855c6>] fput+0x32/0x36=

Sep 20 00:06:06 xenon kernel: [   53.754167]  [<c0182c62>] filp_close+0x5=
4/0x5c
Sep 20 00:06:06 xenon kernel: [   53.754173]  [<c012c1fa>] put_files_stru=
ct+0x7e/0xc0
Sep 20 00:06:06 xenon kernel: [   53.754179]  [<c012d3fc>] do_exit+0x265/=
0x76b
Sep 20 00:06:06 xenon kernel: [   53.754185]  [<c012d972>] sys_exit_group=
+0x0/0x11
Sep 20 00:06:06 xenon kernel: [   53.754190]  [<c013529c>] get_signal_to_=
deliver+0x40f/0x434
Sep 20 00:06:06 xenon kernel: [   53.754197]  [<c010673a>] do_notify_resu=
me+0x94/0x6a6
Sep 20 00:06:06 xenon kernel: [   53.754204]  [<c01072e5>] work_notifysig=
+0x13/0x1a
Sep 20 00:06:06 xenon kernel: [   53.754211]  [<b7e4a5e0>] 0xb7e4a5e0
Sep 20 00:06:06 xenon kernel: [   53.754219]  =3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
[etc. etc. - I can't seem to find a rule to it]

This is on the Pentium D 940 / Intel DQ965GF / Matrox G550 / openSUSE 10.=
2
system where I currently do all my kernel torturing. .config attached. No=
t
sure what other information to include. Just ask.

HTH
T.

--=20
Tilman Schmidt                          E-Mail: tilman@imap.cc
Bonn, Germany
Diese Nachricht besteht zu 100% aus wiederverwerteten Bits.
Unge=F6ffnet mindestens haltbar bis: (siehe R=FCckseite)

--------------090208080409080002090402
Content-Type: text/plain;
 name=".config"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline;
 filename=".config"

#
# Automatically generated make config: don't edit
# Linux kernel version: 2.6.23-rc6-mm1
# Wed Sep 19 21:01:48 2007
#
CONFIG_X86_32=3Dy
CONFIG_GENERIC_TIME=3Dy
CONFIG_GENERIC_CMOS_UPDATE=3Dy
CONFIG_CLOCKSOURCE_WATCHDOG=3Dy
CONFIG_GENERIC_CLOCKEVENTS=3Dy
CONFIG_GENERIC_CLOCKEVENTS_BROADCAST=3Dy
CONFIG_LOCKDEP_SUPPORT=3Dy
CONFIG_STACKTRACE_SUPPORT=3Dy
CONFIG_SEMAPHORE_SLEEPERS=3Dy
CONFIG_X86=3Dy
CONFIG_MMU=3Dy
CONFIG_ZONE_DMA=3Dy
CONFIG_QUICKLIST=3Dy
CONFIG_GENERIC_ISA_DMA=3Dy
CONFIG_GENERIC_IOMAP=3Dy
CONFIG_GENERIC_BUG=3Dy
CONFIG_GENERIC_HWEIGHT=3Dy
CONFIG_ARCH_MAY_HAVE_PC_FDC=3Dy
CONFIG_DMI=3Dy
CONFIG_DEFCONFIG_LIST=3D"/lib/modules/$UNAME_RELEASE/.config"

#
# General setup
#
CONFIG_EXPERIMENTAL=3Dy
CONFIG_LOCK_KERNEL=3Dy
CONFIG_INIT_ENV_ARG_LIMIT=3D32
CONFIG_LOCALVERSION=3D"-testing"
CONFIG_LOCALVERSION_AUTO=3Dy
CONFIG_SWAP=3Dy
CONFIG_SYSVIPC=3Dy
CONFIG_SYSVIPC_SYSCTL=3Dy
CONFIG_POSIX_MQUEUE=3Dy
CONFIG_BSD_PROCESS_ACCT=3Dy
CONFIG_BSD_PROCESS_ACCT_V3=3Dy
# CONFIG_TASKSTATS is not set
# CONFIG_USER_NS is not set
CONFIG_AUDIT=3Dy
CONFIG_AUDITSYSCALL=3Dy
CONFIG_AUDIT_TREE=3Dy
CONFIG_IKCONFIG=3Dy
CONFIG_IKCONFIG_PROC=3Dy
CONFIG_LOG_BUF_SHIFT=3D17
# CONFIG_CONTAINERS is not set
CONFIG_SYSFS_DEPRECATED=3Dy
CONFIG_RELAY=3Dy
CONFIG_BLK_DEV_INITRD=3Dy
CONFIG_INITRAMFS_SOURCE=3D""
CONFIG_CC_OPTIMIZE_FOR_SIZE=3Dy
CONFIG_SYSCTL=3Dy
# CONFIG_EMBEDDED is not set
CONFIG_UID16=3Dy
CONFIG_SYSCTL_SYSCALL=3Dy
CONFIG_KALLSYMS=3Dy
CONFIG_KALLSYMS_ALL=3Dy
# CONFIG_KALLSYMS_EXTRA_PASS is not set
CONFIG_HOTPLUG=3Dy
CONFIG_PRINTK=3Dy
CONFIG_BUG=3Dy
CONFIG_ELF_CORE=3Dy
CONFIG_BASE_FULL=3Dy
CONFIG_FUTEX=3Dy
CONFIG_ANON_INODES=3Dy
CONFIG_EPOLL=3Dy
CONFIG_SIGNALFD=3Dy
CONFIG_EVENTFD=3Dy
CONFIG_SHMEM=3Dy
CONFIG_VM_EVENT_COUNTERS=3Dy
CONFIG_SLUB_DEBUG=3Dy
# CONFIG_SLAB is not set
CONFIG_SLUB=3Dy
# CONFIG_SLOB is not set
CONFIG_PROC_PAGE_MONITOR=3Dy
CONFIG_PROC_KPAGEMAP=3Dy
CONFIG_RT_MUTEXES=3Dy
# CONFIG_TINY_SHMEM is not set
CONFIG_BASE_SMALL=3D0
CONFIG_MODULES=3Dy
CONFIG_MODULE_UNLOAD=3Dy
CONFIG_MODULE_FORCE_UNLOAD=3Dy
CONFIG_MODVERSIONS=3Dy
CONFIG_MODULE_SRCVERSION_ALL=3Dy
CONFIG_KMOD=3Dy
CONFIG_STOP_MACHINE=3Dy
CONFIG_BLOCK=3Dy
CONFIG_LBD=3Dy
CONFIG_BLK_DEV_IO_TRACE=3Dy
CONFIG_LSF=3Dy
CONFIG_BLK_DEV_BSG=3Dy

#
# IO Schedulers
#
CONFIG_IOSCHED_NOOP=3Dy
CONFIG_IOSCHED_AS=3Dy
CONFIG_IOSCHED_DEADLINE=3Dy
CONFIG_IOSCHED_CFQ=3Dy
# CONFIG_DEFAULT_AS is not set
CONFIG_DEFAULT_DEADLINE=3Dy
# CONFIG_DEFAULT_CFQ is not set
# CONFIG_DEFAULT_NOOP is not set
CONFIG_DEFAULT_IOSCHED=3D"deadline"
CONFIG_PREEMPT_NOTIFIERS=3Dy

#
# Processor type and features
#
CONFIG_TICK_ONESHOT=3Dy
CONFIG_NO_HZ=3Dy
CONFIG_HIGH_RES_TIMERS=3Dy
CONFIG_GENERIC_CLOCKEVENTS_BUILD=3Dy
CONFIG_SMP=3Dy
CONFIG_X86_PC=3Dy
# CONFIG_X86_ELAN is not set
# CONFIG_X86_VOYAGER is not set
# CONFIG_X86_NUMAQ is not set
# CONFIG_X86_SUMMIT is not set
# CONFIG_X86_BIGSMP is not set
# CONFIG_X86_VISWS is not set
# CONFIG_X86_GENERICARCH is not set
# CONFIG_X86_ES7000 is not set
CONFIG_PARAVIRT=3Dy
CONFIG_XEN=3Dy
CONFIG_VMI=3Dy
# CONFIG_M386 is not set
# CONFIG_M486 is not set
# CONFIG_M586 is not set
# CONFIG_M586TSC is not set
# CONFIG_M586MMX is not set
# CONFIG_M686 is not set
# CONFIG_MPENTIUMII is not set
# CONFIG_MPENTIUMIII is not set
# CONFIG_MPENTIUMM is not set
CONFIG_MPENTIUM4=3Dy
# CONFIG_MCORE2 is not set
# CONFIG_MK6 is not set
# CONFIG_MK7 is not set
# CONFIG_MK8 is not set
# CONFIG_MCRUSOE is not set
# CONFIG_MEFFICEON is not set
# CONFIG_MWINCHIPC6 is not set
# CONFIG_MWINCHIP2 is not set
# CONFIG_MWINCHIP3D is not set
# CONFIG_MGEODEGX1 is not set
# CONFIG_MGEODE_LX is not set
# CONFIG_MCYRIXIII is not set
# CONFIG_MVIAC3_2 is not set
# CONFIG_MVIAC7 is not set
# CONFIG_X86_GENERIC is not set
CONFIG_X86_CMPXCHG=3Dy
CONFIG_X86_L1_CACHE_SHIFT=3D7
CONFIG_X86_XADD=3Dy
CONFIG_RWSEM_XCHGADD_ALGORITHM=3Dy
# CONFIG_ARCH_HAS_ILOG2_U32 is not set
# CONFIG_ARCH_HAS_ILOG2_U64 is not set
CONFIG_GENERIC_CALIBRATE_DELAY=3Dy
CONFIG_X86_WP_WORKS_OK=3Dy
CONFIG_X86_INVLPG=3Dy
CONFIG_X86_BSWAP=3Dy
CONFIG_X86_POPAD_OK=3Dy
CONFIG_X86_GOOD_APIC=3Dy
CONFIG_X86_INTEL_USERCOPY=3Dy
CONFIG_X86_USE_PPRO_CHECKSUM=3Dy
CONFIG_X86_TSC=3Dy
CONFIG_X86_CMOV=3Dy
CONFIG_X86_MINIMUM_CPU_FAMILY=3D4
CONFIG_HPET_TIMER=3Dy
CONFIG_HPET_EMULATE_RTC=3Dy
CONFIG_NR_CPUS=3D8
CONFIG_SCHED_SMT=3Dy
CONFIG_SCHED_MC=3Dy
# CONFIG_PREEMPT_NONE is not set
# CONFIG_PREEMPT_VOLUNTARY is not set
CONFIG_PREEMPT=3Dy
CONFIG_PREEMPT_BKL=3Dy
CONFIG_X86_LOCAL_APIC=3Dy
CONFIG_X86_IO_APIC=3Dy
CONFIG_X86_MCE=3Dy
CONFIG_X86_MCE_NONFATAL=3Dy
CONFIG_X86_MCE_P4THERMAL=3Dy
CONFIG_VM86=3Dy
# CONFIG_TOSHIBA is not set
# CONFIG_I8K is not set
# CONFIG_X86_REBOOTFIXUPS is not set
CONFIG_MICROCODE=3Dm
CONFIG_MICROCODE_OLD_INTERFACE=3Dy
CONFIG_X86_MSR=3Dm
CONFIG_X86_CPUID=3Dm

#
# Firmware Drivers
#
CONFIG_EDD=3Dm
CONFIG_DELL_RBU=3Dm
CONFIG_DCDBAS=3Dm
CONFIG_DMIID=3Dy
# CONFIG_NOHIGHMEM is not set
CONFIG_HIGHMEM4G=3Dy
# CONFIG_HIGHMEM64G is not set
CONFIG_PAGE_OFFSET=3D0xC0000000
CONFIG_HIGHMEM=3Dy
CONFIG_ARCH_FLATMEM_ENABLE=3Dy
CONFIG_ARCH_SPARSEMEM_ENABLE=3Dy
CONFIG_ARCH_SELECT_MEMORY_MODEL=3Dy
CONFIG_ARCH_POPULATES_NODE_MAP=3Dy
CONFIG_SELECT_MEMORY_MODEL=3Dy
CONFIG_FLATMEM_MANUAL=3Dy
# CONFIG_DISCONTIGMEM_MANUAL is not set
# CONFIG_SPARSEMEM_MANUAL is not set
CONFIG_FLATMEM=3Dy
CONFIG_FLAT_NODE_MEM_MAP=3Dy
CONFIG_SPARSEMEM_STATIC=3Dy
# CONFIG_SPARSEMEM_VMEMMAP_ENABLE is not set
CONFIG_SPLIT_PTLOCK_CPUS=3D4
# CONFIG_RESOURCES_64BIT is not set
CONFIG_ZONE_DMA_FLAG=3D1
CONFIG_BOUNCE=3Dy
CONFIG_NR_QUICK=3D1
CONFIG_VIRT_TO_BUS=3Dy
CONFIG_HIGHPTE=3Dy
# CONFIG_MATH_EMULATION is not set
CONFIG_MTRR=3Dy
# CONFIG_EFI is not set
CONFIG_IRQBALANCE=3Dy
CONFIG_SECCOMP=3Dy
# CONFIG_HZ_100 is not set
# CONFIG_HZ_250 is not set
# CONFIG_HZ_300 is not set
CONFIG_HZ_1000=3Dy
CONFIG_HZ=3D1000
CONFIG_KEXEC=3Dy
# CONFIG_CRASH_DUMP is not set
CONFIG_PHYSICAL_START=3D0x100000
# CONFIG_RELOCATABLE is not set
CONFIG_PHYSICAL_ALIGN=3D0x100000
CONFIG_HOTPLUG_CPU=3Dy
# CONFIG_COMPAT_VDSO is not set
CONFIG_ARCH_ENABLE_MEMORY_HOTPLUG=3Dy

#
# Power management options (ACPI, APM)
#
CONFIG_PM=3Dy
# CONFIG_PM_LEGACY is not set
# CONFIG_PM_DEBUG is not set
CONFIG_PM_SLEEP_SMP=3Dy
CONFIG_PM_SLEEP=3Dy
CONFIG_SUSPEND_SMP_POSSIBLE=3Dy
CONFIG_SUSPEND=3Dy
CONFIG_HIBERNATION_SMP_POSSIBLE=3Dy
CONFIG_HIBERNATION=3Dy
CONFIG_PM_STD_PARTITION=3D""
CONFIG_ACPI=3Dy
CONFIG_ACPI_SLEEP=3Dy
CONFIG_ACPI_PROCFS=3Dy
CONFIG_ACPI_PROC_EVENT=3Dy
CONFIG_ACPI_AC=3Dm
CONFIG_ACPI_BATTERY=3Dm
CONFIG_ACPI_BUTTON=3Dm
CONFIG_ACPI_VIDEO=3Dm
CONFIG_ACPI_FAN=3Dm
CONFIG_ACPI_DOCK=3Dm
# CONFIG_ACPI_BAY is not set
CONFIG_ACPI_PROCESSOR=3Dm
CONFIG_ACPI_HOTPLUG_CPU=3Dy
CONFIG_ACPI_THERMAL=3Dm
# CONFIG_ACPI_ASUS is not set
# CONFIG_ACPI_TOSHIBA is not set
# CONFIG_ACPI_CUSTOM_DSDT is not set
CONFIG_ACPI_BLACKLIST_YEAR=3D0
# CONFIG_ACPI_DEBUG is not set
CONFIG_ACPI_EC=3Dy
CONFIG_ACPI_POWER=3Dy
CONFIG_ACPI_SYSTEM=3Dy
CONFIG_X86_PM_TIMER=3Dy
CONFIG_ACPI_CONTAINER=3Dm
# CONFIG_ACPI_SBS is not set
# CONFIG_APM is not set

#
# CPU Frequency scaling
#
CONFIG_CPU_FREQ=3Dy
CONFIG_CPU_FREQ_TABLE=3Dm
# CONFIG_CPU_FREQ_DEBUG is not set
CONFIG_CPU_FREQ_STAT=3Dm
CONFIG_CPU_FREQ_STAT_DETAILS=3Dy
CONFIG_CPU_FREQ_DEFAULT_GOV_PERFORMANCE=3Dy
# CONFIG_CPU_FREQ_DEFAULT_GOV_USERSPACE is not set
# CONFIG_CPU_FREQ_DEFAULT_GOV_ONDEMAND is not set
# CONFIG_CPU_FREQ_DEFAULT_GOV_CONSERVATIVE is not set
CONFIG_CPU_FREQ_GOV_PERFORMANCE=3Dy
CONFIG_CPU_FREQ_GOV_POWERSAVE=3Dm
CONFIG_CPU_FREQ_GOV_USERSPACE=3Dm
CONFIG_CPU_FREQ_GOV_ONDEMAND=3Dm
CONFIG_CPU_FREQ_GOV_CONSERVATIVE=3Dm

#
# CPUFreq processor drivers
#
CONFIG_X86_ACPI_CPUFREQ=3Dm
CONFIG_X86_POWERNOW_K6=3Dm
CONFIG_X86_POWERNOW_K7=3Dm
CONFIG_X86_POWERNOW_K7_ACPI=3Dy
CONFIG_X86_POWERNOW_K8=3Dm
CONFIG_X86_POWERNOW_K8_ACPI=3Dy
CONFIG_X86_GX_SUSPMOD=3Dm
CONFIG_X86_SPEEDSTEP_CENTRINO=3Dm
CONFIG_X86_SPEEDSTEP_CENTRINO_TABLE=3Dy
CONFIG_X86_SPEEDSTEP_ICH=3Dm
CONFIG_X86_SPEEDSTEP_SMI=3Dm
CONFIG_X86_P4_CLOCKMOD=3Dm
CONFIG_X86_CPUFREQ_NFORCE2=3Dm
CONFIG_X86_LONGRUN=3Dm
CONFIG_X86_LONGHAUL=3Dm
CONFIG_X86_E_POWERSAVER=3Dm

#
# shared options
#
# CONFIG_X86_ACPI_CPUFREQ_PROC_INTF is not set
CONFIG_X86_SPEEDSTEP_LIB=3Dm
CONFIG_X86_SPEEDSTEP_RELAXED_CAP_CHECK=3Dy

#
# CPU idle PM support
#
CONFIG_CPU_IDLE=3Dy

#
# Governors
#
CONFIG_CPU_IDLE_GOV_LADDER=3Dy
CONFIG_CPU_IDLE_GOV_MENU=3Dy

#
# Bus options (PCI, PCMCIA, EISA, MCA, ISA)
#
CONFIG_PCI=3Dy
# CONFIG_PCI_GOBIOS is not set
# CONFIG_PCI_GOMMCONFIG is not set
# CONFIG_PCI_GODIRECT is not set
CONFIG_PCI_GOANY=3Dy
CONFIG_PCI_BIOS=3Dy
CONFIG_PCI_DIRECT=3Dy
CONFIG_PCI_MMCONFIG=3Dy
CONFIG_PCIEPORTBUS=3Dy
CONFIG_PCIEAER=3Dy
CONFIG_ARCH_SUPPORTS_MSI=3Dy
CONFIG_PCI_MSI=3Dy
# CONFIG_PCI_DEBUG is not set
CONFIG_HT_IRQ=3Dy
CONFIG_ISA_DMA_API=3Dy
# CONFIG_ISA is not set
# CONFIG_MCA is not set
# CONFIG_SCx200 is not set
CONFIG_K8_NB=3Dy
# CONFIG_PCCARD is not set
# CONFIG_HOTPLUG_PCI is not set

#
# Executable file formats
#
CONFIG_BINFMT_ELF=3Dy
CONFIG_BINFMT_AOUT=3Dm
CONFIG_BINFMT_MISC=3Dm

#
# Networking
#
CONFIG_NET=3Dy

#
# Networking options
#
CONFIG_PACKET=3Dm
CONFIG_PACKET_MMAP=3Dy
CONFIG_UNIX=3Dy
CONFIG_XFRM=3Dy
CONFIG_XFRM_USER=3Dm
CONFIG_XFRM_SUB_POLICY=3Dy
CONFIG_XFRM_MIGRATE=3Dy
CONFIG_NET_KEY=3Dm
CONFIG_NET_KEY_MIGRATE=3Dy
CONFIG_INET=3Dy
CONFIG_IP_MULTICAST=3Dy
CONFIG_IP_ADVANCED_ROUTER=3Dy
CONFIG_ASK_IP_FIB_HASH=3Dy
# CONFIG_IP_FIB_TRIE is not set
CONFIG_IP_FIB_HASH=3Dy
CONFIG_IP_MULTIPLE_TABLES=3Dy
CONFIG_IP_ROUTE_MULTIPATH=3Dy
CONFIG_IP_ROUTE_VERBOSE=3Dy
# CONFIG_IP_PNP is not set
CONFIG_NET_IPIP=3Dm
CONFIG_NET_IPGRE=3Dm
CONFIG_NET_IPGRE_BROADCAST=3Dy
CONFIG_IP_MROUTE=3Dy
CONFIG_IP_PIMSM_V1=3Dy
CONFIG_IP_PIMSM_V2=3Dy
# CONFIG_ARPD is not set
CONFIG_SYN_COOKIES=3Dy
CONFIG_INET_AH=3Dm
CONFIG_INET_ESP=3Dm
CONFIG_INET_IPCOMP=3Dm
CONFIG_INET_XFRM_TUNNEL=3Dm
CONFIG_INET_TUNNEL=3Dm
CONFIG_INET_XFRM_MODE_TRANSPORT=3Dm
CONFIG_INET_XFRM_MODE_TUNNEL=3Dm
CONFIG_INET_XFRM_MODE_BEET=3Dm
CONFIG_INET_LRO=3Dy
CONFIG_INET_DIAG=3Dm
CONFIG_INET_TCP_DIAG=3Dm
CONFIG_TCP_CONG_ADVANCED=3Dy
CONFIG_TCP_CONG_BIC=3Dm
CONFIG_TCP_CONG_CUBIC=3Dm
CONFIG_TCP_CONG_WESTWOOD=3Dm
CONFIG_TCP_CONG_HTCP=3Dm
CONFIG_TCP_CONG_HSTCP=3Dm
CONFIG_TCP_CONG_HYBLA=3Dm
CONFIG_TCP_CONG_VEGAS=3Dm
CONFIG_TCP_CONG_SCALABLE=3Dm
CONFIG_TCP_CONG_LP=3Dm
CONFIG_TCP_CONG_VENO=3Dm
CONFIG_TCP_CONG_YEAH=3Dm
CONFIG_TCP_CONG_ILLINOIS=3Dm
# CONFIG_DEFAULT_BIC is not set
# CONFIG_DEFAULT_CUBIC is not set
# CONFIG_DEFAULT_HTCP is not set
# CONFIG_DEFAULT_VEGAS is not set
# CONFIG_DEFAULT_WESTWOOD is not set
CONFIG_DEFAULT_RENO=3Dy
CONFIG_DEFAULT_TCP_CONG=3D"reno"
CONFIG_TCP_MD5SIG=3Dy
CONFIG_IP_VS=3Dm
# CONFIG_IP_VS_DEBUG is not set
CONFIG_IP_VS_TAB_BITS=3D12

#
# IPVS transport protocol load balancing support
#
CONFIG_IP_VS_PROTO_TCP=3Dy
CONFIG_IP_VS_PROTO_UDP=3Dy
CONFIG_IP_VS_PROTO_ESP=3Dy
CONFIG_IP_VS_PROTO_AH=3Dy

#
# IPVS scheduler
#
CONFIG_IP_VS_RR=3Dm
CONFIG_IP_VS_WRR=3Dm
CONFIG_IP_VS_LC=3Dm
CONFIG_IP_VS_WLC=3Dm
CONFIG_IP_VS_LBLC=3Dm
CONFIG_IP_VS_LBLCR=3Dm
CONFIG_IP_VS_DH=3Dm
CONFIG_IP_VS_SH=3Dm
CONFIG_IP_VS_SED=3Dm
CONFIG_IP_VS_NQ=3Dm

#
# IPVS application helper
#
CONFIG_IP_VS_FTP=3Dm
CONFIG_IPV6=3Dm
CONFIG_IPV6_PRIVACY=3Dy
CONFIG_IPV6_ROUTER_PREF=3Dy
CONFIG_IPV6_ROUTE_INFO=3Dy
# CONFIG_IPV6_OPTIMISTIC_DAD is not set
CONFIG_INET6_AH=3Dm
CONFIG_INET6_ESP=3Dm
CONFIG_INET6_IPCOMP=3Dm
CONFIG_IPV6_MIP6=3Dm
CONFIG_INET6_XFRM_TUNNEL=3Dm
CONFIG_INET6_TUNNEL=3Dm
CONFIG_INET6_XFRM_MODE_TRANSPORT=3Dm
CONFIG_INET6_XFRM_MODE_TUNNEL=3Dm
CONFIG_INET6_XFRM_MODE_BEET=3Dm
# CONFIG_INET6_XFRM_MODE_ROUTEOPTIMIZATION is not set
CONFIG_IPV6_SIT=3Dm
CONFIG_IPV6_TUNNEL=3Dm
CONFIG_IPV6_MULTIPLE_TABLES=3Dy
CONFIG_IPV6_SUBTREES=3Dy
CONFIG_NETLABEL=3Dy
CONFIG_NETWORK_SECMARK=3Dy
CONFIG_NETFILTER=3Dy
# CONFIG_NETFILTER_DEBUG is not set
CONFIG_BRIDGE_NETFILTER=3Dy

#
# Core Netfilter Configuration
#
CONFIG_NETFILTER_NETLINK=3Dm
CONFIG_NETFILTER_NETLINK_QUEUE=3Dm
CONFIG_NETFILTER_NETLINK_LOG=3Dm
CONFIG_NF_CONNTRACK_ENABLED=3Dm
CONFIG_NF_CONNTRACK=3Dm
CONFIG_NF_CT_ACCT=3Dy
CONFIG_NF_CONNTRACK_MARK=3Dy
CONFIG_NF_CONNTRACK_SECMARK=3Dy
CONFIG_NF_CONNTRACK_EVENTS=3Dy
CONFIG_NF_CT_PROTO_GRE=3Dm
CONFIG_NF_CT_PROTO_SCTP=3Dm
CONFIG_NF_CT_PROTO_UDPLITE=3Dm
CONFIG_NF_CONNTRACK_AMANDA=3Dm
CONFIG_NF_CONNTRACK_FTP=3Dm
CONFIG_NF_CONNTRACK_H323=3Dm
CONFIG_NF_CONNTRACK_IRC=3Dm
CONFIG_NF_CONNTRACK_NETBIOS_NS=3Dm
CONFIG_NF_CONNTRACK_PPTP=3Dm
CONFIG_NF_CONNTRACK_SANE=3Dm
CONFIG_NF_CONNTRACK_SIP=3Dm
CONFIG_NF_CONNTRACK_TFTP=3Dm
CONFIG_NF_CT_NETLINK=3Dm
CONFIG_NETFILTER_XTABLES=3Dm
CONFIG_NETFILTER_XT_TARGET_CLASSIFY=3Dm
CONFIG_NETFILTER_XT_TARGET_CONNMARK=3Dm
CONFIG_NETFILTER_XT_TARGET_DSCP=3Dm
CONFIG_NETFILTER_XT_TARGET_MARK=3Dm
CONFIG_NETFILTER_XT_TARGET_NFQUEUE=3Dm
CONFIG_NETFILTER_XT_TARGET_NFLOG=3Dm
CONFIG_NETFILTER_XT_TARGET_NOTRACK=3Dm
CONFIG_NETFILTER_XT_TARGET_TRACE=3Dm
CONFIG_NETFILTER_XT_TARGET_SECMARK=3Dm
CONFIG_NETFILTER_XT_TARGET_CONNSECMARK=3Dm
CONFIG_NETFILTER_XT_TARGET_TCPMSS=3Dm
CONFIG_NETFILTER_XT_MATCH_COMMENT=3Dm
CONFIG_NETFILTER_XT_MATCH_CONNBYTES=3Dm
CONFIG_NETFILTER_XT_MATCH_CONNLIMIT=3Dm
CONFIG_NETFILTER_XT_MATCH_CONNMARK=3Dm
CONFIG_NETFILTER_XT_MATCH_CONNTRACK=3Dm
CONFIG_NETFILTER_XT_MATCH_DCCP=3Dm
CONFIG_NETFILTER_XT_MATCH_DSCP=3Dm
CONFIG_NETFILTER_XT_MATCH_ESP=3Dm
CONFIG_NETFILTER_XT_MATCH_HELPER=3Dm
CONFIG_NETFILTER_XT_MATCH_LENGTH=3Dm
CONFIG_NETFILTER_XT_MATCH_LIMIT=3Dm
CONFIG_NETFILTER_XT_MATCH_MAC=3Dm
CONFIG_NETFILTER_XT_MATCH_MARK=3Dm
CONFIG_NETFILTER_XT_MATCH_POLICY=3Dm
CONFIG_NETFILTER_XT_MATCH_MULTIPORT=3Dm
CONFIG_NETFILTER_XT_MATCH_PHYSDEV=3Dm
CONFIG_NETFILTER_XT_MATCH_PKTTYPE=3Dm
CONFIG_NETFILTER_XT_MATCH_QUOTA=3Dm
CONFIG_NETFILTER_XT_MATCH_REALM=3Dm
CONFIG_NETFILTER_XT_MATCH_SCTP=3Dm
CONFIG_NETFILTER_XT_MATCH_STATE=3Dm
CONFIG_NETFILTER_XT_MATCH_STATISTIC=3Dm
CONFIG_NETFILTER_XT_MATCH_STRING=3Dm
CONFIG_NETFILTER_XT_MATCH_TCPMSS=3Dm
CONFIG_NETFILTER_XT_MATCH_U32=3Dm
CONFIG_NETFILTER_XT_MATCH_HASHLIMIT=3Dm

#
# IP: Netfilter Configuration
#
CONFIG_NF_CONNTRACK_IPV4=3Dm
CONFIG_NF_CONNTRACK_PROC_COMPAT=3Dy
CONFIG_IP_NF_QUEUE=3Dm
CONFIG_IP_NF_IPTABLES=3Dm
CONFIG_IP_NF_MATCH_IPRANGE=3Dm
CONFIG_IP_NF_MATCH_TOS=3Dm
CONFIG_IP_NF_MATCH_RECENT=3Dm
CONFIG_IP_NF_MATCH_ECN=3Dm
CONFIG_IP_NF_MATCH_AH=3Dm
CONFIG_IP_NF_MATCH_TTL=3Dm
CONFIG_IP_NF_MATCH_OWNER=3Dm
CONFIG_IP_NF_MATCH_ADDRTYPE=3Dm
CONFIG_IP_NF_FILTER=3Dm
CONFIG_IP_NF_TARGET_REJECT=3Dm
CONFIG_IP_NF_TARGET_LOG=3Dm
CONFIG_IP_NF_TARGET_ULOG=3Dm
CONFIG_NF_NAT=3Dm
CONFIG_NF_NAT_NEEDED=3Dy
CONFIG_IP_NF_TARGET_MASQUERADE=3Dm
CONFIG_IP_NF_TARGET_REDIRECT=3Dm
CONFIG_IP_NF_TARGET_NETMAP=3Dm
CONFIG_IP_NF_TARGET_SAME=3Dm
CONFIG_NF_NAT_SNMP_BASIC=3Dm
CONFIG_NF_NAT_PROTO_GRE=3Dm
CONFIG_NF_NAT_FTP=3Dm
CONFIG_NF_NAT_IRC=3Dm
CONFIG_NF_NAT_TFTP=3Dm
CONFIG_NF_NAT_AMANDA=3Dm
CONFIG_NF_NAT_PPTP=3Dm
CONFIG_NF_NAT_H323=3Dm
CONFIG_NF_NAT_SIP=3Dm
CONFIG_IP_NF_MANGLE=3Dm
CONFIG_IP_NF_TARGET_TOS=3Dm
CONFIG_IP_NF_TARGET_ECN=3Dm
CONFIG_IP_NF_TARGET_TTL=3Dm
CONFIG_IP_NF_TARGET_CLUSTERIP=3Dm
CONFIG_IP_NF_RAW=3Dm
CONFIG_IP_NF_ARPTABLES=3Dm
CONFIG_IP_NF_ARPFILTER=3Dm
CONFIG_IP_NF_ARP_MANGLE=3Dm

#
# IPv6: Netfilter Configuration (EXPERIMENTAL)
#
CONFIG_NF_CONNTRACK_IPV6=3Dm
CONFIG_IP6_NF_QUEUE=3Dm
CONFIG_IP6_NF_IPTABLES=3Dm
CONFIG_IP6_NF_MATCH_RT=3Dm
CONFIG_IP6_NF_MATCH_OPTS=3Dm
CONFIG_IP6_NF_MATCH_FRAG=3Dm
CONFIG_IP6_NF_MATCH_HL=3Dm
CONFIG_IP6_NF_MATCH_OWNER=3Dm
CONFIG_IP6_NF_MATCH_IPV6HEADER=3Dm
CONFIG_IP6_NF_MATCH_AH=3Dm
CONFIG_IP6_NF_MATCH_MH=3Dm
CONFIG_IP6_NF_MATCH_EUI64=3Dm
CONFIG_IP6_NF_FILTER=3Dm
CONFIG_IP6_NF_TARGET_LOG=3Dm
CONFIG_IP6_NF_TARGET_REJECT=3Dm
CONFIG_IP6_NF_MANGLE=3Dm
CONFIG_IP6_NF_TARGET_HL=3Dm
CONFIG_IP6_NF_RAW=3Dm

#
# Bridge: Netfilter Configuration
#
CONFIG_BRIDGE_NF_EBTABLES=3Dm
CONFIG_BRIDGE_EBT_BROUTE=3Dm
CONFIG_BRIDGE_EBT_T_FILTER=3Dm
CONFIG_BRIDGE_EBT_T_NAT=3Dm
CONFIG_BRIDGE_EBT_802_3=3Dm
CONFIG_BRIDGE_EBT_AMONG=3Dm
CONFIG_BRIDGE_EBT_ARP=3Dm
CONFIG_BRIDGE_EBT_IP=3Dm
CONFIG_BRIDGE_EBT_LIMIT=3Dm
CONFIG_BRIDGE_EBT_MARK=3Dm
CONFIG_BRIDGE_EBT_PKTTYPE=3Dm
CONFIG_BRIDGE_EBT_STP=3Dm
CONFIG_BRIDGE_EBT_VLAN=3Dm
CONFIG_BRIDGE_EBT_ARPREPLY=3Dm
CONFIG_BRIDGE_EBT_DNAT=3Dm
CONFIG_BRIDGE_EBT_MARK_T=3Dm
CONFIG_BRIDGE_EBT_REDIRECT=3Dm
CONFIG_BRIDGE_EBT_SNAT=3Dm
CONFIG_BRIDGE_EBT_LOG=3Dm
CONFIG_BRIDGE_EBT_ULOG=3Dm
CONFIG_IP_DCCP=3Dm
CONFIG_INET_DCCP_DIAG=3Dm
CONFIG_IP_DCCP_ACKVEC=3Dy

#
# DCCP CCIDs Configuration (EXPERIMENTAL)
#
CONFIG_IP_DCCP_CCID2=3Dm
CONFIG_IP_DCCP_CCID2_DEBUG=3Dy
CONFIG_IP_DCCP_CCID3=3Dm
CONFIG_IP_DCCP_TFRC_LIB=3Dm
CONFIG_IP_DCCP_CCID3_DEBUG=3Dy
CONFIG_IP_DCCP_CCID3_RTO=3D100

#
# DCCP Kernel Hacking
#
# CONFIG_IP_DCCP_DEBUG is not set
# CONFIG_NET_DCCPPROBE is not set
CONFIG_IP_SCTP=3Dm
# CONFIG_SCTP_DBG_MSG is not set
# CONFIG_SCTP_DBG_OBJCNT is not set
# CONFIG_SCTP_HMAC_NONE is not set
# CONFIG_SCTP_HMAC_SHA1 is not set
CONFIG_SCTP_HMAC_MD5=3Dy
# CONFIG_TIPC is not set
# CONFIG_ATM is not set
CONFIG_BRIDGE=3Dm
CONFIG_VLAN_8021Q=3Dm
# CONFIG_DECNET is not set
CONFIG_LLC=3Dm
CONFIG_LLC2=3Dm
# CONFIG_IPX is not set
# CONFIG_ATALK is not set
CONFIG_X25=3Dm
# CONFIG_LAPB is not set
# CONFIG_ECONET is not set
# CONFIG_WAN_ROUTER is not set

#
# QoS and/or fair queueing
#
# CONFIG_NET_SCHED is not set
CONFIG_NET_CLS_ROUTE=3Dy

#
# Network testing
#
# CONFIG_NET_PKTGEN is not set
# CONFIG_NET_TCPPROBE is not set
# CONFIG_HAMRADIO is not set
# CONFIG_IRDA is not set
# CONFIG_BT is not set
# CONFIG_AF_RXRPC is not set
CONFIG_FIB_RULES=3Dy

#
# Wireless
#
# CONFIG_CFG80211 is not set
# CONFIG_WIRELESS_EXT is not set
# CONFIG_MAC80211 is not set
# CONFIG_IEEE80211 is not set
# CONFIG_RFKILL is not set
# CONFIG_NET_9P is not set

#
# Device Drivers
#

#
# Generic Driver Options
#
CONFIG_UEVENT_HELPER_PATH=3D"/sbin/hotplug"
# CONFIG_STANDALONE is not set
CONFIG_PREVENT_FIRMWARE_BUILD=3Dy
CONFIG_FW_LOADER=3Dm
# CONFIG_DEBUG_DRIVER is not set
# CONFIG_DEBUG_DEVRES is not set
# CONFIG_SYS_HYPERVISOR is not set
# CONFIG_CONNECTOR is not set
# CONFIG_MTD is not set
CONFIG_PARPORT=3Dm
CONFIG_PARPORT_PC=3Dm
CONFIG_PARPORT_SERIAL=3Dm
CONFIG_PARPORT_PC_FIFO=3Dy
CONFIG_PARPORT_PC_SUPERIO=3Dy
# CONFIG_PARPORT_GSC is not set
CONFIG_PARPORT_AX88796=3Dm
CONFIG_PARPORT_1284=3Dy
CONFIG_PARPORT_NOT_PC=3Dy
CONFIG_PNP=3Dy
# CONFIG_PNP_DEBUG is not set

#
# Protocols
#
CONFIG_PNPACPI=3Dy
CONFIG_BLK_DEV=3Dy
CONFIG_BLK_DEV_FD=3Dy
# CONFIG_PARIDE is not set
CONFIG_BLK_CPQ_DA=3Dm
CONFIG_BLK_CPQ_CISS_DA=3Dm
CONFIG_CISS_SCSI_TAPE=3Dy
CONFIG_BLK_DEV_DAC960=3Dm
CONFIG_BLK_DEV_UMEM=3Dm
# CONFIG_BLK_DEV_COW_COMMON is not set
CONFIG_BLK_DEV_LOOP=3Dm
CONFIG_BLK_DEV_CRYPTOLOOP=3Dm
CONFIG_BLK_DEV_NBD=3Dm
CONFIG_BLK_DEV_SX8=3Dm
# CONFIG_BLK_DEV_UB is not set
CONFIG_BLK_DEV_RAM=3Dy
CONFIG_BLK_DEV_RAM_COUNT=3D16
CONFIG_BLK_DEV_RAM_SIZE=3D64000
CONFIG_BLK_DEV_RAM_BLOCKSIZE=3D1024
CONFIG_CDROM_PKTCDVD=3Dm
CONFIG_CDROM_PKTCDVD_BUFFERS=3D8
CONFIG_CDROM_PKTCDVD_WCACHE=3Dy
CONFIG_ATA_OVER_ETH=3Dm
CONFIG_XEN_BLKDEV_FRONTEND=3Dy
CONFIG_MISC_DEVICES=3Dy
# CONFIG_IBM_ASM is not set
# CONFIG_PHANTOM is not set
CONFIG_EEPROM_93CX6=3Dm
# CONFIG_SGI_IOC4 is not set
# CONFIG_TIFM_CORE is not set
# CONFIG_ASUS_LAPTOP is not set
# CONFIG_FUJITSU_LAPTOP is not set
# CONFIG_MSI_LAPTOP is not set
# CONFIG_SONY_LAPTOP is not set
# CONFIG_THINKPAD_ACPI is not set
# CONFIG_IDE is not set

#
# SCSI device support
#
CONFIG_RAID_ATTRS=3Dm
CONFIG_SCSI=3Dm
CONFIG_SCSI_DMA=3Dy
# CONFIG_SCSI_TGT is not set
CONFIG_SCSI_NETLINK=3Dy
CONFIG_SCSI_PROC_FS=3Dy

#
# SCSI support type (disk, tape, CD-ROM)
#
CONFIG_BLK_DEV_SD=3Dm
CONFIG_CHR_DEV_ST=3Dm
CONFIG_CHR_DEV_OSST=3Dm
CONFIG_BLK_DEV_SR=3Dm
# CONFIG_BLK_DEV_SR_VENDOR is not set
CONFIG_CHR_DEV_SG=3Dm
CONFIG_CHR_DEV_SCH=3Dm

#
# Some SCSI devices (e.g. CD jukebox) support multiple LUNs
#
CONFIG_SCSI_MULTI_LUN=3Dy
CONFIG_SCSI_CONSTANTS=3Dy
CONFIG_SCSI_LOGGING=3Dy
CONFIG_SCSI_SCAN_ASYNC=3Dy
CONFIG_SCSI_WAIT_SCAN=3Dm

#
# SCSI Transports
#
CONFIG_SCSI_SPI_ATTRS=3Dm
CONFIG_SCSI_FC_ATTRS=3Dm
CONFIG_SCSI_ISCSI_ATTRS=3Dm
CONFIG_SCSI_SAS_ATTRS=3Dm
CONFIG_SCSI_SAS_LIBSAS=3Dm
CONFIG_SCSI_SAS_ATA=3Dy
CONFIG_SCSI_SAS_LIBSAS_DEBUG=3Dy
CONFIG_SCSI_SRP_ATTRS=3Dm
CONFIG_SCSI_LOWLEVEL=3Dy
CONFIG_ISCSI_TCP=3Dm
CONFIG_BLK_DEV_3W_XXXX_RAID=3Dm
CONFIG_SCSI_3W_9XXX=3Dm
CONFIG_SCSI_ACARD=3Dm
CONFIG_SCSI_AACRAID=3Dm
CONFIG_SCSI_AIC7XXX=3Dm
CONFIG_AIC7XXX_CMDS_PER_DEVICE=3D32
CONFIG_AIC7XXX_RESET_DELAY_MS=3D5000
# CONFIG_AIC7XXX_DEBUG_ENABLE is not set
CONFIG_AIC7XXX_DEBUG_MASK=3D0
CONFIG_AIC7XXX_REG_PRETTY_PRINT=3Dy
CONFIG_SCSI_AIC7XXX_OLD=3Dm
CONFIG_SCSI_AIC79XX=3Dm
CONFIG_AIC79XX_CMDS_PER_DEVICE=3D32
CONFIG_AIC79XX_RESET_DELAY_MS=3D15000
# CONFIG_AIC79XX_DEBUG_ENABLE is not set
CONFIG_AIC79XX_DEBUG_MASK=3D0
CONFIG_AIC79XX_REG_PRETTY_PRINT=3Dy
CONFIG_SCSI_AIC94XX=3Dm
CONFIG_AIC94XX_DEBUG=3Dy
CONFIG_SCSI_DPT_I2O=3Dm
CONFIG_SCSI_ADVANSYS=3Dm
CONFIG_SCSI_ARCMSR=3Dm
CONFIG_SCSI_ARCMSR_AER=3Dy
CONFIG_MEGARAID_NEWGEN=3Dy
CONFIG_MEGARAID_MM=3Dm
CONFIG_MEGARAID_MAILBOX=3Dm
CONFIG_MEGARAID_LEGACY=3Dm
CONFIG_MEGARAID_SAS=3Dm
CONFIG_SCSI_HPTIOP=3Dm
CONFIG_SCSI_BUSLOGIC=3Dm
# CONFIG_SCSI_OMIT_FLASHPOINT is not set
CONFIG_SCSI_DMX3191D=3Dm
CONFIG_SCSI_EATA=3Dm
CONFIG_SCSI_EATA_TAGGED_QUEUE=3Dy
CONFIG_SCSI_EATA_LINKED_COMMANDS=3Dy
CONFIG_SCSI_EATA_MAX_TAGS=3D16
CONFIG_SCSI_FUTURE_DOMAIN=3Dm
CONFIG_SCSI_GDTH=3Dm
CONFIG_SCSI_IPS=3Dm
CONFIG_SCSI_INITIO=3Dm
CONFIG_SCSI_INIA100=3Dm
CONFIG_SCSI_PPA=3Dm
CONFIG_SCSI_IMM=3Dm
# CONFIG_SCSI_IZIP_EPP16 is not set
# CONFIG_SCSI_IZIP_SLOW_CTR is not set
CONFIG_SCSI_STEX=3Dm
CONFIG_SCSI_SYM53C8XX_2=3Dm
CONFIG_SCSI_SYM53C8XX_DMA_ADDRESSING_MODE=3D1
CONFIG_SCSI_SYM53C8XX_DEFAULT_TAGS=3D16
CONFIG_SCSI_SYM53C8XX_MAX_TAGS=3D64
CONFIG_SCSI_SYM53C8XX_MMIO=3Dy
CONFIG_SCSI_IPR=3Dm
CONFIG_SCSI_IPR_TRACE=3Dy
CONFIG_SCSI_IPR_DUMP=3Dy
CONFIG_SCSI_QLOGIC_1280=3Dm
CONFIG_SCSI_QLA_FC=3Dm
CONFIG_SCSI_QLA_ISCSI=3Dm
CONFIG_SCSI_LPFC=3Dm
CONFIG_SCSI_DC395x=3Dm
CONFIG_SCSI_DC390T=3Dm
CONFIG_SCSI_NSP32=3Dm
CONFIG_SCSI_DEBUG=3Dm
# CONFIG_SCSI_SRP is not set
CONFIG_ATA=3Dm
# CONFIG_ATA_NONSTANDARD is not set
CONFIG_ATA_ACPI=3Dy
CONFIG_SATA_AHCI=3Dm
CONFIG_SATA_SVW=3Dm
CONFIG_ATA_PIIX=3Dm
CONFIG_SATA_MV=3Dm
CONFIG_SATA_NV=3Dm
CONFIG_PDC_ADMA=3Dm
CONFIG_SATA_QSTOR=3Dm
CONFIG_SATA_PROMISE=3Dm
CONFIG_SATA_SX4=3Dm
CONFIG_SATA_SIL=3Dm
CONFIG_SATA_SIL24=3Dm
CONFIG_SATA_SIS=3Dm
CONFIG_SATA_ULI=3Dm
CONFIG_SATA_VIA=3Dm
CONFIG_SATA_VITESSE=3Dm
CONFIG_SATA_INIC162X=3Dm
CONFIG_PATA_ALI=3Dm
CONFIG_PATA_AMD=3Dm
CONFIG_PATA_ARTOP=3Dm
CONFIG_PATA_ATIIXP=3Dm
CONFIG_PATA_CMD640_PCI=3Dm
CONFIG_PATA_CMD64X=3Dm
CONFIG_PATA_CS5520=3Dm
CONFIG_PATA_CS5530=3Dm
CONFIG_PATA_CS5535=3Dm
CONFIG_PATA_CYPRESS=3Dm
CONFIG_PATA_EFAR=3Dm
# CONFIG_ATA_GENERIC is not set
CONFIG_PATA_HPT366=3Dm
CONFIG_PATA_HPT37X=3Dm
CONFIG_PATA_HPT3X2N=3Dm
CONFIG_PATA_HPT3X3=3Dm
# CONFIG_PATA_HPT3X3_DMA is not set
CONFIG_PATA_IT821X=3Dm
CONFIG_PATA_IT8213=3Dm
CONFIG_PATA_JMICRON=3Dm
CONFIG_PATA_TRIFLEX=3Dm
CONFIG_PATA_MARVELL=3Dm
CONFIG_PATA_MPIIX=3Dm
# CONFIG_PATA_OLDPIIX is not set
CONFIG_PATA_NETCELL=3Dm
CONFIG_PATA_NS87410=3Dm
CONFIG_PATA_OPTI=3Dm
CONFIG_PATA_OPTIDMA=3Dm
CONFIG_PATA_PDC_OLD=3Dm
CONFIG_PATA_RADISYS=3Dm
CONFIG_PATA_RZ1000=3Dm
CONFIG_PATA_SC1200=3Dm
CONFIG_PATA_SERVERWORKS=3Dm
CONFIG_PATA_PDC2027X=3Dm
CONFIG_PATA_SIL680=3Dm
CONFIG_PATA_SIS=3Dm
CONFIG_PATA_VIA=3Dm
CONFIG_PATA_WINBOND=3Dm
CONFIG_MD=3Dy
CONFIG_BLK_DEV_MD=3Dy
CONFIG_MD_LINEAR=3Dm
CONFIG_MD_RAID0=3Dm
CONFIG_MD_RAID1=3Dm
CONFIG_MD_RAID10=3Dm
CONFIG_MD_RAID456=3Dm
CONFIG_MD_RAID5_RESHAPE=3Dy
CONFIG_MD_MULTIPATH=3Dm
CONFIG_MD_FAULTY=3Dm
CONFIG_BLK_DEV_DM=3Dm
# CONFIG_DM_DEBUG is not set
CONFIG_DM_CRYPT=3Dm
CONFIG_DM_SNAPSHOT=3Dm
CONFIG_DM_MIRROR=3Dm
CONFIG_DM_ZERO=3Dm
CONFIG_DM_MULTIPATH=3Dm
CONFIG_DM_MULTIPATH_EMC=3Dm
CONFIG_DM_MULTIPATH_RDAC=3Dm
# CONFIG_DM_DELAY is not set
CONFIG_FUSION=3Dy
CONFIG_FUSION_SPI=3Dm
CONFIG_FUSION_FC=3Dm
CONFIG_FUSION_SAS=3Dm
CONFIG_FUSION_MAX_SGE=3D128
CONFIG_FUSION_CTL=3Dm
# CONFIG_FUSION_LOGGING is not set

#
# IEEE 1394 (FireWire) support
#
CONFIG_FIREWIRE=3Dm
CONFIG_FIREWIRE_OHCI=3Dm
CONFIG_FIREWIRE_SBP2=3Dm
# CONFIG_IEEE1394 is not set
CONFIG_I2O=3Dm
CONFIG_I2O_LCT_NOTIFY_ON_CHANGES=3Dy
CONFIG_I2O_EXT_ADAPTEC=3Dy
CONFIG_I2O_CONFIG=3Dm
CONFIG_I2O_CONFIG_OLD_IOCTL=3Dy
CONFIG_I2O_BUS=3Dm
CONFIG_I2O_BLOCK=3Dm
CONFIG_I2O_SCSI=3Dm
CONFIG_I2O_PROC=3Dm
# CONFIG_MACINTOSH_DRIVERS is not set
CONFIG_NETDEVICES=3Dy
# CONFIG_NETDEVICES_MULTIQUEUE is not set
CONFIG_DUMMY=3Dm
CONFIG_BONDING=3Dm
CONFIG_MACVLAN=3Dm
CONFIG_EQUALIZER=3Dm
CONFIG_TUN=3Dm
CONFIG_VETH=3Dm
# CONFIG_NET_SB1000 is not set
CONFIG_IP1000=3Dm
# CONFIG_ARCNET is not set
CONFIG_PHYLIB=3Dm

#
# MII PHY device drivers
#
CONFIG_MARVELL_PHY=3Dm
CONFIG_DAVICOM_PHY=3Dm
CONFIG_QSEMI_PHY=3Dm
CONFIG_LXT_PHY=3Dm
CONFIG_CICADA_PHY=3Dm
CONFIG_VITESSE_PHY=3Dm
CONFIG_SMSC_PHY=3Dm
CONFIG_BROADCOM_PHY=3Dm
CONFIG_ICPLUS_PHY=3Dm
CONFIG_FIXED_PHY=3Dm
CONFIG_FIXED_MII_10_FDX=3Dy
CONFIG_FIXED_MII_100_FDX=3Dy
CONFIG_FIXED_MII_1000_FDX=3Dy
CONFIG_FIXED_MII_AMNT=3D1
CONFIG_NET_ETHERNET=3Dy
CONFIG_MII=3Dm
CONFIG_HAPPYMEAL=3Dm
CONFIG_SUNGEM=3Dm
CONFIG_CASSINI=3Dm
CONFIG_NET_VENDOR_3COM=3Dy
CONFIG_VORTEX=3Dm
CONFIG_TYPHOON=3Dm
CONFIG_NET_TULIP=3Dy
CONFIG_DE2104X=3Dm
CONFIG_TULIP=3Dm
# CONFIG_TULIP_MWI is not set
# CONFIG_TULIP_MMIO is not set
CONFIG_TULIP_NAPI=3Dy
CONFIG_TULIP_NAPI_HW_MITIGATION=3Dy
CONFIG_DE4X5=3Dm
CONFIG_WINBOND_840=3Dm
CONFIG_DM9102=3Dm
CONFIG_ULI526X=3Dm
CONFIG_HP100=3Dm
CONFIG_NET_PCI=3Dy
CONFIG_PCNET32=3Dm
# CONFIG_PCNET32_NAPI is not set
CONFIG_AMD8111_ETH=3Dm
# CONFIG_AMD8111E_NAPI is not set
CONFIG_ADAPTEC_STARFIRE=3Dm
CONFIG_ADAPTEC_STARFIRE_NAPI=3Dy
CONFIG_FORCEDETH=3Dm
# CONFIG_FORCEDETH_NAPI is not set
CONFIG_DGRS=3Dm
CONFIG_EEPRO100=3Dm
CONFIG_E100=3Dm
CONFIG_FEALNX=3Dm
CONFIG_NATSEMI=3Dm
CONFIG_NE2K_PCI=3Dm
CONFIG_8139CP=3Dm
CONFIG_8139TOO=3Dm
# CONFIG_8139TOO_PIO is not set
# CONFIG_8139TOO_TUNE_TWISTER is not set
CONFIG_8139TOO_8129=3Dy
# CONFIG_8139_OLD_RX_RESET is not set
CONFIG_SIS900=3Dm
CONFIG_EPIC100=3Dm
CONFIG_SUNDANCE=3Dm
# CONFIG_SUNDANCE_MMIO is not set
CONFIG_TLAN=3Dm
CONFIG_VIA_RHINE=3Dm
# CONFIG_VIA_RHINE_MMIO is not set
CONFIG_VIA_RHINE_NAPI=3Dy
CONFIG_SC92031=3Dm
# CONFIG_NET_POCKET is not set
CONFIG_NETDEV_1000=3Dy
CONFIG_ACENIC=3Dm
# CONFIG_ACENIC_OMIT_TIGON_I is not set
CONFIG_DL2K=3Dm
CONFIG_E1000=3Dy
CONFIG_E1000_NAPI=3Dy
# CONFIG_E1000_DISABLE_PACKET_SPLIT is not set
# CONFIG_E1000E is not set
CONFIG_NS83820=3Dm
CONFIG_HAMACHI=3Dm
CONFIG_YELLOWFIN=3Dm
CONFIG_R8169=3Dm
CONFIG_R8169_NAPI=3Dy
CONFIG_R8169_VLAN=3Dy
CONFIG_SIS190=3Dm
CONFIG_SKGE=3Dm
CONFIG_SKY2=3Dm
# CONFIG_SKY2_DEBUG is not set
# CONFIG_SK98LIN is not set
CONFIG_VIA_VELOCITY=3Dm
CONFIG_TIGON3=3Dm
CONFIG_BNX2=3Dm
CONFIG_QLA3XXX=3Dm
CONFIG_ATL1=3Dm
# CONFIG_NETDEV_10000 is not set
# CONFIG_TR is not set

#
# Wireless LAN
#
# CONFIG_WLAN_PRE80211 is not set
# CONFIG_WLAN_80211 is not set

#
# USB Network Adapters
#
# CONFIG_USB_CATC is not set
# CONFIG_USB_KAWETH is not set
# CONFIG_USB_PEGASUS is not set
# CONFIG_USB_RTL8150 is not set
# CONFIG_USB_USBNET_MII is not set
# CONFIG_USB_USBNET is not set
# CONFIG_WAN is not set
CONFIG_XEN_NETDEV_FRONTEND=3Dy
# CONFIG_FDDI is not set
# CONFIG_HIPPI is not set
# CONFIG_PLIP is not set
CONFIG_PPP=3Dm
CONFIG_PPP_MULTILINK=3Dy
CONFIG_PPP_FILTER=3Dy
CONFIG_PPP_ASYNC=3Dm
CONFIG_PPP_SYNC_TTY=3Dm
CONFIG_PPP_DEFLATE=3Dm
CONFIG_PPP_BSDCOMP=3Dm
CONFIG_PPP_MPPE=3Dm
CONFIG_PPPOE=3Dm
CONFIG_PPPOL2TP=3Dm
CONFIG_SLIP=3Dm
CONFIG_SLIP_COMPRESSED=3Dy
CONFIG_SLHC=3Dm
CONFIG_SLIP_SMART=3Dy
CONFIG_SLIP_MODE_SLIP6=3Dy
# CONFIG_NET_FC is not set
CONFIG_SHAPER=3Dm
CONFIG_NETCONSOLE=3Dy
# CONFIG_NETCONSOLE_DYNAMIC is not set
CONFIG_NETPOLL=3Dy
CONFIG_NETPOLL_TRAP=3Dy
CONFIG_NET_POLL_CONTROLLER=3Dy
CONFIG_ISDN=3Dm
CONFIG_ISDN_I4L=3Dm
CONFIG_ISDN_PPP=3Dy
CONFIG_ISDN_PPP_VJ=3Dy
CONFIG_ISDN_MPP=3Dy
CONFIG_IPPP_FILTER=3Dy
CONFIG_ISDN_PPP_BSDCOMP=3Dm
CONFIG_ISDN_AUDIO=3Dy
CONFIG_ISDN_TTY_FAX=3Dy
CONFIG_ISDN_X25=3Dy

#
# ISDN feature submodules
#
CONFIG_ISDN_DIVERSION=3Dm

#
# ISDN4Linux hardware drivers
#

#
# Passive cards
#
CONFIG_ISDN_DRV_HISAX=3Dm

#
# D-channel protocol features
#
CONFIG_HISAX_EURO=3Dy
CONFIG_DE_AOC=3Dy
# CONFIG_HISAX_NO_SENDCOMPLETE is not set
# CONFIG_HISAX_NO_LLC is not set
# CONFIG_HISAX_NO_KEYPAD is not set
CONFIG_HISAX_1TR6=3Dy
CONFIG_HISAX_NI1=3Dy
CONFIG_HISAX_MAX_CARDS=3D8

#
# HiSax supported cards
#
CONFIG_HISAX_16_3=3Dy
CONFIG_HISAX_TELESPCI=3Dy
CONFIG_HISAX_S0BOX=3Dy
CONFIG_HISAX_FRITZPCI=3Dy
CONFIG_HISAX_AVM_A1_PCMCIA=3Dy
CONFIG_HISAX_ELSA=3Dy
CONFIG_HISAX_DIEHLDIVA=3Dy
CONFIG_HISAX_SEDLBAUER=3Dy
CONFIG_HISAX_NETJET=3Dy
CONFIG_HISAX_NETJET_U=3Dy
CONFIG_HISAX_NICCY=3Dy
CONFIG_HISAX_BKM_A4T=3Dy
CONFIG_HISAX_SCT_QUADRO=3Dy
CONFIG_HISAX_GAZEL=3Dy
CONFIG_HISAX_HFC_PCI=3Dy
CONFIG_HISAX_W6692=3Dy
CONFIG_HISAX_HFC_SX=3Dy
CONFIG_HISAX_ENTERNOW_PCI=3Dy
CONFIG_HISAX_DEBUG=3Dy

#
# HiSax PCMCIA card service modules
#

#
# HiSax sub driver modules
#
CONFIG_HISAX_ST5481=3Dm
CONFIG_HISAX_HFCUSB=3Dm
CONFIG_HISAX_HFC4S8S=3Dm
CONFIG_HISAX_FRITZ_PCIPNP=3Dm
CONFIG_HISAX_HDLC=3Dy

#
# Active cards
#
# CONFIG_HYSDN is not set
CONFIG_ISDN_DRV_GIGASET=3Dm
CONFIG_GIGASET_BASE=3Dm
CONFIG_GIGASET_M105=3Dm
CONFIG_GIGASET_M101=3Dm
CONFIG_GIGASET_DEBUG=3Dy
CONFIG_GIGASET_UNDOCREQ=3Dy
CONFIG_ISDN_CAPI=3Dm
CONFIG_ISDN_DRV_AVMB1_VERBOSE_REASON=3Dy
CONFIG_CAPI_TRACE=3Dy
CONFIG_ISDN_CAPI_MIDDLEWARE=3Dy
CONFIG_ISDN_CAPI_CAPI20=3Dm
CONFIG_ISDN_CAPI_CAPIFS_BOOL=3Dy
CONFIG_ISDN_CAPI_CAPIFS=3Dm
CONFIG_ISDN_CAPI_CAPIDRV=3Dm

#
# CAPI hardware drivers
#
CONFIG_CAPI_AVM=3Dy
CONFIG_ISDN_DRV_AVMB1_B1PCI=3Dm
CONFIG_ISDN_DRV_AVMB1_B1PCIV4=3Dy
CONFIG_ISDN_DRV_AVMB1_B1PCMCIA=3Dm
CONFIG_ISDN_DRV_AVMB1_T1PCI=3Dm
CONFIG_ISDN_DRV_AVMB1_C4=3Dm
CONFIG_CAPI_EICON=3Dy
CONFIG_ISDN_DIVAS=3Dm
CONFIG_ISDN_DIVAS_BRIPCI=3Dy
CONFIG_ISDN_DIVAS_PRIPCI=3Dy
CONFIG_ISDN_DIVAS_DIVACAPI=3Dm
CONFIG_ISDN_DIVAS_USERIDI=3Dm
CONFIG_ISDN_DIVAS_MAINT=3Dm
CONFIG_PHONE=3Dm
CONFIG_PHONE_IXJ=3Dm

#
# Input device support
#
CONFIG_INPUT=3Dy
# CONFIG_INPUT_FF_MEMLESS is not set
CONFIG_INPUT_POLLDEV=3Dm

#
# Userland interfaces
#
CONFIG_INPUT_MOUSEDEV=3Dy
CONFIG_INPUT_MOUSEDEV_PSAUX=3Dy
CONFIG_INPUT_MOUSEDEV_SCREEN_X=3D1024
CONFIG_INPUT_MOUSEDEV_SCREEN_Y=3D768
CONFIG_INPUT_JOYDEV=3Dm
CONFIG_INPUT_TSDEV=3Dm
CONFIG_INPUT_TSDEV_SCREEN_X=3D240
CONFIG_INPUT_TSDEV_SCREEN_Y=3D320
CONFIG_INPUT_EVDEV=3Dy
# CONFIG_INPUT_EVBUG is not set

#
# Input Device Drivers
#
CONFIG_INPUT_KEYBOARD=3Dy
CONFIG_KEYBOARD_ATKBD=3Dy
CONFIG_KEYBOARD_SUNKBD=3Dm
# CONFIG_KEYBOARD_LKKBD is not set
CONFIG_KEYBOARD_XTKBD=3Dm
CONFIG_KEYBOARD_NEWTON=3Dm
# CONFIG_KEYBOARD_STOWAWAY is not set
CONFIG_INPUT_MOUSE=3Dy
CONFIG_MOUSE_PS2=3Dy
CONFIG_MOUSE_PS2_ALPS=3Dy
CONFIG_MOUSE_PS2_LOGIPS2PP=3Dy
CONFIG_MOUSE_PS2_SYNAPTICS=3Dy
CONFIG_MOUSE_PS2_LIFEBOOK=3Dy
CONFIG_MOUSE_PS2_TRACKPOINT=3Dy
# CONFIG_MOUSE_PS2_TOUCHKIT is not set
CONFIG_MOUSE_SERIAL=3Dm
# CONFIG_MOUSE_APPLETOUCH is not set
# CONFIG_MOUSE_VSXXXAA is not set
# CONFIG_INPUT_JOYSTICK is not set
# CONFIG_INPUT_TABLET is not set
# CONFIG_INPUT_TOUCHSCREEN is not set
CONFIG_INPUT_MISC=3Dy
CONFIG_INPUT_PCSPKR=3Dy
CONFIG_INPUT_WISTRON_BTNS=3Dm
# CONFIG_INPUT_ATLAS_BTNS is not set
# CONFIG_INPUT_ATI_REMOTE is not set
# CONFIG_INPUT_ATI_REMOTE2 is not set
# CONFIG_INPUT_KEYSPAN_REMOTE is not set
# CONFIG_INPUT_POWERMATE is not set
# CONFIG_INPUT_YEALINK is not set
CONFIG_INPUT_UINPUT=3Dm

#
# Hardware I/O ports
#
CONFIG_SERIO=3Dy
CONFIG_SERIO_I8042=3Dy
CONFIG_SERIO_SERPORT=3Dm
CONFIG_SERIO_CT82C710=3Dm
CONFIG_SERIO_PARKBD=3Dm
CONFIG_SERIO_PCIPS2=3Dm
CONFIG_SERIO_LIBPS2=3Dy
CONFIG_SERIO_RAW=3Dm
CONFIG_GAMEPORT=3Dm
CONFIG_GAMEPORT_NS558=3Dm
CONFIG_GAMEPORT_L4=3Dm
CONFIG_GAMEPORT_EMU10K1=3Dm
CONFIG_GAMEPORT_FM801=3Dm

#
# Character devices
#
CONFIG_VT=3Dy
CONFIG_VT_UNICODE=3Dy
CONFIG_VT_CONSOLE=3Dy
CONFIG_HW_CONSOLE=3Dy
CONFIG_VT_HW_CONSOLE_BINDING=3Dy
# CONFIG_SERIAL_NONSTANDARD is not set
# CONFIG_NOZOMI is not set

#
# Serial drivers
#
CONFIG_SERIAL_8250=3Dy
CONFIG_SERIAL_8250_CONSOLE=3Dy
CONFIG_FIX_EARLYCON_MEM=3Dy
CONFIG_SERIAL_8250_PCI=3Dy
CONFIG_SERIAL_8250_PNP=3Dy
CONFIG_SERIAL_8250_NR_UARTS=3D4
CONFIG_SERIAL_8250_RUNTIME_UARTS=3D4
CONFIG_SERIAL_8250_EXTENDED=3Dy
CONFIG_SERIAL_8250_MANY_PORTS=3Dy
CONFIG_SERIAL_8250_SHARE_IRQ=3Dy
# CONFIG_SERIAL_8250_DETECT_IRQ is not set
CONFIG_SERIAL_8250_RSA=3Dy

#
# Non-8250 serial port support
#
CONFIG_SERIAL_CORE=3Dy
CONFIG_SERIAL_CORE_CONSOLE=3Dy
# CONFIG_SERIAL_JSM is not set
CONFIG_UNIX98_PTYS=3Dy
CONFIG_LEGACY_PTYS=3Dy
CONFIG_LEGACY_PTY_COUNT=3D256
CONFIG_PRINTER=3Dm
# CONFIG_LP_CONSOLE is not set
# CONFIG_PPDEV is not set
# CONFIG_TIPAR is not set
CONFIG_HVC_DRIVER=3Dy
CONFIG_HVC_XEN=3Dy
CONFIG_IPMI_HANDLER=3Dm
CONFIG_IPMI_PANIC_EVENT=3Dy
CONFIG_IPMI_PANIC_STRING=3Dy
CONFIG_IPMI_DEVICE_INTERFACE=3Dm
CONFIG_IPMI_SI=3Dm
CONFIG_IPMI_WATCHDOG=3Dm
CONFIG_IPMI_POWEROFF=3Dm
CONFIG_HW_RANDOM=3Dy
CONFIG_HW_RANDOM_INTEL=3Dm
CONFIG_HW_RANDOM_AMD=3Dm
CONFIG_HW_RANDOM_GEODE=3Dm
CONFIG_HW_RANDOM_VIA=3Dm
CONFIG_NVRAM=3Dm
CONFIG_RTC=3Dy
CONFIG_R3964=3Dm
CONFIG_APPLICOM=3Dm
CONFIG_SONYPI=3Dm
CONFIG_AGP=3Dm
CONFIG_AGP_ALI=3Dm
CONFIG_AGP_ATI=3Dm
CONFIG_AGP_AMD=3Dm
CONFIG_AGP_AMD64=3Dm
CONFIG_AGP_INTEL=3Dm
CONFIG_AGP_NVIDIA=3Dm
CONFIG_AGP_SIS=3Dm
CONFIG_AGP_SWORKS=3Dm
CONFIG_AGP_VIA=3Dm
CONFIG_AGP_EFFICEON=3Dm
CONFIG_DRM=3Dm
CONFIG_DRM_TDFX=3Dm
CONFIG_DRM_R128=3Dm
CONFIG_DRM_RADEON=3Dm
CONFIG_DRM_I810=3Dm
CONFIG_DRM_I830=3Dm
CONFIG_DRM_I915=3Dm
CONFIG_DRM_MGA=3Dm
CONFIG_DRM_SIS=3Dm
CONFIG_DRM_VIA=3Dm
CONFIG_DRM_SAVAGE=3Dm
CONFIG_MWAVE=3Dm
CONFIG_PC8736x_GPIO=3Dm
CONFIG_NSC_GPIO=3Dm
CONFIG_CS5535_GPIO=3Dm
CONFIG_RAW_DRIVER=3Dm
CONFIG_MAX_RAW_DEVS=3D4096
CONFIG_HPET=3Dy
# CONFIG_HPET_RTC_IRQ is not set
CONFIG_HPET_MMAP=3Dy
CONFIG_HANGCHECK_TIMER=3Dm
CONFIG_TCG_TPM=3Dm
CONFIG_TCG_TIS=3Dm
CONFIG_TCG_NSC=3Dm
CONFIG_TCG_ATMEL=3Dm
CONFIG_TCG_INFINEON=3Dm
# CONFIG_TELCLOCK is not set
CONFIG_DEVPORT=3Dy
CONFIG_I2C=3Dm
CONFIG_I2C_BOARDINFO=3Dy
CONFIG_I2C_CHARDEV=3Dm

#
# I2C Algorithms
#
CONFIG_I2C_ALGOBIT=3Dm
CONFIG_I2C_ALGOPCF=3Dm
CONFIG_I2C_ALGOPCA=3Dm

#
# I2C Hardware Bus support
#
CONFIG_I2C_ALI1535=3Dm
CONFIG_I2C_ALI1563=3Dm
CONFIG_I2C_ALI15X3=3Dm
CONFIG_I2C_AMD756=3Dm
CONFIG_I2C_AMD756_S4882=3Dm
CONFIG_I2C_AMD8111=3Dm
CONFIG_I2C_I801=3Dm
CONFIG_I2C_I810=3Dm
CONFIG_I2C_PIIX4=3Dm
CONFIG_I2C_NFORCE2=3Dm
CONFIG_I2C_OCORES=3Dm
CONFIG_I2C_PARPORT=3Dm
CONFIG_I2C_PARPORT_LIGHT=3Dm
CONFIG_I2C_PROSAVAGE=3Dm
CONFIG_I2C_SAVAGE4=3Dm
CONFIG_I2C_SIMTEC=3Dm
CONFIG_SCx200_ACB=3Dm
CONFIG_I2C_SIS5595=3Dm
CONFIG_I2C_SIS630=3Dm
CONFIG_I2C_SIS96X=3Dm
CONFIG_I2C_TAOS_EVM=3Dm
CONFIG_I2C_STUB=3Dm
CONFIG_I2C_TINY_USB=3Dm
CONFIG_I2C_VIA=3Dm
CONFIG_I2C_VIAPRO=3Dm
CONFIG_I2C_VOODOO3=3Dm

#
# Miscellaneous I2C Chip support
#
CONFIG_SENSORS_DS1337=3Dm
CONFIG_SENSORS_DS1374=3Dm
CONFIG_DS1682=3Dm
CONFIG_SENSORS_EEPROM=3Dm
CONFIG_SENSORS_PCF8574=3Dm
CONFIG_SENSORS_PCA9539=3Dm
CONFIG_SENSORS_PCF8591=3Dm
CONFIG_SENSORS_MAX6875=3Dm
CONFIG_SENSORS_TSL2550=3Dm
# CONFIG_I2C_DEBUG_CORE is not set
# CONFIG_I2C_DEBUG_ALGO is not set
# CONFIG_I2C_DEBUG_BUS is not set
# CONFIG_I2C_DEBUG_CHIP is not set

#
# SPI support
#
CONFIG_SPI=3Dy
CONFIG_SPI_DEBUG=3Dy
CONFIG_SPI_MASTER=3Dy

#
# SPI Master Controller Drivers
#
CONFIG_SPI_BITBANG=3Dm
CONFIG_SPI_BUTTERFLY=3Dm
CONFIG_SPI_LM70_LLP=3Dm

#
# SPI Protocol Masters
#
CONFIG_SPI_AT25=3Dm
CONFIG_SPI_SPIDEV=3Dm
CONFIG_SPI_TLE62X0=3Dm
CONFIG_W1=3Dm

#
# 1-wire Bus Masters
#
CONFIG_W1_MASTER_MATROX=3Dm
CONFIG_W1_MASTER_DS2490=3Dm
CONFIG_W1_MASTER_DS2482=3Dm

#
# 1-wire Slaves
#
CONFIG_W1_SLAVE_THERM=3Dm
CONFIG_W1_SLAVE_SMEM=3Dm
CONFIG_W1_SLAVE_DS2433=3Dm
CONFIG_W1_SLAVE_DS2433_CRC=3Dy
CONFIG_W1_SLAVE_DS2760=3Dm
CONFIG_POWER_SUPPLY=3Dm
# CONFIG_POWER_SUPPLY_DEBUG is not set
CONFIG_PDA_POWER=3Dm
CONFIG_BATTERY_DS2760=3Dm
CONFIG_HWMON=3Dm
CONFIG_HWMON_VID=3Dm
CONFIG_SENSORS_ABITUGURU=3Dm
CONFIG_SENSORS_ABITUGURU3=3Dm
CONFIG_SENSORS_AD7418=3Dm
CONFIG_SENSORS_ADM1021=3Dm
CONFIG_SENSORS_ADM1025=3Dm
CONFIG_SENSORS_ADM1026=3Dm
CONFIG_SENSORS_ADM1029=3Dm
CONFIG_SENSORS_ADM1031=3Dm
CONFIG_SENSORS_ADM9240=3Dm
CONFIG_SENSORS_ADT7470=3Dm
CONFIG_SENSORS_K8TEMP=3Dm
CONFIG_SENSORS_ASB100=3Dm
CONFIG_SENSORS_ATXP1=3Dm
CONFIG_SENSORS_DS1621=3Dm
CONFIG_SENSORS_F71805F=3Dm
CONFIG_SENSORS_F71882FG=3Dm
CONFIG_SENSORS_F75375S=3Dm
CONFIG_SENSORS_FSCHER=3Dm
CONFIG_SENSORS_FSCPOS=3Dm
CONFIG_SENSORS_GL518SM=3Dm
CONFIG_SENSORS_GL520SM=3Dm
CONFIG_SENSORS_CORETEMP=3Dm
CONFIG_SENSORS_IT87=3Dm
CONFIG_SENSORS_LM63=3Dm
CONFIG_SENSORS_LM70=3Dm
CONFIG_SENSORS_LM75=3Dm
CONFIG_SENSORS_LM77=3Dm
CONFIG_SENSORS_LM78=3Dm
CONFIG_SENSORS_LM80=3Dm
CONFIG_SENSORS_LM83=3Dm
CONFIG_SENSORS_LM85=3Dm
CONFIG_SENSORS_LM87=3Dm
CONFIG_SENSORS_LM90=3Dm
CONFIG_SENSORS_LM92=3Dm
CONFIG_SENSORS_LM93=3Dm
CONFIG_SENSORS_MAX1619=3Dm
CONFIG_SENSORS_MAX6650=3Dm
CONFIG_SENSORS_PC87360=3Dm
CONFIG_SENSORS_PC87427=3Dm
CONFIG_SENSORS_SIS5595=3Dm
CONFIG_SENSORS_DME1737=3Dm
CONFIG_SENSORS_SMSC47M1=3Dm
CONFIG_SENSORS_SMSC47M192=3Dm
CONFIG_SENSORS_SMSC47B397=3Dm
CONFIG_SENSORS_THMC50=3Dm
CONFIG_SENSORS_VIA686A=3Dm
CONFIG_SENSORS_VT1211=3Dm
CONFIG_SENSORS_VT8231=3Dm
CONFIG_SENSORS_W83781D=3Dm
CONFIG_SENSORS_W83791D=3Dm
CONFIG_SENSORS_W83792D=3Dm
CONFIG_SENSORS_W83793=3Dm
CONFIG_SENSORS_W83L785TS=3Dm
CONFIG_SENSORS_W83627HF=3Dm
CONFIG_SENSORS_W83627EHF=3Dm
CONFIG_SENSORS_HDAPS=3Dm
CONFIG_SENSORS_APPLESMC=3Dm
# CONFIG_HWMON_DEBUG_CHIP is not set
# CONFIG_WATCHDOG is not set

#
# Sonics Silicon Backplane
#
CONFIG_SSB_POSSIBLE=3Dy
CONFIG_SSB=3Dm
CONFIG_SSB_PCIHOST_POSSIBLE=3Dy
CONFIG_SSB_PCIHOST=3Dy
# CONFIG_SSB_DEBUG is not set
CONFIG_SSB_DRIVER_PCICORE_POSSIBLE=3Dy
CONFIG_SSB_DRIVER_PCICORE=3Dy

#
# Multifunction device drivers
#
CONFIG_MFD_SM501=3Dm

#
# Multimedia devices
#
# CONFIG_VIDEO_DEV is not set
# CONFIG_DVB_CORE is not set
# CONFIG_DAB is not set

#
# Graphics support
#
CONFIG_BACKLIGHT_LCD_SUPPORT=3Dy
CONFIG_LCD_CLASS_DEVICE=3Dm
CONFIG_LCD_LTV350QV=3Dm
CONFIG_BACKLIGHT_CLASS_DEVICE=3Dy
# CONFIG_BACKLIGHT_PROGEAR is not set

#
# Display device support
#
CONFIG_DISPLAY_SUPPORT=3Dm

#
# Display hardware drivers
#
CONFIG_VGASTATE=3Dm
CONFIG_VIDEO_OUTPUT_CONTROL=3Dm
CONFIG_FB=3Dy
CONFIG_FIRMWARE_EDID=3Dy
CONFIG_FB_DDC=3Dm
CONFIG_FB_CFB_FILLRECT=3Dy
CONFIG_FB_CFB_COPYAREA=3Dy
CONFIG_FB_CFB_IMAGEBLIT=3Dy
# CONFIG_FB_CFB_REV_PIXELS_IN_BYTE is not set
CONFIG_FB_SYS_FILLRECT=3Dm
CONFIG_FB_SYS_COPYAREA=3Dm
CONFIG_FB_SYS_IMAGEBLIT=3Dm
CONFIG_FB_SYS_FOPS=3Dm
CONFIG_FB_DEFERRED_IO=3Dy
CONFIG_FB_SVGALIB=3Dm
# CONFIG_FB_MACMODES is not set
CONFIG_FB_BACKLIGHT=3Dy
CONFIG_FB_MODE_HELPERS=3Dy
CONFIG_FB_TILEBLITTING=3Dy

#
# Frame buffer hardware drivers
#
CONFIG_FB_CIRRUS=3Dm
CONFIG_FB_PM2=3Dm
CONFIG_FB_PM2_FIFO_DISCONNECT=3Dy
CONFIG_FB_CYBER2000=3Dm
CONFIG_FB_ARC=3Dm
# CONFIG_FB_ASILIANT is not set
# CONFIG_FB_IMSTT is not set
CONFIG_FB_VGA16=3Dm
CONFIG_FB_VESA=3Dy
CONFIG_FB_EFI=3Dy
# CONFIG_FB_HECUBA is not set
# CONFIG_FB_HGA is not set
# CONFIG_FB_S1D13XXX is not set
CONFIG_FB_NVIDIA=3Dm
CONFIG_FB_NVIDIA_I2C=3Dy
# CONFIG_FB_NVIDIA_DEBUG is not set
CONFIG_FB_NVIDIA_BACKLIGHT=3Dy
CONFIG_FB_RIVA=3Dm
CONFIG_FB_RIVA_I2C=3Dy
# CONFIG_FB_RIVA_DEBUG is not set
CONFIG_FB_RIVA_BACKLIGHT=3Dy
CONFIG_FB_I810=3Dm
CONFIG_FB_I810_GTF=3Dy
CONFIG_FB_I810_I2C=3Dy
# CONFIG_FB_LE80578 is not set
CONFIG_FB_INTEL=3Dm
# CONFIG_FB_INTEL_DEBUG is not set
CONFIG_FB_INTEL_I2C=3Dy
CONFIG_FB_MATROX=3Dy
CONFIG_FB_MATROX_MILLENIUM=3Dy
CONFIG_FB_MATROX_MYSTIQUE=3Dy
CONFIG_FB_MATROX_G=3Dy
CONFIG_FB_MATROX_I2C=3Dm
CONFIG_FB_MATROX_MAVEN=3Dm
CONFIG_FB_MATROX_MULTIHEAD=3Dy
CONFIG_FB_RADEON=3Dm
CONFIG_FB_RADEON_I2C=3Dy
CONFIG_FB_RADEON_BACKLIGHT=3Dy
# CONFIG_FB_RADEON_DEBUG is not set
# CONFIG_FB_ATY128 is not set
CONFIG_FB_ATY=3Dm
CONFIG_FB_ATY_CT=3Dy
CONFIG_FB_ATY_GENERIC_LCD=3Dy
CONFIG_FB_ATY_GX=3Dy
CONFIG_FB_ATY_BACKLIGHT=3Dy
CONFIG_FB_S3=3Dm
CONFIG_FB_SAVAGE=3Dm
CONFIG_FB_SAVAGE_I2C=3Dy
CONFIG_FB_SAVAGE_ACCEL=3Dy
CONFIG_FB_SIS=3Dm
CONFIG_FB_SIS_300=3Dy
CONFIG_FB_SIS_315=3Dy
# CONFIG_FB_NEOMAGIC is not set
# CONFIG_FB_KYRO is not set
CONFIG_FB_3DFX=3Dm
CONFIG_FB_3DFX_ACCEL=3Dy
CONFIG_FB_VOODOO1=3Dm
# CONFIG_FB_VT8623 is not set
# CONFIG_FB_CYBLA is not set
# CONFIG_FB_TRIDENT is not set
# CONFIG_FB_ARK is not set
# CONFIG_FB_PM3 is not set
# CONFIG_FB_GEODE is not set
# CONFIG_FB_SM501 is not set
# CONFIG_FB_VIRTUAL is not set

#
# Console display driver support
#
CONFIG_VGA_CONSOLE=3Dy
# CONFIG_VGACON_SOFT_SCROLLBACK is not set
CONFIG_VIDEO_SELECT=3Dy
CONFIG_DUMMY_CONSOLE=3Dy
CONFIG_FRAMEBUFFER_CONSOLE=3Dy
CONFIG_FRAMEBUFFER_CONSOLE_DETECT_PRIMARY=3Dy
# CONFIG_FRAMEBUFFER_CONSOLE_ROTATION is not set
CONFIG_FONTS=3Dy
# CONFIG_FONT_8x8 is not set
CONFIG_FONT_8x16=3Dy
# CONFIG_FONT_6x11 is not set
# CONFIG_FONT_7x14 is not set
# CONFIG_FONT_PEARL_8x8 is not set
# CONFIG_FONT_ACORN_8x8 is not set
# CONFIG_FONT_MINI_4x6 is not set
# CONFIG_FONT_SUN8x16 is not set
# CONFIG_FONT_SUN12x22 is not set
# CONFIG_FONT_10x18 is not set
CONFIG_LOGO=3Dy
CONFIG_LOGO_LINUX_MONO=3Dy
CONFIG_LOGO_LINUX_VGA16=3Dy
CONFIG_LOGO_LINUX_CLUT224=3Dy

#
# Sound
#
CONFIG_SOUND=3Dm

#
# Advanced Linux Sound Architecture
#
CONFIG_SND=3Dm
CONFIG_SND_TIMER=3Dm
CONFIG_SND_PCM=3Dm
CONFIG_SND_HWDEP=3Dm
CONFIG_SND_RAWMIDI=3Dm
CONFIG_SND_SEQUENCER=3Dm
CONFIG_SND_SEQ_DUMMY=3Dm
CONFIG_SND_OSSEMUL=3Dy
CONFIG_SND_MIXER_OSS=3Dm
CONFIG_SND_PCM_OSS=3Dm
CONFIG_SND_PCM_OSS_PLUGINS=3Dy
CONFIG_SND_SEQUENCER_OSS=3Dy
CONFIG_SND_RTCTIMER=3Dm
CONFIG_SND_SEQ_RTCTIMER_DEFAULT=3Dy
CONFIG_SND_DYNAMIC_MINORS=3Dy
CONFIG_SND_SUPPORT_OLD_API=3Dy
CONFIG_SND_VERBOSE_PROCFS=3Dy
CONFIG_SND_VERBOSE_PRINTK=3Dy
CONFIG_SND_DEBUG=3Dy
# CONFIG_SND_DEBUG_DETECT is not set
# CONFIG_SND_PCM_XRUN_DEBUG is not set

#
# Generic devices
#
CONFIG_SND_MPU401_UART=3Dm
CONFIG_SND_OPL3_LIB=3Dm
CONFIG_SND_VX_LIB=3Dm
CONFIG_SND_AC97_CODEC=3Dm
CONFIG_SND_DUMMY=3Dm
CONFIG_SND_VIRMIDI=3Dm
CONFIG_SND_MTPAV=3Dm
# CONFIG_SND_MTS64 is not set
CONFIG_SND_SERIAL_U16550=3Dm
CONFIG_SND_MPU401=3Dm
# CONFIG_SND_PORTMAN2X4 is not set
CONFIG_SND_SB_COMMON=3Dm
CONFIG_SND_SB16_DSP=3Dm

#
# PCI devices
#
CONFIG_SND_AD1889=3Dm
CONFIG_SND_ALS300=3Dm
CONFIG_SND_ALS4000=3Dm
CONFIG_SND_ALI5451=3Dm
CONFIG_SND_ATIIXP=3Dm
CONFIG_SND_ATIIXP_MODEM=3Dm
CONFIG_SND_AU8810=3Dm
CONFIG_SND_AU8820=3Dm
CONFIG_SND_AU8830=3Dm
CONFIG_SND_AZT3328=3Dm
CONFIG_SND_BT87X=3Dm
# CONFIG_SND_BT87X_OVERCLOCK is not set
CONFIG_SND_CA0106=3Dm
CONFIG_SND_CMIPCI=3Dm
CONFIG_SND_CS4281=3Dm
CONFIG_SND_CS46XX=3Dm
CONFIG_SND_CS46XX_NEW_DSP=3Dy
CONFIG_SND_CS5530=3Dm
CONFIG_SND_CS5535AUDIO=3Dm
CONFIG_SND_DARLA20=3Dm
CONFIG_SND_GINA20=3Dm
CONFIG_SND_LAYLA20=3Dm
CONFIG_SND_DARLA24=3Dm
CONFIG_SND_GINA24=3Dm
CONFIG_SND_LAYLA24=3Dm
CONFIG_SND_MONA=3Dm
CONFIG_SND_MIA=3Dm
CONFIG_SND_ECHO3G=3Dm
CONFIG_SND_INDIGO=3Dm
CONFIG_SND_INDIGOIO=3Dm
CONFIG_SND_INDIGODJ=3Dm
CONFIG_SND_EMU10K1=3Dm
CONFIG_SND_EMU10K1X=3Dm
CONFIG_SND_ENS1370=3Dm
CONFIG_SND_ENS1371=3Dm
CONFIG_SND_ES1938=3Dm
CONFIG_SND_ES1968=3Dm
CONFIG_SND_FM801=3Dm
# CONFIG_SND_FM801_TEA575X_BOOL is not set
CONFIG_SND_HDA_INTEL=3Dm
CONFIG_SND_HDA_HWDEP=3Dy
CONFIG_SND_HDA_CODEC_REALTEK=3Dy
CONFIG_SND_HDA_CODEC_ANALOG=3Dy
CONFIG_SND_HDA_CODEC_SIGMATEL=3Dy
CONFIG_SND_HDA_CODEC_VIA=3Dy
CONFIG_SND_HDA_CODEC_ATIHDMI=3Dy
CONFIG_SND_HDA_CODEC_CONEXANT=3Dy
CONFIG_SND_HDA_CODEC_CMEDIA=3Dy
CONFIG_SND_HDA_CODEC_SI3054=3Dy
CONFIG_SND_HDA_GENERIC=3Dy
# CONFIG_SND_HDA_POWER_SAVE is not set
CONFIG_SND_HDSP=3Dm
CONFIG_SND_HDSPM=3Dm
CONFIG_SND_ICE1712=3Dm
CONFIG_SND_ICE1724=3Dm
CONFIG_SND_INTEL8X0=3Dm
CONFIG_SND_INTEL8X0M=3Dm
CONFIG_SND_KORG1212=3Dm
CONFIG_SND_KORG1212_FIRMWARE_IN_KERNEL=3Dy
CONFIG_SND_MAESTRO3=3Dm
CONFIG_SND_MAESTRO3_FIRMWARE_IN_KERNEL=3Dy
CONFIG_SND_MIXART=3Dm
CONFIG_SND_NM256=3Dm
CONFIG_SND_PCXHR=3Dm
CONFIG_SND_RIPTIDE=3Dm
CONFIG_SND_RME32=3Dm
CONFIG_SND_RME96=3Dm
CONFIG_SND_RME9652=3Dm
CONFIG_SND_SONICVIBES=3Dm
CONFIG_SND_TRIDENT=3Dm
CONFIG_SND_VIA82XX=3Dm
CONFIG_SND_VIA82XX_MODEM=3Dm
CONFIG_SND_VX222=3Dm
CONFIG_SND_YMFPCI=3Dm
CONFIG_SND_YMFPCI_FIRMWARE_IN_KERNEL=3Dy
CONFIG_SND_AC97_POWER_SAVE=3Dy

#
# SPI devices
#

#
# USB devices
#
CONFIG_SND_USB_AUDIO=3Dm
CONFIG_SND_USB_USX2Y=3Dm
CONFIG_SND_USB_CAIAQ=3Dm
CONFIG_SND_USB_CAIAQ_INPUT=3Dy

#
# System on Chip audio support
#
# CONFIG_SND_SOC is not set

#
# SoC Audio support for SuperH
#

#
# Open Sound System
#
# CONFIG_SOUND_PRIME is not set
CONFIG_AC97_BUS=3Dm
CONFIG_HID_SUPPORT=3Dy
CONFIG_HID=3Dy
# CONFIG_HID_DEBUG is not set
# CONFIG_HIDRAW is not set

#
# USB Input Devices
#
CONFIG_USB_HID=3Dm
# CONFIG_USB_HIDINPUT_POWERBOOK is not set
# CONFIG_HID_FF is not set
CONFIG_USB_HIDDEV=3Dy

#
# USB HID Boot Protocol drivers
#
# CONFIG_USB_KBD is not set
# CONFIG_USB_MOUSE is not set
CONFIG_USB_SUPPORT=3Dy
CONFIG_USB_ARCH_HAS_HCD=3Dy
CONFIG_USB_ARCH_HAS_OHCI=3Dy
CONFIG_USB_ARCH_HAS_EHCI=3Dy
CONFIG_USB=3Dm
# CONFIG_USB_DEBUG is not set

#
# Miscellaneous USB options
#
CONFIG_USB_DEVICEFS=3Dy
# CONFIG_USB_DEVICE_CLASS is not set
# CONFIG_USB_DYNAMIC_MINORS is not set
CONFIG_USB_SUSPEND=3Dy
# CONFIG_USB_PERSIST is not set
# CONFIG_USB_OTG is not set

#
# USB Host Controller Drivers
#
CONFIG_USB_EHCI_HCD=3Dm
CONFIG_USB_EHCI_SPLIT_ISO=3Dy
CONFIG_USB_EHCI_ROOT_HUB_TT=3Dy
CONFIG_USB_EHCI_TT_NEWSCHED=3Dy
CONFIG_USB_ISP116X_HCD=3Dm
CONFIG_USB_OHCI_HCD=3Dm
# CONFIG_USB_OHCI_HCD_SSB is not set
# CONFIG_USB_OHCI_BIG_ENDIAN_DESC is not set
# CONFIG_USB_OHCI_BIG_ENDIAN_MMIO is not set
CONFIG_USB_OHCI_LITTLE_ENDIAN=3Dy
CONFIG_USB_UHCI_HCD=3Dm
# CONFIG_USB_U132_HCD is not set
CONFIG_USB_SL811_HCD=3Dm
CONFIG_USB_R8A66597_HCD=3Dm

#
# USB Device Class drivers
#
CONFIG_USB_ACM=3Dm
CONFIG_USB_PRINTER=3Dm

#
# NOTE: USB_STORAGE enables SCSI, and 'SCSI disk support'
#

#
# may also be needed; see USB_STORAGE Help for more information
#
CONFIG_USB_STORAGE=3Dm
# CONFIG_USB_STORAGE_DEBUG is not set
CONFIG_USB_STORAGE_DATAFAB=3Dy
CONFIG_USB_STORAGE_FREECOM=3Dy
CONFIG_USB_STORAGE_DPCM=3Dy
CONFIG_USB_STORAGE_USBAT=3Dy
CONFIG_USB_STORAGE_SDDR09=3Dy
CONFIG_USB_STORAGE_SDDR55=3Dy
CONFIG_USB_STORAGE_JUMPSHOT=3Dy
CONFIG_USB_STORAGE_ALAUDA=3Dy
CONFIG_USB_STORAGE_KARMA=3Dy
CONFIG_USB_LIBUSUAL=3Dy

#
# USB Imaging devices
#
CONFIG_USB_MDC800=3Dm
CONFIG_USB_MICROTEK=3Dm
CONFIG_USB_MON=3Dy

#
# USB port drivers
#
CONFIG_USB_USS720=3Dm

#
# USB Serial Converter support
#
CONFIG_USB_SERIAL=3Dm
CONFIG_USB_SERIAL_GENERIC=3Dy
CONFIG_USB_SERIAL_AIRCABLE=3Dm
CONFIG_USB_SERIAL_AIRPRIME=3Dm
CONFIG_USB_SERIAL_ARK3116=3Dm
CONFIG_USB_SERIAL_BELKIN=3Dm
CONFIG_USB_SERIAL_CH341=3Dm
CONFIG_USB_SERIAL_WHITEHEAT=3Dm
CONFIG_USB_SERIAL_DIGI_ACCELEPORT=3Dm
CONFIG_USB_SERIAL_CP2101=3Dm
CONFIG_USB_SERIAL_CYPRESS_M8=3Dm
CONFIG_USB_SERIAL_EMPEG=3Dm
CONFIG_USB_SERIAL_FTDI_SIO=3Dm
CONFIG_USB_SERIAL_FUNSOFT=3Dm
CONFIG_USB_SERIAL_VISOR=3Dm
CONFIG_USB_SERIAL_IPAQ=3Dm
CONFIG_USB_SERIAL_IR=3Dm
CONFIG_USB_SERIAL_EDGEPORT=3Dm
CONFIG_USB_SERIAL_EDGEPORT_TI=3Dm
CONFIG_USB_SERIAL_GARMIN=3Dm
CONFIG_USB_SERIAL_IPW=3Dm
CONFIG_USB_SERIAL_KEYSPAN_PDA=3Dm
CONFIG_USB_SERIAL_KEYSPAN=3Dm
CONFIG_USB_SERIAL_KEYSPAN_MPR=3Dy
CONFIG_USB_SERIAL_KEYSPAN_USA28=3Dy
CONFIG_USB_SERIAL_KEYSPAN_USA28X=3Dy
CONFIG_USB_SERIAL_KEYSPAN_USA28XA=3Dy
CONFIG_USB_SERIAL_KEYSPAN_USA28XB=3Dy
CONFIG_USB_SERIAL_KEYSPAN_USA19=3Dy
CONFIG_USB_SERIAL_KEYSPAN_USA18X=3Dy
CONFIG_USB_SERIAL_KEYSPAN_USA19W=3Dy
CONFIG_USB_SERIAL_KEYSPAN_USA19QW=3Dy
CONFIG_USB_SERIAL_KEYSPAN_USA19QI=3Dy
CONFIG_USB_SERIAL_KEYSPAN_USA49W=3Dy
CONFIG_USB_SERIAL_KEYSPAN_USA49WLC=3Dy
CONFIG_USB_SERIAL_KLSI=3Dm
CONFIG_USB_SERIAL_KOBIL_SCT=3Dm
CONFIG_USB_SERIAL_MCT_U232=3Dm
CONFIG_USB_SERIAL_MOS7720=3Dm
CONFIG_USB_SERIAL_MOS7840=3Dm
CONFIG_USB_SERIAL_NAVMAN=3Dm
CONFIG_USB_SERIAL_PL2303=3Dm
CONFIG_USB_SERIAL_OTI6858=3Dm
CONFIG_USB_SERIAL_HP4X=3Dm
CONFIG_USB_SERIAL_SAFE=3Dm
CONFIG_USB_SERIAL_SAFE_PADDED=3Dy
CONFIG_USB_SERIAL_SIERRAWIRELESS=3Dm
CONFIG_USB_SERIAL_TI=3Dm
CONFIG_USB_SERIAL_CYBERJACK=3Dm
CONFIG_USB_SERIAL_XIRCOM=3Dm
CONFIG_USB_SERIAL_OPTION=3Dm
CONFIG_USB_SERIAL_OMNINET=3Dm
CONFIG_USB_SERIAL_DEBUG=3Dm
CONFIG_USB_EZUSB=3Dy

#
# USB Miscellaneous drivers
#
CONFIG_USB_EMI62=3Dm
CONFIG_USB_EMI26=3Dm
CONFIG_USB_ADUTUX=3Dm
CONFIG_USB_AUERSWALD=3Dm
CONFIG_USB_RIO500=3Dm
CONFIG_USB_LEGOTOWER=3Dm
CONFIG_USB_LCD=3Dm
CONFIG_USB_BERRY_CHARGE=3Dm
CONFIG_USB_LED=3Dm
CONFIG_USB_CYPRESS_CY7C63=3Dm
CONFIG_USB_CYTHERM=3Dm
CONFIG_USB_PHIDGET=3Dm
CONFIG_USB_PHIDGETKIT=3Dm
CONFIG_USB_PHIDGETMOTORCONTROL=3Dm
CONFIG_USB_PHIDGETSERVO=3Dm
CONFIG_USB_IDMOUSE=3Dm
CONFIG_USB_FTDI_ELAN=3Dm
CONFIG_USB_APPLEDISPLAY=3Dm
CONFIG_USB_SISUSBVGA=3Dm
CONFIG_USB_SISUSBVGA_CON=3Dy
CONFIG_USB_LD=3Dm
# CONFIG_USB_TRANCEVIBRATOR is not set
CONFIG_USB_IOWARRIOR=3Dm
# CONFIG_USB_TEST is not set
CONFIG_USB_GOTEMP=3Dm

#
# USB DSL modem support
#

#
# USB Gadget Support
#
# CONFIG_USB_GADGET is not set
# CONFIG_MMC is not set
CONFIG_NEW_LEDS=3Dy
CONFIG_LEDS_CLASS=3Dm

#
# LED drivers
#

#
# LED Triggers
#
# CONFIG_LEDS_TRIGGERS is not set
# CONFIG_INFINIBAND is not set
CONFIG_EDAC=3Dy

#
# Reporting subsystems
#
# CONFIG_EDAC_DEBUG is not set
CONFIG_EDAC_MM_EDAC=3Dm
CONFIG_EDAC_AMD76X=3Dm
CONFIG_EDAC_E7XXX=3Dm
CONFIG_EDAC_E752X=3Dm
CONFIG_EDAC_I82875P=3Dm
CONFIG_EDAC_I82975X=3Dm
CONFIG_EDAC_I3000=3Dm
CONFIG_EDAC_I82860=3Dm
CONFIG_EDAC_R82600=3Dm
CONFIG_EDAC_I5000=3Dm
CONFIG_RTC_LIB=3Dm
CONFIG_RTC_CLASS=3Dm

#
# RTC interfaces
#
CONFIG_RTC_INTF_SYSFS=3Dy
CONFIG_RTC_INTF_PROC=3Dy
CONFIG_RTC_INTF_DEV=3Dy
CONFIG_RTC_INTF_DEV_UIE_EMUL=3Dy
# CONFIG_RTC_DRV_TEST is not set

#
# I2C RTC drivers
#
CONFIG_RTC_DRV_DS1307=3Dm
CONFIG_RTC_DRV_DS1672=3Dm
CONFIG_RTC_DRV_MAX6900=3Dm
CONFIG_RTC_DRV_RS5C372=3Dm
CONFIG_RTC_DRV_ISL1208=3Dm
CONFIG_RTC_DRV_X1205=3Dm
CONFIG_RTC_DRV_PCF8563=3Dm
CONFIG_RTC_DRV_PCF8583=3Dm
CONFIG_RTC_DRV_M41T80=3Dm
CONFIG_RTC_DRV_M41T80_WDT=3Dy

#
# SPI RTC drivers
#
# CONFIG_RTC_DRV_RS5C348 is not set
# CONFIG_RTC_DRV_MAX6902 is not set

#
# Platform RTC drivers
#
CONFIG_RTC_DRV_CMOS=3Dm
CONFIG_RTC_DRV_DS1553=3Dm
CONFIG_RTC_DRV_STK17TA8=3Dm
CONFIG_RTC_DRV_DS1742=3Dm
CONFIG_RTC_DRV_M48T86=3Dm
CONFIG_RTC_DRV_M48T59=3Dm
CONFIG_RTC_DRV_V3020=3Dm

#
# on-CPU RTC drivers
#
CONFIG_DMADEVICES=3Dy

#
# DMA Devices
#
CONFIG_INTEL_IOATDMA=3Dm
CONFIG_DMA_ENGINE=3Dy

#
# DMA Clients
#
CONFIG_NET_DMA=3Dy
CONFIG_DCA=3Dm
# CONFIG_AUXDISPLAY is not set
CONFIG_VIRTUALIZATION=3Dy
CONFIG_KVM=3Dm
CONFIG_KVM_INTEL=3Dm
CONFIG_KVM_AMD=3Dm

#
# Userspace I/O
#
# CONFIG_UIO is not set
CONFIG_LGUEST=3Dm
CONFIG_LGUEST_GUEST=3Dy
CONFIG_LGUEST_NET=3Dy
CONFIG_LGUEST_BLOCK=3Dy

#
# File systems
#
CONFIG_EXT2_FS=3Dm
CONFIG_EXT2_FS_XATTR=3Dy
CONFIG_EXT2_FS_POSIX_ACL=3Dy
CONFIG_EXT2_FS_SECURITY=3Dy
CONFIG_EXT2_FS_XIP=3Dy
CONFIG_FS_XIP=3Dy
CONFIG_EXT3_FS=3Dm
CONFIG_EXT3_FS_XATTR=3Dy
CONFIG_EXT3_FS_POSIX_ACL=3Dy
CONFIG_EXT3_FS_SECURITY=3Dy
# CONFIG_EXT4DEV_FS is not set
CONFIG_JBD=3Dm
CONFIG_JBD_DEBUG=3Dy
CONFIG_FS_MBCACHE=3Dm
# CONFIG_REISER4_FS is not set
CONFIG_REISERFS_FS=3Dm
# CONFIG_REISERFS_CHECK is not set
# CONFIG_REISERFS_PROC_INFO is not set
CONFIG_REISERFS_FS_XATTR=3Dy
CONFIG_REISERFS_FS_POSIX_ACL=3Dy
CONFIG_REISERFS_FS_SECURITY=3Dy
CONFIG_JFS_FS=3Dm
CONFIG_JFS_POSIX_ACL=3Dy
CONFIG_JFS_SECURITY=3Dy
# CONFIG_JFS_DEBUG is not set
CONFIG_JFS_STATISTICS=3Dy
CONFIG_FS_POSIX_ACL=3Dy
CONFIG_XFS_FS=3Dm
CONFIG_XFS_QUOTA=3Dy
CONFIG_XFS_SECURITY=3Dy
CONFIG_XFS_POSIX_ACL=3Dy
CONFIG_XFS_RT=3Dy
# CONFIG_GFS2_FS is not set
# CONFIG_OCFS2_FS is not set
CONFIG_MINIX_FS=3Dy
CONFIG_ROMFS_FS=3Dm
CONFIG_INOTIFY=3Dy
CONFIG_INOTIFY_USER=3Dy
CONFIG_QUOTA=3Dy
CONFIG_QUOTA_NETLINK_INTERFACE=3Dy
CONFIG_PRINT_QUOTA_WARNING=3Dy
CONFIG_QFMT_V1=3Dm
CONFIG_QFMT_V2=3Dm
CONFIG_QUOTACTL=3Dy
CONFIG_DNOTIFY=3Dy
CONFIG_AUTOFS_FS=3Dm
CONFIG_AUTOFS4_FS=3Dm
CONFIG_FUSE_FS=3Dm
CONFIG_GENERIC_ACL=3Dy

#
# CD-ROM/DVD Filesystems
#
CONFIG_ISO9660_FS=3Dy
CONFIG_JOLIET=3Dy
CONFIG_ZISOFS=3Dy
CONFIG_UDF_FS=3Dm
CONFIG_UDF_NLS=3Dy

#
# DOS/FAT/NT Filesystems
#
CONFIG_FAT_FS=3Dm
CONFIG_MSDOS_FS=3Dm
CONFIG_VFAT_FS=3Dm
CONFIG_FAT_DEFAULT_CODEPAGE=3D437
CONFIG_FAT_DEFAULT_IOCHARSET=3D"iso8859-1"
CONFIG_NTFS_FS=3Dm
CONFIG_NTFS_DEBUG=3Dy
CONFIG_NTFS_RW=3Dy

#
# Pseudo filesystems
#
CONFIG_PROC_FS=3Dy
CONFIG_PROC_KCORE=3Dy
CONFIG_PROC_SYSCTL=3Dy
CONFIG_SYSFS=3Dy
CONFIG_TMPFS=3Dy
CONFIG_TMPFS_POSIX_ACL=3Dy
CONFIG_HUGETLBFS=3Dy
CONFIG_HUGETLB_PAGE=3Dy
CONFIG_CONFIGFS_FS=3Dm

#
# Layered filesystems
#
# CONFIG_ECRYPT_FS is not set
# CONFIG_UNION_FS is not set

#
# Miscellaneous filesystems
#
# CONFIG_ADFS_FS is not set
# CONFIG_AFFS_FS is not set
# CONFIG_HFS_FS is not set
# CONFIG_HFSPLUS_FS is not set
# CONFIG_BEFS_FS is not set
# CONFIG_BFS_FS is not set
# CONFIG_EFS_FS is not set
CONFIG_CRAMFS=3Dm
CONFIG_VXFS_FS=3Dm
# CONFIG_HPFS_FS is not set
# CONFIG_QNX4FS_FS is not set
# CONFIG_SYSV_FS is not set
# CONFIG_UFS_FS is not set

#
# Network File Systems
#
CONFIG_NFS_FS=3Dm
CONFIG_NFS_V3=3Dy
CONFIG_NFS_V3_ACL=3Dy
CONFIG_NFS_V4=3Dy
CONFIG_NFS_DIRECTIO=3Dy
CONFIG_NFSD=3Dm
CONFIG_NFSD_V2_ACL=3Dy
CONFIG_NFSD_V3=3Dy
CONFIG_NFSD_V3_ACL=3Dy
CONFIG_NFSD_V4=3Dy
CONFIG_NFSD_TCP=3Dy
CONFIG_LOCKD=3Dm
CONFIG_LOCKD_V4=3Dy
CONFIG_EXPORTFS=3Dm
CONFIG_NFS_ACL_SUPPORT=3Dm
CONFIG_NFS_COMMON=3Dy
CONFIG_SUNRPC=3Dm
CONFIG_SUNRPC_GSS=3Dm
# CONFIG_SUNRPC_BIND34 is not set
CONFIG_RPCSEC_GSS_KRB5=3Dm
CONFIG_RPCSEC_GSS_SPKM3=3Dm
# CONFIG_SMB_FS is not set
CONFIG_CIFS=3Dm
CONFIG_CIFS_STATS=3Dy
CONFIG_CIFS_STATS2=3Dy
CONFIG_CIFS_WEAK_PW_HASH=3Dy
CONFIG_CIFS_XATTR=3Dy
CONFIG_CIFS_POSIX=3Dy
# CONFIG_CIFS_DEBUG2 is not set
# CONFIG_CIFS_EXPERIMENTAL is not set
# CONFIG_NCP_FS is not set
# CONFIG_CODA_FS is not set
# CONFIG_AFS_FS is not set

#
# Partition Types
#
CONFIG_PARTITION_ADVANCED=3Dy
# CONFIG_ACORN_PARTITION is not set
# CONFIG_OSF_PARTITION is not set
# CONFIG_AMIGA_PARTITION is not set
# CONFIG_ATARI_PARTITION is not set
# CONFIG_MAC_PARTITION is not set
CONFIG_MSDOS_PARTITION=3Dy
CONFIG_BSD_DISKLABEL=3Dy
# CONFIG_MINIX_SUBPARTITION is not set
# CONFIG_SOLARIS_X86_PARTITION is not set
# CONFIG_UNIXWARE_DISKLABEL is not set
CONFIG_LDM_PARTITION=3Dy
CONFIG_LDM_DEBUG=3Dy
# CONFIG_SGI_PARTITION is not set
# CONFIG_ULTRIX_PARTITION is not set
# CONFIG_SUN_PARTITION is not set
CONFIG_KARMA_PARTITION=3Dy
CONFIG_EFI_PARTITION=3Dy
# CONFIG_SYSV68_PARTITION is not set

#
# Native Language Support
#
CONFIG_NLS=3Dy
CONFIG_NLS_DEFAULT=3D"utf8"
CONFIG_NLS_CODEPAGE_437=3Dm
CONFIG_NLS_CODEPAGE_737=3Dm
CONFIG_NLS_CODEPAGE_775=3Dm
CONFIG_NLS_CODEPAGE_850=3Dm
CONFIG_NLS_CODEPAGE_852=3Dm
CONFIG_NLS_CODEPAGE_855=3Dm
CONFIG_NLS_CODEPAGE_857=3Dm
CONFIG_NLS_CODEPAGE_860=3Dm
CONFIG_NLS_CODEPAGE_861=3Dm
CONFIG_NLS_CODEPAGE_862=3Dm
CONFIG_NLS_CODEPAGE_863=3Dm
CONFIG_NLS_CODEPAGE_864=3Dm
CONFIG_NLS_CODEPAGE_865=3Dm
CONFIG_NLS_CODEPAGE_866=3Dm
CONFIG_NLS_CODEPAGE_869=3Dm
CONFIG_NLS_CODEPAGE_936=3Dm
CONFIG_NLS_CODEPAGE_950=3Dm
CONFIG_NLS_CODEPAGE_932=3Dm
CONFIG_NLS_CODEPAGE_949=3Dm
CONFIG_NLS_CODEPAGE_874=3Dm
CONFIG_NLS_ISO8859_8=3Dm
CONFIG_NLS_CODEPAGE_1250=3Dm
CONFIG_NLS_CODEPAGE_1251=3Dm
CONFIG_NLS_ASCII=3Dm
CONFIG_NLS_ISO8859_1=3Dm
CONFIG_NLS_ISO8859_2=3Dm
CONFIG_NLS_ISO8859_3=3Dm
CONFIG_NLS_ISO8859_4=3Dm
CONFIG_NLS_ISO8859_5=3Dm
CONFIG_NLS_ISO8859_6=3Dm
CONFIG_NLS_ISO8859_7=3Dm
CONFIG_NLS_ISO8859_9=3Dm
CONFIG_NLS_ISO8859_13=3Dm
CONFIG_NLS_ISO8859_14=3Dm
CONFIG_NLS_ISO8859_15=3Dm
CONFIG_NLS_KOI8_R=3Dm
CONFIG_NLS_KOI8_U=3Dm
CONFIG_NLS_UTF8=3Dm

#
# Distributed Lock Manager
#
CONFIG_DLM=3Dm
# CONFIG_DLM_DEBUG is not set
CONFIG_INSTRUMENTATION=3Dy
CONFIG_PROFILING=3Dy
CONFIG_OPROFILE=3Dm
CONFIG_KPROBES=3Dy

#
# Kernel hacking
#
CONFIG_TRACE_IRQFLAGS_SUPPORT=3Dy
CONFIG_PRINTK_TIME=3Dy
CONFIG_ENABLE_MUST_CHECK=3Dy
CONFIG_MAGIC_SYSRQ=3Dy
# CONFIG_UNUSED_SYMBOLS is not set
# CONFIG_PAGE_OWNER is not set
CONFIG_DEBUG_FS=3Dy
CONFIG_HEADERS_CHECK=3Dy
CONFIG_DEBUG_KERNEL=3Dy
# CONFIG_DEBUG_SHIRQ is not set
CONFIG_DETECT_SOFTLOCKUP=3Dy
CONFIG_SCHED_DEBUG=3Dy
# CONFIG_SCHEDSTATS is not set
# CONFIG_TIMER_STATS is not set
# CONFIG_SLUB_DEBUG_ON is not set
CONFIG_DEBUG_PREEMPT=3Dy
CONFIG_DEBUG_RT_MUTEXES=3Dy
CONFIG_DEBUG_PI_LIST=3Dy
# CONFIG_RT_MUTEX_TESTER is not set
CONFIG_DEBUG_SPINLOCK=3Dy
CONFIG_DEBUG_MUTEXES=3Dy
CONFIG_DEBUG_LOCK_ALLOC=3Dy
CONFIG_PROVE_LOCKING=3Dy
CONFIG_LOCKDEP=3Dy
# CONFIG_LOCK_STAT is not set
# CONFIG_DEBUG_LOCKDEP is not set
CONFIG_TRACE_IRQFLAGS=3Dy
CONFIG_DEBUG_SPINLOCK_SLEEP=3Dy
CONFIG_DEBUG_LOCKING_API_SELFTESTS=3Dy
CONFIG_STACKTRACE=3Dy
# CONFIG_DEBUG_KOBJECT is not set
# CONFIG_DEBUG_HIGHMEM is not set
CONFIG_DEBUG_BUGVERBOSE=3Dy
CONFIG_DEBUG_INFO=3Dy
# CONFIG_DEBUG_VM is not set
# CONFIG_DEBUG_LIST is not set
CONFIG_FRAME_POINTER=3Dy
CONFIG_UNWIND_INFO=3Dy
CONFIG_STACK_UNWIND=3Dy
# CONFIG_PROFILE_LIKELY is not set
# CONFIG_FORCED_INLINING is not set
# CONFIG_BOOT_PRINTK_DELAY is not set
# CONFIG_DEBUG_SYNCHRO_TEST is not set
# CONFIG_RCU_TORTURE_TEST is not set
# CONFIG_LKDTM is not set
CONFIG_FAULT_INJECTION=3Dy
CONFIG_FAILSLAB=3Dy
CONFIG_FAIL_PAGE_ALLOC=3Dy
CONFIG_FAIL_MAKE_REQUEST=3Dy
CONFIG_FAULT_INJECTION_DEBUG_FS=3Dy
CONFIG_FAULT_INJECTION_STACKTRACE_FILTER=3Dy
# CONFIG_WANT_EXTRA_DEBUG_INFORMATION is not set
# CONFIG_KGDB is not set
# CONFIG_KGDB_ATTACH_WAIT is not set
CONFIG_EARLY_PRINTK=3Dy
CONFIG_DEBUG_STACKOVERFLOW=3Dy
# CONFIG_DEBUG_STACK_USAGE is not set

#
# Page alloc debug is incompatible with Software Suspend on i386
#
CONFIG_DEBUG_RODATA=3Dy
CONFIG_4KSTACKS=3Dy
CONFIG_X86_FIND_SMP_CONFIG=3Dy
CONFIG_X86_MPPARSE=3Dy
CONFIG_DOUBLEFAULT=3Dy

#
# Security options
#
CONFIG_KEYS=3Dy
CONFIG_KEYS_DEBUG_PROC_KEYS=3Dy
CONFIG_SECURITY=3Dy
CONFIG_SECURITY_NETWORK=3Dy
# CONFIG_SECURITY_NETWORK_XFRM is not set
CONFIG_SECURITY_CAPABILITIES=3Dy
# CONFIG_SECURITY_FILE_CAPABILITIES is not set
# CONFIG_SECURITY_SELINUX is not set
CONFIG_XOR_BLOCKS=3Dm
CONFIG_ASYNC_CORE=3Dm
CONFIG_ASYNC_MEMCPY=3Dm
CONFIG_ASYNC_XOR=3Dm
CONFIG_CRYPTO=3Dy
CONFIG_CRYPTO_ALGAPI=3Dy
CONFIG_CRYPTO_ABLKCIPHER=3Dm
CONFIG_CRYPTO_AEAD=3Dm
CONFIG_CRYPTO_BLKCIPHER=3Dy
CONFIG_CRYPTO_HASH=3Dy
CONFIG_CRYPTO_MANAGER=3Dy
CONFIG_CRYPTO_HMAC=3Dy
CONFIG_CRYPTO_XCBC=3Dm
CONFIG_CRYPTO_NULL=3Dm
CONFIG_CRYPTO_MD4=3Dm
CONFIG_CRYPTO_MD5=3Dy
CONFIG_CRYPTO_SHA1=3Dm
CONFIG_CRYPTO_SHA256=3Dm
CONFIG_CRYPTO_SHA512=3Dm
CONFIG_CRYPTO_WP512=3Dm
CONFIG_CRYPTO_TGR192=3Dm
CONFIG_CRYPTO_GF128MUL=3Dm
CONFIG_CRYPTO_ECB=3Dm
CONFIG_CRYPTO_CBC=3Dy
CONFIG_CRYPTO_PCBC=3Dm
CONFIG_CRYPTO_LRW=3Dm
CONFIG_CRYPTO_CRYPTD=3Dm
CONFIG_CRYPTO_DES=3Dy
CONFIG_CRYPTO_FCRYPT=3Dm
CONFIG_CRYPTO_BLOWFISH=3Dm
# CONFIG_CRYPTO_TWOFISH is not set
CONFIG_CRYPTO_TWOFISH_COMMON=3Dm
CONFIG_CRYPTO_TWOFISH_586=3Dm
CONFIG_CRYPTO_SERPENT=3Dm
# CONFIG_CRYPTO_AES is not set
CONFIG_CRYPTO_AES_586=3Dm
CONFIG_CRYPTO_CAST5=3Dm
CONFIG_CRYPTO_CAST6=3Dm
CONFIG_CRYPTO_TEA=3Dm
CONFIG_CRYPTO_ARC4=3Dm
CONFIG_CRYPTO_KHAZAD=3Dm
CONFIG_CRYPTO_ANUBIS=3Dm
CONFIG_CRYPTO_SEED=3Dm
CONFIG_CRYPTO_DEFLATE=3Dm
CONFIG_CRYPTO_MICHAEL_MIC=3Dm
CONFIG_CRYPTO_CRC32C=3Dm
CONFIG_CRYPTO_CAMELLIA=3Dm
CONFIG_CRYPTO_TEST=3Dm
CONFIG_CRYPTO_AUTHENC=3Dm
CONFIG_CRYPTO_HW=3Dy
CONFIG_CRYPTO_DEV_PADLOCK=3Dm
CONFIG_CRYPTO_DEV_PADLOCK_AES=3Dm
CONFIG_CRYPTO_DEV_PADLOCK_SHA=3Dm
CONFIG_CRYPTO_DEV_GEODE=3Dm

#
# Library routines
#
CONFIG_BITREVERSE=3Dy
CONFIG_CRC_CCITT=3Dm
CONFIG_CRC16=3Dm
CONFIG_CRC_ITU_T=3Dm
CONFIG_CRC32=3Dy
CONFIG_CRC7=3Dm
CONFIG_LIBCRC32C=3Dm
CONFIG_AUDIT_GENERIC=3Dy
CONFIG_ZLIB_INFLATE=3Dy
CONFIG_ZLIB_DEFLATE=3Dm
CONFIG_TEXTSEARCH=3Dy
CONFIG_TEXTSEARCH_KMP=3Dm
CONFIG_TEXTSEARCH_BM=3Dm
CONFIG_TEXTSEARCH_FSM=3Dm
CONFIG_PLIST=3Dy
CONFIG_HAS_IOMEM=3Dy
CONFIG_HAS_IOPORT=3Dy
CONFIG_HAS_DMA=3Dy
CONFIG_CHECK_SIGNATURE=3Dy
CONFIG_GENERIC_HARDIRQS=3Dy
CONFIG_GENERIC_IRQ_PROBE=3Dy
CONFIG_GENERIC_PENDING_IRQ=3Dy
CONFIG_X86_SMP=3Dy
CONFIG_X86_HT=3Dy
CONFIG_X86_BIOS_REBOOT=3Dy
CONFIG_X86_TRAMPOLINE=3Dy
CONFIG_KTIME_SCALAR=3Dy

--------------090208080409080002090402--

--------------enig420DE9C8462E3CEFB672F964
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.3rc1 (MingW32)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iD8DBQFG8ap5MdB4Whm86/kRArLLAJ42aScv1dRa0t3aNs7XpMVMzVGp2ACeP0I0
H8G7Kf6oGYyKA8G/sSi1dGo=
=FszZ
-----END PGP SIGNATURE-----

--------------enig420DE9C8462E3CEFB672F964--
