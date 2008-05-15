Return-Path: <linux-kernel-owner+w=401wt.eu-S932098AbYEOLC1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932098AbYEOLC1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2008 07:02:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759425AbYEOLCH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 May 2008 07:02:07 -0400
Received: from mail.numalliance.com ([213.41.233.134]:57260 "EHLO
	mail.numalliance.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759344AbYEOLCC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2008 07:02:02 -0400
Message-ID: <482C175E.9000604@free.fr>
Date: Thu, 15 May 2008 12:58:38 +0200
From: =?ISO-8859-1?Q?St=E9phane_ANCELOT?= <sancelot@free.fr>
User-Agent: Thunderbird 2.0.0.14 (X11/20080513)
MIME-Version: 1.0
Cc: linux-kernel@vger.kernel.org
Subject: Re: detecting kernel mem leak
References: <1209462094.4816ed4e93977@imp.free.fr>	 <84144f020804290546h666983aci77fbb08eb507e777@mail.gmail.com>	 <Pine.LNX.4.64.0804290956360.10847@schroedinger.engr.sgi.com>	 <4821C526.8030901@free.fr>	 <Pine.LNX.4.64.0805071020210.3173@schroedinger.engr.sgi.com>	 <4829566B.7090804@free.fr> <84144f020805131245l13d9770hce8447f5665a5289@mail.gmail.com>
In-Reply-To: <84144f020805131245l13d9770hce8447f5665a5289@mail.gmail.com>
X-Enigmail-Version: 0.95.6
Content-Type: multipart/mixed;
 boundary="------------040605070708010608080700"
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------040605070708010608080700
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit



Pekka Enberg a écrit :
> On Tue, May 13, 2008 at 11:50 AM, Stéphane ANCELOT <sancelot@free.fr> wrote:
>   
>>  The are some signifiant changes in slabinfo but now, I do not know where
>>  to search ?
>>     
>
> Can you please post your full dmesg, /proc/slabinfo and /proc/meminfo
> output please?
> --
>   
Enclosed are outputs.

However, after some analyzes and enabling DEBUG mem features of the 
kernel , I found anormal proc_inode_cache , and a bug in fork process 
(my kernel has got  patches enabling Realtime features)
This has been corrected, but know, I am waiting again for new results of 
stability , there may be other problems.
Best Regards
Steph
 
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
>
>   

--------------040605070708010608080700
Content-Type: text/plain;
 name="v1m.txt"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="v1m.txt"

MemTotal:       223328 kB
MemFree:         24324 kB
Buffers:          3956 kB
Cached:          34080 kB
SwapCached:          0 kB
Active:         131176 kB
Inactive:        26708 kB
SwapTotal:           0 kB
SwapFree:            0 kB
Dirty:              44 kB
Writeback:           0 kB
AnonPages:      119868 kB
Mapped:       4294834120 kB
Slab:             4692 kB
SReclaimable:     1480 kB
SUnreclaim:       3212 kB
PageTables:        836 kB
NFS_Unstable:        0 kB
Bounce:              0 kB
CommitLimit:    111664 kB
Committed_AS:    45072 kB
VmallocTotal:   810720 kB
VmallocUsed:      3328 kB
VmallocChunk:   807132 kB
slabinfo - version: 2.1
# name            <active_objs> <num_objs> <objsize> <objperslab> <pagesperslab> : tunables <limit> <batchcount> <sharedfactor> : slabdata <active_slabs> <num_slabs> <sharedavail>
ip_fib_alias           9    113     32  113    1 : tunables  120   60    0 : slabdata      1      1      0
ip_fib_hash            9    113     32  113    1 : tunables  120   60    0 : slabdata      1      1      0
rpc_buffers            8      8   2048    2    1 : tunables   24   12    0 : slabdata      4      4      0
rpc_tasks              8     20    192   20    1 : tunables  120   60    0 : slabdata      1      1      0
rpc_inode_cache        0      0    448    9    1 : tunables   54   27    0 : slabdata      0      0      0
UNIX                  32     40    384   10    1 : tunables   54   27    0 : slabdata      4      4      0
flow_cache             0      0    128   30    1 : tunables  120   60    0 : slabdata      0      0      0
uhci_urb_priv          0      0     28  127    1 : tunables  120   60    0 : slabdata      0      0      0
cfq_io_context         0      0     80   48    1 : tunables  120   60    0 : slabdata      0      0      0
cfq_queue              0      0     84   46    1 : tunables  120   60    0 : slabdata      0      0      0
nfs_direct_cache       0      0     68   56    1 : tunables  120   60    0 : slabdata      0      0      0
nfs_write_data        36     36    448    9    1 : tunables   54   27    0 : slabdata      4      4      0
nfs_read_data         32     36    448    9    1 : tunables   54   27    0 : slabdata      4      4      0
nfs_inode_cache        0      0    536    7    1 : tunables   54   27    0 : slabdata      0      0      0
nfs_page               0      0     64   59    1 : tunables  120   60    0 : slabdata      0      0      0
isofs_inode_cache      0      0    316   12    1 : tunables   54   27    0 : slabdata      0      0      0
fat_inode_cache        0      0    340   11    1 : tunables   54   27    0 : slabdata      0      0      0
fat_cache              0      0     20  169    1 : tunables  120   60    0 : slabdata      0      0      0
ext2_inode_cache       0      0    424    9    1 : tunables   54   27    0 : slabdata      0      0      0
ext2_xattr             0      0     44   84    1 : tunables  120   60    0 : slabdata      0      0      0
journal_handle        16    169     20  169    1 : tunables  120   60    0 : slabdata      1      1      0
journal_head          22     72     52   72    1 : tunables  120   60    0 : slabdata      1      1      0
revoke_table           2    254     12  254    1 : tunables  120   60    0 : slabdata      1      1      0
revoke_record          0      0     16  203    1 : tunables  120   60    0 : slabdata      0      0      0
ext3_inode_cache    1764   1764    432    9    1 : tunables   54   27    0 : slabdata    196    196      0
ext3_xattr             0      0     44   84    1 : tunables  120   60    0 : slabdata      0      0      0
dnotify_cache          0      0     20  169    1 : tunables  120   60    0 : slabdata      0      0      0
inotify_event_cache      0      0     28  127    1 : tunables  120   60    0 : slabdata      0      0      0
inotify_watch_cache      0      0     40   92    1 : tunables  120   60    0 : slabdata      0      0      0
kioctx                 0      0    192   20    1 : tunables  120   60    0 : slabdata      0      0      0
kiocb                  0      0    192   20    1 : tunables  120   60    0 : slabdata      0      0      0
fasync_cache           1    203     16  203    1 : tunables  120   60    0 : slabdata      1      1      0
shmem_inode_cache     47     50    380   10    1 : tunables   54   27    0 : slabdata      5      5      0
nsproxy                0      0     28  127    1 : tunables  120   60    0 : slabdata      0      0      0
posix_timers_cache      0      0     88   44    1 : tunables  120   60    0 : slabdata      0      0      0
uid_cache              2     30    128   30    1 : tunables  120   60    0 : slabdata      1      1      0
ip_mrt_cache           0      0    128   30    1 : tunables  120   60    0 : slabdata      0      0      0
UDP-Lite               0      0    512    7    1 : tunables   54   27    0 : slabdata      0      0      0
tcp_bind_bucket       16    203     16  203    1 : tunables  120   60    0 : slabdata      1      1      0
inet_peer_cache        0      0     64   59    1 : tunables  120   60    0 : slabdata      0      0      0
secpath_cache          0      0     32  113    1 : tunables  120   60    0 : slabdata      0      0      0
xfrm_dst_cache         0      0    320   12    1 : tunables   54   27    0 : slabdata      0      0      0
ip_dst_cache          60     60    256   15    1 : tunables  120   60    0 : slabdata      4      4      0
arp_cache              2     30    128   30    1 : tunables  120   60    0 : slabdata      1      1      0
RAW                    2      9    448    9    1 : tunables   54   27    0 : slabdata      1      1      0
UDP                    4      7    512    7    1 : tunables   54   27    0 : slabdata      1      1      0
tw_sock_TCP            0      0    128   30    1 : tunables  120   60    0 : slabdata      0      0      0
request_sock_TCP       0      0     64   59    1 : tunables  120   60    0 : slabdata      0      0      0
TCP                   16     21   1088    7    2 : tunables   24   12    0 : slabdata      3      3      0
eventpoll_pwq          0      0     36  101    1 : tunables  120   60    0 : slabdata      0      0      0
eventpoll_epi          0      0    128   30    1 : tunables  120   60    0 : slabdata      0      0      0
sgpool-128             2      2   2048    2    1 : tunables   24   12    0 : slabdata      1      1      0
sgpool-64              2      4   1024    4    1 : tunables   54   27    0 : slabdata      1      1      0
sgpool-32              2      8    512    8    1 : tunables   54   27    0 : slabdata      1      1      0
sgpool-16              2     15    256   15    1 : tunables  120   60    0 : slabdata      1      1      0
sgpool-8               2     30    128   30    1 : tunables  120   60    0 : slabdata      1      1      0
scsi_io_context        0      0    104   37    1 : tunables  120   60    0 : slabdata      0      0      0
blkdev_ioc            48    113     32  113    1 : tunables  120   60    0 : slabdata      1      1      0
blkdev_queue          25     28    908    4    1 : tunables   54   27    0 : slabdata      7      7      0
blkdev_requests        8     22    180   22    1 : tunables  120   60    0 : slabdata      1      1      0
biovec-256             2      2   3072    2    2 : tunables   24   12    0 : slabdata      1      1      0
biovec-128             2      5   1536    5    2 : tunables   24   12    0 : slabdata      1      1      0
biovec-64              2      5    768    5    1 : tunables   54   27    0 : slabdata      1      1      0
biovec-16              2     20    192   20    1 : tunables  120   60    0 : slabdata      1      1      0
biovec-4               2     59     64   59    1 : tunables  120   60    0 : slabdata      1      1      0
biovec-1              66    203     16  203    1 : tunables  120   60    0 : slabdata      1      1      0
bio                   59     59     64   59    1 : tunables  120   60    0 : slabdata      1      1      0
sock_inode_cache      60     60    384   10    1 : tunables   54   27    0 : slabdata      6      6      0
skbuff_fclone_cache      0      0    320   12    1 : tunables   54   27    0 : slabdata      0      0      0
skbuff_head_cache    360    420    192   20    1 : tunables  120   60    0 : slabdata     21     21      0
file_lock_cache        0      0     92   42    1 : tunables  120   60    0 : slabdata      0      0      0
proc_inode_cache     150    156    304   13    1 : tunables   54   27    0 : slabdata     12     12      0
sigqueue              27     27    144   27    1 : tunables  120   60    0 : slabdata      1      1      0
radix_tree_node      807    897    288   13    1 : tunables   54   27    0 : slabdata     69     69      0
bdev_cache             4      9    448    9    1 : tunables   54   27    0 : slabdata      1      1      0
sysfs_dir_cache     4336   4368     44   84    1 : tunables  120   60    0 : slabdata     52     52      0
mnt_cache             17     30    128   30    1 : tunables  120   60    0 : slabdata      1      1      0
inode_cache           14     26    288   13    1 : tunables   54   27    0 : slabdata      2      2      0
dentry              4092   4092    124   31    1 : tunables  120   60    0 : slabdata    132    132      0
filp                1230   1470    128   30    1 : tunables  120   60    0 : slabdata     49     49      0
names_cache            6      6   4096    1    1 : tunables   24   12    0 : slabdata      6      6      0
idr_layer_cache      101    116    136   29    1 : tunables  120   60    0 : slabdata      4      4      0
buffer_head         1138   1296     52   72    1 : tunables  120   60    0 : slabdata     18     18      0
mm_struct             50     50    384   10    1 : tunables   54   27    0 : slabdata      5      5      0
vm_area_struct      2120   2254     84   46    1 : tunables  120   60    0 : slabdata     49     49      0
fs_cache              50    113     32  113    1 : tunables  120   60    0 : slabdata      1      1      0
files_cache           51     60    192   20    1 : tunables  120   60    0 : slabdata      3      3      0
signal_cache          53     60    384   10    1 : tunables   54   27    0 : slabdata      6      6      0
sighand_cache         54     54   1344    3    1 : tunables   24   12    0 : slabdata     18     18      0
task_struct           63     63   1344    3    1 : tunables   24   12    0 : slabdata     21     21      0
anon_vma            1211   1356      8  339    1 : tunables  120   60    0 : slabdata      4      4      0
pid_namespace          0      0     36  101    1 : tunables  120   60    0 : slabdata      0      0      0
pid_1                 64    118     64   59    1 : tunables  120   60    0 : slabdata      2      2      0
size-4194304(DMA)      0      0 4194304    1 1024 : tunables    1    1    0 : slabdata      0      0      0
size-4194304           0      0 4194304    1 1024 : tunables    1    1    0 : slabdata      0      0      0
size-2097152(DMA)      0      0 2097152    1  512 : tunables    1    1    0 : slabdata      0      0      0
size-2097152           0      0 2097152    1  512 : tunables    1    1    0 : slabdata      0      0      0
size-1048576(DMA)      0      0 1048576    1  256 : tunables    1    1    0 : slabdata      0      0      0
size-1048576           0      0 1048576    1  256 : tunables    1    1    0 : slabdata      0      0      0
size-524288(DMA)       0      0 524288    1  128 : tunables    1    1    0 : slabdata      0      0      0
size-524288            0      0 524288    1  128 : tunables    1    1    0 : slabdata      0      0      0
size-262144(DMA)       0      0 262144    1   64 : tunables    1    1    0 : slabdata      0      0      0
size-262144            0      0 262144    1   64 : tunables    1    1    0 : slabdata      0      0      0
size-131072(DMA)       0      0 131072    1   32 : tunables    8    4    0 : slabdata      0      0      0
size-131072            1      1 131072    1   32 : tunables    8    4    0 : slabdata      1      1      0
size-65536(DMA)        0      0  65536    1   16 : tunables    8    4    0 : slabdata      0      0      0
size-65536             0      0  65536    1   16 : tunables    8    4    0 : slabdata      0      0      0
size-32768(DMA)        0      0  32768    1    8 : tunables    8    4    0 : slabdata      0      0      0
size-32768             1      1  32768    1    8 : tunables    8    4    0 : slabdata      1      1      0
size-16384(DMA)        0      0  16384    1    4 : tunables    8    4    0 : slabdata      0      0      0
size-16384             1      1  16384    1    4 : tunables    8    4    0 : slabdata      1      1      0
size-8192(DMA)         0      0   8192    1    2 : tunables    8    4    0 : slabdata      0      0      0
size-8192              3      3   8192    1    2 : tunables    8    4    0 : slabdata      3      3      0
size-4096(DMA)         0      0   4096    1    1 : tunables   24   12    0 : slabdata      0      0      0
size-4096             25     25   4096    1    1 : tunables   24   12    0 : slabdata     25     25      0
size-2048(DMA)         0      0   2048    2    1 : tunables   24   12    0 : slabdata      0      0      0
size-2048            290    290   2048    2    1 : tunables   24   12    0 : slabdata    145    145      0
size-1024(DMA)         0      0   1024    4    1 : tunables   54   27    0 : slabdata      0      0      0
size-1024             80     80   1024    4    1 : tunables   54   27    0 : slabdata     20     20      0
size-512(DMA)          0      0    512    8    1 : tunables   54   27    0 : slabdata      0      0      0
size-512             839    856    512    8    1 : tunables   54   27    0 : slabdata    107    107      0
size-256(DMA)          0      0    256   15    1 : tunables  120   60    0 : slabdata      0      0      0
size-256             165    165    256   15    1 : tunables  120   60    0 : slabdata     11     11      0
size-128(DMA)          0      0    128   30    1 : tunables  120   60    0 : slabdata      0      0      0
size-128             570    570    128   30    1 : tunables  120   60    0 : slabdata     19     19      0
size-64(DMA)           0      0     64   59    1 : tunables  120   60    0 : slabdata      0      0      0
size-32(DMA)           0      0     32  113    1 : tunables  120   60    0 : slabdata      0      0      0
size-64              885    885     64   59    1 : tunables  120   60    0 : slabdata     15     15      0
size-32             3729   3729     32  113    1 : tunables  120   60    0 : slabdata     33     33      0
kmem_cache           129    150    128   30    1 : tunables  120   60    0 : slabdata      5      5      0

Cache                       Num  Total   Size  Pages
ip_fib_alias                  9    113     32    113
ip_fib_hash                   9    113     32    113
rpc_buffers                   8      8   2048      2
rpc_tasks                     8     20    192     20
rpc_inode_cache               0      0    448      9
UNIX                         40     40    384     10
flow_cache                    0      0    128     30
uhci_urb_priv                 0      0     28    127
cfq_io_context                0      0     80     48
cfq_queue                     0      0     84     46
nfs_direct_cache              0      0     68     56
nfs_write_data               36     36    448      9
nfs_read_data                32     36    448      9
nfs_inode_cache               0      0    536      7
nfs_page                      0      0     64     59
isofs_inode_cache             0      0    316     12
fat_inode_cache               0      0    340     11
fat_cache                     0      0     20    169
ext2_inode_cache              0      0    424      9
ext2_xattr                    0      0     44     84
journal_handle               16    169     20    169
Cache                       Num  Total   Size  Pages
journal_head                 22     72     52     72
revoke_table                  2    254     12    254
revoke_record                 0      0     16    203
ext3_inode_cache           1764   1764    432      9
ext3_xattr                    0      0     44     84
dnotify_cache                 0      0     20    169
inotify_event_cache           0      0     28    127
inotify_watch_cache           0      0     40     92
kioctx                        0      0    192     20
kiocb                         0      0    192     20
fasync_cache                  1    203     16    203
shmem_inode_cache            47     50    380     10
nsproxy                       0      0     28    127
posix_timers_cache            0      0     88     44
uid_cache                     2     30    128     30
ip_mrt_cache                  0      0    128     30
UDP-Lite                      0      0    512      7
tcp_bind_bucket              16    203     16    203
inet_peer_cache               0      0     64     59
secpath_cache                 0      0     32    113
xfrm_dst_cache                0      0    320     12
Cache                       Num  Total   Size  Pages
ip_dst_cache                 60     60    256     15
arp_cache                     2     30    128     30
RAW                           2      9    448      9
UDP                           4      7    512      7
tw_sock_TCP                   0      0    128     30
request_sock_TCP              0      0     64     59
TCP                          16     21   1088      7
eventpoll_pwq                 0      0     36    101
eventpoll_epi                 0      0    128     30
sgpool-128                    2      2   2048      2
sgpool-64                     2      4   1024      4
sgpool-32                     2      8    512      8
sgpool-16                     2     15    256     15
sgpool-8                      2     30    128     30
scsi_io_context               0      0    104     37
blkdev_ioc                   48    113     32    113
blkdev_queue                 25     28    908      4
blkdev_requests               8     22    180     22
biovec-256                    2      2   3072      2
biovec-128                    2      5   1536      5
biovec-64                     2      5    768      5
Cache                       Num  Total   Size  Pages
biovec-16                    18     20    192     20
biovec-4                     18     59     64     59
biovec-1                     66    203     16    203
bio                          59     59     64     59
sock_inode_cache             70     70    384     10
skbuff_fclone_cache           0      0    320     12
skbuff_head_cache           360    420    192     20
file_lock_cache              16     42     92     42
proc_inode_cache            221    221    304     13
sigqueue                     27     27    144     27
radix_tree_node             807    897    288     13
bdev_cache                    4      9    448      9
sysfs_dir_cache            4336   4368     44     84
mnt_cache                    17     30    128     30
inode_cache                  14     26    288     13
dentry                     4185   4185    124     31
filp                       1350   1470    128     30
names_cache                   6      6   4096      1
idr_layer_cache             101    116    136     29
buffer_head                1138   1296     52     72
mm_struct                    50     50    384     10
Cache                       Num  Total   Size  Pages
vm_area_struct             2120   2254     84     46
fs_cache                     50    113     32    113
files_cache                  51     60    192     20
signal_cache                 53     60    384     10
sighand_cache                54     54   1344      3
task_struct                  63     63   1344      3
anon_vma                   1211   1356      8    339
pid_namespace                 0      0     36    101
pid_1                        64    118     64     59
size-4194304(DMA)             0      0 4194304      1
size-4194304                  0      0 4194304      1
size-2097152(DMA)             0      0 2097152      1
size-2097152                  0      0 2097152      1
size-1048576(DMA)             0      0 1048576      1
size-1048576                  0      0 1048576      1
size-524288(DMA)              0      0 524288      1
size-524288                   0      0 524288      1
size-262144(DMA)              0      0 262144      1
size-262144                   0      0 262144      1
size-131072(DMA)              0      0 131072      1
size-131072                   1      1 131072      1
Cache                       Num  Total   Size  Pages
size-65536(DMA)               0      0  65536      1
size-65536                    0      0  65536      1
size-32768(DMA)               0      0  32768      1
size-32768                    1      1  32768      1
size-16384(DMA)               0      0  16384      1
size-16384                    1      1  16384      1
size-8192(DMA)                0      0   8192      1
size-8192                     3      3   8192      1
size-4096(DMA)                0      0   4096      1
size-4096                    25     25   4096      1
size-2048(DMA)                0      0   2048      2
size-2048                   290    290   2048      2
size-1024(DMA)                0      0   1024      4
size-1024                    80     80   1024      4
size-512(DMA)                 0      0    512      8
size-512                    839    856    512      8
size-256(DMA)                 0      0    256     15
size-256                    165    165    256     15
size-128(DMA)                 0      0    128     30
size-128                    570    570    128     30
size-64(DMA)                  0      0     64     59
Cache                       Num  Total   Size  Pages
size-32(DMA)                  0      0     32    113
size-64                     885    885     64     59
size-32                    3729   3729     32    113
kmem_cache                  129    150    128     30


--------------040605070708010608080700
Content-Type: text/plain;
 name="v2m.txt"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="v2m.txt"

MemTotal:       223328 kB
MemFree:          8692 kB
Buffers:         18740 kB
Cached:          34452 kB
SwapCached:          0 kB
Active:         147592 kB
Inactive:        25440 kB
SwapTotal:           0 kB
SwapFree:            0 kB
Dirty:              24 kB
Writeback:           0 kB
AnonPages:      119860 kB
Mapped:       4098808392 kB
Slab:             4952 kB
SReclaimable:     1744 kB
SUnreclaim:       3208 kB
PageTables:        832 kB
NFS_Unstable:        0 kB
Bounce:              0 kB
CommitLimit:    111664 kB
Committed_AS:    45072 kB
VmallocTotal:   810720 kB
VmallocUsed:      3328 kB
VmallocChunk:   807132 kB
slabinfo - version: 2.1
# name            <active_objs> <num_objs> <objsize> <objperslab> <pagesperslab> : tunables <limit> <batchcount> <sharedfactor> : slabdata <active_slabs> <num_slabs> <sharedavail>
ip_fib_alias           9    113     32  113    1 : tunables  120   60    0 : slabdata      1      1      0
ip_fib_hash            9    113     32  113    1 : tunables  120   60    0 : slabdata      1      1      0
rpc_buffers            8      8   2048    2    1 : tunables   24   12    0 : slabdata      4      4      0
rpc_tasks              8     20    192   20    1 : tunables  120   60    0 : slabdata      1      1      0
rpc_inode_cache        0      0    448    9    1 : tunables   54   27    0 : slabdata      0      0      0
UNIX                  32     40    384   10    1 : tunables   54   27    0 : slabdata      4      4      0
flow_cache             0      0    128   30    1 : tunables  120   60    0 : slabdata      0      0      0
uhci_urb_priv          0      0     28  127    1 : tunables  120   60    0 : slabdata      0      0      0
cfq_io_context         0      0     80   48    1 : tunables  120   60    0 : slabdata      0      0      0
cfq_queue              0      0     84   46    1 : tunables  120   60    0 : slabdata      0      0      0
nfs_direct_cache       0      0     68   56    1 : tunables  120   60    0 : slabdata      0      0      0
nfs_write_data        36     36    448    9    1 : tunables   54   27    0 : slabdata      4      4      0
nfs_read_data         32     36    448    9    1 : tunables   54   27    0 : slabdata      4      4      0
nfs_inode_cache        0      0    536    7    1 : tunables   54   27    0 : slabdata      0      0      0
nfs_page               0      0     64   59    1 : tunables  120   60    0 : slabdata      0      0      0
isofs_inode_cache      0      0    316   12    1 : tunables   54   27    0 : slabdata      0      0      0
fat_inode_cache        0      0    340   11    1 : tunables   54   27    0 : slabdata      0      0      0
fat_cache              0      0     20  169    1 : tunables  120   60    0 : slabdata      0      0      0
ext2_inode_cache       0      0    424    9    1 : tunables   54   27    0 : slabdata      0      0      0
ext2_xattr             0      0     44   84    1 : tunables  120   60    0 : slabdata      0      0      0
journal_handle         8    169     20  169    1 : tunables  120   60    0 : slabdata      1      1      0
journal_head          15     72     52   72    1 : tunables  120   60    0 : slabdata      1      1      0
revoke_table           2    254     12  254    1 : tunables  120   60    0 : slabdata      1      1      0
revoke_record          0      0     16  203    1 : tunables  120   60    0 : slabdata      0      0      0
ext3_inode_cache    1764   1764    432    9    1 : tunables   54   27    0 : slabdata    196    196      0
ext3_xattr             0      0     44   84    1 : tunables  120   60    0 : slabdata      0      0      0
dnotify_cache          0      0     20  169    1 : tunables  120   60    0 : slabdata      0      0      0
inotify_event_cache      0      0     28  127    1 : tunables  120   60    0 : slabdata      0      0      0
inotify_watch_cache      0      0     40   92    1 : tunables  120   60    0 : slabdata      0      0      0
kioctx                 0      0    192   20    1 : tunables  120   60    0 : slabdata      0      0      0
kiocb                  0      0    192   20    1 : tunables  120   60    0 : slabdata      0      0      0
fasync_cache           1    203     16  203    1 : tunables  120   60    0 : slabdata      1      1      0
shmem_inode_cache     47     50    380   10    1 : tunables   54   27    0 : slabdata      5      5      0
nsproxy                0      0     28  127    1 : tunables  120   60    0 : slabdata      0      0      0
posix_timers_cache      0      0     88   44    1 : tunables  120   60    0 : slabdata      0      0      0
uid_cache              2     30    128   30    1 : tunables  120   60    0 : slabdata      1      1      0
ip_mrt_cache           0      0    128   30    1 : tunables  120   60    0 : slabdata      0      0      0
UDP-Lite               0      0    512    7    1 : tunables   54   27    0 : slabdata      0      0      0
tcp_bind_bucket       16    203     16  203    1 : tunables  120   60    0 : slabdata      1      1      0
inet_peer_cache        0      0     64   59    1 : tunables  120   60    0 : slabdata      0      0      0
secpath_cache          0      0     32  113    1 : tunables  120   60    0 : slabdata      0      0      0
xfrm_dst_cache         0      0    320   12    1 : tunables   54   27    0 : slabdata      0      0      0
ip_dst_cache          41     60    256   15    1 : tunables  120   60    0 : slabdata      4      4      0
arp_cache              0      0    128   30    1 : tunables  120   60    0 : slabdata      0      0      0
RAW                    2      9    448    9    1 : tunables   54   27    0 : slabdata      1      1      0
UDP                    4      7    512    7    1 : tunables   54   27    0 : slabdata      1      1      0
tw_sock_TCP            0      0    128   30    1 : tunables  120   60    0 : slabdata      0      0      0
request_sock_TCP       0      0     64   59    1 : tunables  120   60    0 : slabdata      0      0      0
TCP                   16     21   1088    7    2 : tunables   24   12    0 : slabdata      3      3      0
eventpoll_pwq          0      0     36  101    1 : tunables  120   60    0 : slabdata      0      0      0
eventpoll_epi          0      0    128   30    1 : tunables  120   60    0 : slabdata      0      0      0
sgpool-128             2      2   2048    2    1 : tunables   24   12    0 : slabdata      1      1      0
sgpool-64              2      4   1024    4    1 : tunables   54   27    0 : slabdata      1      1      0
sgpool-32              2      8    512    8    1 : tunables   54   27    0 : slabdata      1      1      0
sgpool-16              2     15    256   15    1 : tunables  120   60    0 : slabdata      1      1      0
sgpool-8               2     30    128   30    1 : tunables  120   60    0 : slabdata      1      1      0
scsi_io_context        0      0    104   37    1 : tunables  120   60    0 : slabdata      0      0      0
blkdev_ioc            33    113     32  113    1 : tunables  120   60    0 : slabdata      1      1      0
blkdev_queue          25     28    908    4    1 : tunables   54   27    0 : slabdata      7      7      0
blkdev_requests       12     22    180   22    1 : tunables  120   60    0 : slabdata      1      1      0
biovec-256             2      2   3072    2    2 : tunables   24   12    0 : slabdata      1      1      0
biovec-128             2      5   1536    5    2 : tunables   24   12    0 : slabdata      1      1      0
biovec-64              2      5    768    5    1 : tunables   54   27    0 : slabdata      1      1      0
biovec-16              2     20    192   20    1 : tunables  120   60    0 : slabdata      1      1      0
biovec-4               2     59     64   59    1 : tunables  120   60    0 : slabdata      1      1      0
biovec-1              10    203     16  203    1 : tunables  120   60    0 : slabdata      1      1      0
bio                   10     59     64   59    1 : tunables  120   60    0 : slabdata      1      1      0
sock_inode_cache      60     60    384   10    1 : tunables   54   27    0 : slabdata      6      6      0
skbuff_fclone_cache      0      0    320   12    1 : tunables   54   27    0 : slabdata      0      0      0
skbuff_head_cache    360    380    192   20    1 : tunables  120   60    0 : slabdata     19     19      0
file_lock_cache        0      0     92   42    1 : tunables  120   60    0 : slabdata      0      0      0
proc_inode_cache     299    299    304   13    1 : tunables   54   27    0 : slabdata     23     23      0
sigqueue              27     27    144   27    1 : tunables  120   60    0 : slabdata      1      1      0
radix_tree_node      870    897    288   13    1 : tunables   54   27    0 : slabdata     69     69      0
bdev_cache             4      9    448    9    1 : tunables   54   27    0 : slabdata      1      1      0
sysfs_dir_cache     4336   4368     44   84    1 : tunables  120   60    0 : slabdata     52     52      0
mnt_cache             17     30    128   30    1 : tunables  120   60    0 : slabdata      1      1      0
inode_cache           26     26    288   13    1 : tunables   54   27    0 : slabdata      2      2      0
dentry              4249   4278    124   31    1 : tunables  120   60    0 : slabdata    138    138      0
filp                1230   1440    128   30    1 : tunables  120   60    0 : slabdata     48     48      0
names_cache            6      6   4096    1    1 : tunables   24   12    0 : slabdata      6      6      0
idr_layer_cache      101    116    136   29    1 : tunables  120   60    0 : slabdata      4      4      0
buffer_head         4824   4824     52   72    1 : tunables  120   60    0 : slabdata     67     67      0
mm_struct             50     50    384   10    1 : tunables   54   27    0 : slabdata      5      5      0
vm_area_struct      2120   2254     84   46    1 : tunables  120   60    0 : slabdata     49     49      0
fs_cache              50    113     32  113    1 : tunables  120   60    0 : slabdata      1      1      0
files_cache           51     60    192   20    1 : tunables  120   60    0 : slabdata      3      3      0
signal_cache          60     60    384   10    1 : tunables   54   27    0 : slabdata      6      6      0
sighand_cache         54     54   1344    3    1 : tunables   24   12    0 : slabdata     18     18      0
task_struct           63     63   1344    3    1 : tunables   24   12    0 : slabdata     21     21      0
anon_vma            1210   1356      8  339    1 : tunables  120   60    0 : slabdata      4      4      0
pid_namespace          0      0     36  101    1 : tunables  120   60    0 : slabdata      0      0      0
pid_1                 76    118     64   59    1 : tunables  120   60    0 : slabdata      2      2      0
size-4194304(DMA)      0      0 4194304    1 1024 : tunables    1    1    0 : slabdata      0      0      0
size-4194304           0      0 4194304    1 1024 : tunables    1    1    0 : slabdata      0      0      0
size-2097152(DMA)      0      0 2097152    1  512 : tunables    1    1    0 : slabdata      0      0      0
size-2097152           0      0 2097152    1  512 : tunables    1    1    0 : slabdata      0      0      0
size-1048576(DMA)      0      0 1048576    1  256 : tunables    1    1    0 : slabdata      0      0      0
size-1048576           0      0 1048576    1  256 : tunables    1    1    0 : slabdata      0      0      0
size-524288(DMA)       0      0 524288    1  128 : tunables    1    1    0 : slabdata      0      0      0
size-524288            0      0 524288    1  128 : tunables    1    1    0 : slabdata      0      0      0
size-262144(DMA)       0      0 262144    1   64 : tunables    1    1    0 : slabdata      0      0      0
size-262144            0      0 262144    1   64 : tunables    1    1    0 : slabdata      0      0      0
size-131072(DMA)       0      0 131072    1   32 : tunables    8    4    0 : slabdata      0      0      0
size-131072            1      1 131072    1   32 : tunables    8    4    0 : slabdata      1      1      0
size-65536(DMA)        0      0  65536    1   16 : tunables    8    4    0 : slabdata      0      0      0
size-65536             0      0  65536    1   16 : tunables    8    4    0 : slabdata      0      0      0
size-32768(DMA)        0      0  32768    1    8 : tunables    8    4    0 : slabdata      0      0      0
size-32768             1      1  32768    1    8 : tunables    8    4    0 : slabdata      1      1      0
size-16384(DMA)        0      0  16384    1    4 : tunables    8    4    0 : slabdata      0      0      0
size-16384             1      1  16384    1    4 : tunables    8    4    0 : slabdata      1      1      0
size-8192(DMA)         0      0   8192    1    2 : tunables    8    4    0 : slabdata      0      0      0
size-8192              3      3   8192    1    2 : tunables    8    4    0 : slabdata      3      3      0
size-4096(DMA)         0      0   4096    1    1 : tunables   24   12    0 : slabdata      0      0      0
size-4096             25     25   4096    1    1 : tunables   24   12    0 : slabdata     25     25      0
size-2048(DMA)         0      0   2048    2    1 : tunables   24   12    0 : slabdata      0      0      0
size-2048            290    290   2048    2    1 : tunables   24   12    0 : slabdata    145    145      0
size-1024(DMA)         0      0   1024    4    1 : tunables   54   27    0 : slabdata      0      0      0
size-1024             88     88   1024    4    1 : tunables   54   27    0 : slabdata     22     22      0
size-512(DMA)          0      0    512    8    1 : tunables   54   27    0 : slabdata      0      0      0
size-512             820    848    512    8    1 : tunables   54   27    0 : slabdata    106    106      0
size-256(DMA)          0      0    256   15    1 : tunables  120   60    0 : slabdata      0      0      0
size-256             165    165    256   15    1 : tunables  120   60    0 : slabdata     11     11      0
size-128(DMA)          0      0    128   30    1 : tunables  120   60    0 : slabdata      0      0      0
size-128             555    570    128   30    1 : tunables  120   60    0 : slabdata     19     19      0
size-64(DMA)           0      0     64   59    1 : tunables  120   60    0 : slabdata      0      0      0
size-32(DMA)           0      0     32  113    1 : tunables  120   60    0 : slabdata      0      0      0
size-64              944    944     64   59    1 : tunables  120   60    0 : slabdata     16     16      0
size-32             3729   3729     32  113    1 : tunables  120   60    0 : slabdata     33     33      0
kmem_cache           129    150    128   30    1 : tunables  120   60    0 : slabdata      5      5      0

Cache                       Num  Total   Size  Pages
ip_fib_alias                  9    113     32    113
ip_fib_hash                   9    113     32    113
rpc_buffers                   8      8   2048      2
rpc_tasks                     8     20    192     20
rpc_inode_cache               0      0    448      9
UNIX                         40     40    384     10
flow_cache                    0      0    128     30
uhci_urb_priv                 0      0     28    127
cfq_io_context                0      0     80     48
cfq_queue                     0      0     84     46
nfs_direct_cache              0      0     68     56
nfs_write_data               36     36    448      9
nfs_read_data                32     36    448      9
nfs_inode_cache               0      0    536      7
nfs_page                      0      0     64     59
isofs_inode_cache             0      0    316     12
fat_inode_cache               0      0    340     11
fat_cache                     0      0     20    169
ext2_inode_cache              0      0    424      9
ext2_xattr                    0      0     44     84
journal_handle                8    169     20    169
Cache                       Num  Total   Size  Pages
journal_head                 15     72     52     72
revoke_table                  2    254     12    254
revoke_record                 0      0     16    203
ext3_inode_cache           1764   1764    432      9
ext3_xattr                    0      0     44     84
dnotify_cache                 0      0     20    169
inotify_event_cache           0      0     28    127
inotify_watch_cache           0      0     40     92
kioctx                        0      0    192     20
kiocb                         0      0    192     20
fasync_cache                  1    203     16    203
shmem_inode_cache            47     50    380     10
nsproxy                       0      0     28    127
posix_timers_cache            0      0     88     44
uid_cache                     2     30    128     30
ip_mrt_cache                  0      0    128     30
UDP-Lite                      0      0    512      7
tcp_bind_bucket              16    203     16    203
inet_peer_cache               0      0     64     59
secpath_cache                 0      0     32    113
xfrm_dst_cache                0      0    320     12
Cache                       Num  Total   Size  Pages
ip_dst_cache                 41     60    256     15
arp_cache                     0      0    128     30
RAW                           2      9    448      9
UDP                           4      7    512      7
tw_sock_TCP                   0      0    128     30
request_sock_TCP              0      0     64     59
TCP                          16     21   1088      7
eventpoll_pwq                 0      0     36    101
eventpoll_epi                 0      0    128     30
sgpool-128                    2      2   2048      2
sgpool-64                     2      4   1024      4
sgpool-32                     2      8    512      8
sgpool-16                     2     15    256     15
sgpool-8                      2     30    128     30
scsi_io_context               0      0    104     37
blkdev_ioc                   33    113     32    113
blkdev_queue                 25     28    908      4
blkdev_requests              12     22    180     22
biovec-256                    2      2   3072      2
biovec-128                    2      5   1536      5
biovec-64                     2      5    768      5
Cache                       Num  Total   Size  Pages
biovec-16                     2     20    192     20
biovec-4                      2     59     64     59
biovec-1                     10    203     16    203
bio                          10     59     64     59
sock_inode_cache             70     70    384     10
skbuff_fclone_cache           0      0    320     12
skbuff_head_cache           360    380    192     20
file_lock_cache              16     42     92     42
proc_inode_cache            312    312    304     13
sigqueue                     27     27    144     27
radix_tree_node             870    897    288     13
bdev_cache                    4      9    448      9
sysfs_dir_cache            4336   4368     44     84
mnt_cache                    17     30    128     30
inode_cache                  26     26    288     13
dentry                     4278   4278    124     31
filp                       1350   1440    128     30
names_cache                   6      6   4096      1
idr_layer_cache             101    116    136     29
buffer_head                4824   4824     52     72
mm_struct                    50     50    384     10
Cache                       Num  Total   Size  Pages
vm_area_struct             2120   2254     84     46
fs_cache                     50    113     32    113
files_cache                  51     60    192     20
signal_cache                 60     60    384     10
sighand_cache                54     54   1344      3
task_struct                  63     63   1344      3
anon_vma                   1210   1356      8    339
pid_namespace                 0      0     36    101
pid_1                        76    118     64     59
size-4194304(DMA)             0      0 4194304      1
size-4194304                  0      0 4194304      1
size-2097152(DMA)             0      0 2097152      1
size-2097152                  0      0 2097152      1
size-1048576(DMA)             0      0 1048576      1
size-1048576                  0      0 1048576      1
size-524288(DMA)              0      0 524288      1
size-524288                   0      0 524288      1
size-262144(DMA)              0      0 262144      1
size-262144                   0      0 262144      1
size-131072(DMA)              0      0 131072      1
size-131072                   1      1 131072      1
Cache                       Num  Total   Size  Pages
size-65536(DMA)               0      0  65536      1
size-65536                    0      0  65536      1
size-32768(DMA)               0      0  32768      1
size-32768                    1      1  32768      1
size-16384(DMA)               0      0  16384      1
size-16384                    1      1  16384      1
size-8192(DMA)                0      0   8192      1
size-8192                     3      3   8192      1
size-4096(DMA)                0      0   4096      1
size-4096                    25     25   4096      1
size-2048(DMA)                0      0   2048      2
size-2048                   290    290   2048      2
size-1024(DMA)                0      0   1024      4
size-1024                    88     88   1024      4
size-512(DMA)                 0      0    512      8
size-512                    820    848    512      8
size-256(DMA)                 0      0    256     15
size-256                    165    165    256     15
size-128(DMA)                 0      0    128     30
size-128                    555    570    128     30
size-64(DMA)                  0      0     64     59
Cache                       Num  Total   Size  Pages
size-32(DMA)                  0      0     32    113
size-64                     944    944     64     59
size-32                    3729   3729     32    113
kmem_cache                  129    150    128     30


--------------040605070708010608080700
Content-Type: text/plain;
 name="dmesg.txt"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="dmesg.txt"

e10
Xenomai: POSIX: destroyed thread cdf21610
Xenomai: POSIX: destroyed thread cdf20e10
Xenomai: POSIX: destroyed thread cdf21610
Xenomai: POSIX: destroyed thread cdf20e10
Xenomai: POSIX: destroyed thread cdf21610
Xenomai: POSIX: destroyed thread cdf20e10
Xenomai: POSIX: destroyed thread cdf21610
Xenomai: POSIX: destroyed thread cdf20e10
Xenomai: POSIX: destroyed thread cdf21610
Xenomai: POSIX: destroyed thread cdf20e10
Xenomai: POSIX: destroyed thread cdf21610
Xenomai: POSIX: destroyed thread cdf20e10
Xenomai: POSIX: destroyed thread cdf21610
Xenomai: POSIX: destroyed thread cdf20e10
Xenomai: POSIX: destroyed thread cdf21610
Xenomai: POSIX: destroyed thread cdf20e10
Xenomai: POSIX: destroyed thread cdf21610
Xenomai: POSIX: destroyed thread cdf20e10
Xenomai: POSIX: destroyed thread cdf21610
Xenomai: POSIX: destroyed thread cdf20e10
Xenomai: POSIX: destroyed thread cdf21610
Xenomai: POSIX: destroyed thread cdf20e10
Xenomai: POSIX: destroyed thread cdf21610
Xenomai: POSIX: destroyed thread cdf20e10
Xenomai: POSIX: destroyed thread cdf21610
Xenomai: POSIX: destroyed thread cdf20e10
Xenomai: POSIX: destroyed thread cdf21610
Xenomai: POSIX: destroyed thread cdf20e10
Xenomai: POSIX: destroyed thread cdf21610
Xenomai: POSIX: destroyed thread cdf20e10
Xenomai: POSIX: destroyed thread cdf21610
Xenomai: POSIX: destroyed thread cdf20e10
Xenomai: POSIX: destroyed thread cdf21610
Xenomai: POSIX: destroyed thread cdf20e10
Xenomai: POSIX: destroyed thread cdf21610
Xenomai: POSIX: destroyed thread cdf20e10
Xenomai: POSIX: destroyed thread cdf21610
Xenomai: POSIX: destroyed thread cdf20e10
Xenomai: POSIX: destroyed thread cdf21610
Xenomai: POSIX: destroyed thread cdf20e10
Xenomai: POSIX: destroyed thread cdf21610
Xenomai: POSIX: destroyed thread cdf20e10
Xenomai: POSIX: destroyed thread cdf21610
Xenomai: POSIX: destroyed thread cdf20e10
Xenomai: POSIX: destroyed thread cdf21610
Xenomai: POSIX: destroyed thread cdf20e10
Xenomai: POSIX: destroyed thread cdf21610
Xenomai: POSIX: destroyed thread cdf20e10
Xenomai: POSIX: destroyed thread cdf21610
Xenomai: POSIX: destroyed thread cdf20e10
Xenomai: POSIX: destroyed thread cdf21610
Xenomai: POSIX: destroyed thread cdf20e10
Xenomai: POSIX: destroyed thread cdf21610
Xenomai: POSIX: destroyed thread cdf20e10
Xenomai: POSIX: destroyed thread cdf21610
Xenomai: POSIX: destroyed thread cdf20e10
Xenomai: POSIX: destroyed thread cdf21610
Xenomai: POSIX: destroyed thread cdf20e10
Xenomai: POSIX: destroyed thread cdf21610
Xenomai: POSIX: destroyed thread cdf20e10
Xenomai: POSIX: destroyed thread cdf21610
Xenomai: POSIX: destroyed thread cdf20e10
Xenomai: POSIX: destroyed thread cdf21610
Xenomai: POSIX: destroyed thread cdf20e10
Xenomai: POSIX: destroyed thread cdf21610
Xenomai: POSIX: destroyed thread cdf20e10
Xenomai: POSIX: destroyed thread cdf21610
Xenomai: POSIX: destroyed thread cdf20e10
Xenomai: POSIX: destroyed thread cdf21610
Xenomai: POSIX: destroyed thread cdf20e10
Xenomai: POSIX: destroyed thread cdf21610
Xenomai: POSIX: destroyed thread cdf20e10
Xenomai: POSIX: destroyed thread cdf21610
Xenomai: POSIX: destroyed thread cdf20e10
Xenomai: POSIX: destroyed thread cdf21610
Xenomai: POSIX: destroyed thread cdf20e10
Xenomai: POSIX: destroyed thread cdf21610
Xenomai: POSIX: destroyed thread cdf20e10
Xenomai: POSIX: destroyed thread cdf21610
Xenomai: POSIX: destroyed thread cdf20e10
Xenomai: POSIX: destroyed thread cdf21610
Xenomai: POSIX: destroyed thread cdf20e10
Xenomai: POSIX: destroyed thread cdf21610
Xenomai: POSIX: destroyed thread cdf20e10
Xenomai: POSIX: destroyed thread cdf21610
Xenomai: POSIX: destroyed thread cdf20e10
Xenomai: POSIX: destroyed thread cdf21610
Xenomai: POSIX: destroyed thread cdf20e10
Xenomai: POSIX: destroyed thread cdf21610
Xenomai: POSIX: destroyed thread cdf20e10
Xenomai: POSIX: destroyed thread cdf21610
Xenomai: POSIX: destroyed thread cdf20e10
Xenomai: POSIX: destroyed thread cdf21610
Xenomai: POSIX: destroyed thread cdf20e10
Xenomai: POSIX: destroyed thread cdf21610
Xenomai: POSIX: destroyed thread cdf20e10
Xenomai: POSIX: destroyed thread cdf21610
Xenomai: POSIX: destroyed thread cdf20e10
Xenomai: POSIX: destroyed thread cdf21610
Xenomai: POSIX: destroyed thread cdf20e10
Xenomai: POSIX: destroyed thread cdf21610
Xenomai: POSIX: destroyed thread cdf20e10
Xenomai: POSIX: destroyed thread cdf21610
Xenomai: POSIX: destroyed thread cdf20e10
Xenomai: POSIX: destroyed thread cdf21610
Xenomai: POSIX: destroyed thread cdf20e10
Xenomai: POSIX: destroyed thread cdf21610
Xenomai: POSIX: destroyed thread cdf20e10
Xenomai: POSIX: destroyed thread cdf21610
Xenomai: POSIX: destroyed thread cdf20e10
Xenomai: POSIX: destroyed thread cdf21610
Xenomai: POSIX: destroyed thread cdf20e10
Xenomai: POSIX: destroyed thread cdf21610
Xenomai: POSIX: destroyed thread cdf20e10
Xenomai: POSIX: destroyed thread cdf21610
Xenomai: POSIX: destroyed thread cdf20e10
Xenomai: POSIX: destroyed thread cdf21610
Xenomai: POSIX: destroyed thread cdf20e10
Xenomai: POSIX: destroyed thread cdf21610
Xenomai: POSIX: destroyed thread cdf20e10
Xenomai: POSIX: destroyed thread cdf21610
Xenomai: POSIX: destroyed thread cdf20e10
Xenomai: POSIX: destroyed thread cdf21610
Xenomai: POSIX: destroyed thread cdf20e10
Xenomai: POSIX: destroyed thread cdf21610
Xenomai: POSIX: destroyed thread cdf20e10
Xenomai: POSIX: destroyed thread cdf21610
Xenomai: POSIX: destroyed thread cdf20e10
Xenomai: POSIX: destroyed thread cdf21610
Xenomai: POSIX: destroyed thread cdf20e10
Xenomai: POSIX: destroyed thread cdf21610
Xenomai: POSIX: destroyed thread cdf20e10
Xenomai: POSIX: destroyed thread cdf21610
Xenomai: POSIX: destroyed thread cdf20e10
Xenomai: POSIX: destroyed thread cdf21610
Xenomai: POSIX: destroyed thread cdf20e10
Xenomai: POSIX: destroyed thread cdf21610
Xenomai: POSIX: destroyed thread cdf20e10
Xenomai: POSIX: destroyed thread cdf21610
Xenomai: POSIX: destroyed thread cdf20e10
Xenomai: POSIX: destroyed thread cdf21610
Xenomai: POSIX: destroyed thread cdf20e10
Xenomai: POSIX: destroyed thread cdf21610
Xenomai: POSIX: destroyed thread cdf20e10
Xenomai: POSIX: destroyed thread cdf21610
Xenomai: POSIX: destroyed thread cdf20e10
Xenomai: POSIX: destroyed thread cdf21610
Xenomai: POSIX: destroyed thread cdf20e10
Xenomai: POSIX: destroyed thread cdf21610
Xenomai: POSIX: destroyed thread cdf20e10
Xenomai: POSIX: destroyed thread cdf21610
Xenomai: POSIX: destroyed thread cdf20e10
Xenomai: POSIX: destroyed thread cdf21610
Xenomai: POSIX: destroyed thread cdf20e10
Xenomai: POSIX: destroyed thread cdf21610
Xenomai: POSIX: destroyed thread cdf20e10
Xenomai: POSIX: destroyed thread cdf21610
Xenomai: POSIX: destroyed thread cdf20e10
Xenomai: POSIX: destroyed thread cdf21610
Xenomai: POSIX: destroyed thread cdf20e10
Xenomai: POSIX: destroyed thread cdf21610
Xenomai: POSIX: destroyed thread cdf20e10
Xenomai: POSIX: destroyed thread cdf21610
Xenomai: POSIX: destroyed thread cdf20e10
Xenomai: POSIX: destroyed thread cdf21610
Xenomai: POSIX: destroyed thread cdf20e10
Xenomai: POSIX: destroyed thread cdf21610
Xenomai: POSIX: destroyed thread cdf20e10
Xenomai: POSIX: destroyed thread cdf21610
Xenomai: POSIX: destroyed thread cdf20e10
Xenomai: POSIX: destroyed thread cdf21610
Xenomai: POSIX: destroyed thread cdf20e10
Xenomai: POSIX: destroyed thread cdf21610
Xenomai: POSIX: destroyed thread cdf20e10
Xenomai: POSIX: destroyed thread cdf21610
Xenomai: POSIX: destroyed thread cdf20e10
Xenomai: POSIX: destroyed thread cdf21610
Xenomai: POSIX: destroyed thread cdf20e10
Xenomai: POSIX: destroyed thread cdf21610
Xenomai: POSIX: destroyed thread cdf20e10
Xenomai: POSIX: destroyed thread cdf21610
Xenomai: POSIX: destroyed thread cdf20e10
Xenomai: POSIX: destroyed thread cdf21610
Xenomai: POSIX: destroyed thread cdf20e10
Xenomai: POSIX: destroyed thread cdf21610
Xenomai: POSIX: destroyed thread cdf20e10
Xenomai: POSIX: destroyed thread cdf21610
Xenomai: POSIX: destroyed thread cdf20e10
Xenomai: POSIX: destroyed thread cdf21610
Xenomai: POSIX: destroyed thread cdf20e10
Xenomai: POSIX: destroyed thread cdf21610
Xenomai: POSIX: destroyed thread cdf20e10
Xenomai: POSIX: destroyed thread cdf21610
Xenomai: POSIX: destroyed thread cdf20e10
Xenomai: POSIX: destroyed thread cdf21610
Xenomai: POSIX: destroyed thread cdf20e10
Xenomai: POSIX: destroyed thread cdf21610
Xenomai: POSIX: destroyed thread cdf20e10
Xenomai: POSIX: destroyed thread cdf21610
Xenomai: POSIX: destroyed thread cdf20e10
Xenomai: POSIX: destroyed thread cdf21610
Xenomai: POSIX: destroyed thread cdf20e10
Xenomai: POSIX: destroyed thread cdf21610
Xenomai: POSIX: destroyed thread cdf20e10
Xenomai: POSIX: destroyed thread cdf21610
Xenomai: POSIX: destroyed thread cdf20e10
Xenomai: POSIX: destroyed thread cdf21610
Xenomai: POSIX: destroyed thread cdf20e10
Xenomai: POSIX: destroyed thread cdf21610
Xenomai: POSIX: destroyed thread cdf20e10
Xenomai: POSIX: destroyed thread cdf21610
Xenomai: POSIX: destroyed thread cdf20e10
Xenomai: POSIX: destroyed thread cdf21610
Xenomai: POSIX: destroyed thread cdf20e10
Xenomai: POSIX: destroyed thread cdf21610
Xenomai: POSIX: destroyed thread cdf20e10
Xenomai: POSIX: destroyed thread cdf21610
Xenomai: POSIX: destroyed thread cdf20e10
Xenomai: POSIX: destroyed thread cdf21610
Xenomai: POSIX: destroyed thread cdf20e10
Xenomai: POSIX: destroyed thread cdf21610
Xenomai: POSIX: destroyed thread cdf20e10
Xenomai: POSIX: destroyed thread cdf21610
Xenomai: POSIX: destroyed thread cdf20e10
Xenomai: POSIX: destroyed thread cdf21610
Xenomai: POSIX: destroyed thread cdf20e10
Xenomai: POSIX: destroyed thread cdf21610
Xenomai: POSIX: destroyed thread cdf20e10
Xenomai: POSIX: destroyed thread cdf21610
Xenomai: POSIX: destroyed thread cdf20e10
Xenomai: POSIX: destroyed thread cdf21610
Xenomai: POSIX: destroyed thread cdf20e10
Xenomai: POSIX: destroyed thread cdf21610
Xenomai: POSIX: destroyed thread cdf20e10
Xenomai: POSIX: destroyed thread cdf21610
Xenomai: POSIX: destroyed thread cdf20e10
Xenomai: POSIX: destroyed thread cdf21610
Xenomai: POSIX: destroyed thread cdf20e10
Xenomai: POSIX: destroyed thread cdf21610
Xenomai: POSIX: destroyed thread cdf20e10
Xenomai: POSIX: destroyed thread cdf21610
Xenomai: POSIX: destroyed thread cdf20e10
Xenomai: POSIX: destroyed thread cdf21610
Xenomai: POSIX: destroyed thread cdf20e10
Xenomai: POSIX: destroyed thread cdf21610
Xenomai: POSIX: destroyed thread cdf20e10
Xenomai: POSIX: destroyed thread cdf21610
Xenomai: POSIX: destroyed thread cdf20e10
Xenomai: POSIX: destroyed thread cdf21610
Xenomai: POSIX: destroyed thread cdf20e10
Xenomai: POSIX: destroyed thread cdf21610
Xenomai: POSIX: destroyed thread cdf20e10
Xenomai: POSIX: destroyed thread cdf21610
Xenomai: POSIX: destroyed thread cdf20e10
Xenomai: POSIX: destroyed thread cdf21610
Xenomai: POSIX: destroyed thread cdf20e10
Xenomai: POSIX: destroyed thread cdf21610
Xenomai: POSIX: destroyed thread cdf20e10
Xenomai: POSIX: destroyed thread cdf21610
Xenomai: POSIX: destroyed thread cdf20e10
Xenomai: POSIX: destroyed thread cdf21610
Xenomai: POSIX: destroyed thread cdf20e10
Xenomai: POSIX: destroyed thread cdf21610
Xenomai: POSIX: destroyed thread cdf20e10
Xenomai: POSIX: destroyed thread cdf21610
Xenomai: POSIX: destroyed thread cdf20e10
Xenomai: POSIX: destroyed thread cdf21610
Xenomai: POSIX: destroyed thread cdf20e10
Xenomai: POSIX: destroyed thread cdf21610
Xenomai: POSIX: destroyed thread cdf20e10
Xenomai: POSIX: destroyed thread cdf21610
Xenomai: POSIX: destroyed thread cdf20e10
Xenomai: POSIX: destroyed thread cdf21610
Xenomai: POSIX: destroyed thread cdf20e10
Xenomai: POSIX: destroyed thread cdf21610
Xenomai: POSIX: destroyed thread cdf20e10
Xenomai: POSIX: destroyed thread cdf21610
Xenomai: POSIX: destroyed thread cdf20e10
Xenomai: POSIX: destroyed thread cdf21610
Xenomai: POSIX: destroyed thread cdf20e10
Xenomai: POSIX: destroyed thread cdf21610
Xenomai: POSIX: destroyed thread cdf20e10
Xenomai: POSIX: destroyed thread cdf21610
Xenomai: POSIX: destroyed thread cdf20e10
Xenomai: POSIX: destroyed thread cdf21610
Xenomai: POSIX: destroyed thread cdf20e10
Xenomai: POSIX: destroyed thread cdf21610
Xenomai: POSIX: destroyed thread cdf20e10
Xenomai: POSIX: destroyed thread cdf21610
Xenomai: POSIX: destroyed thread cdf20e10
Xenomai: POSIX: destroyed thread cdf21610
Xenomai: POSIX: destroyed thread cdf20e10
Xenomai: POSIX: destroyed thread cdf21610
Xenomai: POSIX: destroyed thread cdf20e10
Xenomai: POSIX: destroyed thread cdf21610
Xenomai: POSIX: destroyed thread cdf20e10
Xenomai: POSIX: destroyed thread cdf21610
Xenomai: POSIX: destroyed thread cdf20e10
Xenomai: POSIX: destroyed thread cdf21610
Xenomai: POSIX: destroyed thread cdf20e10
Xenomai: POSIX: destroyed thread cdf21610
Xenomai: POSIX: destroyed thread cdf20e10
Xenomai: POSIX: destroyed thread cdf21610
Xenomai: POSIX: destroyed thread cdf20e10
Xenomai: POSIX: destroyed thread cdf21610
Xenomai: POSIX: destroyed thread cdf20e10
Xenomai: POSIX: destroyed thread cdf21610
Xenomai: POSIX: destroyed thread cdf20e10
Xenomai: POSIX: destroyed thread cdf21610
Xenomai: POSIX: destroyed thread cdf20e10
Xenomai: POSIX: destroyed thread cdf21610
Xenomai: POSIX: destroyed thread cdf20e10
Xenomai: POSIX: destroyed thread cdf21610
Xenomai: POSIX: destroyed thread cdf20e10
Xenomai: POSIX: destroyed thread cdf21610
Xenomai: POSIX: destroyed thread cdf20e10
Xenomai: POSIX: destroyed thread cdf21610
Xenomai: POSIX: destroyed thread cdf20e10
Xenomai: POSIX: destroyed thread cdf21610
Xenomai: POSIX: destroyed thread cdf20e10
Xenomai: POSIX: destroyed thread cdf21610
Xenomai: POSIX: destroyed thread cdf20e10
Xenomai: POSIX: destroyed thread cdf21610
Xenomai: POSIX: destroyed thread cdf20e10
Xenomai: POSIX: destroyed thread cdf21610
Xenomai: POSIX: destroyed thread cdf20e10
Xenomai: POSIX: destroyed thread cdf21610
Xenomai: POSIX: destroyed thread cdf20e10
Xenomai: POSIX: destroyed thread cdf21610
Xenomai: POSIX: destroyed thread cdf20e10
Xenomai: POSIX: destroyed thread cdf21610
Xenomai: POSIX: destroyed thread cdf20e10
Xenomai: POSIX: destroyed thread cdf21610
Xenomai: POSIX: destroyed thread cdf20e10
Xenomai: POSIX: destroyed thread cdf21610
Xenomai: POSIX: destroyed thread cdf20e10
Xenomai: POSIX: destroyed thread cdf21610
Xenomai: POSIX: destroyed thread cdf20e10
Xenomai: POSIX: destroyed thread cdf21610
Xenomai: POSIX: destroyed thread cdf20e10
Xenomai: POSIX: destroyed thread cdf21610
Xenomai: POSIX: destroyed thread cdf20e10
Xenomai: POSIX: destroyed thread cdf21610
Xenomai: POSIX: destroyed thread cdf20e10
Xenomai: POSIX: destroyed thread cdf21610
Xenomai: POSIX: destroyed thread cdf20e10
Xenomai: POSIX: destroyed thread cdf21610
Xenomai: POSIX: destroyed thread cdf20e10
Xenomai: POSIX: destroyed thread cdf21610
Xenomai: POSIX: destroyed thread cdf20e10
Xenomai: POSIX: destroyed thread cdf21610
Xenomai: POSIX: destroyed thread cdf20e10
Xenomai: POSIX: destroyed thread cdf21610
Xenomai: POSIX: destroyed thread cdf20e10
Xenomai: POSIX: destroyed thread cdf21610
Xenomai: POSIX: destroyed thread cdf20e10
Xenomai: POSIX: destroyed thread cdf21610
Xenomai: POSIX: destroyed thread cdf20e10
Xenomai: POSIX: destroyed thread cdf21610
Xenomai: POSIX: destroyed thread cdf20e10
Xenomai: POSIX: destroyed thread cdf21610
Xenomai: POSIX: destroyed thread cdf20e10
Xenomai: POSIX: destroyed thread cdf21610
Xenomai: POSIX: destroyed thread cdf20e10


--------------040605070708010608080700--
