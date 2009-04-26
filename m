Return-Path: <linux-kernel-owner+w=401wt.eu-S1756715AbZDZUFi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756715AbZDZUFi (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Apr 2009 16:05:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755281AbZDZUF3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 26 Apr 2009 16:05:29 -0400
Received: from mail.cyberdogtech.com ([64.22.125.39]:33818 "EHLO
	mail.cyberdogtech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753585AbZDZUF0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Apr 2009 16:05:26 -0400
X-Greylist: delayed 672 seconds by postgrey-1.27 at vger.kernel.org; Sun, 26 Apr 2009 16:05:25 EDT
From: Matt LaPlante <kernel1@cyberdogtech.com>
To: linux-kernel@vger.kernel.org
Cc: trivial@kernel.org, Matt LaPlante <kernel1@cyberdogtech.com>
Subject: [PATCH] Miscellaneous documentation cleanup: 2.6.30-rc3
Date: Sun, 26 Apr 2009 14:54:08 -0500
Message-Id: <1240775648-20094-1-git-send-email-kernel1@cyberdogtech.com>
X-Mailer: git-send-email 1.6.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix various typos in documentation txts.

Signed-off-by: Matt LaPlante <kernel1@cyberdogtech.com>

diff --git a/Documentation/DMA-API.txt b/Documentation/DMA-API.txt
index d9aa43d..04cc0bc 100644
--- a/Documentation/DMA-API.txt
+++ b/Documentation/DMA-API.txt
@@ -676,8 +676,8 @@ this directory the following files can currently be found:
 	dma-api/all_errors	This file contains a numeric value. If this
 				value is not equal to zero the debugging code
 				will print a warning for every error it finds
-				into the kernel log. Be carefull with this
-				option. It can easily flood your logs.
+				into the kernel log. Be careful with this
+				option, as it can easily flood your logs.
 
 	dma-api/disabled	This read-only file contains the character 'Y'
 				if the debugging code is disabled. This can
diff --git a/Documentation/RCU/rculist_nulls.txt b/Documentation/RCU/rculist_nulls.txt
index 6389dec..93cb28d 100644
--- a/Documentation/RCU/rculist_nulls.txt
+++ b/Documentation/RCU/rculist_nulls.txt
@@ -118,7 +118,7 @@ to another chain) checking the final 'nulls' value if
 the lookup met the end of chain. If final 'nulls' value
 is not the slot number, then we must restart the lookup at
 the beginning. If the object was moved to the same chain,
-then the reader doesnt care : It might eventually
+then the reader doesn't care : It might eventually
 scan the list again without harm.
 
 
diff --git a/Documentation/SM501.txt b/Documentation/SM501.txt
index 6fc6560..561826f 100644
--- a/Documentation/SM501.txt
+++ b/Documentation/SM501.txt
@@ -5,7 +5,7 @@ Copyright 2006, 2007 Simtec Electronics
 
 The Silicon Motion SM501 multimedia companion chip is a multifunction device
 which may provide numerous interfaces including USB host controller USB gadget,
-Asyncronous Serial ports, Audio functions and a dual display video interface.
+asynchronous serial ports, audio functions, and a dual display video interface.
 The device may be connected by PCI or local bus with varying functions enabled.
 
 Core
diff --git a/Documentation/block/deadline-iosched.txt b/Documentation/block/deadline-iosched.txt
index 7257676..2d82c80 100644
--- a/Documentation/block/deadline-iosched.txt
+++ b/Documentation/block/deadline-iosched.txt
@@ -58,7 +58,7 @@ same criteria as reads.
 front_merges	(bool)
 ------------
 
-Sometimes it happens that a request enters the io scheduler that is contigious
+Sometimes it happens that a request enters the io scheduler that is contiguous
 with a request that is already on the queue. Either it fits in the back of that
 request, or it fits at the front. That is called either a back merge candidate
 or a front merge candidate. Due to the way files are typically laid out,
diff --git a/Documentation/braille-console.txt b/Documentation/braille-console.txt
index 000b0fb..d0d042c 100644
--- a/Documentation/braille-console.txt
+++ b/Documentation/braille-console.txt
@@ -27,7 +27,7 @@ parameter.
 
 For simplicity, only one braille console can be enabled, other uses of
 console=brl,... will be discarded.  Also note that it does not interfere with
-the console selection mecanism described in serial-console.txt
+the console selection mechanism described in serial-console.txt
 
 For now, only the VisioBraille device is supported.
 
diff --git a/Documentation/driver-model/devres.txt b/Documentation/driver-model/devres.txt
index 387b8a7..d79aead 100644
--- a/Documentation/driver-model/devres.txt
+++ b/Documentation/driver-model/devres.txt
@@ -188,7 +188,7 @@ For example, you can do something like the following.
 
   void my_midlayer_destroy_something()
   {
-	devres_release_group(dev, my_midlayer_create_soemthing);
+	devres_release_group(dev, my_midlayer_create_something);
   }
 
 
diff --git a/Documentation/edac.txt b/Documentation/edac.txt
index 8eda3fb..06f8f46 100644
--- a/Documentation/edac.txt
+++ b/Documentation/edac.txt
@@ -23,8 +23,8 @@ first time, it was renamed to 'EDAC'.
 The bluesmoke project at sourceforge.net is now utilized as a 'staging area'
 for EDAC development, before it is sent upstream to kernel.org
 
-At the bluesmoke/EDAC project site, is a series of quilt patches against
-recent kernels, stored in a SVN respository. For easier downloading, there
+At the bluesmoke/EDAC project site is a series of quilt patches against
+recent kernels, stored in a SVN repository. For easier downloading, there
 is also a tarball snapshot available.
 
 ============================================================================
@@ -73,9 +73,9 @@ the vendor should tie the parity status bits to 0 if they do not intend
 to generate parity.  Some vendors do not do this, and thus the parity bit
 can "float" giving false positives.
 
-In the kernel there is a pci device attribute located in sysfs that is
+In the kernel there is a PCI device attribute located in sysfs that is
 checked by the EDAC PCI scanning code. If that attribute is set,
-PCI parity/error scannining is skipped for that device. The attribute
+PCI parity/error scanning is skipped for that device. The attribute
 is:
 
 	broken_parity_status
diff --git a/Documentation/fb/sh7760fb.txt b/Documentation/fb/sh7760fb.txt
index c87bfe5..b994c3b 100644
--- a/Documentation/fb/sh7760fb.txt
+++ b/Documentation/fb/sh7760fb.txt
@@ -1,7 +1,7 @@
 SH7760/SH7763 integrated LCDC Framebuffer driver
 ================================================
 
-0. Overwiew
+0. Overview
 -----------
 The SH7760/SH7763 have an integrated LCD Display controller (LCDC) which
 supports (in theory) resolutions ranging from 1x1 to 1024x1024,
diff --git a/Documentation/filesystems/autofs4-mount-control.txt b/Documentation/filesystems/autofs4-mount-control.txt
index c634174..8f78ded 100644
--- a/Documentation/filesystems/autofs4-mount-control.txt
+++ b/Documentation/filesystems/autofs4-mount-control.txt
@@ -369,7 +369,7 @@ The call requires an initialized struct autofs_dev_ioctl. There are two
 possible variations. Both use the path field set to the path of the mount
 point to check and the size field adjusted appropriately. One uses the
 ioctlfd field to identify a specific mount point to check while the other
-variation uses the path and optionaly arg1 set to an autofs mount type.
+variation uses the path and optionally arg1 set to an autofs mount type.
 The call returns 1 if this is a mount point and sets arg1 to the device
 number of the mount and field arg2 to the relevant super block magic
 number (described below) or 0 if it isn't a mountpoint. In both cases
diff --git a/Documentation/filesystems/caching/netfs-api.txt b/Documentation/filesystems/caching/netfs-api.txt
index 4db125b..2666b1e 100644
--- a/Documentation/filesystems/caching/netfs-api.txt
+++ b/Documentation/filesystems/caching/netfs-api.txt
@@ -184,7 +184,7 @@ This has the following fields:
      have index children.
 
      If this function is not supplied or if it returns NULL then the first
-     cache in the parent's list will be chosed, or failing that, the first
+     cache in the parent's list will be chosen, or failing that, the first
      cache in the master list.
 
  (4) A function to retrieve an object's key from the netfs [mandatory].
diff --git a/Documentation/filesystems/ext4.txt b/Documentation/filesystems/ext4.txt
index 97882df..608fdba 100644
--- a/Documentation/filesystems/ext4.txt
+++ b/Documentation/filesystems/ext4.txt
@@ -294,7 +294,7 @@ max_batch_time=usec	Maximum amount of time ext4 should wait for
 			amount of time (on average) that it takes to
 			finish committing a transaction.  Call this time
 			the "commit time".  If the time that the
-			transactoin has been running is less than the
+			transaction has been running is less than the
 			commit time, ext4 will try sleeping for the
 			commit time to see if other operations will join
 			the transaction.   The commit time is capped by
@@ -328,7 +328,7 @@ noauto_da_alloc		replacing existing files via patterns such as
 			journal commit, in the default data=ordered
 			mode, the data blocks of the new file are forced
 			to disk before the rename() operation is
-			commited.  This provides roughly the same level
+			committed.  This provides roughly the same level
 			of guarantees as ext3, and avoids the
 			"zero-length" problem that can happen when a
 			system crashes before the delayed allocation
@@ -358,7 +358,7 @@ written to the journal first, and then to its final location.
 In the event of a crash, the journal can be replayed, bringing both data and
 metadata into a consistent state.  This mode is the slowest except when data
 needs to be read from and written to disk at the same time where it
-outperforms all others modes.  Curently ext4 does not have delayed
+outperforms all others modes.  Currently ext4 does not have delayed
 allocation support if this data journalling mode is selected.
 
 References
diff --git a/Documentation/filesystems/fiemap.txt b/Documentation/filesystems/fiemap.txt
index 1e3defc..606233c 100644
--- a/Documentation/filesystems/fiemap.txt
+++ b/Documentation/filesystems/fiemap.txt
@@ -204,7 +204,7 @@ fiemap_check_flags() helper:
 
 int fiemap_check_flags(struct fiemap_extent_info *fieinfo, u32 fs_flags);
 
-The struct fieinfo should be passed in as recieved from ioctl_fiemap(). The
+The struct fieinfo should be passed in as received from ioctl_fiemap(). The
 set of fiemap flags which the fs understands should be passed via fs_flags. If
 fiemap_check_flags finds invalid user flags, it will place the bad values in
 fieinfo->fi_flags and return -EBADR. If the file system gets -EBADR, from
diff --git a/Documentation/filesystems/nfs-rdma.txt b/Documentation/filesystems/nfs-rdma.txt
index 85eaead..e386f7e 100644
--- a/Documentation/filesystems/nfs-rdma.txt
+++ b/Documentation/filesystems/nfs-rdma.txt
@@ -100,7 +100,7 @@ Installation
     $ sudo cp utils/mount/mount.nfs /sbin/mount.nfs
 
     In this location, mount.nfs will be invoked automatically for NFS mounts
-    by the system mount commmand.
+    by the system mount command.
 
     NOTE: mount.nfs and therefore nfs-utils-1.1.2 or greater is only needed
     on the NFS client machine. You do not need this specific version of
diff --git a/Documentation/filesystems/proc.txt b/Documentation/filesystems/proc.txt
index ce84cfc..cd8717a 100644
--- a/Documentation/filesystems/proc.txt
+++ b/Documentation/filesystems/proc.txt
@@ -366,7 +366,7 @@ just those considered 'most important'.  The new vectors are:
   RES, CAL, TLB -- rescheduling, call and TLB flush interrupts are
   sent from one CPU to another per the needs of the OS.  Typically,
   their statistics are used by kernel developers and interested users to
-  determine the occurance of interrupt of the given type.
+  determine the occurrence of interrupts of the given type.
 
 The above IRQ vectors are displayed only when relevent.  For example,
 the threshold vector does not exist on x86_64 platforms.  Others are
@@ -551,7 +551,7 @@ Committed_AS: The amount of memory presently allocated on the system.
               memory once that memory has been successfully allocated.
 VmallocTotal: total size of vmalloc memory area
  VmallocUsed: amount of vmalloc area which is used
-VmallocChunk: largest contigious block of vmalloc area which is free
+VmallocChunk: largest contiguous block of vmalloc area which is free
 
 ..............................................................................
 
diff --git a/Documentation/filesystems/sysfs-pci.txt b/Documentation/filesystems/sysfs-pci.txt
index 26e4b8b..85354b3 100644
--- a/Documentation/filesystems/sysfs-pci.txt
+++ b/Documentation/filesystems/sysfs-pci.txt
@@ -72,7 +72,7 @@ The 'rom' file is special in that it provides read-only access to the device's
 ROM file, if available.  It's disabled by default, however, so applications
 should write the string "1" to the file to enable it before attempting a read
 call, and disable it following the access by writing "0" to the file.  Note
-that the device must be enabled for a rom read to return data succesfully.
+that the device must be enabled for a rom read to return data successfully.
 In the event a driver is not bound to the device, it can be enabled using the
 'enable' file, documented above.
 
diff --git a/Documentation/filesystems/vfat.txt b/Documentation/filesystems/vfat.txt
index 3a5ddc9..5147be5 100644
--- a/Documentation/filesystems/vfat.txt
+++ b/Documentation/filesystems/vfat.txt
@@ -124,10 +124,10 @@ sys_immutable -- If set, ATTR_SYS attribute on FAT is handled as
 flush         -- If set, the filesystem will try to flush to disk more
 		 early than normal. Not set by default.
 
-rodir	      -- FAT has the ATTR_RO (read-only) attribute. But on Windows,
-		 the ATTR_RO of the directory will be just ignored actually,
-		 and is used by only applications as flag. E.g. it's setted
-		 for the customized folder.
+rodir	      -- FAT has the ATTR_RO (read-only) attribute. On Windows,
+		 the ATTR_RO of the directory will just be ignored,
+		 and is used only by applications as a flag (e.g. it's set
+		 for the customized folder).
 
 		 If you want to use ATTR_RO as read-only flag even for
 		 the directory, set this option.
diff --git a/Documentation/gpio.txt b/Documentation/gpio.txt
index 145c25a..e4b6985 100644
--- a/Documentation/gpio.txt
+++ b/Documentation/gpio.txt
@@ -458,7 +458,7 @@ debugfs interface, since it provides control over GPIO direction and
 value instead of just showing a gpio state summary.  Plus, it could be
 present on production systems without debugging support.
 
-Given approprate hardware documentation for the system, userspace could
+Given appropriate hardware documentation for the system, userspace could
 know for example that GPIO #23 controls the write protect line used to
 protect boot loader segments in flash memory.  System upgrade procedures
 may need to temporarily remove that protection, first importing a GPIO,
diff --git a/Documentation/kdump/kdump.txt b/Documentation/kdump/kdump.txt
index 3f4bc84..cab61d8 100644
--- a/Documentation/kdump/kdump.txt
+++ b/Documentation/kdump/kdump.txt
@@ -108,7 +108,7 @@ There are two possible methods of using Kdump.
 
 2) Or use the system kernel binary itself as dump-capture kernel and there is
    no need to build a separate dump-capture kernel. This is possible
