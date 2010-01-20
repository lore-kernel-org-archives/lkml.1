Return-Path: <linux-kernel-owner+w=401wt.eu-S1755621Ab0ATHG2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755621Ab0ATHG2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jan 2010 02:06:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751181Ab0ATHG1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Jan 2010 02:06:27 -0500
Received: from g6t0184.atlanta.hp.com ([15.193.32.61]:23002 "EHLO
	g6t0184.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752547Ab0ATHG0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jan 2010 02:06:26 -0500
Subject: [PATCH 0/2] ACPI: Early _PDC tweaks
To: lenb@kernel.org
From: Alex Chiang <achiang@hp.com>
Cc: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Wed, 20 Jan 2010 00:06:25 -0700
Message-ID: <20100120070403.19777.31978.stgit@bob.kio>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As requested by Len, a few more improvements in how we handle the
early _PDC path.

Allow platforms not listed in the DMI table to opt-in for early _PDC
with a kernel command line param.

If we do evaluate _PDC early, remember that fact and do not evaluate
it a second time when the ACPI processor driver loads.

/ac

---

Alex Chiang (2):
      ACPI: processor: add kernel command line support for early _PDC eval
      ACPI: processor: only evaluate _PDC once per processor


 Documentation/kernel-parameters.txt |    4 ++++
 drivers/acpi/processor_pdc.c        |   14 ++++++++++++++
 2 files changed, 18 insertions(+), 0 deletions(-)

