Return-Path: <linux-kernel-owner+w=401wt.eu-S1756076AbYD2LsU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756076AbYD2LsU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2008 07:48:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751585AbYD2LsH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Apr 2008 07:48:07 -0400
Received: from an-out-0708.google.com ([209.85.132.248]:51372 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751216AbYD2LsE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2008 07:48:04 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=TVZe99nfhD3lrX1K5eIbkRK1wBMRja1dabAM8eBiMmuCi++q3OutwiYqVzc/O373DQRL7SdA/icv01hQsJkLwFQfbTU1R3gEEya1Eufy5BWAEbQIcg3NBD2v6MFG+vb/hOzar3njXfNEIqcIG0bUr1Yb/8bjy58qGK8n/JbgBoE=
Message-ID: <804dabb00804290447jd80b1bdp798b823a6cb10b62@mail.gmail.com>
Date: Tue, 29 Apr 2008 19:47:55 +0800
From: "Peter Teoh" <htmldeveloper@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Subject: conflicted merge for sched-devel?
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This morning (about 11 hours ago) I did a git pull in sched-devel
today and got a problem:

/mnt/hd0/download/linux_sched/linux-2.6-sched-devel>git pull
remote: Counting objects: 10018, done.
remote: Compressing objects: 100% (1515/1515), done.
Indexing 7753 objects...
remote: Total 7753 (delta 6571), reused 7403 (delta 6233)
 100% (7753/7753) done
Resolving 6571 deltas...
 100% (6571/6571) done
1292 objects were added to complete this thin pack.
* refs/remotes/origin/base: fast forward to branch 'base' of
git://git.kernel.org/pub/scm/linux/kernel/git/mingo/linux-2.6-sched-devel
  old..new: b69d398..4a27214
* refs/remotes/origin/for-akpm: forcing update to non-fast forward
branch 'for-akpm' of
git://git.kernel.org/pub/scm/linux/kernel/git/mingo/linux-2.6-sched-devel
  old...new: ea4796c...5839a00
* refs/remotes/origin/for-linus: fast forward to branch 'for-linus' of
git://git.kernel.org/pub/scm/linux/kernel/git/mingo/linux-2.6-sched-devel
  old..new: 00c6b2d..dd54904
* refs/remotes/origin/latest: forcing update to non-fast forward
branch 'latest' of
git://git.kernel.org/pub/scm/linux/kernel/git/mingo/linux-2.6-sched-devel
  old...new: ea0fc5a...0a987b3
* refs/remotes/origin/master: forcing update to non-fast forward
branch 'master' of
git://git.kernel.org/pub/scm/linux/kernel/git/mingo/linux-2.6-sched-devel
  old...new: ea0fc5a...0a987b3
Renamed arch/x86/xen/events.c->drivers/xen/events.c
Auto-merged drivers/xen/events.c
Removed Documentation/smart-config.txt
Auto-merged Makefile
Removed arch/powerpc/platforms/celleb/Kconfig
Removed arch/powerpc/platforms/celleb/Makefile
Removed arch/powerpc/platforms/celleb/io-workarounds.c
Removed arch/ppc/configs/ads8272_defconfig
Removed arch/ppc/configs/mpc86x_ads_defconfig
Removed arch/ppc/configs/mpc885ads_defconfig
Removed arch/ppc/platforms/mpc8272ads_setup.c
Removed arch/ppc/platforms/mpc885ads.h
Removed arch/ppc/platforms/mpc885ads_setup.c
Removed arch/ppc/platforms/pq2ads.c
Removed arch/ppc/platforms/pq2ads.h
Removed arch/ppc/platforms/pq2ads_pd.h
Auto-merged arch/um/Kconfig.i386
CONFLICT (content): Merge conflict in arch/um/Kconfig.i386
Auto-merged arch/um/Kconfig.x86_64
Auto-merged arch/x86/Kconfig
Auto-merged arch/x86/Kconfig.cpu
Auto-merged arch/x86/Makefile
Auto-merged arch/x86/kernel/Makefile
Auto-merged arch/x86/kernel/entry_32.S
Auto-merged arch/x86/kernel/entry_64.S
CONFLICT (content): Merge conflict in arch/x86/kernel/entry_64.S
Auto-merged arch/x86/kernel/paravirt.c
Auto-merged arch/x86/kernel/reboot.c
Auto-merged arch/x86/kernel/traps_32.c
Auto-merged arch/x86/kernel/traps_64.c
Auto-merged arch/x86/kernel/vmi_32.c
Auto-merged arch/x86/kernel/vmlinux_32.lds.S
Auto-merged arch/x86/mm/fault.c
Auto-merged arch/x86/mm/init_32.c
Auto-merged arch/x86/mm/mmio-mod.c
CONFLICT (add/add): Merge conflict in arch/x86/mm/mmio-mod.c
Auto-merged arch/x86/mm/pat.c
Auto-merged arch/x86/xen/enlighten.c
CONFLICT (content): Merge conflict in arch/x86/xen/enlighten.c
Removed drivers/md/kcopyd.h
Auto-merged include/asm-generic/vmlinux.lds.h
Auto-merged include/asm-x86/irqflags.h
Auto-merged include/asm-x86/kdebug.h
Auto-merged include/asm-x86/paravirt.h
Auto-merged include/linux/fs.h
Removed include/linux/hdsmart.h
Auto-merged include/linux/ide.h
Auto-merged include/linux/sched.h
CONFLICT (content): Merge conflict in include/linux/sched.h
Auto-merged init/main.c
CONFLICT (content): Merge conflict in init/main.c
Auto-merged kernel/Makefile
Auto-merged kernel/fork.c
CONFLICT (content): Merge conflict in kernel/fork.c
Auto-merged kernel/kthread.c
CONFLICT (content): Merge conflict in kernel/kthread.c
Auto-merged kernel/lockdep.c
CONFLICT (content): Merge conflict in kernel/lockdep.c
Auto-merged kernel/printk.c
Auto-merged kernel/sched.c
CONFLICT (content): Merge conflict in kernel/sched.c
Auto-merged kernel/sched_fair.c
CONFLICT (content): Merge conflict in kernel/sched_fair.c
Auto-merged kernel/sched_rt.c
Auto-merged kernel/signal.c
Auto-merged kernel/softirq.c
Auto-merged kernel/trace/ftrace.c
CONFLICT (add/add): Merge conflict in kernel/trace/ftrace.c
Auto-merged kernel/trace/trace.h
CONFLICT (add/add): Merge conflict in kernel/trace/trace.h
Auto-merged kernel/trace/trace_sched_switch.c
CONFLICT (add/add): Merge conflict in kernel/trace/trace_sched_switch.c
Auto-merged kernel/trace/trace_sched_wakeup.c
CONFLICT (add/add): Merge conflict in kernel/trace/trace_sched_wakeup.c
Auto-merged lib/Kconfig.debug
Automatic merge failed; fix conflicts and then commit the result.

And git status gives the following files unchanged (after a lot of others :

# Changed but not updated:
#   (use "git add <file>..." to update what will be committed)
#
#       unmerged:   arch/um/Kconfig.i386
#       modified:   arch/um/Kconfig.i386
#       unmerged:   arch/x86/kernel/entry_64.S
#       modified:   arch/x86/kernel/entry_64.S
#       unmerged:   arch/x86/mm/mmio-mod.c
#       modified:   arch/x86/mm/mmio-mod.c
#       unmerged:   arch/x86/xen/enlighten.c
#       modified:   arch/x86/xen/enlighten.c
#       unmerged:   include/linux/sched.h
#       modified:   include/linux/sched.h
#       unmerged:   init/main.c
#       modified:   init/main.c
#       unmerged:   kernel/fork.c
#       modified:   kernel/fork.c
#       unmerged:   kernel/kthread.c
#       modified:   kernel/kthread.c
#       unmerged:   kernel/lockdep.c
#       modified:   kernel/lockdep.c
#       unmerged:   kernel/sched.c
#       modified:   kernel/sched.c
#       unmerged:   kernel/sched_fair.c
#       modified:   kernel/sched_fair.c
#       unmerged:   kernel/trace/ftrace.c
#       modified:   kernel/trace/ftrace.c
#       unmerged:   kernel/trace/trace.h
#       modified:   kernel/trace/trace.h
#       unmerged:   kernel/trace/trace_sched_switch.c
#       modified:   kernel/trace/trace_sched_switch.c
#       unmerged:   kernel/trace/trace_sched_wakeup.c
#       modified:   kernel/trace/trace_sched_wakeup.c


Can I know:

a.   what is the cause of this problem?
b.   how do I resolve the issue?

Thank you very much.

-- 
Regards,
Peter Teoh
