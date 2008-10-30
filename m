Return-Path: <linux-kernel-owner+w=401wt.eu-S1757261AbYJ3WNY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757261AbYJ3WNY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2008 18:13:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753388AbYJ3WNM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Oct 2008 18:13:12 -0400
Received: from g5t0006.atlanta.hp.com ([15.192.0.43]:16239 "EHLO
	g5t0006.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751690AbYJ3WNK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2008 18:13:10 -0400
From: Myron Stowe <myron.stowe@hp.com>
Subject: [PATCH v2 0/3] ACPI: Fix for supporting > 256 processor declaration
	limit
To: lenb@kernel.org
Cc: aystarik@gmail.com, yakui.zhao@intel.com, linux-acpi@vger.kernel.org,
       linux-kernel@vger.kernel.org
Date: Thu, 30 Oct 2008 16:13:09 -0600
Message-ID: <20081030215410.30683.95368.stgit@bob.kio>
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

This version, v2, has no functional changes from the original
(gmane.linux.acpi.devel/34815).  The changes, base on reviewer comments, are:
  . a change to the printk verbage,
  . some additional comments.

Please queue as .29 material.

Thanks,
Myron

---

Myron Stowe (3):
      ACPI: 80 column adherence and spelling fix (no functional change)
      ACPI: Behave uniquely based on processor declaration definition type
      ACPI: Disambiguate processor declaration type


 drivers/acpi/processor_core.c |   83 +++++++++++++++++++++++------------------
 drivers/acpi/scan.c           |    2 -
 include/acpi/acpi_drivers.h   |    1 
 3 files changed, 49 insertions(+), 37 deletions(-)

