Return-Path: <linux-kernel-owner+w=401wt.eu-S1752772AbYIZLuU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752772AbYIZLuU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2008 07:50:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750985AbYIZLuG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Sep 2008 07:50:06 -0400
Received: from mga06.intel.com ([134.134.136.21]:26066 "EHLO
	orsmga101.jf.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750875AbYIZLuF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2008 07:50:05 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.33,313,1220252400"; 
   d="scan'208";a="443938631"
Message-ID: <48DCCC5F.8040609@linux.intel.com>
Date: Fri, 26 Sep 2008 04:49:51 -0700
From: Arjan van de Ven <arjan@linux.intel.com>
User-Agent: Thunderbird 2.0.0.16 (Windows/20080708)
MIME-Version: 1.0
To: Jiri Kosina <jkosina@suse.cz>
CC: "Brandeburg, Jesse" <jesse.brandeburg@intel.com>,
       LKML <linux-kernel@vger.kernel.org>, agospoda@redhat.com,
       "Ronciak, John" <john.ronciak@intel.com>,
       "Allan, Bruce W" <bruce.w.allan@intel.com>,
       "Graham, David" <david.graham@intel.com>, kkiel@suse.de,
       tglx@linutronix.de, chris.jones@canonical.com, arjan@linux.jf.intel.com
Subject: Re: e1000e NVM corruption issue status
References: <987CEB09A2567F4A963E1E226364E2D33A685B4B@orsmsx418.amr.corp.intel.com> <Pine.WNT.4.63.0809251811330.1736@jbrandeb-desk.amr.corp.intel.com> <Pine.WNT.4.63.0809251857360.1736@jbrandeb-desk.amr.corp.intel.com> <alpine.LNX.1.10.0809260812130.14480@pegasus.suse.cz>
In-Reply-To: <alpine.LNX.1.10.0809260812130.14480@pegasus.suse.cz>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jiri Kosina wrote:
> On Thu, 25 Sep 2008, Brandeburg, Jesse wrote:
> 
>> this is the current set of patches that I have to help us debug
>> and/or fix e1000e issues found during this debug effort for
>> the corrupt NVM.  the "drop stats lock" - "reset swflag" patches allow 
>> Thomas' patch for a mutex in the SWFLAG acquire function to run without 
>> any errors.
> 
> Thanks. Also Jesse Barnes' patch shouldn't be forgotten, could you please 
> add it to that lineup?
> 
> 	http://marc.info/?l=linux-kernel&m=122237193628087&w=2
> 

can we (for now) also stick a WARN_ON() into that failure path? that way we can at least
catch if/when this happens more visibly..... if it happens consistently in say the new distros
we can be more confident that we're down the right path in diagnosing the issue.