-   only with the architecutres which support a relocatable kernel. As
+   only with the architectures which support a relocatable kernel. As
    of today, i386, x86_64, ppc64 and ia64 architectures support relocatable
    kernel.
 
@@ -222,7 +222,7 @@ Dump-capture kernel config options (Arch Dependent, ia64)
 ----------------------------------------------------------
 
 - No specific options are required to create a dump-capture kernel
-  for ia64, other than those specified in the arch idependent section
+  for ia64, other than those specified in the arch independent section
   above. This means that it is possible to use the system kernel
   as a dump-capture kernel if desired.
 
diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
index 600cdd7..86b8b9e 100644
--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -1059,7 +1059,7 @@ and is between 256 and 4096 characters. It is defined in the file
 
 	kgdboc=		[HW] kgdb over consoles.
 			Requires a tty driver that supports console polling.
-			(only serial suported for now)
+			(only serial supported for now)
 			Format: <serial_device>[,baud]
 
 	kmac=		[MIPS] korina ethernet MAC address.
@@ -1384,7 +1384,7 @@ and is between 256 and 4096 characters. It is defined in the file
 			('y', default) or cooked coordinates ('n')
 
 	mtrr_chunk_size=nn[KMG] [X86]
-			used for mtrr cleanup. It is largest continous chunk
+			used for mtrr cleanup. It is largest continuous chunk
 			that could hold holes aka. UC entries.
 
 	mtrr_gran_size=nn[KMG] [X86]
