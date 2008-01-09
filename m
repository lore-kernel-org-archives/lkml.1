Return-Path: <linux-kernel-owner+w=401wt.eu-S1755580AbYAIPlA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755580AbYAIPlA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2008 10:41:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752216AbYAIPku
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Jan 2008 10:40:50 -0500
Received: from mga07.intel.com ([143.182.124.22]:30646 "EHLO
	azsmga101.ch.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751691AbYAIPkt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2008 10:40:49 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.24,263,1196668800"; 
   d="scan'208";a="362695348"
Message-ID: <4784E828.7090906@linux.intel.com>
Date: Wed, 09 Jan 2008 07:28:40 -0800
From: Arjan van de Ven <arjan@linux.intel.com>
User-Agent: Thunderbird 1.5.0.14 (Windows/20071210)
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       NetDev <netdev@vger.kernel.org>
Subject: Re: Top 10 kernel oopses for the week ending January 5th, 2008
References: <477FF149.4070609@linux.intel.com>	 (sfid-20080105_210825_521052_738F2802) <1199887950.6762.26.camel@johannes.berg>
In-Reply-To: <1199887950.6762.26.camel@johannes.berg>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Johannes Berg wrote:
>> Rank 1: __ieee80211_rx
>> 	Warning at net/mac80211/rx.c:1672
>> 	Reported 6 times (11 total reports)
>> 	Same issue that was ranked 2nd last week
>> 	Johannes has diagnosed this as a driver bug in the iwlwifi drivers
>> 	More info: http://www.kerneloops.org/search.php?search=__ieee80211_rx
> 
> Note that because we don't get the module list for WARN_ON, we don't
> actually know whether all of these instances are from the iwlwifi
> drivers. A few other drivers suffer from the same problem. In one of
> these cases, iwlwifi was contained in the stack trace, but in the common
> case that isn't happening because packet processing is delayed to a
> tasklet.
> 

and fwiw a patch to get this added to WARN_ON was posted by my last week to fix this;
once this goes into 2.6.25-rc this annoyance/hinderance in debugging will be fixed.
