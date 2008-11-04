Return-Path: <linux-kernel-owner+w=401wt.eu-S1756694AbYKDW6B@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756694AbYKDW6B (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2008 17:58:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754278AbYKDW5w
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Nov 2008 17:57:52 -0500
Received: from mga10.intel.com ([192.55.52.92]:48632 "EHLO
	fmsmga102.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753804AbYKDW5w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2008 17:57:52 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.33,545,1220252400"; 
   d="scan'208";a="635551898"
Message-ID: <4910D37E.7030706@linux.intel.com>
Date: Tue, 04 Nov 2008 23:58:06 +0100
From: Andi Kleen <ak@linux.intel.com>
User-Agent: Thunderbird 2.0.0.17 (Windows/20080914)
MIME-Version: 1.0
To: Pekka J Enberg <penberg@cs.helsinki.fi>
CC: Robert Richter <robert.richter@amd.com>, Andi Kleen <andi@firstfloor.org>,
       Eric Dumazet <dada1@cosmosbay.com>,
       linux kernel <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: linux-2.6.28-rc2 regression : oprofile doesnt work anymore ?
References: <4909F690.9090208@cosmosbay.com> <84144f020810310721x1d1eccbeica5d10608d7b2e57@mail.gmail.com> <20081104181855.GK9785@erda.amd.com> <Pine.LNX.4.64.0811042118460.1597@melkki.cs.Helsinki.FI>
In-Reply-To: <Pine.LNX.4.64.0811042118460.1597@melkki.cs.Helsinki.FI>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pekka J Enberg wrote:
> Hi Robert,
> 
> On Tue, 4 Nov 2008, Robert Richter wrote:
>> your patchset breaks oprofile on Intel Core 2 cpus. I could bisect the
>> bug for c493756..5951290. Please take a look at this and send me a fix.
> 
> Unfortunately I don't have my machine with me right now so I can't test 
> this, but don't we want something like this? Andi?

The patch is not the correct fix to whatever the problem is.
arch perfmon is not Nehalem specific.

-Andi
