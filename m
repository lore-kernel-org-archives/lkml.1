Return-Path: <linux-kernel-owner+w=401wt.eu-S1759689AbZDQGqW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759689AbZDQGqW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Apr 2009 02:46:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754444AbZDQGqM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Apr 2009 02:46:12 -0400
Received: from e28smtp09.in.ibm.com ([59.145.155.9]:44823 "EHLO
	e28smtp09.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752783AbZDQGqK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Apr 2009 02:46:10 -0400
Message-ID: <49E825AA.8000506@in.ibm.com>
Date: Fri, 17 Apr 2009 12:16:02 +0530
From: Sachin Sant <sachinp@in.ibm.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20081216)
MIME-Version: 1.0
To: linux-kernel <linux-kernel@vger.kernel.org>
CC: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       linux-ide@vger.kernel.org
Subject: Next April 17: x86 allmodconfig drivers/ata failure
References: <20090417120002.c47a686d.sfr@canb.auug.org.au>
In-Reply-To: <20090417120002.c47a686d.sfr@canb.auug.org.au>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Today's next allmodconfig (x86) build failed with

drivers/ata/pata_legacy.c: In function ‘pdc_data_xfer_vlb’:
drivers/ata/pata_legacy.c:289: error: ‘ap’ undeclared (first use in this 
function)
drivers/ata/pata_legacy.c:289: error: (Each undeclared identifier is 
reported only once
drivers/ata/pata_legacy.c:289: error: for each function it appears in.)
drivers/ata/pata_legacy.c: At top level:
drivers/ata/pata_legacy.c:869: error: ‘ATA_PFLAG_PIO32_CHANGE’ 
undeclared here (not in a
+function)
make[2]: *** [drivers/ata/pata_legacy.o] Error 1
make[1]: *** [drivers/ata] Error 2

Thanks
-Sachin

-- 

---------------------------------
Sachin Sant
IBM Linux Technology Center
India Systems and Technology Labs
Bangalore, India
---------------------------------

