Return-Path: <linux-kernel-owner+w=401wt.eu-S1755476AbZBTXXs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755476AbZBTXXs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Feb 2009 18:23:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754049AbZBTXXj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Feb 2009 18:23:39 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52239 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753830AbZBTXXi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Feb 2009 18:23:38 -0500
Date: Fri, 20 Feb 2009 15:23:05 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: torvalds@linux-foundation.org, linux-scsi@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [GIT PATCH] SCSI fixes for 2.6.29-rc5
Message-Id: <20090220152305.8a2e384f.akpm@linux-foundation.org>
In-Reply-To: <1235170927.9025.42.camel@localhost.localdomain>
References: <1235170927.9025.42.camel@localhost.localdomain>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 20 Feb 2009 17:02:07 -0600
James Bottomley <James.Bottomley@HansenPartnership.com> wrote:

> This is a bunch of assorted bug fixes (with several in the qlogic
> drivers).
> 
> The patch is available at
> 
> master.kernel.org:/pub/scm/linux/kernel/git/jejb/scsi-rc-fixes-2.6.git
> 
> The short changelog is:
> 
> Andrew Vasquez (3):
>       qla2xxx: Update version number to 8.03.00-k3.
>       qla2xxx: Mask out 'reserved' bits while processing FLT regions.
>       qla2xxx: Properly acknowledge IDC notification messages.
> 
> Anirban Chakraborty (2):
>       qla2xxx: Correct slab-error overwrite during vport creation and deletion.
>       qla2xxx: Remove interrupt request bit check in the response processing pat
> 
> Brian King (3):
>       ibmvfc: Increase cancel timeout
>       ibmvfc: Fix rport relogin
>       ibmvfc: Fix command timeout errors
> 
> James Smart (1):
>       scsi_scan: add missing interim SDEV_DEL state if slave_alloc fails
> 
> Julia Lawall (1):
>       lpfc: introduce missing kfree
> 
> Martin Peschke (1):
>       sg: fix device number in blktrace data
> 
> Mike Christie (1):
>       libiscsi: Fix scsi command timeout oops in iscsi_eh_timed_out
> 
> Robert Jennings (1):
>       ibmvscsi: Correct DMA mapping leak
> 
> Shyam_Iyer@Dell.com (1):
>       qla2xxx: fix Kernel Panic with Qlogic 2472 Card.

Did the mpt-fusion MSI problems get sorted out?  I think so...

I believe that "scsi: mpt: suppress debugobjects warning" is 2.6.29
material.  Sent 11 Feb, no response.

Also I believe that "hptiop: add new PCI device ID" should be in 2.6.29
(and earlier), below.  I can send this on if you like.


From: HighPoint Linux Team <linux@highpoint-tech.com>

Add a new PCI device ID.

Signed-off-by: HighPoint Linux Team <linux@highpoint-tech.com>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/scsi/hptiop.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN drivers/scsi/hptiop.c~hptiop-add-new-pci-device-id drivers/scsi/hptiop.c
--- a/drivers/scsi/hptiop.c~hptiop-add-new-pci-device-id
+++ a/drivers/scsi/hptiop.c
@@ -1251,6 +1251,7 @@ static struct pci_device_id hptiop_id_ta
 	{ PCI_VDEVICE(TTI, 0x3530), (kernel_ulong_t)&hptiop_itl_ops },
 	{ PCI_VDEVICE(TTI, 0x3560), (kernel_ulong_t)&hptiop_itl_ops },
 	{ PCI_VDEVICE(TTI, 0x4322), (kernel_ulong_t)&hptiop_itl_ops },
+	{ PCI_VDEVICE(TTI, 0x4321), (kernel_ulong_t)&hptiop_itl_ops },
 	{ PCI_VDEVICE(TTI, 0x4210), (kernel_ulong_t)&hptiop_itl_ops },
 	{ PCI_VDEVICE(TTI, 0x4211), (kernel_ulong_t)&hptiop_itl_ops },
 	{ PCI_VDEVICE(TTI, 0x4310), (kernel_ulong_t)&hptiop_itl_ops },
_

