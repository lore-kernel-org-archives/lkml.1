Return-Path: <linux-kernel-owner+w=401wt.eu-S1757426AbZLDV61@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757426AbZLDV61 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Dec 2009 16:58:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757310AbZLDV6Z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Dec 2009 16:58:25 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:43618 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757264AbZLDV6Z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Dec 2009 16:58:25 -0500
Message-ID: <4B198670.2000406@gmail.com>
Date: Fri, 04 Dec 2009 23:00:16 +0100
From: Emese Revfy <re.emese@gmail.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20090812)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
       re.emese@gmail.com
Subject: [PATCH 00/31] constify various _ops structures for 2.6.32 v1
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
X-ELTE-SpamScore: 0.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=0.0 required=5.9 tests=none autolearn=no SpamAssassin version=3.2.5
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello everyone!

The following patch series attempts to constify several structures
that hold function pointers. This is only the initial batch, there
are about over 150 candidate structures, some of which can be
constified as well, I plan to submit them in the future.

The list of constified structures in this series:
acpi_dock_ops
address_space_operations
backlight_ops
block_device_operations
dma_map_ops
e1000_mac_operations
e1000_nvm_operations
e1000_phy_operations
extent_io_ops
file_lock_operations
file_operations
hv_ops
intel_dvo_dev_ops
item_operations
iwl_ops
kgdb_arch
kgdb_io
kset_uevent_ops
lock_manager_operations
microcode_ops
mtrr_ops
neigh_ops
nlmsvc_binding
pci_raw_ops
platform_hibernation_ops
platform_suspend_ops
snd_ac97_build_ops
super_operations
sysfs_ops
usb_mon_operations
wd_ops

There are certain exceptions where a given instance of the structure
cannot be const, they are marked with a comment in the patch.

The patches compile fine with an allyesconfig kernel on i386 and x86_64.

Please let me know if any of these structures should not be constified
and any other issues you see with them.

Thanks,
   Emese

