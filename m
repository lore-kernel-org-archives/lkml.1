Return-Path: <linux-kernel-owner+w=401wt.eu-S1753822AbZBRMzL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753822AbZBRMzL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Feb 2009 07:55:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751877AbZBRMyz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Feb 2009 07:54:55 -0500
Received: from stinky.trash.net ([213.144.137.162]:51797 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751635AbZBRMyy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Feb 2009 07:54:54 -0500
Message-ID: <499C0519.2050204@trash.net>
Date: Wed, 18 Feb 2009 13:54:49 +0100
From: Patrick McHardy <kaber@trash.net>
User-Agent: Mozilla-Thunderbird 2.0.0.19 (X11/20090103)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Oleg Nesterov <oleg@redhat.com>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Stephen Hemminger <shemminger@vyatta.com>,
       David Miller <davem@davemloft.net>, Rick Jones <rick.jones2@hp.com>,
       Eric Dumazet <dada1@cosmosbay.com>, netdev@vger.kernel.org,
       netfilter-devel@vger.kernel.org, tglx@linutronix.de,
       Martin Josefsson <gandalf@wlug.westbo.se>, linux-kernel@vger.kernel.org
Subject: Re: [patch] timers: add mod_timer_pending()
References: <20090218051906.174295181@vyatta.com> <20090218052747.437271195@vyatta.com> <20090218092041.GC3294@elte.hu> <499BDDFE.5010101@trash.net> <20090218120508.GB4100@elte.hu> <499C000A.4040205@trash.net> <20090218125049.GA28791@elte.hu>
In-Reply-To: <20090218125049.GA28791@elte.hu>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> To accelerate matters i've committed the new API patch into a 
> new standalone topic branch: tip:timers/new-apis.
> 
> Unless there are objections or test failures, you (or Stephen or 
> David) can then git-pull it into the networking tree via the Git 
> coordinates below - and you'll get this single commit in a 
> surgical manner - no other timer changes are included.
> 
> Doing so has the advantage of:
> 
> - You not having to wait a kernel cycle for the API to go
>   upstream.
> 
> - You can also push it upstream without waiting for the timer 
>   tree. (the timer tree and the networking tree will share the 
>   exact same commit)
> 
> - It will also all merge cleanly with the timer tree in 
>   linux-next, etc.
> 
> I'd suggest to do it in about a week, to make sure any after 
> effects have trickled down and to make sure the topic has become 
> append-only. You can ping Thomas and me about testing/review 
> status then, whenever you want to do the pull.

Thanks Ingo. I'll wait for Stephen to rebase his patches on
top of your change and the test results and will let you know.