diff --git a/Documentation/kobject.txt b/Documentation/kobject.txt
index b2e3745..c79ab99 100644
--- a/Documentation/kobject.txt
+++ b/Documentation/kobject.txt
@@ -132,7 +132,7 @@ kobject_name():
     const char *kobject_name(const struct kobject * kobj);
 
 There is a helper function to both initialize and add the kobject to the
-kernel at the same time, called supprisingly enough kobject_init_and_add():
+kernel at the same time, called surprisingly enough kobject_init_and_add():
 
     int kobject_init_and_add(struct kobject *kobj, struct kobj_type *ktype,
                              struct kobject *parent, const char *fmt, ...);
diff --git a/Documentation/laptops/acer-wmi.txt b/Documentation/laptops/acer-wmi.txt
index 5ee2a02..0768fcc 100644
--- a/Documentation/laptops/acer-wmi.txt
+++ b/Documentation/laptops/acer-wmi.txt
@@ -40,7 +40,7 @@ NOTE: The Acer Aspire One is not supported hardware. It cannot work with
 acer-wmi until Acer fix their ACPI-WMI implementation on them, so has been
 blacklisted until that happens.
 
-Please see the website for the current list of known working hardare:
+Please see the website for the current list of known working hardware:
 
 http://code.google.com/p/aceracpi/wiki/SupportedHardware
 
diff --git a/Documentation/laptops/sony-laptop.txt b/Documentation/laptops/sony-laptop.txt
index 8b2bc15..23ce7d3 100644
--- a/Documentation/laptops/sony-laptop.txt
+++ b/Documentation/laptops/sony-laptop.txt
@@ -22,7 +22,7 @@ If your laptop model supports it, you will find sysfs files in the
 /sys/class/backlight/sony/
 directory. You will be able to query and set the current screen
 brightness:
-	brightness		get/set screen brightness (an iteger
+	brightness		get/set screen brightness (an integer
 				between 0 and 7)
 	actual_brightness	reading from this file will query the HW
 				to get real brightness value
diff --git a/Documentation/laptops/thinkpad-acpi.txt b/Documentation/laptops/thinkpad-acpi.txt
index e7e9a69..78e354b 100644
--- a/Documentation/laptops/thinkpad-acpi.txt
+++ b/Documentation/laptops/thinkpad-acpi.txt
@@ -506,7 +506,7 @@ generate input device EV_KEY events.
 In addition to the EV_KEY events, thinkpad-acpi may also issue EV_SW
 events for switches:
 
-SW_RFKILL_ALL	T60 and later hardare rfkill rocker switch
+SW_RFKILL_ALL	T60 and later hardware rfkill rocker switch
 SW_TABLET_MODE	Tablet ThinkPads HKEY events 0x5009 and 0x500A
 
 Non hot-key ACPI HKEY event map:
diff --git a/Documentation/local_ops.txt b/Documentation/local_ops.txt
index 23045b8..300da4b 100644
--- a/Documentation/local_ops.txt
+++ b/Documentation/local_ops.txt
@@ -34,7 +34,7 @@ out of order wrt other memory writes by the owner CPU.
 
 It can be done by slightly modifying the standard atomic operations : only
 their UP variant must be kept. It typically means removing LOCK prefix (on
-i386 and x86_64) and any SMP sychronization barrier. If the architecture does
+i386 and x86_64) and any SMP synchronization barrier. If the architecture does
 not have a different behavior between SMP and UP, including asm-generic/local.h
 in your architecture's local.h is sufficient.
 
diff --git a/Documentation/memory-hotplug.txt b/Documentation/memory-hotplug.txt
index 4c2ecf5..bbc8a6a 100644
--- a/Documentation/memory-hotplug.txt
+++ b/Documentation/memory-hotplug.txt
@@ -73,13 +73,13 @@ this phase is triggered automatically. ACPI can notify this event. If not,
 (see Section 4.).
 
 Logical Memory Hotplug phase is to change memory state into
-avaiable/unavailable for users. Amount of memory from user's view is
+available/unavailable for users. Amount of memory from user's view is
 changed by this phase. The kernel makes all memory in it as free pages
 when a memory range is available.
 
 In this document, this phase is described as online/offline.
 
