Return-Path: <linux-kernel-owner+w=401wt.eu-S966046AbXCSRgt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966046AbXCSRgt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2007 13:36:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966049AbXCSRgt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Mar 2007 13:36:49 -0400
Received: from mga03.intel.com ([143.182.124.21]:3848 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966046AbXCSRgs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2007 13:36:48 -0400
X-ExtLoop1: 1
X-IronPort-AV: i="4.14,301,1170662400"; 
   d="scan'208"; a="198882945:sNHT18585763"
Message-ID: <45FECA26.7010905@intel.com>
Date: Mon, 19 Mar 2007 10:36:38 -0700
From: akorolev <alexey.korolev@intel.com>
User-Agent: Thunderbird 1.5.0.10 (Windows/20070221)
MIME-Version: 1.0
To: Willy Tarreau <w@1wt.eu>
CC: David Woodhouse <dwmw2@infradead.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Linux 2.4.x MTD CFI P30/P33 support
References: <523F3D8D8C97554AA47E53DF1A05466A666249@nnsmsx411.ccr.corp.intel.com> <20070317064637.GA14739@1wt.eu>
In-Reply-To: <20070317064637.GA14739@1wt.eu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 19 Mar 2007 17:36:40.0913 (UTC) FILETIME=[27625410:01C76A4D]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Willy,


> OK, it seems trivial enough to me. I have no problem merging this. Your
> mailer has wrapped lines, but I'll fix this by hand.
>   
Oh thank you very much. Sorry for wrapped text. I've corrected it.

Signed-off-by: Alexey Korolev <alexey.korolev@intel.com
------------------------
--- a/drivers/mtd/chips/cfi_cmdset_0001.c	2003-06-13 18:51:34.000000000 +0400
+++ b/drivers/mtd/chips/cfi_cmdset_0001.c	2007-02-16 21:39:50.000000000 +0300
@@ -152,7 +152,7 @@
 		}
 		
 		if (extp->MajorVersion != '1' || 
-		    (extp->MinorVersion < '0' || extp->MinorVersion > '3')) {
+		    (extp->MinorVersion < '0' || extp->MinorVersion > '4')) {
 			printk(KERN_WARNING "  Unknown IntelExt Extended Query "
 			       "version %c.%c.\n",  extp->MajorVersion,
 			       extp->MinorVersion);
------------------------

Thanks,
Alexey
