Return-Path: <linux-kernel-owner+w=401wt.eu-S965501AbXFGFDe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965501AbXFGFDe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2007 01:03:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754129AbXFGFDW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jun 2007 01:03:22 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:42710 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753903AbXFGFDV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2007 01:03:21 -0400
Date: Wed, 6 Jun 2007 22:03:13 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: linux-kernel@vger.kernel.org
Subject: 2.6.22-rc4-mm2
Message-Id: <20070606220313.8f7c1fab.akpm@linux-foundation.org>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.22-rc4/2.6.22-rc4-mm2/

- Basically a bugfixed version of 2.6.22-rc4-mm1.  None of the subsystem
  trees were repulled, several bad patches were dropped, a few were fixed.


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



Changes since 2.6.22-rc4-mm1:

 git-acpi.patch
 git-alsa.patch
 git-arm-master.patch
 git-arm.patch
 git-avr32.patch
 git-cifs.patch
 git-cpufreq.patch
 git-drm.patch
 git-dvb.patch
 git-gfs2-nmw.patch
 git-hid.patch
 git-ieee1394.patch
 git-infiniband.patch
 git-input.patch
 git-kbuild.patch
 git-kvm.patch
 git-leds.patch
 git-libata-all.patch
 git-md-accel.patch
 git-mips.patch
 git-mmc.patch
 git-ubi.patch
 git-netdev-all.patch
 git-net.patch
 git-backlight.patch
 git-battery.patch
 git-ioat.patch
 git-nfs.patch
 git-nfs-server-cluster-locking-api.patch
 git-ocfs2.patch
 git-parisc.patch
 git-r8169.patch
 git-selinux.patch
 git-s390.patch
 git-sh.patch
 git-scsi-misc.patch
 git-scsi-rc-fixes.patch
 git-scsi-target.patch
 git-unionfs.patch
 git-watchdog.patch
 git-wireless.patch
 git-ipwireless_cs.patch
 git-newsetup.patch
 git-xfs.patch
 git-cryptodev.patch
 git-xtensa.patch
 git-gccbug.patch

 git trees

+char-stallion-dont-fail-with-less-than-max-panels.patch
+char-stallion-alloc-tty-before-pci-devices-init.patch
+char-stallion-proper-fail-return-values.patch
+frv-build-fix.patch
+uml-get-declaration-of-simple_strtoul.patch
+isdn-diva-fix-section-mismatch.patch

 2.6.22 queue

+git-acpi-disable-acpi_processor_throttling_seq_show.patch

 Attempt to stop acpi oopsing

+toshica_acpi-fix-section-mismatch-in-allyesconfig.patch

 section fix

+revert-gregkh-driver-block-device.patch

 Revert dud patch from driver tree

+mac80211-fix-1-bit-bitfield-to-unsigned.patch

 wireless sparse fix

+x86_64-acpi-disable-srat-when-numa-emulation-succeeds-fix.patch

 Fix x86_64-acpi-disable-srat-when-numa-emulation-succeeds.patch

-mmconfig-validate-against-acpi-motherboard-resources.patch

 Dropped due to compilation errors

+paravirt-helper-to-disable-all-io-space-fix-2.patch
+paravirt-helper-to-disable-all-io-space-fix-3.patch

 Fix paravirt-helper-to-disable-all-io-space-fix.patch

+sata_promise-use-tf-interface-for-polling-nodata-commands.patch

 SATA Promise fix

+serial-convert-early_uart-to-earlycon-for-8250-fix.patch

 Fix serial-convert-early_uart-to-earlycon-for-8250.patch for ia64

-slub-use-ilog2-instead-of-series-of-constant-comparisons.patch

 Dropped due to gcc-3.3.3 bustage

+mm-merge-nopfn-into-fault-spufs-fix.patch

 Fix mm-merge-nopfn-into-fault.patch compile

+pm-introduce-hibernation-and-suspend-notifiers-fix-fix.patch

 Fix pm-introduce-hibernation-and-suspend-notifiers.patch compile again

-define-new-percpu-interface-for-shared-data.patch
-use-the-new-percpu-interface-for-shared-data.patch

 Dropped because it caused hangs in Michal's testing

+undeprecate-raw-driver.patch
+hfsplus-change-kmalloc-memset-to-kzalloc.patch
+submitchecklist-update-fix-spelling-error.patch
+fix-typo-in-prefetchh.patch

 Misc fixes

+spi_mpc83xxc-underclocking-hotfix.patch

 Fix an SPI driver

-sane-irq-initialization-in-sedlbauer-hisax.patch
+sane-irq-initialization-in-sedlbauer-hisax.patch

 New, fixed version of this ISDN patch

+matroxfb-color-setting-fixes-fix.patch

 fbdev fix

+schedstats-fix-printk-format.patch

 printk fix

-arch-personality-independent-stack-top.patch
-audit-rework-execve-audit.patch
-audit-rework-execve-audit-fix.patch
-mm-move_page_tables_up.patch
-mm-variable-length-argument-support.patch
-mm-variable-length-argument-support-fix.patch

 Dropped due to build problems and some BUG_ON() triggerings.  Will be
 updated.

+drivers-edac-new-intel-5000-mc-driver-fix.patch

 Fix drivers-edac-new-intel-5000-mc-driver.patch

+containersv10-basic-container-framework-fix-2.patch

 Fix boot-time hangs caused by
 containersv10-basic-container-framework-fix.patch



All 1208 patches:

ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.22-rc4/2.6.22-rc4-mm2/patch-list



