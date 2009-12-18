Return-Path: <linux-kernel-owner+w=401wt.eu-S1752057AbZLRGvK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752057AbZLRGvK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Dec 2009 01:51:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751860AbZLRGvJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Dec 2009 01:51:09 -0500
Received: from mail-yx0-f187.google.com ([209.85.210.187]:65049 "EHLO
	mail-yx0-f187.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751922AbZLRGvH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Dec 2009 01:51:07 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=EOkeqCPqIHJ59PBkv5bqvWfs7fCSTmbKmwDi0np/oNHvr7U8W6zd7kU/SLfyPDu9h9
         isQMVFQLOguXb5XAVgoWXuFkXwhiIOLKukjLVCu+rXP8M7p2+VXVa9j6dPnKXBWvHtxb
         Jmxrk4vBGZE4+qJLTFLNm76+fBMXUXWds5TRU=
MIME-Version: 1.0
In-Reply-To: <b1e768440912172008g605bade0ledc77f91eeaa9d36@mail.gmail.com>
References: <b1e768440912172008g605bade0ledc77f91eeaa9d36@mail.gmail.com>
From: Barry Song <21cnbao@gmail.com>
Date: Fri, 18 Dec 2009 14:50:42 +0800
Message-ID: <3c17e3570912172250l3515de1dub187da76302a1e50@mail.gmail.com>
Subject: Re: 2.6.32 Kernel panic - not syncing: Attempted to kill init! 
	Rebooting in 180 seconds..
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

Your rootfs is not ready. No console, no /dev, then init process can't start-up.

>
> Can anyone give me a warm hand?
>
>
> Cheers,
>
> Zhiyong Wu
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