-Logical Memory Hotplug phase is triggred by write of sysfs file by system
+Logical Memory Hotplug phase is triggered by write of sysfs file by system
 administrator. For the hot-add case, it must be executed after Physical Hotplug
 phase by hand.
 (However, if you writes udev's hotplug scripts for memory hotplug, these
@@ -334,7 +334,7 @@ MEMORY_CANCEL_ONLINE
   Generated if MEMORY_GOING_ONLINE fails.
 
 MEMORY_ONLINE
-  Generated when memory has succesfully brought online. The callback may
+  Generated when memory has successfully brought online. The callback may
   allocate pages from the new memory.
 
 MEMORY_GOING_OFFLINE
@@ -359,7 +359,7 @@ The third argument is passed by pointer of struct memory_notify.
 struct memory_notify {
        unsigned long start_pfn;
        unsigned long nr_pages;
-       int status_cahnge_nid;
+       int status_change_nid;
 }
 
 start_pfn is start_pfn of online/offline memory.
diff --git a/Documentation/mn10300/ABI.txt b/Documentation/mn10300/ABI.txt
index 1fef1f0..d3507ba 100644
--- a/Documentation/mn10300/ABI.txt
+++ b/Documentation/mn10300/ABI.txt
@@ -26,7 +26,7 @@ registers and the stack. If the first argument is a 64-bit value, it will be
 passed in D0:D1. If the first argument is not a 64-bit value, but the second
 is, the second will be passed entirely on the stack and D1 will be unused.
 
-Arguments smaller than 32-bits are not coelesced within a register or a stack
+Arguments smaller than 32-bits are not coalesced within a register or a stack
 word. For example, two byte-sized arguments will always be passed in separate
 registers or word-sized stack slots.
 
diff --git a/Documentation/mtd/nand_ecc.txt b/Documentation/mtd/nand_ecc.txt
index bdf93b7..274821b 100644
--- a/Documentation/mtd/nand_ecc.txt
+++ b/Documentation/mtd/nand_ecc.txt
@@ -50,7 +50,7 @@ byte 255:  bit7 bit6 bit5 bit4 bit3 bit2 bit1 bit0   rp1 rp3 rp5 ... rp15
            cp5  cp5  cp5  cp5  cp4  cp4  cp4  cp4
 
 This figure represents a sector of 256 bytes.
-cp is my abbreviaton for column parity, rp for row parity.
+cp is my abbreviation for column parity, rp for row parity.
 
 Let's start to explain column parity.
 cp0 is the parity that belongs to all bit0, bit2, bit4, bit6.
@@ -560,7 +560,7 @@ Measuring this code again showed big gain. When executing the original
 linux code 1 million times, this took about 1 second on my system.
 (using time to measure the performance). After this iteration I was back
 to 0.075 sec. Actually I had to decide to start measuring over 10
-million interations in order not to loose too much accuracy. This one
+million iterations in order not to lose too much accuracy. This one
 definitely seemed to be the jackpot!
 
 There is a little bit more room for improvement though. There are three
@@ -571,8 +571,8 @@ loop; This eliminates 3 statements per loop. Of course after the loop we
 need to correct by adding:
     rp4 ^= rp4_6;
     rp6 ^= rp4_6
-Furthermore there are 4 sequential assingments to rp8. This can be
-encoded slightly more efficient by saving tmppar before those 4 lines
+Furthermore there are 4 sequential assignments to rp8. This can be
+encoded slightly more efficiently by saving tmppar before those 4 lines
 and later do rp8 = rp8 ^ tmppar ^ notrp8;
 (where notrp8 is the value of rp8 before those 4 lines).
 Again a use of the commutative property of xor.
@@ -622,7 +622,7 @@ Not a big change, but every penny counts :-)
 Analysis 7
 ==========
 
-Acutally this made things worse. Not very much, but I don't want to move
+Actually this made things worse. Not very much, but I don't want to move
 into the wrong direction. Maybe something to investigate later. Could
 have to do with caching again.
 
@@ -642,7 +642,7 @@ Analysis 8
 This makes things worse. Let's stick with attempt 6 and continue from there.
 Although it seems that the code within the loop cannot be optimised
 further there is still room to optimize the generation of the ecc codes.
-We can simply calcualate the total parity. If this is 0 then rp4 = rp5
+We can simply calculate the total parity. If this is 0 then rp4 = rp5
 etc. If the parity is 1, then rp4 = !rp5;
 But if rp4 = rp5 we do not need rp5 etc. We can just write the even bits
 in the result byte and then do something like
diff --git a/Documentation/networking/bonding.txt b/Documentation/networking/bonding.txt
index 0876275..d5181ce 100644
--- a/Documentation/networking/bonding.txt
+++ b/Documentation/networking/bonding.txt
@@ -221,7 +221,7 @@ ad_select
 
 		- Any slave's 802.3ad association state changes
 
-		- The bond's adminstrative state changes to up
+		- The bond's administrative state changes to up
 
 	count or 2
 
@@ -369,7 +369,7 @@ fail_over_mac
 		When this policy is used in conjuction with the mii
 		monitor, devices which assert link up prior to being
 		able to actually transmit and receive are particularly
-		susecptible to loss of the gratuitous ARP, and an
+		susceptible to loss of the gratuitous ARP, and an
 		appropriate updelay setting may be required.
 
 	follow or 2
@@ -1794,7 +1794,7 @@ target to query.
 generally referred to as "trunk failover."  This is a feature of the
 switch that causes the link state of a particular switch port to be set
 down (or up) when the state of another switch port goes down (or up).
-It's purpose is to propogate link failures from logically "exterior" ports
+Its purpose is to propagate link failures from logically "exterior" ports
 to the logically "interior" ports that bonding is able to monitor via
 miimon.  Availability and configuration for trunk failover varies by
 switch, but this can be a viable alternative to the ARP monitor when using
diff --git a/Documentation/networking/can.txt b/Documentation/networking/can.txt
index 2035bc4..463d9e0 100644
--- a/Documentation/networking/can.txt
+++ b/Documentation/networking/can.txt
@@ -327,7 +327,7 @@ solution for a couple of reasons:
             return 1;
     }
 
-    /* paraniod check ... */
+    /* paranoid check ... */
     if (nbytes < sizeof(struct can_frame)) {
             fprintf(stderr, "read: incomplete CAN frame\n");
             return 1;
diff --git a/Documentation/networking/dm9000.txt b/Documentation/networking/dm9000.txt
index 65df3de..5552e2e 100644
--- a/Documentation/networking/dm9000.txt
+++ b/Documentation/networking/dm9000.txt
@@ -129,7 +129,7 @@ PHY Link state polling
 ----------------------
 
 The driver keeps track of the link state and informs the network core
-about link (carrier) availablilty. This is managed by several methods
+about link (carrier) availability. This is managed by several methods
 depending on the version of the chip and on which PHY is being used.
 
 For the internal PHY, the original (and currently default) method is
diff --git a/Documentation/networking/l2tp.txt b/Documentation/networking/l2tp.txt
index 2451f55..63214b2 100644
--- a/Documentation/networking/l2tp.txt
+++ b/Documentation/networking/l2tp.txt
@@ -158,7 +158,7 @@ Sample Userspace Code
         }
         return 0;
 
