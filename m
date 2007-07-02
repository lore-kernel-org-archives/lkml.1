Return-Path: <linux-kernel-owner+w=401wt.eu-S1756726AbXGBVqN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756726AbXGBVqN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jul 2007 17:46:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755650AbXGBVp4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Jul 2007 17:45:56 -0400
Received: from mga01.intel.com ([192.55.52.88]:24236 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755629AbXGBVpz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jul 2007 17:45:55 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.16,489,1175497200"; 
   d="scan'208";a="263707107"
Message-ID: <46897212.30104@intel.com>
Date: Mon, 02 Jul 2007 14:45:54 -0700
From: "Kok, Auke" <auke-jan.h.kok@intel.com>
User-Agent: Thunderbird 2.0.0.4 (X11/20070623)
MIME-Version: 1.0
To: Bill Davidsen <davidsen@tmr.com>
CC: Adrian Bunk <bunk@stusta.de>, jgarzik@pobox.com, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org, saw@saw.sw.com.sg
Subject: Re: [2.6 patch] the overdue eepro100 removal
References: <20070701202139.GM10869@stusta.de> <46894BD5.9080609@tmr.com>
In-Reply-To: <46894BD5.9080609@tmr.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 02 Jul 2007 21:45:54.0610 (UTC) FILETIME=[5DDB2920:01C7BCF2]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Bill Davidsen wrote:
> Adrian Bunk wrote:
>> This patch contains the overdue removal of the eepro100 driver.
>>
>> Signed-off-by: Adrian Bunk <bunk@stusta.de>
>>
> The hardware supported by this driver is still in use, thanks. It's 
> probably easier to leave the eepro100 driver in than find anyone who 
> wants to investigate why the other driver (e100? from memory) doesn't 
> work with some cards. As I recall this was suggested over a year ago and 
> it was decided to leave it in, all of the reasons for doing so still 
> seem valid. There really doesn't seem to be a benefit, it's not like 
> people are working night and day to support new cards for this chip.
> 

please see the thread "Re: [PATCH] fix e100 rx path on ARM (was [PATCH] e100 rx: 
or s and el bits)" which is discussing a fix for this issue and currently being 
worked.

eepro100 will *still* be removed once e100 is fixed to support those devices.

Moreover, we now also have a fix for the e100 IPMI issues on some tyan boards 
(patch coming this week!). That hopefully solves all e100 issues that are still 
open.

Auke
