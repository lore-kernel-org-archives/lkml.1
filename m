Return-Path: <linux-kernel-owner+w=401wt.eu-S932634AbXCRShJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932634AbXCRShJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Mar 2007 14:37:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932074AbXCRShJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 Mar 2007 14:37:09 -0400
Received: from ug-out-1314.google.com ([66.249.92.169]:55047 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932634AbXCRShH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Mar 2007 14:37:07 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding:from;
        b=cZVaTsb8+6c1j4hKDvJjI6sXF1pdZJUqp5ELz3NhyqvH24NrGL+J3iwO9NT/l6eTFJa/AnGJ2jjizhk3OPSIVZWYiOg1LXSTpQkKaHKmTXzZG6H9xmwF4UvAce9KxzINFt1fuNALdweF3TzMtNqqKsZHSvqk29x489w1tKHyeEc=
Message-ID: <45FD8684.4030501@googlemail.com>
Date: Sun, 18 Mar 2007 19:35:48 +0100
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: LKML <linux-kernel@vger.kernel.org>
Subject: Re: mm snapshot broken-out-2007-03-18-02-44.tar.gz uploaded
References: <200703180946.l2I9kTVc020636@shell0.pdx.osdl.net>
In-Reply-To: <200703180946.l2I9kTVc020636@shell0.pdx.osdl.net>
X-Enigmail-Version: 0.94.1.1
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 8bit
From: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

akpm@linux-foundation.org napisa³(a):
> The mm snapshot broken-out-2007-03-18-02-44.tar.gz has been uploaded to
> 
>    ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/mm/broken-out-2007-03-18-02-44.tar.gz
> 
> It contains the following patches against 2.6.21-rc4:
> 

Interesting

Freeing unused kernel memory: 204k freed
Write protecting the kernel read-only data: 917k
PM: Adding info for No Bus:vcs1
PM: Adding info for No Bus:vcsa1
Failed to execute /init
Kernel panic - not syncing: No init found.  Try passing init= option to kernel.

It's not a new-kernel-pkg (Fedora initrd generator) related issue, 2.6.21-rc4-git2
boots fine.

  LD      .tmp_vmlinux1
  KSYM    .tmp_kallsyms1.S
  AS      .tmp_kallsyms1.o
  LD      .tmp_vmlinux2
  KSYM    .tmp_kallsyms2.S
  AS      .tmp_kallsyms2.o
  LD      vmlinux
  SYSMAP  System.map
  SYSMAP  .tmp_System.map
  MODPOST vmlinux
WARNING: could not find versions for .tmp_versions/head.mod
WARNING: could not find versions for .tmp_versions/init_task.mod
WARNING: init/built-in.o - Section mismatch: reference to .init.text: from .text between 'rest_init' (at offset 0x101) and 'try_name'
WARNING: could not find versions for .tmp_versions/built-in.mod
WARNING: could not find versions for .tmp_versions/built-in.mod
WARNING: arch/i386/kernel/built-in.o - Section mismatch: reference to .init.text:irqbalance_disable from .text between 'quirk_intel_irqbalance' (at offset 0x82ef) and 'i8237A_suspend'
WARNING: arch/i386/kernel/built-in.o - Section mismatch: reference to .init.text:sysenter_setup from .text between 'identify_cpu' (at offset 0x97a0) and 'display_cacheinfo'
WARNING: arch/i386/kernel/built-in.o - Section mismatch: reference to .init.text:mtrr_bp_init from .text between 'identify_cpu' (at offset 0x97aa) and 'display_cacheinfo'
WARNING: could not find versions for .tmp_versions/built-in.mod
WARNING: could not find versions for .tmp_versions/built-in.mod
WARNING: could not find versions for .tmp_versions/built-in.mod
WARNING: could not find versions for .tmp_versions/built-in.mod
WARNING: mm/built-in.o - Section mismatch: reference to .init.data:initkmem_list3 from .text between 'set_up_list3s' (at offset 0x1c77f) and 's_start'
WARNING: could not find versions for .tmp_versions/built-in.mod
WARNING: could not find versions for .tmp_versions/built-in.mod
WARNING: could not find versions for .tmp_versions/built-in.mod
WARNING: could not find versions for .tmp_versions/built-in.mod
WARNING: could not find versions for .tmp_versions/built-in.mod
WARNING: could not find versions for .tmp_versions/built-in.mod
WARNING: could not find versions for .tmp_versions/built-in.mod
WARNING: could not find versions for .tmp_versions/built-in.mod
WARNING: could not find versions for .tmp_versions/built-in.mod
WARNING: could not find versions for .tmp_versions/built-in.mod
WARNING: could not find versions for .tmp_versions/built-in.mod
WARNING: could not find versions for .tmp_versions/built-in.mod
  AS      arch/i386/boot/setup.o
  LD      arch/i386/boot/setup
  OBJCOPY arch/i386/boot/compressed/vmlinux.bin
  GZIP    arch/i386/boot/compressed/vmlinux.bin.gz
  LD      arch/i386/boot/compressed/piggy.o
  LD      arch/i386/boot/compressed/vmlinux
  OBJCOPY arch/i386/boot/vmlinux.bin
  BUILD   arch/i386/boot/bzImage
Root device is (8, 1)
Boot sector 512 bytes.
Setup is 7025 bytes.
System is 1823 kB
Kernel: arch/i386/boot/bzImage is ready  (#3)

http://www.stardust.webpages.pl/files/tbf/bitis-gabonica/broken-out-2007-03-18-02-44/mm-config
http://www.stardust.webpages.pl/files/tbf/bitis-gabonica/broken-out-2007-03-18-02-44/mm-console.log

Regards,
Michal

-- 
Michal K. K. Piotrowski
LTG - Linux Testers Group (PL)
(http://www.stardust.webpages.pl/ltg/)
LTG - Linux Testers Group (EN)
(http://www.stardust.webpages.pl/linux_testers_group_en/)