-Miscellanous
+Miscellaneous
 ============
 
 The PPPoL2TP driver was developed as part of the OpenL2TP project by
diff --git a/Documentation/networking/netdevices.txt b/Documentation/networking/netdevices.txt
index a2ab6a0..87b3d15 100644
--- a/Documentation/networking/netdevices.txt
+++ b/Documentation/networking/netdevices.txt
@@ -74,7 +74,7 @@ dev->hard_start_xmit:
 	for this and return NETDEV_TX_LOCKED when the spin lock fails.
 	The locking there should also properly protect against 
 	set_multicast_list. Note that the use of NETIF_F_LLTX is deprecated.
-	Dont use it for new drivers.
+	Don't use it for new drivers.
 
 	Context: Process with BHs disabled or BH (timer),
 	         will be called with interrupts disabled by netconsole.
diff --git a/Documentation/networking/phonet.txt b/Documentation/networking/phonet.txt
index 6a07e45..6e8ce09 100644
--- a/Documentation/networking/phonet.txt
+++ b/Documentation/networking/phonet.txt
@@ -36,7 +36,7 @@ Phonet packets have a common header as follows:
 On Linux, the link-layer header includes the pn_media byte (see below).
 The next 7 bytes are part of the network-layer header.
 
-The device ID is split: the 6 higher-order bits consitute the device
+The device ID is split: the 6 higher-order bits constitute the device
 address, while the 2 lower-order bits are used for multiplexing, as are
 the 8-bit object identifiers. As such, Phonet can be considered as a
 network layer with 6 bits of address space and 10 bits for transport
diff --git a/Documentation/networking/regulatory.txt b/Documentation/networking/regulatory.txt
index dcf3164..eaa1a25 100644
--- a/Documentation/networking/regulatory.txt
+++ b/Documentation/networking/regulatory.txt
@@ -89,7 +89,7 @@ added to this document when its support is enabled.
 Device drivers who provide their own built regulatory domain
 do not need a callback as the channels registered by them are
 the only ones that will be allowed and therefore *additional*
-cannels cannot be enabled.
+channels cannot be enabled.
 
 Example code - drivers hinting an alpha2:
 ------------------------------------------
diff --git a/Documentation/power/regulator/consumer.txt b/Documentation/power/regulator/consumer.txt
index 82b7a43..5f83fd2 100644
--- a/Documentation/power/regulator/consumer.txt
+++ b/Documentation/power/regulator/consumer.txt
@@ -178,5 +178,5 @@ Consumers can uregister interest by calling :-
 int regulator_unregister_notifier(struct regulator *regulator,
 				struct notifier_block *nb);
 
-Regulators use the kernel notifier framework to send event to thier interested
+Regulators use the kernel notifier framework to send event to their interested
 consumers.
diff --git a/Documentation/power/regulator/overview.txt b/Documentation/power/regulator/overview.txt
index bdcb332..0cded69 100644
--- a/Documentation/power/regulator/overview.txt
+++ b/Documentation/power/regulator/overview.txt
@@ -119,7 +119,7 @@ Some terms used in this document:-
                    battery power, USB power)
 
                    Regulator Domains: is the new current limit within the
-                   regulator operating parameters for input/ouput voltage.
+                   regulator operating parameters for input/output voltage.
 
                    If the regulator request passes all the constraint tests
                    then the new regulator value is applied.
diff --git a/Documentation/power/s2ram.txt b/Documentation/power/s2ram.txt
index 2ebdc60..514b94f 100644
--- a/Documentation/power/s2ram.txt
+++ b/Documentation/power/s2ram.txt
@@ -63,7 +63,7 @@ hardware during resume operations where a value can be set that will
 survive a reboot.
 
 Consequence is that after a resume (even if it is successful) your system
-clock will have a value corresponding to the magic mumber instead of the
+clock will have a value corresponding to the magic number instead of the
 correct date/time! It is therefore advisable to use a program like ntp-date
 or rdate to reset the correct date/time from an external time source when
 using this trace option.
diff --git a/Documentation/power/userland-swsusp.txt b/Documentation/power/userland-swsusp.txt
index 7b99636..b967cd9 100644
--- a/Documentation/power/userland-swsusp.txt
+++ b/Documentation/power/userland-swsusp.txt
@@ -109,7 +109,7 @@ unfreeze user space processes frozen by SNAPSHOT_UNFREEZE if they are
 still frozen when the device is being closed).
 
 Currently it is assumed that the userland utilities reading/writing the
-snapshot image from/to the kernel will use a swap parition, called the resume
+snapshot image from/to the kernel will use a swap partition, called the resume
 partition, or a swap file as storage space (if a swap file is used, the resume
 partition is the partition that holds this file).  However, this is not really
 required, as they can use, for example, a special (blank) suspend partition or
diff --git a/Documentation/powerpc/booting-without-of.txt b/Documentation/powerpc/booting-without-of.txt
index d16b7a1..8d999d8 100644
--- a/Documentation/powerpc/booting-without-of.txt
+++ b/Documentation/powerpc/booting-without-of.txt
@@ -1356,7 +1356,7 @@ platforms are moved over to use the flattened-device-tree model.
     - phy-map           : 1 cell, optional, bitmap of addresses to probe the PHY
 			  for, used if phy-address is absent. bit 0x00000001 is
 			  MDIO address 0.
-			  For Axon it can be absent, thouugh my current driver
+			  For Axon it can be absent, though my current driver
 			  doesn't handle phy-address yet so for now, keep
 			  0x00ffffff in it.
     - rx-fifo-size-gige : 1 cell, Rx fifo size in bytes for 1000 Mb/sec
@@ -1438,7 +1438,7 @@ platforms are moved over to use the flattened-device-tree model.
 
    The Xilinx EDK toolchain ships with a set of IP cores (devices) for use
    in Xilinx Spartan and Virtex FPGAs.  The devices cover the whole range
-   of standard device types (network, serial, etc.) and miscellanious
+   of standard device types (network, serial, etc.) and miscellaneous
    devices (gpio, LCD, spi, etc).  Also, since these devices are
    implemented within the fpga fabric every instance of the device can be
    synthesised with different options that change the behaviour.
diff --git a/Documentation/powerpc/dts-bindings/fsl/cpm_qe/cpm.txt b/Documentation/powerpc/dts-bindings/fsl/cpm_qe/cpm.txt
index 088fc47..160c752 100644
--- a/Documentation/powerpc/dts-bindings/fsl/cpm_qe/cpm.txt
+++ b/Documentation/powerpc/dts-bindings/fsl/cpm_qe/cpm.txt
@@ -19,7 +19,7 @@ Example:
 	reg = <119c0 30>;
      }
 
-* Properties common to mulitple CPM/QE devices
+* Properties common to multiple CPM/QE devices
 
 - fsl,cpm-command : This value is ORed with the opcode and command flag
                     to specify the device on which a CPM command operates.
diff --git a/Documentation/powerpc/dts-bindings/fsl/msi-pic.txt b/Documentation/powerpc/dts-bindings/fsl/msi-pic.txt
index b26b919..bcc30ba 100644
--- a/Documentation/powerpc/dts-bindings/fsl/msi-pic.txt
+++ b/Documentation/powerpc/dts-bindings/fsl/msi-pic.txt
@@ -1,6 +1,6 @@
 * Freescale MSI interrupt controller
 
