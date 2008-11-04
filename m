Return-Path: <linux-kernel-owner+w=401wt.eu-S1755965AbYKDVxE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755965AbYKDVxE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2008 16:53:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753712AbYKDVww
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Nov 2008 16:52:52 -0500
Received: from g1t0029.austin.hp.com ([15.216.28.36]:11117 "EHLO
	g1t0029.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752360AbYKDVwv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2008 16:52:51 -0500
From: Myron Stowe <myron.stowe@hp.com>
Subject: [PATCH v3 0/3] ACPI: Fix for supporting > 256 processor declaration
	limit
To: lenb@kernel.org
Cc: aystarik@gmail.com, yakui.zhao@intel.com, myron.stowe@hp.com,
       linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Tue, 04 Nov 2008 14:52:50 -0700
Message-ID: <20081104213732.15214.174.stgit@bob.kio>
User-Agent: StGIT/0.14.3.215.gff3d
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following three item patch series fixes an issue with the introduction
of > 256 processor declaration support: "Allow processor to be declared with
the Device() instead of Processor()" (git SHA 11bf04c4).

This version, v3, has no functional changes from the original
(gmane.linux.acpi.devel/34815).  The changes, based on reviewer comments, are:
  . a change to the printk verbage (v2),
  . some additional comments (v2),
  . augment an existing printk to aid detection of faulty FW (v3).

Please queue as .29 material.

Thanks,
Myron

---

Myron Stowe (3):
      ACPI: 80 column adherence and spelling fix (no functional change)
      ACPI: Behave uniquely based on processor declaration definition type
      ACPI: Disambiguate processor declaration type


 drivers/acpi/processor_core.c |   86 +++++++++++++++++++++++------------------
 drivers/acpi/scan.c           |    2 -
 include/acpi/acpi_drivers.h   |    1 
 3 files changed, 51 insertions(+), 38 deletions(-)

