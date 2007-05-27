Return-Path: <linux-kernel-owner+w=401wt.eu-S1758061AbXE0Pu5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758061AbXE0Pu5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 May 2007 11:50:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754826AbXE0Puv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 May 2007 11:50:51 -0400
Received: from nz-out-0506.google.com ([64.233.162.236]:5200 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754774AbXE0Puu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 May 2007 11:50:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=eOuizVzUtPxPRNn2KE4RIPIL4BgoDvj60CqrAfKiqctqHR+e7Q2j0BXM/j/7IQHIrucKfXonBMn4UpARfAVFC2+/UOkgLjOubHqVq0vSVm/WWUtkYv91QyoP9+VYO89YkeGH5/g1tIm11GJKynxqK8a8Ve0i7L/iqXv9QB9zyj0=
Message-ID: <b6a2187b0705270850i5f3ac752w470407e8db031b3f@mail.gmail.com>
Date: Sun, 27 May 2007 23:50:46 +0800
From: "Jeff Chua" <jeff.chua.linux@gmail.com>
To: "Linus Torvalds" <torvalds@linux-foundation.org>
Subject: Re: Linux v2.6.22-rc3
Cc: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
In-Reply-To: <alpine.LFD.0.98.0705252008210.26602@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <alpine.LFD.0.98.0705252008210.26602@woody.linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/26/07, Linus Torvalds <torvalds@linux-foundation.org> wrote:

> But now you _can_ do something: you can download the latest -rc kernel,
> and smile smugly to yourself, knowing that you are running the latest and
> greatest on your machine.

Got this only after "recompile". "make clean" will make the warnings go away.

  SYSMAP  System.map
  SYSMAP  .tmp_System.map
  MODPOST vmlinux
WARNING: arch/i386/kernel/built-in.o(.text+0xa677): Section mismatch:
reference to .init.text: (between 'init_intel_cacheinfo' and
'cache_shared_cpu_map_setup')
WARNING: arch/i386/kernel/built-in.o(.text+0xb8c0): Section mismatch:
reference to .init.text: (between 'mtrr_bp_init' and 'mtrr_ap_init')
WARNING: arch/i386/kernel/built-in.o(.text+0xba79): Section mismatch:
reference to .init.text: (between 'mtrr_bp_init' and 'mtrr_ap_init')
WARNING: arch/i386/kernel/built-in.o(.text+0xba7e): Section mismatch:
reference to .init.text: (between 'mtrr_bp_init' and 'mtrr_ap_init')
WARNING: arch/i386/kernel/built-in.o(.text+0xc4a0): Section mismatch:
reference to .init.text: (between 'get_mtrr_state' and 'mtrr_wrmsr')
WARNING: kernel/built-in.o(.text+0x17437): Section mismatch: reference
to .init.text: (between 'kthreadd' and 'init_waitqueue_head')
  AS      arch/i386/boot/setup.o
  LD      arch/i386/boot/setup
  OBJCOPY arch/i386/boot/compressed/vmlinux.bin


Thanks,
Jeff.
