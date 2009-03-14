Return-Path: <linux-kernel-owner+w=401wt.eu-S1760601AbZCNB0E@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760601AbZCNB0E (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Mar 2009 21:26:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752811AbZCNBT7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Mar 2009 21:19:59 -0400
Received: from kroah.org ([198.145.64.141]:34874 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752681AbZCNBT5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Mar 2009 21:19:57 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Fri Mar 13 18:10:33 2009
Message-Id: <20090314011033.739621017@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Fri, 13 Mar 2009 18:09:53 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, Willy Tarreau <w@1wt.eu>,
       Rodrigo Rubira Branco <rbranco@la.checkpoint.com>,
       Jake Edge <jake@lwn.net>, Eugene Teo <eteo@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk,
       HighPoint Linux Team <linux@highpoint-tech.com>,
       James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: [patch 016/114] SCSI: hptiop: Add new PCI device ID
References: <20090314010937.416083662@mini.kroah.org>
Content-Disposition: inline; filename=scsi-hptiop-add-new-pci-device-id.patch
In-Reply-To: <20090314011649.GA26170@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.28-stable review patch.  If anyone has any objections, please let us know.

------------------

From: HighPoint Linux Team <linux@highpoint-tech.com>

commit b73a77494292b930642fbf87de3e3196593f7593 upstream.

Signed-off-by: HighPoint Linux Team <linux@highpoint-tech.com>
Signed-off-by: James Bottomley <James.Bottomley@HansenPartnership.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/scsi/hptiop.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/scsi/hptiop.c
+++ b/drivers/scsi/hptiop.c
@@ -1251,6 +1251,7 @@ static struct pci_device_id hptiop_id_ta
 	{ PCI_VDEVICE(TTI, 0x3530), (kernel_ulong_t)&hptiop_itl_ops },
 	{ PCI_VDEVICE(TTI, 0x3560), (kernel_ulong_t)&hptiop_itl_ops },
 	{ PCI_VDEVICE(TTI, 0x4322), (kernel_ulong_t)&hptiop_itl_ops },
+	{ PCI_VDEVICE(TTI, 0x4321), (kernel_ulong_t)&hptiop_itl_ops },
 	{ PCI_VDEVICE(TTI, 0x4210), (kernel_ulong_t)&hptiop_itl_ops },
 	{ PCI_VDEVICE(TTI, 0x4211), (kernel_ulong_t)&hptiop_itl_ops },
 	{ PCI_VDEVICE(TTI, 0x4310), (kernel_ulong_t)&hptiop_itl_ops },


