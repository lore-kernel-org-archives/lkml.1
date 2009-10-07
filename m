Return-Path: <linux-kernel-owner+w=401wt.eu-S1754686AbZJGWIG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754686AbZJGWIG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Oct 2009 18:08:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753534AbZJGWIF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Oct 2009 18:08:05 -0400
Received: from g6t0185.atlanta.hp.com ([15.193.32.62]:2138 "EHLO
	g6t0185.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753425AbZJGWIF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Oct 2009 18:08:05 -0400
Subject: [PATCH 0/6] ACPI: dock: code hygiene
To: lenb@kernel.org
From: Alex Chiang <achiang@hp.com>
Cc: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Wed, 07 Oct 2009 16:07:27 -0600
Message-ID: <20091007220509.15597.65501.stgit@bob.kio>
User-Agent: StGit/0.14.3.386.gb02d
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

While poking around in the dock driver debugging the NULL ptr that
Rafael fixed, I found the driver a little hard to read.

Here is a modest attempt to clean it up a little, and is intended as
2.6.33 material.

Compile-tested only. I have access to an HP nc6220 and nc6230, but neither
of them seem to provide the _DCK method, which is needed for the dock
driver.

Thanks.

/ac

---

Alex Chiang (6):
      ACPI: dock: clean up error handling paths in dock_add()
      ACPI: dock: rename local variable 'dock_station' in dock_add()
      ACPI: dock: clean up one more error path in dock_add()
      ACPI: dock: add struct dock_station * directly to platform device data
      ACPI: dock: combine add|alloc_dock_dependent_device
      ACPI: dock: minor whitespace and style cleanups


 drivers/acpi/dock.c |  259 ++++++++++++++++++++-------------------------------
 1 files changed, 104 insertions(+), 155 deletions(-)

