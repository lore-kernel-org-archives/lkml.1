Return-Path: <linux-kernel-owner+w=401wt.eu-S932740AbZKDWOc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932740AbZKDWOc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Nov 2009 17:14:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932082AbZKDWOb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Nov 2009 17:14:31 -0500
Received: from Cpsmtpm-eml107.kpnxchange.com ([195.121.3.11]:56125 "EHLO
	CPSMTPM-EML107.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932620AbZKDWOb convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Nov 2009 17:14:31 -0500
From: Frans Pop <elendil@planet.nl>
To: Michael Guntsche <mike@it-loops.com>
Subject: Re: Page alloc problems with 2.6.32-rc kernels
Date: Wed, 4 Nov 2009 23:14:32 +0100
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       Mel Gorman <mel@csn.ul.ie>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       Andrew Morton <akpm@linux-foundation.org>
References: <20091102122010.GA5552@gibson.comsick.at> <200911040114.08879.elendil@planet.nl> <20091104071750.GA19287@gibson.comsick.at>
In-Reply-To: <20091104071750.GA19287@gibson.comsick.at>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Content-Disposition: inline
Message-Id: <200911042314.35006.elendil@planet.nl>
X-OriginalArrivalTime: 04 Nov 2009 22:14:35.0383 (UTC) FILETIME=[311E4870:01CA5D9C]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 04 November 2009, Michael Guntsche wrote:
> On 04 Nov 09 01:14, Frans Pop wrote:
> > Thanks Michael. That means we now have two cases where reverting the
> > congestion_wait() changes from .31-rc3 (8aa7e847d8 + 373c0a7ed3) makes
> > a clear and significant difference.
> >
> > I wonder if more effort could/should be made on this aspect.
>
> As a cross check I reverted the revert here and tried to reproduce the
> problem again. It is a lot harder to trigger for me now (I was not able
> to reproduce it yet). I did update my local git tree though,

OK. Can you tell us a bit more about your setup:
- how much RAM does the system have?
- what's so special about mutt in your case that it triggers these errors?
  - do you maybe have a huge mailbox, so mutt uses a lot of memory?
  - does starting/use mutt cause swapping when you see the errors?
- do you use disk encryption at all?
  - if you do, what is encrypted: the file system, swap, both?

>From your first mail it does look as if you had little free memory and that 
swap was in use.

> can you reproduce this problem on your side with current git?

Yes I can, but my test case is somewhat special as it forces a huge amount 
of swapping. It does look as if your problem may also be related to 
swapping activity.

Cheers,
FJP
