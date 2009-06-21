Return-Path: <linux-kernel-owner+w=401wt.eu-S1754745AbZFULaS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754745AbZFULaS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Jun 2009 07:30:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753454AbZFULaH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 21 Jun 2009 07:30:07 -0400
Received: from mx34.mail.ru ([94.100.176.48]:11931 "EHLO mx34.mail.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751261AbZFULaF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Jun 2009 07:30:05 -0400
From: Andrey Borzenkov <arvidjaar@mail.ru>
To: Pekka Enberg <penberg@cs.helsinki.fi>
Subject: Re: Why half of slabs are not shown in /proc/slabinfo?
Date: Sun, 21 Jun 2009 15:30:09 +0400
User-Agent: KMail/1.11.90 (Linux/2.6.30-desktop-2mnb; KDE/4.2.90; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, Christoph Lameter <cl@linux-foundation.org>
References: <200906211152.25100.arvidjaar@mail.ru> <84144f020906210426h6a41ad3csf6d9731663e30834@mail.gmail.com>
In-Reply-To: <84144f020906210426h6a41ad3csf6d9731663e30834@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart155702889.omCSHupfMd";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200906211530.13463.arvidjaar@mail.ru>
X-Spam: Not detected
X-Mras: Ok
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart155702889.omCSHupfMd
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Sunday 21 of June 2009 15:26:15 Pekka Enberg wrote:
> On Sun, Jun 21, 2009 at 10:52 AM, Andrey Borzenkov<arvidjaar@mail.ru>=20
wrote:
> > Mandriva kernel 2.6.30 using SLUB:
> >
> > {pts/1}% grep SLUB /boot/config
> > CONFIG_SLUB_DEBUG=3Dy
> > CONFIG_SLUB=3Dy
> > # CONFIG_SLUB_DEBUG_ON is not set
> > # CONFIG_SLUB_STATS is not set
> >
> > Some of slabs (e.g. filp) are not shown in /proc/slabinfo;
> > comparing number of entries under /sys and slabinfo results in
> >
> > {pts/0}% =3Dls -1 /sys/kernel/slab | grep -v : | wc -l
> > 131
> > {pts/0}% wc -l /proc/slabinfo
> > 68 /proc/slabinfo
> > {pts/0}%
> >
> > so almost half of the all entries are missing. Is it expected or
> > there is something wrong here?
>
> Can you post the actual file listing of /sys/kernel/slab and the
> contents of /proc/slabinfo?
>

Sure.

{pts/1}% ls -l /sys/kernel/slab=20
=D0=B8=D1=82=D0=BE=D0=B3=D0=BE 0                        =20
drwxr-xr-x 2 root root 0 2009-06-21 00:46 :0000008/
drwxr-xr-x 2 root root 0 2009-06-21 00:46 :0000016/
drwxr-xr-x 2 root root 0 2009-06-21 00:46 :0000024/
drwxr-xr-x 2 root root 0 2009-06-21 00:46 :0000032/
drwxr-xr-x 2 root root 0 2009-06-21 00:46 :0000040/
drwxr-xr-x 2 root root 0 2009-06-21 00:46 :0000048/
drwxr-xr-x 2 root root 0 2009-06-21 11:29 :0000056/
drwxr-xr-x 2 root root 0 2009-06-21 00:46 :0000064/
drwxr-xr-x 2 root root 0 2009-06-21 00:46 :0000072/
drwxr-xr-x 2 root root 0 2009-06-21 00:46 :0000080/
drwxr-xr-x 2 root root 0 2009-06-21 00:46 :0000096/
drwxr-xr-x 2 root root 0 2009-06-21 00:46 :0000112/
drwxr-xr-x 2 root root 0 2009-06-21 00:46 :0000128/
drwxr-xr-x 2 root root 0 2009-06-21 00:46 :0000160/
drwxr-xr-x 2 root root 0 2009-06-21 00:46 :0000168/
drwxr-xr-x 2 root root 0 2009-06-21 00:46 :0000176/
drwxr-xr-x 2 root root 0 2009-06-21 00:46 :0000192/
drwxr-xr-x 2 root root 0 2009-06-21 00:46 :0000256/
drwxr-xr-x 2 root root 0 2009-06-21 00:46 :0000312/
drwxr-xr-x 2 root root 0 2009-06-21 15:28 :0000320/
drwxr-xr-x 2 root root 0 2009-06-21 00:46 :0000328/
drwxr-xr-x 2 root root 0 2009-06-21 00:46 :0000368/
drwxr-xr-x 2 root root 0 2009-06-21 00:46 :0000384/
drwxr-xr-x 2 root root 0 2009-06-21 15:28 :0000408/
drwxr-xr-x 2 root root 0 2009-06-21 00:46 :0000512/
drwxr-xr-x 2 root root 0 2009-06-21 00:46 :0000544/
drwxr-xr-x 2 root root 0 2009-06-21 00:46 :0000704/
drwxr-xr-x 2 root root 0 2009-06-21 00:46 :0000768/
drwxr-xr-x 2 root root 0 2009-06-21 00:46 :0000832/
drwxr-xr-x 2 root root 0 2009-06-21 00:46 :0000960/
drwxr-xr-x 2 root root 0 2009-06-21 00:46 :0001024/
drwxr-xr-x 2 root root 0 2009-06-21 15:28 :0001064/
drwxr-xr-x 2 root root 0 2009-06-21 00:46 :0002048/
drwxr-xr-x 2 root root 0 2009-06-21 00:46 :0002272/
drwxr-xr-x 2 root root 0 2009-06-21 15:28 :0002608/
drwxr-xr-x 2 root root 0 2009-06-21 00:46 :0004096/
drwxr-xr-x 2 root root 0 2009-06-21 00:46 :0005664/
drwxr-xr-x 2 root root 0 2009-06-21 00:46 :0008192/
drwxr-xr-x 2 root root 0 2009-06-20 23:00 :0012288/
drwxr-xr-x 2 root root 0 2009-06-21 00:46 :a-0000088/
drwxr-xr-x 2 root root 0 2009-06-21 00:46 :a-0000192/
drwxr-xr-x 2 root root 0 2009-06-21 00:46 :a-0000256/
lrwxrwxrwx 1 root root 0 2009-06-21 00:46 Acpi-Namespace -> :0000032/
lrwxrwxrwx 1 root root 0 2009-06-21 00:46 Acpi-Operand -> :0000072/ =20
lrwxrwxrwx 1 root root 0 2009-06-21 00:46 Acpi-Parse -> :0000048/   =20
lrwxrwxrwx 1 root root 0 2009-06-21 00:46 Acpi-ParseExt -> :0000072/=20
lrwxrwxrwx 1 root root 0 2009-06-21 00:46 Acpi-State -> :0000080/   =20
drwxr-xr-x 2 root root 0 2009-06-21 00:46 anon_vma/                 =20
lrwxrwxrwx 1 root root 0 2009-06-21 00:46 arp_cache -> :0000256/    =20
drwxr-xr-x 2 root root 0 2009-06-21 00:46 bdev_cache/               =20
lrwxrwxrwx 1 root root 0 2009-06-21 00:46 bio-0 -> :0000192/        =20
lrwxrwxrwx 1 root root 0 2009-06-21 00:46 bio_integrity_payload ->=20
:0000128/
lrwxrwxrwx 1 root root 0 2009-06-21 00:46 biovec-1 -> :0000016/            =
=20
lrwxrwxrwx 1 root root 0 2009-06-21 00:46 biovec-128 -> :0002048/          =
=20
lrwxrwxrwx 1 root root 0 2009-06-21 00:46 biovec-16 -> :0000256/           =
=20
lrwxrwxrwx 1 root root 0 2009-06-21 00:46 biovec-256 -> :0004096/          =
=20
lrwxrwxrwx 1 root root 0 2009-06-21 00:46 biovec-4 -> :0000064/            =
=20
lrwxrwxrwx 1 root root 0 2009-06-21 00:46 biovec-64 -> :0001024/           =
=20
lrwxrwxrwx 1 root root 0 2009-06-21 00:46 blkdev_integrity -> :0000112/    =
=20
lrwxrwxrwx 1 root root 0 2009-06-21 00:46 blkdev_ioc -> :0000072/          =
=20
lrwxrwxrwx 1 root root 0 2009-06-21 00:46 blkdev_queue -> :0002272/        =
=20
lrwxrwxrwx 1 root root 0 2009-06-21 00:46 blkdev_requests -> :0000368/     =
=20
lrwxrwxrwx 1 root root 0 2009-06-21 00:46 bridge_fdb_cache -> :0000064/    =
=20
lrwxrwxrwx 1 root root 0 2009-06-21 00:46 bsg_cmd -> :0000312/             =
=20
drwxr-xr-x 2 root root 0 2009-06-21 00:46 buffer_head/                     =
=20
lrwxrwxrwx 1 root root 0 2009-06-21 00:46 cfq_io_context -> :0000168/      =
=20
lrwxrwxrwx 1 root root 0 2009-06-21 00:46 cfq_queue -> :0000168/           =
=20
lrwxrwxrwx 1 root root 0 2009-06-21 00:46 cred_jar -> :0000192/            =
=20
drwxr-xr-x 2 root root 0 2009-06-21 11:29 :d-0000512/                      =
=20
lrwxrwxrwx 1 root root 0 2009-06-21 00:46 dentry -> :a-0000192/            =
=20
lrwxrwxrwx 1 root root 0 2009-06-21 00:46 dm_io -> :0000032/               =
=20
lrwxrwxrwx 1 root root 0 2009-06-21 00:46 dm_raid1_read_record ->=20
:0001064/=20
lrwxrwxrwx 1 root root 0 2009-06-21 00:46 dm_rq_clone_bio_info ->=20
:0000016/=20
lrwxrwxrwx 1 root root 0 2009-06-21 00:46 dm_rq_target_io -> :0000408/     =
=20
lrwxrwxrwx 1 root root 0 2009-06-21 00:46 dm_target_io -> :0000024/        =
=20
lrwxrwxrwx 1 root root 0 2009-06-21 00:46 dm_uevent -> :0002608/           =
=20
lrwxrwxrwx 1 root root 0 2009-06-21 00:46 dnotify_cache -> :0000040/       =
=20
lrwxrwxrwx 1 root root 0 2009-06-21 00:46 dquot -> :a-0000256/             =
=20
lrwxrwxrwx 1 root root 0 2009-06-21 00:46 eventpoll_epi -> :0000128/       =
=20
lrwxrwxrwx 1 root root 0 2009-06-21 00:46 eventpoll_pwq -> :0000072/       =
=20
drwxr-xr-x 2 root root 0 2009-06-21 00:46 ext2_inode_cache/                =
=20
lrwxrwxrwx 1 root root 0 2009-06-21 00:46 ext2_xattr -> :a-0000088/        =
=20
lrwxrwxrwx 1 root root 0 2009-06-21 00:46 fasync_cache -> :0000024/        =
=20
lrwxrwxrwx 1 root root 0 2009-06-21 00:46 fib6_nodes -> :0000064/          =
=20
drwxr-xr-x 2 root root 0 2009-06-21 00:46 file_lock_cache/                 =
=20
lrwxrwxrwx 1 root root 0 2009-06-21 00:46 files_cache -> :0000704/         =
=20
lrwxrwxrwx 1 root root 0 2009-06-21 00:46 filp -> :0000192/                =
=20
lrwxrwxrwx 1 root root 0 2009-06-21 00:46 flow_cache -> :0000096/          =
=20
lrwxrwxrwx 1 root root 0 2009-06-21 00:46 fs_cache -> :0000064/            =
=20
drwxr-xr-x 2 root root 0 2009-06-21 00:46 hugetlbfs_inode_cache/           =
=20
lrwxrwxrwx 1 root root 0 2009-06-21 00:46 idr_layer_cache -> :0000544/     =
=20
lrwxrwxrwx 1 root root 0 2009-06-21 00:46 inet_peer_cache -> :0000064/     =
=20
drwxr-xr-x 2 root root 0 2009-06-21 00:46 inode_cache/                     =
=20
lrwxrwxrwx 1 root root 0 2009-06-21 00:46 inotify_event_cache ->=20
:0000040/ =20
lrwxrwxrwx 1 root root 0 2009-06-21 00:46 inotify_watch_cache ->=20
:0000072/ =20
lrwxrwxrwx 1 root root 0 2009-06-21 00:46 ip6_dst_cache -> :0000320/       =
=20
lrwxrwxrwx 1 root root 0 2009-06-21 00:46 ip6_mrt_cache -> :0000128/       =
=20
lrwxrwxrwx 1 root root 0 2009-06-21 00:46 ip_dst_cache -> :0000384/        =
=20
lrwxrwxrwx 1 root root 0 2009-06-21 00:46 ip_fib_alias -> :0000032/        =
=20
lrwxrwxrwx 1 root root 0 2009-06-21 00:46 ip_fib_hash -> :0000072/         =
=20
lrwxrwxrwx 1 root root 0 2009-06-21 00:46 ip_mrt_cache -> :0000128/        =
=20
lrwxrwxrwx 1 root root 0 2009-06-21 00:46 kcopyd_job -> :0000368/          =
=20
lrwxrwxrwx 1 root root 0 2009-06-21 00:46 key_jar -> :0000192/             =
=20
lrwxrwxrwx 1 root root 0 2009-06-21 00:46 kiocb -> :0000256/               =
=20
lrwxrwxrwx 1 root root 0 2009-06-21 00:46 kioctx -> :0000384/              =
=20
lrwxrwxrwx 1 root root 0 2009-06-21 00:46 kmalloc-1024 -> :0001024/        =
=20
lrwxrwxrwx 1 root root 0 2009-06-21 00:46 kmalloc-128 -> :0000128/         =
=20
lrwxrwxrwx 1 root root 0 2009-06-21 00:46 kmalloc-16 -> :0000016/          =
=20
lrwxrwxrwx 1 root root 0 2009-06-21 00:46 kmalloc-192 -> :0000192/         =
=20
lrwxrwxrwx 1 root root 0 2009-06-21 00:46 kmalloc-2048 -> :0002048/        =
=20
lrwxrwxrwx 1 root root 0 2009-06-21 00:46 kmalloc-256 -> :0000256/         =
=20
lrwxrwxrwx 1 root root 0 2009-06-21 00:46 kmalloc-32 -> :0000032/          =
=20
lrwxrwxrwx 1 root root 0 2009-06-21 00:46 kmalloc-4096 -> :0004096/        =
=20
lrwxrwxrwx 1 root root 0 2009-06-21 00:46 kmalloc-512 -> :0000512/         =
=20
lrwxrwxrwx 1 root root 0 2009-06-21 00:46 kmalloc-64 -> :0000064/          =
=20
lrwxrwxrwx 1 root root 0 2009-06-21 00:46 kmalloc-8 -> :0000008/           =
=20
lrwxrwxrwx 1 root root 0 2009-06-21 00:46 kmalloc-8192 -> :0008192/        =
=20
lrwxrwxrwx 1 root root 0 2009-06-21 00:46 kmalloc-96 -> :0000096/          =
=20
lrwxrwxrwx 1 root root 0 2009-06-21 00:46 kmalloc_dma-512 -> :d-0000512/   =
=20
drwxr-xr-x 2 root root 0 2009-06-21 00:46 kmem_cache_node/                 =
=20
lrwxrwxrwx 1 root root 0 2009-06-21 00:46 mm_struct -> :0000832/           =
=20
lrwxrwxrwx 1 root root 0 2009-06-21 00:46 mnt_cache -> :0000256/           =
=20
drwxr-xr-x 2 root root 0 2009-06-21 00:46 mqueue_inode_cache/              =
=20
lrwxrwxrwx 1 root root 0 2009-06-21 00:46 names_cache -> :0004096/         =
=20
lrwxrwxrwx 1 root root 0 2009-06-21 00:46 ndisc_cache -> :0000256/         =
=20
lrwxrwxrwx 1 root root 0 2009-06-21 00:46 nsproxy -> :0000048/             =
=20
lrwxrwxrwx 1 root root 0 2009-06-21 00:46 numa_policy -> :0000024/         =
=20
lrwxrwxrwx 1 root root 0 2009-06-21 00:46 nv_pte_t -> :0000032/            =
=20
lrwxrwxrwx 1 root root 0 2009-06-21 00:46 nv_stack_t -> :0012288/          =
=20
lrwxrwxrwx 1 root root 0 2009-06-21 00:46 pid -> :0000128/                 =
=20
lrwxrwxrwx 1 root root 0 2009-06-21 00:46 posix_timers_cache ->=20
:0000192/  =20
drwxr-xr-x 2 root root 0 2009-06-21 00:46 proc_inode_cache/                =
=20
drwxr-xr-x 2 root root 0 2009-06-21 00:46 radix_tree_node/                 =
=20
lrwxrwxrwx 1 root root 0 2009-06-21 00:46 RAW -> :0000768/                 =
=20
lrwxrwxrwx 1 root root 0 2009-06-21 00:46 RAWv6 -> :0000960/               =
=20
drwxr-xr-x 2 root root 0 2009-06-21 00:46 reiser_inode_cache/              =
=20
lrwxrwxrwx 1 root root 0 2009-06-21 00:46 request_sock_TCP -> :0000128/    =
=20
lrwxrwxrwx 1 root root 0 2009-06-21 00:46 request_sock_TCPv6 ->=20
:0000192/  =20
lrwxrwxrwx 1 root root 0 2009-06-21 00:46 scsi_cmd_cache -> :0000256/      =
=20
lrwxrwxrwx 1 root root 0 2009-06-21 00:46 scsi_data_buffer -> :0000024/
lrwxrwxrwx 1 root root 0 2009-06-21 00:46 scsi_sense_cache -> :0000128/
lrwxrwxrwx 1 root root 0 2009-06-21 00:46 secpath_cache -> :0000064/
lrwxrwxrwx 1 root root 0 2009-06-21 00:46 sgpool-128 -> :0004096/
lrwxrwxrwx 1 root root 0 2009-06-21 00:46 sgpool-16 -> :0000512/
lrwxrwxrwx 1 root root 0 2009-06-21 00:46 sgpool-32 -> :0001024/
lrwxrwxrwx 1 root root 0 2009-06-21 00:46 sgpool-64 -> :0002048/
lrwxrwxrwx 1 root root 0 2009-06-21 00:46 sgpool-8 -> :0000256/
lrwxrwxrwx 1 root root 0 2009-06-21 00:46 shared_policy_node ->=20
:0000048/
drwxr-xr-x 2 root root 0 2009-06-21 00:46 shmem_inode_cache/
drwxr-xr-x 2 root root 0 2009-06-21 00:46 sighand_cache/
lrwxrwxrwx 1 root root 0 2009-06-21 00:46 signal_cache -> :0000960/
lrwxrwxrwx 1 root root 0 2009-06-21 00:46 sigqueue -> :0000160/
lrwxrwxrwx 1 root root 0 2009-06-21 00:46 skbuff_fclone_cache ->=20
:0000512/
lrwxrwxrwx 1 root root 0 2009-06-21 00:46 skbuff_head_cache -> :0000256/
drwxr-xr-x 2 root root 0 2009-06-21 00:46 sock_inode_cache/
lrwxrwxrwx 1 root root 0 2009-06-21 00:46 sysfs_dir_cache -> :0000080/
lrwxrwxrwx 1 root root 0 2009-06-21 00:46 task_delay_info -> :0000112/
lrwxrwxrwx 1 root root 0 2009-06-21 00:46 taskstats -> :0000328/
lrwxrwxrwx 1 root root 0 2009-06-21 00:46 task_struct -> :0005664/
lrwxrwxrwx 1 root root 0 2009-06-21 00:46 task_xstate -> :0000512/
drwxr-xr-x 2 root root 0 2009-06-21 00:46 TCP/
lrwxrwxrwx 1 root root 0 2009-06-21 00:46 tcp_bind_bucket -> :0000032/
drwxr-xr-x 2 root root 0 2009-06-21 15:28 TCPv6/
drwxr-xr-x 2 root root 0 2009-06-21 00:46 tw_sock_TCP/
drwxr-xr-x 2 root root 0 2009-06-21 15:28 tw_sock_TCPv6/
drwxr-xr-x 2 root root 0 2009-06-21 00:46 UDP/
drwxr-xr-x 2 root root 0 2009-06-21 00:46 UDP-Lite/
drwxr-xr-x 2 root root 0 2009-06-21 15:28 UDPLITEv6/
drwxr-xr-x 2 root root 0 2009-06-21 15:28 UDPv6/
lrwxrwxrwx 1 root root 0 2009-06-21 00:46 uhci_urb_priv -> :0000056/
lrwxrwxrwx 1 root root 0 2009-06-21 00:46 uid_cache -> :0000128/
lrwxrwxrwx 1 root root 0 2009-06-21 00:46 UNIX -> :0000768/
lrwxrwxrwx 1 root root 0 2009-06-21 00:46 vm_area_struct -> :0000176/
lrwxrwxrwx 1 root root 0 2009-06-21 00:46 xfrm_dst_cache -> :0000384/
{pts/1}%

{pts/1}% cat /proc/slabinfo=20
slabinfo - version: 2.1    =20
# name            <active_objs> <num_objs> <objsize> <objperslab>=20
<pagesperslab> : tunables <limit> <batchcount> <sharedfactor> : slabdata=20
<active_slabs> <num_slabs> <sharedavail>                                   =
                         =20
nv_stack_t            30     30  12288    2    8 : tunables    0    0   =20
0 : slabdata     15     15      0                                          =
           =20
ip6_dst_cache         25     36    320   12    1 : tunables    0    0   =20
0 : slabdata      3      3      0                                          =
           =20
UDPLITEv6              0      0    960   17    4 : tunables    0    0   =20
0 : slabdata      0      0      0                                          =
           =20
UDPv6                 19     34    960   17    4 : tunables    0    0   =20
0 : slabdata      2      2      0                                          =
           =20
tw_sock_TCPv6          0      0    192   21    1 : tunables    0    0   =20
0 : slabdata      0      0      0                                          =
           =20
TCPv6                 22     36   1792   18    8 : tunables    0    0   =20
0 : slabdata      2      2      0                                          =
           =20
dm_raid1_read_record      0      0   1064   15    4 : tunables    0    0   =
=20
0 : slabdata      0      0      0                                          =
        =20
dm_uevent              0      0   2608   12    8 : tunables    0    0   =20
0 : slabdata      0      0      0                                          =
           =20
dm_rq_target_io        0      0    408   20    2 : tunables    0    0   =20
0 : slabdata      0      0      0                                          =
           =20
uhci_urb_priv        146    146     56   73    1 : tunables    0    0   =20
0 : slabdata      2      2      0                                          =
           =20
kmalloc_dma-512        0     16    512   16    2 : tunables    0    0   =20
0 : slabdata      1      1      0                                          =
           =20
reiser_inode_cache  46837  53086    728   22    4 : tunables    0    0   =20
0 : slabdata   2413   2413      0                                          =
          =20
cfq_queue            194    216    168   24    1 : tunables    0    0   =20
0 : slabdata      9      9      0                                          =
           =20
bsg_cmd                0      0    312   13    1 : tunables    0    0   =20
0 : slabdata      0      0      0                                          =
           =20
mqueue_inode_cache     18     18    896   18    4 : tunables    0    0   =20
0 : slabdata      1      1      0                                          =
          =20
hugetlbfs_inode_cache     13     13    600   13    2 : tunables    0   =20
0    0 : slabdata      1      1      0                                     =
            =20
ext2_inode_cache      21     40    784   20    4 : tunables    0    0   =20
0 : slabdata      2      2      0                                          =
           =20
ext2_xattr             0      0     88   46    1 : tunables    0    0   =20
0 : slabdata      0      0      0                                          =
           =20
dquot                  0      0    256   16    1 : tunables    0    0   =20
0 : slabdata      0      0      0                                          =
           =20
dnotify_cache        204    204     40  102    1 : tunables    0    0   =20
0 : slabdata      2      2      0                                          =
           =20
shmem_inode_cache   1927   1940    808   20    4 : tunables    0    0   =20
0 : slabdata     97     97      0                                          =
           =20
UDP-Lite               0      0    832   19    4 : tunables    0    0   =20
0 : slabdata      0      0      0                                          =
           =20
ip_dst_cache          66     84    384   21    2 : tunables    0    0   =20
0 : slabdata      4      4      0                                          =
           =20
RAW                  426    462    768   21    4 : tunables    0    0   =20
0 : slabdata     22     22      0                                          =
           =20
UDP                   38     38    832   19    4 : tunables    0    0   =20
0 : slabdata      2      2      0                                          =
           =20
tw_sock_TCP           21     42    192   21    1 : tunables    0    0   =20
0 : slabdata      2      2      0                                          =
           =20
TCP                   43     57   1664   19    8 : tunables    0    0   =20
0 : slabdata      3      3      0                                          =
           =20
blkdev_queue          30     42   2272   14    8 : tunables    0    0   =20
0 : slabdata      3      3      0                                          =
           =20
blkdev_requests       52     66    368   22    2 : tunables    0    0   =20
0 : slabdata      3      3      0                                          =
           =20
sock_inode_cache     501    529    704   23    4 : tunables    0    0   =20
0 : slabdata     23     23      0                                          =
           =20
file_lock_cache       44     44    184   22    1 : tunables    0    0   =20
0 : slabdata      2      2      0                                          =
           =20
Acpi-ParseExt       1829   1848     72   56    1 : tunables    0    0   =20
0 : slabdata     33     33      0                                          =
           =20
task_delay_info      280    324    112   36    1 : tunables    0    0   =20
0 : slabdata      9      9      0                                          =
           =20
taskstats             19     24    328   12    1 : tunables    0    0   =20
0 : slabdata      2      2      0                                          =
           =20
proc_inode_cache    1991   2000    632   25    4 : tunables    0    0   =20
0 : slabdata     80     80      0                                          =
           =20
sigqueue              50     50    160   25    1 : tunables    0    0   =20
0 : slabdata      2      2      0                                          =
           =20
radix_tree_node    23294  23618    560   14    2 : tunables    0    0   =20
0 : slabdata   1687   1687      0                                          =
           =20
bdev_cache            23     38    832   19    4 : tunables    0    0   =20
0 : slabdata      2      2      0                                          =
           =20
sysfs_dir_cache    12548  12597     80   51    1 : tunables    0    0   =20
0 : slabdata    247    247      0                                          =
           =20
inode_cache         3487   4144    584   14    2 : tunables    0    0   =20
0 : slabdata    296    296      0                                          =
           =20
dentry             34096  34104    192   21    1 : tunables    0    0   =20
0 : slabdata   1624   1624      0                                          =
           =20
buffer_head       126690 134172    112   36    1 : tunables    0    0   =20
0 : slabdata   3727   3727      0                                          =
           =20
vm_area_struct     23015  23621    176   23    1 : tunables    0    0   =20
0 : slabdata   1027   1027      0                                          =
           =20
mm_struct            131    152    832   19    4 : tunables    0    0   =20
0 : slabdata      8      8      0                                          =
           =20
files_cache          138    161    704   23    4 : tunables    0    0   =20
0 : slabdata      7      7      0                                          =
           =20
signal_cache         193    221    960   17    4 : tunables    0    0   =20
0 : slabdata     13     13      0                                          =
           =20
sighand_cache        180    210   2112   15    8 : tunables    0    0   =20
0 : slabdata     14     14      0                                          =
           =20
task_struct          255    280   5664    5    8 : tunables    0    0   =20
0 : slabdata     56     56      0                                          =
           =20
anon_vma            3860   4096     32  128    1 : tunables    0    0   =20
0 : slabdata     32     32      0
shared_policy_node    170    170     48   85    1 : tunables    0    0   =20
0 : slabdata      2      2      0
numa_policy          340    340     24  170    1 : tunables    0    0   =20
0 : slabdata      2      2      0
idr_layer_cache      434    450    544   15    2 : tunables    0    0   =20
0 : slabdata     30     30      0
kmalloc-8192          45     52   8192    4    8 : tunables    0    0   =20
0 : slabdata     13     13      0
kmalloc-4096         530    544   4096    8    8 : tunables    0    0   =20
0 : slabdata     68     68      0
kmalloc-2048         376    400   2048   16    8 : tunables    0    0   =20
0 : slabdata     25     25      0
kmalloc-1024        4747   4784   1024   16    4 : tunables    0    0   =20
0 : slabdata    299    299      0
kmalloc-512         2306   2320    512   16    2 : tunables    0    0   =20
0 : slabdata    145    145      0
kmalloc-256         4781   4800    256   16    1 : tunables    0    0   =20
0 : slabdata    300    300      0
kmalloc-128         2021   2048    128   32    1 : tunables    0    0   =20
0 : slabdata     64     64      0
kmalloc-64         13690  13696     64   64    1 : tunables    0    0   =20
0 : slabdata    214    214      0
kmalloc-32          3677   5504     32  128    1 : tunables    0    0   =20
0 : slabdata     43     43      0
kmalloc-16          3310   3328     16  256    1 : tunables    0    0   =20
0 : slabdata     13     13      0
kmalloc-8           4588   4608      8  512    1 : tunables    0    0   =20
0 : slabdata      9      9      0
kmalloc-192         8748   9177    192   21    1 : tunables    0    0   =20
0 : slabdata    437    437      0
kmalloc-96          6536   6552     96   42    1 : tunables    0    0   =20
0 : slabdata    156    156      0
kmem_cache_node        0      0     64   64    1 : tunables    0    0   =20
0 : slabdata      0      0      0
{pts/1}%

--nextPart155702889.omCSHupfMd
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAko+GcEACgkQR6LMutpd94yfTQCfcG0B8hbmz913PpoIOqYO+ZVy
Um8An32SJOPF8ulDVPMzeOX2n+81YZWU
=9vFI
-----END PGP SIGNATURE-----

--nextPart155702889.omCSHupfMd--
