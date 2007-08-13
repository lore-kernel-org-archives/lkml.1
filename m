Return-Path: <linux-kernel-owner+w=401wt.eu-S1032128AbXHMU30@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1032128AbXHMU30 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 16:29:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756771AbXHMU3E
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 16:29:04 -0400
Received: from mga03.intel.com ([143.182.124.21]:37727 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753785AbXHMU3B (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 16:29:01 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.19,256,1183359600"; 
   d="scan'208";a="262596587"
Message-ID: <46C0BEE9.1010207@intel.com>
Date: Mon, 13 Aug 2007 13:28:25 -0700
From: "Kok, Auke" <auke-jan.h.kok@intel.com>
User-Agent: Thunderbird 2.0.0.4 (X11/20070623)
MIME-Version: 1.0
To: Richard Knutsson <ricknu-0@student.ltu.se>
CC: Joe Perches <joe@perches.com>, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, torvalds@linux-foundation.org
Subject: Re: [PATCH] [1/2many] - FInd the maintainer(s) for a patch -	scripts/get_maintainer.pl
References: <1186984174.10249.7.camel@localhost> <46C07C16.6060406@intel.com> <46C0B3BF.20500@student.ltu.se>
In-Reply-To: <46C0B3BF.20500@student.ltu.se>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 13 Aug 2007 20:28:57.0759 (UTC) FILETIME=[93591AF0:01C7DDE8]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Richard Knutsson wrote:
> Kok, Auke wrote:
>> Joe Perches wrote:
>>> I grew weary of looking up the appropriate
>>> maintainer email address(es) to CC: for a patch.
>>>
>>> I added flags to the MAINTAINERS file
>>>
>>> F:    file pattern
>>>
>>> for each maintained block and a script to parse
>>> the modified blocks for maintainer and list
>>> email addresses.
>>>
>>> perl scripts/get_maintainer.pl <patch>
>>>
>>> gives the appropriate maintainer(s).
>>>
>>> Modifications since last post:
>>>
>>> Added options to control email address style and multiple address 
>>> separator
>>>
>>> Please apply.
>> Well, I came up with this implementation, so I definately support it 
>> and the way Joe implemented it:
>>
> Really? Please check out this thread with at least two ideas of possible 
> implementations, with Stefan Richter as the spokesman of the current 
> implementation: http://marc.info/?l=linux-kernel&m=116870578531280&w=3
> ...and I am not saying there hasn't been someone suggesting it even earlier.
> 
> The expression; nothing is new under the sun comes to mind ;)
> 
> Anyway, glad to see someone actually implementing it. Thanks!

bad wording my side, I never implemented anything, but I did post the "F:" flag 
idea specific to allocating files to developers on lkml: 
http://lkml.org/lkml/2007/6/29/300

Cheers,

Auke
