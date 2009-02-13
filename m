Return-Path: <linux-kernel-owner+w=401wt.eu-S1760371AbZBMTWe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760371AbZBMTWe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Feb 2009 14:22:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758631AbZBMTWX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Feb 2009 14:22:23 -0500
Received: from rcsinet13.oracle.com ([148.87.113.125]:25415 "EHLO
	rgminet13.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751326AbZBMTWV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Feb 2009 14:22:21 -0500
Message-ID: <4995C85E.9040001@oracle.com>
Date: Fri, 13 Feb 2009 11:22:06 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
Organization: Oracle Linux Engineering
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       Greg KH <greg@kroah.com>, linux-usb <linux-usb@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH -next] usb: fix ehci printk formats
References: <20090213175526.d0590862.sfr@canb.auug.org.au>
In-Reply-To: <20090213175526.d0590862.sfr@canb.auug.org.au>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt703.oracle.com [141.146.40.81]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A09020A.4995C83C.02E6:SCFSTAT928724,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

Fix ehci printk formats:

drivers/usb/host/ehci-q.c:351: warning: format '%d' expects type 'int', but argument 4 has type 'size_t'
drivers/usb/host/ehci-q.c:351: warning: format '%d' expects type 'int', but argument 5 has type 'size_t'

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 drivers/usb/host/ehci-q.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- linux-next-20090213.orig/drivers/usb/host/ehci-q.c
+++ linux-next-20090213/drivers/usb/host/ehci-q.c
@@ -349,7 +349,7 @@ qh_completions (struct ehci_hcd *ehci, s
 						--qh->xacterrs > 0 &&
 						!urb->unlinked) {
 					ehci_dbg(ehci,
-	"detected XactErr len %d/%d retry %d\n",
+	"detected XactErr len %zu/%zu retry %d\n",
 	qtd->length - QTD_LENGTH(token), qtd->length,
 	QH_XACTERR_MAX - qh->xacterrs);
 
