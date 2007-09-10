Return-Path: <linux-kernel-owner+w=401wt.eu-S1760709AbXIJPWM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760709AbXIJPWM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Sep 2007 11:22:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759540AbXIJPV6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Sep 2007 11:21:58 -0400
Received: from mga02.intel.com ([134.134.136.20]:62783 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759475AbXIJPV5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Sep 2007 11:21:57 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.20,231,1186383600"; 
   d="scan'208";a="291857800"
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: FW: [-mm patch] drivers/dma/ioat_dma.c: make 3 functions static
Date: Mon, 10 Sep 2007 08:21:29 -0700
Message-ID: <BAE9DCEF64577A439B3A37F36F9B691C030231FA@orsmsx418.amr.corp.intel.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [-mm patch] drivers/dma/ioat_dma.c: make 3 functions static
thread-index: AcfzH3vInkXCdOkfShOW+WgYGNjOzgAnklpQ
From: "Nelson, Shannon" <shannon.nelson@intel.com>
To: "Andrew Morton" <akpm@linux-foundation.org>,
       "Nelson, Shannon" <shannon.nelson@intel.com>,
       "Williams, Dan J" <dan.j.williams@intel.com>
Cc: <linux-kernel@vger.kernel.org>, "Adrian Bunk" <bunk@kernel.org>
X-OriginalArrivalTime: 10 Sep 2007 15:21:29.0964 (UTC) FILETIME=[432BFAC0:01C7F3BE]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> From: Adrian Bunk [mailto:bunk@kernel.org] 
> Sent: Sunday, September 09, 2007 1:25 PM
> To: Andrew Morton; Nelson, Shannon; Williams, Dan J
> Cc: linux-kernel@vger.kernel.org
> Subject: [-mm patch] drivers/dma/ioat_dma.c: make 3 functions static
> 

Thanks Adrian,
sln

>On Fri, Aug 31, 2007 at 09:58:22PM -0700, Andrew Morton wrote:
>>...
>> Changes since 2.6.23-rc3-mm1:
>>...
>> +i-oat-add-support-for-msi-and-msi-x.patch
>>...
>>  ioat tree
>>...

This patch makes three needlessly global functions static.

Signed-off-by: Adrian Bunk <bunk@kernel.org>
Signed-off-by: Shannon Nelson <shannon.nelson@intel.com>

---

 drivers/dma/ioat_dma.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

c633b44cd60648f456a11bb38fd9193ce4d6acdc 
diff --git a/drivers/dma/ioat_dma.c b/drivers/dma/ioat_dma.c
index e4c3afe..66c5bb5 100644
--- a/drivers/dma/ioat_dma.c
+++ b/drivers/dma/ioat_dma.c
@@ -47,8 +47,8 @@
 static void ioat_dma_start_null_desc(struct ioat_dma_chan *ioat_chan);
 static void ioat_dma_memcpy_cleanup(struct ioat_dma_chan *ioat_chan);
 
-struct ioat_dma_chan *ioat_lookup_chan_by_index(struct ioatdma_device
*device,
-						int index)
+static struct ioat_dma_chan *ioat_lookup_chan_by_index(struct
ioatdma_device *device,
+						       int index)
 {
 	return device->idx[index];
 }
@@ -716,7 +716,7 @@ MODULE_PARM_DESC(ioat_interrupt_style,
  * ioat_dma_setup_interrupts - setup interrupt handler
  * @device: ioat device
  */
-int ioat_dma_setup_interrupts(struct ioatdma_device *device)
+static int ioat_dma_setup_interrupts(struct ioatdma_device *device)
 {
 	struct ioat_dma_chan *ioat_chan;
 	int err, i, j, msixcnt;
@@ -826,7 +826,7 @@ err_no_irq:
  * ioat_dma_remove_interrupts - remove whatever interrupts were set
  * @device: ioat device
  */
-void ioat_dma_remove_interrupts(struct ioatdma_device *device)
+static void ioat_dma_remove_interrupts(struct ioatdma_device *device)
 {
 	struct ioat_dma_chan *ioat_chan;
 	int i;