-Reguired properities:
+Required properties:
 - compatible : compatible list, contains 2 entries,
   first is "fsl,CHIP-msi", where CHIP is the processor(mpc8610, mpc8572,
   etc.) and the second is "fsl,mpic-msi" or "fsl,ipic-msi" depending on
diff --git a/Documentation/powerpc/dts-bindings/fsl/pmc.txt b/Documentation/powerpc/dts-bindings/fsl/pmc.txt
index 02f6f43..07256b7 100644
--- a/Documentation/powerpc/dts-bindings/fsl/pmc.txt
+++ b/Documentation/powerpc/dts-bindings/fsl/pmc.txt
@@ -15,8 +15,8 @@ Properties:
   compatible; all statements below that apply to "fsl,mpc8548-pmc" also
   apply to "fsl,mpc8641d-pmc".
 
-  Compatibility does not include bit assigments in SCCR/PMCDR/DEVDISR; these
-  bit assigments are indicated via the sleep specifier in each device's
+  Compatibility does not include bit assignments in SCCR/PMCDR/DEVDISR; these
+  bit assignments are indicated via the sleep specifier in each device's
   sleep property.
 
 - reg: For devices compatible with "fsl,mpc8349-pmc", the first resource
diff --git a/Documentation/powerpc/qe_firmware.txt b/Documentation/powerpc/qe_firmware.txt
index 06da4d4..2031ddb 100644
--- a/Documentation/powerpc/qe_firmware.txt
+++ b/Documentation/powerpc/qe_firmware.txt
@@ -225,7 +225,7 @@ For example, to match the 8323, revision 1.0:
      soc.major = 1
      soc.minor = 0
 
-'padding' is neccessary for structure alignment.  This field ensures that the
+'padding' is necessary for structure alignment.  This field ensures that the
 'extended_modes' field is aligned on a 64-bit boundary.
 
 'extended_modes' is a bitfield that defines special functionality which has an
diff --git a/Documentation/rfkill.txt b/Documentation/rfkill.txt
index 4d3ee31..bb17c65 100644
--- a/Documentation/rfkill.txt
+++ b/Documentation/rfkill.txt
@@ -293,7 +293,7 @@ E.g:
   [RFKILL slider switch] -- [GPIO hardware] -- [WLAN card rf-kill input]
                            (platform driver)    (wireless card driver)
 
-The user is closer to the RFKILL slide switch plaform driver, so the driver
+The user is closer to the RFKILL slide switch platform driver, so the driver
 which must issue input events is the platform driver looking at the GPIO
 hardware, and NEVER the wireless card driver (which is just a slave).  It is
 very likely that there are other leaves than just the WLAN card rf-kill input
@@ -548,7 +548,7 @@ The following sysfs entries will be created:
 			transmitter is forced off, but one can override it
 			by a write to the state attribute;
 		1: RFKILL_STATE_UNBLOCKED
-			transmiter is NOT forced off, and may operate if
+			transmitter is NOT forced off, and may operate if
 			all other conditions for such operation are met
 			(such as interface is up and configured, etc);
 		2: RFKILL_STATE_HARD_BLOCKED
diff --git a/Documentation/s390/Debugging390.txt b/Documentation/s390/Debugging390.txt
index 10711d9..1eb576a 100644
--- a/Documentation/s390/Debugging390.txt
+++ b/Documentation/s390/Debugging390.txt
@@ -1984,7 +1984,7 @@ break *$pc
 
 break *0x400618
 
-heres a really useful one for large programs
+Here's a really useful one for large programs
 rbr
 Set a breakpoint for all functions matching REGEXP
 e.g.
@@ -2211,7 +2211,7 @@ Breakpoint 2 at 0x4d87a4: file top.c, line 2609.
 #5  0x51692c in readline_internal () at readline.c:521
 #6  0x5164fe in readline (prompt=0x7ffff810 "\177ÿøx\177ÿ÷Ø\177ÿøxÀ")
     at readline.c:349
-#7  0x4d7a8a in command_line_input (prrompt=0x564420 "(gdb) ", repeat=1,
+#7  0x4d7a8a in command_line_input (prompt=0x564420 "(gdb) ", repeat=1,
     annotation_suffix=0x4d6b44 "prompt") at top.c:2091
 #8  0x4d6cf0 in command_loop () at top.c:1345
 #9  0x4e25bc in main (argc=1, argv=0x7ffffdf4) at main.c:635
diff --git a/Documentation/scheduler/sched-nice-design.txt b/Documentation/scheduler/sched-nice-design.txt
index e2bae5a..3ac1e46 100644
--- a/Documentation/scheduler/sched-nice-design.txt
+++ b/Documentation/scheduler/sched-nice-design.txt
@@ -55,7 +55,7 @@ To sum it up: we always wanted to make nice levels more consistent, but
 within the constraints of HZ and jiffies and their nasty design level
 coupling to timeslices and granularity it was not really viable.
 
-The second (less frequent but still periodically occuring) complaint
+The second (less frequent but still periodically occurring) complaint
 about Linux's nice level support was its assymetry around the origo
 (which you can see demonstrated in the picture above), or more
 accurately: the fact that nice level behavior depended on the _absolute_
diff --git a/Documentation/scsi/aic79xx.txt b/Documentation/scsi/aic79xx.txt
index 683ccae..c014ecc 100644
--- a/Documentation/scsi/aic79xx.txt
+++ b/Documentation/scsi/aic79xx.txt
@@ -194,7 +194,7 @@ The following information is available in this file:
           - Packetized SCSI Protocol at 160MB/s and 320MB/s
           - Quick Arbitration Selection (QAS)
           - Retained Training Information (Rev B. ASIC only)
-        - Interrupt Coalessing
+        - Interrupt Coalescing
         - Initiator Mode (target mode not currently 
           supported)
         - Support for the PCI-X standard up to 133MHz
diff --git a/Documentation/scsi/ncr53c8xx.txt b/Documentation/scsi/ncr53c8xx.txt
index 230e308..08e2b4d 100644
--- a/Documentation/scsi/ncr53c8xx.txt
+++ b/Documentation/scsi/ncr53c8xx.txt
@@ -206,7 +206,7 @@ of MOVE MEMORY instructions.
 The 896 and the 895A allows handling of the phase mismatch context from 
 SCRIPTS (avoids the phase mismatch interrupt that stops the SCSI processor 
 until the C code has saved the context of the transfer).
-Implementing this without using LOAD/STORE instructions would be painfull 
+Implementing this without using LOAD/STORE instructions would be painful 
 and I didn't even want to try it.
 
 The 896 chip supports 64 bit PCI transactions and addressing, while the 
@@ -240,7 +240,7 @@ characteristics. This feature may also reduce average command latency.
 In order to really gain advantage of this feature, devices must have 
 a reasonable cache size (No miracle is to be expected for a low-end 
 hard disk with 128 KB or less).
