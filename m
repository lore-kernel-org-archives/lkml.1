Return-Path: <linux-kernel-owner+w=401wt.eu-S1754988AbZCKHbA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754988AbZCKHbA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Mar 2009 03:31:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752872AbZCKHar
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Mar 2009 03:30:47 -0400
Received: from mx3.schottelius.org ([77.109.138.221]:34316 "EHLO
	mx3.schottelius.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752159AbZCKHag (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Mar 2009 03:30:36 -0400
Date: Wed, 11 Mar 2009 08:30:31 +0100
From: Nico Schottelius <nico-linux-20090311@schottelius.org>
To: LKML <linux-kernel@vger.kernel.org>, ipw3945-devel@lists.sourceforge.net
Cc: Linux Next Mailing List <linux-next@vger.kernel.org>,
       nico-linux-20090311@schottelius.org
Subject: X200 suspend status on -wl and -next
Message-ID: <20090311073030.GA5284@denkbrett.schottelius.org>
Mail-Followup-To: Nico Schottelius <nico-linux-20090311@schottelius.org>,
	LKML <linux-kernel@vger.kernel.org>,
	ipw3945-devel@lists.sourceforge.net,
	Linux Next Mailing List <linux-next@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="qlTNgmc+xy1dBmNv"
Content-Disposition: inline
User-Agent: echo $message | gpg -e $sender  -s | netcat mailhost 25
X-Unix-Info: http://unix.schottelius.org/
X-Netzseite: http://nico.schottelius.org/
X-System-Info: ikn (Linux 2.6.29-rc7-next-20090306-ikn x86_64)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--qlTNgmc+xy1dBmNv
Content-Type: multipart/mixed; boundary="0F1p//8PRICkK4MW"
Content-Disposition: inline


--0F1p//8PRICkK4MW
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Good morning!

vmlinuz-2.6.29-rc7-wl-ikn-32831-g98c5597:
  resume and suspend works once, after that the attached
  dmesg output is printed and no further suspend is possible
2.6.29-rc7-next-20090306-ikn:
  seems to work fine so far, even adjusting the brightness works

Sincerly,

Nico

ps: please cc on reply

--=20
Think about Free and Open Source Software (FOSS).
http://nico.schottelius.org/documentations/foss/the-term-foss/

PGP: BFE4 C736 ABE5 406F 8F42  F7CF B8BE F92A 9885 188C

--0F1p//8PRICkK4MW
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename=dmesg
Content-Transfer-Encoding: quoted-printable

  [<ffffffff802a100d>] ? pipe_read+0x34e/0x3ad
[37582.656869]  [<ffffffff8024e7e0>] refrigerator+0xe7/0xf3
[37582.656972]  [<ffffffff802425b8>] get_signal_to_deliver+0x5a/0x3aa
[37582.657077]  [<ffffffff8020a904>] do_notify_resume+0x8c/0x833
[37582.657201]  [<ffffffff80249146>] ? autoremove_wake_function+0x0/0x38
[37582.657305]  [<ffffffff80238ad4>] ? do_wait+0x2d6/0x393
[37582.657413]  [<ffffffff80250203>] ? getnstimeofday+0x58/0xb4
[37582.657516]  [<ffffffff8024bfc4>] ? ktime_get_ts+0x49/0x4e
[37582.657618]  [<ffffffff802a72d8>] ? poll_select_set_timeout+0x5c/0x77
[37582.657722]  [<ffffffff8020b735>] sysret_signal+0x6d/0xb7
[37582.657824] multilog      D 00000000006065c0     0  4443   4442
[37582.657997]  ffff8800738e5d78 0000000000000086 ffff8800738e5cd8 ffffffff=
80249294
[37582.658302]  ffffffff8069fdc0 ffffffff8069fdc0 ffff88007adf5180 ffff8800=
76e1c400
[37582.658606]  ffff880074585a00 ffff880074581800 ffff880074585c78 00000001=
74585a00
[37582.658910] Call Trace:
[37582.659009]  [<ffffffff80249294>] ? finish_wait+0x5d/0x65
[37582.659111]  [<ffffffff80249146>] ? autoremove_wake_function+0x0/0x38
[37582.659215]  [<ffffffff802a100d>] ? pipe_read+0x34e/0x3ad
[37582.659317]  [<ffffffff8024e7e0>] refrigerator+0xe7/0xf3
[37582.659419]  [<ffffffff802425b8>] get_signal_to_deliver+0x5a/0x3aa
[37582.659523]  [<ffffffff8020a904>] do_notify_resume+0x8c/0x833
[37582.659625]  [<ffffffff80249146>] ? autoremove_wake_function+0x0/0x38
[37582.659729]  [<ffffffff802ad09c>] ? notify_change+0x2ca/0x2de
[37582.659832]  [<ffffffff802b01ef>] ? mnt_drop_write+0xa0/0x147
[37582.659935]  [<ffffffff803321d0>] ? security_file_permission+0x11/0x13
[37582.660051]  [<ffffffff8029a4e2>] ? vfs_read+0xab/0x154
[37582.660153]  [<ffffffff8020b735>] sysret_signal+0x6d/0xb7
[37582.660255] dnscache      D 00007fffc5042c50     0  4444   4441
[37582.660428]  ffff880072c2dd78 0000000000000086 ffff880072c2dcd8 ffffffff=
802b01ef
[37582.660732]  ffffffff8069fdc0 ffffffff8069fdc0 ffff880074d40f88 ffff8800=
7557da80
[37582.661038]  ffff880074581800 ffff8800738a5a00 ffff880074581a78 00000001=
119fdc82
[37582.661366] Call Trace:
[37582.661464]  [<ffffffff802b01ef>] ? mnt_drop_write+0xa0/0x147
[37582.661567]  [<ffffffff802a0cad>] ? pipe_write+0x4ec/0x4fe
[37582.661669]  [<ffffffff8024e7e0>] refrigerator+0xe7/0xf3
[37582.661772]  [<ffffffff802425b8>] get_signal_to_deliver+0x5a/0x3aa
[37582.661875]  [<ffffffff8020a904>] do_notify_resume+0x8c/0x833
[37582.661979]  [<ffffffff80249146>] ? autoremove_wake_function+0x0/0x38
[37582.662083]  [<ffffffff802a8c0e>] ? d_free+0x32/0x49
[37582.662184]  [<ffffffff80250203>] ? getnstimeofday+0x58/0xb4
[37582.662287]  [<ffffffff8024bfc4>] ? ktime_get_ts+0x49/0x4e
[37582.662390]  [<ffffffff802a72d8>] ? poll_select_set_timeout+0x5c/0x77
[37582.662493]  [<ffffffff8020b735>] sysret_signal+0x6d/0xb7
[37582.662595] zsh           D 0000000000000000     0  4513   4415
[37582.662768]  ffff8800738f3d78 0000000000000082 0000000000000000 ffffffff=
8027546e
[37582.663072]  ffffffff8069fdc0 ffffffff8069fdc0 ffff8800738f3ce8 ffffffff=
80227295
[37582.663376]  ffff880074586600 ffff88007c062400 ffff880074586878 00000001=
8027f986
[37582.663680] Call Trace:
[37582.663778]  [<ffffffff8027546e>] ? __lru_cache_add+0x70/0x98
[37582.663881]  [<ffffffff80227295>] ? ptep_set_access_flags+0x22/0x28
[37582.663985]  [<ffffffff80249146>] ? autoremove_wake_function+0x0/0x38
[37582.664102]  [<ffffffff8024e7e0>] refrigerator+0xe7/0xf3
[37582.664204]  [<ffffffff802425b8>] get_signal_to_deliver+0x5a/0x3aa
[37582.664308]  [<ffffffff8022b43b>] ? update_curr+0x53/0xf0
[37582.664410]  [<ffffffff8020a904>] do_notify_resume+0x8c/0x833
[37582.664513]  [<ffffffff8022b7fc>] ? set_next_entity+0x3b/0x61
[37582.664615]  [<ffffffff8022ff17>] ? finish_task_switch+0x2b/0x8e
[37582.664718]  [<ffffffff804cad4c>] ? thread_return+0x3d/0xda
[37582.664821]  [<ffffffff802af502>] ? mntput_no_expire+0x2a/0x14d
[37582.664924]  [<ffffffff8023f872>] ? sigprocmask+0xc6/0xd0
[37582.665028]  [<ffffffff8020b735>] sysret_signal+0x6d/0xb7
[37582.665149] startx        D 0000000000001242     0  4656   4513
[37582.665328]  ffff880073d31d78 0000000000000082 0000000000000000 ffffffff=
8027546e
[37582.665632]  ffffffff8069fdc0 ffffffff8069fdc0 ffff880073d31cf8 ffffffff=
8022b43b
[37582.665936]  ffff880074582400 ffff880074586600 ffff880074582678 00000001=
00000000
[37582.666240] Call Trace:
[37582.666339]  [<ffffffff8027546e>] ? __lru_cache_add+0x70/0x98
[37582.666442]  [<ffffffff8022b43b>] ? update_curr+0x53/0xf0
[37582.666544]  [<ffffffff80350c3d>] ? rb_erase+0x14f/0x2a0
[37582.666646]  [<ffffffff8022b7fc>] ? set_next_entity+0x3b/0x61
[37582.666749]  [<ffffffff8024e7e0>] refrigerator+0xe7/0xf3
[37582.666851]  [<ffffffff802425b8>] get_signal_to_deliver+0x5a/0x3aa
[37582.666955]  [<ffffffff8020a904>] do_notify_resume+0x8c/0x833
[37582.667058]  [<ffffffff804cafbe>] ? preempt_schedule+0x35/0x5c
[37582.667161]  [<ffffffff802493a8>] ? remove_wait_queue+0x3c/0x41
[37582.667264]  [<ffffffff80238ad4>] ? do_wait+0x2d6/0x393
[37582.667367]  [<ffffffff80231ed7>] ? default_wake_function+0x0/0xf
[37582.667470]  [<ffffffff8020b735>] sysret_signal+0x6d/0xb7
[37582.667571] xinit         D 00007fff46856538     0  4674   4656
[37582.667745]  ffff880073987d78 0000000000000086 ffff880001025dc0 ffff8800=
73987ce0
[37582.668061]  ffffffff8069fdc0 ffffffff8069fdc0 ffff880073987cf8 ffffffff=
8022b43b
[37582.668366]  ffff880074584800 ffff880074582400 ffff880074584a78 00000001=
00000000
[37582.668670] Call Trace:
[37582.668768]  [<ffffffff8022b43b>] ? update_curr+0x53/0xf0
[37582.668871]  [<ffffffff8022b7fc>] ? set_next_entity+0x3b/0x61
[37582.668974]  [<ffffffff8024e7e0>] refrigerator+0xe7/0xf3
[37582.669077]  [<ffffffff802425b8>] get_signal_to_deliver+0x5a/0x3aa
[37582.669200]  [<ffffffff8020a904>] do_notify_resume+0x8c/0x833
[37582.669303]  [<ffffffff804ca346>] ? wait_for_common+0x116/0x131
[37582.669413]  [<ffffffff80231ed7>] ? default_wake_function+0x0/0xf
[37582.669517]  [<ffffffff802493a8>] ? remove_wait_queue+0x3c/0x41
[37582.669619]  [<ffffffff80238ad4>] ? do_wait+0x2d6/0x393
[37582.669722]  [<ffffffff80231ed7>] ? default_wake_function+0x0/0xf
[37582.669825]  [<ffffffff8020b735>] sysret_signal+0x6d/0xb7
[37582.669927] Xorg          D 00000000007d2340     0  4675   4674
[37582.670101]  ffff880073989d78 0000000000000082 ffff880073989ce8 ffff8800=
74583278
[37582.670405]  ffffffff8069fdc0 ffffffff8069fdc0 0000000000000000 00000000=
00000001
[37582.670711]  ffff880074583000 ffff88007c062400 ffff880074583278 00000001=
8024c80c
[37582.671014] Call Trace:
[37582.671113]  [<ffffffff804cafbe>] ? preempt_schedule+0x35/0x5c
[37582.671216]  [<ffffffff804ccb18>] ? unlock_kernel+0x4f/0x51
[37582.671319]  [<ffffffff8024e7e0>] refrigerator+0xe7/0xf3
[37582.671421]  [<ffffffff802425b8>] get_signal_to_deliver+0x5a/0x3aa
[37582.671525]  [<ffffffff80440f14>] ? pci_conf1_read+0xd2/0xe2
[37582.671628]  [<ffffffff8020a904>] do_notify_resume+0x8c/0x833
[37582.671731]  [<ffffffff803a60d0>] ? tty_ioctl+0x778/0x7df
[37582.671834]  [<ffffffff802a63a4>] ? vfs_ioctl+0x2a/0x78
[37582.671936]  [<ffffffff802a6838>] ? do_vfs_ioctl+0x446/0x482
[37582.672052]  [<ffffffff8020b735>] sysret_signal+0x6d/0xb7
[37582.672153] awesome       D 0000000000000005     0  4724   4674
[37582.672327]  ffff880064d23d78 0000000000000086 0000000000000000 00000000=
00000000
[37582.672631]  ffffffff8069fdc0 ffffffff8069fdc0 0000000000000000 ffff8800=
00000040
[37582.672935]  ffff880074587200 ffff880074584800 ffff880074587478 00000001=
00001000
[37582.673264] Call Trace:
[37582.673363]  [<ffffffff8024e7e0>] refrigerator+0xe7/0xf3
[37582.673466]  [<ffffffff802425b8>] get_signal_to_deliver+0x5a/0x3aa
[37582.673570]  [<ffffffff8020a904>] do_notify_resume+0x8c/0x833
[37582.673673]  [<ffffffff80249146>] ? autoremove_wake_function+0x0/0x38
[37582.673777]  [<ffffffff802a8467>] ? sys_select+0xa7/0xbc
[37582.673879]  [<ffffffff8020b735>] sysret_signal+0x6d/0xb7
[37582.673981] xbindkeys     D 00007fff500a58e0     0  4738      1
[37582.674155]  ffff880073981d78 0000000000000086 ffff880073981cc8 ffffffff=
802a1711
[37582.674459]  ffffffff8069fdc0 ffffffff8069fdc0 ffff880073981d58 ffffffff=
802a3d9b
[37582.674763]  ffff880074580c00 ffff880074587200 ffff880074580e78 00000001=
7bb79800
[37582.675067] Call Trace:
[37582.675165]  [<ffffffff802a1711>] ? path_put+0x2c/0x30
[37582.675267]  [<ffffffff802a3d9b>] ? __link_path_walk+0xdc4/0xde0
[37582.675371]  [<ffffffff8024e7e0>] refrigerator+0xe7/0xf3
[37582.675473]  [<ffffffff802425b8>] get_signal_to_deliver+0x5a/0x3aa
[37582.675576]  [<ffffffff8020a904>] do_notify_resume+0x8c/0x833
[37582.675679]  [<ffffffff8029d0c3>] ? cp_new_stat+0xe2/0xef
[37582.675782]  [<ffffffff802af502>] ? mntput_no_expire+0x2a/0x14d
[37582.675886]  [<ffffffff802a8467>] ? sys_select+0xa7/0xbc
[37582.675988]  [<ffffffff8020b735>] sysret_signal+0x6d/0xb7
[37582.676103] gconfd-2      D 00000000008e39c0     0  4741      1
[37582.676276]  ffff88007295bd78 0000000000000082 0000000000000000 ffff8800=
7295bb98
[37582.676580]  ffffffff8069fdc0 ffffffff8069fdc0 0000000000200200 ffff8800=
64848f30
[37582.676884]  ffff880074587800 ffff88007c067200 ffff880074587a78 00000001=
802a8546
[37582.677212] Call Trace:
[37582.677311]  [<ffffffff802a8546>] ? pollwake+0x0/0x4e
[37582.677418]  [<ffffffff8024e7e0>] refrigerator+0xe7/0xf3
[37582.677521]  [<ffffffff802425b8>] get_signal_to_deliver+0x5a/0x3aa
[37582.677624]  [<ffffffff8020a904>] do_notify_resume+0x8c/0x833
[37582.677726]  [<ffffffff802af502>] ? mntput_no_expire+0x2a/0x14d
[37582.677830]  [<ffffffff80250203>] ? getnstimeofday+0x58/0xb4
[37582.677932]  [<ffffffff8024bfc4>] ? ktime_get_ts+0x49/0x4e
[37582.678035]  [<ffffffff802a72d8>] ? poll_select_set_timeout+0x5c/0x77
[37582.678139]  [<ffffffff8020b735>] sysret_signal+0x6d/0xb7
[37582.679950] dbus-launch   D 0000000000000000     0  4746      1
[37582.680136]  ffff880062167d78 0000000000000082 0000000000000000 00000000=
00000000
[37582.680440]  ffffffff8069fdc0 ffffffff8069fdc0 ffff880062167d58 ffffffff=
8027f145
[37582.680745]  ffff88007b901200 ffff880074580c00 ffff88007b901478 00000001=
00001000
[37582.681050] Call Trace:
[37582.681169]  [<ffffffff8027f145>] ? __do_fault+0x367/0x3ad
[37582.681272]  [<ffffffff8024e7e0>] refrigerator+0xe7/0xf3
[37582.681380]  [<ffffffff802425b8>] get_signal_to_deliver+0x5a/0x3aa
[37582.681483]  [<ffffffff8020a904>] do_notify_resume+0x8c/0x833
[37582.681586]  [<ffffffff80249146>] ? autoremove_wake_function+0x0/0x38
[37582.681690]  [<ffffffff802a8467>] ? sys_select+0xa7/0xbc
[37582.681792]  [<ffffffff8020b735>] sysret_signal+0x6d/0xb7
[37582.681894] dbus-daemon   D 00007ffbdd904490     0  4747      1
[37582.682068]  ffff880062169d78 0000000000000086 0000000000000000 ffff8800=
62169b98
[37582.682372]  ffffffff8069fdc0 ffffffff8069fdc0 0000000000200200 ffff8800=
783c5430
[37582.682676]  ffff8800738a6000 ffff88007b901200 ffff8800738a6278 00000001=
62169d28
[37582.682980] Call Trace:
[37582.683079]  [<ffffffff80299843>] ? do_sync_readv_writev+0xe3/0x12b
[37582.683183]  [<ffffffff8024e7e0>] refrigerator+0xe7/0xf3
[37582.683285]  [<ffffffff802425b8>] get_signal_to_deliver+0x5a/0x3aa
[37582.683388]  [<ffffffff8020a904>] do_notify_resume+0x8c/0x833
[37582.683491]  [<ffffffff8029a026>] ? do_readv_writev+0x17e/0x193
[37582.683594]  [<ffffffff802af502>] ? mntput_no_expire+0x2a/0x14d
[37582.683697]  [<ffffffff8029acf8>] ? __fput+0x18c/0x199
[37582.683799]  [<ffffffff8020b735>] sysret_signal+0x6d/0xb7
[37582.683901] gnome-screens D 000000000067a190     0  4748      1
[37582.684087]  ffff880062105d78 0000000000000082 0000000000000000 ffff8800=
62105b98
[37582.684391]  ffffffff8069fdc0 ffffffff8069fdc0 0000000000200200 ffff8800=
64848a30
[37582.684694]  ffff88007b903600 ffff8800738a6000 ffff88007b903878 00000001=
802a8546
[37582.684998] Call Trace:
[37582.685098]  [<ffffffff802a8546>] ? pollwake+0x0/0x4e
[37582.685218]  [<ffffffff8024e7e0>] refrigerator+0xe7/0xf3
[37582.685321]  [<ffffffff802425b8>] get_signal_to_deliver+0x5a/0x3aa
[37582.685429]  [<ffffffff8020a904>] do_notify_resume+0x8c/0x833
[37582.685532]  [<ffffffff80249146>] ? autoremove_wake_function+0x0/0x38
[37582.685636]  [<ffffffff804cad4c>] ? thread_return+0x3d/0xda
[37582.685739]  [<ffffffff8020c0c6>] ? retint_kernel+0x26/0x30
[37582.685841]  [<ffffffff80250203>] ? getnstimeofday+0x58/0xb4
[37582.685944]  [<ffffffff8024bfc4>] ? ktime_get_ts+0x49/0x4e
[37582.686046]  [<ffffffff802a72d8>] ? poll_select_set_timeout+0x5c/0x77
[37582.686150]  [<ffffffff8020b735>] sysret_signal+0x6d/0xb7
[37582.686252] urxvtd        D 0000000000000000     0  4754      1
[37582.686425]  ffff880064cefd78 0000000000000086 ffff880001025dc0 00000000=
0000000e
[37582.686729]  ffffffff8069fdc0 ffffffff8069fdc0 0000000000000000 ffff8800=
01025e30
[37582.687033]  ffff88007b895a00 ffff88007b906c00 ffff88007b895c78 00000001=
8022bca1
[37582.687336] Call Trace:
[37582.687434]  [<ffffffff80209f5a>] ? __switch_to+0x35e/0x36e
[37582.687537]  [<ffffffff8022acbd>] ? dequeue_task+0xad/0xb8
[37582.687639]  [<ffffffff8022ff17>] ? finish_task_switch+0x2b/0x8e
[37582.687742]  [<ffffffff8024e7e0>] refrigerator+0xe7/0xf3
[37582.687844]  [<ffffffff802425b8>] get_signal_to_deliver+0x5a/0x3aa
[37582.687947]  [<ffffffff8020a904>] do_notify_resume+0x8c/0x833
[37582.688064]  [<ffffffff8023ef02>] ? del_timer_sync+0x14/0x20
[37582.688166]  [<ffffffff804cb0ac>] ? schedule_timeout+0xb3/0xcf
[37582.688269]  [<ffffffff8023eb1e>] ? process_timeout+0x0/0xb
[37582.688371]  [<ffffffff802c339b>] ? sys_epoll_wait+0x464/0x47c
[37582.688474]  [<ffffffff80231ed7>] ? default_wake_function+0x0/0xf
[37582.688577]  [<ffffffff8020b735>] sysret_signal+0x6d/0xb7
[37582.688679] zsh           D 0000000000000000     0  4760   4754
[37582.688852]  ffff880064cd9d78 0000000000000082 0000000000000000 ffffffff=
8027546e
[37582.689179]  ffffffff8069fdc0 ffffffff8069fdc0 ffff880064cd9ce8 ffffffff=
80227295
[37582.689489]  ffff8800738a2a00 ffff88007b903600 ffff8800738a2c78 00000001=
8027f986
[37582.689793] Call Trace:
[37582.689891]  [<ffffffff8027546e>] ? __lru_cache_add+0x70/0x98
[37582.689994]  [<ffffffff80227295>] ? ptep_set_access_flags+0x22/0x28
[37582.690098]  [<ffffffff8024e7e0>] refrigerator+0xe7/0xf3
[37582.690200]  [<ffffffff802425b8>] get_signal_to_deliver+0x5a/0x3aa
[37582.690303]  [<ffffffff8022b43b>] ? update_curr+0x53/0xf0
[37582.690405]  [<ffffffff8020a904>] do_notify_resume+0x8c/0x833
[37582.690508]  [<ffffffff8022b7fc>] ? set_next_entity+0x3b/0x61
[37582.690611]  [<ffffffff8022ff17>] ? finish_task_switch+0x2b/0x8e
[37582.690714]  [<ffffffff804cad4c>] ? thread_return+0x3d/0xda
[37582.690816]  [<ffffffff802af502>] ? mntput_no_expire+0x2a/0x14d
[37582.690920]  [<ffffffff8023f872>] ? sigprocmask+0xc6/0xd0
[37582.691022]  [<ffffffff8020b735>] sysret_signal+0x6d/0xb7
[37582.691123] ressh.sh      D 0000000000001330     0  4911   4760
[37582.691296]  ffff880064cd3d78 0000000000000082 0000000000000000 ffffffff=
8026d481
[37582.691601]  ffffffff8069fdc0 ffffffff8069fdc0 ffff880064cd3cf8 ffffffff=
8022b43b
[37582.691905]  ffff8800738a7200 ffff8800738a2a00 ffff8800738a7478 00000001=
00000000
[37582.692222] Call Trace:
[37582.692320]  [<ffffffff8026d481>] ? unlock_page+0x22/0x27
[37582.692423]  [<ffffffff8022b43b>] ? update_curr+0x53/0xf0
[37582.692526]  [<ffffffff8022b7fc>] ? set_next_entity+0x3b/0x61
[37582.692629]  [<ffffffff8024e7e0>] refrigerator+0xe7/0xf3
[37582.692731]  [<ffffffff802425b8>] get_signal_to_deliver+0x5a/0x3aa
[37582.692834]  [<ffffffff8020a904>] do_notify_resume+0x8c/0x833
[37582.692937]  [<ffffffff8021c04e>] ? native_smp_send_reschedule+0x50/0x52
[37582.693043]  [<ffffffff8022a5d7>] ? resched_task+0x67/0x69
[37582.693164]  [<ffffffff802493a8>] ? remove_wait_queue+0x3c/0x41
[37582.693267]  [<ffffffff80238ad4>] ? do_wait+0x2d6/0x393
[37582.693375]  [<ffffffff80231ed7>] ? default_wake_function+0x0/0xf
[37582.693478]  [<ffffffff8020b735>] sysret_signal+0x6d/0xb7
[37582.693580] ssh           D 0000000000000000     0  4912   4911
[37582.693753]  ffff880073de9d78 0000000000000082 ffff880073de9df8 ffffffff=
803a951f
[37582.694057]  ffffffff8069fdc0 ffffffff8069fdc0 ffff8800648cb680 ffff8800=
73de9d60
[37582.694362]  ffff88007b954200 ffff8800738a7200 ffff88007b954478 00000001=
648cb680
[37582.694666] Call Trace:
[37582.694764]  [<ffffffff803a951f>] ? n_tty_receive_buf+0xe38/0xe8c
[37582.694868]  [<ffffffff8024e7e0>] refrigerator+0xe7/0xf3
[37582.694970]  [<ffffffff802425b8>] get_signal_to_deliver+0x5a/0x3aa
[37582.695073]  [<ffffffff8020a904>] do_notify_resume+0x8c/0x833
[37582.695176]  [<ffffffff8022b175>] ? __wake_up+0x43/0x50
[37582.695278]  [<ffffffff803aac9c>] ? tty_ldisc_deref+0x69/0x6e
[37582.695381]  [<ffffffff802a8467>] ? sys_select+0xa7/0xbc
[37582.695483]  [<ffffffff8020b735>] sysret_signal+0x6d/0xb7
[37582.695585] firefox-bin   D 00007fc8502039e0     0  5078      1
[37582.695759]  ffff880060469d78 0000000000000082 0000000000000000 ffff8800=
60469b98
[37582.696076]  ffffffff8069fdc0 ffffffff8069fdc0 0000000000200200 ffff8800=
5fd02030
[37582.696381]  ffff8800738a0c00 ffff88007b954200 ffff8800738a0e78 00000001=
802a8546
[37582.696685] Call Trace:
[37582.696784]  [<ffffffff802a8546>] ? pollwake+0x0/0x4e
[37582.696886]  [<ffffffff8024e7e0>] refrigerator+0xe7/0xf3
[37582.696988]  [<ffffffff802425b8>] get_signal_to_deliver+0x5a/0x3aa
[37582.697093]  [<ffffffff8020a904>] do_notify_resume+0x8c/0x833
[37582.697216]  [<ffffffff80249146>] ? autoremove_wake_function+0x0/0x38
[37582.697320]  [<ffffffff80250203>] ? getnstimeofday+0x58/0xb4
[37582.697428]  [<ffffffff8024bfc4>] ? ktime_get_ts+0x49/0x4e
[37582.697531]  [<ffffffff802a72d8>] ? poll_select_set_timeout+0x5c/0x77
[37582.697635]  [<ffffffff8020b735>] sysret_signal+0x6d/0xb7
[37582.697736] firefox-bin   D 0000000000000001     0  5082      1
[37582.697909]  ffff880060233d78 0000000000000082 ffff880060233ca0 ffff8800=
60233cb0
[37582.698214]  ffffffff8069fdc0 ffffffff8069fdc0 ffff880060233d90 ffff8800=
60233d90
[37582.698519]  ffff8800795dce00 ffff8800738a0c00 ffff8800795dd078 00000001=
00000540
[37582.698822] Call Trace:
[37582.698921]  [<ffffffff802a1056>] ? pipe_read+0x397/0x3ad
[37582.699023]  [<ffffffff8024e7e0>] refrigerator+0xe7/0xf3
[37582.699125]  [<ffffffff802425b8>] get_signal_to_deliver+0x5a/0x3aa
[37582.699229]  [<ffffffff8020a904>] do_notify_resume+0x8c/0x833
[37582.699332]  [<ffffffff80249146>] ? autoremove_wake_function+0x0/0x38
[37582.699436]  [<ffffffff8022ac05>] ? enqueue_task+0x59/0x64
[37582.699538]  [<ffffffff80230d02>] ? __sched_setscheduler+0x2ef/0x30e
[37582.699642]  [<ffffffff80256342>] ? sys_futex+0xf8/0x116
[37582.699744]  [<ffffffff8020b735>] sysret_signal+0x6d/0xb7
[37582.699845] firefox-bin   D 00000000416e1fe0     0  5084      1
[37582.700032]  ffff8800601afd78 0000000000000082 ffff8800601afca0 ffff8800=
601afcb0
[37582.700336]  ffffffff8069fdc0 ffffffff8069fdc0 ffff8800601afd90 ffff8800=
601afd90
[37582.700641]  ffff88007b896600 ffff8800795dce00 ffff88007b896878 00000001=
0000050c
[37582.700945] Call Trace:
[37582.701045]  [<ffffffff8024b65a>] ? hrtimer_wakeup+0x0/0x21
[37582.701166]  [<ffffffff8024e7e0>] refrigerator+0xe7/0xf3
[37582.701269]  [<ffffffff802425b8>] get_signal_to_deliver+0x5a/0x3aa
[37582.701378]  [<ffffffff8020a904>] do_notify_resume+0x8c/0x833
[37582.701481]  [<ffffffff80249146>] ? autoremove_wake_function+0x0/0x38
[37582.701585]  [<ffffffff80250203>] ? getnstimeofday+0x58/0xb4
[37582.701688]  [<ffffffff8024bfc4>] ? ktime_get_ts+0x49/0x4e
[37582.701790]  [<ffffffff80256342>] ? sys_futex+0xf8/0x116
[37582.701892]  [<ffffffff8020b735>] sysret_signal+0x6d/0xb7
[37582.701994] firefox-bin   D 0000000000000005     0  5104      1
[37582.702167]  ffff880072c4bd78 0000000000000082 ffff880072c4bca0 ffff8800=
72c4bcb0
[37582.704201]  ffffffff8069fdc0 ffffffff8069fdc0 ffff880072c4bd90 ffff8800=
72c4bd90
[37582.704505]  ffff88007c067200 ffff88007b957200 ffff88007c067478 00000001=
0000030c
[37582.704809] Call Trace:
[37582.704908]  [<ffffffff802a0cad>] ? pipe_write+0x4ec/0x4fe
[37582.705012]  [<ffffffff8024e7e0>] refrigerator+0xe7/0xf3
[37582.705132]  [<ffffffff802425b8>] get_signal_to_deliver+0x5a/0x3aa
[37582.705236]  [<ffffffff8020a904>] do_notify_resume+0x8c/0x833
[37582.705345]  [<ffffffff80249146>] ? autoremove_wake_function+0x0/0x38
[37582.705448]  [<ffffffff802a8c0e>] ? d_free+0x32/0x49
[37582.705550]  [<ffffffff80256342>] ? sys_futex+0xf8/0x116
[37582.705652]  [<ffffffff8020b735>] sysret_signal+0x6d/0xb7
[37582.705754] firefox-bin   D 0000000002dcd4e8     0  5105      1
[37582.705927]  ffff88007ad83d78 0000000000000082 ffff88007ad83ca0 ffff8800=
7ad83cb0
[37582.706230]  ffffffff8069fdc0 ffffffff8069fdc0 ffff88007ad83d90 ffff8800=
7ad83d90
[37582.706534]  ffff88007b957200 ffff88007bba6c00 ffff88007b957478 00000001=
0000060c
[37582.706837] Call Trace:
[37582.706936]  [<ffffffff8023fdb5>] ? __sigqueue_free+0x3c/0x41
[37582.707039]  [<ffffffff80240a6b>] ? __dequeue_signal+0x103/0x12f
[37582.707142]  [<ffffffff8024e7e0>] refrigerator+0xe7/0xf3
[37582.707244]  [<ffffffff802425b8>] get_signal_to_deliver+0x5a/0x3aa
[37582.707347]  [<ffffffff8020a904>] do_notify_resume+0x8c/0x833
[37582.707451]  [<ffffffff80212394>] ? restore_i387_xstate+0x6a/0x14e
[37582.707554]  [<ffffffff8022bd36>] ? enqueue_task_fair+0x22/0x8c
[37582.707656]  [<ffffffff8020b3a5>] ? sys_rt_sigreturn+0x2e6/0x341
[37582.707760]  [<ffffffff80256342>] ? sys_futex+0xf8/0x116
[37582.707862]  [<ffffffff8020b735>] sysret_signal+0x6d/0xb7
[37582.707963] firefox-bin   D 0000000041ee3950     0  5106      1
[37582.708149]  ffff8800601e9d78 0000000000000082 ffff8800601e9ca0 ffff8800=
601e9cb0
[37582.708453]  ffffffff8069fdc0 ffffffff8069fdc0 ffff8800601e9d90 ffff8800=
601e9d90
[37582.708757]  ffff88007bba6c00 ffff880032ca0000 ffff88007bba6e78 00000001=
00000c9c
[37582.709062] Call Trace:
[37582.709182]  [<ffffffff8024e7e0>] refrigerator+0xe7/0xf3
[37582.709284]  [<ffffffff802425b8>] get_signal_to_deliver+0x5a/0x3aa
[37582.709393]  [<ffffffff8020a904>] do_notify_resume+0x8c/0x833
[37582.709496]  [<ffffffff802c84de>] ? __posix_lock_file+0x4bb/0x4ec
[37582.709600]  [<ffffffff802c7d96>] ? locks_free_lock+0x4a/0x4e
[37582.709703]  [<ffffffff802c8890>] ? fcntl_setlk+0x28c/0x2a0
[37582.709805]  [<ffffffff80256342>] ? sys_futex+0xf8/0x116
[37582.709907]  [<ffffffff8020b735>] sysret_signal+0x6d/0xb7
[37582.710009] firefox-bin   D 0000000000000001     0 17835      1
[37582.710182]  ffff88003ec1fd78 0000000000000082 0000000000000001 00000000=
00000001
[37582.710487]  ffffffff8069fdc0 ffffffff8069fdc0 ffff88007c355f00 ffff8800=
386d86a8
[37582.710791]  ffff880032ca0000 ffff88005b9c1200 ffff880032ca0278 00000001=
802ab624
[37582.711094] Call Trace:
[37582.711192]  [<ffffffff802a1056>] ? pipe_read+0x397/0x3ad
[37582.711295]  [<ffffffff8024e7e0>] refrigerator+0xe7/0xf3
[37582.711397]  [<ffffffff802425b8>] get_signal_to_deliver+0x5a/0x3aa
[37582.711500]  [<ffffffff8020a904>] do_notify_resume+0x8c/0x833
[37582.711604]  [<ffffffff802493a8>] ? remove_wait_queue+0x3c/0x41
[37582.711706]  [<ffffffff80238ad4>] ? do_wait+0x2d6/0x393
[37582.711809]  [<ffffffff80231ed7>] ? default_wake_function+0x0/0xf
[37582.711911]  [<ffffffff8020b735>] sysret_signal+0x6d/0xb7
[37582.712026] ssh           D 0000000000000000     0  5226      1
[37582.712198]  ffff880060575d78 0000000000000082 0000000000000040 ffff8800=
60575d60
[37582.712503]  ffffffff8069fdc0 ffffffff8069fdc0 ffff88005ffeb680 ffff8800=
60575d60
[37582.712807]  ffff88005b9c1200 ffff8800738a4e00 ffff88005b9c1478 00000001=
5ffeb680
[37582.713134] Call Trace:
[37582.713233]  [<ffffffff8024e7e0>] refrigerator+0xe7/0xf3
[37582.713341]  [<ffffffff802425b8>] get_signal_to_deliver+0x5a/0x3aa
[37582.713444]  [<ffffffff8020a904>] do_notify_resume+0x8c/0x833
[37582.713547]  [<ffffffff802a8bd8>] ? __d_free+0x4f/0x53
[37582.713649]  [<ffffffff802a8c0e>] ? d_free+0x32/0x49
[37582.713751]  [<ffffffff802af502>] ? mntput_no_expire+0x2a/0x14d
[37582.713854]  [<ffffffff802a8467>] ? sys_select+0xa7/0xbc
[37582.713956]  [<ffffffff8020b735>] sysret_signal+0x6d/0xb7
[37582.714057] ssh           D 0000000000000000     0  5228      1
[37582.714230]  ffff880072df7d78 0000000000000086 0000000000000040 00007f62=
d26280f0
[37582.714535]  ffffffff8069fdc0 ffffffff8069fdc0 0000000000000000 00000000=
00000000
[37582.714840]  ffff8800738a4e00 ffff8800738a4800 ffff8800738a5078 00000001=
5ffeb180
[37582.715144] Call Trace:
[37582.715242]  [<ffffffff8024e7e0>] refrigerator+0xe7/0xf3
[37582.715344]  [<ffffffff802425b8>] get_signal_to_deliver+0x5a/0x3aa
[37582.715447]  [<ffffffff8020a904>] do_notify_resume+0x8c/0x833
[37582.715550]  [<ffffffff80249146>] ? autoremove_wake_function+0x0/0x38
[37582.715654]  [<ffffffff804ccd1f>] ? page_fault+0x1f/0x30
[37582.715756]  [<ffffffff802a8467>] ? sys_select+0xa7/0xbc
[37582.715858]  [<ffffffff8020b735>] sysret_signal+0x6d/0xb7
[37582.715959] ssh           D 0000000000000000     0  5230      1
[37582.716145]  ffff8800620a9d78 0000000000000082 ffff8800620a9cc8 ffffffff=
8026d481
[37582.716449]  ffffffff8069fdc0 ffffffff8069fdc0 ffff8800620a9d58 ffffffff=
8027f145
[37582.716753]  ffff8800738a4800 ffff8800738a6600 ffff8800738a4a78 00000001=
00000200
[37582.717058] Call Trace:
[37582.717177]  [<ffffffff8026d481>] ? unlock_page+0x22/0x27
[37582.717279]  [<ffffffff8027f145>] ? __do_fault+0x367/0x3ad
[37582.717388]  [<ffffffff8024e7e0>] refrigerator+0xe7/0xf3
[37582.717490]  [<ffffffff802425b8>] get_signal_to_deliver+0x5a/0x3aa
[37582.717593]  [<ffffffff8020a904>] do_notify_resume+0x8c/0x833
[37582.717696]  [<ffffffff80249146>] ? autoremove_wake_function+0x0/0x38
[37582.717800]  [<ffffffff802a8467>] ? sys_select+0xa7/0xbc
[37582.717902]  [<ffffffff8020b735>] sysret_signal+0x6d/0xb7
[37582.718004] zsh           D 0000000000000000     0  5235   4754
[37582.718177]  ffff88005145bd78 0000000000000086 0000000000000000 ffff8800=
74583000
[37582.718482]  ffffffff8069fdc0 ffffffff8069fdc0 ffff88005145bce8 ffffffff=
80227295
[37582.718786]  ffff8800738a6600 ffff88005b9c4200 ffff8800738a6878 00000001=
8027f986
[37582.719090] Call Trace:
[37582.719189]  [<ffffffff80227295>] ? ptep_set_access_flags+0x22/0x28
[37582.719292]  [<ffffffff8024e7e0>] refrigerator+0xe7/0xf3
[37582.719394]  [<ffffffff802425b8>] get_signal_to_deliver+0x5a/0x3aa
[37582.719498]  [<ffffffff8022b43b>] ? update_curr+0x53/0xf0
[37582.719600]  [<ffffffff8020a904>] do_notify_resume+0x8c/0x833
[37582.719703]  [<ffffffff8022b7fc>] ? set_next_entity+0x3b/0x61
[37582.719806]  [<ffffffff8022ff17>] ? finish_task_switch+0x2b/0x8e
[37582.719909]  [<ffffffff804cad4c>] ? thread_return+0x3d/0xda
[37582.720025]  [<ffffffff8023f872>] ? sigprocmask+0xc6/0xd0
[37582.720127]  [<ffffffff8020b735>] sysret_signal+0x6d/0xb7
[37582.720228] zsh           D 0000000000000000     0  7352   4754
[37582.720402]  ffff880047515d78 0000000000000082 0000000000000000 ffffffff=
8027546e
[37582.720706]  ffffffff8069fdc0 ffffffff8069fdc0 ffff880047515ce8 ffffffff=
80227295
[37582.721012]  ffff88005b9c4200 ffff88005b9c3600 ffff88005b9c4478 00000001=
8027f986
[37582.721340] Call Trace:
[37582.721438]  [<ffffffff8027546e>] ? __lru_cache_add+0x70/0x98
[37582.721540]  [<ffffffff80227295>] ? ptep_set_access_flags+0x22/0x28
[37582.721645]  [<ffffffff80249146>] ? autoremove_wake_function+0x0/0x38
[37582.721748]  [<ffffffff8024e7e0>] refrigerator+0xe7/0xf3
[37582.721850]  [<ffffffff802425b8>] get_signal_to_deliver+0x5a/0x3aa
[37582.721953]  [<ffffffff8020a904>] do_notify_resume+0x8c/0x833
[37582.722056]  [<ffffffff8022b7fc>] ? set_next_entity+0x3b/0x61
[37582.722158]  [<ffffffff8022ff17>] ? finish_task_switch+0x2b/0x8e
[37582.722261]  [<ffffffff804cad4c>] ? thread_return+0x3d/0xda
[37582.722364]  [<ffffffff802af502>] ? mntput_no_expire+0x2a/0x14d
[37582.722467]  [<ffffffff8023f872>] ? sigprocmask+0xc6/0xd0
[37582.722569]  [<ffffffff8020b735>] sysret_signal+0x6d/0xb7
[37582.722671] nfsiod        S ffff880051437e08     0 10336      2
[37582.722844]  ffff8800375a9ec0 0000000000000046 ffff8800375a9e10 ffffffff=
a045e422
[37582.723148]  ffffffff8069fdc0 ffffffff8069fdc0 ffff8800375a9e30 ffffffff=
a045e46d
[37582.723451]  ffff8800795dc200 ffffffff805f0350 ffff8800795dc478 00000000=
a0340493
[37582.723755] Call Trace:
[37582.723867]  [<ffffffffa045e422>] ? nfs_readdata_release+0x20/0x25 [nfs]
[37582.723982]  [<ffffffffa045e46d>] ? nfs_readpage_release_full+0x46/0x4b =
[nfs]
[37582.724112]  [<ffffffffa03406be>] ? rpc_async_release+0x10/0x12 [sunrpc]
[37582.724216]  [<ffffffff80245676>] worker_thread+0xa9/0xee
[37582.724319]  [<ffffffff80249146>] ? autoremove_wake_function+0x0/0x38
[37582.724422]  [<ffffffff802455cd>] ? worker_thread+0x0/0xee
[37582.724525]  [<ffffffff80248d3e>] kthread+0x49/0x76
[37582.724626]  [<ffffffff8020c5ea>] child_rip+0xa/0x20
[37582.724728]  [<ffffffff8022acbd>] ? dequeue_task+0xad/0xb8
[37582.724830]  [<ffffffff80248cf5>] ? kthread+0x0/0x76
[37582.724932]  [<ffffffff8020c5e0>] ? child_rip+0x0/0x20
[37582.725035] zsh           D 00007ffff44ead48     0 10787   4754
[37582.725226]  ffff880038971d78 0000000000000082 0000000000000000 ffffffff=
803a951f
[37582.725536]  ffffffff8069fdc0 ffffffff8069fdc0 ffff880038971ce8 ffffffff=
80227295
[37582.725839]  ffff88005b9c3600 ffff88005b9c3000 ffff88005b9c3878 00000001=
8027f986
[37582.726143] Call Trace:
[37582.726241]  [<ffffffff803a951f>] ? n_tty_receive_buf+0xe38/0xe8c
[37582.726345]  [<ffffffff80227295>] ? ptep_set_access_flags+0x22/0x28
[37582.726449]  [<ffffffff8024e7e0>] refrigerator+0xe7/0xf3
[37582.726551]  [<ffffffff802425b8>] get_signal_to_deliver+0x5a/0x3aa
[37582.726655]  [<ffffffff802493a8>] ? remove_wait_queue+0x3c/0x41
[37582.728487]  [<ffffffff8020a904>] do_notify_resume+0x8c/0x833
[37582.728590]  [<ffffffff8022b175>] ? __wake_up+0x43/0x50
[37582.728692]  [<ffffffff80231ed7>] ? default_wake_function+0x0/0xf
[37582.728795]  [<ffffffff803aac9c>] ? tty_ldisc_deref+0x69/0x6e
[37582.728897]  [<ffffffff803a3f6c>] ? tty_read+0x87/0xba
[37582.728999]  [<ffffffff8029a4e2>] ? vfs_read+0xab/0x154
[37582.729102]  [<ffffffff8020b735>] sysret_signal+0x6d/0xb7
[37582.729223] zsh           D 0000000000000000     0 16762   4754
[37582.729402]  ffff88000a54dd78 0000000000000082 0000000000000000 ffffffff=
8027546e
[37582.729706]  ffffffff8069fdc0 ffffffff8069fdc0 ffff88000a54dce8 ffffffff=
80227295
[37582.730010]  ffff88005b9c3000 ffff88005b9c3c00 ffff88005b9c3278 00000001=
8027f986
[37582.730314] Call Trace:
[37582.730412]  [<ffffffff8027546e>] ? __lru_cache_add+0x70/0x98
[37582.730514]  [<ffffffff80227295>] ? ptep_set_access_flags+0x22/0x28
[37582.730618]  [<ffffffff8024e7e0>] refrigerator+0xe7/0xf3
[37582.730720]  [<ffffffff802425b8>] get_signal_to_deliver+0x5a/0x3aa
[37582.730823]  [<ffffffff8022b43b>] ? update_curr+0x53/0xf0
[37582.730925]  [<ffffffff8020a904>] do_notify_resume+0x8c/0x833
[37582.731028]  [<ffffffff8022b7fc>] ? set_next_entity+0x3b/0x61
[37582.731131]  [<ffffffff8022ff17>] ? finish_task_switch+0x2b/0x8e
[37582.731234]  [<ffffffff804cad4c>] ? thread_return+0x3d/0xda
[37582.731336]  [<ffffffff802af502>] ? mntput_no_expire+0x2a/0x14d
[37582.731440]  [<ffffffff8023f872>] ? sigprocmask+0xc6/0xd0
[37582.731541]  [<ffffffff8020b735>] sysret_signal+0x6d/0xb7
[37582.731642] zsh           D 0000000000000000     0 17504   4754
[37582.731815]  ffff88003c967d78 0000000000000082 0000000000000000 ffff8800=
5d186000
[37582.732132]  ffffffff8069fdc0 ffffffff8069fdc0 ffff88003c967ce8 ffffffff=
80227295
[37582.732436]  ffff88005b9c3c00 ffff88005b9c7800 ffff88005b9c3e78 00000001=
8027f986
[37582.732739] Call Trace:
[37582.732838]  [<ffffffff80227295>] ? ptep_set_access_flags+0x22/0x28
[37582.732942]  [<ffffffff80249146>] ? autoremove_wake_function+0x0/0x38
[37582.733047]  [<ffffffff8024e7e0>] refrigerator+0xe7/0xf3
[37582.733168]  [<ffffffff802425b8>] get_signal_to_deliver+0x5a/0x3aa
[37582.733272]  [<ffffffff8020a904>] do_notify_resume+0x8c/0x833
[37582.733380]  [<ffffffff8022b7fc>] ? set_next_entity+0x3b/0x61
[37582.733482]  [<ffffffff8022ff17>] ? finish_task_switch+0x2b/0x8e
[37582.733585]  [<ffffffff804cad4c>] ? thread_return+0x3d/0xda
[37582.733688]  [<ffffffff802af502>] ? mntput_no_expire+0x2a/0x14d
[37582.733792]  [<ffffffff8023f872>] ? sigprocmask+0xc6/0xd0
[37582.733894]  [<ffffffff8020b735>] sysret_signal+0x6d/0xb7
[37582.733995] zsh           D 0000000000000000     0 32118  16762
[37582.734168]  ffff88003c5d7d78 0000000000000086 0000000000000000 ffff8800=
64ce1400
[37582.734472]  ffffffff8069fdc0 ffffffff8069fdc0 ffff88003c5d7ce8 ffffffff=
80227295
[37582.734775]  ffff88005b9c7800 ffff88005b9c6000 ffff88005b9c7a78 00000001=
8027f986
[37582.735079] Call Trace:
[37582.735177]  [<ffffffff80227295>] ? ptep_set_access_flags+0x22/0x28
[37582.735281]  [<ffffffff80249146>] ? autoremove_wake_function+0x0/0x38
[37582.735385]  [<ffffffff8024e7e0>] refrigerator+0xe7/0xf3
[37582.735487]  [<ffffffff802425b8>] get_signal_to_deliver+0x5a/0x3aa
[37582.735590]  [<ffffffff8022b43b>] ? update_curr+0x53/0xf0
[37582.735692]  [<ffffffff8020a904>] do_notify_resume+0x8c/0x833
[37582.735795]  [<ffffffff8022b7fc>] ? set_next_entity+0x3b/0x61
[37582.735898]  [<ffffffff8022ff17>] ? finish_task_switch+0x2b/0x8e
[37582.736014]  [<ffffffff804cad4c>] ? thread_return+0x3d/0xda
[37582.736116]  [<ffffffff802af502>] ? mntput_no_expire+0x2a/0x14d
[37582.736219]  [<ffffffff8023f872>] ? sigprocmask+0xc6/0xd0
[37582.736321]  [<ffffffff8020b735>] sysret_signal+0x6d/0xb7
[37582.736423] mutt          D 0000000000000000     0 32260  32118
[37582.736597]  ffff88003c5a1d78 0000000000000082 ffff88003c5a1df8 ffffffff=
803a951f
[37582.736901]  ffffffff8069fdc0 ffffffff8069fdc0 ffff88003c5a1d58 ffffffff=
802a3ca0
[37582.737228]  ffff88005b9c6000 ffff8800795db000 ffff88005b9c6278 00000001=
7bb79800
[37582.737538] Call Trace:
[37582.737636]  [<ffffffff803a951f>] ? n_tty_receive_buf+0xe38/0xe8c
[37582.737739]  [<ffffffff802a3ca0>] ? __link_path_walk+0xcc9/0xde0
[37582.737843]  [<ffffffff8024e7e0>] refrigerator+0xe7/0xf3
[37582.737945]  [<ffffffff802425b8>] get_signal_to_deliver+0x5a/0x3aa
[37582.738048]  [<ffffffff8020a904>] do_notify_resume+0x8c/0x833
[37582.738151]  [<ffffffff8022b175>] ? __wake_up+0x43/0x50
[37582.738253]  [<ffffffff80250203>] ? getnstimeofday+0x58/0xb4
[37582.738356]  [<ffffffff8024bfc4>] ? ktime_get_ts+0x49/0x4e
[37582.738458]  [<ffffffff802a717d>] ? poll_select_copy_remaining+0xc5/0xea
[37582.738563]  [<ffffffff802a8467>] ? sys_select+0xa7/0xbc
[37582.738665]  [<ffffffff8020b735>] sysret_signal+0x6d/0xb7
[37582.738767] keepassx      D 0000000000825a20     0 18479  17504
[37582.738940]  ffff88001ab37d78 0000000000000082 0000000000000000 00000000=
00000000
[37582.739244]  ffffffff8069fdc0 ffffffff8069fdc0 0000000000000000 ffff8800=
00000040
[37582.739548]  ffff8800738a0600 ffff88007b896600 ffff8800738a0878 00000001=
00001000
[37582.739852] Call Trace:
[37582.739951]  [<ffffffff80446db9>] ? sock_aio_read+0x146/0x15a
[37582.740067]  [<ffffffff8024e7e0>] refrigerator+0xe7/0xf3
[37582.740169]  [<ffffffff802425b8>] get_signal_to_deliver+0x5a/0x3aa
[37582.740273]  [<ffffffff8020a904>] do_notify_resume+0x8c/0x833
[37582.740376]  [<ffffffff80249146>] ? autoremove_wake_function+0x0/0x38
[37582.740480]  [<ffffffff804cad4c>] ? thread_return+0x3d/0xda
[37582.740582]  [<ffffffff802849db>] ? unmap_region+0xf3/0x159
[37582.740685]  [<ffffffff80250203>] ? getnstimeofday+0x58/0xb4
[37582.740787]  [<ffffffff803321d0>] ? security_file_permission+0x11/0x13
[37582.740891]  [<ffffffff8020b735>] sysret_signal+0x6d/0xb7
[37582.740993] zsh           D 00000000ffffffff     0 18510   4754
[37582.741186]  ffff8800378ebd78 0000000000000082 ffff8800378ebcc8 ffffffff=
80224bae
[37582.741496]  ffffffff8069fdc0 ffffffff8069fdc0 ffff8800378ebe38 ffffffff=
804cf030
[37582.741800]  ffff8800795db000 ffff88005b9c0c00 ffff8800795db278 00000001=
32c11da0
[37582.742105] Call Trace:
[37582.742203]  [<ffffffff80224bae>] ? fixup_exception+0x18/0x36
[37582.742306]  [<ffffffff804cf030>] ? do_page_fault+0x6d9/0x8ca
[37582.742410]  [<ffffffff8024e7e0>] refrigerator+0xe7/0xf3
[37582.742512]  [<ffffffff802425b8>] get_signal_to_deliver+0x5a/0x3aa
[37582.742615]  [<ffffffff802493a8>] ? remove_wait_queue+0x3c/0x41
[37582.742718]  [<ffffffff8020a904>] do_notify_resume+0x8c/0x833
[37582.742821]  [<ffffffff8022b175>] ? __wake_up+0x43/0x50
[37582.742923]  [<ffffffff80231ed7>] ? default_wake_function+0x0/0xf
[37582.743027]  [<ffffffff803aac9c>] ? tty_ldisc_deref+0x69/0x6e
[37582.743129]  [<ffffffff803a3f6c>] ? tty_read+0x87/0xba
[37582.743231]  [<ffffffff8029a4e2>] ? vfs_read+0xab/0x154
[37582.743334]  [<ffffffff8020b735>] sysret_signal+0x6d/0xb7
[37582.743435] zsh           R  running task        0 19154   5235
[37582.743608]  ffff880043d7dcf8 0000000000000000 0000000000004ad2 00000000=
00001473
[37582.743913]  0000000000000000 0000000000000000 ffff880043d7dce8 00000000=
00000007
[37582.744230]  ffff880043d7dd58 ffffffff8020d9a2 ffff88005b9c2680 00000000=
00000000
[37582.744534] Call Trace:
[37582.744632]  [<ffffffff8020e9df>] show_trace_log_lvl+0x4c/0x58
[37582.744735]  [<ffffffff8020d9d0>] show_stack_log_lvl+0xfb/0x10a
[37582.744838]  [<ffffffff8020e991>] show_stack+0x17/0x19
[37582.744940]  [<ffffffff8022fa12>] sched_show_task+0xa5/0xaa
[37582.745044]  [<ffffffff8022fa67>] show_state_filter+0x50/0x92
[37582.745168]  [<ffffffff8025c7be>] try_to_freeze_tasks+0x159/0x237
[37582.745272]  [<ffffffff802493a8>] ? remove_wait_queue+0x3c/0x41
[37582.745381]  [<ffffffff8025c8bd>] freeze_processes+0x21/0xa0
[37582.745483]  [<ffffffff8025c2b5>] enter_state+0x96/0x164
[37582.745586]  [<ffffffff8025c438>] state_store+0xb5/0xd7
[37582.745688]  [<ffffffff8034ddbf>] kobj_attr_store+0x17/0x19
[37582.745791]  [<ffffffff802e5581>] sysfs_write_file+0xdf/0x114
[37582.745893]  [<ffffffff8029a2a1>] vfs_write+0xae/0x157
[37582.745995]  [<ffffffff8029a40e>] sys_write+0x47/0x70
[37582.746096]  [<ffffffff8020b65b>] system_call_fastpath+0x16/0x1b
[37582.746198] zsh           D 0000000000000000     0 19380   4754
[37582.746372]  ffff880037e0bd78 0000000000000082 0000000000000000 ffff8800=
37e0bcc0
[37582.746676]  ffffffff8069fdc0 ffffffff8069fdc0 ffff880037e0bce8 ffffffff=
80227295
[37582.746980]  ffff88005b9c0c00 ffff8800738a6c00 ffff88005b9c0e78 00000001=
8027f986
[37582.747284] Call Trace:
[37582.747382]  [<ffffffff80227295>] ? ptep_set_access_flags+0x22/0x28
[37582.747487]  [<ffffffff8024e7e0>] refrigerator+0xe7/0xf3
[37582.747589]  [<ffffffff802425b8>] get_signal_to_deliver+0x5a/0x3aa
[37582.747692]  [<ffffffff8020a904>] do_notify_resume+0x8c/0x833
[37582.747794]  [<ffffffff8022b7fc>] ? set_next_entity+0x3b/0x61
[37582.747897]  [<ffffffff8022ff17>] ? finish_task_switch+0x2b/0x8e
[37582.748013]  [<ffffffff804cad4c>] ? thread_return+0x3d/0xda
[37582.748115]  [<ffffffff802af502>] ? mntput_no_expire+0x2a/0x14d
[37582.748219]  [<ffffffff8023f872>] ? sigprocmask+0xc6/0xd0
[37582.748321]  [<ffffffff8020b735>] sysret_signal+0x6d/0xb7
[37582.748422] vi            D 000000000000003e     0 23999  19380
[37582.748596]  ffff880037e27d78 0000000000000082 0000000049b6a3f8 ffff8800=
24078268
[37582.748900]  ffffffff8069fdc0 ffffffff8069fdc0 0000000000000000 ffff8800=
37e27e68
[37582.749226]  ffff8800738a6c00 ffff880032ca2a00 ffff8800738a6e78 00000001=
00000010
[37582.749536] Call Trace:
[37582.749634]  [<ffffffff8024e7e0>] refrigerator+0xe7/0xf3
[37582.749737]  [<ffffffff802425b8>] get_signal_to_deliver+0x5a/0x3aa
[37582.749840]  [<ffffffff8020a904>] do_notify_resume+0x8c/0x833
[37582.749944]  [<ffffffff80249146>] ? autoremove_wake_function+0x0/0x38
[37582.750047]  [<ffffffff8024bfc4>] ? ktime_get_ts+0x49/0x4e
[37582.750150]  [<ffffffff802a717d>] ? poll_select_copy_remaining+0xc5/0xea
[37582.750254]  [<ffffffff802a8467>] ? sys_select+0xa7/0xbc
[37582.750356]  [<ffffffff8020b735>] sysret_signal+0x6d/0xb7
[37582.752181] zsh           D 00007fff1d325b88     0 24275   4754
[37582.752354]  ffff880014dbdd78 0000000000000086 ffff880014dbddf8 ffffffff=
803a951f
[37582.752658]  ffffffff8069fdc0 ffffffff8069fdc0 0000000500006506 00008a3b=
000000bf
[37582.752962]  ffff88007b906c00 ffff88007c062400 ffff88007b906e78 00000001=
00009600
[37582.753291] Call Trace:
[37582.753390]  [<ffffffff803a951f>] ? n_tty_receive_buf+0xe38/0xe8c
[37582.753493]  [<ffffffff8024e7e0>] refrigerator+0xe7/0xf3
[37582.753595]  [<ffffffff802425b8>] get_signal_to_deliver+0x5a/0x3aa
[37582.753699]  [<ffffffff802493a8>] ? remove_wait_queue+0x3c/0x41
[37582.753802]  [<ffffffff8020a904>] do_notify_resume+0x8c/0x833
[37582.753904]  [<ffffffff8022b175>] ? __wake_up+0x43/0x50
[37582.754007]  [<ffffffff80231ed7>] ? default_wake_function+0x0/0xf
[37582.754110]  [<ffffffff803aac9c>] ? tty_ldisc_deref+0x69/0x6e
[37582.754213]  [<ffffffff803a3f6c>] ? tty_read+0x87/0xba
[37582.754315]  [<ffffffff8029a4e2>] ? vfs_read+0xab/0x154
[37582.754417]  [<ffffffff8020b735>] sysret_signal+0x6d/0xb7
[37582.754518] gnome-vfs-dae D 0000000000641820     0 24525      1
[37582.754691]  ffff8800420fbd78 0000000000000086 0000000000000000 ffff8800=
420fbb98
[37582.754996]  ffffffff8069fdc0 ffffffff8069fdc0 0000000000200200 ffff8800=
5ff42a30
[37582.755300]  ffff880032ca7200 ffff8800738a0600 ffff880032ca7478 00000001=
802a8546
[37582.755603] Call Trace:
[37582.755702]  [<ffffffff802a8546>] ? pollwake+0x0/0x4e
[37582.755804]  [<ffffffff8024e7e0>] refrigerator+0xe7/0xf3
[37582.755906]  [<ffffffff802425b8>] get_signal_to_deliver+0x5a/0x3aa
[37582.756022]  [<ffffffff8020a904>] do_notify_resume+0x8c/0x833
[37582.756125]  [<ffffffff80249146>] ? autoremove_wake_function+0x0/0x38
[37582.756228]  [<ffffffff804cad4c>] ? thread_return+0x3d/0xda
[37582.756331]  [<ffffffff803321d0>] ? security_file_permission+0x11/0x13
[37582.756434]  [<ffffffff8020b735>] sysret_signal+0x6d/0xb7
[37582.756536] tail          D 0000000000000001     0 27431  19154
[37582.756709]  ffff880003961d78 0000000000000082 ffff88007bb79800 00000000=
0006d000
[37582.757015]  ffffffff8069fdc0 ffffffff8069fdc0 ffff880003961cf8 ffffffff=
8026d1d5
[37582.757343]  ffff8800738a1e00 ffff88007b902a00 ffff8800738a2078 00000001=
0006d000
[37582.757647] Call Trace:
[37582.757745]  [<ffffffff8026d1d5>] ? find_get_page+0x30/0xb6
[37582.757847]  [<ffffffff8022b869>] ? dequeue_entity+0x18/0x12c
[37582.757950]  [<ffffffff8024e7e0>] refrigerator+0xe7/0xf3
[37582.758052]  [<ffffffff802425b8>] get_signal_to_deliver+0x5a/0x3aa
[37582.758155]  [<ffffffff8020a904>] do_notify_resume+0x8c/0x833
[37582.758258]  [<ffffffff8024b537>] ? __remove_hrtimer+0x5f/0x6d
[37582.758360]  [<ffffffff8024bbe3>] ? hrtimer_try_to_cancel+0x67/0x71
[37582.758464]  [<ffffffff8024bc01>] ? hrtimer_cancel+0x14/0x20
[37582.758566]  [<ffffffff804cb7af>] ? do_nanosleep+0x6c/0xa7
[37582.758669]  [<ffffffff8024be7b>] ? hrtimer_nanosleep+0x91/0xff
[37582.758771]  [<ffffffff8024b65a>] ? hrtimer_wakeup+0x0/0x21
[37582.758874]  [<ffffffff8020b735>] sysret_signal+0x6d/0xb7
[37582.758975] zsh           D 0000000000000000     0 27722   4754
[37582.759148]  ffff880018e77d78 0000000000000086 0000000000000000 ffff8800=
3797d800
[37582.759452]  ffffffff8069fdc0 ffffffff8069fdc0 ffff880018e77ce8 ffffffff=
80227295
[37582.759756]  ffff880032ca2a00 ffff880032ca6c00 ffff880032ca2c78 00000001=
8027f986
[37582.760072] Call Trace:
[37582.760171]  [<ffffffff80227295>] ? ptep_set_access_flags+0x22/0x28
[37582.760274]  [<ffffffff80249146>] ? autoremove_wake_function+0x0/0x38
[37582.760378]  [<ffffffff8024e7e0>] refrigerator+0xe7/0xf3
[37582.760480]  [<ffffffff802425b8>] get_signal_to_deliver+0x5a/0x3aa
[37582.760583]  [<ffffffff8022b43b>] ? update_curr+0x53/0xf0
[37582.760685]  [<ffffffff8020a904>] do_notify_resume+0x8c/0x833
[37582.760788]  [<ffffffff8022b7fc>] ? set_next_entity+0x3b/0x61
[37582.760891]  [<ffffffff8022ff17>] ? finish_task_switch+0x2b/0x8e
[37582.760993]  [<ffffffff804cad4c>] ? thread_return+0x3d/0xda
[37582.761097]  [<ffffffff802af502>] ? mntput_no_expire+0x2a/0x14d
[37582.761219]  [<ffffffff8023f872>] ? sigprocmask+0xc6/0xd0
[37582.761321]  [<ffffffff8020b735>] sysret_signal+0x6d/0xb7
[37582.761428] mutt          D 0000000000000000     0 27863  27722
[37582.761601]  ffff8800299dfd78 0000000000000082 ffff8800299dfdf8 ffffffff=
803a951f
[37582.761905]  ffffffff8069fdc0 ffffffff8069fdc0 ffff8800299dfcf8 ffffffff=
8026d1d5
[37582.762208]  ffff880032ca6c00 ffff880032ca1800 ffff880032ca6e78 00000001=
00000000
[37582.762512] Call Trace:
[37582.762610]  [<ffffffff803a951f>] ? n_tty_receive_buf+0xe38/0xe8c
[37582.762714]  [<ffffffff8026d1d5>] ? find_get_page+0x30/0xb6
[37582.762816]  [<ffffffff8024e7e0>] refrigerator+0xe7/0xf3
[37582.762918]  [<ffffffff802425b8>] get_signal_to_deliver+0x5a/0x3aa
[37582.763022]  [<ffffffff8020a904>] do_notify_resume+0x8c/0x833
[37582.763124]  [<ffffffff8022b175>] ? __wake_up+0x43/0x50
[37582.763226]  [<ffffffff80250203>] ? getnstimeofday+0x58/0xb4
[37582.763328]  [<ffffffff8024bfc4>] ? ktime_get_ts+0x49/0x4e
[37582.763430]  [<ffffffff802a717d>] ? poll_select_copy_remaining+0xc5/0xea
[37582.763534]  [<ffffffff802a8467>] ? sys_select+0xa7/0xbc
[37582.763637]  [<ffffffff8020b735>] sysret_signal+0x6d/0xb7
[37582.763738] zsh           D 0000000000000000     0  1366   4754
[37582.763911]  ffff8800600dfd78 0000000000000086 0000000000000000 ffff8800=
5d185000
[37582.764228]  ffffffff8069fdc0 ffffffff8069fdc0 ffff8800600dfce8 ffffffff=
80227295
[37582.764532]  ffff880032ca4e00 ffff88005b9c7200 ffff880032ca5078 00000001=
8027f986
[37582.764836] Call Trace:
[37582.764934]  [<ffffffff80227295>] ? ptep_set_access_flags+0x22/0x28
[37582.765040]  [<ffffffff80249146>] ? autoremove_wake_function+0x0/0x38
[37582.765162]  [<ffffffff8024e7e0>] refrigerator+0xe7/0xf3
[37582.765265]  [<ffffffff802425b8>] get_signal_to_deliver+0x5a/0x3aa
[37582.765374]  [<ffffffff8022b43b>] ? update_curr+0x53/0xf0
[37582.765477]  [<ffffffff8020a904>] do_notify_resume+0x8c/0x833
[37582.765579]  [<ffffffff8022b7fc>] ? set_next_entity+0x3b/0x61
[37582.765682]  [<ffffffff8022ff17>] ? finish_task_switch+0x2b/0x8e
[37582.765785]  [<ffffffff804cad4c>] ? thread_return+0x3d/0xda
[37582.765887]  [<ffffffff802af502>] ? mntput_no_expire+0x2a/0x14d
[37582.765991]  [<ffffffff8023f872>] ? sigprocmask+0xc6/0xd0
[37582.766093]  [<ffffffff8020b735>] sysret_signal+0x6d/0xb7
[37582.766195] mutt          D 0000000000000000     0  1507   1366
[37582.766368]  ffff8800471abd78 0000000000000086 ffff8800471abdf8 ffffffff=
803a951f
[37582.766672]  ffffffff8069fdc0 ffffffff8069fdc0 ffff8800471abd58 ffffffff=
802a3ca0
[37582.766977]  ffff88005b9c7200 ffff88005b9c1e00 ffff88005b9c7478 00000001=
7bb79800
[37582.767281] Call Trace:
[37582.767379]  [<ffffffff803a951f>] ? n_tty_receive_buf+0xe38/0xe8c
[37582.767483]  [<ffffffff802a3ca0>] ? __link_path_walk+0xcc9/0xde0
[37582.767586]  [<ffffffff8024e7e0>] refrigerator+0xe7/0xf3
[37582.767688]  [<ffffffff802425b8>] get_signal_to_deliver+0x5a/0x3aa
[37582.767791]  [<ffffffff8020a904>] do_notify_resume+0x8c/0x833
[37582.767893]  [<ffffffff8022b175>] ? __wake_up+0x43/0x50
[37582.768009]  [<ffffffff80250203>] ? getnstimeofday+0x58/0xb4
[37582.768111]  [<ffffffff8024bfc4>] ? ktime_get_ts+0x49/0x4e
[37582.768214]  [<ffffffff802a717d>] ? poll_select_copy_remaining+0xc5/0xea
[37582.768318]  [<ffffffff802a8467>] ? sys_select+0xa7/0xbc
[37582.768420]  [<ffffffff8020b735>] sysret_signal+0x6d/0xb7
[37582.768521] ethlog.sh     D 00000000000016f4     0  5874   7352
[37582.768695]  ffff880013425d78 0000000000000082 ffff880013425cb8 ffffffff=
8027546e
[37582.768999]  ffffffff8069fdc0 ffffffff8069fdc0 800000003ff3f067 ffffe200=
01139238
[37582.769328]  ffff880032ca1800 ffff8800738a3600 ffff880032ca1a78 00000001=
00000000
[37582.769632] Call Trace:
[37582.769730]  [<ffffffff8027546e>] ? __lru_cache_add+0x70/0x98
[37582.769833]  [<ffffffff8022b7fc>] ? set_next_entity+0x3b/0x61
[37582.769936]  [<ffffffff8024e7e0>] refrigerator+0xe7/0xf3
[37582.770038]  [<ffffffff802425b8>] get_signal_to_deliver+0x5a/0x3aa
[37582.770141]  [<ffffffff8020a904>] do_notify_resume+0x8c/0x833
[37582.770243]  [<ffffffff8021c04e>] ? native_smp_send_reschedule+0x50/0x52
[37582.770348]  [<ffffffff8022a5d7>] ? resched_task+0x67/0x69
[37582.770451]  [<ffffffff802493a8>] ? remove_wait_queue+0x3c/0x41
[37582.770553]  [<ffffffff80238ad4>] ? do_wait+0x2d6/0x393
[37582.770656]  [<ffffffff80231ed7>] ? default_wake_function+0x0/0xf
[37582.770759]  [<ffffffff8020b735>] sysret_signal+0x6d/0xb7
[37582.770861] vi            D 000000000000003c     0  5876   5874
[37582.771034]  ffff88001cdf9d78 0000000000000082 0000000049b6a403 ffff8800=
28eaec08
[37582.771338]  ffffffff8069fdc0 ffffffff8069fdc0 0000000000000000 ffff8800=
1cdf9e68
[37582.771642]  ffff8800738a3600 ffff880032ca0600 ffff8800738a3878 00000001=
7a44d500
[37582.771947] Call Trace:
[37582.772058]  [<ffffffff8024e7e0>] refrigerator+0xe7/0xf3
[37582.772160]  [<ffffffff802425b8>] get_signal_to_deliver+0x5a/0x3aa
[37582.772263]  [<ffffffff8020a904>] do_notify_resume+0x8c/0x833
[37582.772367]  [<ffffffff80249146>] ? autoremove_wake_function+0x0/0x38
[37582.772471]  [<ffffffff8024bfc4>] ? ktime_get_ts+0x49/0x4e
[37582.772573]  [<ffffffff802a717d>] ? poll_select_copy_remaining+0xc5/0xea
[37582.772677]  [<ffffffff802a8467>] ? sys_select+0xa7/0xbc
[37582.772779]  [<ffffffff8020b735>] sysret_signal+0x6d/0xb7
[37582.772881] zsh           D 0000000000000000     0 15047   4754
[37582.773055]  ffff88005d0d5d78 0000000000000082 ffff88005d0d5df8 ffffffff=
803a951f
[37582.773384]  ffffffff8069fdc0 ffffffff8069fdc0 ffff88005d0d5ce8 ffffffff=
80227295
[37582.773688]  ffff880032ca0600 ffff88007b895a00 ffff880032ca0878 00000001=
8027f986
[37582.773992] Call Trace:
[37582.774090]  [<ffffffff803a951f>] ? n_tty_receive_buf+0xe38/0xe8c
[37582.774194]  [<ffffffff80227295>] ? ptep_set_access_flags+0x22/0x28
[37582.774298]  [<ffffffff8024e7e0>] refrigerator+0xe7/0xf3
[37582.774399]  [<ffffffff802425b8>] get_signal_to_deliver+0x5a/0x3aa
[37582.776227]  [<ffffffff803a3a0c>] ? tty_put_char+0x2d/0x2f
[37582.776330]  [<ffffffff8020a904>] do_notify_resume+0x8c/0x833
[37582.776432]  [<ffffffff8022b7fc>] ? set_next_entity+0x3b/0x61
[37582.776535]  [<ffffffff8022ff17>] ? finish_task_switch+0x2b/0x8e
[37582.776638]  [<ffffffff804cad4c>] ? thread_return+0x3d/0xda
[37582.776740]  [<ffffffff802a6838>] ? do_vfs_ioctl+0x446/0x482
[37582.776843]  [<ffffffff8023f872>] ? sigprocmask+0xc6/0xd0
[37582.776945]  [<ffffffff8020b735>] sysret_signal+0x6d/0xb7
[37582.777047] mutt          D 0000000000000000     0 15188  15047
[37582.777239]  ffff880060dafd78 0000000000000086 ffff880060dafdf8 ffffffff=
803a951f
[37582.777548]  ffffffff8069fdc0 ffffffff8069fdc0 ffff880060dafd58 ffffffff=
802a3ca0
[37582.777852]  ffff88005b9c1e00 ffff880074587800 ffff88005b9c2078 00000001=
7bb79800
[37582.778156] Call Trace:
[37582.778254]  [<ffffffff803a951f>] ? n_tty_receive_buf+0xe38/0xe8c
[37582.778357]  [<ffffffff802a3ca0>] ? __link_path_walk+0xcc9/0xde0
[37582.778461]  [<ffffffff8024e7e0>] refrigerator+0xe7/0xf3
[37582.778563]  [<ffffffff802425b8>] get_signal_to_deliver+0x5a/0x3aa
[37582.778666]  [<ffffffff8020a904>] do_notify_resume+0x8c/0x833
[37582.778768]  [<ffffffff8022b175>] ? __wake_up+0x43/0x50
[37582.778870]  [<ffffffff80250203>] ? getnstimeofday+0x58/0xb4
[37582.778973]  [<ffffffff8024bfc4>] ? ktime_get_ts+0x49/0x4e
[37582.779075]  [<ffffffff802a717d>] ? poll_select_copy_remaining+0xc5/0xea
[37582.779179]  [<ffffffff802a8467>] ? sys_select+0xa7/0xbc
[37582.779281]  [<ffffffff8020b735>] sysret_signal+0x6d/0xb7
[37582.779382] vim           D 0000000000000044     0 17848   4754
[37582.779555]  ffff88000e8e1d78 0000000000000086 0000000049b6a311 ffff8800=
2005c268
[37582.779859]  ffffffff8069fdc0 ffffffff8069fdc0 0000000000000000 ffff8800=
0e8e1e68
[37582.780176]  ffff88007b896c00 ffff880074583000 ffff88007b896e78 00000001=
00000000
[37582.780480] Call Trace:
[37582.780578]  [<ffffffff8024e7e0>] refrigerator+0xe7/0xf3
[37582.780680]  [<ffffffff802425b8>] get_signal_to_deliver+0x5a/0x3aa
[37582.780783]  [<ffffffff8020a904>] do_notify_resume+0x8c/0x833
[37582.780886]  [<ffffffff80249146>] ? autoremove_wake_function+0x0/0x38
[37582.780990]  [<ffffffff8024bfc4>] ? ktime_get_ts+0x49/0x4e
[37582.781094]  [<ffffffff802a717d>] ? poll_select_copy_remaining+0xc5/0xea
[37582.781216]  [<ffffffff802a8467>] ? sys_select+0xa7/0xbc
[37582.781318]  [<ffffffff8020b735>] sysret_signal+0x6d/0xb7
[37582.781426] scsi_eh_8     S ffff88007959b7e0     0 21360      2
[37582.781599]  ffff88007994fe80 0000000000000046 ffff8800738a4200 ffff8800=
01021580
[37582.781902]  ffffffff8069fdc0 ffffffff8069fdc0 ffff88007c060648 ffff8800=
7c060638
[37582.782206]  ffff880032ca3000 ffff88007c060600 ffff880032ca3278 00000001=
01021580
[37582.782510] Call Trace:
[37582.782608]  [<ffffffff8022ff17>] ? finish_task_switch+0x2b/0x8e
[37582.782711]  [<ffffffff804cad4c>] ? thread_return+0x3d/0xda
[37582.782814]  [<ffffffff803e2879>] scsi_error_handler+0x67/0x326
[37582.782916]  [<ffffffff80237ed5>] ? release_task+0x3de/0x3f4
[37582.783019]  [<ffffffff803e2812>] ? scsi_error_handler+0x0/0x326
[37582.783122]  [<ffffffff80248d3e>] kthread+0x49/0x76
[37582.783223]  [<ffffffff8020c5ea>] child_rip+0xa/0x20
[37582.783324]  [<ffffffff8022acbd>] ? dequeue_task+0xad/0xb8
[37582.783426]  [<ffffffff80248cf5>] ? kthread+0x0/0x76
[37582.783528]  [<ffffffff8020c5e0>] ? child_rip+0x0/0x20
[37582.783629] usb-storage   S ffff88007396b690     0 21361      2
[37582.783802]  ffff880043dd3dc0 0000000000000046 ffff880043dd3d00 ffffffff=
804ca398
[37582.784118]  ffffffff8069fdc0 ffffffff8069fdc0 0000000000000000 00000000=
00000303
[37582.784422]  ffff880032ca4800 ffff88007c061200 ffff880032ca4a78 00000000=
00000001
[37582.784726] Call Trace:
[37582.784825]  [<ffffffff804ca398>] ? wait_for_completion_interruptible_ti=
meout+0xe/0x10
[37582.784988]  [<ffffffff8022bb3e>] ? enqueue_entity+0x110/0x118
[37582.785093]  [<ffffffff8022a9b4>] ? wakeup_preempt_entity+0x31/0x3f
[37582.785214]  [<ffffffff804cb01b>] schedule_timeout+0x22/0xcf
[37582.785317]  [<ffffffff80231ec5>] ? try_to_wake_up+0x1d2/0x1e4
[37582.785430]  [<ffffffffa01c7455>] ? usb_stor_invoke_transport+0x299/0x2a=
6 [usb_storage]
[37582.785593]  [<ffffffff804ca2f7>] wait_for_common+0xc7/0x131
[37582.785696]  [<ffffffff80231ed7>] ? default_wake_function+0x0/0xf
[37582.785799]  [<ffffffff804ca3b2>] wait_for_completion_interruptible+0x18=
/0x29
[37582.785908]  [<ffffffffa01c8837>] usb_stor_control_thread+0x3e/0x1d3 [us=
b_storage]
[37582.786071]  [<ffffffff80237ed5>] ? release_task+0x3de/0x3f4
[37582.786177]  [<ffffffffa01c87f9>] ? usb_stor_control_thread+0x0/0x1d3 [u=
sb_storage]
[37582.786341]  [<ffffffff80248d3e>] kthread+0x49/0x76
[37582.786442]  [<ffffffff8020c5ea>] child_rip+0xa/0x20
[37582.786544]  [<ffffffff80248cf5>] ? kthread+0x0/0x76
[37582.786645]  [<ffffffff8020c5e0>] ? child_rip+0x0/0x20
[37582.786746] hald-addon-st D 000000000060a510     0 21427   4136
[37582.786919]  ffff880029869d78 0000000000000082 ffff880029869cd8 ffffffff=
8033f81c
[37582.787222]  ffffffff8069fdc0 ffffffff8069fdc0 0000000000000000 00000000=
0009a000
[37582.787526]  ffff88005b9c5a00 ffff88007c060000 ffff88005b9c5c78 00000000=
0000001d
[37582.787830] Call Trace:
[37582.787928]  [<ffffffff8033f81c>] ? blk_put_request+0x3d/0x46
[37582.788044]  [<ffffffff803e5242>] ? scsi_execute_req+0xa2/0xb4
[37582.788147]  [<ffffffff8024e7e0>] refrigerator+0xe7/0xf3
[37582.788249]  [<ffffffff802425b8>] get_signal_to_deliver+0x5a/0x3aa
[37582.788353]  [<ffffffff803e0366>] ? ioctl_internal_command+0x36/0xf3
[37582.788456]  [<ffffffff8020a904>] do_notify_resume+0x8c/0x833
[37582.788559]  [<ffffffff802ab675>] ? iput+0x2f/0x65
[37582.788660]  [<ffffffff802bdfb9>] ? __blkdev_put+0x144/0x169
[37582.788763]  [<ffffffff802af502>] ? mntput_no_expire+0x2a/0x14d
[37582.788866]  [<ffffffff80250203>] ? getnstimeofday+0x58/0xb4
[37582.788968]  [<ffffffff8024bfc4>] ? ktime_get_ts+0x49/0x4e
[37582.789072]  [<ffffffff802a72d8>] ? poll_select_set_timeout+0x5c/0x77
[37582.789194]  [<ffffffff8020b735>] sysret_signal+0x6d/0xb7
[37582.789295] migration/1   S ffff880043d7dbb8     0 21668      2
[37582.789475]  ffff880074455ed0 0000000000000046 ffff880074455e30 ffffffff=
8022bb3e
[37582.789779]  ffffffff8069fdc0 ffffffff8069fdc0 ffff880001019dc0 ffff8800=
01019dc0
[37582.790083]  ffff880032ca1200 ffff88007c062400 ffff880032ca1478 00000001=
00000001
[37582.790388] Call Trace:
[37582.790486]  [<ffffffff8022bb3e>] ? enqueue_entity+0x110/0x118
[37582.790589]  [<ffffffff8021c04e>] ? native_smp_send_reschedule+0x50/0x52
[37582.790693]  [<ffffffff80232b6d>] migration_thread+0x1a5/0x23b
[37582.790796]  [<ffffffff802329c8>] ? migration_thread+0x0/0x23b
[37582.790899]  [<ffffffff80248d3e>] kthread+0x49/0x76
[37582.791000]  [<ffffffff8020c5ea>] child_rip+0xa/0x20
[37582.791102]  [<ffffffff8022acbd>] ? dequeue_task+0xad/0xb8
[37582.791204]  [<ffffffff80248cf5>] ? kthread+0x0/0x76
[37582.791306]  [<ffffffff8020c5e0>] ? child_rip+0x0/0x20
[37582.791407] ksoftirqd/1   S ffffffff80640358     0 21669      2
[37582.791580]  ffff880074485ef0 0000000000000046 ffffffff8069fdc0 00000000=
00000000
[37582.791884]  ffffffff8069fdc0 ffffffff8069fdc0 ffff880032ca6280 00000001=
804cad4c
[37582.792201]  ffff880032ca6000 ffff88007c062400 ffff880032ca6278 00000001=
8069fdc0
[37582.792504] Call Trace:
[37582.792603]  [<ffffffff8023a703>] ksoftirqd+0x62/0x17c
[37582.792704]  [<ffffffff8023a6a1>] ? ksoftirqd+0x0/0x17c
[37582.792806]  [<ffffffff8023a6a1>] ? ksoftirqd+0x0/0x17c
[37582.792908]  [<ffffffff80248d3e>] kthread+0x49/0x76
[37582.793011]  [<ffffffff8020c5ea>] child_rip+0xa/0x20
[37582.793132]  [<ffffffff80248cf5>] ? kthread+0x0/0x76
[37582.793233]  [<ffffffff8020c5e0>] ? child_rip+0x0/0x20
[37582.793340] rpciod/1      S ffff88007a936b08     0 21670      2
[37582.793514]  ffff88007448dec0 0000000000000046 ffffffff802455cd ffff8800=
01015580
[37582.793817]  ffffffff8069fdc0 ffffffff8069fdc0 ffff88007448de40 ffffffff=
8022ff17
[37582.794121]  ffff880032ca5a00 ffff880032ca0c00 ffff880032ca5c78 00000001=
00000000
[37582.794425] Call Trace:
[37582.794523]  [<ffffffff802455cd>] ? worker_thread+0x0/0xee
[37582.794625]  [<ffffffff8022ff17>] ? finish_task_switch+0x2b/0x8e
[37582.794728]  [<ffffffff80245676>] worker_thread+0xa9/0xee
[37582.794831]  [<ffffffff80249146>] ? autoremove_wake_function+0x0/0x38
[37582.794934]  [<ffffffff802455cd>] ? worker_thread+0x0/0xee
[37582.795037]  [<ffffffff80248d3e>] kthread+0x49/0x76
[37582.795138]  [<ffffffff8020c5ea>] child_rip+0xa/0x20
[37582.795240]  [<ffffffff80248cf5>] ? kthread+0x0/0x76
[37582.795341]  [<ffffffff8020c5e0>] ? child_rip+0x0/0x20
[37582.795442] ib_cm/1       S ffff88007902eb88     0 21671      2
[37582.795616]  ffff880074497ec0 0000000000000046 0000000000000010 00000000=
00000207
[37582.795920]  ffffffff8069fdc0 ffffffff8069fdc0 ffff880074497e40 ffffffff=
8022ff17
[37582.796236]  ffff880032ca6600 ffff880032ca4200 ffff880032ca6878 00000001=
1c5c1ed0
[37582.796540] Call Trace:
[37582.796638]  [<ffffffff8022ff17>] ? finish_task_switch+0x2b/0x8e
[37582.796741]  [<ffffffff80231ec5>] ? try_to_wake_up+0x1d2/0x1e4
[37582.796844]  [<ffffffff80245676>] worker_thread+0xa9/0xee
[37582.796946]  [<ffffffff80249146>] ? autoremove_wake_function+0x0/0x38
[37582.797051]  [<ffffffff802455cd>] ? worker_thread+0x0/0xee
[37582.797172]  [<ffffffff80248d3e>] kthread+0x49/0x76
[37582.797273]  [<ffffffff8020c5ea>] child_rip+0xa/0x20
[37582.797381]  [<ffffffff80248cf5>] ? kthread+0x0/0x76
[37582.797483]  [<ffffffff8020c5e0>] ? child_rip+0x0/0x20
[37582.797583] aio/1         S ffff88007c38dc88     0 21672      2
[37582.797757]  ffff88007449fec0 0000000000000046 ffffffff802455cd ffff8800=
01015580
[37582.798061]  ffffffff8069fdc0 ffffffff8069fdc0 ffff88007449fe40 ffffffff=
8022ff17
[37582.800085]  ffff880032ca4200 ffff88007c062400 ffff880032ca4478 00000001=
74497ed0
[37582.800389] Call Trace:
[37582.800487]  [<ffffffff802455cd>] ? worker_thread+0x0/0xee
[37582.800589]  [<ffffffff8022ff17>] ? finish_task_switch+0x2b/0x8e
[37582.800692]  [<ffffffff80245676>] worker_thread+0xa9/0xee
[37582.800794]  [<ffffffff80249146>] ? autoremove_wake_function+0x0/0x38
[37582.800898]  [<ffffffff802455cd>] ? worker_thread+0x0/0xee
[37582.801002]  [<ffffffff80248d3e>] kthread+0x49/0x76
[37582.801123]  [<ffffffff8020c5ea>] child_rip+0xa/0x20
[37582.801225]  [<ffffffff80248cf5>] ? kthread+0x0/0x76
[37582.801332]  [<ffffffff8020c5e0>] ? child_rip+0x0/0x20
[37582.801433] kondemand/1   S ffff88007c38d488     0 21673      2
[37582.801606]  ffff8800744b9ec0 0000000000000046 ffff8800744b9e80 ffffffff=
804372f7
[37582.801909]  ffffffff8069fdc0 ffffffff8069fdc0 ffff8800744b9e40 00000000=
00000001
[37582.802213]  ffff880032ca0c00 ffff88007c062400 ffff880032ca0e78 00000001=
7448ded0
[37582.802517] Call Trace:
[37582.802615]  [<ffffffff804372f7>] ? do_dbs_timer+0x2c3/0x2d2
[37582.802717]  [<ffffffff80437034>] ? do_dbs_timer+0x0/0x2d2
[37582.802820]  [<ffffffff80245676>] worker_thread+0xa9/0xee
[37582.802922]  [<ffffffff80249146>] ? autoremove_wake_function+0x0/0x38
[37582.803025]  [<ffffffff802455cd>] ? worker_thread+0x0/0xee
[37582.803127]  [<ffffffff80248d3e>] kthread+0x49/0x76
[37582.803229]  [<ffffffff8020c5ea>] child_rip+0xa/0x20
[37582.803330]  [<ffffffff80248cf5>] ? kthread+0x0/0x76
[37582.803431]  [<ffffffff8020c5e0>] ? child_rip+0x0/0x20
[37582.803532] ata/1         S ffff88007b8f9788     0 21674      2
[37582.803705]  ffff8800744c1ec0 0000000000000046 ffffffff802455cd ffff8800=
01015580
[37582.804022]  ffffffff8069fdc0 ffffffff8069fdc0 ffff8800744c1e40 ffffffff=
8022ff17
[37582.804325]  ffff880032ca7800 ffff880032ca2400 ffff880032ca7a78 00000001=
744b9ed0
[37582.804629] Call Trace:
[37582.804727]  [<ffffffff802455cd>] ? worker_thread+0x0/0xee
[37582.804830]  [<ffffffff8022ff17>] ? finish_task_switch+0x2b/0x8e
[37582.804933]  [<ffffffff80245676>] worker_thread+0xa9/0xee
[37582.805036]  [<ffffffff80249146>] ? autoremove_wake_function+0x0/0x38
[37582.805159]  [<ffffffff802455cd>] ? worker_thread+0x0/0xee
[37582.805269]  [<ffffffff80248d3e>] kthread+0x49/0x76
[37582.805392]  [<ffffffff8020c5ea>] child_rip+0xa/0x20
[37582.805494]  [<ffffffff80248cf5>] ? kthread+0x0/0x76
[37582.805595]  [<ffffffff8020c5e0>] ? child_rip+0x0/0x20
[37582.805696] kblockd/1     S ffff88007c34d688     0 21675      2
[37582.805869]  ffff8800744cbec0 0000000000000046 ffff88007a9c0858 ffff8800=
7a9c0970
[37582.806173]  ffffffff8069fdc0 ffffffff8069fdc0 ffff8800744cbe30 ffffffff=
8033ff8b
[37582.806477]  ffff880032ca2400 ffff880020d8b000 ffff880032ca2678 00000001=
80340075
[37582.806781] Call Trace:
[37582.806879]  [<ffffffff8033ff8b>] ? __generic_unplug_device+0x2d/0x32
[37582.806983]  [<ffffffff80347911>] ? as_work_handler+0x0/0x39
[37582.807085]  [<ffffffff8033e6a7>] ? blk_unplug_work+0x7a/0x82
[37582.807188]  [<ffffffff80245676>] worker_thread+0xa9/0xee
[37582.807290]  [<ffffffff80249146>] ? autoremove_wake_function+0x0/0x38
[37582.807394]  [<ffffffff802455cd>] ? worker_thread+0x0/0xee
[37582.807496]  [<ffffffff80248d3e>] kthread+0x49/0x76
[37582.807598]  [<ffffffff8020c5ea>] child_rip+0xa/0x20
[37582.807699]  [<ffffffff80248cf5>] ? kthread+0x0/0x76
[37582.807801]  [<ffffffff8020c5e0>] ? child_rip+0x0/0x20
[37582.807902] work_on_cpu/1 S ffff88007c003e88     0 21676      2
[37582.808087]  ffff88001fd3fec0 0000000000000046 ffff88001fd3fe00 ffffffff=
80231ee4
[37582.808391]  ffffffff8069fdc0 ffffffff8069fdc0 0000000300000000 ffff8800=
744b9ce0
[37582.808695]  ffff880032ca3c00 ffff880032ca0c00 ffff880032ca3e78 00000001=
00000286
[37582.808999] Call Trace:
[37582.809098]  [<ffffffff80231ee4>] ? default_wake_function+0xd/0xf
[37582.809220]  [<ffffffff802458ac>] ? wq_barrier_func+0xd/0xf
[37582.809322]  [<ffffffff80245676>] worker_thread+0xa9/0xee
[37582.809431]  [<ffffffff80249146>] ? autoremove_wake_function+0x0/0x38
[37582.809534]  [<ffffffff802455cd>] ? worker_thread+0x0/0xee
[37582.809636]  [<ffffffff80248d3e>] kthread+0x49/0x76
[37582.809738]  [<ffffffff8020c5ea>] child_rip+0xa/0x20
[37582.809840]  [<ffffffff80248cf5>] ? kthread+0x0/0x76
[37582.809941]  [<ffffffff8020c5e0>] ? child_rip+0x0/0x20
[37582.810042] events/1      S ffff88007c003c88     0 21677      2
[37582.810215]  ffff88001c5c1ec0 0000000000000046 ffff880079060000 ffff8800=
79060680
[37582.810519]  ffffffff8069fdc0 ffffffff8069fdc0 ffff88001c5c1e80 ffffffff=
a0085024
[37582.810822]  ffff8800738a7800 ffff88007c062400 ffff8800738a7a78 00000001=
7c003c88
[37582.811126] Call Trace:
[37582.811232]  [<ffffffffa0085024>] ? e1000_watchdog_task+0x6ad/0x6bc [e10=
00e]
[37582.811344]  [<ffffffffa0084977>] ? e1000_watchdog_task+0x0/0x6bc [e1000=
e]
[37582.811448]  [<ffffffff80245676>] worker_thread+0xa9/0xee
[37582.811551]  [<ffffffff80249146>] ? autoremove_wake_function+0x0/0x38
[37582.811654]  [<ffffffff802455cd>] ? worker_thread+0x0/0xee
[37582.811756]  [<ffffffff80248d3e>] kthread+0x49/0x76
[37582.811858]  [<ffffffff8020c5ea>] child_rip+0xa/0x20
[37582.811959]  [<ffffffff80248cf5>] ? kthread+0x0/0x76
[37582.812074]  [<ffffffff8020c5e0>] ? child_rip+0x0/0x20
[37582.812175] pickup        D 00000000ffffffff     0 21854   4087
[37582.812348]  ffff8800424e9d78 0000000000000082 ffff880001019dc0 00000000=
00000000
[37582.812652]  ffffffff8069fdc0 ffffffff8069fdc0 0000000000000000 ffff8800=
01019e30
[37582.812955]  ffff880020d8f200 ffff88007b897800 ffff880020d8f478 00000000=
8022bca1
[37582.813285] Call Trace:
[37582.813383]  [<ffffffff8022acbd>] ? dequeue_task+0xad/0xb8
[37582.813486]  [<ffffffff8022ff17>] ? finish_task_switch+0x2b/0x8e
[37582.813589]  [<ffffffff8024e7e0>] refrigerator+0xe7/0xf3
[37582.813692]  [<ffffffff802425b8>] get_signal_to_deliver+0x5a/0x3aa
[37582.813795]  [<ffffffff8020a904>] do_notify_resume+0x8c/0x833
[37582.813898]  [<ffffffff8023ef02>] ? del_timer_sync+0x14/0x20
[37582.814000]  [<ffffffff804cb0ac>] ? schedule_timeout+0xb3/0xcf
[37582.814103]  [<ffffffff8023eb1e>] ? process_timeout+0x0/0xb
[37582.814206]  [<ffffffff802c339b>] ? sys_epoll_wait+0x464/0x47c
[37582.814309]  [<ffffffff80231ed7>] ? default_wake_function+0x0/0xf
[37582.814412]  [<ffffffff8020b735>] sysret_signal+0x6d/0xb7
[37582.814514] qmgr          D 00000000ffffffff     0 21857   4087
[37582.814686]  ffff88007887bd78 0000000000000082 ffff880001025dc0 00000000=
00000000
[37582.814991]  ffffffff8069fdc0 ffffffff8069fdc0 ffff88002557d780 ffff8800=
01025e30
[37582.815295]  ffff880020d8bc00 ffff880074587800 ffff880020d8be78 00000001=
7b902a38
[37582.815599] Call Trace:
[37582.815697]  [<ffffffff8022ff17>] ? finish_task_switch+0x2b/0x8e
[37582.815800]  [<ffffffff8024e7e0>] refrigerator+0xe7/0xf3
[37582.815902]  [<ffffffff802425b8>] get_signal_to_deliver+0x5a/0x3aa
[37582.816027]  [<ffffffff8020a904>] do_notify_resume+0x8c/0x833
[37582.816131]  [<ffffffff8023ef02>] ? del_timer_sync+0x14/0x20
[37582.816233]  [<ffffffff804cb0ac>] ? schedule_timeout+0xb3/0xcf
[37582.816336]  [<ffffffff8023eb1e>] ? process_timeout+0x0/0xb
[37582.816438]  [<ffffffff802c339b>] ? sys_epoll_wait+0x464/0x47c
[37582.816541]  [<ffffffff802a6838>] ? do_vfs_ioctl+0x446/0x482
[37582.816644]  [<ffffffff80231ed7>] ? default_wake_function+0x0/0xf
[37582.816746]  [<ffffffff8020b735>] sysret_signal+0x6d/0xb7
[37582.816848] automount     D ffff88000f2cbb78     0 21871   3834
[37582.817023]  ffff88000f2cbb08 0000000000000082 ffff88000f2cba58 ffffffff=
80447a40
[37582.817350]  ffffffff8069fdc0 ffffffff8069fdc0 ffff88000f2cbac8 ffffffff=
a033e204
[37582.817654]  ffff88007c064e00 ffff88007b952a00 ffff88007c065078 00000000=
00000001
[37582.817959] Call Trace:
[37582.818058]  [<ffffffff80447a40>] ? kernel_sendmsg+0x39/0x4e
[37582.818173]  [<ffffffffa033e204>] ? xs_send_kvec+0x7a/0x83 [sunrpc]
[37582.818277]  [<ffffffff8023ee66>] ? lock_timer_base+0x26/0x4a
[37582.818380]  [<ffffffff8023f022>] ? __mod_timer+0xb2/0xc4
[37582.818495]  [<ffffffffa03409b0>] rpc_wait_bit_killable+0x2c/0x30 [sunrp=
c]
[37582.818599]  [<ffffffff804cb264>] __wait_on_bit+0x47/0x79
[37582.818714]  [<ffffffffa0340984>] ? rpc_wait_bit_killable+0x0/0x30 [sunr=
pc]
[37582.818830]  [<ffffffffa0340984>] ? rpc_wait_bit_killable+0x0/0x30 [sunr=
pc]
[37582.818935]  [<ffffffff804cb300>] out_of_line_wait_on_bit+0x6a/0x77
[37582.819039]  [<ffffffff8024917e>] ? wake_bit_function+0x0/0x2a
[37582.819153]  [<ffffffffa033acfe>] ? call_transmit+0x21d/0x250 [sunrpc]
[37582.819269]  [<ffffffffa0341130>] __rpc_execute+0xe5/0x22b [sunrpc]
[37582.819385]  [<ffffffffa034129e>] rpc_execute+0x28/0x2c [sunrpc]
[37582.819500]  [<ffffffffa033b5dd>] rpc_run_task+0x56/0x5e [sunrpc]
[37582.819615]  [<ffffffffa033b6d0>] rpc_call_sync+0x3f/0x5d [sunrpc]
[37582.819730]  [<ffffffffa0461e81>] nfs3_rpc_wrapper+0x22/0x5c [nfs]
[37582.819845]  [<ffffffffa04625ba>] nfs3_proc_getattr+0x5b/0x81 [nfs]
[37582.819959]  [<ffffffffa0455d8f>] __nfs_revalidate_inode+0xda/0x1e6 [nfs]
[37582.820076]  [<ffffffff802a1711>] ? path_put+0x2c/0x30
[37582.820178]  [<ffffffff802a4019>] ? path_walk+0xc7/0xd4
[37582.820280]  [<ffffffff802a4202>] ? do_path_lookup+0x180/0x1a0
[37582.820393]  [<ffffffffa0455f3a>] nfs_revalidate_inode+0x44/0x49 [nfs]
[37582.820507]  [<ffffffffa04562fb>] nfs_getattr+0xaf/0xef [nfs]
[37582.820610]  [<ffffffff8029d231>] vfs_getattr+0x44/0x61
[37582.820712]  [<ffffffff8029d334>] vfs_lstat_fd+0x34/0x4b
[37582.820814]  [<ffffffff8029d36d>] sys_newlstat+0x22/0x3c
[37582.820916]  [<ffffffff8029ad1d>] ? fput+0x18/0x1a
[37582.821019]  [<ffffffff8029805c>] ? filp_close+0x67/0x72
[37582.821140]  [<ffffffff8029810c>] ? sys_close+0xa5/0xe4
[37582.821242]  [<ffffffff8020b65b>] system_call_fastpath+0x16/0x1b
[37582.821350] awesome       ? ffff8800049e3ef8     0 22887   4724
[37582.821523]  ffff8800049e3eb8 0000000000000046 ffff8800049e3eb8 ffffffff=
802416f1
[37582.821827]  ffffffff8069fdc0 ffffffff8069fdc0 0000000000000011 ffff8800=
00040001
[37582.823824]  ffff880020d8e600 ffff880074587200 ffff880020d8e878 00000001=
00000000
[37582.824140] Call Trace:
[37582.824238]  [<ffffffff802416f1>] ? do_notify_parent+0x214/0x229
[37582.824342]  [<ffffffff802374a0>] ? put_fs_struct+0x37/0x3c
[37582.824444]  [<ffffffff802394a7>] do_exit+0x7bf/0x7cd
[37582.824546]  [<ffffffff80239528>] do_group_exit+0x73/0xa0
[37582.824648]  [<ffffffff80239567>] sys_exit_group+0x12/0x16
[37582.824750]  [<ffffffff8020b65b>] system_call_fastpath+0x16/0x1b
[37582.824909]  automount
[37582.825016]=20
[37582.825117] Restarting tasks ... done.
[39108.774057] PM: Syncing filesystems ... done.
[39109.566895] Freezing user space processes ...=20
[39129.568104] Freezing of tasks failed after 20.00 seconds (1 tasks refusi=
ng to freeze):
[39129.568271]   task                        PC stack   pid father
[39129.568375] init          D 00007fff4f776030     0     1      0
[39129.568551]  ffff88007c05bd78 0000000000000086 ffff88007c05bcc8 ffffffff=
802a9348
[39129.568859]  ffffffff8069fdc0 ffffffff8069fdc0 ffff88007c05bd58 ffffffff=
802a3ca0
[39129.569189]  ffff88007c060000 ffff88007b896000 ffff88007c060278 00000000=
7bb79800
[39129.569502] Call Trace:
[39129.569606]  [<ffffffff802a9348>] ? dput+0x24/0x145
[39129.569710]  [<ffffffff802a3ca0>] ? __link_path_walk+0xcc9/0xde0
[39129.569817]  [<ffffffff8024e7e0>] refrigerator+0xe7/0xf3
[39129.569921]  [<ffffffff802425b8>] get_signal_to_deliver+0x5a/0x3aa
[39129.570026]  [<ffffffff8020a904>] do_notify_resume+0x8c/0x833
[39129.570131]  [<ffffffff8029d0c3>] ? cp_new_stat+0xe2/0xef
[39129.570236]  [<ffffffff802af502>] ? mntput_no_expire+0x2a/0x14d
[39129.570341]  [<ffffffff80250203>] ? getnstimeofday+0x58/0xb4
[39129.570446]  [<ffffffff8024bfc4>] ? ktime_get_ts+0x49/0x4e
[39129.570550]  [<ffffffff802a717d>] ? poll_select_copy_remaining+0xc5/0xea
[39129.570656]  [<ffffffff802a8467>] ? sys_select+0xa7/0xbc
[39129.570759]  [<ffffffff8020b735>] sysret_signal+0x6d/0xb7
[39129.570863] kthreadd      S ffff880043d7dba8     0     2      0
[39129.571038]  ffff88007c06ded0 0000000000000046 ffff88007c06de50 ffff8800=
7c060878
[39129.571345]  ffffffff8069fdc0 ffffffff8069fdc0 0000000000000046 ffff8800=
43d7dbd8
[39129.571652]  ffff88007c060600 ffff88005b9c2400 ffff88007c060878 00000000=
00000000
[39129.571959] Call Trace:
[39129.572073]  [<ffffffff804cafbe>] ? preempt_schedule+0x35/0x5c
[39129.572178]  [<ffffffff804cc8b5>] ? _spin_unlock_irqrestore+0x2e/0x30
[39129.572284]  [<ffffffff80248beb>] kthreadd+0x8f/0x199
[39129.572388]  [<ffffffff8020c5ea>] child_rip+0xa/0x20
[39129.572491]  [<ffffffff80248b5c>] ? kthreadd+0x0/0x199
[39129.572595]  [<ffffffff8020c5e0>] ? child_rip+0x0/0x20
[39129.572697] migration/0   S ffff880001021640     0     3      2
[39129.572872]  ffff88007c06fed0 0000000000000046 ffff88007c06fe30 ffffffff=
8022bb3e
[39129.573203]  ffffffff8069fdc0 ffffffff8069fdc0 ffff880001025dc0 ffff8800=
01025dc0
[39129.573516]  ffff88007c060c00 ffffffff805f0350 ffff88007c060e78 00000000=
00000001
[39129.573823] Call Trace:
[39129.573924]  [<ffffffff8022bb3e>] ? enqueue_entity+0x110/0x118
[39129.574029]  [<ffffffff8021c04e>] ? native_smp_send_reschedule+0x50/0x52
[39129.574135]  [<ffffffff80232b6d>] migration_thread+0x1a5/0x23b
[39129.574240]  [<ffffffff802329c8>] ? migration_thread+0x0/0x23b
[39129.574345]  [<ffffffff80248d3e>] kthread+0x49/0x76
[39129.574448]  [<ffffffff8020c5ea>] child_rip+0xa/0x20
[39129.574551]  [<ffffffff80248cf5>] ? kthread+0x0/0x76
[39129.574654]  [<ffffffff8020c5e0>] ? child_rip+0x0/0x20
[39129.574757] ksoftirqd/0   S ffffffff80640358     0     4      2
[39129.574932]  ffff88007c079ef0 0000000000000046 ffff88007c078000 ffff8800=
8097a000
[39129.575239]  ffffffff8069fdc0 ffffffff8069fdc0 ffff88007c061480 00000000=
8020c11e
[39129.575546]  ffff88007c061200 ffff88007c065400 ffff88007c061478 00000000=
806fd1a8
[39129.575853] Call Trace:
[39129.575953]  [<ffffffff8023a703>] ksoftirqd+0x62/0x17c
[39129.576070]  [<ffffffff8023a6a1>] ? ksoftirqd+0x0/0x17c
[39129.576173]  [<ffffffff8023a6a1>] ? ksoftirqd+0x0/0x17c
[39129.576277]  [<ffffffff80248d3e>] kthread+0x49/0x76
[39129.576380]  [<ffffffff8020c5ea>] child_rip+0xa/0x20
[39129.576483]  [<ffffffff80248cf5>] ? kthread+0x0/0x76
[39129.576586]  [<ffffffff8020c5e0>] ? child_rip+0x0/0x20
[39129.576689] events/0      S ffff88007c003c08     0     7      2
[39129.576863]  ffff88007c393ec0 0000000000000046 ffff88007c393e40 ffffffff=
8023f022
[39129.577193]  ffffffff8069fdc0 ffffffff8069fdc0 0000000000000282 ffff8800=
01016658
[39129.577507]  ffff88007c062a00 ffff88005b9c2400 ffff88007c062c78 00000000=
7c003c08
[39129.577814] Call Trace:
[39129.577914]  [<ffffffff8023f022>] ? __mod_timer+0xb2/0xc4
[39129.578018]  [<ffffffff80246155>] ? queue_delayed_work+0x21/0x23
[39129.578123]  [<ffffffff80246170>] ? schedule_delayed_work+0x19/0x1d
[39129.578229]  [<ffffffff8027d6e6>] ? vmstat_update+0x30/0x32
[39129.578333]  [<ffffffff80245676>] worker_thread+0xa9/0xee
[39129.578438]  [<ffffffff80249146>] ? autoremove_wake_function+0x0/0x38
[39129.578543]  [<ffffffff802455cd>] ? worker_thread+0x0/0xee
[39129.578647]  [<ffffffff80248d3e>] kthread+0x49/0x76
[39129.578750]  [<ffffffff8020c5ea>] child_rip+0xa/0x20
[39129.578853]  [<ffffffff80248cf5>] ? kthread+0x0/0x76
[39129.578957]  [<ffffffff8020c5e0>] ? child_rip+0x0/0x20
[39129.579059] work_on_cpu/0 S ffff88007c003e08     0     9      2
[39129.579234]  ffff88007c397ec0 0000000000000046 ffff88007c397e00 ffffffff=
80231ee4
[39129.579541]  ffffffff8069fdc0 ffffffff8069fdc0 0000000300000000 ffff8800=
7b875ce0
[39129.579848]  ffff88007c063600 ffff88007b952a00 ffff88007c063878 00000000=
00000286
[39129.580168] Call Trace:
[39129.580268]  [<ffffffff80231ee4>] ? default_wake_function+0xd/0xf
[39129.580373]  [<ffffffff802458ac>] ? wq_barrier_func+0xd/0xf
[39129.580477]  [<ffffffff80245676>] worker_thread+0xa9/0xee
[39129.580582]  [<ffffffff80249146>] ? autoremove_wake_function+0x0/0x38
[39129.580687]  [<ffffffff802455cd>] ? worker_thread+0x0/0xee
[39129.580791]  [<ffffffff80248d3e>] kthread+0x49/0x76
[39129.580894]  [<ffffffff8020c5ea>] child_rip+0xa/0x20
[39129.580997]  [<ffffffff80248cf5>] ? kthread+0x0/0x76
[39129.581102]  [<ffffffff8020c5e0>] ? child_rip+0x0/0x20
[39129.581223] khelper       S ffff88007c34d008     0    11      2
[39129.581404]  ffff88007c39bec0 0000000000000046 0000000000000000 ffff8800=
01025dc0
[39129.581711]  ffffffff8069fdc0 ffffffff8069fdc0 0000000000005fbb 00000000=
00000001
[39129.582018]  ffff88007c064200 ffff880032ca1800 ffff88007c064478 00000001=
00000000
[39129.582325] Call Trace:
[39129.582424]  [<ffffffff8020c5e0>] ? child_rip+0x0/0x20
[39129.582528]  [<ffffffff80244e2e>] ? __call_usermodehelper+0x4d/0x6c
[39129.582633]  [<ffffffff80245676>] worker_thread+0xa9/0xee
[39129.582737]  [<ffffffff80249146>] ? autoremove_wake_function+0x0/0x38
[39129.582842]  [<ffffffff802455cd>] ? worker_thread+0x0/0xee
[39129.582946]  [<ffffffff80248d3e>] kthread+0x49/0x76
[39129.583050]  [<ffffffff8020c5ea>] child_rip+0xa/0x20
[39129.583153]  [<ffffffff80248cf5>] ? kthread+0x0/0x76
[39129.583256]  [<ffffffff8020c5e0>] ? child_rip+0x0/0x20
[39129.583359] kblockd/0     S ffff88007c34d608     0   111      2
[39129.583534]  ffff88007b8d5ec0 0000000000000046 ffff88007a9c0858 ffff8800=
7a9c0970
[39129.583841]  ffffffff8069fdc0 ffffffff8069fdc0 ffff88007b8d5e30 ffffffff=
8033ff8b
[39129.584161]  ffff88007c064800 ffff88007b895a00 ffff88007c064a78 00000000=
80340075
[39129.584468] Call Trace:
[39129.584569]  [<ffffffff8033ff8b>] ? __generic_unplug_device+0x2d/0x32
[39129.584675]  [<ffffffff80347911>] ? as_work_handler+0x0/0x39
[39129.584779]  [<ffffffff8033e6a7>] ? blk_unplug_work+0x7a/0x82
[39129.584884]  [<ffffffff80245676>] worker_thread+0xa9/0xee
[39129.584988]  [<ffffffff80249146>] ? autoremove_wake_function+0x0/0x38
[39129.585095]  [<ffffffff802455cd>] ? worker_thread+0x0/0xee
[39129.585218]  [<ffffffff80248d3e>] kthread+0x49/0x76
[39129.585321]  [<ffffffff8020c5ea>] child_rip+0xa/0x20
[39129.585430]  [<ffffffff80248cf5>] ? kthread+0x0/0x76
[39129.585533]  [<ffffffff8020c5e0>] ? child_rip+0x0/0x20
[39129.585636] kacpid        S ffff88007c34d808     0   113      2
[39129.585811]  ffff88007b8d9ec0 0000000000000046 ffff88007c349940 ffff8800=
7c3498c0
[39129.586118]  ffffffff8069fdc0 ffffffff8069fdc0 0000000000000000 00000000=
0000002a
[39129.586424]  ffff88007c065400 ffff88005b9c2400 ffff88007c065678 00000000=
7c34d808
[39129.586730] Call Trace:
[39129.586831]  [<ffffffff80367756>] ? acpi_os_execute_deferred+0x34/0x39
[39129.586936]  [<ffffffff80245676>] worker_thread+0xa9/0xee
[39129.587041]  [<ffffffff80249146>] ? autoremove_wake_function+0x0/0x38
[39129.587146]  [<ffffffff802455cd>] ? worker_thread+0x0/0xee
[39129.587249]  [<ffffffff80248d3e>] kthread+0x49/0x76
[39129.587352]  [<ffffffff8020c5ea>] child_rip+0xa/0x20
[39129.587455]  [<ffffffff80248cf5>] ? kthread+0x0/0x76
[39129.587558]  [<ffffffff8020c5e0>] ? child_rip+0x0/0x20
[39129.587660] kacpi_notify  S ffff88007c34d988     0   114      2
[39129.587835]  ffff88007b8dbec0 0000000000000046 ffff88007b8dbe20 00000000=
00000246
[39129.588155]  ffffffff8069fdc0 ffffffff8069fdc0 ffff88007c34d980 ffff8800=
2b95f650
[39129.588461]  ffff88007c065a00 ffff88005b9c2400 ffff88007c065c78 00000000=
80387579
[39129.588767] Call Trace:
[39129.588867]  [<ffffffff80367756>] ? acpi_os_execute_deferred+0x34/0x39
[39129.588973]  [<ffffffff80245676>] worker_thread+0xa9/0xee
[39129.589079]  [<ffffffff80249146>] ? autoremove_wake_function+0x0/0x38
[39129.589202]  [<ffffffff802455cd>] ? worker_thread+0x0/0xee
[39129.589306]  [<ffffffff80248d3e>] kthread+0x49/0x76
[39129.589415]  [<ffffffff8020c5ea>] child_rip+0xa/0x20
[39129.589517]  [<ffffffff80248cf5>] ? kthread+0x0/0x76
[39129.589620]  [<ffffffff8020c5e0>] ? child_rip+0x0/0x20
[39129.589722] ata/0         S ffff88007b8f9708     0   197      2
[39129.589897]  ffff88007b91dec0 0000000000000046 ffff88007b91de20 ffff8800=
01015580
[39129.590203]  ffffffff8069fdc0 ffffffff8069fdc0 ffff88007b91de40 ffffffff=
8022ff17
[39129.590510]  ffff88007b904200 ffff88007c060600 ffff88007b904478 00000000=
00000000
[39129.590816] Call Trace:
[39129.592688]  [<ffffffff8022ff17>] ? finish_task_switch+0x2b/0x8e
[39129.592793]  [<ffffffff80245676>] worker_thread+0xa9/0xee
[39129.592897]  [<ffffffff80249146>] ? autoremove_wake_function+0x0/0x38
[39129.593003]  [<ffffffff802455cd>] ? worker_thread+0x0/0xee
[39129.593126]  [<ffffffff80248d3e>] kthread+0x49/0x76
[39129.593229]  [<ffffffff8020c5ea>] child_rip+0xa/0x20
[39129.593338]  [<ffffffff80248cf5>] ? kthread+0x0/0x76
[39129.593440]  [<ffffffff8020c5e0>] ? child_rip+0x0/0x20
[39129.593543] ata_aux       S ffff88007b8f9908     0   199      2
[39129.593718]  ffff88007b921ec0 0000000000000046 ffff88007b921e10 ffffffff=
8034df22
[39129.594023]  ffffffff8069fdc0 ffffffff8069fdc0 ffff88007b921e20 ffffffff=
803bbe36
[39129.594330]  ffff88007b904e00 ffff88007c064800 ffff88007b905078 00000000=
00000246
[39129.594636] Call Trace:
[39129.594736]  [<ffffffff8034df22>] ? kobject_put+0x47/0x4b
[39129.594840]  [<ffffffff803bbe36>] ? put_device+0x15/0x17
[39129.594944]  [<ffffffff803f8288>] ? ata_scsi_dev_rescan+0x0/0xcb
[39129.595049]  [<ffffffff80245676>] worker_thread+0xa9/0xee
[39129.595153]  [<ffffffff80249146>] ? autoremove_wake_function+0x0/0x38
[39129.595258]  [<ffffffff802455cd>] ? worker_thread+0x0/0xee
[39129.595361]  [<ffffffff80248d3e>] kthread+0x49/0x76
[39129.595463]  [<ffffffff8020c5ea>] child_rip+0xa/0x20
[39129.595567]  [<ffffffff80248cf5>] ? kthread+0x0/0x76
[39129.595669]  [<ffffffff8020c5e0>] ? child_rip+0x0/0x20
[39129.595771] kseriod       S ffff880025416340     0   201      2
[39129.595946]  ffff88007b929ea0 0000000000000046 ffffffff803bf1e0 ffff8800=
7b929df0
[39129.596265]  ffffffff8069fdc0 ffffffff8069fdc0 ffff88007c355e98 00000000=
00000246
[39129.596572]  ffff88007b905a00 ffffffff805f0350 ffff88007b905c78 00000000=
7b9784b8
[39129.596878] Call Trace:
[39129.596978]  [<ffffffff803bf1e0>] ? __device_attach+0x0/0xb
[39129.597084]  [<ffffffff80423ef3>] serio_thread+0x2ff/0x377
[39129.597206]  [<ffffffff80249146>] ? autoremove_wake_function+0x0/0x38
[39129.597312]  [<ffffffff80423bf4>] ? serio_thread+0x0/0x377
[39129.597421]  [<ffffffff80248d3e>] kthread+0x49/0x76
[39129.597524]  [<ffffffff8020c5ea>] child_rip+0xa/0x20
[39129.597627]  [<ffffffff80248cf5>] ? kthread+0x0/0x76
[39129.597730]  [<ffffffff8020c5e0>] ? child_rip+0x0/0x20
[39129.597832] khpsbpkt      S 0000000000000001     0   229      2
[39129.598007]  ffff88007b815ee0 0000000000000046 ffff88007b815e40 ffffffff=
8022ff17
[39129.598314]  ffffffff8069fdc0 ffffffff8069fdc0 ffffffff805f0020 ffffffff=
80677e50
[39129.598621]  ffff88007b950000 ffffffff805f0350 ffff88007b950278 00000000=
00000000
[39129.598927] Call Trace:
[39129.599027]  [<ffffffff8022ff17>] ? finish_task_switch+0x2b/0x8e
[39129.599132]  [<ffffffff80412570>] hpsbpkt_thread+0xf8/0x122
[39129.599236]  [<ffffffff80412478>] ? hpsbpkt_thread+0x0/0x122
[39129.599340]  [<ffffffff80412478>] ? hpsbpkt_thread+0x0/0x122
[39129.599443]  [<ffffffff80248d3e>] kthread+0x49/0x76
[39129.599547]  [<ffffffff8020c5ea>] child_rip+0xa/0x20
[39129.599650]  [<ffffffff80248cf5>] ? kthread+0x0/0x76
[39129.599753]  [<ffffffff8020c5e0>] ? child_rip+0x0/0x20
[39129.599855] kondemand/0   S ffff88007c38d408     0   236      2
[39129.600042]  ffff88007b875ec0 0000000000000046 ffff88007b875e80 ffffffff=
804372f7
[39129.600349]  ffffffff8069fdc0 ffffffff8069fdc0 ffffffff8022acbd 00000000=
00000000
[39129.600656]  ffff88007b952a00 ffff88005b9c2400 ffff88007b952c78 00000000=
8020bf8e
[39129.600963] Call Trace:
[39129.601066]  [<ffffffff804372f7>] ? do_dbs_timer+0x2c3/0x2d2
[39129.601188]  [<ffffffff8022acbd>] ? dequeue_task+0xad/0xb8
[39129.601292]  [<ffffffff80437034>] ? do_dbs_timer+0x0/0x2d2
[39129.601402]  [<ffffffff80245676>] worker_thread+0xa9/0xee
[39129.601506]  [<ffffffff80249146>] ? autoremove_wake_function+0x0/0x38
[39129.601611]  [<ffffffff802455cd>] ? worker_thread+0x0/0xee
[39129.601715]  [<ffffffff80248d3e>] kthread+0x49/0x76
[39129.601818]  [<ffffffff8020c5ea>] child_rip+0xa/0x20
[39129.601921]  [<ffffffff8022acbd>] ? dequeue_task+0xad/0xb8
[39129.602025]  [<ffffffff80248cf5>] ? kthread+0x0/0x76
[39129.602128]  [<ffffffff8020c5e0>] ? child_rip+0x0/0x20
[39129.602231] pdflush       S ffff88007c05bd20     0   271      2
[39129.602405]  ffff88007b97dec0 0000000000000046 ffff88007b97de00 ffffffff=
8024c20f
[39129.602712]  ffffffff8069fdc0 ffffffff8069fdc0 ffff88007b907478 00000000=
7b97dee8
[39129.603020]  ffff88007b907200 ffff88007b907800 ffff88007b907478 00000000=
80273c56
[39129.603363] Call Trace:
[39129.603463]  [<ffffffff8024c20f>] ? up_read+0x9/0xb
[39129.603567]  [<ffffffff80274455>] pdflush+0xec/0x203
[39129.603670]  [<ffffffff80274369>] ? pdflush+0x0/0x203
[39129.603773]  [<ffffffff80248d3e>] kthread+0x49/0x76
[39129.603876]  [<ffffffff8020c5ea>] child_rip+0xa/0x20
[39129.603979]  [<ffffffff8022acbd>] ? dequeue_task+0xad/0xb8
[39129.604096]  [<ffffffff80248cf5>] ? kthread+0x0/0x76
[39129.604200]  [<ffffffff8020c5e0>] ? child_rip+0x0/0x20
[39129.604303] pdflush       S ffff88007c05bd20     0   272      2
[39129.604478]  ffff88007b97fec0 0000000000000046 ffff88007c020470 ffff8800=
7b97fe50
[39129.604785]  ffffffff8069fdc0 ffffffff8069fdc0 000000010094215c ffff8800=
7b97fe50
[39129.605094]  ffff88007b907800 ffff88005b9c2400 ffff88007b907a78 00000000=
8023f0af
[39129.605425] Call Trace:
[39129.605525]  [<ffffffff80274455>] pdflush+0xec/0x203
[39129.605628]  [<ffffffff80274369>] ? pdflush+0x0/0x203
[39129.605731]  [<ffffffff80248d3e>] kthread+0x49/0x76
[39129.605834]  [<ffffffff8020c5ea>] child_rip+0xa/0x20
[39129.605937]  [<ffffffff8022acbd>] ? dequeue_task+0xad/0xb8
[39129.606041]  [<ffffffff80248cf5>] ? kthread+0x0/0x76
[39129.606144]  [<ffffffff8020c5e0>] ? child_rip+0x0/0x20
[39129.606246] kswapd0       S ffffffffffffffff     0   273      2
[39129.606422]  ffff88007bb01de0 0000000000000046 0000000000000004 ffffffff=
8062c900
[39129.606729]  ffffffff8069fdc0 ffffffff8069fdc0 ffff88007bb01de0 ffffffff=
8027800c
[39129.607036]  ffff88007c067800 ffff880020d8c200 ffff88007c067a78 00000000=
8035120b
[39129.607342] Call Trace:
[39129.607442]  [<ffffffff8027800c>] ? shrink_zone+0x31a/0x329
[39129.607547]  [<ffffffff8024c20f>] ? up_read+0x9/0xb
[39129.607649]  [<ffffffff80278196>] ? shrink_slab+0x17b/0x18d
[39129.607754]  [<ffffffff802782ba>] kswapd+0x112/0x69a
[39129.607857]  [<ffffffff802781a8>] ? kswapd+0x0/0x69a
[39129.607960]  [<ffffffff80276119>] ? isolate_pages_global+0x0/0x22d
[39129.608077]  [<ffffffff80249146>] ? autoremove_wake_function+0x0/0x38
[39129.608182]  [<ffffffff802781a8>] ? kswapd+0x0/0x69a
[39129.608285]  [<ffffffff80248d3e>] kthread+0x49/0x76
[39129.608388]  [<ffffffff8020c5ea>] child_rip+0xa/0x20
[39129.608492]  [<ffffffff8022acbd>] ? dequeue_task+0xad/0xb8
[39129.608595]  [<ffffffff80248cf5>] ? kthread+0x0/0x76
[39129.608698]  [<ffffffff8020c5e0>] ? child_rip+0x0/0x20
[39129.608801] aio/0         S ffff88007c38dc08     0   320      2
[39129.608975]  ffff88007bb9bec0 0000000000000046 ffff88007bb9be20 ffff8800=
01015580
[39129.609308]  ffffffff8069fdc0 ffffffff8069fdc0 ffff88007bb9be40 ffffffff=
8022ff17
[39129.609615]  ffff88007bba0000 ffff88007c060600 ffff88007bba0278 00000000=
80677e50
[39129.609921] Call Trace:
[39129.610020]  [<ffffffff8022ff17>] ? finish_task_switch+0x2b/0x8e
[39129.610125]  [<ffffffff80245676>] worker_thread+0xa9/0xee
[39129.610228]  [<ffffffff80249146>] ? autoremove_wake_function+0x0/0x38
[39129.610333]  [<ffffffff802455cd>] ? worker_thread+0x0/0xee
[39129.610437]  [<ffffffff80248d3e>] kthread+0x49/0x76
[39129.610540]  [<ffffffff8020c5ea>] child_rip+0xa/0x20
[39129.610643]  [<ffffffff8022acbd>] ? dequeue_task+0xad/0xb8
[39129.610747]  [<ffffffff80248cf5>] ? kthread+0x0/0x76
[39129.610850]  [<ffffffff8020c5e0>] ? child_rip+0x0/0x20
[39129.610952] jfsIO         S ffff88007c05bd10     0   332      2
[39129.611127]  ffff88007ad8df00 0000000000000046 ffff880032d2c480 ffffffff=
8063f3f0
[39129.611435]  ffffffff8069fdc0 ffffffff8069fdc0 0000000000000010 00000000=
00000000
[39129.611741]  ffff88007bba4800 ffff8800795da400 ffff88007bba4a78 00000000=
5d085780
[39129.612061] Call Trace:
[39129.612161]  [<ffffffff8033f2b8>] ? submit_bio+0x10a/0x113
[39129.612266]  [<ffffffff8031c626>] jfsIOWait+0x8b/0xc2
[39129.612369]  [<ffffffff8031c59b>] ? jfsIOWait+0x0/0xc2
[39129.612473]  [<ffffffff80248d3e>] kthread+0x49/0x76
[39129.612576]  [<ffffffff8020c5ea>] child_rip+0xa/0x20
[39129.612679]  [<ffffffff8022acbd>] ? dequeue_task+0xad/0xb8
[39129.612782]  [<ffffffff80248cf5>] ? kthread+0x0/0x76
[39129.612886]  [<ffffffff8020c5e0>] ? child_rip+0x0/0x20
[39129.612988] jfsCommit     S ffff8800794962e8     0   333      2
[39129.613183]  ffff88007ad8feb0 0000000000000046 0000000300000000 ffffffff=
80729600
[39129.613496]  ffffffff8069fdc0 ffffffff8069fdc0 0000000000000282 00000000=
00000282
[39129.613803]  ffff88007bba4e00 ffff88007bba5400 ffff88007bba5078 00000000=
00000000
[39129.614111] Call Trace:
[39129.614210]  [<ffffffff8022b175>] ? __wake_up+0x43/0x50
[39129.614314]  [<ffffffff8032138b>] jfs_lazycommit+0x24d/0x2c0
[39129.614418]  [<ffffffff80231ed7>] ? default_wake_function+0x0/0xf
[39129.614523]  [<ffffffff8032113e>] ? jfs_lazycommit+0x0/0x2c0
[39129.614627]  [<ffffffff80248d3e>] kthread+0x49/0x76
[39129.614730]  [<ffffffff8020c5ea>] child_rip+0xa/0x20
[39129.614833]  [<ffffffff8022acbd>] ? dequeue_task+0xad/0xb8
[39129.614936]  [<ffffffff80248cf5>] ? kthread+0x0/0x76
[39129.615039]  [<ffffffff8020c5e0>] ? child_rip+0x0/0x20
[39129.615141] jfsCommit     S ffff8800798dbee8     0   334      2
[39129.617089]  ffff88007ad91eb0 0000000000000046 0000000300000000 ffffffff=
80729600
[39129.617418]  ffffffff8069fdc0 ffffffff8069fdc0 0000000000000282 00000000=
00000282
[39129.617723]  ffff88007bba5400 ffffffff805f0350 ffff88007bba5678 00000000=
00000000
[39129.618029] Call Trace:
[39129.618128]  [<ffffffff8022b175>] ? __wake_up+0x43/0x50
[39129.618231]  [<ffffffff8032138b>] jfs_lazycommit+0x24d/0x2c0
[39129.618335]  [<ffffffff80231ed7>] ? default_wake_function+0x0/0xf
[39129.618440]  [<ffffffff8032113e>] ? jfs_lazycommit+0x0/0x2c0
[39129.618544]  [<ffffffff80248d3e>] kthread+0x49/0x76
[39129.618645]  [<ffffffff8020c5ea>] child_rip+0xa/0x20
[39129.618748]  [<ffffffff8022acbd>] ? dequeue_task+0xad/0xb8
[39129.618851]  [<ffffffff80248cf5>] ? kthread+0x0/0x76
[39129.618954]  [<ffffffff8020c5e0>] ? child_rip+0x0/0x20
[39129.619056] jfsSync       S ffff88007c05bd10     0   335      2
[39129.619230]  ffff88007ad93ed0 0000000000000046 ffff88007c060638 ffff8800=
01019dc0
[39129.619536]  ffffffff8069fdc0 ffffffff8069fdc0 ffffffff8069fdc0 00000000=
00000000
[39129.619841]  ffff88007bba5a00 ffffffff805f0350 ffff88007bba5c78 00000000=
804cad4c
[39129.620158] Call Trace:
[39129.620257]  [<ffffffff80320e28>] ? jfs_sync+0x0/0x1fb
[39129.620360]  [<ffffffff80320fde>] jfs_sync+0x1b6/0x1fb
[39129.620463]  [<ffffffff80320e28>] ? jfs_sync+0x0/0x1fb
[39129.620566]  [<ffffffff80248d3e>] kthread+0x49/0x76
[39129.620668]  [<ffffffff8020c5ea>] child_rip+0xa/0x20
[39129.620770]  [<ffffffff8022acbd>] ? dequeue_task+0xad/0xb8
[39129.620872]  [<ffffffff80248cf5>] ? kthread+0x0/0x76
[39129.620975]  [<ffffffff8020c5e0>] ? child_rip+0x0/0x20
[39129.621078] scsi_eh_0     S ffff88007c05b8f0     0   996      2
[39129.621269]  ffff88007ade3e80 0000000000000046 0000000000000000 00000000=
00000246
[39129.621580]  ffffffff8069fdc0 ffffffff8069fdc0 ffff88007ade3df0 ffffffff=
8034df22
[39129.621885]  ffff88007b900c00 ffff88007c061200 ffff88007b900e78 00000000=
803bbe36
[39129.622191] Call Trace:
[39129.622290]  [<ffffffff8034df22>] ? kobject_put+0x47/0x4b
[39129.622393]  [<ffffffff803defa1>] ? __scsi_iterate_devices+0x67/0x77
[39129.622498]  [<ffffffff803e2879>] scsi_error_handler+0x67/0x326
[39129.622601]  [<ffffffff8022ae48>] ? __wake_up_common+0x46/0x76
[39129.622704]  [<ffffffff803e2812>] ? scsi_error_handler+0x0/0x326
[39129.622808]  [<ffffffff80248d3e>] kthread+0x49/0x76
[39129.622910]  [<ffffffff8020c5ea>] child_rip+0xa/0x20
[39129.623012]  [<ffffffff8022acbd>] ? dequeue_task+0xad/0xb8
[39129.623115]  [<ffffffff80248cf5>] ? kthread+0x0/0x76
[39129.623217]  [<ffffffff8020c5e0>] ? child_rip+0x0/0x20
[39129.623319] scsi_eh_1     S ffff88007c05b8f0     0   998      2
[39129.623492]  ffff88007b88fe80 0000000000000046 0000000000000000 00000000=
00000246
[39129.623798]  ffffffff8069fdc0 ffffffff8069fdc0 ffff88007b88fdf0 ffffffff=
8034df22
[39129.624115]  ffff88007b901800 ffff88007b904e00 ffff88007b901a78 00000000=
803bbe36
[39129.624419] Call Trace:
[39129.624518]  [<ffffffff8034df22>] ? kobject_put+0x47/0x4b
[39129.624620]  [<ffffffff803defa1>] ? __scsi_iterate_devices+0x67/0x77
[39129.624724]  [<ffffffff803e2879>] scsi_error_handler+0x67/0x326
[39129.624828]  [<ffffffff8022ae48>] ? __wake_up_common+0x46/0x76
[39129.624931]  [<ffffffff803e2812>] ? scsi_error_handler+0x0/0x326
[39129.625036]  [<ffffffff80248d3e>] kthread+0x49/0x76
[39129.625157]  [<ffffffff8020c5ea>] child_rip+0xa/0x20
[39129.625260]  [<ffffffff80248cf5>] ? kthread+0x0/0x76
[39129.625367]  [<ffffffff8020c5e0>] ? child_rip+0x0/0x20
[39129.625469] scsi_eh_2     S ffff88007c05b8f0     0  1000      2
[39129.625642]  ffff88007b85be80 0000000000000046 0000000000000000 00000000=
00000000
[39129.625947]  ffffffff8069fdc0 ffffffff8069fdc0 ffff88007b85be10 ffffffff=
8022b175
[39129.626252]  ffff88007b902400 ffff88005b9c2400 ffff88007b902678 00000000=
00000000
[39129.626558] Call Trace:
[39129.626657]  [<ffffffff8022b175>] ? __wake_up+0x43/0x50
[39129.626760]  [<ffffffff803def94>] ? __scsi_iterate_devices+0x5a/0x77
[39129.626865]  [<ffffffff803e2879>] scsi_error_handler+0x67/0x326
[39129.626968]  [<ffffffff8022ae48>] ? __wake_up_common+0x46/0x76
[39129.627072]  [<ffffffff803e2812>] ? scsi_error_handler+0x0/0x326
[39129.627176]  [<ffffffff80248d3e>] kthread+0x49/0x76
[39129.627278]  [<ffffffff8020c5ea>] child_rip+0xa/0x20
[39129.627381]  [<ffffffff80248cf5>] ? kthread+0x0/0x76
[39129.627484]  [<ffffffff8020c5e0>] ? child_rip+0x0/0x20
[39129.627586] scsi_eh_3     S ffff88007c05b8f0     0  1002      2
[39129.627761]  ffff88007ad97e80 0000000000000046 0000000000000000 00000000=
00000000
[39129.628080]  ffffffff8069fdc0 ffffffff8069fdc0 ffff88007ad97e10 ffffffff=
8022b175
[39129.628387]  ffff88007b903000 ffff88005b9c2400 ffff88007b903278 00000000=
00000000
[39129.628694] Call Trace:
[39129.628793]  [<ffffffff8022b175>] ? __wake_up+0x43/0x50
[39129.628896]  [<ffffffff803def94>] ? __scsi_iterate_devices+0x5a/0x77
[39129.629002]  [<ffffffff803e2879>] scsi_error_handler+0x67/0x326
[39129.629127]  [<ffffffff8022ae48>] ? __wake_up_common+0x46/0x76
[39129.629232]  [<ffffffff803e2812>] ? scsi_error_handler+0x0/0x326
[39129.629342]  [<ffffffff80248d3e>] kthread+0x49/0x76
[39129.629445]  [<ffffffff8020c5ea>] child_rip+0xa/0x20
[39129.629548]  [<ffffffff80248cf5>] ? kthread+0x0/0x76
[39129.629651]  [<ffffffff8020c5e0>] ? child_rip+0x0/0x20
[39129.629753] kpsmoused     S ffff88007b942108     0  1032      2
[39129.629927]  ffff88007b94fec0 0000000000000046 ffffffff802455cd ffff8800=
7c05bcb0
[39129.630233]  ffffffff8069fdc0 ffffffff8069fdc0 ffff88007b94fe40 ffffffff=
8022ff17
[39129.630540]  ffff88007c066000 ffff88007c062400 ffff88007c066278 00000001=
00000000
[39129.630845] Call Trace:
[39129.630945]  [<ffffffff802455cd>] ? worker_thread+0x0/0xee
[39129.631048]  [<ffffffff8022ff17>] ? finish_task_switch+0x2b/0x8e
[39129.631152]  [<ffffffff80231ec5>] ? try_to_wake_up+0x1d2/0x1e4
[39129.631256]  [<ffffffff80245676>] worker_thread+0xa9/0xee
[39129.631360]  [<ffffffff80249146>] ? autoremove_wake_function+0x0/0x38
[39129.631465]  [<ffffffff802455cd>] ? worker_thread+0x0/0xee
[39129.631569]  [<ffffffff80248d3e>] kthread+0x49/0x76
[39129.631671]  [<ffffffff8020c5ea>] child_rip+0xa/0x20
[39129.631774]  [<ffffffff80248cf5>] ? kthread+0x0/0x76
[39129.631877]  [<ffffffff8020c5e0>] ? child_rip+0x0/0x20
[39129.631979] hid_compat    S ffff88007b8ead88     0  1059      2
[39129.632167]  ffff88007a995ec0 0000000000000046 ffffffff802455cd ffff8800=
7c05bcb0
[39129.632473]  ffffffff8069fdc0 ffffffff8069fdc0 ffff88007a995e40 ffffffff=
8022ff17
[39129.632780]  ffff88007b953c00 ffff88007c062400 ffff88007b953e78 00000001=
00000000
[39129.633089] Call Trace:
[39129.633209]  [<ffffffff802455cd>] ? worker_thread+0x0/0xee
[39129.633313]  [<ffffffff8022ff17>] ? finish_task_switch+0x2b/0x8e
[39129.633423]  [<ffffffff80231ec5>] ? try_to_wake_up+0x1d2/0x1e4
[39129.633528]  [<ffffffff8043c12f>] ? hid_compat_load+0x12/0x14
[39129.633632]  [<ffffffff80245676>] worker_thread+0xa9/0xee
[39129.633736]  [<ffffffff80249146>] ? autoremove_wake_function+0x0/0x38
[39129.633841]  [<ffffffff802455cd>] ? worker_thread+0x0/0xee
[39129.633944]  [<ffffffff80248d3e>] kthread+0x49/0x76
[39129.634047]  [<ffffffff8020c5ea>] child_rip+0xa/0x20
[39129.634150]  [<ffffffff80248cf5>] ? kthread+0x0/0x76
[39129.634253]  [<ffffffff8020c5e0>] ? child_rip+0x0/0x20
[39129.634356] udevd         D 0000000000000009     0  1172      1
[39129.634530]  ffff88007a949d78 0000000000000082 0000000000000000 00000000=
00000000
[39129.634837]  ffffffff8069fdc0 ffffffff8069fdc0 ffff88007a949ce8 ffffffff=
80227295
[39129.635143]  ffff88007bba2400 ffff88007c061200 ffff88007bba2678 00000000=
8027f986
[39129.635450] Call Trace:
[39129.635550]  [<ffffffff80227295>] ? ptep_set_access_flags+0x22/0x28
[39129.635656]  [<ffffffff8024e7e0>] refrigerator+0xe7/0xf3
[39129.635759]  [<ffffffff802425b8>] get_signal_to_deliver+0x5a/0x3aa
[39129.635863]  [<ffffffff8020a904>] do_notify_resume+0x8c/0x833
[39129.635967]  [<ffffffff802a9238>] ? shrink_dcache_parent+0x116/0x12b
[39129.636084]  [<ffffffff802a1437>] ? inode_permission+0x8b/0x97
[39129.636189]  [<ffffffff802493a8>] ? remove_wait_queue+0x3c/0x41
[39129.636294]  [<ffffffff80238ad4>] ? do_wait+0x2d6/0x393
[39129.636397]  [<ffffffff802a8467>] ? sys_select+0xa7/0xbc
[39129.636500]  [<ffffffff8020b735>] sysret_signal+0x6d/0xb7
[39129.636602] ktpacpid      S ffff88007a5df408     0  2062      2
[39129.636777]  ffff88007a563ec0 0000000000000046 ffff88007a563e20 ffff8800=
01021580
[39129.637085]  ffffffff8069fdc0 ffffffff8069fdc0 ffff88007a563e40 ffffffff=
8022ff17
[39129.637416]  ffff88007b956600 ffff88007b950600 ffff88007b956878 00000001=
0100ae58
[39129.637722] Call Trace:
[39129.637821]  [<ffffffff8022ff17>] ? finish_task_switch+0x2b/0x8e
[39129.637925]  [<ffffffff80231ec5>] ? try_to_wake_up+0x1d2/0x1e4
[39129.638029]  [<ffffffff80245676>] worker_thread+0xa9/0xee
[39129.638133]  [<ffffffff80249146>] ? autoremove_wake_function+0x0/0x38
[39129.638238]  [<ffffffff802455cd>] ? worker_thread+0x0/0xee
[39129.638341]  [<ffffffff80248d3e>] kthread+0x49/0x76
[39129.638444]  [<ffffffff8020c5ea>] child_rip+0xa/0x20
[39129.638547]  [<ffffffff80248cf5>] ? kthread+0x0/0x76
[39129.638649]  [<ffffffff8020c5e0>] ? child_rip+0x0/0x20
[39129.638751] ksuspend_usbd S ffff8800799d6208     0  2221      2
[39129.638926]  ffff8800795b3ec0 0000000000000046 ffff8800795b9d10 ffff8800=
795b9980
[39129.639231]  ffffffff8069fdc0 ffffffff8069fdc0 0000000000000210 00000000=
00000000
[39129.639538]  ffff88007b895400 ffff88007b893c00 ffff88007b895678 00000000=
00000246
[39129.641613] Call Trace:
[39129.641756]  [<ffffffffa009ba89>] ? hcd_resume_work+0x32/0x37 [usbcore]
[39129.641867]  [<ffffffff80245676>] worker_thread+0xa9/0xee
[39129.641971]  [<ffffffff80249146>] ? autoremove_wake_function+0x0/0x38
[39129.642075]  [<ffffffff802455cd>] ? worker_thread+0x0/0xee
[39129.642179]  [<ffffffff80248d3e>] kthread+0x49/0x76
[39129.642281]  [<ffffffff8020c5ea>] child_rip+0xa/0x20
[39129.642384]  [<ffffffff802598c4>] ? load_module+0x3c/0x188d
[39129.642487]  [<ffffffff8022acbd>] ? dequeue_task+0xad/0xb8
[39129.642591]  [<ffffffff80248cf5>] ? kthread+0x0/0x76
[39129.642694]  [<ffffffff8020c5e0>] ? child_rip+0x0/0x20
[39129.642795] khubd         S ffff88007a473001     0  2224      2
[39129.642970]  ffff88007959bdb0 0000000000000046 ffff88007959bd40 ffffffff=
a009ea63
[39129.643275]  ffffffff8069fdc0 ffffffff8069fdc0 ffff88007a9a5800 ffff8800=
795bd150
[39129.643581]  ffff88007b893c00 ffff88007b894e00 ffff88007b893e78 00000000=
795b7400
[39129.643887] Call Trace:
[39129.643998]  [<ffffffffa009ea63>] ? usb_control_msg+0xe0/0xf1 [usbcore]
[39129.644123]  [<ffffffffa0097af1>] ? hub_port_status+0xfe/0x110 [usbcore]
[39129.644240]  [<ffffffffa009b38e>] hub_thread+0xf62/0xff0 [usbcore]
[39129.644345]  [<ffffffff80249146>] ? autoremove_wake_function+0x0/0x38
[39129.644462]  [<ffffffffa009a42c>] ? hub_thread+0x0/0xff0 [usbcore]
[39129.644567]  [<ffffffff80248d3e>] kthread+0x49/0x76
[39129.644669]  [<ffffffff8020c5ea>] child_rip+0xa/0x20
[39129.644772]  [<ffffffff8022acbd>] ? dequeue_task+0xad/0xb8
[39129.644876]  [<ffffffff80248cf5>] ? kthread+0x0/0x76
[39129.644978]  [<ffffffff8020c5e0>] ? child_rip+0x0/0x20
[39129.645082] iwlagn        S ffff88007af24888     0  2358      2
[39129.645274]  ffff88007902dec0 0000000000000046 ffff880079086078 00000000=
00000082
[39129.645586]  ffffffff8069fdc0 ffffffff8069fdc0 ffff880079081240 ffff8800=
79081240
[39129.645892]  ffff8800795df200 ffff88005b9c2400 ffff8800795df478 00000000=
a01335ff
[39129.646198] Call Trace:
[39129.646303]  [<ffffffffa014eff1>] ? iwl_bg_rx_replenish+0x37/0x3c [iwlag=
n]
[39129.646408]  [<ffffffff80245676>] worker_thread+0xa9/0xee
[39129.646512]  [<ffffffff80249146>] ? autoremove_wake_function+0x0/0x38
[39129.646617]  [<ffffffff802455cd>] ? worker_thread+0x0/0xee
[39129.646721]  [<ffffffff80248d3e>] kthread+0x49/0x76
[39129.646823]  [<ffffffff8020c5ea>] child_rip+0xa/0x20
[39129.646926]  [<ffffffff80248cf5>] ? kthread+0x0/0x76
[39129.647028]  [<ffffffff8020c5e0>] ? child_rip+0x0/0x20
[39129.647130] phy0          S ffff8800795aa888     0  2360      2
[39129.647305]  ffff880079565ec0 0000000000000046 ffff880079565e80 ffffffff=
a0101908
[39129.647610]  ffffffff8069fdc0 ffffffff8069fdc0 ffffffff8022acbd ffff8800=
79565dc0
[39129.647916]  ffff8800795dec00 ffff88007c061200 ffff8800795dee78 00000000=
7b9728e0
[39129.648234] Call Trace:
[39129.648343]  [<ffffffffa0101908>] ? ieee80211_sta_work+0x3c2/0x84b [mac8=
0211]
[39129.648449]  [<ffffffff8022acbd>] ? dequeue_task+0xad/0xb8
[39129.648559]  [<ffffffffa0101546>] ? ieee80211_sta_work+0x0/0x84b [mac802=
11]
[39129.648665]  [<ffffffff80245676>] worker_thread+0xa9/0xee
[39129.648769]  [<ffffffff80249146>] ? autoremove_wake_function+0x0/0x38
[39129.648874]  [<ffffffff802455cd>] ? worker_thread+0x0/0xee
[39129.648978]  [<ffffffff80248d3e>] kthread+0x49/0x76
[39129.649082]  [<ffffffff8020c5ea>] child_rip+0xa/0x20
[39129.649203]  [<ffffffff80248cf5>] ? kthread+0x0/0x76
[39129.649306]  [<ffffffff8020c5e0>] ? child_rip+0x0/0x20
[39129.649414] hd-audio0     S ffff88007af24488     0  2411      2
[39129.649588]  ffff88007956fec0 0000000000000046 ffffffff802455cd ffff8800=
794f9a68
[39129.649895]  ffffffff8069fdc0 ffffffff8069fdc0 ffff88007956fe40 ffffffff=
8022ff17
[39129.650201]  ffff8800795dda00 ffffffff805f0350 ffff8800795ddc78 00000000=
80677e50
[39129.650508] Call Trace:
[39129.650607]  [<ffffffff802455cd>] ? worker_thread+0x0/0xee
[39129.650711]  [<ffffffff8022ff17>] ? finish_task_switch+0x2b/0x8e
[39129.650815]  [<ffffffff80231ec5>] ? try_to_wake_up+0x1d2/0x1e4
[39129.650918]  [<ffffffff80245676>] worker_thread+0xa9/0xee
[39129.651022]  [<ffffffff80249146>] ? autoremove_wake_function+0x0/0x38
[39129.651126]  [<ffffffff802455cd>] ? worker_thread+0x0/0xee
[39129.651229]  [<ffffffff80248d3e>] kthread+0x49/0x76
[39129.651332]  [<ffffffff8020c5ea>] child_rip+0xa/0x20
[39129.651434]  [<ffffffff8022acbd>] ? dequeue_task+0xad/0xb8
[39129.651538]  [<ffffffff80248cf5>] ? kthread+0x0/0x76
[39129.651641]  [<ffffffff8020c5e0>] ? child_rip+0x0/0x20
[39129.651742] kstriped      S ffff88007b942788     0  2749      2
[39129.651916]  ffff88007addbec0 0000000000000046 ffff88007addbe20 ffff8800=
01015580
[39129.652235]  ffffffff8069fdc0 ffffffff8069fdc0 ffff88007addbe40 ffffffff=
8022ff17
[39129.652542]  ffff88007b951200 ffff88007b905400 ffff88007b951478 00000000=
00000000
[39129.652847] Call Trace:
[39129.652946]  [<ffffffff8022ff17>] ? finish_task_switch+0x2b/0x8e
[39129.653052]  [<ffffffff80245676>] worker_thread+0xa9/0xee
[39129.653174]  [<ffffffff80249146>] ? autoremove_wake_function+0x0/0x38
[39129.653279]  [<ffffffff802455cd>] ? worker_thread+0x0/0xee
[39129.653387]  [<ffffffff80248d3e>] kthread+0x49/0x76
[39129.653490]  [<ffffffff8020c5ea>] child_rip+0xa/0x20
[39129.653593]  [<ffffffff80248cf5>] ? kthread+0x0/0x76
[39129.653695]  [<ffffffff8020c5e0>] ? child_rip+0x0/0x20
[39129.653797] kdmflush      S ffff8800799db508     0  2901      2
[39129.653972]  ffff8800790d5ec0 0000000000000046 ffff8800790d5e00 ffffffff=
80231ee4
[39129.654279]  ffffffff8069fdc0 ffffffff8069fdc0 0000000300000000 ffff8800=
79031cc8
[39129.654585]  ffff8800795d8c00 ffffffff805f0350 ffff8800795d8e78 00000000=
00000286
[39129.654891] Call Trace:
[39129.654990]  [<ffffffff80231ee4>] ? default_wake_function+0xd/0xf
[39129.655095]  [<ffffffff802458ac>] ? wq_barrier_func+0xd/0xf
[39129.655198]  [<ffffffff80245676>] worker_thread+0xa9/0xee
[39129.655302]  [<ffffffff80249146>] ? autoremove_wake_function+0x0/0x38
[39129.655406]  [<ffffffff802455cd>] ? worker_thread+0x0/0xee
[39129.655509]  [<ffffffff80248d3e>] kthread+0x49/0x76
[39129.655612]  [<ffffffff8020c5ea>] child_rip+0xa/0x20
[39129.655714]  [<ffffffff8022acbd>] ? dequeue_task+0xad/0xb8
[39129.655817]  [<ffffffff80248cf5>] ? kthread+0x0/0x76
[39129.655919]  [<ffffffff8020c5e0>] ? child_rip+0x0/0x20
[39129.656034] kcryptd_io    S ffff8800799dba88     0  2902      2
[39129.656208]  ffff880079581ec0 0000000000000046 ffff880079581e40 ffffffff=
802bca10
[39129.656515]  ffffffff8069fdc0 ffffffff8069fdc0 0000000000000000 ffff8800=
7948bb58
[39129.656820]  ffff8800795dc800 ffff88007c062400 ffff8800795dca78 00000001=
799dba88
[39129.657148] Call Trace:
[39129.657247]  [<ffffffff802bca10>] ? bio_alloc_bioset+0x79/0x105
[39129.657359]  [<ffffffffa021e576>] ? kcryptd_io+0x0/0x106 [dm_crypt]
[39129.657464]  [<ffffffff80245676>] worker_thread+0xa9/0xee
[39129.657567]  [<ffffffff80249146>] ? autoremove_wake_function+0x0/0x38
[39129.657672]  [<ffffffff802455cd>] ? worker_thread+0x0/0xee
[39129.657775]  [<ffffffff80248d3e>] kthread+0x49/0x76
[39129.657877]  [<ffffffff8020c5ea>] child_rip+0xa/0x20
[39129.657979]  [<ffffffff8022acbd>] ? dequeue_task+0xad/0xb8
[39129.658083]  [<ffffffff80248cf5>] ? kthread+0x0/0x76
[39129.658186]  [<ffffffff8020c5e0>] ? child_rip+0x0/0x20
[39129.658287] kcryptd       S ffff8800799dbb88     0  2903      2
[39129.658461]  ffff88007addfec0 0000000000000046 0000000000000000 00000000=
00000001
[39129.658767]  ffffffff8069fdc0 ffffffff8069fdc0 ffff88007addfe80 ffffffff=
a021ef02
[39129.659073]  ffff8800795da400 ffffffff805f0350 ffff8800795da678 00000000=
08c167f0
[39129.659378] Call Trace:
[39129.659479]  [<ffffffffa021ef02>] ? kcryptd_crypt+0x3b5/0x41f [dm_crypt]
[39129.659585]  [<ffffffffa021eb4d>] ? kcryptd_crypt+0x0/0x41f [dm_crypt]
[39129.659690]  [<ffffffff80245676>] worker_thread+0xa9/0xee
[39129.659793]  [<ffffffff80249146>] ? autoremove_wake_function+0x0/0x38
[39129.659897]  [<ffffffff802455cd>] ? worker_thread+0x0/0xee
[39129.660013]  [<ffffffff80248d3e>] kthread+0x49/0x76
[39129.660116]  [<ffffffff8020c5ea>] child_rip+0xa/0x20
[39129.660218]  [<ffffffff8022acbd>] ? dequeue_task+0xad/0xb8
[39129.660321]  [<ffffffff80248cf5>] ? kthread+0x0/0x76
[39129.660424]  [<ffffffff8020c5e0>] ? child_rip+0x0/0x20
[39129.660525] portmap       D 0000000000000002     0  3379      1
[39129.660699]  ffff8800799cdd78 0000000000000082 ffff8800799cdca8 ffff8800=
799cdd18
[39129.661007]  ffffffff8069fdc0 ffffffff8069fdc0 ffff8800799cdd58 ffffffff=
8027f145
[39129.661337]  ffff88007b897800 ffff88007bba6600 ffff88007b897a78 00000001=
00000200
[39129.661642] Call Trace:
[39129.661742]  [<ffffffff8027f145>] ? __do_fault+0x367/0x3ad
[39129.661846]  [<ffffffff8024e7e0>] refrigerator+0xe7/0xf3
[39129.661949]  [<ffffffff802425b8>] get_signal_to_deliver+0x5a/0x3aa
[39129.662052]  [<ffffffff8020a904>] do_notify_resume+0x8c/0x833
[39129.662156]  [<ffffffff80284a05>] ? unmap_region+0x11d/0x159
[39129.662259]  [<ffffffff8020b735>] sysret_signal+0x6d/0xb7
[39129.662361] rpc.statd     D 00007fff562dbd60     0  3392      1
[39129.662536]  ffff88007add3d78 0000000000000082 ffff88007add3ca8 ffff8800=
7add3d18
[39129.662841]  ffffffff8069fdc0 ffffffff8069fdc0 ffff88007add3d58 ffffffff=
8027f145
[39129.663147]  ffff8800795d9e00 ffff8800795db600 ffff8800795da078 00000000=
00000200
[39129.663452] Call Trace:
[39129.663552]  [<ffffffff8027f145>] ? __do_fault+0x367/0x3ad
[39129.663655]  [<ffffffff8024e7e0>] refrigerator+0xe7/0xf3
[39129.663758]  [<ffffffff802425b8>] get_signal_to_deliver+0x5a/0x3aa
[39129.663862]  [<ffffffff8020a904>] do_notify_resume+0x8c/0x833
[39129.663965]  [<ffffffff802a8bd8>] ? __d_free+0x4f/0x53
[39129.664081]  [<ffffffff802a8c0e>] ? d_free+0x32/0x49
[39129.665922]  [<ffffffff802a8467>] ? sys_select+0xa7/0xbc
[39129.666043]  [<ffffffff8020b735>] sysret_signal+0x6d/0xb7
[39129.666145] iscsi_eh      S ffff88007a936308     0  3410      2
[39129.666325]  ffff880078901ec0 0000000000000046 ffffffff802455cd ffff8800=
788e5cf8
[39129.666630]  ffffffff8069fdc0 ffffffff8069fdc0 ffff880078901e40 ffffffff=
8022ff17
[39129.666935]  ffff8800795d9800 ffff88007c062400 ffff8800795d9a78 00000001=
0100aa98
[39129.667239] Call Trace:
[39129.667338]  [<ffffffff802455cd>] ? worker_thread+0x0/0xee
[39129.667440]  [<ffffffff8022ff17>] ? finish_task_switch+0x2b/0x8e
[39129.667544]  [<ffffffff80231ec5>] ? try_to_wake_up+0x1d2/0x1e4
[39129.667647]  [<ffffffff80245676>] worker_thread+0xa9/0xee
[39129.667750]  [<ffffffff80249146>] ? autoremove_wake_function+0x0/0x38
[39129.667853]  [<ffffffff802455cd>] ? worker_thread+0x0/0xee
[39129.667956]  [<ffffffff80248d3e>] kthread+0x49/0x76
[39129.668071]  [<ffffffff8020c5ea>] child_rip+0xa/0x20
[39129.668173]  [<ffffffff80248cf5>] ? kthread+0x0/0x76
[39129.668274]  [<ffffffff8020c5e0>] ? child_rip+0x0/0x20
[39129.668375] ib_addr       S ffff88007902ec88     0  3430      2
[39129.668549]  ffff88007882dec0 0000000000000046 ffff88007882de20 ffff8800=
01021580
[39129.668854]  ffffffff8069fdc0 ffffffff8069fdc0 ffff88007882de40 ffffffff=
8022ff17
[39129.669180]  ffff88007b891e00 ffffffff805f0350 ffff88007b892078 00000000=
00000000
[39129.669491] Call Trace:
[39129.669590]  [<ffffffff8022ff17>] ? finish_task_switch+0x2b/0x8e
[39129.669695]  [<ffffffff80245676>] worker_thread+0xa9/0xee
[39129.669798]  [<ffffffff80249146>] ? autoremove_wake_function+0x0/0x38
[39129.669902]  [<ffffffff802455cd>] ? worker_thread+0x0/0xee
[39129.670005]  [<ffffffff80248d3e>] kthread+0x49/0x76
[39129.670107]  [<ffffffff8020c5ea>] child_rip+0xa/0x20
[39129.670209]  [<ffffffff8022acbd>] ? dequeue_task+0xad/0xb8
[39129.670311]  [<ffffffff80248cf5>] ? kthread+0x0/0x76
[39129.670413]  [<ffffffff8020c5e0>] ? child_rip+0x0/0x20
[39129.670514] ib_mcast      S ffff880079546108     0  3441      2
[39129.670688]  ffff880078907ec0 0000000000000046 ffffffff802455cd ffff8800=
78897cd8
[39129.670993]  ffffffff8069fdc0 ffffffff8069fdc0 ffff880078907e40 ffffffff=
8022ff17
[39129.671297]  ffff88007b892a00 ffffffff805f0350 ffff88007b892c78 00000000=
80677e50
[39129.671602] Call Trace:
[39129.671701]  [<ffffffff802455cd>] ? worker_thread+0x0/0xee
[39129.671804]  [<ffffffff8022ff17>] ? finish_task_switch+0x2b/0x8e
[39129.671908]  [<ffffffff80231ec5>] ? try_to_wake_up+0x1d2/0x1e4
[39129.672025]  [<ffffffff80245676>] worker_thread+0xa9/0xee
[39129.672129]  [<ffffffff80249146>] ? autoremove_wake_function+0x0/0x38
[39129.672233]  [<ffffffff802455cd>] ? worker_thread+0x0/0xee
[39129.672337]  [<ffffffff80248d3e>] kthread+0x49/0x76
[39129.672439]  [<ffffffff8020c5ea>] child_rip+0xa/0x20
[39129.672541]  [<ffffffff8022acbd>] ? dequeue_task+0xad/0xb8
[39129.672644]  [<ffffffff80248cf5>] ? kthread+0x0/0x76
[39129.672747]  [<ffffffff8020c5e0>] ? child_rip+0x0/0x20
[39129.672848] iw_cm_wq      S ffff880078933088     0  3445      2
[39129.673024]  ffff880078905ec0 0000000000000046 ffff880078905e20 ffff8800=
01021580
[39129.673354]  ffffffff8069fdc0 ffffffff8069fdc0 ffff880078905e40 ffffffff=
8022ff17
[39129.673659]  ffff88007b893600 ffff88007c060600 ffff88007b893878 00000001=
00000000
[39129.673964] Call Trace:
[39129.674063]  [<ffffffff8022ff17>] ? finish_task_switch+0x2b/0x8e
[39129.674168]  [<ffffffff80245676>] worker_thread+0xa9/0xee
[39129.674271]  [<ffffffff80249146>] ? autoremove_wake_function+0x0/0x38
[39129.674376]  [<ffffffff802455cd>] ? worker_thread+0x0/0xee
[39129.674479]  [<ffffffff80248d3e>] kthread+0x49/0x76
[39129.674581]  [<ffffffff8020c5ea>] child_rip+0xa/0x20
[39129.674684]  [<ffffffff8022acbd>] ? dequeue_task+0xad/0xb8
[39129.674787]  [<ffffffff80248cf5>] ? kthread+0x0/0x76
[39129.674890]  [<ffffffff8020c5e0>] ? child_rip+0x0/0x20
[39129.674992] ib_cm/0       S ffff88007902e988     0  3449      2
[39129.675166]  ffff8800788e5ec0 0000000000000046 ffff8800788e5e20 ffff8800=
01021580
[39129.675472]  ffffffff8069fdc0 ffffffff8069fdc0 ffff8800788e5e40 ffffffff=
8022ff17
[39129.675778]  ffff88007b892400 ffff88007bba2400 ffff88007b892678 00000000=
8a457470
[39129.676097] Call Trace:
[39129.676197]  [<ffffffff8022ff17>] ? finish_task_switch+0x2b/0x8e
[39129.676301]  [<ffffffff80245676>] worker_thread+0xa9/0xee
[39129.676405]  [<ffffffff80249146>] ? autoremove_wake_function+0x0/0x38
[39129.676509]  [<ffffffff802455cd>] ? worker_thread+0x0/0xee
[39129.676612]  [<ffffffff80248d3e>] kthread+0x49/0x76
[39129.676714]  [<ffffffff8020c5ea>] child_rip+0xa/0x20
[39129.676816]  [<ffffffff8022acbd>] ? dequeue_task+0xad/0xb8
[39129.676919]  [<ffffffff80248cf5>] ? kthread+0x0/0x76
[39129.677023]  [<ffffffff8020c5e0>] ? child_rip+0x0/0x20
[39129.677144] rdma_cm       S ffff880078933908     0  3455      2
[39129.677324]  ffff880078973ec0 0000000000000046 ffffffff802455cd ffff8800=
78897ce8
[39129.677631]  ffffffff8069fdc0 ffffffff8069fdc0 ffff880078973e40 ffffffff=
8022ff17
[39129.677937]  ffff88007b890c00 ffffffff805f0350 ffff88007b890e78 00000000=
80677e50
[39129.678243] Call Trace:
[39129.678342]  [<ffffffff802455cd>] ? worker_thread+0x0/0xee
[39129.678445]  [<ffffffff8022ff17>] ? finish_task_switch+0x2b/0x8e
[39129.678549]  [<ffffffff80231ec5>] ? try_to_wake_up+0x1d2/0x1e4
[39129.678653]  [<ffffffff80245676>] worker_thread+0xa9/0xee
[39129.678756]  [<ffffffff80249146>] ? autoremove_wake_function+0x0/0x38
[39129.678860]  [<ffffffff802455cd>] ? worker_thread+0x0/0xee
[39129.678963]  [<ffffffff80248d3e>] kthread+0x49/0x76
[39129.679065]  [<ffffffff8020c5ea>] child_rip+0xa/0x20
[39129.679168]  [<ffffffff80248cf5>] ? kthread+0x0/0x76
[39129.679270]  [<ffffffff8020c5e0>] ? child_rip+0x0/0x20
[39129.679372] iscsid        D 00007fffb8218960     0  3462      1
[39129.679546]  ffff88007892fd78 0000000000000086 0000000000000680 00000000=
00000000
[39129.679851]  ffffffff8069fdc0 ffffffff8069fdc0 ffff88007892fd08 00000000=
00000202
[39129.680170]  ffff88007b896000 ffff88007b953600 ffff88007b896278 00000000=
8022b43b
[39129.680476] Call Trace:
[39129.680575]  [<ffffffff8022b869>] ? dequeue_entity+0x18/0x12c
[39129.680679]  [<ffffffff8024e7e0>] refrigerator+0xe7/0xf3
[39129.680781]  [<ffffffff802425b8>] get_signal_to_deliver+0x5a/0x3aa
[39129.680885]  [<ffffffff8020a904>] do_notify_resume+0x8c/0x833
[39129.680989]  [<ffffffff80250203>] ? getnstimeofday+0x58/0xb4
[39129.681094]  [<ffffffff8024bfc4>] ? ktime_get_ts+0x49/0x4e
[39129.681215]  [<ffffffff8024bfda>] ? ktime_get+0x11/0x42
[39129.681318]  [<ffffffff8024b645>] ? update_rmtp+0x4c/0x61
[39129.681427]  [<ffffffff8024be9b>] ? hrtimer_nanosleep+0xb1/0xff
[39129.681530]  [<ffffffff8024b65a>] ? hrtimer_wakeup+0x0/0x21
[39129.681633]  [<ffffffff8020b735>] sysret_signal+0x6d/0xb7
[39129.681735] iscsid        D 00000000ffffffff     0  3463      1
[39129.681909]  ffff880078931d78 0000000000000086 ffff880078931d68 00000000=
00000058
[39129.682215]  ffffffff8069fdc0 ffffffff8069fdc0 ffff880078931cf8 ffffffff=
8022b7fc
[39129.682520]  ffff88007b890600 ffff88005b9c2400 ffff88007b890878 00000000=
01025dc0
[39129.682826] Call Trace:
[39129.682925]  [<ffffffff8022b7fc>] ? set_next_entity+0x3b/0x61
[39129.683028]  [<ffffffff804cad4c>] ? thread_return+0x3d/0xda
[39129.683132]  [<ffffffff8024e7e0>] refrigerator+0xe7/0xf3
[39129.683234]  [<ffffffff802425b8>] get_signal_to_deliver+0x5a/0x3aa
[39129.683338]  [<ffffffff8022ff17>] ? finish_task_switch+0x2b/0x8e
[39129.683442]  [<ffffffff8020a904>] do_notify_resume+0x8c/0x833
[39129.683546]  [<ffffffff8021ff4d>] ? read_hpet+0x13/0x17
[39129.683649]  [<ffffffff80250203>] ? getnstimeofday+0x58/0xb4
[39129.683752]  [<ffffffff8024bfc4>] ? ktime_get_ts+0x49/0x4e
[39129.683855]  [<ffffffff802a72d8>] ? poll_select_set_timeout+0x5c/0x77
[39129.683960]  [<ffffffff8020b735>] sysret_signal+0x6d/0xb7
[39129.684075] rsyslogd      D 00007fff11f38b58     0  3679      1
[39129.684248]  ffff880078975d78 0000000000000082 ffff880001026680 ffff8800=
7bba4238
[39129.684554]  ffffffff8069fdc0 ffffffff8069fdc0 ffffffff8020c11e ffff8800=
78975f08
[39129.684859]  ffff88007bba3000 ffff88007bba1e00 ffff88007bba3278 00000000=
78975f38
[39129.685187] Call Trace:
[39129.685286]  [<ffffffff8020c11e>] ? apic_timer_interrupt+0xe/0x20
[39129.685396]  [<ffffffff8024e7e0>] refrigerator+0xe7/0xf3
[39129.685499]  [<ffffffff802425b8>] get_signal_to_deliver+0x5a/0x3aa
[39129.685603]  [<ffffffff8020a904>] do_notify_resume+0x8c/0x833
[39129.685706]  [<ffffffff804cc8b5>] ? _spin_unlock_irqrestore+0x2e/0x30
[39129.685811]  [<ffffffff80241880>] ? group_send_sig_info+0x66/0x74
[39129.685915]  [<ffffffff80250203>] ? getnstimeofday+0x58/0xb4
[39129.686018]  [<ffffffff8024bfc4>] ? ktime_get_ts+0x49/0x4e
[39129.686121]  [<ffffffff802a717d>] ? poll_select_copy_remaining+0xc5/0xea
[39129.686226]  [<ffffffff802a8467>] ? sys_select+0xa7/0xbc
[39129.686328]  [<ffffffff8020b735>] sysret_signal+0x6d/0xb7
[39129.686430] rsyslogd      D 00007fa308b75360     0  3681      1
[39129.686604]  ffff8800789b1d78 0000000000000082 ffff8800789b1cb8 ffffffff=
8021c04e
[39129.686909]  ffffffff8069fdc0 ffffffff8069fdc0 ffff8800789b1cd8 00000000=
00000087
[39129.687214]  ffff88007bba7200 ffff8800795de000 ffff88007bba7478 00000000=
7bba7200
[39129.687519] Call Trace:
[39129.687618]  [<ffffffff8021c04e>] ? native_smp_send_reschedule+0x50/0x52
[39129.687723]  [<ffffffff8024e7e0>] refrigerator+0xe7/0xf3
[39129.687826]  [<ffffffff802425b8>] get_signal_to_deliver+0x5a/0x3aa
[39129.687930]  [<ffffffff8020a904>] do_notify_resume+0x8c/0x833
[39129.688047]  [<ffffffff802a8467>] ? sys_select+0xa7/0xbc
[39129.688150]  [<ffffffff8020b735>] sysret_signal+0x6d/0xb7
[39129.688252] rsyslogd      D 00007fa3098eff00     0  3682      1
[39129.690166]  ffff8800789b3d78 0000000000000082 0000000000000082 ffff8800=
01015580
[39129.690494]  ffffffff8069fdc0 ffffffff8069fdc0 ffff88007b952a48 ffff8800=
7b952a38
[39129.690800]  ffff88007bba1e00 ffff8800795d8600 ffff88007bba2078 00000000=
01015580
[39129.691106] Call Trace:
[39129.691205]  [<ffffffff8022ff17>] ? finish_task_switch+0x2b/0x8e
[39129.691309]  [<ffffffff804cad4c>] ? thread_return+0x3d/0xda
[39129.691412]  [<ffffffff80230478>] ? sched_balance_self+0x2b9/0x2ef
[39129.691516]  [<ffffffff8024e7e0>] refrigerator+0xe7/0xf3
[39129.691619]  [<ffffffff802425b8>] get_signal_to_deliver+0x5a/0x3aa
[39129.691723]  [<ffffffff8020a904>] do_notify_resume+0x8c/0x833
[39129.691827]  [<ffffffff802e37b1>] ? kmsg_read+0x0/0x47
[39129.691929]  [<ffffffff80236b47>] ? do_syslog+0x1b5/0x383
[39129.692046]  [<ffffffff80249146>] ? autoremove_wake_function+0x0/0x38
[39129.692150]  [<ffffffff802e37b1>] ? kmsg_read+0x0/0x47
[39129.692253]  [<ffffffff802db28d>] ? pde_users_dec+0x3e/0x43
[39129.692357]  [<ffffffff8029a556>] ? vfs_read+0x11f/0x154
[39129.692460]  [<ffffffff8020b735>] sysret_signal+0x6d/0xb7
[39129.692563] rsyslogd      D 000000004199cfe0     0 23153      1
[39129.692736]  ffff880012eb5d78 0000000000000082 ffff880012eb5ca0 ffff8800=
12eb5cb0
[39129.693043]  ffffffff8069fdc0 ffffffff8069fdc0 ffff880012eb5d90 ffff8800=
12eb5d90
[39129.693372]  ffff880021837200 ffff880021830000 ffff880021837478 00000001=
00000e1c
[39129.693677] Call Trace:
[39129.693776]  [<ffffffff8024b65a>] ? hrtimer_wakeup+0x0/0x21
[39129.693879]  [<ffffffff8024e7e0>] refrigerator+0xe7/0xf3
[39129.693982]  [<ffffffff802425b8>] get_signal_to_deliver+0x5a/0x3aa
[39129.694086]  [<ffffffff8020a904>] do_notify_resume+0x8c/0x833
[39129.694189]  [<ffffffff8022b7fc>] ? set_next_entity+0x3b/0x61
[39129.694292]  [<ffffffff8022bc26>] ? pick_next_task_fair+0x8f/0xe4
[39129.694396]  [<ffffffff804cad76>] ? thread_return+0x67/0xda
[39129.694500]  [<ffffffff80250203>] ? getnstimeofday+0x58/0xb4
[39129.694603]  [<ffffffff8024bfc4>] ? ktime_get_ts+0x49/0x4e
[39129.694706]  [<ffffffff80256342>] ? sys_futex+0xf8/0x116
[39129.694808]  [<ffffffff8020b735>] sysret_signal+0x6d/0xb7
[39129.694910] acpid         D 0000000000000003     0  3690      1
[39129.695084]  ffff8800789d1d78 0000000000000082 0000000000000000 00000000=
00034cba
[39129.695389]  ffffffff8069fdc0 ffffffff8069fdc0 ffff8800789d1ce8 ffffffff=
80227295
[39129.695694]  ffff88007bba6600 ffff88007b956000 ffff88007bba6878 00000001=
8027f986
[39129.696012] Call Trace:
[39129.696111]  [<ffffffff80227295>] ? ptep_set_access_flags+0x22/0x28
[39129.696216]  [<ffffffff8024e7e0>] refrigerator+0xe7/0xf3
[39129.696318]  [<ffffffff802425b8>] get_signal_to_deliver+0x5a/0x3aa
[39129.696422]  [<ffffffff8020a904>] do_notify_resume+0x8c/0x833
[39129.696525]  [<ffffffff804cafbe>] ? preempt_schedule+0x35/0x5c
[39129.696629]  [<ffffffff802493a8>] ? remove_wait_queue+0x3c/0x41
[39129.696733]  [<ffffffff80238ad4>] ? do_wait+0x2d6/0x393
[39129.696836]  [<ffffffff80231ed7>] ? default_wake_function+0x0/0xf
[39129.696940]  [<ffffffff8020b735>] sysret_signal+0x6d/0xb7
[39129.697044] dbus-daemon   D 00007f5f1c709500     0  3700      1
[39129.697236]  ffff880077c57d78 0000000000000086 0000000000000000 ffff8800=
77c57b98
[39129.697545]  ffffffff8069fdc0 ffffffff8069fdc0 0000000000200200 ffff8800=
780b36b0
[39129.697849]  ffff8800795db600 ffff8800795de600 ffff8800795db878 00000000=
802a8546
[39129.698154] Call Trace:
[39129.698252]  [<ffffffff802a8546>] ? pollwake+0x0/0x4e
[39129.698354]  [<ffffffff8024e7e0>] refrigerator+0xe7/0xf3
[39129.698457]  [<ffffffff802425b8>] get_signal_to_deliver+0x5a/0x3aa
[39129.698560]  [<ffffffff8020a904>] do_notify_resume+0x8c/0x833
[39129.698663]  [<ffffffff80250203>] ? getnstimeofday+0x58/0xb4
[39129.698766]  [<ffffffff803321d0>] ? security_file_permission+0x11/0x13
[39129.698871]  [<ffffffff8020b735>] sysret_signal+0x6d/0xb7
[39129.698973] avahi-daemon  D 0000000000620e90     0  3712      1
[39129.699146]  ffff8800789d9d78 0000000000000082 ffff880000000000 ffff8800=
789d9b98
[39129.699451]  ffffffff8069fdc0 ffffffff8069fdc0 0000000000200200 ffff8800=
7801cf30
[39129.699755]  ffff88007bba0c00 ffff880020d8f200 ffff88007bba0e78 00000000=
802a8546
[39129.700073] Call Trace:
[39129.700172]  [<ffffffff802a8546>] ? pollwake+0x0/0x4e
[39129.700274]  [<ffffffff8024e7e0>] refrigerator+0xe7/0xf3
[39129.700376]  [<ffffffff802425b8>] get_signal_to_deliver+0x5a/0x3aa
[39129.700480]  [<ffffffff8020a904>] do_notify_resume+0x8c/0x833
[39129.700583]  [<ffffffff804caf61>] ? preempt_schedule_irq+0x3a/0x62
[39129.700687]  [<ffffffff8020b735>] sysret_signal+0x6d/0xb7
[39129.700788] avahi-daemon  D 00007fffd9247d50     0  3714   3712
[39129.700962]  ffff880077cbbd78 0000000000000082 0000000000000000 00000000=
00000000
[39129.701292]  ffffffff8069fdc0 ffffffff8069fdc0 ffff880077cbbd58 ffffffff=
8027f145
[39129.701597]  ffff8800795de600 ffff88007b951800 ffff8800795de878 00000000=
00000001
[39129.701901] Call Trace:
[39129.702000]  [<ffffffff8027f145>] ? __do_fault+0x367/0x3ad
[39129.702104]  [<ffffffff80446db9>] ? sock_aio_read+0x146/0x15a
[39129.702207]  [<ffffffff8024e7e0>] refrigerator+0xe7/0xf3
[39129.702309]  [<ffffffff802425b8>] get_signal_to_deliver+0x5a/0x3aa
[39129.702414]  [<ffffffff8020a904>] do_notify_resume+0x8c/0x833
[39129.702517]  [<ffffffff804ccd1f>] ? page_fault+0x1f/0x30
[39129.702621]  [<ffffffff80249146>] ? autoremove_wake_function+0x0/0x38
[39129.702725]  [<ffffffff803321d0>] ? security_file_permission+0x11/0x13
[39129.702830]  [<ffffffff8029a4f5>] ? vfs_read+0xbe/0x154
[39129.702932]  [<ffffffff8020b735>] sysret_signal+0x6d/0xb7
[39129.703034] sshd          D 00007fce4c8833b0     0  3733      1
[39129.703208]  ffff880077c6bd78 0000000000000082 ffff880077c6bcc8 ffffffff=
8026d481
[39129.703514]  ffffffff8069fdc0 ffffffff8069fdc0 ffff880077c6bd58 ffffffff=
8027f145
[39129.703820]  ffff8800795de000 ffff88007b906000 ffff8800795de278 00000000=
00000200
[39129.704139] Call Trace:
[39129.704239]  [<ffffffff8026d481>] ? unlock_page+0x22/0x27
[39129.704342]  [<ffffffff8027f145>] ? __do_fault+0x367/0x3ad
[39129.704445]  [<ffffffff8024e7e0>] refrigerator+0xe7/0xf3
[39129.704548]  [<ffffffff802425b8>] get_signal_to_deliver+0x5a/0x3aa
[39129.704652]  [<ffffffff8020a904>] do_notify_resume+0x8c/0x833
[39129.704756]  [<ffffffff8028beda>] ? free_pages_and_swap_cache+0x82/0xa2
[39129.704861]  [<ffffffff80284a05>] ? unmap_region+0x11d/0x159
[39129.704964]  [<ffffffff802a8467>] ? sys_select+0xa7/0xbc
[39129.705069]  [<ffffffff8020b735>] sysret_signal+0x6d/0xb7
[39129.705189] automount     D 0000000000000003     0  3834      1
[39129.705369]  ffff880077d9bd78 0000000000000082 0000000000000000 00000000=
00000000
[39129.705675]  ffffffff8069fdc0 ffffffff8069fdc0 800000005a69d067 ffffe200=
01528ef0
[39129.705980]  ffff88007b906000 ffff88007b903c00 ffff88007b906278 00000000=
8027f986
[39129.706285] Call Trace:
[39129.706385]  [<ffffffff8024e7e0>] refrigerator+0xe7/0xf3
[39129.706488]  [<ffffffff802425b8>] get_signal_to_deliver+0x5a/0x3aa
[39129.706592]  [<ffffffff8020a904>] do_notify_resume+0x8c/0x833
[39129.706695]  [<ffffffff804cafbe>] ? preempt_schedule+0x35/0x5c
[39129.706798]  [<ffffffff804cc8b5>] ? _spin_unlock_irqrestore+0x2e/0x30
[39129.706903]  [<ffffffff80230f61>] ? wake_up_new_task+0x142/0x157
[39129.707007]  [<ffffffff80235273>] ? do_fork+0x270/0x336
[39129.707110]  [<ffffffff8020b735>] sysret_signal+0x6d/0xb7
[39129.707212] atop          D 0000000000000000     0  3854      1
[39129.707386]  ffff880077d65d78 0000000000000086 0000000049b6d50e ffff8800=
780e30a8
[39129.707692]  ffffffff8069fdc0 ffffffff8069fdc0 0000000000646644 ffff8800=
77d65e68
[39129.708013]  ffff88007b900000 ffff88005b9c2400 ffff88007b900278 00000000=
8027fc1b
[39129.708318] Call Trace:
[39129.708418]  [<ffffffff8024e7e0>] refrigerator+0xe7/0xf3
[39129.708521]  [<ffffffff802425b8>] get_signal_to_deliver+0x5a/0x3aa
[39129.708625]  [<ffffffff8020a904>] do_notify_resume+0x8c/0x833
[39129.708728]  [<ffffffff8022bca1>] ? dequeue_task_fair+0x26/0x99
[39129.708832]  [<ffffffff8022acbd>] ? dequeue_task+0xad/0xb8
[39129.708935]  [<ffffffff8022ff17>] ? finish_task_switch+0x2b/0x8e
[39129.709040]  [<ffffffff804cad4c>] ? thread_return+0x3d/0xda
[39129.709162]  [<ffffffff804cad4c>] ? thread_return+0x3d/0xda
[39129.709266]  [<ffffffff8029a315>] ? vfs_write+0x122/0x157
[39129.709374]  [<ffffffff8020b735>] sysret_signal+0x6d/0xb7
[39129.709477] cupsd         D 000000000065b418     0  3868      1
[39129.709650]  ffff880077d91d78 0000000000000086 ffff880001019dc0 00000000=
0044d9ee
[39129.709956]  ffffffff8069fdc0 ffffffff8069fdc0 0000000000000000 ffff8800=
01015580
[39129.710261]  ffff88007b903c00 ffff88007b906600 ffff88007b903e78 00000000=
7b952a38
[39129.710566] Call Trace:
[39129.710666]  [<ffffffff8022ff17>] ? finish_task_switch+0x2b/0x8e
[39129.710770]  [<ffffffff8024e7e0>] refrigerator+0xe7/0xf3
[39129.710873]  [<ffffffff802425b8>] get_signal_to_deliver+0x5a/0x3aa
[39129.710977]  [<ffffffff8020a904>] do_notify_resume+0x8c/0x833
[39129.711080]  [<ffffffff804cb01b>] ? schedule_timeout+0x22/0xcf
[39129.711184]  [<ffffffff8023eb1e>] ? process_timeout+0x0/0xb
[39129.711287]  [<ffffffff802c339b>] ? sys_epoll_wait+0x464/0x47c
[39129.711391]  [<ffffffff80231ed7>] ? default_wake_function+0x0/0xf
[39129.711495]  [<ffffffff8020b735>] sysret_signal+0x6d/0xb7
[39129.711597] gpm           D 0000000000616e70     0  3881      1
[39129.711771]  ffff88007a435d78 0000000000000082 ffff880046804240 00000000=
00000001
[39129.712090]  ffffffff8069fdc0 ffffffff8069fdc0 ffff88007a435ce8 ffff8800=
7adad200
[39129.712395]  ffff88007b954e00 ffff880021837200 ffff88007b955078 00000001=
803a6c87
[39129.712700] Call Trace:
[39129.712800]  [<ffffffff8024e7e0>] refrigerator+0xe7/0xf3
[39129.714636]  [<ffffffff802425b8>] get_signal_to_deliver+0x5a/0x3aa
[39129.714759]  [<ffffffff8020a904>] do_notify_resume+0x8c/0x833
[39129.714863]  [<ffffffff8029d0c3>] ? cp_new_stat+0xe2/0xef
[39129.714971]  [<ffffffff80250203>] ? getnstimeofday+0x58/0xb4
[39129.715074]  [<ffffffff8024bfc4>] ? ktime_get_ts+0x49/0x4e
[39129.715177]  [<ffffffff802a717d>] ? poll_select_copy_remaining+0xc5/0xea
[39129.715282]  [<ffffffff802a8467>] ? sys_select+0xa7/0xbc
[39129.715385]  [<ffffffff8020b735>] sysret_signal+0x6d/0xb7
[39129.715487] thinkpad-keys D 0000000000000001     0  3922      1
[39129.715661]  ffff880077009d78 0000000000000082 ffff880078169988 00000000=
77009e48
[39129.715966]  ffffffff8069fdc0 ffffffff8069fdc0 0000000000000282 ffff8800=
29002280
[39129.716285]  ffff88007b906600 ffff88007bba3000 ffff88007b906878 00000000=
00000282
[39129.716590] Call Trace:
[39129.716689]  [<ffffffff802a028f>] ? __free_pipe_info+0x53/0x5b
[39129.716792]  [<ffffffff8024e7e0>] refrigerator+0xe7/0xf3
[39129.716894]  [<ffffffff802425b8>] get_signal_to_deliver+0x5a/0x3aa
[39129.716998]  [<ffffffff8020a904>] do_notify_resume+0x8c/0x833
[39129.717103]  [<ffffffff802a5270>] ? do_filp_open+0x418/0x85d
[39129.717225]  [<ffffffff804ccd1f>] ? page_fault+0x1f/0x30
[39129.717329]  [<ffffffff80298216>] ? do_sys_open+0xcb/0xda
[39129.717437]  [<ffffffff8020b735>] sysret_signal+0x6d/0xb7
[39129.717539] inetutils-ine D 7878787878787878     0  3933      1
[39129.717713]  ffff880077095d78 0000000000000086 ffff880077095cc8 ffffffff=
8026d481
[39129.718017]  ffffffff8069fdc0 ffffffff8069fdc0 ffff880077095d58 ffffffff=
8027f145
[39129.718321]  ffff88007b956000 ffff88007b891200 ffff88007b956278 00000001=
00000200
[39129.718626] Call Trace:
[39129.718724]  [<ffffffff8026d481>] ? unlock_page+0x22/0x27
[39129.718827]  [<ffffffff8027f145>] ? __do_fault+0x367/0x3ad
[39129.718930]  [<ffffffff8024e7e0>] refrigerator+0xe7/0xf3
[39129.719033]  [<ffffffff802425b8>] get_signal_to_deliver+0x5a/0x3aa
[39129.719136]  [<ffffffff8020a904>] do_notify_resume+0x8c/0x833
[39129.719239]  [<ffffffff8029d0c3>] ? cp_new_stat+0xe2/0xef
[39129.719342]  [<ffffffff802af502>] ? mntput_no_expire+0x2a/0x14d
[39129.719446]  [<ffffffff802af502>] ? mntput_no_expire+0x2a/0x14d
[39129.719549]  [<ffffffff802a8467>] ? sys_select+0xa7/0xbc
[39129.719651]  [<ffffffff8020b735>] sysret_signal+0x6d/0xb7
[39129.719753] kerneloops    D 00000000006063f0     0  3942      1
[39129.719927]  ffff88007708dd78 0000000000000086 ffffffff8062dc80 00000000=
00000000
[39129.720245]  ffffffff8069fdc0 ffffffff8069fdc0 0000000000000000 00000080=
00000000
[39129.720549]  ffff88007b891200 ffff88007bba1200 ffff88007b891478 00000001=
7b891200
[39129.720853] Call Trace:
[39129.720952]  [<ffffffff80446db9>] ? sock_aio_read+0x146/0x15a
[39129.721057]  [<ffffffff802754bc>] ? lru_cache_add_lru+0x26/0x28
[39129.721179]  [<ffffffff8024e7e0>] refrigerator+0xe7/0xf3
[39129.721282]  [<ffffffff802425b8>] get_signal_to_deliver+0x5a/0x3aa
[39129.721391]  [<ffffffff8020a904>] do_notify_resume+0x8c/0x833
[39129.721495]  [<ffffffff8020bf8e>] ? common_interrupt+0xe/0x13
[39129.721598]  [<ffffffff8022b7fc>] ? set_next_entity+0x3b/0x61
[39129.721701]  [<ffffffff8022ff17>] ? finish_task_switch+0x2b/0x8e
[39129.721805]  [<ffffffff804cad4c>] ? thread_return+0x3d/0xda
[39129.721908]  [<ffffffff80250203>] ? getnstimeofday+0x58/0xb4
[39129.722011]  [<ffffffff8024bfc4>] ? ktime_get_ts+0x49/0x4e
[39129.722114]  [<ffffffff802a72d8>] ? poll_select_set_timeout+0x5c/0x77
[39129.722218]  [<ffffffff8020b735>] sysret_signal+0x6d/0xb7
[39129.722320] rpciod/0      S ffff88007a936f88     0  3969      2
[39129.722493]  ffff8800770c7ec0 0000000000000046 ffff8800770c7e30 ffffffff=
a0340d53
[39129.722797]  ffffffff8069fdc0 ffffffff8069fdc0 ffff880043dcc800 ffff8800=
43dccd50
[39129.723102]  ffff88007b951e00 ffff88007c064e00 ffff88007b952078 00000000=
a033d7a5
[39129.723406] Call Trace:
[39129.723520]  [<ffffffffa0340d53>] ? rpc_wake_up_status+0x81/0x8d [sunrpc]
[39129.723624]  [<ffffffff80245676>] worker_thread+0xa9/0xee
[39129.723727]  [<ffffffff80249146>] ? autoremove_wake_function+0x0/0x38
[39129.723831]  [<ffffffff802455cd>] ? worker_thread+0x0/0xee
[39129.723934]  [<ffffffff80248d3e>] kthread+0x49/0x76
[39129.724049]  [<ffffffff8020c5ea>] child_rip+0xa/0x20
[39129.724151]  [<ffffffff8022acbd>] ? dequeue_task+0xad/0xb8
[39129.724253]  [<ffffffff80248cf5>] ? kthread+0x0/0x76
[39129.724355]  [<ffffffff8020c5e0>] ? child_rip+0x0/0x20
[39129.724456] lockd         S ffff880077128000     0  3999      2
[39129.724630]  ffff880077117dc0 0000000000000046 ffffffff8069fdc0 00000000=
00000000
[39129.724935]  ffffffff8069fdc0 ffffffff8069fdc0 ffff880077117df0 ffffffff=
804cad8a
[39129.725265]  ffff88007b894e00 ffff88007b890000 ffff88007b895078 00000000=
8069fdc0
[39129.725570] Call Trace:
[39129.725668]  [<ffffffff804cad8a>] ? thread_return+0x7b/0xda
[39129.725771]  [<ffffffff804cb01b>] schedule_timeout+0x22/0xcf
[39129.725888]  [<ffffffffa034daa4>] svc_recv+0x338/0x78b [sunrpc]
[39129.725992]  [<ffffffff80231ed7>] ? default_wake_function+0x0/0xf
[39129.726095]  [<ffffffff80246155>] ? queue_delayed_work+0x21/0x23
[39129.726204]  [<ffffffffa037b94a>] lockd+0xd5/0x1a3 [lockd]
[39129.726311]  [<ffffffffa037b875>] ? lockd+0x0/0x1a3 [lockd]
[39129.726414]  [<ffffffff80248d3e>] kthread+0x49/0x76
[39129.726515]  [<ffffffff8020c5ea>] child_rip+0xa/0x20
[39129.726617]  [<ffffffff8022acbd>] ? dequeue_task+0xad/0xb8
[39129.726720]  [<ffffffff80248cf5>] ? kthread+0x0/0x76
[39129.726822]  [<ffffffff8020c5e0>] ? child_rip+0x0/0x20
[39129.726923] nfsd4         S ffff8800795aae88     0  4000      2
[39129.727096]  ffff8800770edec0 0000000000000046 ffffffffa03c1380 00000000=
0000005a
[39129.727401]  ffffffff8069fdc0 ffffffff8069fdc0 ffff8800770ede20 ffffffff=
80245df7
[39129.727706]  ffff88007b897200 ffff88005b9c2400 ffff88007b897478 00000000=
a03a47fd
[39129.728023] Call Trace:
[39129.728123]  [<ffffffff80245df7>] ? queue_delayed_work_on+0xb0/0xb9
[39129.728238]  [<ffffffffa03a45c5>] ? laundromat_main+0x0/0x247 [nfsd]
[39129.728343]  [<ffffffff80245676>] worker_thread+0xa9/0xee
[39129.728445]  [<ffffffff80249146>] ? autoremove_wake_function+0x0/0x38
[39129.728550]  [<ffffffff802455cd>] ? worker_thread+0x0/0xee
[39129.728652]  [<ffffffff80248d3e>] kthread+0x49/0x76
[39129.728754]  [<ffffffff8020c5ea>] child_rip+0xa/0x20
[39129.728856]  [<ffffffff80248cf5>] ? kthread+0x0/0x76
[39129.728958]  [<ffffffff8020c5e0>] ? child_rip+0x0/0x20
[39129.729061] nfsd          S ffff8800770ee000     0  4001      2
[39129.729253]  ffff8800771a1e00 0000000000000046 ffffffff8069fdc0 00000000=
00000000
[39129.729563]  ffffffff8069fdc0 ffffffff8069fdc0 ffff8800771a1e30 ffffffff=
804cad4c
[39129.729868]  ffff88007b890000 ffff88007b894200 ffff88007b890278 00000000=
00000282
[39129.730172] Call Trace:
[39129.730270]  [<ffffffff804cad4c>] ? thread_return+0x3d/0xda
[39129.730374]  [<ffffffff8023f022>] ? __mod_timer+0xb2/0xc4
[39129.730476]  [<ffffffff804cb0a1>] schedule_timeout+0xa8/0xcf
[39129.730579]  [<ffffffff8023eb1e>] ? process_timeout+0x0/0xb
[39129.730694]  [<ffffffffa034daa4>] svc_recv+0x338/0x78b [sunrpc]
[39129.730797]  [<ffffffff80231ec5>] ? try_to_wake_up+0x1d2/0x1e4
[39129.730902]  [<ffffffff80231ed7>] ? default_wake_function+0x0/0xf
[39129.731005]  [<ffffffff80231f03>] ? wake_up_process+0x10/0x12
[39129.731115]  [<ffffffffa038c777>] nfsd+0xeb/0x291 [nfsd]
[39129.731224]  [<ffffffffa038c68c>] ? nfsd+0x0/0x291 [nfsd]
[39129.731333]  [<ffffffffa038c68c>] ? nfsd+0x0/0x291 [nfsd]
[39129.731436]  [<ffffffff80248d3e>] kthread+0x49/0x76
[39129.731538]  [<ffffffff8020c5ea>] child_rip+0xa/0x20
[39129.731640]  [<ffffffff80248cf5>] ? kthread+0x0/0x76
[39129.731742]  [<ffffffff8020c5e0>] ? child_rip+0x0/0x20
[39129.731844] nfsd          S ffff8800771a2000     0  4002      2
[39129.732030]  ffff8800771e3e00 0000000000000046 ffffffff8069fdc0 00000000=
00000000
[39129.732335]  ffffffff8069fdc0 ffffffff8069fdc0 ffff8800771e3e30 ffffffff=
804cad4c
[39129.732640]  ffff88007b894200 ffff88007b891800 ffff88007b894478 00000000=
00000282
[39129.732945] Call Trace:
[39129.733045]  [<ffffffff804cad4c>] ? thread_return+0x3d/0xda
[39129.733166]  [<ffffffff8023f022>] ? __mod_timer+0xb2/0xc4
[39129.733269]  [<ffffffff804cb0a1>] schedule_timeout+0xa8/0xcf
[39129.733378]  [<ffffffff8023eb1e>] ? process_timeout+0x0/0xb
[39129.733493]  [<ffffffffa034daa4>] svc_recv+0x338/0x78b [sunrpc]
[39129.733596]  [<ffffffff80231ec5>] ? try_to_wake_up+0x1d2/0x1e4
[39129.733701]  [<ffffffff80231ed7>] ? default_wake_function+0x0/0xf
[39129.733804]  [<ffffffff80231f03>] ? wake_up_process+0x10/0x12
[39129.733914]  [<ffffffffa038c777>] nfsd+0xeb/0x291 [nfsd]
[39129.734023]  [<ffffffffa038c68c>] ? nfsd+0x0/0x291 [nfsd]
[39129.734132]  [<ffffffffa038c68c>] ? nfsd+0x0/0x291 [nfsd]
[39129.734235]  [<ffffffff80248d3e>] kthread+0x49/0x76
[39129.734337]  [<ffffffff8020c5ea>] child_rip+0xa/0x20
[39129.734439]  [<ffffffff80248cf5>] ? kthread+0x0/0x76
[39129.734541]  [<ffffffff8020c5e0>] ? child_rip+0x0/0x20
[39129.734643] nfsd          S ffff8800771e4000     0  4003      2
[39129.734816]  ffff880077225e00 0000000000000046 ffffffff8069fdc0 00000000=
00000000
[39129.735122]  ffffffff8069fdc0 ffffffff8069fdc0 ffff880077225e30 ffffffff=
804cad4c
[39129.735426]  ffff88007b891800 ffff88007b893000 ffff88007b891a78 00000000=
00000282
[39129.735730] Call Trace:
[39129.735829]  [<ffffffff804cad4c>] ? thread_return+0x3d/0xda
[39129.735932]  [<ffffffff8023f022>] ? __mod_timer+0xb2/0xc4
[39129.736047]  [<ffffffff804cb0a1>] schedule_timeout+0xa8/0xcf
[39129.736151]  [<ffffffff8023eb1e>] ? process_timeout+0x0/0xb
[39129.736266]  [<ffffffffa034daa4>] svc_recv+0x338/0x78b [sunrpc]
[39129.736370]  [<ffffffff80231ec5>] ? try_to_wake_up+0x1d2/0x1e4
[39129.736474]  [<ffffffff80231ed7>] ? default_wake_function+0x0/0xf
[39129.736578]  [<ffffffff80231f03>] ? wake_up_process+0x10/0x12
[39129.736688]  [<ffffffffa038c777>] nfsd+0xeb/0x291 [nfsd]
[39129.738525]  [<ffffffffa038c68c>] ? nfsd+0x0/0x291 [nfsd]
[39129.738644]  [<ffffffffa038c68c>] ? nfsd+0x0/0x291 [nfsd]
[39129.738752]  [<ffffffff80248d3e>] kthread+0x49/0x76
[39129.738854]  [<ffffffff8020c5ea>] child_rip+0xa/0x20
[39129.738956]  [<ffffffff80248cf5>] ? kthread+0x0/0x76
[39129.739058]  [<ffffffff8020c5e0>] ? child_rip+0x0/0x20
[39129.739159] nfsd          S ffff880077226000     0  4004      2
[39129.739332]  ffff880077267e00 0000000000000046 ffffffff8069fdc0 00000000=
00000000
[39129.739637]  ffffffff8069fdc0 ffffffff8069fdc0 ffff880077267e30 ffffffff=
804cad4c
[39129.739941]  ffff88007b893000 ffff88007bba1800 ffff88007b893278 00000000=
00000282
[39129.740258] Call Trace:
[39129.740356]  [<ffffffff804cad4c>] ? thread_return+0x3d/0xda
[39129.740459]  [<ffffffff8023f022>] ? __mod_timer+0xb2/0xc4
[39129.740561]  [<ffffffff804cb0a1>] schedule_timeout+0xa8/0xcf
[39129.740665]  [<ffffffff8023eb1e>] ? process_timeout+0x0/0xb
[39129.740780]  [<ffffffffa034daa4>] svc_recv+0x338/0x78b [sunrpc]
[39129.740883]  [<ffffffff80231ec5>] ? try_to_wake_up+0x1d2/0x1e4
[39129.740988]  [<ffffffff80231ed7>] ? default_wake_function+0x0/0xf
[39129.741093]  [<ffffffff80231f03>] ? wake_up_process+0x10/0x12
[39129.741222]  [<ffffffffa038c777>] nfsd+0xeb/0x291 [nfsd]
[39129.741336]  [<ffffffffa038c68c>] ? nfsd+0x0/0x291 [nfsd]
[39129.741445]  [<ffffffffa038c68c>] ? nfsd+0x0/0x291 [nfsd]
[39129.741549]  [<ffffffff80248d3e>] kthread+0x49/0x76
[39129.741651]  [<ffffffff8020c5ea>] child_rip+0xa/0x20
[39129.741753]  [<ffffffff80248cf5>] ? kthread+0x0/0x76
[39129.741854]  [<ffffffff8020c5e0>] ? child_rip+0x0/0x20
[39129.741956] nfsd          S ffff880077268000     0  4005      2
[39129.742129]  ffff8800772a9e00 0000000000000046 ffffffff8069fdc0 00000000=
00000000
[39129.742433]  ffffffff8069fdc0 ffffffff8069fdc0 ffff8800772a9e30 ffffffff=
804cad4c
[39129.742737]  ffff88007bba1800 ffff88007bba2a00 ffff88007bba1a78 00000000=
00000282
[39129.743042] Call Trace:
[39129.743141]  [<ffffffff804cad4c>] ? thread_return+0x3d/0xda
[39129.743244]  [<ffffffff8023f022>] ? __mod_timer+0xb2/0xc4
[39129.743346]  [<ffffffff804cb0a1>] schedule_timeout+0xa8/0xcf
[39129.743449]  [<ffffffff8023eb1e>] ? process_timeout+0x0/0xb
[39129.743564]  [<ffffffffa034daa4>] svc_recv+0x338/0x78b [sunrpc]
[39129.743668]  [<ffffffff80231ec5>] ? try_to_wake_up+0x1d2/0x1e4
[39129.743772]  [<ffffffff80231ed7>] ? default_wake_function+0x0/0xf
[39129.743875]  [<ffffffff80231f03>] ? wake_up_process+0x10/0x12
[39129.743985]  [<ffffffffa038c777>] nfsd+0xeb/0x291 [nfsd]
[39129.744108]  [<ffffffffa038c68c>] ? nfsd+0x0/0x291 [nfsd]
[39129.744217]  [<ffffffffa038c68c>] ? nfsd+0x0/0x291 [nfsd]
[39129.744320]  [<ffffffff80248d3e>] kthread+0x49/0x76
[39129.744422]  [<ffffffff8020c5ea>] child_rip+0xa/0x20
[39129.744524]  [<ffffffff80248cf5>] ? kthread+0x0/0x76
[39129.744626]  [<ffffffff8020c5e0>] ? child_rip+0x0/0x20
[39129.744727] nfsd          S ffff8800772aa000     0  4006      2
[39129.744901]  ffff8800772f3e00 0000000000000046 ffffffff8069fdc0 00000000=
00000000
[39129.745228]  ffffffff8069fdc0 ffffffff8069fdc0 ffff8800772f3e30 ffffffff=
804cad4c
[39129.745539]  ffff88007bba2a00 ffff88007bba4200 ffff88007bba2c78 00000000=
00000282
[39129.745844] Call Trace:
[39129.745942]  [<ffffffff804cad4c>] ? thread_return+0x3d/0xda
[39129.746045]  [<ffffffff8023f022>] ? __mod_timer+0xb2/0xc4
[39129.746147]  [<ffffffff804cb0a1>] schedule_timeout+0xa8/0xcf
[39129.746251]  [<ffffffff8023eb1e>] ? process_timeout+0x0/0xb
[39129.746366]  [<ffffffffa034daa4>] svc_recv+0x338/0x78b [sunrpc]
[39129.746470]  [<ffffffff80231ec5>] ? try_to_wake_up+0x1d2/0x1e4
[39129.746574]  [<ffffffff80231ed7>] ? default_wake_function+0x0/0xf
[39129.746678]  [<ffffffff80231f03>] ? wake_up_process+0x10/0x12
[39129.746788]  [<ffffffffa038c777>] nfsd+0xeb/0x291 [nfsd]
[39129.746897]  [<ffffffffa038c68c>] ? nfsd+0x0/0x291 [nfsd]
[39129.747006]  [<ffffffffa038c68c>] ? nfsd+0x0/0x291 [nfsd]
[39129.747109]  [<ffffffff80248d3e>] kthread+0x49/0x76
[39129.747211]  [<ffffffff8020c5ea>] child_rip+0xa/0x20
[39129.747313]  [<ffffffff80248cf5>] ? kthread+0x0/0x76
[39129.747415]  [<ffffffff8020c5e0>] ? child_rip+0x0/0x20
[39129.747516] nfsd          S ffff8800772f4000     0  4007      2
[39129.747690]  ffff880077335e00 0000000000000046 ffffffff8069fdc0 00000000=
00000000
[39129.748007]  ffffffff8069fdc0 ffffffff8069fdc0 ffff880077335e30 ffffffff=
804cad4c
[39129.748311]  ffff88007bba4200 ffff88005b9c2400 ffff88007bba4478 00000000=
00000282
[39129.748616] Call Trace:
[39129.748714]  [<ffffffff804cad4c>] ? thread_return+0x3d/0xda
[39129.748817]  [<ffffffff8023f022>] ? __mod_timer+0xb2/0xc4
[39129.748919]  [<ffffffff804cb0a1>] schedule_timeout+0xa8/0xcf
[39129.749024]  [<ffffffff8023eb1e>] ? process_timeout+0x0/0xb
[39129.749158]  [<ffffffffa034daa4>] svc_recv+0x338/0x78b [sunrpc]
[39129.749268]  [<ffffffff80231ed7>] ? default_wake_function+0x0/0xf
[39129.749378]  [<ffffffffa038c777>] nfsd+0xeb/0x291 [nfsd]
[39129.749487]  [<ffffffffa038c68c>] ? nfsd+0x0/0x291 [nfsd]
[39129.749596]  [<ffffffffa038c68c>] ? nfsd+0x0/0x291 [nfsd]
[39129.749699]  [<ffffffff80248d3e>] kthread+0x49/0x76
[39129.749801]  [<ffffffff8020c5ea>] child_rip+0xa/0x20
[39129.749903]  [<ffffffff80248cf5>] ? kthread+0x0/0x76
[39129.750005]  [<ffffffff8020c5e0>] ? child_rip+0x0/0x20
[39129.750106] nfsd          S ffff880077336000     0  4008      2
[39129.750281]  ffff880077395e00 0000000000000046 ffffffff8069fdc0 00000000=
00000000
[39129.750585]  ffffffff8069fdc0 ffffffff8069fdc0 ffff880077395e30 ffffffff=
804cad4c
[39129.750889]  ffff88007bba3c00 ffff88007b905a00 ffff88007bba3e78 00000000=
00000282
[39129.751194] Call Trace:
[39129.751292]  [<ffffffff804cad4c>] ? thread_return+0x3d/0xda
[39129.751395]  [<ffffffff8023f022>] ? __mod_timer+0xb2/0xc4
[39129.751497]  [<ffffffff804cb0a1>] schedule_timeout+0xa8/0xcf
[39129.751600]  [<ffffffff8023eb1e>] ? process_timeout+0x0/0xb
[39129.751715]  [<ffffffffa034daa4>] svc_recv+0x338/0x78b [sunrpc]
[39129.751832]  [<ffffffffa0343313>] ? svc_process+0x468/0x723 [sunrpc]
[39129.751936]  [<ffffffff80231ed7>] ? default_wake_function+0x0/0xf
[39129.752059]  [<ffffffffa038c777>] nfsd+0xeb/0x291 [nfsd]
[39129.752168]  [<ffffffffa038c68c>] ? nfsd+0x0/0x291 [nfsd]
[39129.752277]  [<ffffffffa038c68c>] ? nfsd+0x0/0x291 [nfsd]
[39129.752379]  [<ffffffff80248d3e>] kthread+0x49/0x76
[39129.752481]  [<ffffffff8020c5ea>] child_rip+0xa/0x20
[39129.752583]  [<ffffffff80248cf5>] ? kthread+0x0/0x76
[39129.752685]  [<ffffffff8020c5e0>] ? child_rip+0x0/0x20
[39129.752786] rpc.mountd    D 00007f4494a7d140     0  4012      1
[39129.752959]  ffff880077115d78 0000000000000086 ffff880077115cc8 ffffffff=
8026d481
[39129.753289]  ffffffff8069fdc0 ffffffff8069fdc0 ffff880077115d58 ffffffff=
8027f145
[39129.753594]  ffff88007bba6000 ffff88007b954e00 ffff88007bba6278 00000001=
00000200
[39129.753898] Call Trace:
[39129.753996]  [<ffffffff8026d481>] ? unlock_page+0x22/0x27
[39129.754099]  [<ffffffff8027f145>] ? __do_fault+0x367/0x3ad
[39129.754202]  [<ffffffff8024e7e0>] refrigerator+0xe7/0xf3
[39129.754304]  [<ffffffff802425b8>] get_signal_to_deliver+0x5a/0x3aa
[39129.754407]  [<ffffffff8020a904>] do_notify_resume+0x8c/0x833
[39129.754511]  [<ffffffff804ccd1f>] ? page_fault+0x1f/0x30
[39129.754613]  [<ffffffff802a8467>] ? sys_select+0xa7/0xbc
[39129.754715]  [<ffffffff8020b735>] sysret_signal+0x6d/0xb7
[39129.754817] nginx         D 0000000000693590     0  4020      1
[39129.754991]  ffff880076c11d78 0000000000000086 0000000000000000 ffffffff=
8026d481
[39129.755295]  ffffffff8069fdc0 ffffffff8069fdc0 ffff880076c11ce8 ffffffff=
80227295
[39129.755599]  ffff88007bba1200 ffff88007bba6000 ffff88007bba1478 00000001=
8027f986
[39129.755904] Call Trace:
[39129.756016]  [<ffffffff8026d481>] ? unlock_page+0x22/0x27
[39129.756119]  [<ffffffff80227295>] ? ptep_set_access_flags+0x22/0x28
[39129.756223]  [<ffffffff8024e7e0>] refrigerator+0xe7/0xf3
[39129.756325]  [<ffffffff802425b8>] get_signal_to_deliver+0x5a/0x3aa
[39129.756429]  [<ffffffff8022b43b>] ? update_curr+0x53/0xf0
[39129.756531]  [<ffffffff8020a904>] do_notify_resume+0x8c/0x833
[39129.756633]  [<ffffffff8022b7fc>] ? set_next_entity+0x3b/0x61
[39129.756736]  [<ffffffff8022ff17>] ? finish_task_switch+0x2b/0x8e
[39129.756839]  [<ffffffff804cad4c>] ? thread_return+0x3d/0xda
[39129.756942]  [<ffffffff80235273>] ? do_fork+0x270/0x336
[39129.757046]  [<ffffffff8020b735>] sysret_signal+0x6d/0xb7
[39129.757167] nginx         D 0000000000693710     0  4021   4020
[39129.757346]  ffff880076c13d78 0000000000000086 ffff880001019dc0 00000000=
00000001
[39129.757651]  ffffffff8069fdc0 ffffffff8069fdc0 ffff880076c13d58 ffff8800=
01019e30
[39129.757956]  ffff88007b951800 ffff88007b900600 ffff88007b951a78 00000000=
7b900638
[39129.758261] Call Trace:
[39129.758360]  [<ffffffff8022ff17>] ? finish_task_switch+0x2b/0x8e
[39129.758463]  [<ffffffff8024e7e0>] refrigerator+0xe7/0xf3
[39129.758566]  [<ffffffff802425b8>] get_signal_to_deliver+0x5a/0x3aa
[39129.758669]  [<ffffffff8020a904>] do_notify_resume+0x8c/0x833
[39129.758772]  [<ffffffff804cb01b>] ? schedule_timeout+0x22/0xcf
[39129.758875]  [<ffffffff802a8bd8>] ? __d_free+0x4f/0x53
[39129.758977]  [<ffffffff802a8c0e>] ? d_free+0x32/0x49
[39129.759078]  [<ffffffff802c339b>] ? sys_epoll_wait+0x464/0x47c
[39129.759181]  [<ffffffff80231ed7>] ? default_wake_function+0x0/0xf
[39129.759285]  [<ffffffff8020b735>] sysret_signal+0x6d/0xb7
[39129.759387] master        D 00000000ffffffff     0  4087      1
[39129.759560]  ffff880076cb7d78 0000000000000082 ffff880001019dc0 00000000=
00000000
[39129.759865]  ffffffff8069fdc0 ffffffff8069fdc0 0000000000000000 ffff8800=
01019e30
[39129.760182]  ffff88007b902a00 ffff88005b9c2400 ffff88007b902c78 00000000=
8022bca1
[39129.760485] Call Trace:
[39129.760584]  [<ffffffff8022acbd>] ? dequeue_task+0xad/0xb8
[39129.762397]  [<ffffffff8022ff17>] ? finish_task_switch+0x2b/0x8e
[39129.762519]  [<ffffffff8024e7e0>] refrigerator+0xe7/0xf3
[39129.762621]  [<ffffffff802425b8>] get_signal_to_deliver+0x5a/0x3aa
[39129.762730]  [<ffffffff8020a904>] do_notify_resume+0x8c/0x833
[39129.762833]  [<ffffffff8023ef02>] ? del_timer_sync+0x14/0x20
[39129.762936]  [<ffffffff804cb0ac>] ? schedule_timeout+0xb3/0xcf
[39129.763039]  [<ffffffff8023eb1e>] ? process_timeout+0x0/0xb
[39129.763141]  [<ffffffff802c339b>] ? sys_epoll_wait+0x464/0x47c
[39129.763245]  [<ffffffff80231ed7>] ? default_wake_function+0x0/0xf
[39129.763347]  [<ffffffff8020b735>] sysret_signal+0x6d/0xb7
[39129.763449] uml_switch    D 00007fffd57f34b0     0  4109      1
[39129.763622]  ffff880076d9fd78 0000000000000086 ffffffff8023fdb5 ffff8800=
7ab081e0
[39129.763927]  ffffffff8069fdc0 ffffffff8069fdc0 ffff88007bba3600 ffff8800=
76d9fe78
[39129.764244]  ffff88007bba3600 ffff8800795dbc00 ffff88007bba3878 00000001=
0a40caa0
[39129.764547] Call Trace:
[39129.764646]  [<ffffffff8023fdb5>] ? __sigqueue_free+0x3c/0x41
[39129.764749]  [<ffffffff8023fdb5>] ? __sigqueue_free+0x3c/0x41
[39129.764852]  [<ffffffff80240a6b>] ? __dequeue_signal+0x103/0x12f
[39129.764955]  [<ffffffff8024e7e0>] refrigerator+0xe7/0xf3
[39129.765058]  [<ffffffff802425b8>] get_signal_to_deliver+0x5a/0x3aa
[39129.765180]  [<ffffffff8020a904>] do_notify_resume+0x8c/0x833
[39129.765283]  [<ffffffff8024b5aa>] ? enqueue_hrtimer+0x65/0x72
[39129.765391]  [<ffffffff8024bdd8>] ? hrtimer_start_range_ns+0x1cb/0x1dd
[39129.765495]  [<ffffffff8020b3a5>] ? sys_rt_sigreturn+0x2e6/0x341
[39129.765598]  [<ffffffff8020b735>] sysret_signal+0x6d/0xb7
[39129.765699] dhcdbd        D 000000000061e808     0  4124      1
[39129.765873]  ffff880076d9bd78 0000000000000086 ffff880076d9bd68 00000000=
00034c8a
[39129.766177]  ffffffff8069fdc0 ffffffff8069fdc0 0000000000000206 00000001=
00939884
[39129.766481]  ffff8800795df800 ffff88005b9c2400 ffff8800795dfa78 00000000=
00000001
[39129.766785] Call Trace:
[39129.766883]  [<ffffffff802a7f8c>] ? do_select+0x5a2/0x5a4
[39129.766985]  [<ffffffff8024e7e0>] refrigerator+0xe7/0xf3
[39129.767087]  [<ffffffff802425b8>] get_signal_to_deliver+0x5a/0x3aa
[39129.767191]  [<ffffffff8020a904>] do_notify_resume+0x8c/0x833
[39129.767294]  [<ffffffff80209f5a>] ? __switch_to+0x35e/0x36e
[39129.767396]  [<ffffffff80250203>] ? getnstimeofday+0x58/0xb4
[39129.767499]  [<ffffffff8024bfc4>] ? ktime_get_ts+0x49/0x4e
[39129.767601]  [<ffffffff802a717d>] ? poll_select_copy_remaining+0xc5/0xea
[39129.767706]  [<ffffffff802a8467>] ? sys_select+0xa7/0xbc
[39129.767808]  [<ffffffff8020b735>] sysret_signal+0x6d/0xb7
[39129.767909] hald          D 00000000006e4f80     0  4135      1
[39129.768095]  ffff880076de7d78 0000000000000082 ffff880000000000 ffff8800=
76de7b98
[39129.768400]  ffffffff8069fdc0 ffffffff8069fdc0 0000000000200200 ffff8800=
783c4530
[39129.768704]  ffff8800795daa00 ffff88007bba0c00 ffff8800795dac78 00000000=
802a8546
[39129.769009] Call Trace:
[39129.769129]  [<ffffffff802a8546>] ? pollwake+0x0/0x4e
[39129.769231]  [<ffffffff8024e7e0>] refrigerator+0xe7/0xf3
[39129.769339]  [<ffffffff802425b8>] get_signal_to_deliver+0x5a/0x3aa
[39129.769442]  [<ffffffff8020a904>] do_notify_resume+0x8c/0x833
[39129.769545]  [<ffffffff80284a05>] ? unmap_region+0x11d/0x159
[39129.769648]  [<ffffffff80250203>] ? getnstimeofday+0x58/0xb4
[39129.769751]  [<ffffffff8024bfc4>] ? ktime_get_ts+0x49/0x4e
[39129.769853]  [<ffffffff802a72d8>] ? poll_select_set_timeout+0x5c/0x77
[39129.769957]  [<ffffffff8020b735>] sysret_signal+0x6d/0xb7
[39129.770059] hald-runner   D 0000000000604fe0     0  4136   4135
[39129.770232]  ffff880076e67d78 0000000000000082 0000000000000000 ffff8800=
76e67e68
[39129.770537]  ffffffff8069fdc0 ffffffff8069fdc0 0000000000000000 ffffffff=
00000040
[39129.770841]  ffff8800795dbc00 ffff88007b950600 ffff8800795dbe78 00000001=
76e67d28
[39129.771145] Call Trace:
[39129.771244]  [<ffffffff80299843>] ? do_sync_readv_writev+0xe3/0x12b
[39129.771348]  [<ffffffff80233496>] ? __cleanup_signal+0x27/0x2b
[39129.771451]  [<ffffffff8024e7e0>] refrigerator+0xe7/0xf3
[39129.771553]  [<ffffffff802425b8>] get_signal_to_deliver+0x5a/0x3aa
[39129.771656]  [<ffffffff8020a904>] do_notify_resume+0x8c/0x833
[39129.771759]  [<ffffffff8029a026>] ? do_readv_writev+0x17e/0x193
[39129.771863]  [<ffffffff80231ed7>] ? default_wake_function+0x0/0xf
[39129.771966]  [<ffffffff8020b735>] sysret_signal+0x6d/0xb7
[39129.772080] hald-addon-in D 000000000060c2c0     0  4168   4136
[39129.772254]  ffff880075441d78 0000000000000086 0000000000000000 ffff8800=
75441b98
[39129.772558]  ffffffff8069fdc0 ffffffff8069fdc0 0000000000200200 ffff8800=
7adb3068
[39129.772864]  ffff88007b953600 ffff8800795df800 ffff88007b953878 00000000=
802a8546
[39129.773191] Call Trace:
[39129.773290]  [<ffffffff802a8546>] ? pollwake+0x0/0x4e
[39129.773398]  [<ffffffff8024e7e0>] refrigerator+0xe7/0xf3
[39129.773500]  [<ffffffff802425b8>] get_signal_to_deliver+0x5a/0x3aa
[39129.773603]  [<ffffffff8020a904>] do_notify_resume+0x8c/0x833
[39129.773707]  [<ffffffff8042a5ea>] ? evdev_read+0x235/0x255
[39129.773809]  [<ffffffff8020bf8e>] ? common_interrupt+0xe/0x13
[39129.773912]  [<ffffffff80250203>] ? getnstimeofday+0x58/0xb4
[39129.774015]  [<ffffffff803321d0>] ? security_file_permission+0x11/0x13
[39129.774118]  [<ffffffff8020b735>] sysret_signal+0x6d/0xb7
[39129.774220] hald-addon-cp D 000000000060cc50     0  4172   4136
[39129.774393]  ffff880075459d78 0000000000000082 ffff880075459cc8 ffffffff=
8026d481
[39129.774698]  ffffffff8069fdc0 ffffffff8069fdc0 ffff880075459d58 ffffffff=
8027f145
[39129.775003]  ffff88007b950600 ffff88007b957800 ffff88007b950878 00000001=
00000200
[39129.775308] Call Trace:
[39129.775406]  [<ffffffff8026d481>] ? unlock_page+0x22/0x27
[39129.775508]  [<ffffffff8027f145>] ? __do_fault+0x367/0x3ad
[39129.775611]  [<ffffffff8024e7e0>] refrigerator+0xe7/0xf3
[39129.775713]  [<ffffffff802425b8>] get_signal_to_deliver+0x5a/0x3aa
[39129.775817]  [<ffffffff8020a904>] do_notify_resume+0x8c/0x833
[39129.775919]  [<ffffffff8029d0c3>] ? cp_new_stat+0xe2/0xef
[39129.776035]  [<ffffffff80249146>] ? autoremove_wake_function+0x0/0x38
[39129.776139]  [<ffffffff8029d2c1>] ? sys_newfstat+0x29/0x34
[39129.776242]  [<ffffffff8020b735>] sysret_signal+0x6d/0xb7
[39129.776344] hald-addon-ac D 0000000000000100     0  4173   4136
[39129.776518]  ffff88007545bd78 0000000000000082 0000000000000000 00000000=
00000000
[39129.776821]  ffffffff8069fdc0 ffffffff8069fdc0 0000000000000000 ffffffff=
00000040
[39129.777149]  ffff88007b900600 ffff8800795daa00 ffff88007b900878 00000000=
00001000
[39129.777459] Call Trace:
[39129.777558]  [<ffffffff80446db9>] ? sock_aio_read+0x146/0x15a
[39129.777661]  [<ffffffff8024e7e0>] refrigerator+0xe7/0xf3
[39129.777763]  [<ffffffff802425b8>] get_signal_to_deliver+0x5a/0x3aa
[39129.777867]  [<ffffffff8020a904>] do_notify_resume+0x8c/0x833
[39129.777971]  [<ffffffff80249146>] ? autoremove_wake_function+0x0/0x38
[39129.778075]  [<ffffffff80250203>] ? getnstimeofday+0x58/0xb4
[39129.778177]  [<ffffffff803321d0>] ? security_file_permission+0x11/0x13
[39129.778282]  [<ffffffff8029a4f5>] ? vfs_read+0xbe/0x154
[39129.778383]  [<ffffffff8020b735>] sysret_signal+0x6d/0xb7
[39129.778485] hcid          D 00007f04966f7b70     0  4198      1
[39129.778659]  ffff8800755c9d78 0000000000000082 ffff880000000000 ffff8800=
755c9b98
[39129.778963]  ffffffff8069fdc0 ffffffff8069fdc0 0000000000200200 ffff8800=
781ed930
[39129.779268]  ffff88007b901e00 ffff88007b955a00 ffff88007b902078 00000001=
00000200
[39129.779572] Call Trace:
[39129.779671]  [<ffffffff8024e7e0>] refrigerator+0xe7/0xf3
[39129.779774]  [<ffffffff802425b8>] get_signal_to_deliver+0x5a/0x3aa
[39129.779877]  [<ffffffff8020a904>] do_notify_resume+0x8c/0x833
[39129.779980]  [<ffffffff80446a6e>] ? sock_ioctl+0x1e2/0x20c
[39129.780096]  [<ffffffff802a63a4>] ? vfs_ioctl+0x2a/0x78
[39129.780198]  [<ffffffff802a6838>] ? do_vfs_ioctl+0x446/0x482
[39129.780301]  [<ffffffff8029d2c1>] ? sys_newfstat+0x29/0x34
[39129.780403]  [<ffffffff8020b735>] sysret_signal+0x6d/0xb7
[39129.780505] btaddconn     S ffff880075465988     0  4205      2
[39129.780678]  ffff880075613ec0 0000000000000046 ffffffff802455cd ffff8800=
755cdce8
[39129.780982]  ffffffff8069fdc0 ffffffff8069fdc0 ffff880075613e40 ffffffff=
8022ff17
[39129.781312]  ffff88007c066600 ffff88007c062400 ffff88007c066878 00000001=
00000000
[39129.781616] Call Trace:
[39129.781714]  [<ffffffff802455cd>] ? worker_thread+0x0/0xee
[39129.781816]  [<ffffffff8022ff17>] ? finish_task_switch+0x2b/0x8e
[39129.781920]  [<ffffffff80231ec5>] ? try_to_wake_up+0x1d2/0x1e4
[39129.782023]  [<ffffffff80245676>] worker_thread+0xa9/0xee
[39129.782126]  [<ffffffff80249146>] ? autoremove_wake_function+0x0/0x38
[39129.782229]  [<ffffffff802455cd>] ? worker_thread+0x0/0xee
[39129.782331]  [<ffffffff80248d3e>] kthread+0x49/0x76
[39129.782433]  [<ffffffff8020c5ea>] child_rip+0xa/0x20
[39129.782535]  [<ffffffff8022acbd>] ? dequeue_task+0xad/0xb8
[39129.782637]  [<ffffffff80248cf5>] ? kthread+0x0/0x76
[39129.782739]  [<ffffffff8020c5e0>] ? child_rip+0x0/0x20
[39129.782840] btdelconn     S ffff880075465008     0  4206      2
[39129.783013]  ffff880075615ec0 0000000000000046 ffff88007adbd380 ffff8800=
7b901200
[39129.783318]  ffffffff8069fdc0 ffffffff8069fdc0 ffff880075615e40 ffffffff=
8022ff5b
[39129.783621]  ffff88007b955400 ffff88007c062400 ffff88007b955678 00000001=
7b9011f0
[39129.783925] Call Trace:
[39129.784036]  [<ffffffff8022ff5b>] ? finish_task_switch+0x6f/0x8e
[39129.784139]  [<ffffffff80231ec5>] ? try_to_wake_up+0x1d2/0x1e4
[39129.784242]  [<ffffffff80245676>] worker_thread+0xa9/0xee
[39129.784345]  [<ffffffff80249146>] ? autoremove_wake_function+0x0/0x38
[39129.784449]  [<ffffffff802455cd>] ? worker_thread+0x0/0xee
[39129.784552]  [<ffffffff80248d3e>] kthread+0x49/0x76
[39129.784653]  [<ffffffff8020c5ea>] child_rip+0xa/0x20
[39129.786479]  [<ffffffff80248cf5>] ? kthread+0x0/0x76
[39129.786600]  [<ffffffff8020c5e0>] ? child_rip+0x0/0x20
[39129.786702] krfcommd      S ffff8800755cdd68     0  4219      2
[39129.786881]  ffff88007565bda0 0000000000000046 ffff88007565bcf0 ffffffff=
804cc6a0
[39129.787185]  ffffffff8069fdc0 ffffffff8069fdc0 ffff88007565bd50 ffffffff=
80449ab7
[39129.787489]  ffff88007c066c00 ffff88007b954200 ffff88007c066e78 00000000=
804cc78c
[39129.787793] Call Trace:
[39129.787891]  [<ffffffff804cc6a0>] ? _spin_lock_bh+0x11/0x38
[39129.788006]  [<ffffffff80449ab7>] ? lock_sock_nested+0xa7/0xb4
[39129.788113]  [<ffffffffa03e3e1e>] ? rfcomm_run+0x0/0x138e [rfcomm]
[39129.788218]  [<ffffffffa03e3f8f>] rfcomm_run+0x171/0x138e [rfcomm]
[39129.788322]  [<ffffffff804d082b>] ? kprobe_flush_task+0xa8/0xb7
[39129.788425]  [<ffffffff8022ff5b>] ? finish_task_switch+0x6f/0x8e
[39129.788528]  [<ffffffff804cad4c>] ? thread_return+0x3d/0xda
[39129.788632]  [<ffffffffa03e3e1e>] ? rfcomm_run+0x0/0x138e [rfcomm]
[39129.788736]  [<ffffffff80248d3e>] kthread+0x49/0x76
[39129.788838]  [<ffffffff8020c5ea>] child_rip+0xa/0x20
[39129.788940]  [<ffffffff8022acbd>] ? dequeue_task+0xad/0xb8
[39129.789044]  [<ffffffff80248cf5>] ? kthread+0x0/0x76
[39129.789166]  [<ffffffff8020c5e0>] ? child_rip+0x0/0x20
[39129.789267] mdadm         D 0000000000000000     0  4228      1
[39129.789447]  ffff8800755d1d78 0000000000000082 0000003000000010 ffff8800=
755d1d98
[39129.789751]  ffffffff8069fdc0 ffffffff8069fdc0 ffffffff8062c9c0 00000001=
00000006
[39129.790055]  ffff88007b957800 ffff8800795d8000 ffff88007b957a78 00000001=
0062e0f0
[39129.790359] Call Trace:
[39129.790458]  [<ffffffff8024e7e0>] refrigerator+0xe7/0xf3
[39129.790561]  [<ffffffff802425b8>] get_signal_to_deliver+0x5a/0x3aa
[39129.790664]  [<ffffffff8020a904>] do_notify_resume+0x8c/0x833
[39129.790766]  [<ffffffff80250203>] ? getnstimeofday+0x58/0xb4
[39129.790868]  [<ffffffff8024bfc4>] ? ktime_get_ts+0x49/0x4e
[39129.790971]  [<ffffffff802a717d>] ? poll_select_copy_remaining+0xc5/0xea
[39129.791075]  [<ffffffff802a8467>] ? sys_select+0xa7/0xbc
[39129.791177]  [<ffffffff8020b735>] sysret_signal+0x6d/0xb7
[39129.791279] NetworkManage D 00007fd218000c40     0  4240      1
[39129.791452]  ffff8800756a7d78 0000000000000082 ffff880000000000 ffff8800=
756a7e68
[39129.791756]  ffffffff8069fdc0 ffffffff8069fdc0 0000000000000000 ffff8800=
00000040
[39129.792073]  ffff88007b955a00 ffff8800738a0000 ffff88007b955c78 00000001=
756a7d28
[39129.792377] Call Trace:
[39129.792476]  [<ffffffff80299843>] ? do_sync_readv_writev+0xe3/0x12b
[39129.792580]  [<ffffffff802a1056>] ? pipe_read+0x397/0x3ad
[39129.792682]  [<ffffffff8024e7e0>] refrigerator+0xe7/0xf3
[39129.792784]  [<ffffffff802425b8>] get_signal_to_deliver+0x5a/0x3aa
[39129.792888]  [<ffffffff8020a904>] do_notify_resume+0x8c/0x833
[39129.792991]  [<ffffffff8029a026>] ? do_readv_writev+0x17e/0x193
[39129.793096]  [<ffffffff803321d0>] ? security_file_permission+0x11/0x13
[39129.793218]  [<ffffffff8020b735>] sysret_signal+0x6d/0xb7
[39129.793320] NetworkManage D 0000000000665a00     0  4285      1
[39129.793499]  ffff8800755fdd78 0000000000000082 ffff8800755fdcd8 ffffffff=
802b01ef
[39129.793804]  ffffffff8069fdc0 ffffffff8069fdc0 ffff880074c811c0 ffff8800=
75624540
[39129.794108]  ffff8800738a0000 ffff8800795dd400 ffff8800738a0278 00000001=
01fc5def
[39129.794412] Call Trace:
[39129.794511]  [<ffffffff802b01ef>] ? mnt_drop_write+0xa0/0x147
[39129.794613]  [<ffffffff802a0cad>] ? pipe_write+0x4ec/0x4fe
[39129.794716]  [<ffffffff804b8eda>] ? wext_handle_ioctl+0x55/0x6f
[39129.794819]  [<ffffffff8024e7e0>] refrigerator+0xe7/0xf3
[39129.794921]  [<ffffffff802425b8>] get_signal_to_deliver+0x5a/0x3aa
[39129.795024]  [<ffffffff8020a904>] do_notify_resume+0x8c/0x833
[39129.795127]  [<ffffffff80249146>] ? autoremove_wake_function+0x0/0x38
[39129.795231]  [<ffffffff802a8c0e>] ? d_free+0x32/0x49
[39129.795333]  [<ffffffff80250203>] ? getnstimeofday+0x58/0xb4
[39129.795435]  [<ffffffff8024bfc4>] ? ktime_get_ts+0x49/0x4e
[39129.795538]  [<ffffffff802a72d8>] ? poll_select_set_timeout+0x5c/0x77
[39129.795641]  [<ffffffff8020b735>] sysret_signal+0x6d/0xb7
[39129.795743] NetworkManage D 00000000006644d0     0  4289      1
[39129.795916]  ffff880074487d78 0000000000000082 ffff880074487cd8 ffffffff=
802b01ef
[39129.796232]  ffffffff8069fdc0 ffffffff8069fdc0 ffff880074c811c0 ffff8800=
75624540
[39129.796537]  ffff8800795d8000 ffff8800738a1200 ffff8800795d8278 00000001=
32d0a2a6
[39129.796840] Call Trace:
[39129.796939]  [<ffffffff802b01ef>] ? mnt_drop_write+0xa0/0x147
[39129.797043]  [<ffffffff802a0cad>] ? pipe_write+0x4ec/0x4fe
[39129.797165]  [<ffffffff8024e7e0>] refrigerator+0xe7/0xf3
[39129.797267]  [<ffffffff802425b8>] get_signal_to_deliver+0x5a/0x3aa
[39129.797376]  [<ffffffff8020a904>] do_notify_resume+0x8c/0x833
[39129.797479]  [<ffffffff80249146>] ? autoremove_wake_function+0x0/0x38
[39129.797583]  [<ffffffff803321d0>] ? security_file_permission+0x11/0x13
[39129.797687]  [<ffffffff8020b735>] sysret_signal+0x6d/0xb7
[39129.797788] NetworkManage D 000000000060d550     0  4248      1
[39129.797962]  ffff8800756d7d78 0000000000000086 0000000000000000 00000000=
00000000
[39129.798267]  ffffffff8069fdc0 ffffffff8069fdc0 ffff8800756d7ce8 ffffffff=
80227295
[39129.798571]  ffff8800795d8600 ffff88007c060000 ffff8800795d8878 00000000=
00000800
[39129.798893] Call Trace:
[39129.798992]  [<ffffffff80227295>] ? ptep_set_access_flags+0x22/0x28
[39129.799096]  [<ffffffff80446db9>] ? sock_aio_read+0x146/0x15a
[39129.799199]  [<ffffffff8024e7e0>] refrigerator+0xe7/0xf3
[39129.799301]  [<ffffffff802425b8>] get_signal_to_deliver+0x5a/0x3aa
[39129.799404]  [<ffffffff8020a904>] do_notify_resume+0x8c/0x833
[39129.799507]  [<ffffffff80249146>] ? autoremove_wake_function+0x0/0x38
[39129.799611]  [<ffffffff803321d0>] ? security_file_permission+0x11/0x13
[39129.799715]  [<ffffffff8020b735>] sysret_signal+0x6d/0xb7
[39129.799817] system-tools- D 0000000000610880     0  4260      1
[39129.799990]  ffff8800744bdd78 0000000000000082 ffff8800744bdcc8 ffffffff=
8026d481
[39129.800308]  ffffffff8069fdc0 ffffffff8069fdc0 ffff8800744bdd58 ffffffff=
8027f145
[39129.800612]  ffff8800795dd400 ffff8800738a3c00 ffff8800795dd678 00000001=
00000200
[39129.800916] Call Trace:
[39129.801017]  [<ffffffff8026d481>] ? unlock_page+0x22/0x27
[39129.801138]  [<ffffffff8027f145>] ? __do_fault+0x367/0x3ad
[39129.801242]  [<ffffffff8024e7e0>] refrigerator+0xe7/0xf3
[39129.801349]  [<ffffffff802425b8>] get_signal_to_deliver+0x5a/0x3aa
[39129.801453]  [<ffffffff8020a904>] do_notify_resume+0x8c/0x833
[39129.801556]  [<ffffffff8029d0c3>] ? cp_new_stat+0xe2/0xef
[39129.801659]  [<ffffffff80249146>] ? autoremove_wake_function+0x0/0x38
[39129.801763]  [<ffffffff8029d2c1>] ? sys_newfstat+0x29/0x34
[39129.801865]  [<ffffffff8020b735>] sysret_signal+0x6d/0xb7
[39129.801967] atd           D 00007fff4297f3e0     0  4292      1
[39129.802140]  ffff8800744c5d78 0000000000000086 ffff8800744c5cc8 ffffffff=
802a1437
[39129.802443]  ffffffff8069fdc0 ffffffff8069fdc0 ffff8800744c5d58 ffffffff=
802a310b
[39129.802747]  ffff8800738a1200 ffff880074584e00 ffff8800738a1478 00000001=
7bb79800
[39129.803051] Call Trace:
[39129.803149]  [<ffffffff802a1437>] ? inode_permission+0x8b/0x97
[39129.803252]  [<ffffffff802a310b>] ? __link_path_walk+0x134/0xde0
[39129.803355]  [<ffffffff8022b869>] ? dequeue_entity+0x18/0x12c
[39129.803458]  [<ffffffff8024e7e0>] refrigerator+0xe7/0xf3
[39129.803560]  [<ffffffff802425b8>] get_signal_to_deliver+0x5a/0x3aa
[39129.803664]  [<ffffffff8020a904>] do_notify_resume+0x8c/0x833
[39129.803766]  [<ffffffff80250203>] ? getnstimeofday+0x58/0xb4
[39129.803869]  [<ffffffff8024bfc4>] ? ktime_get_ts+0x49/0x4e
[39129.803971]  [<ffffffff8024bfda>] ? ktime_get+0x11/0x42
[39129.804086]  [<ffffffff8024b645>] ? update_rmtp+0x4c/0x61
[39129.804188]  [<ffffffff804cb836>] ? hrtimer_nanosleep_restart+0x4c/0x63
[39129.804293]  [<ffffffff8020b735>] sysret_signal+0x6d/0xb7
[39129.804394] cron          D 00007fff6fbed690     0  4323      1
[39129.804567]  ffff880073c09d78 0000000000000082 ffff880073c09cc8 ffffffff=
802a9348
[39129.804872]  ffffffff8069fdc0 ffffffff8069fdc0 ffff880073c09d58 ffffffff=
802a3ca0
[39129.805199]  ffff8800738a3c00 ffff880074585400 ffff8800738a3e78 00000001=
7bb79800
[39129.805509] Call Trace:
[39129.805607]  [<ffffffff802a9348>] ? dput+0x24/0x145
[39129.805709]  [<ffffffff802a3ca0>] ? __link_path_walk+0xcc9/0xde0
[39129.805813]  [<ffffffff8022b869>] ? dequeue_entity+0x18/0x12c
[39129.805916]  [<ffffffff8024e7e0>] refrigerator+0xe7/0xf3
[39129.806017]  [<ffffffff802425b8>] get_signal_to_deliver+0x5a/0x3aa
[39129.806121]  [<ffffffff8020a904>] do_notify_resume+0x8c/0x833
[39129.806224]  [<ffffffff80250203>] ? getnstimeofday+0x58/0xb4
[39129.806326]  [<ffffffff8024bfc4>] ? ktime_get_ts+0x49/0x4e
[39129.806428]  [<ffffffff8024bfda>] ? ktime_get+0x11/0x42
[39129.806530]  [<ffffffff8024b645>] ? update_rmtp+0x4c/0x61
[39129.806632]  [<ffffffff8024be9b>] ? hrtimer_nanosleep+0xb1/0xff
[39129.806735]  [<ffffffff8024b65a>] ? hrtimer_wakeup+0x0/0x21
[39129.806837]  [<ffffffff8020b735>] sysret_signal+0x6d/0xb7
[39129.806939] login         D 000000000061ce40     0  4415      1
[39129.807114]  ffff880072c1fd78 0000000000000082 0000000000000000 00000000=
00000000
[39129.807821]  ffffffff8069fdc0 ffffffff8069fdc0 8000000074a3c067 ffffe200=
019e4f90
[39129.808139]  ffff880074584e00 ffff880074582a00 ffff880074585078 00000001=
00000000
[39129.808444] Call Trace:
[39129.808543]  [<ffffffff80350c3d>] ? rb_erase+0x14f/0x2a0
[39129.808644]  [<ffffffff8022b7fc>] ? set_next_entity+0x3b/0x61
[39129.808747]  [<ffffffff8024e7e0>] refrigerator+0xe7/0xf3
[39129.808849]  [<ffffffff802425b8>] get_signal_to_deliver+0x5a/0x3aa
[39129.808952]  [<ffffffff8020a904>] do_notify_resume+0x8c/0x833
[39129.809056]  [<ffffffff8021c04e>] ? native_smp_send_reschedule+0x50/0x52
[39129.809179]  [<ffffffff8022a5d7>] ? resched_task+0x67/0x69
[39129.810996]  [<ffffffff802493a8>] ? remove_wait_queue+0x3c/0x41
[39129.811099]  [<ffffffff80238ad4>] ? do_wait+0x2d6/0x393
[39129.811201]  [<ffffffff80231ed7>] ? default_wake_function+0x0/0xf
[39129.811304]  [<ffffffff8020b735>] sysret_signal+0x6d/0xb7
[39129.811406] getty         D 0000000000604580     0  4419      1
[39129.811580]  ffff88007458fd78 0000000000000086 ffff88007458fcc8 00000000=
00000096
[39129.811884]  ffffffff8069fdc0 ffffffff8069fdc0 ffff880074584200 ffff8800=
01019dc0
[39129.812201]  ffff880074585400 ffff880074583c00 ffff880074585678 00000001=
8022a5d7
[39129.812506] Call Trace:
[39129.812604]  [<ffffffff80231ec5>] ? try_to_wake_up+0x1d2/0x1e4
[39129.812707]  [<ffffffff8024e7e0>] refrigerator+0xe7/0xf3
[39129.812809]  [<ffffffff802425b8>] get_signal_to_deliver+0x5a/0x3aa
[39129.812913]  [<ffffffff802493a8>] ? remove_wait_queue+0x3c/0x41
[39129.813017]  [<ffffffff8020a904>] do_notify_resume+0x8c/0x833
[39129.813139]  [<ffffffff8022b175>] ? __wake_up+0x43/0x50
[39129.813241]  [<ffffffff80231ed7>] ? default_wake_function+0x0/0xf
[39129.813351]  [<ffffffff803aac9c>] ? tty_ldisc_deref+0x69/0x6e
[39129.813454]  [<ffffffff803a3f6c>] ? tty_read+0x87/0xba
[39129.813556]  [<ffffffff8029a4e2>] ? vfs_read+0xab/0x154
[39129.813658]  [<ffffffff8020b735>] sysret_signal+0x6d/0xb7
[39129.813759] getty         D 0000000000604580     0  4421      1
[39129.813933]  ffff88007390bd78 0000000000000082 ffff88007390bcc8 00000000=
00000096
[39129.814237]  ffffffff8069fdc0 ffffffff8069fdc0 ffff880074583c00 ffff8800=
01025dc0
[39129.814542]  ffff880074582a00 ffff880074584200 ffff880074582c78 00000001=
8022a5d7
[39129.814845] Call Trace:
[39129.814944]  [<ffffffff80231ec5>] ? try_to_wake_up+0x1d2/0x1e4
[39129.815048]  [<ffffffff8024e7e0>] refrigerator+0xe7/0xf3
[39129.815150]  [<ffffffff802425b8>] get_signal_to_deliver+0x5a/0x3aa
[39129.815253]  [<ffffffff802493a8>] ? remove_wait_queue+0x3c/0x41
[39129.815356]  [<ffffffff8020a904>] do_notify_resume+0x8c/0x833
[39129.815459]  [<ffffffff8022b175>] ? __wake_up+0x43/0x50
[39129.815561]  [<ffffffff80231ed7>] ? default_wake_function+0x0/0xf
[39129.815664]  [<ffffffff803aac9c>] ? tty_ldisc_deref+0x69/0x6e
[39129.815767]  [<ffffffff803a3f6c>] ? tty_read+0x87/0xba
[39129.815869]  [<ffffffff8029a4e2>] ? vfs_read+0xab/0x154
[39129.815971]  [<ffffffff8020b735>] sysret_signal+0x6d/0xb7
[39129.816086] getty         D 0000000000604580     0  4422      1
[39129.816259]  ffff880075487d78 0000000000000082 ffff880075487cc8 ffff8800=
745cc800
[39129.816563]  ffffffff8069fdc0 ffffffff8069fdc0 0000000000000020 00000000=
00000020
[39129.816866]  ffff880074583c00 ffff880074583600 ffff880074583e78 00000001=
74583c00
[39129.817194] Call Trace:
[39129.817292]  [<ffffffff804cb01b>] ? schedule_timeout+0x22/0xcf
[39129.817401]  [<ffffffff8024e7e0>] refrigerator+0xe7/0xf3
[39129.817503]  [<ffffffff802425b8>] get_signal_to_deliver+0x5a/0x3aa
[39129.817607]  [<ffffffff802493a8>] ? remove_wait_queue+0x3c/0x41
[39129.817710]  [<ffffffff8020a904>] do_notify_resume+0x8c/0x833
[39129.817813]  [<ffffffff8022b175>] ? __wake_up+0x43/0x50
[39129.817915]  [<ffffffff80231ed7>] ? default_wake_function+0x0/0xf
[39129.818018]  [<ffffffff803aac9c>] ? tty_ldisc_deref+0x69/0x6e
[39129.818121]  [<ffffffff803a3f6c>] ? tty_read+0x87/0xba
[39129.818223]  [<ffffffff8029a4e2>] ? vfs_read+0xab/0x154
[39129.818325]  [<ffffffff8020b735>] sysret_signal+0x6d/0xb7
[39129.818426] getty         D 0000000000604580     0  4423      1
[39129.818600]  ffff8800745f7d78 0000000000000086 ffff8800745f7cc8 00000000=
00000096
[39129.818905]  ffffffff8069fdc0 ffffffff8069fdc0 ffff880074583c00 ffff8800=
01025dc0
[39129.819209]  ffff880074584200 ffff880074580000 ffff880074584478 00000001=
8022a5d7
[39129.819513] Call Trace:
[39129.819612]  [<ffffffff80231ec5>] ? try_to_wake_up+0x1d2/0x1e4
[39129.819715]  [<ffffffff8024e7e0>] refrigerator+0xe7/0xf3
[39129.819817]  [<ffffffff802425b8>] get_signal_to_deliver+0x5a/0x3aa
[39129.819920]  [<ffffffff802493a8>] ? remove_wait_queue+0x3c/0x41
[39129.820039]  [<ffffffff8020a904>] do_notify_resume+0x8c/0x833
[39129.820142]  [<ffffffff8022b175>] ? __wake_up+0x43/0x50
[39129.820244]  [<ffffffff80231ed7>] ? default_wake_function+0x0/0xf
[39129.820348]  [<ffffffff803aac9c>] ? tty_ldisc_deref+0x69/0x6e
[39129.820450]  [<ffffffff803a3f6c>] ? tty_read+0x87/0xba
[39129.820552]  [<ffffffff8029a4e2>] ? vfs_read+0xab/0x154
[39129.820654]  [<ffffffff8020b735>] sysret_signal+0x6d/0xb7
[39129.820755] getty         D 0000000000604580     0  4424      1
[39129.820928]  ffff880073c33d78 0000000000000082 ffff880073c33cc8 00000000=
00000096
[39129.821258]  ffffffff8069fdc0 ffffffff8069fdc0 ffff880074583c00 ffff8800=
01025dc0
[39129.821562]  ffff880074580000 ffff880074586000 ffff880074580278 00000001=
8022a5d7
[39129.821866] Call Trace:
[39129.821964]  [<ffffffff80231ec5>] ? try_to_wake_up+0x1d2/0x1e4
[39129.822068]  [<ffffffff8024e7e0>] refrigerator+0xe7/0xf3
[39129.822170]  [<ffffffff802425b8>] get_signal_to_deliver+0x5a/0x3aa
[39129.822274]  [<ffffffff802493a8>] ? remove_wait_queue+0x3c/0x41
[39129.822377]  [<ffffffff8020a904>] do_notify_resume+0x8c/0x833
[39129.822479]  [<ffffffff8022b175>] ? __wake_up+0x43/0x50
[39129.822581]  [<ffffffff80231ed7>] ? default_wake_function+0x0/0xf
[39129.822685]  [<ffffffff803aac9c>] ? tty_ldisc_deref+0x69/0x6e
[39129.822787]  [<ffffffff803a3f6c>] ? tty_read+0x87/0xba
[39129.822890]  [<ffffffff8029a4e2>] ? vfs_read+0xab/0x154
[39129.822992]  [<ffffffff8020b735>] sysret_signal+0x6d/0xb7
[39129.823094] svscanboot    D 0000000000001158     0  4425      1
[39129.823267]  ffff880072c27d78 0000000000000086 0000000000000000 00000000=
00000000
[39129.823571]  ffffffff8069fdc0 ffffffff8069fdc0 ffff880072c27cf8 ffffffff=
8022b43b
[39129.823875]  ffff880074586000 ffff880074580600 ffff880074586278 00000001=
00000000
[39129.824192] Call Trace:
[39129.824290]  [<ffffffff8022b43b>] ? update_curr+0x53/0xf0
[39129.824393]  [<ffffffff80350cbb>] ? rb_erase+0x1cd/0x2a0
[39129.824495]  [<ffffffff8022b7fc>] ? set_next_entity+0x3b/0x61
[39129.824598]  [<ffffffff8024e7e0>] refrigerator+0xe7/0xf3
[39129.824700]  [<ffffffff802425b8>] get_signal_to_deliver+0x5a/0x3aa
[39129.824802]  [<ffffffff8020a904>] do_notify_resume+0x8c/0x833
[39129.824905]  [<ffffffff804cafbe>] ? preempt_schedule+0x35/0x5c
[39129.825010]  [<ffffffff802493a8>] ? remove_wait_queue+0x3c/0x41
[39129.825131]  [<ffffffff80238ad4>] ? do_wait+0x2d6/0x393
[39129.825234]  [<ffffffff80231ed7>] ? default_wake_function+0x0/0xf
[39129.825343]  [<ffffffff8020b735>] sysret_signal+0x6d/0xb7
[39129.825444] svscan        D 00007fff417c0390     0  4439   4425
[39129.825618]  ffff880073c05d78 0000000000000086 ffff880073c05cc8 ffffffff=
802a1711
[39129.825922]  ffffffff8069fdc0 ffffffff8069fdc0 ffff880073c05d58 ffffffff=
802a3c54
[39129.826226]  ffff880074580600 ffff8800738a5400 ffff880074580878 00000001=
7bb79800
[39129.826530] Call Trace:
[39129.826628]  [<ffffffff802a1711>] ? path_put+0x2c/0x30
[39129.826729]  [<ffffffff802a3c54>] ? __link_path_walk+0xc7d/0xde0
[39129.826832]  [<ffffffff8022b869>] ? dequeue_entity+0x18/0x12c
[39129.826935]  [<ffffffff8024e7e0>] refrigerator+0xe7/0xf3
[39129.827037]  [<ffffffff802425b8>] get_signal_to_deliver+0x5a/0x3aa
[39129.827141]  [<ffffffff8020a904>] do_notify_resume+0x8c/0x833
[39129.827244]  [<ffffffff80250203>] ? getnstimeofday+0x58/0xb4
[39129.827346]  [<ffffffff8024bfc4>] ? ktime_get_ts+0x49/0x4e
[39129.827448]  [<ffffffff8024bfda>] ? ktime_get+0x11/0x42
[39129.827550]  [<ffffffff8024b645>] ? update_rmtp+0x4c/0x61
[39129.827653]  [<ffffffff8024be9b>] ? hrtimer_nanosleep+0xb1/0xff
[39129.827756]  [<ffffffff8024b65a>] ? hrtimer_wakeup+0x0/0x21
[39129.827858]  [<ffffffff8020b735>] sysret_signal+0x6d/0xb7
[39129.827960] readproctitle D 000000000000018f     0  4440   4425
[39129.828146]  ffff880072c19d78 0000000000000082 ffff880072c19cd8 ffffffff=
80249294
[39129.828450]  ffffffff8069fdc0 ffffffff8069fdc0 ffff880075622300 ffff8800=
773f1800
[39129.828754]  ffff880074583600 ffff88007bba6000 ffff880074583878 00000001=
74583600
[39129.829060] Call Trace:
[39129.829179]  [<ffffffff80249294>] ? finish_wait+0x5d/0x65
[39129.829282]  [<ffffffff80249146>] ? autoremove_wake_function+0x0/0x38
[39129.829392]  [<ffffffff802a100d>] ? pipe_read+0x34e/0x3ad
[39129.829494]  [<ffffffff8024e7e0>] refrigerator+0xe7/0xf3
[39129.829595]  [<ffffffff802425b8>] get_signal_to_deliver+0x5a/0x3aa
[39129.829698]  [<ffffffff8020a904>] do_notify_resume+0x8c/0x833
[39129.829801]  [<ffffffff80249146>] ? autoremove_wake_function+0x0/0x38
[39129.829905]  [<ffffffff803321d0>] ? security_file_permission+0x11/0x13
[39129.830009]  [<ffffffff8029a4e2>] ? vfs_read+0xab/0x154
[39129.830111]  [<ffffffff8020b735>] sysret_signal+0x6d/0xb7
[39129.830212] supervise     D 00007fffa4d3a850     0  4441   4439
[39129.830386]  ffff880073909d78 0000000000000082 ffff880073909cc8 ffffffff=
8026d481
[39129.830690]  ffffffff8069fdc0 ffffffff8069fdc0 ffff880073909d58 ffffffff=
8027f145
[39129.830995]  ffff8800738a5400 ffff880074585a00 ffff8800738a5678 00000001=
00000200
[39129.831298] Call Trace:
[39129.831397]  [<ffffffff8026d481>] ? unlock_page+0x22/0x27
[39129.831499]  [<ffffffff8027f145>] ? __do_fault+0x367/0x3ad
[39129.831602]  [<ffffffff802a100d>] ? pipe_read+0x34e/0x3ad
[39129.831704]  [<ffffffff8024e7e0>] refrigerator+0xe7/0xf3
[39129.831806]  [<ffffffff802425b8>] get_signal_to_deliver+0x5a/0x3aa
[39129.831910]  [<ffffffff8020a904>] do_notify_resume+0x8c/0x833
[39129.832026]  [<ffffffff80249146>] ? autoremove_wake_function+0x0/0x38
[39129.832129]  [<ffffffff80238ad4>] ? do_wait+0x2d6/0x393
[39129.832232]  [<ffffffff80250203>] ? getnstimeofday+0x58/0xb4
[39129.832334]  [<ffffffff8024bfc4>] ? ktime_get_ts+0x49/0x4e
[39129.832437]  [<ffffffff802a72d8>] ? poll_select_set_timeout+0x5c/0x77
[39129.832541]  [<ffffffff8020b735>] sysret_signal+0x6d/0xb7
[39129.832642] supervise     D 00007fffcf39aeb0     0  4442   4439
[39129.832816]  ffff880073cf3d78 0000000000000086 ffff880073cf3cc8 ffffffff=
8026d481
[39129.834860]  ffffffff8069fdc0 ffffffff8069fdc0 ffff880073cf3d58 ffffffff=
8027f145
[39129.835164]  ffff8800738a5a00 ffff88007b901e00 ffff8800738a5c78 00000001=
00000200
[39129.835468] Call Trace:
[39129.835567]  [<ffffffff8026d481>] ? unlock_page+0x22/0x27
[39129.835669]  [<ffffffff8027f145>] ? __do_fault+0x367/0x3ad
[39129.835772]  [<ffffffff802a100d>] ? pipe_read+0x34e/0x3ad
[39129.835874]  [<ffffffff8024e7e0>] refrigerator+0xe7/0xf3
[39129.835976]  [<ffffffff802425b8>] get_signal_to_deliver+0x5a/0x3aa
[39129.836093]  [<ffffffff8020a904>] do_notify_resume+0x8c/0x833
[39129.836196]  [<ffffffff80249146>] ? autoremove_wake_function+0x0/0x38
[39129.836299]  [<ffffffff80238ad4>] ? do_wait+0x2d6/0x393
[39129.836402]  [<ffffffff80250203>] ? getnstimeofday+0x58/0xb4
[39129.836504]  [<ffffffff8024bfc4>] ? ktime_get_ts+0x49/0x4e
[39129.836607]  [<ffffffff802a72d8>] ? poll_select_set_timeout+0x5c/0x77
[39129.836711]  [<ffffffff8020b735>] sysret_signal+0x6d/0xb7
[39129.836812] multilog      D 00000000006065c0     0  4443   4442
[39129.836986]  ffff8800738e5d78 0000000000000086 ffff8800738e5cd8 ffffffff=
80249294
[39129.837316]  ffffffff8069fdc0 ffffffff8069fdc0 ffff88007adf5180 ffff8800=
76e1c400
[39129.837620]  ffff880074585a00 ffff880074581800 ffff880074585c78 00000001=
74585a00
[39129.837924] Call Trace:
[39129.838023]  [<ffffffff80249294>] ? finish_wait+0x5d/0x65
[39129.838125]  [<ffffffff80249146>] ? autoremove_wake_function+0x0/0x38
[39129.838229]  [<ffffffff802a100d>] ? pipe_read+0x34e/0x3ad
[39129.838331]  [<ffffffff8024e7e0>] refrigerator+0xe7/0xf3
[39129.838433]  [<ffffffff802425b8>] get_signal_to_deliver+0x5a/0x3aa
[39129.838536]  [<ffffffff8020a904>] do_notify_resume+0x8c/0x833
[39129.838639]  [<ffffffff80249146>] ? autoremove_wake_function+0x0/0x38
[39129.838743]  [<ffffffff802ad09c>] ? notify_change+0x2ca/0x2de
[39129.838846]  [<ffffffff802b01ef>] ? mnt_drop_write+0xa0/0x147
[39129.838949]  [<ffffffff803321d0>] ? security_file_permission+0x11/0x13
[39129.839052]  [<ffffffff8029a4e2>] ? vfs_read+0xab/0x154
[39129.839154]  [<ffffffff8020b735>] sysret_signal+0x6d/0xb7
[39129.839256] dnscache      D 00007fffc5042c50     0  4444   4441
[39129.839428]  ffff880072c2dd78 0000000000000086 ffff880072c2dcd8 ffffffff=
802b01ef
[39129.839732]  ffffffff8069fdc0 ffffffff8069fdc0 ffff880074d40f88 ffff8800=
7557da80
[39129.840055]  ffff880074581800 ffff8800738a5a00 ffff880074581a78 00000001=
1896ba2a
[39129.840359] Call Trace:
[39129.840457]  [<ffffffff802b01ef>] ? mnt_drop_write+0xa0/0x147
[39129.840560]  [<ffffffff802a0cad>] ? pipe_write+0x4ec/0x4fe
[39129.840663]  [<ffffffff8024e7e0>] refrigerator+0xe7/0xf3
[39129.840765]  [<ffffffff802425b8>] get_signal_to_deliver+0x5a/0x3aa
[39129.840867]  [<ffffffff8020a904>] do_notify_resume+0x8c/0x833
[39129.840971]  [<ffffffff80249146>] ? autoremove_wake_function+0x0/0x38
[39129.841076]  [<ffffffff802a8c0e>] ? d_free+0x32/0x49
[39129.841197]  [<ffffffff80250203>] ? getnstimeofday+0x58/0xb4
[39129.841300]  [<ffffffff8024bfc4>] ? ktime_get_ts+0x49/0x4e
[39129.841408]  [<ffffffff802a72d8>] ? poll_select_set_timeout+0x5c/0x77
[39129.841511]  [<ffffffff8020b735>] sysret_signal+0x6d/0xb7
[39129.841613] zsh           D 0000000000000000     0  4513   4415
[39129.841786]  ffff8800738f3d78 0000000000000082 0000000000000000 ffffffff=
8027546e
[39129.842090]  ffffffff8069fdc0 ffffffff8069fdc0 ffff8800738f3ce8 ffffffff=
80227295
[39129.842394]  ffff880074586600 ffff8800738a1e00 ffff880074586878 00000001=
8027f986
[39129.842699] Call Trace:
[39129.842797]  [<ffffffff8027546e>] ? __lru_cache_add+0x70/0x98
[39129.842900]  [<ffffffff80227295>] ? ptep_set_access_flags+0x22/0x28
[39129.843003]  [<ffffffff80249146>] ? autoremove_wake_function+0x0/0x38
[39129.843107]  [<ffffffff8024e7e0>] refrigerator+0xe7/0xf3
[39129.843209]  [<ffffffff802425b8>] get_signal_to_deliver+0x5a/0x3aa
[39129.843312]  [<ffffffff8022b43b>] ? update_curr+0x53/0xf0
[39129.843414]  [<ffffffff8020a904>] do_notify_resume+0x8c/0x833
[39129.843517]  [<ffffffff8022b7fc>] ? set_next_entity+0x3b/0x61
[39129.843619]  [<ffffffff8022ff17>] ? finish_task_switch+0x2b/0x8e
[39129.843722]  [<ffffffff804cad4c>] ? thread_return+0x3d/0xda
[39129.843825]  [<ffffffff802af502>] ? mntput_no_expire+0x2a/0x14d
[39129.843928]  [<ffffffff8023f872>] ? sigprocmask+0xc6/0xd0
[39129.844043]  [<ffffffff8020b735>] sysret_signal+0x6d/0xb7
[39129.844144] startx        D 0000000000001242     0  4656   4513
[39129.844318]  ffff880073d31d78 0000000000000082 0000000000000000 ffffffff=
8027546e
[39129.844621]  ffffffff8069fdc0 ffffffff8069fdc0 ffff880073d31cf8 ffffffff=
8022b43b
[39129.844925]  ffff880074582400 ffff880074584800 ffff880074582678 00000001=
00000000
[39129.845255] Call Trace:
[39129.845353]  [<ffffffff8027546e>] ? __lru_cache_add+0x70/0x98
[39129.845456]  [<ffffffff8022b43b>] ? update_curr+0x53/0xf0
[39129.845558]  [<ffffffff80350c3d>] ? rb_erase+0x14f/0x2a0
[39129.845661]  [<ffffffff8022b7fc>] ? set_next_entity+0x3b/0x61
[39129.845764]  [<ffffffff8024e7e0>] refrigerator+0xe7/0xf3
[39129.845866]  [<ffffffff802425b8>] get_signal_to_deliver+0x5a/0x3aa
[39129.845969]  [<ffffffff8020a904>] do_notify_resume+0x8c/0x833
[39129.846072]  [<ffffffff804cafbe>] ? preempt_schedule+0x35/0x5c
[39129.846175]  [<ffffffff802493a8>] ? remove_wait_queue+0x3c/0x41
[39129.846278]  [<ffffffff80238ad4>] ? do_wait+0x2d6/0x393
[39129.846380]  [<ffffffff80231ed7>] ? default_wake_function+0x0/0xf
[39129.846484]  [<ffffffff8020b735>] sysret_signal+0x6d/0xb7
[39129.846585] xinit         D 00007fff46856538     0  4674   4656
[39129.846758]  ffff880073987d78 0000000000000086 ffff880001025dc0 ffff8800=
73987ce0
[39129.847062]  ffffffff8069fdc0 ffffffff8069fdc0 ffff880073987cf8 ffffffff=
8022b43b
[39129.847365]  ffff880074584800 ffff88007b901200 ffff880074584a78 00000001=
00000000
[39129.847669] Call Trace:
[39129.847767]  [<ffffffff8022b43b>] ? update_curr+0x53/0xf0
[39129.847869]  [<ffffffff8022b7fc>] ? set_next_entity+0x3b/0x61
[39129.847972]  [<ffffffff8024e7e0>] refrigerator+0xe7/0xf3
[39129.848088]  [<ffffffff802425b8>] get_signal_to_deliver+0x5a/0x3aa
[39129.848191]  [<ffffffff8020a904>] do_notify_resume+0x8c/0x833
[39129.848294]  [<ffffffff804ca346>] ? wait_for_common+0x116/0x131
[39129.848398]  [<ffffffff80231ed7>] ? default_wake_function+0x0/0xf
[39129.848501]  [<ffffffff802493a8>] ? remove_wait_queue+0x3c/0x41
[39129.848604]  [<ffffffff80238ad4>] ? do_wait+0x2d6/0x393
[39129.848707]  [<ffffffff80231ed7>] ? default_wake_function+0x0/0xf
[39129.848810]  [<ffffffff8020b735>] sysret_signal+0x6d/0xb7
[39129.848912] Xorg          D 00000000007d2340     0  4675   4674
[39129.849088]  ffff880073989d78 0000000000000082 ffff880073989ce8 ffff8800=
74583278
[39129.849416]  ffffffff8069fdc0 ffffffff8069fdc0 0000000000000000 00000000=
00000001
[39129.849719]  ffff880074583000 ffff88005b9c2400 ffff880074583278 00000000=
8024c80c
[39129.850024] Call Trace:
[39129.850122]  [<ffffffff804cafbe>] ? preempt_schedule+0x35/0x5c
[39129.850225]  [<ffffffff804ccb18>] ? unlock_kernel+0x4f/0x51
[39129.850327]  [<ffffffff8024e7e0>] refrigerator+0xe7/0xf3
[39129.850429]  [<ffffffff802425b8>] get_signal_to_deliver+0x5a/0x3aa
[39129.850533]  [<ffffffff80440f14>] ? pci_conf1_read+0xd2/0xe2
[39129.850636]  [<ffffffff8020a904>] do_notify_resume+0x8c/0x833
[39129.850738]  [<ffffffff803a60d0>] ? tty_ioctl+0x778/0x7df
[39129.850841]  [<ffffffff802a63a4>] ? vfs_ioctl+0x2a/0x78
[39129.850943]  [<ffffffff802a6838>] ? do_vfs_ioctl+0x446/0x482
[39129.851045]  [<ffffffff8020b735>] sysret_signal+0x6d/0xb7
[39129.851148] awesome       D 0000000000000005     0  4724   4674
[39129.851321]  ffff880064d23d78 0000000000000086 0000000000000000 00000000=
00000000
[39129.851626]  ffffffff8069fdc0 ffffffff8069fdc0 0000000000000000 ffff8800=
00000040
[39129.851930]  ffff880074587200 ffff88005b9c2400 ffff880074587478 00000000=
00001000
[39129.852246] Call Trace:
[39129.852345]  [<ffffffff8024e7e0>] refrigerator+0xe7/0xf3
[39129.852446]  [<ffffffff802425b8>] get_signal_to_deliver+0x5a/0x3aa
[39129.852550]  [<ffffffff8020a904>] do_notify_resume+0x8c/0x833
[39129.852653]  [<ffffffff80249146>] ? autoremove_wake_function+0x0/0x38
[39129.852757]  [<ffffffff802a8467>] ? sys_select+0xa7/0xbc
[39129.852859]  [<ffffffff8020b735>] sysret_signal+0x6d/0xb7
[39129.852960] xbindkeys     D 00007fff500a58e0     0  4738      1
[39129.853153]  ffff880073981d78 0000000000000086 ffff880073981cc8 ffffffff=
802a1711
[39129.853463]  ffffffff8069fdc0 ffffffff8069fdc0 ffff880073981d58 ffffffff=
802a3d9b
[39129.853766]  ffff880074580c00 ffff88005b9c2400 ffff880074580e78 00000000=
7bb79800
[39129.854071] Call Trace:
[39129.854169]  [<ffffffff802a1711>] ? path_put+0x2c/0x30
[39129.854271]  [<ffffffff802a3d9b>] ? __link_path_walk+0xdc4/0xde0
[39129.854374]  [<ffffffff8024e7e0>] refrigerator+0xe7/0xf3
[39129.854476]  [<ffffffff802425b8>] get_signal_to_deliver+0x5a/0x3aa
[39129.854579]  [<ffffffff8020a904>] do_notify_resume+0x8c/0x833
[39129.854683]  [<ffffffff8029d0c3>] ? cp_new_stat+0xe2/0xef
[39129.854785]  [<ffffffff802af502>] ? mntput_no_expire+0x2a/0x14d
[39129.854889]  [<ffffffff802a8467>] ? sys_select+0xa7/0xbc
[39129.854990]  [<ffffffff8020b735>] sysret_signal+0x6d/0xb7
[39129.855092] gconfd-2      D 00000000008e39c0     0  4741      1
[39129.855266]  ffff88007295bd78 0000000000000082 0000000000000000 ffff8800=
7295bb98
[39129.855569]  ffffffff8069fdc0 ffffffff8069fdc0 0000000000200200 ffff8800=
64848f30
[39129.855873]  ffff880074587800 ffff88005b9c2400 ffff880074587a78 00000000=
802a8546
[39129.856191] Call Trace:
[39129.856289]  [<ffffffff802a8546>] ? pollwake+0x0/0x4e
[39129.856391]  [<ffffffff8024e7e0>] refrigerator+0xe7/0xf3
[39129.856493]  [<ffffffff802425b8>] get_signal_to_deliver+0x5a/0x3aa
[39129.856596]  [<ffffffff8020a904>] do_notify_resume+0x8c/0x833
[39129.856699]  [<ffffffff8029a026>] ? do_readv_writev+0x17e/0x193
[39129.856801]  [<ffffffff804cad4c>] ? thread_return+0x3d/0xda
[39129.856904]  [<ffffffff80250203>] ? getnstimeofday+0x58/0xb4
[39129.858721]  [<ffffffff8024bfc4>] ? ktime_get_ts+0x49/0x4e
[39129.858845]  [<ffffffff802a72d8>] ? poll_select_set_timeout+0x5c/0x77
[39129.858948]  [<ffffffff8020b735>] sysret_signal+0x6d/0xb7
[39129.859056] dbus-launch   D 0000000000000000     0  4746      1
[39129.859229]  ffff880062167d78 0000000000000082 0000000000000000 00000000=
00000000
[39129.859533]  ffffffff8069fdc0 ffffffff8069fdc0 ffff880062167d58 ffffffff=
8027f145
[39129.859836]  ffff88007b901200 ffff88007b896c00 ffff88007b901478 00000001=
00001000
[39129.860153] Call Trace:
[39129.860251]  [<ffffffff8027f145>] ? __do_fault+0x367/0x3ad
[39129.860354]  [<ffffffff8024e7e0>] refrigerator+0xe7/0xf3
[39129.860456]  [<ffffffff802425b8>] get_signal_to_deliver+0x5a/0x3aa
[39129.860559]  [<ffffffff8020a904>] do_notify_resume+0x8c/0x833
[39129.860662]  [<ffffffff80249146>] ? autoremove_wake_function+0x0/0x38
[39129.860766]  [<ffffffff802a8467>] ? sys_select+0xa7/0xbc
[39129.860868]  [<ffffffff8020b735>] sysret_signal+0x6d/0xb7
[39129.860969] dbus-daemon   D 00007ffbdd904490     0  4747      1
[39129.861162]  ffff880062169d78 0000000000000086 0000000000000000 ffff8800=
62169b98
[39129.861472]  ffffffff8069fdc0 ffffffff8069fdc0 0000000000200200 ffff8800=
783c5430
[39129.861776]  ffff8800738a6000 ffff88005b9c2400 ffff8800738a6278 00000000=
00000800
[39129.862079] Call Trace:
[39129.862177]  [<ffffffff80446db9>] ? sock_aio_read+0x146/0x15a
[39129.862280]  [<ffffffff8024e7e0>] refrigerator+0xe7/0xf3
[39129.862382]  [<ffffffff802425b8>] get_signal_to_deliver+0x5a/0x3aa
[39129.862485]  [<ffffffff8020a904>] do_notify_resume+0x8c/0x833
[39129.862588]  [<ffffffff80249146>] ? autoremove_wake_function+0x0/0x38
[39129.862691]  [<ffffffff803321d0>] ? security_file_permission+0x11/0x13
[39129.862795]  [<ffffffff8020b735>] sysret_signal+0x6d/0xb7
[39129.862896] gnome-screens D 000000000067a190     0  4748      1
[39129.863069]  ffff880062105d78 0000000000000082 0000000000000000 ffff8800=
62105b98
[39129.863373]  ffffffff8069fdc0 ffffffff8069fdc0 0000000000200200 ffff8800=
64848a30
[39129.863676]  ffff88007b903600 ffff88005b9c2400 ffff88007b903878 00000000=
802a8546
[39129.863980] Call Trace:
[39129.864091]  [<ffffffff802a8546>] ? pollwake+0x0/0x4e
[39129.864193]  [<ffffffff8024e7e0>] refrigerator+0xe7/0xf3
[39129.864295]  [<ffffffff802425b8>] get_signal_to_deliver+0x5a/0x3aa
[39129.864398]  [<ffffffff8020a904>] do_notify_resume+0x8c/0x833
[39129.864502]  [<ffffffff80249146>] ? autoremove_wake_function+0x0/0x38
[39129.864605]  [<ffffffff804cad4c>] ? thread_return+0x3d/0xda
[39129.864707]  [<ffffffff80250203>] ? getnstimeofday+0x58/0xb4
[39129.864809]  [<ffffffff8024bfc4>] ? ktime_get_ts+0x49/0x4e
[39129.864912]  [<ffffffff802a72d8>] ? poll_select_set_timeout+0x5c/0x77
[39129.865017]  [<ffffffff8020b735>] sysret_signal+0x6d/0xb7
[39129.865137] urxvtd        D 0000000000000000     0  4754      1
[39129.865316]  ffff880064cefd78 0000000000000086 ffff880001019dc0 00000000=
0000000e
[39129.865620]  ffffffff8069fdc0 ffffffff8069fdc0 0000000000000000 ffff8800=
01019e30
[39129.865923]  ffff88007b895a00 ffff88005b9c2400 ffff88007b895c78 00000000=
8022bca1
[39129.866227] Call Trace:
[39129.866325]  [<ffffffff80209f5a>] ? __switch_to+0x35e/0x36e
[39129.866427]  [<ffffffff8022acbd>] ? dequeue_task+0xad/0xb8
[39129.866530]  [<ffffffff8022ff17>] ? finish_task_switch+0x2b/0x8e
[39129.866633]  [<ffffffff8024e7e0>] refrigerator+0xe7/0xf3
[39129.866734]  [<ffffffff802425b8>] get_signal_to_deliver+0x5a/0x3aa
[39129.866837]  [<ffffffff8020a904>] do_notify_resume+0x8c/0x833
[39129.866940]  [<ffffffff8023ef02>] ? del_timer_sync+0x14/0x20
[39129.867042]  [<ffffffff804cb0ac>] ? schedule_timeout+0xb3/0xcf
[39129.867145]  [<ffffffff8023eb1e>] ? process_timeout+0x0/0xb
[39129.867247]  [<ffffffff802c339b>] ? sys_epoll_wait+0x464/0x47c
[39129.867350]  [<ffffffff80231ed7>] ? default_wake_function+0x0/0xf
[39129.867453]  [<ffffffff8020b735>] sysret_signal+0x6d/0xb7
[39129.867555] zsh           D 0000000000000000     0  4760   4754
[39129.867728]  ffff880064cd9d78 0000000000000082 0000000000000000 ffffffff=
8027546e
[39129.868044]  ffffffff8069fdc0 ffffffff8069fdc0 ffff880064cd9ce8 ffffffff=
80227295
[39129.868348]  ffff8800738a2a00 ffff8800738a7200 ffff8800738a2c78 00000001=
8027f986
[39129.868651] Call Trace:
[39129.868749]  [<ffffffff8027546e>] ? __lru_cache_add+0x70/0x98
[39129.868852]  [<ffffffff80227295>] ? ptep_set_access_flags+0x22/0x28
[39129.868956]  [<ffffffff8024e7e0>] refrigerator+0xe7/0xf3
[39129.869059]  [<ffffffff802425b8>] get_signal_to_deliver+0x5a/0x3aa
[39129.869181]  [<ffffffff8022b43b>] ? update_curr+0x53/0xf0
[39129.869283]  [<ffffffff8020a904>] do_notify_resume+0x8c/0x833
[39129.869392]  [<ffffffff8022b7fc>] ? set_next_entity+0x3b/0x61
[39129.869495]  [<ffffffff8022ff17>] ? finish_task_switch+0x2b/0x8e
[39129.869598]  [<ffffffff804cad4c>] ? thread_return+0x3d/0xda
[39129.869700]  [<ffffffff802af502>] ? mntput_no_expire+0x2a/0x14d
[39129.869804]  [<ffffffff8023f872>] ? sigprocmask+0xc6/0xd0
[39129.869906]  [<ffffffff8020b735>] sysret_signal+0x6d/0xb7
[39129.870007] ressh.sh      D 0000000000001330     0  4911   4760
[39129.870180]  ffff880064cd3d78 0000000000000082 0000000000000000 ffffffff=
8026d481
[39129.870483]  ffffffff8069fdc0 ffffffff8069fdc0 ffff880064cd3cf8 ffffffff=
8022b43b
[39129.870787]  ffff8800738a7200 ffff8800795dce00 ffff8800738a7478 00000001=
00000000
[39129.871091] Call Trace:
[39129.871189]  [<ffffffff8026d481>] ? unlock_page+0x22/0x27
[39129.871291]  [<ffffffff8022b43b>] ? update_curr+0x53/0xf0
[39129.871393]  [<ffffffff8022b7fc>] ? set_next_entity+0x3b/0x61
[39129.871496]  [<ffffffff8024e7e0>] refrigerator+0xe7/0xf3
[39129.871598]  [<ffffffff802425b8>] get_signal_to_deliver+0x5a/0x3aa
[39129.871701]  [<ffffffff8020a904>] do_notify_resume+0x8c/0x833
[39129.871804]  [<ffffffff8021c04e>] ? native_smp_send_reschedule+0x50/0x52
[39129.871909]  [<ffffffff8022a5d7>] ? resched_task+0x67/0x69
[39129.872024]  [<ffffffff802493a8>] ? remove_wait_queue+0x3c/0x41
[39129.872127]  [<ffffffff80238ad4>] ? do_wait+0x2d6/0x393
[39129.872229]  [<ffffffff80231ed7>] ? default_wake_function+0x0/0xf
[39129.872332]  [<ffffffff8020b735>] sysret_signal+0x6d/0xb7
[39129.872433] ssh           D 0000000000000000     0  4912   4911
[39129.872606]  ffff880073de9d78 0000000000000082 ffff880073de9df8 ffffffff=
803a951f
[39129.872910]  ffffffff8069fdc0 ffffffff8069fdc0 ffff8800648cb680 ffff8800=
73de9d60
[39129.873237]  ffff88007b954200 ffff88005b9c2400 ffff88007b954478 00000000=
648cb680
[39129.873547] Call Trace:
[39129.873646]  [<ffffffff803a951f>] ? n_tty_receive_buf+0xe38/0xe8c
[39129.873749]  [<ffffffff8024e7e0>] refrigerator+0xe7/0xf3
[39129.873851]  [<ffffffff802425b8>] get_signal_to_deliver+0x5a/0x3aa
[39129.873954]  [<ffffffff8020a904>] do_notify_resume+0x8c/0x833
[39129.874057]  [<ffffffff8022b175>] ? __wake_up+0x43/0x50
[39129.874159]  [<ffffffff803aac9c>] ? tty_ldisc_deref+0x69/0x6e
[39129.874262]  [<ffffffff802a8467>] ? sys_select+0xa7/0xbc
[39129.874364]  [<ffffffff8020b735>] sysret_signal+0x6d/0xb7
[39129.874465] firefox-bin   D 00007fc8502039e0     0  5078      1
[39129.874640]  ffff880060469d78 0000000000000082 0000000000000000 ffff8800=
60469b98
[39129.874944]  ffffffff8069fdc0 ffffffff8069fdc0 0000000000200200 ffff8800=
5fd02030
[39129.875248]  ffff8800738a0c00 ffff88007c062400 ffff8800738a0e78 00000001=
802a8546
[39129.875552] Call Trace:
[39129.875651]  [<ffffffff802a8546>] ? pollwake+0x0/0x4e
[39129.875752]  [<ffffffff8024e7e0>] refrigerator+0xe7/0xf3
[39129.875854]  [<ffffffff802425b8>] get_signal_to_deliver+0x5a/0x3aa
[39129.875957]  [<ffffffff8020a904>] do_notify_resume+0x8c/0x833
[39129.876073]  [<ffffffff80249146>] ? autoremove_wake_function+0x0/0x38
[39129.876177]  [<ffffffff804cad4c>] ? thread_return+0x3d/0xda
[39129.876279]  [<ffffffff80250203>] ? getnstimeofday+0x58/0xb4
[39129.876382]  [<ffffffff8024bfc4>] ? ktime_get_ts+0x49/0x4e
[39129.876485]  [<ffffffff802a72d8>] ? poll_select_set_timeout+0x5c/0x77
[39129.876588]  [<ffffffff8020b735>] sysret_signal+0x6d/0xb7
[39129.876689] firefox-bin   D 0000000000000001     0  5082      1
[39129.876863]  ffff880060233d78 0000000000000082 ffff880060233ca0 ffff8800=
60233cb0
[39129.877189]  ffffffff8069fdc0 ffffffff8069fdc0 ffff880060233d90 ffff8800=
60233d90
[39129.877499]  ffff8800795dce00 ffff88007b896600 ffff8800795dd078 00000001=
00000540
[39129.877802] Call Trace:
[39129.877900]  [<ffffffff802a1056>] ? pipe_read+0x397/0x3ad
[39129.878003]  [<ffffffff8024e7e0>] refrigerator+0xe7/0xf3
[39129.878104]  [<ffffffff802425b8>] get_signal_to_deliver+0x5a/0x3aa
[39129.878208]  [<ffffffff8020a904>] do_notify_resume+0x8c/0x833
[39129.878311]  [<ffffffff80249146>] ? autoremove_wake_function+0x0/0x38
[39129.878414]  [<ffffffff8022ac05>] ? enqueue_task+0x59/0x64
[39129.878517]  [<ffffffff80230d02>] ? __sched_setscheduler+0x2ef/0x30e
[39129.878621]  [<ffffffff80256342>] ? sys_futex+0xf8/0x116
[39129.878723]  [<ffffffff8020b735>] sysret_signal+0x6d/0xb7
[39129.878824] firefox-bin   D 00000000416e1fe0     0  5084      1
[39129.878997]  ffff8800601afd78 0000000000000082 ffff8800601afca0 ffff8800=
601afcb0
[39129.879301]  ffffffff8069fdc0 ffffffff8069fdc0 ffff8800601afd90 ffff8800=
601afd90
[39129.879605]  ffff88007b896600 ffff880021837800 ffff88007b896878 00000001=
0000050c
[39129.879908] Call Trace:
[39129.880019]  [<ffffffff8024b65a>] ? hrtimer_wakeup+0x0/0x21
[39129.880122]  [<ffffffff8024e7e0>] refrigerator+0xe7/0xf3
[39129.880224]  [<ffffffff802425b8>] get_signal_to_deliver+0x5a/0x3aa
[39129.880327]  [<ffffffff8020a904>] do_notify_resume+0x8c/0x833
[39129.880430]  [<ffffffff80249146>] ? autoremove_wake_function+0x0/0x38
[39129.880534]  [<ffffffff80250203>] ? getnstimeofday+0x58/0xb4
[39129.880636]  [<ffffffff8024bfc4>] ? ktime_get_ts+0x49/0x4e
[39129.880738]  [<ffffffff80256342>] ? sys_futex+0xf8/0x116
[39129.880840]  [<ffffffff8020b735>] sysret_signal+0x6d/0xb7
[39129.880941] firefox-bin   D 0000000000000005     0  5104      1
[39129.882840]  ffff880072c4bd78 0000000000000082 ffff880072c4bca0 ffff8800=
72c4bcb0
[39129.883144]  ffffffff8069fdc0 ffffffff8069fdc0 ffff880072c4bd90 ffff8800=
72c4bd90
[39129.883448]  ffff88007c067200 ffff88007c062400 ffff88007c067478 00000001=
0000030c
[39129.883751] Call Trace:
[39129.883849]  [<ffffffff802a0cad>] ? pipe_write+0x4ec/0x4fe
[39129.883951]  [<ffffffff8024e7e0>] refrigerator+0xe7/0xf3
[39129.884066]  [<ffffffff802425b8>] get_signal_to_deliver+0x5a/0x3aa
[39129.884170]  [<ffffffff8020a904>] do_notify_resume+0x8c/0x833
[39129.884273]  [<ffffffff80249146>] ? autoremove_wake_function+0x0/0x38
[39129.884376]  [<ffffffff802a8c0e>] ? d_free+0x32/0x49
[39129.884478]  [<ffffffff80256342>] ? sys_futex+0xf8/0x116
[39129.884580]  [<ffffffff8020b735>] sysret_signal+0x6d/0xb7
[39129.884681] firefox-bin   D 0000000002dcd4e8     0  5105      1
[39129.884854]  ffff88007ad83d78 0000000000000082 ffff88007ad83ca0 ffff8800=
7ad83cb0
[39129.885181]  ffffffff8069fdc0 ffffffff8069fdc0 ffff88007ad83d90 ffff8800=
7ad83d90
[39129.885491]  ffff88007b957200 ffff88007c067200 ffff88007b957478 00000001=
0000060c
[39129.885794] Call Trace:
[39129.885893]  [<ffffffff8023fdb5>] ? __sigqueue_free+0x3c/0x41
[39129.885995]  [<ffffffff80240a6b>] ? __dequeue_signal+0x103/0x12f
[39129.886099]  [<ffffffff8024e7e0>] refrigerator+0xe7/0xf3
[39129.886201]  [<ffffffff802425b8>] get_signal_to_deliver+0x5a/0x3aa
[39129.886304]  [<ffffffff8020a904>] do_notify_resume+0x8c/0x833
[39129.886407]  [<ffffffff80212394>] ? restore_i387_xstate+0x6a/0x14e
[39129.886510]  [<ffffffff8022bd36>] ? enqueue_task_fair+0x22/0x8c
[39129.886613]  [<ffffffff8020b3a5>] ? sys_rt_sigreturn+0x2e6/0x341
[39129.886716]  [<ffffffff80256342>] ? sys_futex+0xf8/0x116
[39129.886817]  [<ffffffff8020b735>] sysret_signal+0x6d/0xb7
[39129.886919] firefox-bin   D 0000000041ee3950     0  5106      1
[39129.887092]  ffff8800601e9d78 0000000000000082 ffff8800601e9ca0 ffff8800=
601e9cb0
[39129.887395]  ffffffff8069fdc0 ffffffff8069fdc0 ffff8800601e9d90 ffff8800=
601e9d90
[39129.887699]  ffff88007bba6c00 ffff88007b957200 ffff88007bba6e78 00000001=
00000c9c
[39129.888016] Call Trace:
[39129.888114]  [<ffffffff8024e7e0>] refrigerator+0xe7/0xf3
[39129.888216]  [<ffffffff802425b8>] get_signal_to_deliver+0x5a/0x3aa
[39129.888320]  [<ffffffff8020a904>] do_notify_resume+0x8c/0x833
[39129.888423]  [<ffffffff802c84de>] ? __posix_lock_file+0x4bb/0x4ec
[39129.888526]  [<ffffffff802c7d96>] ? locks_free_lock+0x4a/0x4e
[39129.888629]  [<ffffffff802c8890>] ? fcntl_setlk+0x28c/0x2a0
[39129.888731]  [<ffffffff80256342>] ? sys_futex+0xf8/0x116
[39129.888833]  [<ffffffff8020b735>] sysret_signal+0x6d/0xb7
[39129.888935] firefox-bin   D 0000000000000001     0 17835      1
[39129.889130]  ffff88003ec1fd78 0000000000000082 0000000000000001 00000000=
00000001
[39129.889439]  ffffffff8069fdc0 ffffffff8069fdc0 ffff88007c355f00 ffff8800=
386d86a8
[39129.889743]  ffff880032ca0000 ffff88007bba6c00 ffff880032ca0278 00000001=
802ab624
[39129.890048] Call Trace:
[39129.890146]  [<ffffffff802a1056>] ? pipe_read+0x397/0x3ad
[39129.890248]  [<ffffffff8024e7e0>] refrigerator+0xe7/0xf3
[39129.890350]  [<ffffffff802425b8>] get_signal_to_deliver+0x5a/0x3aa
[39129.890453]  [<ffffffff8020a904>] do_notify_resume+0x8c/0x833
[39129.890557]  [<ffffffff802493a8>] ? remove_wait_queue+0x3c/0x41
[39129.890660]  [<ffffffff80238ad4>] ? do_wait+0x2d6/0x393
[39129.890762]  [<ffffffff80231ed7>] ? default_wake_function+0x0/0xf
[39129.890865]  [<ffffffff8020b735>] sysret_signal+0x6d/0xb7
[39129.890967] firefox-bin   D 0000000000000000     0 23150      1
[39129.891140]  ffff880029889d78 0000000000000082 ffff880029889e48 ffffffff=
80447690
[39129.891444]  ffffffff8069fdc0 ffffffff8069fdc0 0000000000000000 ffffffff=
00000001
[39129.891748]  ffff880021837800 ffff880021834200 ffff880021837a78 00000001=
00000000
[39129.892065] Call Trace:
[39129.892164]  [<ffffffff80447690>] ? sock_sendmsg+0xfd/0x120
[39129.892267]  [<ffffffff80249146>] ? autoremove_wake_function+0x0/0x38
[39129.892371]  [<ffffffff8024e7e0>] refrigerator+0xe7/0xf3
[39129.892473]  [<ffffffff802425b8>] get_signal_to_deliver+0x5a/0x3aa
[39129.892577]  [<ffffffff8047390f>] ? ip_route_output_flow+0x7d/0x201
[39129.892681]  [<ffffffff8020a904>] do_notify_resume+0x8c/0x833
[39129.892784]  [<ffffffff804479e0>] ? sys_sendto+0xf1/0x107
[39129.892886]  [<ffffffff8049dce2>] ? inet_dgram_connect+0x58/0x65
[39129.892990]  [<ffffffff80250203>] ? getnstimeofday+0x58/0xb4
[39129.893093]  [<ffffffff8024bfc4>] ? ktime_get_ts+0x49/0x4e
[39129.893215]  [<ffffffff802a72d8>] ? poll_select_set_timeout+0x5c/0x77
[39129.893318]  [<ffffffff8020b735>] sysret_signal+0x6d/0xb7
[39129.893425] firefox-bin   D 0000000000000000     0 23151      1
[39129.893599]  ffff880072d37d78 0000000000000082 ffff880072d37e48 ffffffff=
80447690
[39129.893902]  ffffffff8069fdc0 ffffffff8069fdc0 0000000000000000 ffffffff=
00000001
[39129.894206]  ffff880021834200 ffff8800738a0c00 ffff880021834478 00000001=
00000000
[39129.894509] Call Trace:
[39129.894607]  [<ffffffff80447690>] ? sock_sendmsg+0xfd/0x120
[39129.894710]  [<ffffffff80249146>] ? autoremove_wake_function+0x0/0x38
[39129.894814]  [<ffffffff8024e7e0>] refrigerator+0xe7/0xf3
[39129.894916]  [<ffffffff802425b8>] get_signal_to_deliver+0x5a/0x3aa
[39129.895019]  [<ffffffff8047390f>] ? ip_route_output_flow+0x7d/0x201
[39129.895122]  [<ffffffff8020a904>] do_notify_resume+0x8c/0x833
[39129.895225]  [<ffffffff804479e0>] ? sys_sendto+0xf1/0x107
[39129.895327]  [<ffffffff8049dce2>] ? inet_dgram_connect+0x58/0x65
[39129.895430]  [<ffffffff80250203>] ? getnstimeofday+0x58/0xb4
[39129.895532]  [<ffffffff8024bfc4>] ? ktime_get_ts+0x49/0x4e
[39129.895635]  [<ffffffff802a72d8>] ? poll_select_set_timeout+0x5c/0x77
[39129.895738]  [<ffffffff8020b735>] sysret_signal+0x6d/0xb7
[39129.895839] firefox-bin   D 0000000000000000     0 23152      1
[39129.896026]  ffff880020d47d78 0000000000000082 ffff880020d47e48 ffffffff=
80447690
[39129.896329]  ffffffff8069fdc0 ffffffff8069fdc0 0000000000000000 ffffffff=
00000001
[39129.896633]  ffff880021830000 ffff880074586600 ffff880021830278 00000001=
00000000
[39129.896937] Call Trace:
[39129.897037]  [<ffffffff80447690>] ? sock_sendmsg+0xfd/0x120
[39129.897158]  [<ffffffff80249146>] ? autoremove_wake_function+0x0/0x38
[39129.897262]  [<ffffffff8024e7e0>] refrigerator+0xe7/0xf3
[39129.897370]  [<ffffffff802425b8>] get_signal_to_deliver+0x5a/0x3aa
[39129.897474]  [<ffffffff8047390f>] ? ip_route_output_flow+0x7d/0x201
[39129.897577]  [<ffffffff8020a904>] do_notify_resume+0x8c/0x833
[39129.897680]  [<ffffffff804479e0>] ? sys_sendto+0xf1/0x107
[39129.897782]  [<ffffffff8049dce2>] ? inet_dgram_connect+0x58/0x65
[39129.897885]  [<ffffffff80250203>] ? getnstimeofday+0x58/0xb4
[39129.897988]  [<ffffffff8024bfc4>] ? ktime_get_ts+0x49/0x4e
[39129.898090]  [<ffffffff802a72d8>] ? poll_select_set_timeout+0x5c/0x77
[39129.898194]  [<ffffffff8020b735>] sysret_signal+0x6d/0xb7
[39129.898295] ssh           D 0000000000000000     0  5226      1
[39129.898469]  ffff880060575d78 0000000000000082 0000000000000040 ffff8800=
60575d60
[39129.898773]  ffffffff8069fdc0 ffffffff8069fdc0 ffff88005ffeb680 ffff8800=
60575d60
[39129.899077]  ffff88005b9c1200 ffff880032ca0000 ffff88005b9c1478 00000001=
5ffeb680
[39129.899381] Call Trace:
[39129.899480]  [<ffffffff8024e7e0>] refrigerator+0xe7/0xf3
[39129.899582]  [<ffffffff802425b8>] get_signal_to_deliver+0x5a/0x3aa
[39129.899685]  [<ffffffff8020a904>] do_notify_resume+0x8c/0x833
[39129.899788]  [<ffffffff802a8bd8>] ? __d_free+0x4f/0x53
[39129.899890]  [<ffffffff802a8c0e>] ? d_free+0x32/0x49
[39129.899991]  [<ffffffff802af502>] ? mntput_no_expire+0x2a/0x14d
[39129.900108]  [<ffffffff802a8467>] ? sys_select+0xa7/0xbc
[39129.900209]  [<ffffffff8020b735>] sysret_signal+0x6d/0xb7
[39129.900311] ssh           D 0000000000000000     0  5228      1
[39129.900484]  ffff880072df7d78 0000000000000086 0000000000000040 00007f62=
d26280f0
[39129.900788]  ffffffff8069fdc0 ffffffff8069fdc0 0000000000000000 00000000=
00000000
[39129.901120]  ffff8800738a4e00 ffff88005b9c1200 ffff8800738a5078 00000001=
5ffeb180
[39129.901436] Call Trace:
[39129.901535]  [<ffffffff8024e7e0>] refrigerator+0xe7/0xf3
[39129.901637]  [<ffffffff802425b8>] get_signal_to_deliver+0x5a/0x3aa
[39129.901741]  [<ffffffff8020a904>] do_notify_resume+0x8c/0x833
[39129.901844]  [<ffffffff80249146>] ? autoremove_wake_function+0x0/0x38
[39129.901947]  [<ffffffff804ccd1f>] ? page_fault+0x1f/0x30
[39129.902049]  [<ffffffff802a8467>] ? sys_select+0xa7/0xbc
[39129.902151]  [<ffffffff8020b735>] sysret_signal+0x6d/0xb7
[39129.902253] ssh           D 0000000000000000     0  5230      1
[39129.902426]  ffff8800620a9d78 0000000000000082 ffff8800620a9cc8 ffffffff=
8026d481
[39129.902731]  ffffffff8069fdc0 ffffffff8069fdc0 ffff8800620a9d58 ffffffff=
8027f145
[39129.903035]  ffff8800738a4800 ffff8800738a4e00 ffff8800738a4a78 00000001=
00000200
[39129.903339] Call Trace:
[39129.903437]  [<ffffffff8026d481>] ? unlock_page+0x22/0x27
[39129.903540]  [<ffffffff8027f145>] ? __do_fault+0x367/0x3ad
[39129.903643]  [<ffffffff8024e7e0>] refrigerator+0xe7/0xf3
[39129.903745]  [<ffffffff802425b8>] get_signal_to_deliver+0x5a/0x3aa
[39129.903848]  [<ffffffff8020a904>] do_notify_resume+0x8c/0x833
[39129.903951]  [<ffffffff80249146>] ? autoremove_wake_function+0x0/0x38
[39129.904068]  [<ffffffff802a8467>] ? sys_select+0xa7/0xbc
[39129.904170]  [<ffffffff8020b735>] sysret_signal+0x6d/0xb7
[39129.904271] zsh           D 0000000000000000     0  5235   4754
[39129.904445]  ffff88005145bd78 0000000000000086 0000000000000000 ffff8800=
74583000
[39129.904749]  ffffffff8069fdc0 ffffffff8069fdc0 ffff88005145bce8 ffffffff=
80227295
[39129.905053]  ffff8800738a6600 ffff8800738a4800 ffff8800738a6878 00000001=
8027f986
[39129.905381] Call Trace:
[39129.907186]  [<ffffffff80227295>] ? ptep_set_access_flags+0x22/0x28
[39129.907290]  [<ffffffff8024e7e0>] refrigerator+0xe7/0xf3
[39129.907392]  [<ffffffff802425b8>] get_signal_to_deliver+0x5a/0x3aa
[39129.907495]  [<ffffffff8022b43b>] ? update_curr+0x53/0xf0
[39129.907597]  [<ffffffff8020a904>] do_notify_resume+0x8c/0x833
[39129.907700]  [<ffffffff8022b7fc>] ? set_next_entity+0x3b/0x61
[39129.907803]  [<ffffffff8022ff17>] ? finish_task_switch+0x2b/0x8e
[39129.907905]  [<ffffffff804cad4c>] ? thread_return+0x3d/0xda
[39129.908023]  [<ffffffff8023f872>] ? sigprocmask+0xc6/0xd0
[39129.908125]  [<ffffffff8020b735>] sysret_signal+0x6d/0xb7
[39129.908227] zsh           D 0000000000000000     0  7352   4754
[39129.908400]  ffff880047515d78 0000000000000082 0000000000000000 ffffffff=
8027546e
[39129.908703]  ffffffff8069fdc0 ffffffff8069fdc0 ffff880047515ce8 ffffffff=
80227295
[39129.909009]  ffff88005b9c4200 ffff8800738a6600 ffff88005b9c4478 00000001=
8027f986
[39129.909336] Call Trace:
[39129.909434]  [<ffffffff8027546e>] ? __lru_cache_add+0x70/0x98
[39129.909537]  [<ffffffff80227295>] ? ptep_set_access_flags+0x22/0x28
[39129.909641]  [<ffffffff80249146>] ? autoremove_wake_function+0x0/0x38
[39129.909745]  [<ffffffff8024e7e0>] refrigerator+0xe7/0xf3
[39129.909847]  [<ffffffff802425b8>] get_signal_to_deliver+0x5a/0x3aa
[39129.909950]  [<ffffffff8020a904>] do_notify_resume+0x8c/0x833
[39129.910052]  [<ffffffff8022b7fc>] ? set_next_entity+0x3b/0x61
[39129.910155]  [<ffffffff8022ff17>] ? finish_task_switch+0x2b/0x8e
[39129.910258]  [<ffffffff804cad4c>] ? thread_return+0x3d/0xda
[39129.910360]  [<ffffffff802af502>] ? mntput_no_expire+0x2a/0x14d
[39129.910463]  [<ffffffff8023f872>] ? sigprocmask+0xc6/0xd0
[39129.910566]  [<ffffffff8020b735>] sysret_signal+0x6d/0xb7
[39129.910667] nfsiod        S ffff880051437e08     0 10336      2
[39129.910841]  ffff8800375a9ec0 0000000000000046 ffff8800375a9e10 ffffffff=
a045e422
[39129.911144]  ffffffff8069fdc0 ffffffff8069fdc0 ffff8800375a9e30 ffffffff=
a045e46d
[39129.911448]  ffff8800795dc200 ffffffff805f0350 ffff8800795dc478 00000000=
a0340493
[39129.911752] Call Trace:
[39129.911863]  [<ffffffffa045e422>] ? nfs_readdata_release+0x20/0x25 [nfs]
[39129.911977]  [<ffffffffa045e46d>] ? nfs_readpage_release_full+0x46/0x4b =
[nfs]
[39129.912108]  [<ffffffffa03406be>] ? rpc_async_release+0x10/0x12 [sunrpc]
[39129.912213]  [<ffffffff80245676>] worker_thread+0xa9/0xee
[39129.912315]  [<ffffffff80249146>] ? autoremove_wake_function+0x0/0x38
[39129.912419]  [<ffffffff802455cd>] ? worker_thread+0x0/0xee
[39129.912521]  [<ffffffff80248d3e>] kthread+0x49/0x76
[39129.912623]  [<ffffffff8020c5ea>] child_rip+0xa/0x20
[39129.912726]  [<ffffffff8022acbd>] ? dequeue_task+0xad/0xb8
[39129.912828]  [<ffffffff80248cf5>] ? kthread+0x0/0x76
[39129.912930]  [<ffffffff8020c5e0>] ? child_rip+0x0/0x20
[39129.913032] zsh           D 00007ffff44ead48     0 10787   4754
[39129.913224]  ffff880038971d78 0000000000000082 0000000000000000 ffffffff=
803a951f
[39129.913534]  ffffffff8069fdc0 ffffffff8069fdc0 ffff880038971ce8 ffffffff=
80227295
[39129.913838]  ffff88005b9c3600 ffff88007c062400 ffff88005b9c3878 00000001=
8027f986
[39129.914142] Call Trace:
[39129.914241]  [<ffffffff803a951f>] ? n_tty_receive_buf+0xe38/0xe8c
[39129.914344]  [<ffffffff80227295>] ? ptep_set_access_flags+0x22/0x28
[39129.914447]  [<ffffffff8024e7e0>] refrigerator+0xe7/0xf3
[39129.914549]  [<ffffffff802425b8>] get_signal_to_deliver+0x5a/0x3aa
[39129.914653]  [<ffffffff802493a8>] ? remove_wait_queue+0x3c/0x41
[39129.914756]  [<ffffffff8020a904>] do_notify_resume+0x8c/0x833
[39129.914858]  [<ffffffff8022b175>] ? __wake_up+0x43/0x50
[39129.914960]  [<ffffffff80231ed7>] ? default_wake_function+0x0/0xf
[39129.915063]  [<ffffffff803aac9c>] ? tty_ldisc_deref+0x69/0x6e
[39129.915166]  [<ffffffff803a3f6c>] ? tty_read+0x87/0xba
[39129.915268]  [<ffffffff8029a4e2>] ? vfs_read+0xab/0x154
[39129.915369]  [<ffffffff8020b735>] sysret_signal+0x6d/0xb7
[39129.915471] zsh           D 0000000000000000     0 16762   4754
[39129.915644]  ffff88000a54dd78 0000000000000082 0000000000000000 ffffffff=
8027546e
[39129.915948]  ffffffff8069fdc0 ffffffff8069fdc0 ffff88000a54dce8 ffffffff=
80227295
[39129.916265]  ffff88005b9c3000 ffff88005b9c3600 ffff88005b9c3278 00000001=
8027f986
[39129.916569] Call Trace:
[39129.916667]  [<ffffffff8027546e>] ? __lru_cache_add+0x70/0x98
[39129.916770]  [<ffffffff80227295>] ? ptep_set_access_flags+0x22/0x28
[39129.916874]  [<ffffffff8024e7e0>] refrigerator+0xe7/0xf3
[39129.916976]  [<ffffffff802425b8>] get_signal_to_deliver+0x5a/0x3aa
[39129.917081]  [<ffffffff8022b43b>] ? update_curr+0x53/0xf0
[39129.917202]  [<ffffffff8020a904>] do_notify_resume+0x8c/0x833
[39129.917305]  [<ffffffff8022b7fc>] ? set_next_entity+0x3b/0x61
[39129.917413]  [<ffffffff8022ff17>] ? finish_task_switch+0x2b/0x8e
[39129.917516]  [<ffffffff804cad4c>] ? thread_return+0x3d/0xda
[39129.917618]  [<ffffffff802af502>] ? mntput_no_expire+0x2a/0x14d
[39129.917722]  [<ffffffff8023f872>] ? sigprocmask+0xc6/0xd0
[39129.917823]  [<ffffffff8020b735>] sysret_signal+0x6d/0xb7
[39129.917925] zsh           D 0000000000000000     0 17504   4754
[39129.918098]  ffff88003c967d78 0000000000000082 0000000000000000 ffff8800=
5d186000
[39129.918402]  ffffffff8069fdc0 ffffffff8069fdc0 ffff88003c967ce8 ffffffff=
80227295
[39129.918706]  ffff88005b9c3c00 ffff88005b9c3000 ffff88005b9c3e78 00000001=
8027f986
[39129.919010] Call Trace:
[39129.919108]  [<ffffffff80227295>] ? ptep_set_access_flags+0x22/0x28
[39129.919212]  [<ffffffff80249146>] ? autoremove_wake_function+0x0/0x38
[39129.919316]  [<ffffffff8024e7e0>] refrigerator+0xe7/0xf3
[39129.919418]  [<ffffffff802425b8>] get_signal_to_deliver+0x5a/0x3aa
[39129.919521]  [<ffffffff8020a904>] do_notify_resume+0x8c/0x833
[39129.919624]  [<ffffffff8022b7fc>] ? set_next_entity+0x3b/0x61
[39129.919727]  [<ffffffff8022ff17>] ? finish_task_switch+0x2b/0x8e
[39129.919830]  [<ffffffff804cad4c>] ? thread_return+0x3d/0xda
[39129.919933]  [<ffffffff802af502>] ? mntput_no_expire+0x2a/0x14d
[39129.920049]  [<ffffffff8023f872>] ? sigprocmask+0xc6/0xd0
[39129.920151]  [<ffffffff8020b735>] sysret_signal+0x6d/0xb7
[39129.920253] zsh           D 0000000000000000     0 32118  16762
[39129.920426]  ffff88003c5d7d78 0000000000000086 0000000000000000 ffff8800=
64ce1400
[39129.920730]  ffffffff8069fdc0 ffffffff8069fdc0 ffff88003c5d7ce8 ffffffff=
80227295
[39129.921035]  ffff88005b9c7800 ffff88005b9c3c00 ffff88005b9c7a78 00000001=
8027f986
[39129.921363] Call Trace:
[39129.921462]  [<ffffffff80227295>] ? ptep_set_access_flags+0x22/0x28
[39129.921565]  [<ffffffff80249146>] ? autoremove_wake_function+0x0/0x38
[39129.921669]  [<ffffffff8024e7e0>] refrigerator+0xe7/0xf3
[39129.921772]  [<ffffffff802425b8>] get_signal_to_deliver+0x5a/0x3aa
[39129.921875]  [<ffffffff8022b43b>] ? update_curr+0x53/0xf0
[39129.921977]  [<ffffffff8020a904>] do_notify_resume+0x8c/0x833
[39129.922080]  [<ffffffff8022b7fc>] ? set_next_entity+0x3b/0x61
[39129.922182]  [<ffffffff8022ff17>] ? finish_task_switch+0x2b/0x8e
[39129.922285]  [<ffffffff804cad4c>] ? thread_return+0x3d/0xda
[39129.922388]  [<ffffffff802af502>] ? mntput_no_expire+0x2a/0x14d
[39129.922491]  [<ffffffff8023f872>] ? sigprocmask+0xc6/0xd0
[39129.922593]  [<ffffffff8020b735>] sysret_signal+0x6d/0xb7
[39129.922695] mutt          D 0000000000000000     0 32260  32118
[39129.922868]  ffff88003c5a1d78 0000000000000082 ffff88003c5a1cb8 ffffffff=
8027212e
[39129.923172]  ffffffff8069fdc0 ffffffff8069fdc0 ffff88003c5a1ce8 ffffffff=
80272186
[39129.923475]  ffff88005b9c6000 ffff88005b9c7800 ffff88005b9c6278 00000001=
80315c8a
[39129.923779] Call Trace:
[39129.923878]  [<ffffffff8027212e>] ? free_hot_page+0xb/0xd
[39129.923981]  [<ffffffff80272186>] ? free_pages+0x32/0x36
[39129.924096]  [<ffffffff8024e7e0>] refrigerator+0xe7/0xf3
[39129.924198]  [<ffffffff802425b8>] get_signal_to_deliver+0x5a/0x3aa
[39129.924301]  [<ffffffff8020a904>] do_notify_resume+0x8c/0x833
[39129.924404]  [<ffffffff802a5270>] ? do_filp_open+0x418/0x85d
[39129.924506]  [<ffffffff8029d003>] ? cp_new_stat+0x22/0xef
[39129.924609]  [<ffffffff8029d0c3>] ? cp_new_stat+0xe2/0xef
[39129.924711]  [<ffffffff80250203>] ? getnstimeofday+0x58/0xb4
[39129.924813]  [<ffffffff8024bfc4>] ? ktime_get_ts+0x49/0x4e
[39129.924916]  [<ffffffff802a717d>] ? poll_select_copy_remaining+0xc5/0xea
[39129.925021]  [<ffffffff802a8467>] ? sys_select+0xa7/0xbc
[39129.925142]  [<ffffffff8020b735>] sysret_signal+0x6d/0xb7
[39129.925244] keepassx      D 0000000000825a20     0 18479  17504
[39129.925423]  ffff88001ab37d78 0000000000000082 0000000000000000 00000000=
00000000
[39129.925727]  ffffffff8069fdc0 ffffffff8069fdc0 0000000000000000 ffff8800=
00000040
[39129.926030]  ffff8800738a0600 ffff88005b9c6000 ffff8800738a0878 00000001=
00001000
[39129.926334] Call Trace:
[39129.926433]  [<ffffffff80446db9>] ? sock_aio_read+0x146/0x15a
[39129.926536]  [<ffffffff8024e7e0>] refrigerator+0xe7/0xf3
[39129.926638]  [<ffffffff802425b8>] get_signal_to_deliver+0x5a/0x3aa
[39129.926741]  [<ffffffff8020a904>] do_notify_resume+0x8c/0x833
[39129.926844]  [<ffffffff80249146>] ? autoremove_wake_function+0x0/0x38
[39129.926948]  [<ffffffff804cad4c>] ? thread_return+0x3d/0xda
[39129.927050]  [<ffffffff802849db>] ? unmap_region+0xf3/0x159
[39129.927153]  [<ffffffff80250203>] ? getnstimeofday+0x58/0xb4
[39129.927255]  [<ffffffff8024bfc4>] ? ktime_get_ts+0x49/0x4e
[39129.927358]  [<ffffffff802a72d8>] ? poll_select_set_timeout+0x5c/0x77
[39129.927461]  [<ffffffff8020b735>] sysret_signal+0x6d/0xb7
[39129.927563] zsh           D 00000000ffffffff     0 18510   4754
[39129.927736]  ffff8800378ebd78 0000000000000082 ffff8800378ebcc8 ffffffff=
80224bae
[39129.928053]  ffffffff8069fdc0 ffffffff8069fdc0 ffff8800378ebe38 ffffffff=
804cf030
[39129.928356]  ffff8800795db000 ffff8800738a0600 ffff8800795db278 00000001=
32c11da0
[39129.928661] Call Trace:
[39129.928759]  [<ffffffff80224bae>] ? fixup_exception+0x18/0x36
[39129.928862]  [<ffffffff804cf030>] ? do_page_fault+0x6d9/0x8ca
[39129.928965]  [<ffffffff8024e7e0>] refrigerator+0xe7/0xf3
[39129.929069]  [<ffffffff802425b8>] get_signal_to_deliver+0x5a/0x3aa
[39129.930892]  [<ffffffff802493a8>] ? remove_wait_queue+0x3c/0x41
[39129.930995]  [<ffffffff8020a904>] do_notify_resume+0x8c/0x833
[39129.931097]  [<ffffffff8022b175>] ? __wake_up+0x43/0x50
[39129.931199]  [<ffffffff80231ed7>] ? default_wake_function+0x0/0xf
[39129.931303]  [<ffffffff803aac9c>] ? tty_ldisc_deref+0x69/0x6e
[39129.931405]  [<ffffffff803a3f6c>] ? tty_read+0x87/0xba
[39129.931507]  [<ffffffff8029a4e2>] ? vfs_read+0xab/0x154
[39129.931609]  [<ffffffff8020b735>] sysret_signal+0x6d/0xb7
[39129.931710] zsh           R  running task        0 19154   5235
[39129.931884]  ffff880043d7dcf8 0000000000000000 0000000000004ad2 00000000=
00001473
[39129.932201]  0000000000000000 0000000000000000 ffff880043d7dce8 00000000=
00000007
[39129.932504]  ffff880043d7dd58 ffffffff8020d9a2 ffff88005b9c2680 00000000=
00000000
[39129.932808] Call Trace:
[39129.932907]  [<ffffffff8020e9df>] show_trace_log_lvl+0x4c/0x58
[39129.933011]  [<ffffffff8020d9d0>] show_stack_log_lvl+0xfb/0x10a
[39129.933132]  [<ffffffff8020e991>] show_stack+0x17/0x19
[39129.933234]  [<ffffffff8022fa12>] sched_show_task+0xa5/0xaa
[39129.933342]  [<ffffffff8022fa67>] show_state_filter+0x50/0x92
[39129.933445]  [<ffffffff8025c7be>] try_to_freeze_tasks+0x159/0x237
[39129.933549]  [<ffffffff802493a8>] ? remove_wait_queue+0x3c/0x41
[39129.933652]  [<ffffffff8025c8bd>] freeze_processes+0x21/0xa0
[39129.933755]  [<ffffffff8025c2b5>] enter_state+0x96/0x164
[39129.933857]  [<ffffffff8025c438>] state_store+0xb5/0xd7
[39129.933959]  [<ffffffff8034ddbf>] kobj_attr_store+0x17/0x19
[39129.934062]  [<ffffffff802e5581>] sysfs_write_file+0xdf/0x114
[39129.934165]  [<ffffffff8029a2a1>] vfs_write+0xae/0x157
[39129.934266]  [<ffffffff8029a40e>] sys_write+0x47/0x70
[39129.934368]  [<ffffffff8020b65b>] system_call_fastpath+0x16/0x1b
[39129.934470] zsh           D 0000000000000000     0 19380   4754
[39129.934644]  ffff880037e0bd78 0000000000000082 0000000000000000 ffff8800=
37e0bcc0
[39129.934947]  ffffffff8069fdc0 ffffffff8069fdc0 ffff880037e0bce8 ffffffff=
80227295
[39129.935250]  ffff88005b9c0c00 ffff8800795db000 ffff88005b9c0e78 00000001=
8027f986
[39129.935555] Call Trace:
[39129.935653]  [<ffffffff80227295>] ? ptep_set_access_flags+0x22/0x28
[39129.935757]  [<ffffffff8024e7e0>] refrigerator+0xe7/0xf3
[39129.935859]  [<ffffffff802425b8>] get_signal_to_deliver+0x5a/0x3aa
[39129.935962]  [<ffffffff8020a904>] do_notify_resume+0x8c/0x833
[39129.936077]  [<ffffffff8022b7fc>] ? set_next_entity+0x3b/0x61
[39129.936180]  [<ffffffff8022ff17>] ? finish_task_switch+0x2b/0x8e
[39129.936283]  [<ffffffff804cad4c>] ? thread_return+0x3d/0xda
[39129.936385]  [<ffffffff802af502>] ? mntput_no_expire+0x2a/0x14d
[39129.936489]  [<ffffffff8023f872>] ? sigprocmask+0xc6/0xd0
[39129.936591]  [<ffffffff8020b735>] sysret_signal+0x6d/0xb7
[39129.936693] vi            D 000000000000003e     0 23999  19380
[39129.936866]  ffff880037e27d78 0000000000000082 0000000049b6a3f8 ffff8800=
24078268
[39129.937193]  ffffffff8069fdc0 ffffffff8069fdc0 0000000000000000 ffff8800=
37e27e68
[39129.937503]  ffff8800738a6c00 ffff88005b9c0c00 ffff8800738a6e78 00000001=
00000010
[39129.937806] Call Trace:
[39129.937905]  [<ffffffff8024e7e0>] refrigerator+0xe7/0xf3
[39129.938007]  [<ffffffff802425b8>] get_signal_to_deliver+0x5a/0x3aa
[39129.938110]  [<ffffffff8020a904>] do_notify_resume+0x8c/0x833
[39129.938213]  [<ffffffff80249146>] ? autoremove_wake_function+0x0/0x38
[39129.938316]  [<ffffffff8024bfc4>] ? ktime_get_ts+0x49/0x4e
[39129.938419]  [<ffffffff802a717d>] ? poll_select_copy_remaining+0xc5/0xea
[39129.938523]  [<ffffffff802a8467>] ? sys_select+0xa7/0xbc
[39129.938625]  [<ffffffff8020b735>] sysret_signal+0x6d/0xb7
[39129.938726] zsh           D 00007fff1d325b88     0 24275   4754
[39129.938899]  ffff880014dbdd78 0000000000000086 ffff880014dbddf8 ffffffff=
803a951f
[39129.939203]  ffffffff8069fdc0 ffffffff8069fdc0 0000000500006506 00008a3b=
000000bf
[39129.939506]  ffff88007b906c00 ffff8800738a6c00 ffff88007b906e78 00000001=
00009600
[39129.939810] Call Trace:
[39129.939908]  [<ffffffff803a951f>] ? n_tty_receive_buf+0xe38/0xe8c
[39129.940025]  [<ffffffff8024e7e0>] refrigerator+0xe7/0xf3
[39129.940127]  [<ffffffff802425b8>] get_signal_to_deliver+0x5a/0x3aa
[39129.940230]  [<ffffffff802493a8>] ? remove_wait_queue+0x3c/0x41
[39129.940333]  [<ffffffff8020a904>] do_notify_resume+0x8c/0x833
[39129.940436]  [<ffffffff8022b175>] ? __wake_up+0x43/0x50
[39129.940538]  [<ffffffff80231ed7>] ? default_wake_function+0x0/0xf
[39129.940641]  [<ffffffff803aac9c>] ? tty_ldisc_deref+0x69/0x6e
[39129.940744]  [<ffffffff803a3f6c>] ? tty_read+0x87/0xba
[39129.940846]  [<ffffffff8029a4e2>] ? vfs_read+0xab/0x154
[39129.940947]  [<ffffffff8020b735>] sysret_signal+0x6d/0xb7
[39129.941050] gnome-vfs-dae D 0000000000641820     0 24525      1
[39129.941241]  ffff8800420fbd78 0000000000000086 0000000000000000 ffff8800=
420fbb98
[39129.941551]  ffffffff8069fdc0 ffffffff8069fdc0 0000000000200200 ffff8800=
5ff42a30
[39129.941855]  ffff880032ca7200 ffff88007b906c00 ffff880032ca7478 00000001=
802a8546
[39129.942158] Call Trace:
[39129.942257]  [<ffffffff802a8546>] ? pollwake+0x0/0x4e
[39129.942359]  [<ffffffff8024e7e0>] refrigerator+0xe7/0xf3
[39129.942461]  [<ffffffff802425b8>] get_signal_to_deliver+0x5a/0x3aa
[39129.942564]  [<ffffffff8020a904>] do_notify_resume+0x8c/0x833
[39129.942667]  [<ffffffff80249146>] ? autoremove_wake_function+0x0/0x38
[39129.942771]  [<ffffffff804cad4c>] ? thread_return+0x3d/0xda
[39129.942873]  [<ffffffff803321d0>] ? security_file_permission+0x11/0x13
[39129.942977]  [<ffffffff8020b735>] sysret_signal+0x6d/0xb7
[39129.943079] tail          D 0000000000000001     0 27431  19154
[39129.943252]  ffff880003961d78 0000000000000082 ffff88007bb79800 00000000=
000aa000
[39129.943556]  ffffffff8069fdc0 ffffffff8069fdc0 ffff880003961cf8 ffffffff=
8026d1d5
[39129.943860]  ffff8800738a1e00 ffff880074582400 ffff8800738a2078 00000001=
000aa000
[39129.944178] Call Trace:
[39129.944276]  [<ffffffff8026d1d5>] ? find_get_page+0x30/0xb6
[39129.944379]  [<ffffffff8020c2be>] ? reschedule_interrupt+0xe/0x20
[39129.944482]  [<ffffffff8022acbd>] ? dequeue_task+0xad/0xb8
[39129.944585]  [<ffffffff8024e7e0>] refrigerator+0xe7/0xf3
[39129.944687]  [<ffffffff802425b8>] get_signal_to_deliver+0x5a/0x3aa
[39129.944790]  [<ffffffff8020a904>] do_notify_resume+0x8c/0x833
[39129.944893]  [<ffffffff8024b537>] ? __remove_hrtimer+0x5f/0x6d
[39129.944995]  [<ffffffff8024bbe3>] ? hrtimer_try_to_cancel+0x67/0x71
[39129.945101]  [<ffffffff8024bc01>] ? hrtimer_cancel+0x14/0x20
[39129.945222]  [<ffffffff804cb7af>] ? do_nanosleep+0x6c/0xa7
[39129.945325]  [<ffffffff8024be7b>] ? hrtimer_nanosleep+0x91/0xff
[39129.945433]  [<ffffffff8024b65a>] ? hrtimer_wakeup+0x0/0x21
[39129.945535]  [<ffffffff8020b735>] sysret_signal+0x6d/0xb7
[39129.945637] zsh           D 0000000000000000     0 27722   4754
[39129.945811]  ffff880018e77d78 0000000000000086 0000000000000000 ffff8800=
3797d800
[39129.946115]  ffffffff8069fdc0 ffffffff8069fdc0 ffff880018e77ce8 ffffffff=
80227295
[39129.946420]  ffff880032ca2a00 ffff880032ca7200 ffff880032ca2c78 00000001=
8027f986
[39129.946724] Call Trace:
[39129.946822]  [<ffffffff80227295>] ? ptep_set_access_flags+0x22/0x28
[39129.946926]  [<ffffffff80249146>] ? autoremove_wake_function+0x0/0x38
[39129.947030]  [<ffffffff8024e7e0>] refrigerator+0xe7/0xf3
[39129.947132]  [<ffffffff802425b8>] get_signal_to_deliver+0x5a/0x3aa
[39129.947235]  [<ffffffff8022b43b>] ? update_curr+0x53/0xf0
[39129.947337]  [<ffffffff8020a904>] do_notify_resume+0x8c/0x833
[39129.947441]  [<ffffffff8022b7fc>] ? set_next_entity+0x3b/0x61
[39129.947543]  [<ffffffff8022ff17>] ? finish_task_switch+0x2b/0x8e
[39129.947646]  [<ffffffff804cad4c>] ? thread_return+0x3d/0xda
[39129.947749]  [<ffffffff802af502>] ? mntput_no_expire+0x2a/0x14d
[39129.947852]  [<ffffffff8023f872>] ? sigprocmask+0xc6/0xd0
[39129.947954]  [<ffffffff8020b735>] sysret_signal+0x6d/0xb7
[39129.948069] mutt          D 0000000000000000     0 27863  27722
[39129.948242]  ffff8800299dfd78 0000000000000082 ffff8800299dfdf8 ffffffff=
803a951f
[39129.948546]  ffffffff8069fdc0 ffffffff8069fdc0 ffff8800299dfcf8 ffffffff=
8026d1d5
[39129.948850]  ffff880032ca6c00 ffff880032ca2a00 ffff880032ca6e78 00000001=
00000000
[39129.949177] Call Trace:
[39129.949275]  [<ffffffff803a951f>] ? n_tty_receive_buf+0xe38/0xe8c
[39129.949384]  [<ffffffff8026d1d5>] ? find_get_page+0x30/0xb6
[39129.949487]  [<ffffffff8024e7e0>] refrigerator+0xe7/0xf3
[39129.949589]  [<ffffffff802425b8>] get_signal_to_deliver+0x5a/0x3aa
[39129.949692]  [<ffffffff8020a904>] do_notify_resume+0x8c/0x833
[39129.949795]  [<ffffffff8022b175>] ? __wake_up+0x43/0x50
[39129.949897]  [<ffffffff80250203>] ? getnstimeofday+0x58/0xb4
[39129.950000]  [<ffffffff8024bfc4>] ? ktime_get_ts+0x49/0x4e
[39129.950102]  [<ffffffff802a717d>] ? poll_select_copy_remaining+0xc5/0xea
[39129.950206]  [<ffffffff802a8467>] ? sys_select+0xa7/0xbc
[39129.950308]  [<ffffffff8020b735>] sysret_signal+0x6d/0xb7
[39129.950410] zsh           D 0000000000000000     0  1366   4754
[39129.950583]  ffff8800600dfd78 0000000000000086 0000000000000000 ffff8800=
5d185000
[39129.950886]  ffffffff8069fdc0 ffffffff8069fdc0 ffff8800600dfce8 ffffffff=
80227295
[39129.951190]  ffff880032ca4e00 ffff880032ca6c00 ffff880032ca5078 00000001=
8027f986
[39129.951493] Call Trace:
[39129.951592]  [<ffffffff80227295>] ? ptep_set_access_flags+0x22/0x28
[39129.951696]  [<ffffffff80249146>] ? autoremove_wake_function+0x0/0x38
[39129.951800]  [<ffffffff8024e7e0>] refrigerator+0xe7/0xf3
[39129.951901]  [<ffffffff802425b8>] get_signal_to_deliver+0x5a/0x3aa
[39129.952017]  [<ffffffff8022b43b>] ? update_curr+0x53/0xf0
[39129.952119]  [<ffffffff8020a904>] do_notify_resume+0x8c/0x833
[39129.952222]  [<ffffffff8022b7fc>] ? set_next_entity+0x3b/0x61
[39129.952325]  [<ffffffff8022ff17>] ? finish_task_switch+0x2b/0x8e
[39129.952427]  [<ffffffff804cad4c>] ? thread_return+0x3d/0xda
[39129.952530]  [<ffffffff802af502>] ? mntput_no_expire+0x2a/0x14d
[39129.952633]  [<ffffffff8023f872>] ? sigprocmask+0xc6/0xd0
[39129.952735]  [<ffffffff8020b735>] sysret_signal+0x6d/0xb7
[39129.954544] mutt          D 0000000000000000     0  1507   1366
[39129.954736]  ffff8800471abd78 0000000000000086 ffff8800471abcb8 ffffffff=
8027212e
[39129.955046]  ffffffff8069fdc0 ffffffff8069fdc0 ffff8800471abce8 ffffffff=
80272186
[39129.955349]  ffff88005b9c7200 ffff880032ca4e00 ffff88005b9c7478 00000001=
80315c8a
[39129.955653] Call Trace:
[39129.955751]  [<ffffffff8027212e>] ? free_hot_page+0xb/0xd
[39129.955853]  [<ffffffff80272186>] ? free_pages+0x32/0x36
[39129.955956]  [<ffffffff8024e7e0>] refrigerator+0xe7/0xf3
[39129.956071]  [<ffffffff802425b8>] get_signal_to_deliver+0x5a/0x3aa
[39129.956174]  [<ffffffff8020a904>] do_notify_resume+0x8c/0x833
[39129.956277]  [<ffffffff802a5270>] ? do_filp_open+0x418/0x85d
[39129.956380]  [<ffffffff8029d0c3>] ? cp_new_stat+0xe2/0xef
[39129.956482]  [<ffffffff80250203>] ? getnstimeofday+0x58/0xb4
[39129.956584]  [<ffffffff8024bfc4>] ? ktime_get_ts+0x49/0x4e
[39129.956687]  [<ffffffff802a717d>] ? poll_select_copy_remaining+0xc5/0xea
[39129.956791]  [<ffffffff802a8467>] ? sys_select+0xa7/0xbc
[39129.956893]  [<ffffffff8020b735>] sysret_signal+0x6d/0xb7
[39129.956994] ethlog.sh     D 00000000000016f4     0  5874   7352
[39129.957187]  ffff880013425d78 0000000000000082 ffff880013425cb8 ffffffff=
8027546e
[39129.957497]  ffffffff8069fdc0 ffffffff8069fdc0 800000003ff3f067 ffffe200=
01139238
[39129.957801]  ffff880032ca1800 ffff88005b9c7200 ffff880032ca1a78 00000001=
00000000
[39129.958104] Call Trace:
[39129.958203]  [<ffffffff8027546e>] ? __lru_cache_add+0x70/0x98
[39129.958305]  [<ffffffff8022b7fc>] ? set_next_entity+0x3b/0x61
[39129.958408]  [<ffffffff8024e7e0>] refrigerator+0xe7/0xf3
[39129.958510]  [<ffffffff802425b8>] get_signal_to_deliver+0x5a/0x3aa
[39129.958613]  [<ffffffff8020a904>] do_notify_resume+0x8c/0x833
[39129.958716]  [<ffffffff8021c04e>] ? native_smp_send_reschedule+0x50/0x52
[39129.958820]  [<ffffffff8022a5d7>] ? resched_task+0x67/0x69
[39129.958922]  [<ffffffff802493a8>] ? remove_wait_queue+0x3c/0x41
[39129.959025]  [<ffffffff80238ad4>] ? do_wait+0x2d6/0x393
[39129.959127]  [<ffffffff80231ed7>] ? default_wake_function+0x0/0xf
[39129.959230]  [<ffffffff8020b735>] sysret_signal+0x6d/0xb7
[39129.959332] vi            D 000000000000003c     0  5876   5874
[39129.959504]  ffff88001cdf9d78 0000000000000082 0000000049b6a403 ffff8800=
28eaec08
[39129.959809]  ffffffff8069fdc0 ffffffff8069fdc0 0000000000000000 ffff8800=
1cdf9e68
[39129.960125]  ffff8800738a3600 ffff880032ca1800 ffff8800738a3878 00000001=
7a44d500
[39129.960429] Call Trace:
[39129.960528]  [<ffffffff8024e7e0>] refrigerator+0xe7/0xf3
[39129.960629]  [<ffffffff802425b8>] get_signal_to_deliver+0x5a/0x3aa
[39129.960733]  [<ffffffff8020a904>] do_notify_resume+0x8c/0x833
[39129.960836]  [<ffffffff80249146>] ? autoremove_wake_function+0x0/0x38
[39129.960939]  [<ffffffff8024bfc4>] ? ktime_get_ts+0x49/0x4e
[39129.961043]  [<ffffffff802a717d>] ? poll_select_copy_remaining+0xc5/0xea
[39129.961166]  [<ffffffff802a8467>] ? sys_select+0xa7/0xbc
[39129.961268]  [<ffffffff8020b735>] sysret_signal+0x6d/0xb7
[39129.961375] zsh           D 0000000000000000     0 15047   4754
[39129.961549]  ffff88005d0d5d78 0000000000000082 ffff88005d0d5df8 ffffffff=
803a951f
[39129.961853]  ffffffff8069fdc0 ffffffff8069fdc0 ffff88005d0d5ce8 ffffffff=
80227295
[39129.962157]  ffff880032ca0600 ffff8800738a3600 ffff880032ca0878 00000001=
8027f986
[39129.962460] Call Trace:
[39129.962559]  [<ffffffff803a951f>] ? n_tty_receive_buf+0xe38/0xe8c
[39129.962662]  [<ffffffff80227295>] ? ptep_set_access_flags+0x22/0x28
[39129.962766]  [<ffffffff8024e7e0>] refrigerator+0xe7/0xf3
[39129.962868]  [<ffffffff802425b8>] get_signal_to_deliver+0x5a/0x3aa
[39129.962971]  [<ffffffff803a3a0c>] ? tty_put_char+0x2d/0x2f
[39129.963073]  [<ffffffff8020a904>] do_notify_resume+0x8c/0x833
[39129.963176]  [<ffffffff8022b7fc>] ? set_next_entity+0x3b/0x61
[39129.963279]  [<ffffffff8022ff17>] ? finish_task_switch+0x2b/0x8e
[39129.963382]  [<ffffffff804cad4c>] ? thread_return+0x3d/0xda
[39129.963484]  [<ffffffff802a6838>] ? do_vfs_ioctl+0x446/0x482
[39129.963587]  [<ffffffff8023f872>] ? sigprocmask+0xc6/0xd0
[39129.963689]  [<ffffffff8020b735>] sysret_signal+0x6d/0xb7
[39129.963790] mutt          D 0000000000000000     0 15188  15047
[39129.963964]  ffff880060dafd78 0000000000000086 ffff880060dafdf8 ffffffff=
803a951f
[39129.964281]  ffffffff8069fdc0 ffffffff8069fdc0 ffff880060dafcf8 ffffffff=
8026d1d5
[39129.964584]  ffff88005b9c1e00 ffff88005b9c2400 ffff88005b9c2078 00000000=
00000000
[39129.964888] Call Trace:
[39129.964986]  [<ffffffff803a951f>] ? n_tty_receive_buf+0xe38/0xe8c
[39129.965091]  [<ffffffff8026d1d5>] ? find_get_page+0x30/0xb6
[39129.965212]  [<ffffffff8024e7e0>] refrigerator+0xe7/0xf3
[39129.965314]  [<ffffffff802425b8>] get_signal_to_deliver+0x5a/0x3aa
[39129.965423]  [<ffffffff8020a904>] do_notify_resume+0x8c/0x833
[39129.965525]  [<ffffffff8022b175>] ? __wake_up+0x43/0x50
[39129.965628]  [<ffffffff80250203>] ? getnstimeofday+0x58/0xb4
[39129.965730]  [<ffffffff8024bfc4>] ? ktime_get_ts+0x49/0x4e
[39129.965832]  [<ffffffff802a717d>] ? poll_select_copy_remaining+0xc5/0xea
[39129.965936]  [<ffffffff802a8467>] ? sys_select+0xa7/0xbc
[39129.966038]  [<ffffffff8020b735>] sysret_signal+0x6d/0xb7
[39129.966139] vim           D 0000000000000044     0 17848   4754
[39129.966312]  ffff88000e8e1d78 0000000000000086 0000000049b6a311 ffff8800=
2005c268
[39129.966616]  ffffffff8069fdc0 ffffffff8069fdc0 0000000000000000 ffff8800=
0e8e1e68
[39129.966920]  ffff88007b896c00 ffff8800738a2a00 ffff88007b896e78 00000001=
00000000
[39129.967224] Call Trace:
[39129.967322]  [<ffffffff8024e7e0>] refrigerator+0xe7/0xf3
[39129.967424]  [<ffffffff802425b8>] get_signal_to_deliver+0x5a/0x3aa
[39129.967527]  [<ffffffff8020a904>] do_notify_resume+0x8c/0x833
[39129.967630]  [<ffffffff80249146>] ? autoremove_wake_function+0x0/0x38
[39129.967734]  [<ffffffff8024bfc4>] ? ktime_get_ts+0x49/0x4e
[39129.967836]  [<ffffffff802a717d>] ? poll_select_copy_remaining+0xc5/0xea
[39129.967941]  [<ffffffff802a8467>] ? sys_select+0xa7/0xbc
[39129.968055]  [<ffffffff8020b735>] sysret_signal+0x6d/0xb7
[39129.968157] scsi_eh_8     S ffff88007959b7e0     0 21360      2
[39129.968331]  ffff88007994fe80 0000000000000046 ffff8800738a4200 ffff8800=
01021580
[39129.968636]  ffffffff8069fdc0 ffffffff8069fdc0 ffff88007c060648 ffff8800=
7c060638
[39129.968940]  ffff880032ca3000 ffff88007c060600 ffff880032ca3278 00000001=
01021580
[39129.969270] Call Trace:
[39129.969368]  [<ffffffff8022ff17>] ? finish_task_switch+0x2b/0x8e
[39129.969471]  [<ffffffff804cad4c>] ? thread_return+0x3d/0xda
[39129.969574]  [<ffffffff803e2879>] scsi_error_handler+0x67/0x326
[39129.969677]  [<ffffffff80237ed5>] ? release_task+0x3de/0x3f4
[39129.969779]  [<ffffffff803e2812>] ? scsi_error_handler+0x0/0x326
[39129.969882]  [<ffffffff80248d3e>] kthread+0x49/0x76
[39129.969984]  [<ffffffff8020c5ea>] child_rip+0xa/0x20
[39129.970085]  [<ffffffff8022acbd>] ? dequeue_task+0xad/0xb8
[39129.970187]  [<ffffffff80248cf5>] ? kthread+0x0/0x76
[39129.970289]  [<ffffffff8020c5e0>] ? child_rip+0x0/0x20
[39129.970390] usb-storage   S ffff88007396b690     0 21361      2
[39129.970563]  ffff880043dd3dc0 0000000000000046 ffff880043dd3d00 ffffffff=
804ca398
[39129.970867]  ffffffff8069fdc0 ffffffff8069fdc0 0000000000000000 00000000=
00000303
[39129.971171]  ffff880032ca4800 ffff88007c061200 ffff880032ca4a78 00000000=
00000001
[39129.971475] Call Trace:
[39129.971574]  [<ffffffff804ca398>] ? wait_for_completion_interruptible_ti=
meout+0xe/0x10
[39129.971738]  [<ffffffff8022bb3e>] ? enqueue_entity+0x110/0x118
[39129.971841]  [<ffffffff8022a9b4>] ? wakeup_preempt_entity+0x31/0x3f
[39129.971944]  [<ffffffff804cb01b>] schedule_timeout+0x22/0xcf
[39129.972060]  [<ffffffff80231ec5>] ? try_to_wake_up+0x1d2/0x1e4
[39129.972167]  [<ffffffffa01c7455>] ? usb_stor_invoke_transport+0x299/0x2a=
6 [usb_storage]
[39129.972331]  [<ffffffff804ca2f7>] wait_for_common+0xc7/0x131
[39129.972434]  [<ffffffff80231ed7>] ? default_wake_function+0x0/0xf
[39129.972537]  [<ffffffff804ca3b2>] wait_for_completion_interruptible+0x18=
/0x29
[39129.972646]  [<ffffffffa01c8837>] usb_stor_control_thread+0x3e/0x1d3 [us=
b_storage]
[39129.972808]  [<ffffffff80237ed5>] ? release_task+0x3de/0x3f4
[39129.972914]  [<ffffffffa01c87f9>] ? usb_stor_control_thread+0x0/0x1d3 [u=
sb_storage]
[39129.973079]  [<ffffffff80248d3e>] kthread+0x49/0x76
[39129.973200]  [<ffffffff8020c5ea>] child_rip+0xa/0x20
[39129.973302]  [<ffffffff80248cf5>] ? kthread+0x0/0x76
[39129.973409]  [<ffffffff8020c5e0>] ? child_rip+0x0/0x20
[39129.973510] hald-addon-st D 000000000060a510     0 21427   4136
[39129.973683]  ffff880029869d78 0000000000000082 ffff880029869cd8 ffffffff=
8033f81c
[39129.973986]  ffffffff8069fdc0 ffffffff8069fdc0 0000000000000000 00000000=
0009a000
[39129.974290]  ffff88005b9c5a00 ffff88007bba7200 ffff88005b9c5c78 00000000=
0000001d
[39129.974594] Call Trace:
[39129.974692]  [<ffffffff8033f81c>] ? blk_put_request+0x3d/0x46
[39129.974795]  [<ffffffff803e5242>] ? scsi_execute_req+0xa2/0xb4
[39129.974898]  [<ffffffff8024e7e0>] refrigerator+0xe7/0xf3
[39129.975001]  [<ffffffff802425b8>] get_signal_to_deliver+0x5a/0x3aa
[39129.975104]  [<ffffffff803e0366>] ? ioctl_internal_command+0x36/0xf3
[39129.975207]  [<ffffffff8020a904>] do_notify_resume+0x8c/0x833
[39129.975310]  [<ffffffff802ab675>] ? iput+0x2f/0x65
[39129.975412]  [<ffffffff802bdfb9>] ? __blkdev_put+0x144/0x169
[39129.975515]  [<ffffffff802af502>] ? mntput_no_expire+0x2a/0x14d
[39129.975618]  [<ffffffff80250203>] ? getnstimeofday+0x58/0xb4
[39129.975720]  [<ffffffff8024bfc4>] ? ktime_get_ts+0x49/0x4e
[39129.975823]  [<ffffffff802a72d8>] ? poll_select_set_timeout+0x5c/0x77
[39129.975926]  [<ffffffff8020b735>] sysret_signal+0x6d/0xb7
[39129.976041] migration/1   S ffff880043d7dbb8     0 21668      2
[39129.976214]  ffff880074455ed0 0000000000000046 ffff880074455e30 ffffffff=
8022bb3e
[39129.978228]  ffffffff8069fdc0 ffffffff8069fdc0 ffff880001019dc0 ffff8800=
01019dc0
[39129.978556]  ffff880032ca1200 ffff88007c062400 ffff880032ca1478 00000001=
00000001
[39129.978860] Call Trace:
[39129.978958]  [<ffffffff8022bb3e>] ? enqueue_entity+0x110/0x118
[39129.979061]  [<ffffffff8021c04e>] ? native_smp_send_reschedule+0x50/0x52
[39129.979165]  [<ffffffff80232b6d>] migration_thread+0x1a5/0x23b
[39129.979268]  [<ffffffff802329c8>] ? migration_thread+0x0/0x23b
[39129.979371]  [<ffffffff80248d3e>] kthread+0x49/0x76
[39129.979472]  [<ffffffff8020c5ea>] child_rip+0xa/0x20
[39129.979574]  [<ffffffff8022acbd>] ? dequeue_task+0xad/0xb8
[39129.979676]  [<ffffffff80248cf5>] ? kthread+0x0/0x76
[39129.979777]  [<ffffffff8020c5e0>] ? child_rip+0x0/0x20
[39129.979878] ksoftirqd/1   S ffffffff80640358     0 21669      2
[39129.980064]  ffff880074485ef0 0000000000000046 ffffffff8069fdc0 00000000=
00000000
[39129.980368]  ffffffff8069fdc0 ffffffff8069fdc0 ffff880032ca6280 00000001=
804cad4c
[39129.980672]  ffff880032ca6000 ffff88007b895a00 ffff880032ca6278 00000001=
8069fdc0
[39129.980975] Call Trace:
[39129.981075]  [<ffffffff8023a703>] ksoftirqd+0x62/0x17c
[39129.981195]  [<ffffffff8023a6a1>] ? ksoftirqd+0x0/0x17c
[39129.981297]  [<ffffffff8023a6a1>] ? ksoftirqd+0x0/0x17c
[39129.981405]  [<ffffffff80248d3e>] kthread+0x49/0x76
[39129.981506]  [<ffffffff8020c5ea>] child_rip+0xa/0x20
[39129.981608]  [<ffffffff80248cf5>] ? kthread+0x0/0x76
[39129.981709]  [<ffffffff8020c5e0>] ? child_rip+0x0/0x20
[39129.981810] rpciod/1      S ffff88007a936b08     0 21670      2
[39129.981983]  ffff88007448dec0 0000000000000046 ffffffff802455cd ffff8800=
01015580
[39129.982287]  ffffffff8069fdc0 ffffffff8069fdc0 ffff88007448de40 ffffffff=
8022ff17
[39129.982591]  ffff880032ca5a00 ffff880032ca0c00 ffff880032ca5c78 00000001=
00000000
[39129.982894] Call Trace:
[39129.982992]  [<ffffffff802455cd>] ? worker_thread+0x0/0xee
[39129.983094]  [<ffffffff8022ff17>] ? finish_task_switch+0x2b/0x8e
[39129.983197]  [<ffffffff80245676>] worker_thread+0xa9/0xee
[39129.983299]  [<ffffffff80249146>] ? autoremove_wake_function+0x0/0x38
[39129.983403]  [<ffffffff802455cd>] ? worker_thread+0x0/0xee
[39129.983505]  [<ffffffff80248d3e>] kthread+0x49/0x76
[39129.983607]  [<ffffffff8020c5ea>] child_rip+0xa/0x20
[39129.983708]  [<ffffffff80248cf5>] ? kthread+0x0/0x76
[39129.983809]  [<ffffffff8020c5e0>] ? child_rip+0x0/0x20
[39129.983910] ib_cm/1       S ffff88007902eb88     0 21671      2
[39129.984097]  ffff880074497ec0 0000000000000046 0000000000000010 00000000=
00000207
[39129.984400]  ffffffff8069fdc0 ffffffff8069fdc0 ffff880074497e40 ffffffff=
8022ff17
[39129.984704]  ffff880032ca6600 ffff880032ca4200 ffff880032ca6878 00000001=
1c5c1ed0
[39129.985009] Call Trace:
[39129.985127]  [<ffffffff8022ff17>] ? finish_task_switch+0x2b/0x8e
[39129.985231]  [<ffffffff80231ec5>] ? try_to_wake_up+0x1d2/0x1e4
[39129.985339]  [<ffffffff80245676>] worker_thread+0xa9/0xee
[39129.985442]  [<ffffffff80249146>] ? autoremove_wake_function+0x0/0x38
[39129.985546]  [<ffffffff802455cd>] ? worker_thread+0x0/0xee
[39129.985648]  [<ffffffff80248d3e>] kthread+0x49/0x76
[39129.985749]  [<ffffffff8020c5ea>] child_rip+0xa/0x20
[39129.985851]  [<ffffffff80248cf5>] ? kthread+0x0/0x76
[39129.985952]  [<ffffffff8020c5e0>] ? child_rip+0x0/0x20
[39129.986053] aio/1         S ffff88007c38dc88     0 21672      2
[39129.986226]  ffff88007449fec0 0000000000000046 ffffffff802455cd ffff8800=
01015580
[39129.986530]  ffffffff8069fdc0 ffffffff8069fdc0 ffff88007449fe40 ffffffff=
8022ff17
[39129.986834]  ffff880032ca4200 ffff88007c062400 ffff880032ca4478 00000001=
74497ed0
[39129.987138] Call Trace:
[39129.987236]  [<ffffffff802455cd>] ? worker_thread+0x0/0xee
[39129.987338]  [<ffffffff8022ff17>] ? finish_task_switch+0x2b/0x8e
[39129.987441]  [<ffffffff80245676>] worker_thread+0xa9/0xee
[39129.987544]  [<ffffffff80249146>] ? autoremove_wake_function+0x0/0x38
[39129.987647]  [<ffffffff802455cd>] ? worker_thread+0x0/0xee
[39129.987750]  [<ffffffff80248d3e>] kthread+0x49/0x76
[39129.987851]  [<ffffffff8020c5ea>] child_rip+0xa/0x20
[39129.987953]  [<ffffffff80248cf5>] ? kthread+0x0/0x76
[39129.988067]  [<ffffffff8020c5e0>] ? child_rip+0x0/0x20
[39129.988168] kondemand/1   S ffff88007c38d488     0 21673      2
[39129.988341]  ffff8800744b9ec0 0000000000000046 ffff8800744b9e80 ffffffff=
804372f7
[39129.988645]  ffffffff8069fdc0 ffffffff8069fdc0 ffff8800744b9e40 00000000=
00000001
[39129.988949]  ffff880032ca0c00 ffff88007c062400 ffff880032ca0e78 00000001=
7448ded0
[39129.989278] Call Trace:
[39129.989376]  [<ffffffff804372f7>] ? do_dbs_timer+0x2c3/0x2d2
[39129.989479]  [<ffffffff80437034>] ? do_dbs_timer+0x0/0x2d2
[39129.989581]  [<ffffffff80245676>] worker_thread+0xa9/0xee
[39129.989683]  [<ffffffff80249146>] ? autoremove_wake_function+0x0/0x38
[39129.989787]  [<ffffffff802455cd>] ? worker_thread+0x0/0xee
[39129.989889]  [<ffffffff80248d3e>] kthread+0x49/0x76
[39129.989991]  [<ffffffff8020c5ea>] child_rip+0xa/0x20
[39129.990093]  [<ffffffff80248cf5>] ? kthread+0x0/0x76
[39129.990194]  [<ffffffff8020c5e0>] ? child_rip+0x0/0x20
[39129.990295] ata/1         S ffff88007b8f9788     0 21674      2
[39129.990469]  ffff8800744c1ec0 0000000000000046 ffffffff802455cd ffff8800=
01015580
[39129.990772]  ffffffff8069fdc0 ffffffff8069fdc0 ffff8800744c1e40 ffffffff=
8022ff17
[39129.991076]  ffff880032ca7800 ffff880032ca2400 ffff880032ca7a78 00000001=
744b9ed0
[39129.991380] Call Trace:
[39129.991478]  [<ffffffff802455cd>] ? worker_thread+0x0/0xee
[39129.991580]  [<ffffffff8022ff17>] ? finish_task_switch+0x2b/0x8e
[39129.991683]  [<ffffffff80245676>] worker_thread+0xa9/0xee
[39129.991786]  [<ffffffff80249146>] ? autoremove_wake_function+0x0/0x38
[39129.991889]  [<ffffffff802455cd>] ? worker_thread+0x0/0xee
[39129.991992]  [<ffffffff80248d3e>] kthread+0x49/0x76
[39129.992106]  [<ffffffff8020c5ea>] child_rip+0xa/0x20
[39129.992208]  [<ffffffff80248cf5>] ? kthread+0x0/0x76
[39129.992310]  [<ffffffff8020c5e0>] ? child_rip+0x0/0x20
[39129.992411] kblockd/1     S ffff88007c34d688     0 21675      2
[39129.992585]  ffff8800744cbec0 0000000000000046 ffff88007a9c0858 ffff8800=
7a9c0970
[39129.992889]  ffffffff8069fdc0 ffffffff8069fdc0 ffff8800744cbe30 ffffffff=
8033ff8b
[39129.993215]  ffff880032ca2400 ffff88007c062400 ffff880032ca2678 00000001=
80340075
[39129.993524] Call Trace:
[39129.993622]  [<ffffffff8033ff8b>] ? __generic_unplug_device+0x2d/0x32
[39129.993726]  [<ffffffff80347911>] ? as_work_handler+0x0/0x39
[39129.993829]  [<ffffffff8033e6a7>] ? blk_unplug_work+0x7a/0x82
[39129.993931]  [<ffffffff80245676>] worker_thread+0xa9/0xee
[39129.994034]  [<ffffffff80249146>] ? autoremove_wake_function+0x0/0x38
[39129.994138]  [<ffffffff802455cd>] ? worker_thread+0x0/0xee
[39129.994240]  [<ffffffff80248d3e>] kthread+0x49/0x76
[39129.994342]  [<ffffffff8020c5ea>] child_rip+0xa/0x20
[39129.994443]  [<ffffffff80248cf5>] ? kthread+0x0/0x76
[39129.994545]  [<ffffffff8020c5e0>] ? child_rip+0x0/0x20
[39129.994646] work_on_cpu/1 S ffff88007c003e88     0 21676      2
[39129.994818]  ffff88001fd3fec0 0000000000000046 ffff88001fd3fe00 ffffffff=
80231ee4
[39129.995122]  ffffffff8069fdc0 ffffffff8069fdc0 0000000300000000 ffff8800=
744b9ce0
[39129.995426]  ffff880032ca3c00 ffff880032ca0c00 ffff880032ca3e78 00000001=
00000286
[39129.995729] Call Trace:
[39129.995827]  [<ffffffff80231ee4>] ? default_wake_function+0xd/0xf
[39129.995931]  [<ffffffff802458ac>] ? wq_barrier_func+0xd/0xf
[39129.996046]  [<ffffffff80245676>] worker_thread+0xa9/0xee
[39129.996148]  [<ffffffff80249146>] ? autoremove_wake_function+0x0/0x38
[39129.996252]  [<ffffffff802455cd>] ? worker_thread+0x0/0xee
[39129.996354]  [<ffffffff80248d3e>] kthread+0x49/0x76
[39129.996456]  [<ffffffff8020c5ea>] child_rip+0xa/0x20
[39129.996558]  [<ffffffff80248cf5>] ? kthread+0x0/0x76
[39129.996659]  [<ffffffff8020c5e0>] ? child_rip+0x0/0x20
[39129.996760] events/1      S ffff88007c003c88     0 21677      2
[39129.996933]  ffff88001c5c1ec0 0000000000000046 ffff88001c5c1e40 ffffffff=
8023f022
[39129.997262]  ffffffff8069fdc0 ffffffff8069fdc0 0000000000000286 ffff8800=
01022658
[39129.997567]  ffff8800738a7800 ffff88007c062400 ffff8800738a7a78 00000001=
7c003c88
[39129.997871] Call Trace:
[39129.997969]  [<ffffffff8023f022>] ? __mod_timer+0xb2/0xc4
[39129.998071]  [<ffffffff80246155>] ? queue_delayed_work+0x21/0x23
[39129.998174]  [<ffffffff80246170>] ? schedule_delayed_work+0x19/0x1d
[39129.998278]  [<ffffffff8027d6e6>] ? vmstat_update+0x30/0x32
[39129.998380]  [<ffffffff80245676>] worker_thread+0xa9/0xee
[39129.998482]  [<ffffffff80249146>] ? autoremove_wake_function+0x0/0x38
[39129.998586]  [<ffffffff802455cd>] ? worker_thread+0x0/0xee
[39129.998688]  [<ffffffff80248d3e>] kthread+0x49/0x76
[39129.998789]  [<ffffffff8020c5ea>] child_rip+0xa/0x20
[39129.998891]  [<ffffffff80248cf5>] ? kthread+0x0/0x76
[39129.998993]  [<ffffffff8020c5e0>] ? child_rip+0x0/0x20
[39129.999094] pickup        D 00000000ffffffff     0 21854   4087
[39129.999267]  ffff8800424e9d78 0000000000000082 ffff880001019dc0 00000000=
00000000
[39129.999571]  ffffffff8069fdc0 ffffffff8069fdc0 0000000000000000 ffff8800=
01019e30
[39129.999875]  ffff880020d8f200 ffff88005b9c5a00 ffff880020d8f478 00000000=
7b902a38
[39130.000214] Call Trace:
[39130.000313]  [<ffffffff8022ff17>] ? finish_task_switch+0x2b/0x8e
[39130.000422]  [<ffffffff8024e7e0>] refrigerator+0xe7/0xf3
[39130.000524]  [<ffffffff802425b8>] get_signal_to_deliver+0x5a/0x3aa
[39130.000627]  [<ffffffff8020a904>] do_notify_resume+0x8c/0x833
[39130.002435]  [<ffffffff8023ef02>] ? del_timer_sync+0x14/0x20
[39130.002557]  [<ffffffff804cb0ac>] ? schedule_timeout+0xb3/0xcf
[39130.002660]  [<ffffffff8023eb1e>] ? process_timeout+0x0/0xb
[39130.002768]  [<ffffffff802c339b>] ? sys_epoll_wait+0x464/0x47c
[39130.002871]  [<ffffffff80231ed7>] ? default_wake_function+0x0/0xf
[39130.002974]  [<ffffffff8020b735>] sysret_signal+0x6d/0xb7
[39130.003075] qmgr          D 00000000ffffffff     0 21857   4087
[39130.003248]  ffff88007887bd78 0000000000000082 ffff880001019dc0 00000000=
00000000
[39130.003552]  ffffffff8069fdc0 ffffffff8069fdc0 ffff880046804480 ffff8800=
01019e30
[39130.003856]  ffff880020d8bc00 ffff8800795d9e00 ffff880020d8be78 00000000=
7b902a38
[39130.004173] Call Trace:
[39130.004271]  [<ffffffff8022ff17>] ? finish_task_switch+0x2b/0x8e
[39130.004375]  [<ffffffff8024e7e0>] refrigerator+0xe7/0xf3
[39130.004476]  [<ffffffff802425b8>] get_signal_to_deliver+0x5a/0x3aa
[39130.004580]  [<ffffffff8020a904>] do_notify_resume+0x8c/0x833
[39130.004682]  [<ffffffff8023ef02>] ? del_timer_sync+0x14/0x20
[39130.004785]  [<ffffffff804cb0ac>] ? schedule_timeout+0xb3/0xcf
[39130.004887]  [<ffffffff8023eb1e>] ? process_timeout+0x0/0xb
[39130.004990]  [<ffffffff802c339b>] ? sys_epoll_wait+0x464/0x47c
[39130.005094]  [<ffffffff802a6838>] ? do_vfs_ioctl+0x446/0x482
[39130.005215]  [<ffffffff80231ed7>] ? default_wake_function+0x0/0xf
[39130.005318]  [<ffffffff8020b735>] sysret_signal+0x6d/0xb7
[39130.005425] automount     D ffff88000f2cbb78     0 21871   3834
[39130.005599]  ffff88000f2cbb08 0000000000000082 ffff88000f2cba58 ffffffff=
80447a40
[39130.005903]  ffffffff8069fdc0 ffffffff8069fdc0 ffff88000f2cbac8 ffffffff=
a033e204
[39130.006206]  ffff88007c064e00 ffffffff805f0350 ffff88007c065078 00000000=
00000001
[39130.006510] Call Trace:
[39130.006609]  [<ffffffff80447a40>] ? kernel_sendmsg+0x39/0x4e
[39130.006723]  [<ffffffffa033e204>] ? xs_send_kvec+0x7a/0x83 [sunrpc]
[39130.006827]  [<ffffffff8023ee66>] ? lock_timer_base+0x26/0x4a
[39130.006930]  [<ffffffff8023ee66>] ? lock_timer_base+0x26/0x4a
[39130.007044]  [<ffffffffa03409b0>] rpc_wait_bit_killable+0x2c/0x30 [sunrp=
c]
[39130.007149]  [<ffffffff804cb264>] __wait_on_bit+0x47/0x79
[39130.007263]  [<ffffffffa0340984>] ? rpc_wait_bit_killable+0x0/0x30 [sunr=
pc]
[39130.007379]  [<ffffffffa0340984>] ? rpc_wait_bit_killable+0x0/0x30 [sunr=
pc]
[39130.007484]  [<ffffffff804cb300>] out_of_line_wait_on_bit+0x6a/0x77
[39130.007587]  [<ffffffff8024917e>] ? wake_bit_function+0x0/0x2a
[39130.007702]  [<ffffffffa0341130>] __rpc_execute+0xe5/0x22b [sunrpc]
[39130.007818]  [<ffffffffa034129e>] rpc_execute+0x28/0x2c [sunrpc]
[39130.007932]  [<ffffffffa033b5dd>] rpc_run_task+0x56/0x5e [sunrpc]
[39130.008060]  [<ffffffffa033b6d0>] rpc_call_sync+0x3f/0x5d [sunrpc]
[39130.008176]  [<ffffffffa0461e81>] nfs3_rpc_wrapper+0x22/0x5c [nfs]
[39130.008290]  [<ffffffffa04625ba>] nfs3_proc_getattr+0x5b/0x81 [nfs]
[39130.008404]  [<ffffffffa0455d8f>] __nfs_revalidate_inode+0xda/0x1e6 [nfs]
[39130.008508]  [<ffffffff802a1711>] ? path_put+0x2c/0x30
[39130.008610]  [<ffffffff802a4019>] ? path_walk+0xc7/0xd4
[39130.008711]  [<ffffffff802a4202>] ? do_path_lookup+0x180/0x1a0
[39130.008824]  [<ffffffffa0455f3a>] nfs_revalidate_inode+0x44/0x49 [nfs]
[39130.008937]  [<ffffffffa04562fb>] nfs_getattr+0xaf/0xef [nfs]
[39130.009042]  [<ffffffff8029d231>] vfs_getattr+0x44/0x61
[39130.009162]  [<ffffffff8029d334>] vfs_lstat_fd+0x34/0x4b
[39130.009264]  [<ffffffff8029d36d>] sys_newlstat+0x22/0x3c
[39130.009372]  [<ffffffff8029ad1d>] ? fput+0x18/0x1a
[39130.009473]  [<ffffffff8029805c>] ? filp_close+0x67/0x72
[39130.009575]  [<ffffffff8029810c>] ? sys_close+0xa5/0xe4
[39130.009677]  [<ffffffff8020b65b>] system_call_fastpath+0x16/0x1b
[39130.009779] awesome       ? ffff8800049e3ef8     0 22887   4724
[39130.009953]  ffff8800049e3eb8 0000000000000046 ffff8800049e3eb8 ffffffff=
802416f1
[39130.010256]  ffffffff8069fdc0 ffffffff8069fdc0 0000000000000011 ffff8800=
00040001
[39130.010559]  ffff880020d8e600 ffff880074587200 ffff880020d8e878 00000001=
00000000
[39130.010863] Call Trace:
[39130.010961]  [<ffffffff802416f1>] ? do_notify_parent+0x214/0x229
[39130.011064]  [<ffffffff802374a0>] ? put_fs_struct+0x37/0x3c
[39130.011166]  [<ffffffff802394a7>] do_exit+0x7bf/0x7cd
[39130.011268]  [<ffffffff80239528>] do_group_exit+0x73/0xa0
[39130.011369]  [<ffffffff80239567>] sys_exit_group+0x12/0x16
[39130.011471]  [<ffffffff8020b65b>] system_call_fastpath+0x16/0x1b
[39130.011638]  automount
[39130.011737]=20
[39130.011838] Restarting tasks ... done.

--0F1p//8PRICkK4MW--

--qlTNgmc+xy1dBmNv
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkm3aJYACgkQuL75KpiFGIwT+wCfWx0g8ZpxMO4nr0ANnKi4Pr7Q
hrYAnjrKN4x+GSd+RiPeAQrhQRCeZk4Y
=M9nd
-----END PGP SIGNATURE-----

--qlTNgmc+xy1dBmNv--
