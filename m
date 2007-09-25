Return-Path: <linux-kernel-owner+w=401wt.eu-S1751726AbXIYIql@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751726AbXIYIql (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2007 04:46:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750851AbXIYIqa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Sep 2007 04:46:30 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:50050 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750758AbXIYIq2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2007 04:46:28 -0400
Date: Tue, 25 Sep 2007 01:46:25 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: linux-kernel@vger.kernel.org
Subject: 2.6.23-rc8-mm1
Message-Id: <20070925014625.3cd5f896.akpm@linux-foundation.org>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.23-rc8/2.6.23-rc8-mm1/

- Various fixes against 2.6.23-rc7-mm1.

- I repulled the subsystem git trees, but not the subsystem quilt trees. 
  Large amounts of stuff broke as a result - not a bad effort for 24 hours :(

- git-sched.patch broke and was dropped

- The cpuidle code wasn't readded to the acpi tree today, so it still isn't in
  2.6.23-rc8-mm1.



Boilerplate:

- See the `hot-fixes' directory for any important updates to this patchset.

- To fetch an -mm tree using git, use (for example)

  git-fetch git://git.kernel.org/pub/scm/linux/kernel/git/smurf/linux-trees.git tag v2.6.16-rc2-mm1
  git-checkout -b local-v2.6.16-rc2-mm1 v2.6.16-rc2-mm1

- -mm kernel commit activity can be reviewed by subscribing to the
  mm-commits mailing list.

        echo "subscribe mm-commits" | mail majordomo@vger.kernel.org

- If you hit a bug in -mm and it is not obvious which patch caused it, it is
  most valuable if you can perform a bisection search to identify which patch
  introduced the bug.  Instructions for this process are at

        http://www.zip.com.au/~akpm/linux/patches/stuff/bisecting-mm-trees.txt

  But beware that this process takes some time (around ten rebuilds and
  reboots), so consider reporting the bug first and if we cannot immediately
  identify the faulty patch, then perform the bisection search.

- When reporting bugs, please try to Cc: the relevant maintainer and mailing
  list on any email.

- When reporting bugs in this kernel via email, please also rewrite the
  email Subject: in some manner to reflect the nature of the bug.  Some
  developers filter by Subject: when looking for messages to read.

- Occasional snapshots of the -mm lineup are uploaded to
  ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/mm/ and are announced on
  the mm-commits list.



Changes since 2.6.23-rc7-mm1:


 git-acpi.patch
 git-alsa.patch
 git-arm.patch
 git-audit-master.patch
 git-avr32.patch
 git-cifs.patch
 git-cpufreq.patch
 git-powerpc.patch
 git-powerpc-galak.patch
 git-drm.patch
 git-dvb.patch
 git-hwmon.patch
 git-gfs2-nmw.patch
 git-hid.patch
 git-ieee1394.patch
 git-infiniband.patch
 git-input.patch
 git-jfs.patch
 git-jg-misc.patch
 git-kbuild.patch
 git-kvm.patch
 git-leds.patch
 git-libata-all.patch
 git-md-accel.patch
 git-mips.patch
 git-mmc.patch
 git-mtd.patch
 git-ubi.patch
 git-net.patch
 git-backlight.patch
 git-nfs.patch
 git-nfsd.patch
 git-ocfs2.patch
 git-r8169.patch
 git-selinux.patch
 git-s390.patch
 git-sh.patch
 git-scsi-misc.patch
 git-block.patch
 git-unionfs.patch
 git-watchdog.patch
 git-wireless.patch
 git-ipwireless_cs.patch
 git-newsetup.patch
 git-xfs.patch
 git-cryptodev.patch
 git-kgdb.patch

 git trees

-alsa-procfs-fix.patch
-ehca_irq-misc-cpuinit-section-annotations-and-ifdef-cleanups.patch
-git-backlight-build-fix.patch

 Merged into mainline or a subsystem tree

-fix-potential-oops-in-generic_setlease-v2.patch

 Folded into fix-potential-oops-in-generic_setlease.patch

+fix-potential-oops-in-generic_setlease-fix.patch

 Fix fix-potential-oops-in-generic_setlease.patch

+fix-modules-oopsing-in-lguest-guests.patch

 lguest fix

+git-cifs-build-fix.patch

 Fix git-cifs.patch

+git-hwmon-fixup.patch

 Fix rejects in git-hwmon.patch

+git-jg-warning-fixes.patch

 Fix git-jg-misc.patch

-git-mips-fixup.patch

 Unneeded

-mips-add-gpio-support-to-the-bcm947xx-platform-update.patch

 Folded into  mips-add-gpio-support-to-the-bcm947xx-platform.patch

-mips-gpio-led-driver-for-the-wgt634u-machine.patch
-mips-move-platform-independent-cfe-code-into-arch-mips-cfe.patch
-mips-add-cfe-support-to-bcm947xx-code.patch

 Merged, or broken by git-mips changes.

+git-net-sctp-build-fix.patch
+mv643xx_eth-remove-redundant-multiple-initialization.patch
+iseries_veth-kill-unused-variable.patch
+git-net-fix-pasemi_mac.patch

 Keep fixing git-net.patch

+net-bluetooth-hidp-corec-make-hidp_setup_input.patch

 bluetooth fix

+git-nfsd-fix-generic_setlease-mismerge.patch
+git-nfsd-fix-memory-shortage-can-result-in-inconsistent-flocks-state.patch

 Fix stuff in git-nfsd.patch

+ipsc-update-version-information.patch

 scsi driver fix

+git-block-dasd_eckd-fix.patch
+git-block-ps3disk-fix.patch

 Fix git-block

+usb-skeleton-leaking-locks-on-open.patch

 USB fix

-iwl3945-is-bust.patch
-git-wireless-b44-is-bust.patch

 Unneeded - wireless got better.

+x86-64-calgary-fix-calgary=disable=busnum-for-calioc2.patch
+x86-64-calgary-get-rid-of-translate_phb.patch

 Calgary updates

+mm-use-pagevec-to-rotate-reclaimable-page-fix-2.patch

 Fix mm-use-pagevec-to-rotate-reclaimable-page.patch some more

+memoryless-nodes-fixup-uses-of-node_online_map-in-generic-code-fix-2-3.patch

 Fix memoryless-nodes-fixup-uses-of-node_online_map-in-generic-code.patch
 some more

+maps-pssproportional-set-size-accounting-in-smaps.patch

 /proc/pid/smaps feature

+oom-move-prototypes-to-appropriate-header-file-fix.patch

 Fix oom-move-prototypes-to-appropriate-header-file.patch

+track-accurate-idle-time-with-tick_schedidle_sleeptime-fix.patch

 Fix track-accurate-idle-time-with-tick_schedidle_sleeptime.patch

-aio-dont-confuse-debug-define-location.patch

 Generated warnings - dropped

+ecryptfs-update-metadata-read-write-functions-cleanup.patch

 Fix ecryptfs-update-metadata-read-write-functions.patch

+ecryptfs-fix-data-types.patch

 Fix ecryptfs patches in -mm

+intel-fb-whitespace-bracket-and-other-clean-ups.patch
+intel-fb-obvious-changes-and-corrections.patch
+intel-fb-force-even-line-count-in-interlaced-mode.patch
+intel-fb-more-interlaced-mode-support.patch

 fbdev updates

+r-o-bind-mounts-elevate-write-count-for-do_utimes-touch-command-causes-oops.patch

 Fix r-o-bind-mounts-elevate-write-count-for-do_utimes.patch

-r-o-bind-mounts-track-number-of-mount-writers-hack-hack-hack.patch
+r-o-bind-mounts-track-number-of-mount-writers-make-lockdep-happy-with-r-o-bind-mounts.patch

 Fix this properly

+ext2-reservations-fix-for-r-o-bind-mounts-take-writer-count-v2.patch

 Fix ext3-reservations.patch for the r-o bind mounts code

+use-extended-crashkernel-command-line-on-i386-fix-config_nohighmem-for-extended-crashkernel-command-line.patch
+use-extended-crashkernel-command-line-on-i386-fix-config_nohighmem-for-extended-crashkernel-command-line-fix.patch

 Fix use-extended-crashkernel-command-line-on-i386.patch

+use-extended-crashkernel-command-line-on-ia64-fix.patch

 Fix use-extended-crashkernel-command-line-on-ia64.patch

+add-documentation-for-extended-crashkernel-syntax-add-extended-crashkernel-syntax-to-kernel-parameterstxt.patch

 Update add-documentation-for-extended-crashkernel-syntax.patch


5381 commits in 2052 patch files

ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.23-rc8/2.6.23-rc8-mm1/patch-list

