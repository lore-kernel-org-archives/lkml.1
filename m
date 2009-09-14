Return-Path: <linux-kernel-owner+w=401wt.eu-S1753685AbZINJkZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753685AbZINJkZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Sep 2009 05:40:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755155AbZINJkW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Sep 2009 05:40:22 -0400
Received: from hera.kernel.org ([140.211.167.34]:46619 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754972AbZINJkV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Sep 2009 05:40:21 -0400
Message-ID: <4AAE0F7B.5050203@kernel.org>
Date: Mon, 14 Sep 2009 18:40:11 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.22 (X11/20090605)
MIME-Version: 1.0
To: Frans Pop <elendil@planet.nl>
CC: Jesse Brandeburg <jesse.brandeburg@intel.com>,
       linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: bisect results of MSI-X related panic (help!)
References: <1252699744.3877.15.camel@jbrandeb-hc.jf.intel.com> <200909120623.49764.elendil@planet.nl>
In-Reply-To: <200909120623.49764.elendil@planet.nl>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Mon, 14 Sep 2009 09:40:14 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Frans Pop wrote:
> Jesse Brandeburg wrote:
>> I've bisected, here is my bisect log, problem is that the commit
>> identified is a merge commit, and *I don't know what to revert to test*.
>> It appears the parent of the merge:
>> 6e15cf04860074ad032e88c306bea656bbdd0f22 is marked good, but looks to be
>> in a possibly related area to the panic.
> 
> That merge does contain quite a few merge fixups, so it's quite possible 
> one of them is the cause of the failure.
> Maybe the simplest way to verify that is to compile both parents of the 
> merge to doublecheck that they work OK. Then, if a compile of the merge 
> itself is bad, the problem really is in the merge commit itself.
> 
> That commit is the "percpu" merge, so I've added Tejun (author of most of 
> that branch) and Ingo (merger) in CC.

Sorry, the oops doesn't ring a bell, well, not yet at least.  It would
be great if the bisection can be narrowed down more.

-- 
tejun
