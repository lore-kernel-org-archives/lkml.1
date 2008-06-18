Return-Path: <linux-kernel-owner+w=401wt.eu-S1755842AbYFROXR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755842AbYFROXR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2008 10:23:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751410AbYFROXF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Jun 2008 10:23:05 -0400
Received: from mga09.intel.com ([134.134.136.24]:5765 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751036AbYFROXE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2008 10:23:04 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.27,664,1204531200"; 
   d="scan'208";a="261895257"
Message-ID: <48591A30.1020206@linux.intel.com>
Date: Wed, 18 Jun 2008 07:22:40 -0700
From: Arjan van de Ven <arjan@linux.intel.com>
User-Agent: Thunderbird 2.0.0.14 (Windows/20080421)
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: Dave Jones <davej@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       David Miller <davem@davemloft.net>, linux-kernel@vger.kernel.org,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       tglx@linutronix.de, linville@tuxdriver.com, gregkh@suse.de
Subject: Re: Oops report for the week preceding June 16th, 2008
References: <4856AFDF.5080901@linux.intel.com>	 <20080617092023.GA20621@elte.hu>	 <20080617.022652.76635616.davem@davemloft.net>	 <20080617153356.GA3510@elte.hu> <1213730654.3803.122.camel@johannes.berg>	 <20080617194105.GA18177@redhat.com>  <48588255.9060400@linux.intel.com> <1213773447.3803.150.camel@johannes.berg>
In-Reply-To: <1213773447.3803.150.camel@johannes.berg>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Johannes Berg wrote:
>>> FWIW, wireless isn't unique in this regard. For eg, the last few months we've
>>> always been shipping the latest ALSA bits rather than what's in kernel.org too,
>>> for similar reasons -- when bugs appear, the developers want to know
>>> "does it still happen with the latest bits?"
>>>
>>
>> this is the part that concerns me.  The fact that you feel the need to use "not yet in mainline" pieces
>> (I'm not so much talking about backporting from 2.6.26-git to 2.6.25; that's perfectly fine, but I'm
>> talking about code not in 2.6.26-git) is NOT a healthy sign.... if that truely is the case then that code surely
>> deserves to be in mainline as well?
> 
> That's more a case of Fedora living on the bleeding edge. The code is
> fairly stable, all in linux-next, but the churn tends to be high because
> of internal API changes that affect all drivers. Currently, I don't
> think there is actually any _feature_ pending in linux-next, only
> internal cleanups. Such cleanups are desirable, but at the same time can
> lead to instability, hence being kept out of .26-git for the time being,
> and are in -next for .27. Mostly because we only wrote them after .26
> started.
> 

My concern is that if there's something technological in the "bleeding tree" that is so valuable to users
that distros feel that it's ready "enough" and that they need to pick it up for their users, we have a flaw
in our processes in moving to slow for users. From what you described that's not the case for wireless
(more a case of Fedora jumping off the bridge while forgetting to tie down the bungee cord ;-), and
that's good. I hope the same applies for the ALSA parts....

