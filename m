Return-Path: <linux-kernel-owner+w=401wt.eu-S1757788AbZJSVeI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757788AbZJSVeI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Oct 2009 17:34:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757714AbZJSVeI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Oct 2009 17:34:08 -0400
Received: from g1t0026.austin.hp.com ([15.216.28.33]:1616 "EHLO
	g1t0026.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757704AbZJSVeH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Oct 2009 17:34:07 -0400
Subject: [PATCH 0/5] mm: modest useability enhancements for node sysfs attrs
To: akpm@linux-foundation.org
From: Alex Chiang <achiang@hp.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org
Date: Mon, 19 Oct 2009 15:34:10 -0600
Message-ID: <20091019212740.32729.7171.stgit@bob.kio>
User-Agent: StGit/0.14.3.386.gb02d
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I've been poking at memory/node hotplug lately, and found myself wondering
what node a memory section or CPU might belong to.

Yes, the information is there in sysfs, but to me, having a symlink pointing
back to the node is so much more convenient.

Thanks,
/ac

---

Alex Chiang (5):
      mm: add numa node symlink for memory section in sysfs
      mm: refactor register_cpu_under_node()
      mm: refactor unregister_cpu_under_node()
      mm: add numa node symlink for cpu devices in sysfs
      Documentation: ABI: document /sys/devices/system/cpu/


 Documentation/ABI/testing/sysfs-devices-cpu    |   42 ++++++++++++++++++
 Documentation/ABI/testing/sysfs-devices-memory |   14 ++++++
 Documentation/memory-hotplug.txt               |   11 +++--
 drivers/base/node.c                            |   56 +++++++++++++++++-------
 4 files changed, 102 insertions(+), 21 deletions(-)
 create mode 100644 Documentation/ABI/testing/sysfs-devices-cpu

