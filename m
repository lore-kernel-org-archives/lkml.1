Return-Path: <linux-kernel-owner+w=401wt.eu-S1751573AbXC1W0W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751573AbXC1W0W (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Mar 2007 18:26:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753182AbXC1W0W
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Mar 2007 18:26:22 -0400
Received: from mga03.intel.com ([143.182.124.21]:26244 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751573AbXC1W0V (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Mar 2007 18:26:21 -0400
X-ExtLoop1: 1
X-IronPort-AV: i="4.14,342,1170662400"; 
   d="scan'208"; a="204554744:sNHT25260116"
Message-ID: <460AEB85.1020101@intel.com>
Date: Wed, 28 Mar 2007 15:26:13 -0700
From: "Kok, Auke" <auke-jan.h.kok@intel.com>
User-Agent: Mail/News 1.5.0.10 (X11/20070311)
MIME-Version: 1.0
To: Bill Davidsen <davidsen@tmr.com>
CC: Adrian Bunk <bunk@stusta.de>, Andrew Morton <akpm@linux-foundation.org>,
       jgarzik@pobox.com, netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       saw@saw.sw.com.sg, Jesse Brandeburg <jesse.brandeburg@intel.com>
Subject: Re: [2.6 patch] the scheduled eepro100 removal
References: <20070325145810.GI16477@stusta.de> <460AE997.90509@tmr.com>
In-Reply-To: <460AE997.90509@tmr.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 28 Mar 2007 22:26:14.0375 (UTC) FILETIME=[187DFF70:01C77188]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Bill Davidsen wrote:
> Adrian Bunk wrote:
>> This patch contains the scheduled removal of the eepro100 driver.
>>
>> Signed-off-by: Adrian Bunk <bunk@stusta.de>
>>
>>
> This keeps coming around, but I haven't seen an answer to the questions 
> raised by Eric Piel or Kiszka. I do know that e100 didn't work on some 
> IBM rackmount servers and eepro100 did, but since I'm no longer 
> responsible for those machines I can't retest. Perhaps someone will be 
> able to provide data points.
> 
> IBM current offerings as of about three years ago, I had a few dozen of 
> them at one time.

We have provided a (test) driver which allows e100 to use IO to communicate with 
the device, which seems to have helped for one person. I think we need to work 
with those changes and see if it helps the other people resolve their e100 
issues. Unfortunately it keeps slipping off to the low priority list for us.

I suggest that we should push this code into -mm for people to test or 
something. It's fairly low risk as by default the patch won't enable IO and thus 
use the old method of writing to the adapter.

Auke
