Return-Path: <linux-kernel-owner+w=401wt.eu-S1753543AbZFWILm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753543AbZFWILm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jun 2009 04:11:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751535AbZFWIL2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jun 2009 04:11:28 -0400
Received: from mtagate2.uk.ibm.com ([194.196.100.162]:43193 "EHLO
	mtagate2.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751451AbZFWIL0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jun 2009 04:11:26 -0400
Date: Tue, 23 Jun 2009 10:11:23 +0200
From: Alexander Schmidt <alexs@linux.vnet.ibm.com>
To: Roland Dreier <rdreier@cisco.com>
Cc: Hannes Hering <hannes.hering@linux.vnet.ibm.com>,
       linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org,
       raisch@de.ibm.com, ewg@lists.openfabrics.org,
       Hoang-Nam Nguyen <hnguyen@linux.vnet.ibm.com>
Subject: Re: [ewg] Re: [PATCH 2.6.31 try 2] ehca: Tolerate dynamic memory
 operations and huge pages
Message-ID: <20090623101123.72690731@BL3D1974.boeblingen.de.ibm.com>
In-Reply-To: <adabpofr0h2.fsf@cisco.com>
References: <200906091559.24661.hannes.hering@linux.vnet.ibm.com>
	<20090616091021.2acf7302@BL3D1974.boeblingen.de.ibm.com>
	<adabpofr0h2.fsf@cisco.com>
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.12.12; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 22 Jun 2009 22:19:21 -0700
Roland Dreier <rdreier@cisco.com> wrote:

> thanks, applied.
> 
>  > -#define HCAD_VERSION "0026"
>  > +#define HCAD_VERSION "0027"
> 
> the driver version was already 0027 (since bde2cfaf), so I dropped this chunk.

thank you for applying, we would like to increase the version number for this
patch, so please also apply the following:

ehca: Increment version number for DMEM toleration

Signed-off-by: Alexander Schmidt <alexs@linux.vnet.ibm.com>
---
 drivers/infiniband/hw/ehca/ehca_main.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- infiniband.git.orig/drivers/infiniband/hw/ehca/ehca_main.c
+++ infiniband.git/drivers/infiniband/hw/ehca/ehca_main.c
@@ -52,7 +52,7 @@
 #include "ehca_tools.h"
 #include "hcp_if.h"
 
-#define HCAD_VERSION "0027"
+#define HCAD_VERSION "0028"
 
 MODULE_LICENSE("Dual BSD/GPL");
 MODULE_AUTHOR("Christoph Raisch <raisch@de.ibm.com>");
