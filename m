Return-Path: <linux-kernel-owner+w=401wt.eu-S932113AbXBKTc7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932113AbXBKTc7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Feb 2007 14:32:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932120AbXBKTc7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Feb 2007 14:32:59 -0500
Received: from wasp.net.au ([203.190.192.17]:42293 "EHLO wasp.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932113AbXBKTc6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Feb 2007 14:32:58 -0500
Message-ID: <45CF6F64.60500@wasp.net.au>
Date: Sun, 11 Feb 2007 23:32:52 +0400
From: Brad Campbell <brad@wasp.net.au>
User-Agent: Thunderbird 1.5.0.9 (X11/20070104)
MIME-Version: 1.0
To: Pierre Ossman <drzeus-mmc@drzeus.cx>
CC: Alex Dubov <oakad@yahoo.com>, linux-kernel@vger.kernel.org
Subject: Re: Recent and not-so problems with tifm_sd driver - one more
References: <113489.35158.qm@web36703.mail.mud.yahoo.com> <45CDC22B.6040408@drzeus.cx> <45CEB1C9.5010103@wasp.net.au> <45CF3904.5070401@drzeus.cx> <45CF3CA3.1010704@wasp.net.au> <45CF5AB0.6080309@drzeus.cx>
In-Reply-To: <45CF5AB0.6080309@drzeus.cx>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Pierre Ossman wrote:
> Brad Campbell wrote:
>> brad@bklaptop2:/$ find sys/devices | grep mmc
>> sys/devices/pci0000:00/0000:00:1e.0/0000:06:05.3/tifm_sd0:3/mmc_host:mmc0
>>
> 
> This is strange. You should be getting more entries below that.

I believe that should be the case..

>> /sys/block/mmcblk0/device
> 
brad@bklaptop2:/sys/block/mmcblk0$ ls -laR
.:
total 0
drwxr-xr-x  6 root root    0 2007-02-11 23:29 .
drwxr-xr-x 13 root root    0 2007-02-11 23:27 ..
-r--r--r--  1 root root 4096 2007-02-11 23:28 dev
lrwxrwxrwx  1 root root    0 2007-02-11 23:27 device -> ../../class/mmc_host/mmc0/mmc0:b368
drwxr-xr-x  2 root root    0 2007-02-11 23:27 holders
drwxr-xr-x  3 root root    0 2007-02-11 23:29 mmcblk0p1
drwxr-xr-x  3 root root    0 2007-02-11 23:27 queue
-r--r--r--  1 root root 4096 2007-02-11 23:29 range
-r--r--r--  1 root root 4096 2007-02-11 23:27 removable
-r--r--r--  1 root root 4096 2007-02-11 23:29 size
drwxr-xr-x  2 root root    0 2007-02-11 23:27 slaves
-r--r--r--  1 root root 4096 2007-02-11 23:29 stat
lrwxrwxrwx  1 root root    0 2007-02-11 23:27 subsystem -> ../../block
--w-------  1 root root 4096 2007-02-11 23:29 uevent

./holders:
total 0
drwxr-xr-x 2 root root 0 2007-02-11 23:27 .
drwxr-xr-x 6 root root 0 2007-02-11 23:29 ..

./mmcblk0p1:
total 0
drwxr-xr-x 3 root root    0 2007-02-11 23:29 .
drwxr-xr-x 6 root root    0 2007-02-11 23:29 ..
-r--r--r-- 1 root root 4096 2007-02-11 23:29 dev
drwxr-xr-x 2 root root    0 2007-02-11 23:27 holders
-r--r--r-- 1 root root 4096 2007-02-11 23:29 size
-r--r--r-- 1 root root 4096 2007-02-11 23:29 start
-r--r--r-- 1 root root 4096 2007-02-11 23:29 stat
lrwxrwxrwx 1 root root    0 2007-02-11 23:29 subsystem -> ../../../block
--w------- 1 root root 4096 2007-02-11 23:29 uevent

./mmcblk0p1/holders:
total 0
drwxr-xr-x 2 root root 0 2007-02-11 23:27 .
drwxr-xr-x 3 root root 0 2007-02-11 23:29 ..

./queue:
total 0
drwxr-xr-x 3 root root    0 2007-02-11 23:27 .
drwxr-xr-x 6 root root    0 2007-02-11 23:29 ..
drwxr-xr-x 2 root root    0 2007-02-11 23:27 iosched
-r--r--r-- 1 root root 4096 2007-02-11 23:29 max_hw_sectors_kb
-rw-r--r-- 1 root root 4096 2007-02-11 23:29 max_sectors_kb
-rw-r--r-- 1 root root 4096 2007-02-11 23:29 nr_requests
-rw-r--r-- 1 root root 4096 2007-02-11 23:29 read_ahead_kb
-rw-r--r-- 1 root root 4096 2007-02-11 23:29 scheduler

./queue/iosched:
total 0
drwxr-xr-x 2 root root    0 2007-02-11 23:27 .
drwxr-xr-x 3 root root    0 2007-02-11 23:29 ..
-rw-r--r-- 1 root root 4096 2007-02-11 23:29 back_seek_max
-rw-r--r-- 1 root root 4096 2007-02-11 23:29 back_seek_penalty
-rw-r--r-- 1 root root 4096 2007-02-11 23:29 fifo_expire_async
-rw-r--r-- 1 root root 4096 2007-02-11 23:29 fifo_expire_sync
-rw-r--r-- 1 root root 4096 2007-02-11 23:29 quantum
-rw-r--r-- 1 root root 4096 2007-02-11 23:29 slice_async
-rw-r--r-- 1 root root 4096 2007-02-11 23:29 slice_async_rq
-rw-r--r-- 1 root root 4096 2007-02-11 23:29 slice_idle
-rw-r--r-- 1 root root 4096 2007-02-11 23:29 slice_sync

./slaves:
total 0
drwxr-xr-x 2 root root 0 2007-02-11 23:27 .
drwxr-xr-x 6 root root 0 2007-02-11 23:29 ..

brad@bklaptop2:/sys/block/mmcblk0$ cd device
brad@bklaptop2:/sys/block/mmcblk0/device$ ls -laR
.:
total 0
drwxr-xr-x 3 root root    0 2007-02-11 23:30 .
drwxr-xr-x 4 root root    0 2007-02-11 23:27 ..
lrwxrwxrwx 1 root root    0 2007-02-11 23:30 block:mmcblk0 -> ../../../../block/mmcblk0
lrwxrwxrwx 1 root root    0 2007-02-11 23:30 bus -> ../../../../bus/mmc
-r--r--r-- 1 root root 4096 2007-02-11 23:30 cid
-r--r--r-- 1 root root 4096 2007-02-11 23:30 csd
-r--r--r-- 1 root root 4096 2007-02-11 23:30 date
lrwxrwxrwx 1 root root    0 2007-02-11 23:27 driver -> ../../../../bus/mmc/drivers/mmcblk
-r--r--r-- 1 root root 4096 2007-02-11 23:30 fwrev
-r--r--r-- 1 root root 4096 2007-02-11 23:30 hwrev
-r--r--r-- 1 root root 4096 2007-02-11 23:30 manfid
-r--r--r-- 1 root root 4096 2007-02-11 23:30 name
-r--r--r-- 1 root root 4096 2007-02-11 23:30 oemid
drwxr-xr-x 2 root root    0 2007-02-11 23:27 power
-r--r--r-- 1 root root 4096 2007-02-11 23:30 scr
-r--r--r-- 1 root root 4096 2007-02-11 23:30 serial
lrwxrwxrwx 1 root root    0 2007-02-11 23:27 subsystem -> ../../../../bus/mmc
--w------- 1 root root 4096 2007-02-11 23:30 uevent

./power:
total 0
drwxr-xr-x 2 root root    0 2007-02-11 23:27 .
drwxr-xr-x 3 root root    0 2007-02-11 23:30 ..
-rw-r--r-- 1 root root 4096 2007-02-11 23:30 wakeup

Alex, it's still hit and miss getting this card detected. I had to insert/remove the card over 10 
times with random driver load/unloads until it created the device entries..

Brad
-- 
"Human beings, who are almost unique in having the ability
to learn from the experience of others, are also remarkable
for their apparent disinclination to do so." -- Douglas Adams
