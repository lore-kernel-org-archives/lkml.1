Return-Path: <linux-kernel-owner+w=401wt.eu-S932212AbXDAFYO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932212AbXDAFYO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Apr 2007 01:24:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932224AbXDAFYO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Apr 2007 01:24:14 -0400
Received: from ug-out-1314.google.com ([66.249.92.168]:48424 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932212AbXDAFYO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Apr 2007 01:24:14 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=j/ii8KrDya3QRf4m/rhgd9H4UQ1QV0/IkEtRHh2TN0SpZdgnR45ZnzkoJ1+Ke8djHCPLooQG4pI3p68tpMVQYDBlMfTmM7glC8R/5JP6afoWJ5ILRluClMhr/BOeuKSc3orjOvufQC3oRcFHm/PDlwkxD8P9D6HN+3pIv9+xlyc=
Message-ID: <9c9aa5d00703312224t1948b24bhe34199f19cbda4fb@mail.gmail.com>
Date: Sat, 31 Mar 2007 22:24:12 -0700
From: "Pedram M" <pmessri@gmail.com>
To: kernel-janitors@lists.osdl.org
Subject: Re: my first janitorial
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <9c9aa5d00703310639q68fa5d19k4d8e3bfb56b1fa6@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <9c9aa5d00703310639q68fa5d19k4d8e3bfb56b1fa6@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

How about this one? Am I doing it right now?
If not, please try to explain more to me what I am
doing wrong.

@@ -4760,7 +4760,7 @@
 	for (i = 0; i < NR_CARDS; i++) {
 		/* look for a Cyclades card by vendor and device id */
 		while ((device_id = cy_pci_dev_id[dev_index]) != 0) {
-			if ((pdev = pci_find_device(PCI_VENDOR_ID_CYCLADES,
+			if ((pdev = pci_get_device(PCI_VENDOR_ID_CYCLADES,
 						   device_id, pdev)) == NULL) {
 				dev_index++;	/* try next device id */
 			} else {
