Return-Path: <linux-kernel-owner+w=401wt.eu-S1762114AbZJNWqu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762114AbZJNWqu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Oct 2009 18:46:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757047AbZJNWqt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Oct 2009 18:46:49 -0400
Received: from g6t0186.atlanta.hp.com ([15.193.32.63]:8657 "EHLO
	g6t0186.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755145AbZJNWqs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Oct 2009 18:46:48 -0400
Subject: [PATCH v2 0/6] ACPI: dock: code hygiene
To: lenb@kernel.org
From: Alex Chiang <achiang@hp.com>
Cc: shaohua.li@intel.com, linux-kernel@vger.kernel.org,
       linux-acpi@vger.kernel.org
Date: Wed, 14 Oct 2009 16:46:11 -0600
Message-ID: <20091014224415.18044.88208.stgit@bob.kio>
User-Agent: StGit/0.14.3.386.gb02d
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is v2 of a modest attempt to clean up the dock driver.

As before, compile tested only, since I don't have any machines
that provide _DCK.

Thanks.
/ac

v1 -> v2:
	- changed how we add platform device data, based on Shaohua Li's
	  review

---

Alex Chiang (6):
      ACPI: dock: clean up error handling paths in dock_add()
      ACPI: dock: combine add|alloc_dock_dependent_device
      ACPI: dock: remove global 'dock_device_name'
      ACPI: dock: dock_add - hoist up platform_device_register_simple()
      ACPI: dock: add struct dock_station * directly to platform device data
      ACPI: dock: minor whitespace and style cleanups


 drivers/acpi/dock.c |  272 ++++++++++++++++++++-------------------------------
 1 files changed, 104 insertions(+), 168 deletions(-)

