Return-Path: <linux-kernel-owner+w=401wt.eu-S1754848AbYJ3WN4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754848AbYJ3WN4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2008 18:13:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757485AbYJ3WN1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Oct 2008 18:13:27 -0400
Received: from g5t0008.atlanta.hp.com ([15.192.0.45]:46781 "EHLO
	g5t0008.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757278AbYJ3WNZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2008 18:13:25 -0400
From: Myron Stowe <myron.stowe@hp.com>
Subject: [PATCH v2 3/3] ACPI: 80 column adherence and spelling fix (no
	functional change)
To: lenb@kernel.org
Cc: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
       Myron Stowe <myron.stowe@hp.com>
Date: Thu, 30 Oct 2008 16:13:24 -0600
Message-ID: <20081030221324.30683.83564.stgit@bob.kio>
In-Reply-To: <20081030215410.30683.95368.stgit@bob.kio>
References: <20081030215410.30683.95368.stgit@bob.kio>
User-Agent: StGIT/0.14.3.215.gff3d
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Myron Stowe <myron.stowe@hp.com>
---

 drivers/acpi/processor_core.c |    7 ++++---
 1 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/acpi/processor_core.c b/drivers/acpi/processor_core.c
index 35d33e8..10088ae 100644
--- a/drivers/acpi/processor_core.c
+++ b/drivers/acpi/processor_core.c
@@ -594,9 +594,10 @@ static int acpi_processor_get_info(struct acpi_device *device)
 		}
 
 		/*
-		* TBD: Synch processor ID (via LAPIC/LSAPIC structures) on SMP.
-		*      >>> 'acpi_get_processor_id(acpi_id, &id)' in arch/xxx/acpi.c
-		*/
+		 * TBD: Synch processor ID (via LAPIC/LSAPIC structures) on SMP.
+		 *      >>> 'acpi_get_processor_id(acpi_id, &id)' in
+		 *      arch/xxx/acpi.c
+		 */
 		pr->acpi_id = object.processor.proc_id;
 	}
 	cpu_index = get_cpu_id(pr->handle, device_declaration, pr->acpi_id);

