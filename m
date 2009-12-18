Return-Path: <linux-kernel-owner+w=401wt.eu-S1752323AbZLRHMZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752323AbZLRHMZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Dec 2009 02:12:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751920AbZLRHMX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Dec 2009 02:12:23 -0500
Received: from qw-out-2122.google.com ([74.125.92.25]:26827 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751225AbZLRHMW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Dec 2009 02:12:22 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=UEYG3e2bGWJEaykiC3UyNV9mMPOveAvZ+gH54k60skwvcFD4sxt/lkEjcfQ54YueDt
         4mP+NjVYJ8DrY5AnQ44s/K/IYf84AbH2877RBVJU3R+aaTsKBKmzfYVdK6OUxejeoGK4
         DuPXXCXJJugo+/gDTZHI52GZXUF9QOhY40TOM=
MIME-Version: 1.0
In-Reply-To: <b1e768440912172008g605bade0ledc77f91eeaa9d36@mail.gmail.com>
References: <b1e768440912172008g605bade0ledc77f91eeaa9d36@mail.gmail.com>
Date: Fri, 18 Dec 2009 15:12:21 +0800
Message-ID: <2375c9f90912172312x7d324979r10da5ecd7edc61d3@mail.gmail.com>
Subject: Re: 2.6.32 Kernel panic - not syncing: Attempted to kill init! 
	Rebooting in 180 seconds..
From: =?UTF-8?Q?Am=C3=A9rico_Wang?= <xiyou.wangcong@gmail.com>
To: Zhiyong Wu <zwu.kernel@gmail.com>
Cc: linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org,
       Herbert Xu <herbert@gondor.apana.org.au>, llim@redhat.com,
       agraf@suse.de
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 18, 2009 at 12:08 PM, Zhiyong Wu <zwu.kernel@gmail.com> wrote:
> HI,
>
> linux-2.6.32 is compiled on a p6 machine with RH5.4 OS and KVM option is enable.
>
> When rebooting this machine, a crash takes place such as:
>
> Loading ramdisk...
> ramdisk loaded at 01700000, size: 2700 Kbytes
> OF stdout device is: /vdevice/vty@30000000
> Preparing to boot Linux version 2.6.32 (root@p6ml4n07.clusters.com)
> (gcc version 4.1.2 20080704 (Red Hat 4.1.2-46)) #1 SMP Fri Dec 18
> 06:53:27 EST 2009
> Calling ibm,client-architecture-support.../
> Elapsed time since release of system processors: 1212 mins 30 secs
>
> Config file read, 1024 bytes
>
> Welcome
> Welcome to yaboot version 1.3.13 (Red Hat 1.3.13-8.el5)
> Enter "help" to get some basic usage information
> boot: linux-32
> Please wait, loading kernel...
>   Elf64 kernel loaded...
> Loading ramdisk...
> ramdisk loaded at 01700000, size: 2700 Kbytes
> OF stdout device is: /vdevice/vty@30000000
> Preparing to boot Linux version 2.6.32 (root@p6ml4n07.clusters.com)
> (gcc version 4.1.2 20080704 (Red Hat 4.1.2-46)) #1 SMP Fri Dec 18
> 06:53:27 EST 2009
> Calling ibm,client-architecture-support... done
> command line: ro console=hvc0 rhgb quiet root=LABEL=/
> memory layout at init:
>  memory_limit : 0000000000000000 (16 MB aligned)
>  alloc_bottom : 00000000019b0000
>  alloc_top    : 0000000008000000
>  alloc_top_hi : 0000000008000000
>  rmo_top      : 0000000008000000
>  ram_top      : 0000000008000000
> instantiating rtas at 0x0000000006e10000... done
> boot cpu hw idx 0000000000000000
> copying OF device tree...
> Building dt strings...
> Building dt structure...
> Device tree strings 0x0000000001bc0000 -> 0x0000000001bc15bb
> Device tree struct  0x0000000001bd0000 -> 0x0000000001bf0000
> Calling quiesce...
> returning from prom_init
> Red Hat nash version 5.1.19.6 starting
> ibmvscsi 30000002: fast_fail not supported in server
> sd 0:0:1:0: [sda] Assuming drive cache: write through
> sd 0:0:1:0: [sda] Assuming drive cache: write through
> sd 0:0:1:0: [sda] Assuming drive cache: write through
> insmod: error inserting '/lib/dm-region-hash.ko': -1 File exists
> mount: could not find filesystem '/dev/root'
> setuproot: moving /dev failed: No such file or directory
> setuproot: error mounting /proc: No such file or directory
> setuproot: error mounting /sys: No such file or directory
> switchroot: mount failed: No such file or directory
> Kernel panic - not syncing: Attempted to kill init!
> Rebooting in 180 seconds..[disconnect]
>
> Can anyone give me a warm hand?

Probably this is not a problem of kernel, maybe it's
a problem of your initial ramdisk, or something wrong with
your root filesystem.

Does changing "root=LABEL=/" to "root=/dev/XXX" help?
Where "/dev/XXX" is your root filesystem.
