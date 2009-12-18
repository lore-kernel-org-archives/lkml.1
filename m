Return-Path: <linux-kernel-owner+w=401wt.eu-S1752095AbZLREIN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752095AbZLREIN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Dec 2009 23:08:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751440AbZLREIL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Dec 2009 23:08:11 -0500
Received: from mail-px0-f174.google.com ([209.85.216.174]:41343 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751201AbZLREIL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Dec 2009 23:08:11 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:cc:content-type;
        b=iaE689Uw4Ckt/WMATdulCq5mLiRiveATsVrfAFTUI0JotGuxrTSkhfswfXLONMFiHI
         H2LJ+HRJbVIeQO0FUZYYbD+aNvvQPYBeeRNteMINR5scCqITZVxGpJ+wbVR/Aa9vo3IW
         L0Lwa8eHzIJHYmkWJtg2fMNxqx25RVIt5aMag=
MIME-Version: 1.0
Date: Fri, 18 Dec 2009 12:08:09 +0800
Message-ID: <b1e768440912172008g605bade0ledc77f91eeaa9d36@mail.gmail.com>
Subject: 2.6.32 Kernel panic - not syncing: Attempted to kill init! Rebooting 
	in 180 seconds..
From: Zhiyong Wu <zwu.kernel@gmail.com>
To: linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org
Cc: Zhiyong Wu <zwu.kernel@gmail.com>,
       Herbert Xu <herbert@gondor.apana.org.au>, llim@redhat.com,
       agraf@suse.de
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

HI,

linux-2.6.32 is compiled on a p6 machine with RH5.4 OS and KVM option is enable.

When rebooting this machine, a crash takes place such as:

Loading ramdisk...
ramdisk loaded at 01700000, size: 2700 Kbytes
OF stdout device is: /vdevice/vty@30000000
Preparing to boot Linux version 2.6.32 (root@p6ml4n07.clusters.com)
(gcc version 4.1.2 20080704 (Red Hat 4.1.2-46)) #1 SMP Fri Dec 18
06:53:27 EST 2009
Calling ibm,client-architecture-support.../
Elapsed time since release of system processors: 1212 mins 30 secs

Config file read, 1024 bytes

Welcome
Welcome to yaboot version 1.3.13 (Red Hat 1.3.13-8.el5)
Enter "help" to get some basic usage information
boot: linux-32
Please wait, loading kernel...
   Elf64 kernel loaded...
Loading ramdisk...
ramdisk loaded at 01700000, size: 2700 Kbytes
OF stdout device is: /vdevice/vty@30000000
Preparing to boot Linux version 2.6.32 (root@p6ml4n07.clusters.com)
(gcc version 4.1.2 20080704 (Red Hat 4.1.2-46)) #1 SMP Fri Dec 18
06:53:27 EST 2009
Calling ibm,client-architecture-support... done
command line: ro console=hvc0 rhgb quiet root=LABEL=/
memory layout at init:
  memory_limit : 0000000000000000 (16 MB aligned)
  alloc_bottom : 00000000019b0000
  alloc_top    : 0000000008000000
  alloc_top_hi : 0000000008000000
  rmo_top      : 0000000008000000
  ram_top      : 0000000008000000
instantiating rtas at 0x0000000006e10000... done
boot cpu hw idx 0000000000000000
copying OF device tree...
Building dt strings...
Building dt structure...
Device tree strings 0x0000000001bc0000 -> 0x0000000001bc15bb
Device tree struct  0x0000000001bd0000 -> 0x0000000001bf0000
Calling quiesce...
returning from prom_init
Red Hat nash version 5.1.19.6 starting
ibmvscsi 30000002: fast_fail not supported in server
sd 0:0:1:0: [sda] Assuming drive cache: write through
sd 0:0:1:0: [sda] Assuming drive cache: write through
sd 0:0:1:0: [sda] Assuming drive cache: write through
insmod: error inserting '/lib/dm-region-hash.ko': -1 File exists
mount: could not find filesystem '/dev/root'
setuproot: moving /dev failed: No such file or directory
setuproot: error mounting /proc: No such file or directory
setuproot: error mounting /sys: No such file or directory
switchroot: mount failed: No such file or directory
Kernel panic - not syncing: Attempted to kill init!
Rebooting in 180 seconds..[disconnect]

Can anyone give me a warm hand?


Cheers,

Zhiyong Wu
