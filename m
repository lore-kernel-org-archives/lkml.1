Return-Path: <linux-kernel-owner+w=401wt.eu-S1760750AbXKMEpR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760750AbXKMEpR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Nov 2007 23:45:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756801AbXKMEpF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Nov 2007 23:45:05 -0500
Received: from gate.crashing.org ([63.228.1.57]:52206 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758026AbXKMEpE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Nov 2007 23:45:04 -0500
In-Reply-To: <20071112142132.5fcecce5.akpm@linux-foundation.org>
References: <Pine.LNX.4.64.0711101701360.31912@blarg.am.freescale.net> <20071112142132.5fcecce5.akpm@linux-foundation.org>
Mime-Version: 1.0 (Apple Message framework v752.2)
Content-Type: text/plain; charset=US-ASCII; delsp=yes; format=flowed
Message-Id: <638E6495-4AB8-4167-B3D0-CF7050979993@kernel.crashing.org>
Cc: linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Trond.Myklebust@netapp.com
Content-Transfer-Encoding: 7bit
From: Kumar Gala <galak@kernel.crashing.org>
Subject: Re: [PATCH] NFS: Fix the ustat() regression
Date: Mon, 12 Nov 2007 22:43:48 -0600
To: Andrew Morton <akpm@linux-foundation.org>
X-Mailer: Apple Mail (2.752.2)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Nov 12, 2007, at 4:21 PM, Andrew Morton wrote:

> On Sat, 10 Nov 2007 17:02:19 -0600 (CST) Kumar Gala  
> <galak@kernel.crashing.org> wrote:
>
>> Since 2.6.18, the superblock sb->s_root has been a dummy dentry  
>> with a
>> dummy inode. This breaks ustat(), which actually uses sb->s_root in a
>> vfstat() call.
>>
>> Fix this by making the s_root a dummy alias to the directory inode  
>> that was
>> used when creating the superblock.
>
> I already have this in my
> things-which-need-to-go-into-2.6.24-via-maintainers queue.

Ok, didn't seen one of your normal emails about it going into -mm.   
Anyways, want to make sure this finds its way in to 2.6.24

> That queue is huge:

when is one of your queue's not? :)

- k

> i-oat-add-support-for-version-2-of-ioatdma-device.patch
> reiserfs-dont-drop-pg_dirty-when-releasing-sub-page-sized-dirty- 
> file.patch
> rtc-release-correct-region-in-error-path.patch
> rtc-fallback-to-requesting-only-the-ports-we-actually-use.patch
> i5000_edac-no-need-to-__stringify-kbuild_basename.patch
> serial-only-use-pnp-irq-if-its-valid.patch
> sunrpc-xprtrdma-transportc-fix-use-after-free.patch
> fix-mm-utilckrealloc.patch
> fuse_file_alloc-fix-null-dereferences.patch
> tle62x0-driver-stops-ignoring-read-errors.patch
> rd-fix-data-corruption-on-memory-pressure.patch
> cris-gpio-undo-locks-before-returning.patch
> mips-undo-locking-on-error-path-returns.patch
> mips-undo-locking-on-error-path-returns-checkpatch-fixes.patch
> nfs-fix-the-ustat-regression.patch
> proc-simplify-and-correct-proc_flush_task.patch
> fix-param_sysfs_builtin-name-length-check.patch
> rtc-convert-mutex-to-bitfield.patch
> mark-sys_open-sys_read-exports-unused.patch
> sysctl-fix-token-ring-procname.patch
> gbefb-fix-section-mismatch-warnings.patch
> vmstat-fix-section-mismatch-warning.patch
> pidns-place-under-config_experimental.patch
> pidns-place-under-config_experimental-checkpatch-fixes.patch
> __do_irq-does-not-check-irq_disabled-when-irq_per_cpu-is-set.patch
> hibernate-fix-lockdep-report-2.patch
> smbfs-fix-debug-builds.patch
> fix-64kb-blocksize-in-ext3-directories.patch
> fix-64kb-blocksize-in-ext3-directories-checkpatch-fixes.patch
> uml-fix-spurious-irq-testing.patch
> uml-remove-last-include-of-libc-asm-pageh.patch
> uml-fix-build-for-config_tcp.patch
> uml-fix-build-for-config_printk.patch
> markers-fix-warnings.patch
> swap-delay-accounting-include-lock_page-delays.patch
> file-capabilities-allow-sigcont-within-session-v2.patch
> file-capabilities-allow-sigcont-within-session-v2-checkpatch- 
> fixes.patch
> file-capabilities-allow-sigcont-within-session-v2-file-capabilities- 
> remove-the-non-matching-uid-special-case-for-kill.patch
> feature-removal-schedule-remove-sa_-flags-entry.patch
> kernel-taskstatsc-fix-bogus-nlmsg_free.patch
> x86-show-cpuinfo-only-for-online-cpus.patch
> make-proc-acpi-ac_adapter-dependent-on-acpi_procfs.patch
> acpi-ac-update-ac-state-on-resume.patch
> keyspan-init-termios-properly.patch
> x86-disable-preemption-in-delay_tsc.patch
> tty-fix-network-driver-interactions-with-tcget-set-checkpatch- 
> fixes.patch
> tty-fix-tty-network-driver-interactions-with-tcget-tcset-calls-x86- 
> fix.patch
> x86_64-fix-cpu-hotplug-regression.patch
> oprofile-fix-oops-on-x86-32-bit.patch
> x86-32-bit-ptrace-emulation-mishandles-6th-arg.patch
> net-inet_hashtablesh-needs-vmalloch.patch
>
>
> Maintainers miss a lot of stuff :(
>
>

