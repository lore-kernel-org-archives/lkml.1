Return-Path: <linux-kernel-owner+w=401wt.eu-S1754040AbYI3Pqy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754040AbYI3Pqy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2008 11:46:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753337AbYI3Pqg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Sep 2008 11:46:36 -0400
Received: from mtagate3.uk.ibm.com ([195.212.29.136]:43101 "EHLO
	mtagate3.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753215AbYI3Pqf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2008 11:46:35 -0400
Message-ID: <48E249D2.2060805@fr.ibm.com>
Date: Tue, 30 Sep 2008 17:46:26 +0200
From: Daniel Lezcano <dlezcano@fr.ibm.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, netdev@vger.kernel.org, trond.myklebust@fys.uio.no,
       Pekka Enberg <penberg@cs.helsinki.fi>, Neil Brown <neilb@suse.de>
Subject: Re: [PATCH 00/30] Swap over NFS -v18
References: <20080724140042.408642539@chello.nl> <1222778476.9044.1.camel@twins>
In-Reply-To: <1222778476.9044.1.camel@twins>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter Zijlstra wrote:
> On Thu, 2008-07-24 at 16:00 +0200, Peter Zijlstra wrote:
>> Latest version of the swap over nfs work.
>>
>> Patches are against: v2.6.26-rc8-mm1
>>
>> I still need to write some more comments in the reservation code.
>>
>> Pekka, it uses ksize(), please have a look.
>>
>> This version also deals with network namespaces.
>> Two things where I could do with some suggestsion:
>>
>>   - currently the sysctl code uses current->nrproxy.net_ns to obtain
>>     the current network namespace
>>
>>   - the ipv6 route cache code has some initialization order issues
> 
> Daniel, have you ever found time to look at my namespace issues?

Oops, no. I was busy and I forgot, sorry.
Let me review the sysctl vs namespace part.

Thanks
   -- Daniel
