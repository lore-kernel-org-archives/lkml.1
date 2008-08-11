Return-Path: <linux-kernel-owner+w=401wt.eu-S1755327AbYHKWuE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755327AbYHKWuE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2008 18:50:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751962AbYHKWty
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Aug 2008 18:49:54 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:42832 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751680AbYHKWtx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2008 18:49:53 -0400
X-IronPort-AV: E=McAfee;i="5200,2160,5358"; a="5612960"
Message-ID: <48A0C213.4090305@qualcomm.com>
Date: Mon, 11 Aug 2008 15:49:55 -0700
From: Max Krasnyansky <maxk@qualcomm.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
       Dmitry Adamushko <dmitry.adamushko@gmail.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       "Langsdorf, Mark" <mark.langsdorf@amd.com>,
       lkml <linux-kernel@vger.kernel.org>, Gautham R Shenoy <ego@in.ibm.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: Regression in 2.6.27-rc1 for set_cpus_allowed_ptr
References: <6453C3CB8E2B3646B0D020C112613273C5AC5A@sausexmb4.amd.com> <200808082303.41068.rjw@sisk.pl> <b647ffbd0808081431q27a48113q5beee1bae7c24b0a@mail.gmail.com> <20080811123020.GB10082@elte.hu> <alpine.LFD.1.10.0808111500330.3462@nehalem.linux-foundation.org> <48A0B9AC.6020901@qualcomm.com> <20080811224636.GA25577@elte.hu>
In-Reply-To: <20080811224636.GA25577@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Ingo Molnar wrote:
> * Max Krasnyansky <maxk@qualcomm.com> wrote:
> 
>>> And I was hoping to do -rc3 today. Can I please have pull-requests for the 
>>> appropriate urgent scheduler/x86 fixes? Or should I just take these as 
>>> patches?
>> It'd be nice if -rc3 included my cpuset patch so that we could put circular
>> locking issues in the cpu hotplug path to the rest.
>> Ingo, I'm talking about this:
>> 	[PATCH] cpuset: Rework sched domains and CPU hotplug handling (take 4)
> 
> the latest (-v4) version of the patch was submitted just half an hour 
> ago and it's rather large/complex, with a few unrelated changes 
> (whitespace, etc.) mixed in as well. I'd like to wait for Paul's final 
> ack for -v4 (he has already agreed with the approach in general), and 
> wanted to have it tested myself as well, at least minimally.

Fair enough.

btw Whitespace and other cosmetic changes were requested by reviewers.

Max
