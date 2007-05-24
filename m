Return-Path: <linux-kernel-owner+w=401wt.eu-S1759291AbXEXNMo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759291AbXEXNMo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2007 09:12:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756890AbXEXNMh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 May 2007 09:12:37 -0400
Received: from web52606.mail.re2.yahoo.com ([206.190.48.209]:28209 "HELO
	web52606.mail.re2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1756834AbXEXNMg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2007 09:12:36 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=X-YMail-OSG:Received:Date:From:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-ID;
  b=oUdny8xn+k/5pxbRfs+VGfxCDyA5mOtRvntBn0LydPCKcyB4u1XmTmsa5o6ytsW5xQS5ThSCayjsm55EiB8rEDh2DXhCbHG48LzotxG4MvoZU+YzIOB44eLMyDkP7XfKp7Ueifz6dRIgqn+9hA0ZRM53dx/Pm4S4DvhBXe+Nmrs=;
X-YMail-OSG: fOV2mvMVM1m.uD.ezgTAjFV.2m9jJ2nP2ghE.ntKMVVgV46sipBHzoBI2yhkWh3oLg--
Date: Thu, 24 May 2007 23:12:35 +1000 (EST)
From: Srihari Vijayaraghavan <sriharivijayaraghavan@yahoo.com.au>
Subject: Re: [PROBLEM] 2.6.22-rc2 panics on x86-64 with slub
To: Christoph Lameter <clameter@sgi.com>
Cc: Hugh Dickins <hugh@veritas.com>, Ingo Molnar <mingo@elte.hu>,
       Oliver Xymoron <oxymoron@waste.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jens Axboe <jens.axboe@oracle.com>, linux-kernel@vger.kernel.org
In-Reply-To: <Pine.LNX.4.64.0705231528170.22666@schroedinger.engr.sgi.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="0-968067621-1180012355=:81786"
Content-Transfer-Encoding: 8bit
Message-ID: <409105.81786.qm@web52606.mail.re2.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--0-968067621-1180012355=:81786
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Content-Id: 
Content-Disposition: inline

--- Christoph Lameter <clameter@sgi.com> wrote:
> On Thu, 24 May 2007, Srihari Vijayaraghavan wrote:

[...]

> Could you boot with slub_debug and then run

Done.
 
> slabinfo -v
> 
> to validate all slabs? If there is anything wrong with an object then it 
> should show in the syslog.

slabinfo -v produces this error message:
Cannot write to Acpi-Namespace/validate

slabinfo with no argument worked fine; the result is attached.

Thanks



      ___________________________________________________________________________________
How would you spend $50,000 to create a more sustainable environment in Australia?  Go to Yahoo!7 Answers and share your idea.
http://advision.webevents.yahoo.com/aunz/lifestyle/answers/y7ans-babp_reg.html

--0-968067621-1180012355=:81786
Content-Type: text/plain; name="slabinfo-2.6-hg-e3a5033ec4d6.txt"
Content-Description: 2200734171-slabinfo-2.6-hg-e3a5033ec4d6.txt
Content-Disposition: inline; filename="slabinfo-2.6-hg-e3a5033ec4d6.txt"

Name                   Objects Objsize    Space Slabs/Part/Cpu  O/S O %Fr %Ef Flg
Acpi-Namespace             635      32    69.6K         17/1/0   39 0   5  29 PZFU
Acpi-Operand              1975      64   274.4K         67/4/0   30 0   5  46 PZFU
Acpi-Parse                   0      40     8.1K          2/2/0   36 0 100   0 PZFU
Acpi-ParseExt                0      64     8.1K          2/2/0   30 0 100   0 PZFU
Acpi-State                   0      80     8.1K          2/2/0   26 0 100   0 PZFU
anon_vma                  1636      64   233.4K         57/4/2   30 0   7  44 PZFU
arp_cache                    2     300     4.0K          1/1/0   10 0 100  14 APZFU
avc_node                   503      72    81.9K        20/10/2   28 0  50  44 PZFU
avtab_node              110636      24    10.7M       2635/1/0   42 0   0  24 PZFU
bdev_cache                  36    1344    65.5K          8/2/0    5 1  25  73 APaZFU
bio                          2     104     8.1K          2/0/2   21 0   0   2 APZFU
biovec-1                     2      16     8.1K          2/0/2   46 0   0   0 APZFU
biovec-128                   2    2048    16.3K          2/2/0    3 1 100  25 APZFU
biovec-16                    2     256     8.1K          2/1/1   10 0  50   6 APZFU
biovec-256                   2    4096    16.3K          2/0/0    1 1   0  50 APZFU
biovec-4                     2      64     8.1K          2/0/2   21 0   0   1 APZFU
biovec-64                    2    1024    16.3K          2/1/1    7 1  50  12 APZFU
blkdev_ioc                  42      64     8.1K          2/1/1   30 0  50  32 PZFU
blkdev_queue                21    1752    49.1K          6/1/0    4 1  16  74 PZFU
blkdev_requests             16     280    16.3K          4/1/2   11 0  25  27 PZFU
buffer_head               5315     104   954.3K        233/4/2   23 0   1  57 PaZFU
cfq_io_context              45     152    16.3K          4/3/1   18 0  75  41 PZFU
cfq_queue                   52     144    16.3K          4/3/1   18 0  75  45 PZFU
dentry                   21166     240     6.6M       1629/2/2   13 0   0  76 PaZFU
dnotify_cache                1      40     4.0K          1/1/0   36 0 100   0 PZFU
ext3_inode_cache          8357    1376    13.6M       1672/2/2    5 1   0  83 PaZFU
ext3_xattr                 842      88   143.3K         35/0/2   25 0   0  51 PaZFU
fasync_cache                 2      24     4.0K          1/1/0   42 0 100   1 PZFU
file_lock_cache              4     216     8.1K          2/2/0   14 0 100  10 PZFU
files_cache                 60     768    69.6K         17/3/2    4 0  17  66 APZFU
filp                      2190     328     1.0M        245/0/2    9 0   0  71 APZFU
fs_cache                    59     112    16.3K          4/2/2   21 0  50  40 APZFU
hugetlbfs_inode_cache        1    1008     8.1K          1/1/0    7 1 100  12 PZFU
idr_layer_cache            194     528   135.1K         33/1/0    6 0   3  75 PZFU
inet_peer_cache              1      64     4.0K          1/1/0   21 0 100   1 APZFU
inode_cache               5403    1008     6.3M        773/2/2    7 1   0  86 PaZFU
inotify_event_cache          0      40     8.1K          2/2/0   36 0 100   0 PZFU
inotify_watch_cache         81      72    16.3K          4/3/0   28 0  75  35 PZFU
ip_dst_cache                43     320    20.4K          5/0/2    9 0   0  67 APZFU
ip_fib_alias                10      48     8.1K          2/2/0   32 0 100   5 APZFU
ip_fib_hash                 10      40     8.1K          2/2/0   32 0 100   4 APZFU
jbd_4k                       0    4096    16.3K          2/0/2    1 1   0   0 PZFU
journal_handle               0      24     8.1K          2/0/2   42 0   0   0 PZFU
journal_head                28      96    12.2K          3/1/2   24 0  33  21 PZFU
key_jar                     10     216     8.1K          2/2/0   12 0 100  26 APZFU
kmalloc-1024               297    1024   360.4K         44/2/2    7 1   4  84 PZFU
kmalloc-128                100     128    24.5K          6/3/0   20 0  50  52 PZFU
kmalloc-131072               1  131072   262.1K          1/0/0    1 6   0  50 PZFU
kmalloc-16               53453      16     4.7M       1164/6/2   46 0   0  17 PZFU
kmalloc-16384               12   16384   458.7K         14/0/2    1 3   0  42 PZFU
kmalloc-192                999     192   278.5K         68/1/2   15 0   1  68 PZFU
kmalloc-2048               607    2048     1.6M        204/3/2    3 1   1  74 PZFU
kmalloc-256                244     256    90.1K         22/3/2   12 0  13  69 PZFU
kmalloc-32               11176      32     1.1M        288/2/2   39 0   0  30 PZFU
kmalloc-32768                1   32768    65.5K          1/0/0    1 4   0  50 PZFU
kmalloc-4096                41    4096   352.2K         43/0/2    1 1   0  47 PZFU
kmalloc-512                297     512   184.3K         45/4/2    7 0   8  82 PZFU
kmalloc-64                1825      64   262.1K         64/9/2   30 0  14  44 PZFU
kmalloc-8                 5574       8   454.6K        111/1/2   51 0   0   9 PZFU
kmalloc-8192                10    8192   196.6K         12/0/2    1 2   0  41 PZFU
kmalloc-96                 873      96   155.6K         38/3/2   24 0   7  53 PZFU
kmalloc_dma-512              0     512     8.1K          2/0/2    7 0   0   0 dPZFU
mm_struct                   59    1096    90.1K         11/2/2    6 1  18  71 APZFU
mnt_cache                   27     208    12.2K          3/2/0   12 0  66  45 APZFU
mqueue_inode_cache           1    1376     8.1K          1/1/0    5 1 100  16 APZFU
names_cache                  0    4096    16.3K          2/0/2    1 1   0   0 APZFU
pid                        181      64    28.6K          7/2/2   30 0  28  40 PZFU
proc_inode_cache           364    1040   442.3K         54/4/2    7 1   7  85 PaZFU
radix_tree_node           4267     552     2.9M        712/1/2    6 0   0  80 PZFU
RAW                          3    1088     8.1K          1/1/0    6 1 100  39 APZFU
revoke_record                0      32     8.1K          2/2/0   39 0 100   0 APZFU
revoke_table                 4      16     8.1K          2/2/0   46 0 100   0 PZFU
scsi_cmd_cache               6     384     8.1K          2/0/2    8 0   0  28 APZFU
selinux_inode_security    14854     168     3.5M        875/3/2   17 0   0  69 PZFU
sgpool-128                   2    4096    24.5K          3/1/0    1 1  33  33 APZFU
sgpool-16                    2     512     8.1K          2/0/2    6 0   0  12 APZFU
sgpool-32                    2    1024    16.3K          2/1/1    7 1  50  12 APZFU
sgpool-64                    2    2048    16.3K          2/2/0    3 1 100  25 APZFU
sgpool-8                     2     256     8.1K          2/0/2   10 0   0   6 APZFU
shmem_inode_cache          524    1256   729.0K         89/2/1    6 1   2  90 PZFU
sighand_cache              107    2120   311.2K         38/4/2    3 1  10  72 APZFU
signal_cache               107     784   118.7K         29/5/2    4 0  17  70 APZFU
sigqueue                     0     160     8.1K          2/0/2   17 0   0   0 PZFU
skbuff_fclone_cache          0     452     8.1K          2/0/2    7 0   0   0 APZFU
skbuff_head_cache          257     224    98.3K        24/12/2   12 0  50  58 APZFU
sock_inode_cache           168    1128   253.9K         31/5/2    6 1  16  74 APaZFU
sysfs_dir_cache           8336      80     1.3M        322/0/2   26 0   0  50 PZFU
task_struct                181    3600   761.8K         93/5/2    2 1   5  85 PZFU
TCP                          6    2032    40.9K          5/2/2    3 1  40  29 APZFU
tcp_bind_bucket             11      32     8.1K          2/0/2   39 0   0   4 APZFU
tw_sock_TCP                  5     144     4.0K          1/0/1   16 0   0  17 APZFU
UDP                          0    1104    16.3K          2/1/1    6 1  50   0 APZFU
uid_cache                    4      80     8.1K          2/2/0   21 0 100   3 APZFU
UNIX                       144    1216   212.9K         26/4/2    6 1  15  82 APZFU
vm_area_struct            5321     168     1.2M        317/9/2   17 0   2  68 PZFU

--0-968067621-1180012355=:81786--