-Some kown SCSI devices do not properly support tagged command queuing.
+Some known SCSI devices do not properly support tagged command queuing.
 Generally, firmware revisions that fix this kind of problems are available 
 at respective vendor web/ftp sites.
 All I can say is that the hard disks I use on my machines behave well with 
diff --git a/Documentation/scsi/sym53c8xx_2.txt b/Documentation/scsi/sym53c8xx_2.txt
index 49ea5c5..eb9a7b9 100644
--- a/Documentation/scsi/sym53c8xx_2.txt
+++ b/Documentation/scsi/sym53c8xx_2.txt
@@ -206,7 +206,7 @@ characteristics. This feature may also reduce average command latency.
 In order to really gain advantage of this feature, devices must have 
 a reasonable cache size (No miracle is to be expected for a low-end 
 hard disk with 128 KB or less).
-Some kown old SCSI devices do not properly support tagged command queuing.
+Some known old SCSI devices do not properly support tagged command queuing.
 Generally, firmware revisions that fix this kind of problems are available 
 at respective vendor web/ftp sites.
 All I can say is that I never have had problem with tagged queuing using 
diff --git a/Documentation/sound/alsa/ALSA-Configuration.txt b/Documentation/sound/alsa/ALSA-Configuration.txt
index 012858d..ecb969b 100644
--- a/Documentation/sound/alsa/ALSA-Configuration.txt
+++ b/Documentation/sound/alsa/ALSA-Configuration.txt
@@ -754,7 +754,7 @@ Prior to version 0.9.0rc4 options had a 'snd_' prefix. This was removed.
     single_cmd  - Use single immediate commands to communicate with
 		codecs (for debugging only)
     enable_msi	- Enable Message Signaled Interrupt (MSI) (default = off)
