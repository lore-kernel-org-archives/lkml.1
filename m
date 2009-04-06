Return-Path: <linux-kernel-owner+w=401wt.eu-S1758921AbZDFJuX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758921AbZDFJuX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Apr 2009 05:50:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755905AbZDFJo4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Apr 2009 05:44:56 -0400
Received: from e28smtp05.in.ibm.com ([59.145.155.5]:59580 "EHLO
	e28smtp05.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755236AbZDFJoz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Apr 2009 05:44:55 -0400
Message-ID: <49D9CF13.60202@in.ibm.com>
Date: Mon, 06 Apr 2009 15:14:51 +0530
From: Sachin Sant <sachinp@in.ibm.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20081216)
MIME-Version: 1.0
To: LKML <linux-kernel@vger.kernel.org>
CC: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org
Subject: Next April 6 : x86 allmodconfig failure [drivers/pci]
References: <20090406164555.e1232116.sfr@canb.auug.org.au>
In-Reply-To: <20090406164555.e1232116.sfr@canb.auug.org.au>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Today's next tree allmodconfig build on x86 failed with

drivers/pci/intel-iommu.c:2636:35: error: macro "if" passed 2 arguments, but takes just 1
drivers/pci/intel-iommu.c: In function init_iommu_hw:
drivers/pci/intel-iommu.c:2636: error: expected ( before { token
drivers/pci/intel-iommu.c:2637: error: ______r undeclared (first use in this function)
drivers/pci/intel-iommu.c:2637: error: (Each undeclared identifier is reported only once
drivers/pci/intel-iommu.c:2637: error: for each function it appears in.)
drivers/pci/intel-iommu.c:2640:35: error: macro "if" passed 2 arguments, but takes just 1
drivers/pci/intel-iommu.c:2640: error: expected ( before { token

and many more of such errors. Similar errors with intr_remapping.c

drivers/pci/intr_remapping.c:679:28: error: macro "if" passed 2 arguments, but takes just 1
drivers/pci/intr_remapping.c: In function disable_intr_remapping:
drivers/pci/intr_remapping.c:679: error: expected ( before { token
drivers/pci/intr_remapping.c:693:28: error: macro "if" passed 2 arguments, but takes just 1
......

Thanks
-Sachin



-- 

---------------------------------
Sachin Sant
IBM Linux Technology Center
India Systems and Technology Labs
Bangalore, India
---------------------------------

