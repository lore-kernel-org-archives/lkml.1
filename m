Return-Path: <linux-kernel-owner+w=401wt.eu-S1753455AbZJPVOv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753455AbZJPVOv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Oct 2009 17:14:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751551AbZJPVOv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Oct 2009 17:14:51 -0400
Received: from g4t0014.houston.hp.com ([15.201.24.17]:28701 "EHLO
	g4t0014.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751476AbZJPVOu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Oct 2009 17:14:50 -0400
Subject: [PATCH v3 0/6] ACPI: dock: code hygiene
To: lenb@kernel.org
From: Alex Chiang <achiang@hp.com>
Cc: shaohua.li@intel.com, linux-kernel@vger.kernel.org,
       linux-acpi@vger.kernel.org
Date: Fri, 16 Oct 2009 15:14:54 -0600
Message-ID: <20091016211323.12126.58457.stgit@bob.kio>
User-Agent: StGit/0.14.3.386.gb02d
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is v3 of a modest attempt to clean up the dock driver.

As before, compile tested only, since I don't have any machines
that provide _DCK.

Thanks.
/ac

v2 -> v3:
	- now using an attribute_group, as suggested by Dmitry Torokhov

v1 -> v2:
	- changed how we add platform device data, based on Shaohua Li's
	  review
---

Alex Chiang (6):
      ACPI: dock: convert sysfs attributes to an attribute_group
      ACPI: dock: combine add|alloc_dock_dependent_device
      ACPI: dock: remove global 'dock_device_name'
      ACPI: dock: dock_add - hoist up platform_device_register_simple()
      ACPI: dock: add struct dock_station * directly to platform device data
      ACPI: dock: minor whitespace and style cleanups


 drivers/acpi/dock.c |  265 ++++++++++++++++++---------------------------------
 1 files changed, 92 insertions(+), 173 deletions(-)