-    power_save	- Automatic power-saving timtout (in second, 0 =
+    power_save	- Automatic power-saving timeout (in second, 0 =
 		disable)
     power_save_controller - Reset HD-audio controller in power-saving mode
 		(default = on)
diff --git a/Documentation/sound/alsa/HD-Audio.txt b/Documentation/sound/alsa/HD-Audio.txt
index 88b7433..71ac995 100644
--- a/Documentation/sound/alsa/HD-Audio.txt
+++ b/Documentation/sound/alsa/HD-Audio.txt
@@ -16,7 +16,7 @@ methods for the	HD-audio hardware.
 The HD-audio component consists of two parts: the controller chip and 
 the codec chips on the HD-audio bus.  Linux provides a single driver
 for all controllers, snd-hda-intel.  Although the driver name contains
-a word of a well-known harware vendor, it's not specific to it but for
+a word of a well-known hardware vendor, it's not specific to it but for
 all controller chips by other companies.  Since the HD-audio
 controllers are supposed to be compatible, the single snd-hda-driver
 should work in most cases.  But, not surprisingly, there are known
diff --git a/Documentation/sound/alsa/hda_codec.txt b/Documentation/sound/alsa/hda_codec.txt
index 34e87ec..de8efbc 100644
--- a/Documentation/sound/alsa/hda_codec.txt
+++ b/Documentation/sound/alsa/hda_codec.txt
@@ -114,7 +114,7 @@ For writing a sequence of verbs, use snd_hda_sequence_write().
 
 There are variants of cached read/write, snd_hda_codec_write_cache(),
 snd_hda_sequence_write_cache().  These are used for recording the
-register states for the power-mangement resume.  When no PM is needed,
+register states for the power-management resume.  When no PM is needed,
 these are equivalent with non-cached version.
 
 To retrieve the number of sub nodes connected to the given node, use
diff --git a/Documentation/sysctl/vm.txt b/Documentation/sysctl/vm.txt
index 97c4b32..e962cb0 100644
--- a/Documentation/sysctl/vm.txt
+++ b/Documentation/sysctl/vm.txt
@@ -356,7 +356,7 @@ nr_pdflush_threads
 The current number of pdflush threads.  This value is read-only.
 The value changes according to the number of dirty pages in the system.
 
-When neccessary, additional pdflush threads are created, one per second, up to
+When necessary, additional pdflush threads are created, one per second, up to
 nr_pdflush_threads_max.
 
 ==============================================================
@@ -589,7 +589,7 @@ swappiness
 
 This control is used to define how aggressive the kernel will swap
 memory pages.  Higher values will increase agressiveness, lower values
-descrease the amount of swap.
+decrease the amount of swap.
 
 The default value is 60.
 
diff --git a/Documentation/timers/hpet.txt b/Documentation/timers/hpet.txt
index e7c09ab..04763a3 100644
--- a/Documentation/timers/hpet.txt
+++ b/Documentation/timers/hpet.txt
@@ -7,7 +7,7 @@ by Intel and Microsoft which can be found at
 
 Each HPET has one fixed-rate counter (at 10+ MHz, hence "High Precision")
 and up to 32 comparators.  Normally three or more comparators are provided,
-each of which can generate oneshot interupts and at least one of which has
+each of which can generate oneshot interrupts and at least one of which has
 additional hardware to support periodic interrupts.  The comparators are
 also called "timers", which can be misleading since usually timers are
 independent of each other ... these share a counter, complicating resets.
diff --git a/Documentation/timers/timer_stats.txt b/Documentation/timers/timer_stats.txt
index 20d368c..9bd00fc 100644
--- a/Documentation/timers/timer_stats.txt
+++ b/Documentation/timers/timer_stats.txt
@@ -62,7 +62,7 @@ Timerstats sample period: 3.888770 s
 
 The first column is the number of events, the second column the pid, the third
 column is the name of the process. The forth column shows the function which
-initialized the timer and in parantheses the callback function which was
+initialized the timer and in parenthesis the callback function which was
 executed on expiry.
 
     Thomas, Ingo
diff --git a/Documentation/trace/ftrace.txt b/Documentation/trace/ftrace.txt
index fd9a3e6..262562f 100644
--- a/Documentation/trace/ftrace.txt
+++ b/Documentation/trace/ftrace.txt
@@ -1157,7 +1157,7 @@ int main(int argc, char *argv[]) {
 Note: Here we hard coded the path name. The debugfs mount is not
 guaranteed to be at /debug (and is more commonly at
 /sys/kernel/debug). For simple one time traces, the above is
-sufficent. For anything else, a search through /proc/mounts may
+sufficient. For anything else, a search through /proc/mounts may
 be needed to find where the debugfs file-system is mounted.
 
 
diff --git a/Documentation/usb/WUSB-Design-overview.txt b/Documentation/usb/WUSB-Design-overview.txt
index 4c3d62c..c480e9c 100644
--- a/Documentation/usb/WUSB-Design-overview.txt
+++ b/Documentation/usb/WUSB-Design-overview.txt
@@ -84,7 +84,7 @@ The different logical parts of this driver are:
 
       *UWB*: the Ultra-Wide-Band stack -- manages the radio and
       associated spectrum to allow for devices sharing it. Allows to
-      control bandwidth assingment, beaconing, scanning, etc
+      control bandwidth assignment, beaconing, scanning, etc
 
     *
 
@@ -184,7 +184,7 @@ and sends the replies and notifications back to the API
 [/uwb_rc_neh_grok()/]. Notifications are handled to the UWB daemon, that
 is chartered, among other things, to keep the tab of how the UWB radio
 neighborhood looks, creating and destroying devices as they show up or
-dissapear.
+disappear.
 
 Command execution is very simple: a command block is sent and a event
 block or reply is expected back. For sending/receiving command/events, a
@@ -333,7 +333,7 @@ read descriptors and move our data.
 
 *Device life cycle and keep alives*
 
-Everytime there is a succesful transfer to/from a device, we update a
+Every time there is a successful transfer to/from a device, we update a
 per-device activity timestamp. If not, every now and then we check and
 if the activity timestamp gets old, we ping the device by sending it a
 Keep Alive IE; it responds with a /DN_Alive/ pong during the DNTS (this
@@ -411,7 +411,7 @@ context (wa_xfer) and submit it. When the xfer is done, our callback is
 called and we assign the status bits and release the xfer resources.
 
 In dequeue() we are basically cancelling/aborting the transfer. We issue
-a xfer abort request to the HC, cancell all the URBs we had submitted
+a xfer abort request to the HC, cancel all the URBs we had submitted
 and not yet done and when all that is done, the xfer callback will be
 called--this will call the URB callback.
 
diff --git a/Documentation/usb/anchors.txt b/Documentation/usb/anchors.txt
index 6f24f56..fe6a99a 100644
--- a/Documentation/usb/anchors.txt
+++ b/Documentation/usb/anchors.txt
@@ -27,7 +27,7 @@ Association and disassociation of URBs with anchors
 
 An association of URBs to an anchor is made by an explicit
 call to usb_anchor_urb(). The association is maintained until
-an URB is finished by (successfull) completion. Thus disassociation
+an URB is finished by (successful) completion. Thus disassociation
 is automatic. A function is provided to forcibly finish (kill)
 all URBs associated with an anchor.
 Furthermore, disassociation can be made with usb_unanchor_urb()
@@ -76,4 +76,4 @@ usb_get_from_anchor()
 Returns the oldest anchored URB of an anchor. The URB is unanchored
 and returned with a reference. As you may mix URBs to several
 destinations in one anchor you have no guarantee the chronologically
-first submitted URB is returned.
\ No newline at end of file
+first submitted URB is returned.
diff --git a/Documentation/video4linux/cx18.txt b/Documentation/video4linux/cx18.txt
index 914cb7e..4652c0f 100644
--- a/Documentation/video4linux/cx18.txt
+++ b/Documentation/video4linux/cx18.txt
@@ -11,7 +11,7 @@ encoder chip:
 2) Some people have problems getting the i2c bus to work.
    The symptom is that the eeprom cannot be read and the card is
    unusable. This is probably fixed, but if you have problems
-   then post to the video4linux or ivtv-users mailinglist.
+   then post to the video4linux or ivtv-users mailing list.
 
 3) VBI (raw or sliced) has not yet been implemented.
 
diff --git a/drivers/message/fusion/lsi/mpi_history.txt b/drivers/message/fusion/lsi/mpi_history.txt
index 693e4b5..fa9249b 100644
--- a/drivers/message/fusion/lsi/mpi_history.txt
+++ b/drivers/message/fusion/lsi/mpi_history.txt
@@ -130,7 +130,7 @@ mpi_ioc.h
  *  08-08-01  01.02.01  Original release for v1.2 work.
  *                      New format for FWVersion and ProductId in
  *                      MSG_IOC_FACTS_REPLY and MPI_FW_HEADER.
- *  08-31-01  01.02.02  Addded event MPI_EVENT_SCSI_DEVICE_STATUS_CHANGE and
+ *  08-31-01  01.02.02  Added event MPI_EVENT_SCSI_DEVICE_STATUS_CHANGE and
  *                      related structure and defines.
  *                      Added event MPI_EVENT_ON_BUS_TIMER_EXPIRED.
  *                      Added MPI_IOCINIT_FLAGS_DISCARD_FW_IMAGE.
@@ -190,7 +190,7 @@ mpi_ioc.h
  *  10-11-06  01.05.12  Added MPI_IOCFACTS_EXCEPT_METADATA_UNSUPPORTED.
  *                      Added MaxInitiators field to PortFacts reply.
  *                      Added SAS Device Status Change ReasonCode for
- *                      asynchronous notificaiton.
+ *                      asynchronous notification.
  *                      Added MPI_EVENT_SAS_EXPANDER_STATUS_CHANGE and event
  *                      data structure.
  *                      Added new ImageType values for FWDownload and FWUpload
@@ -623,7 +623,7 @@ mpi_fc.h
  *  11-02-00  01.01.01  Original release for post 1.0 work
  *  12-04-00  01.01.02  Added messages for Common Transport Send and
  *                      Primitive Send.
- *  01-09-01  01.01.03  Modifed some of the new flags to have an MPI prefix
+ *  01-09-01  01.01.03  Modified some of the new flags to have an MPI prefix
  *                      and modified the FcPrimitiveSend flags.
  *  01-25-01  01.01.04  Move InitiatorIndex in LinkServiceRsp reply to a larger
  *                      field.
diff --git a/drivers/staging/go7007/go7007.txt b/drivers/staging/go7007/go7007.txt
index 9f6772b..1c2907c 100644
--- a/drivers/staging/go7007/go7007.txt
+++ b/drivers/staging/go7007/go7007.txt
@@ -2,7 +2,7 @@ This is a driver for the WIS GO7007SB multi-format video encoder.
 
 Pete Eberlein <pete@sensoray.com>
 
-The driver was orignally released under the GPL and is currently hosted at:
+The driver was originally released under the GPL and is currently hosted at:
 http://nikosapi.org/wiki/index.php/WIS_Go7007_Linux_driver
 The go7007 firmware can be acquired from the package on the site above.
 
@@ -24,7 +24,7 @@ These should be used instead of the non-standard GO7007 ioctls described
 below.
 
 
-The README files from the orignal package appear below:
+The README files from the original package appears below:
 
 ---------------------------------------------------------------------------
                      WIS GO7007SB Public Linux Driver
diff --git a/drivers/staging/panel/lcd-panel-cgram.txt b/drivers/staging/panel/lcd-panel-cgram.txt
index f9ceef4..7f82c90 100644
--- a/drivers/staging/panel/lcd-panel-cgram.txt
+++ b/drivers/staging/panel/lcd-panel-cgram.txt
@@ -3,7 +3,7 @@ characters 0 to 7. The escape code to define a new character is
 '\e[LG' followed by one digit from 0 to 7, representing the character
 number, and up to 8 couples of hex digits terminated by a semi-colon
 (';'). Each couple of digits represents a line, with 1-bits for each
-illuminated pixel with LSB on the right. Lines are numberred from the
+illuminated pixel with LSB on the right. Lines are numbered from the
 top of the character to the bottom. On a 5x7 matrix, only the 5 lower
 bits of the 7 first bytes are used for each character. If the string
 is incomplete, only complete lines will be redefined. Here are some
-- 
1.6.0.4

