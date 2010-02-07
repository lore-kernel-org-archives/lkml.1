Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756947Ab0BGShb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Feb 2010 13:37:31 -0500
Received: from casper.infradead.org ([85.118.1.10]:50673 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755973Ab0BGShS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Feb 2010 13:37:18 -0500
Date: Sun, 7 Feb 2010 10:38:28 -0800
From: Arjan van de Ven <arjan@infradead.org>
To: linux-kernel@vger.kernel.org
Cc: torvalds@linux-foundation.org, davej@redhat.com, cebbert@redhat.com,
       tglx@linutronix.de, mingo@elte.hu, dwmw2@infradead.org,
       airlied@redhat.com, perex@perex.cz, eparis@redhat.com
Subject: kerneloops.org oops/warning report for the week ending February 7,
 2010
Message-ID: <20100207103828.7e7b1e29@infradead.org>
Organization: Intel
X-Mailer: Claws Mail 3.7.3 (GTK+ 2.16.6; i586-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This week, a total of 771557 oopses and warnings have been reported.
That's a whole lot more than normal..... like by a lot.
The vast majority is in the ext4/quota interaction, specifically in the latest Fedora
kernel rpm (bad backport?)
RCU shows some fun as well, but pretty much exclusively on Dell machines.



Per file statistics
439978	fs/quota/dquot.c
157834	include/linux/rcutiny.h
68451	external/nvidia/binary (P)
33617	sound/pci/hda/hda_intel.c
18022	drivers/gpu/drm/radeon/radeon_object.c
4931	drivers/media/video/usbcam/usbcam_dev.c
3551	drivers/pci/dmar.c
2584	drivers/pci/intel-iommu.c
2488	include/linux/hardirq.h
2201	sound/pci/hda/hda_codec.c
2019	fs/eventpoll.c
1923	fs/notify/inotify/inotify_fsnotify.c


Rank 1: dquot_claim_space (warning)
	Reported 440404 times (482753 total reports)
	Interaction between EXT4 and the quota code.
	It seems to have gotten really worse in the latest Fedora 12 kernel; botched backport?
	This warning was last seen in version 2.6.33-rc4, and first seen in 2.6.30.
	More info: http://www.kerneloops.org/searchweek.php?search=dquot_claim_space

Rank 2: rcu_exit_nohz (warning)
	Almost exclusively seen on Dell machines; almost looks like some buggy SMM code causing
	something evil.
	Reported 86293 times (109140 total reports)
	This warning was last seen in version 2.6.33-rc6-git0, and first seen in 2.6.28.
	More info: http://www.kerneloops.org/searchweek.php?search=rcu_exit_nohz

Rank 3: rcu_enter_nohz (warning)
	counterpart of the #2 item
	Reported 71550 times (91147 total reports)
	This warning was last seen in version 2.6.33-rc6-git0, and first seen in 2.6.24-rc7.
	More info: http://www.kerneloops.org/searchweek.php?search=rcu_enter_nohz

Rank 4: nv_post_event (warning)
	Reported 68189 times (69146 total reports)
	Running the nvidia binary driver on an -rt kernel is just not a good idea.
	Really. We mean it.
	warning only shows up in tainted kernels
	This warning was last seen in version 2.6.31.12, and first seen in 2.6.29.5.
	More info: http://www.kerneloops.org/searchweek.php?search=nv_post_event

Rank 5: azx_send_cmd (warning)
	Reported 33409 times (49076 total reports)
	This warning was last seen in version 2.6.31.12, and first seen in 2.6.31-rc7-git2.
	More info: http://www.kerneloops.org/searchweek.php?search=azx_send_cmd

Rank 6: radeon_object_create (oops)
	Reported 18055 times (27801 total reports)
	List corruption, assumed fixed in 2.6.32
	This oops was last seen in version 2.6.32.7, and first seen in 2.6.31-rc1-git7.
	More info: http://www.kerneloops.org/searchweek.php?search=radeon_object_create

Rank 7: native_apic_write_dummy (warning)
	Reported 10290 times (17346 total reports)
	This warning was last seen in version 2.6.32.1, and first seen in 2.6.30.
	More info: http://www.kerneloops.org/searchweek.php?search=native_apic_write_dummy

Rank 8: usbcam_videobuf_queue (warning)
	Reported 4931 times (6168 total reports)
	[fedora] Out of tree driver calling mutex code from interrupt context
	This warning was last seen in version 2.6.31.12, and first seen in 2.6.27.30.
	More info: http://www.kerneloops.org/searchweek.php?search=usbcam_videobuf_queue

Rank 9: check_zero_address (warning)
	Reported 3552 times (5554 total reports)
	[bios] The BIOS advertizes a zero address for the DMAR table
	This warning was last seen in version 2.6.33-rc6, and first seen in 2.6.31.5.
	More info: http://www.kerneloops.org/searchweek.php?search=check_zero_address

Rank 10: snd_array_new (warning)
	Reported 2201 times (2971 total reports)
	This warning was last seen in version 2.6.31.12, and first seen in 2.6.27.5.
	More info: http://www.kerneloops.org/searchweek.php?search=snd_array_new

Rank 11: iommu_prepare_identity_map (warning)
	Reported 2147 times (3197 total reports)
	This warning was last seen in version 2.6.33-rc6-git1, and first seen in 2.6.31.5.
	More info: http://www.kerneloops.org/searchweek.php?search=iommu_prepare_identity_map

Rank 12: ep_call_nested (warning)
	-rt kernels only; locking issue between eventpoll and a networking driver??
	Reported 2019 times
	This warning was last seen in version 2.6.31.12, and first seen in 2.6.31.12.
	More info: http://www.kerneloops.org/searchweek.php?search=ep_call_nested

-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
