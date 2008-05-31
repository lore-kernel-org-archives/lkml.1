Return-Path: <linux-kernel-owner+w=401wt.eu-S1753297AbYEaAgc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753297AbYEaAgc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2008 20:36:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755547AbYEaAgE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 May 2008 20:36:04 -0400
Received: from cantor2.suse.de ([195.135.220.15]:41315 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753936AbYEaAgC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2008 20:36:02 -0400
Date: Fri, 30 May 2008 17:32:50 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Subject: Re: via agp patches
Message-ID: <20080531003250.GB6208@suse.de>
References: <20080531003214.GA6208@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080531003214.GA6208@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Looks like this adds a new device id, I have no idea why they remove
another one at the same time...

---
 drivers/char/agp/via-agp.c |    7 +------
 1 file changed, 1 insertion(+), 6 deletions(-)

--- a/drivers/char/agp/via-agp.c
+++ b/drivers/char/agp/via-agp.c
@@ -389,11 +389,6 @@ static struct agp_device_ids via_agp_dev
 		.device_id  = PCI_DEVICE_ID_VIA_VT3324,
 		.chipset_name   = "CX700",
 	},
-	/* VT3336 */
-	{
-		.device_id  = PCI_DEVICE_ID_VIA_VT3336,
-		.chipset_name   = "VT3336",
-	},
 	/* P4M890 */
 	{
 		.device_id  = PCI_DEVICE_ID_VIA_P4M890,
@@ -546,8 +541,8 @@ static const struct pci_device_id agp_vi
 	ID(PCI_DEVICE_ID_VIA_3296_0),
 	ID(PCI_DEVICE_ID_VIA_P4M800CE),
 	ID(PCI_DEVICE_ID_VIA_VT3324),
-	ID(PCI_DEVICE_ID_VIA_VT3336),
 	ID(PCI_DEVICE_ID_VIA_P4M890),
+	ID(PCI_DEVICE_ID_VIA_VT3364),
 	{ }
 };
 
