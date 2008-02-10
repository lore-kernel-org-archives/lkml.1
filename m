Return-Path: <linux-kernel-owner+w=401wt.eu-S1756428AbYBJEEZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756428AbYBJEEZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Feb 2008 23:04:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755866AbYBJEEQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 Feb 2008 23:04:16 -0500
Received: from numenor.qualcomm.com ([129.46.51.58]:43308 "EHLO
	numenor.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755857AbYBJEEP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Feb 2008 23:04:15 -0500
Message-ID: <47AE76B8.6060304@qualcomm.com>
Date: Sat, 09 Feb 2008 19:59:52 -0800
From: Max Krasnyansky <maxk@qualcomm.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Paul Jackson <pj@sgi.com>
CC: torvalds@linux-foundation.org, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, mingo@elte.hu, a.p.zijlstra@chello.nl,
       gregkh@suse.de, rusty@rustcorp.com.au
Subject: Re: [git pull] CPU isolation extensions (updated)
References: <47AE6A8B.6030908@qualcomm.com> <20080209212156.ecc72fee.pj@sgi.com>
In-Reply-To: <20080209212156.ecc72fee.pj@sgi.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Paul Jackson wrote:
> Max wrote:
>> Linus, please pull CPU isolation extensions from
> 
> Did I miss something in this discussion?  I thought
> Ingo was quite clear, and Linus pretty clear too,
> that this patch should bake in *-mm or some such
> place for a bit first.
> 

Andrew said:
> The feature as a whole seems useful, and I don't actually oppose the merge
> based on what I see here.  As long as you're really sure that cpusets are
> inappropriate (and bear in mind that Paul has a track record of being wrong
> on this :)).  But I see a few glitches ....

As far as I can understand Andrew is ok with the merge. And I addressed all 
his comments.

Linus said:
> Have these been in -mm and widely discussed etc? I'd like to start more 
> carefully, and (a) have that controversial last patch not merged initially 
> and (b) make sure everybody is on the same page wrt this all..

As far as I can understand Linus _asked_ whether it was in -mm or not and whether
everybody's on the same page. He did not say "this must be in -mm first".
I explained that it has not been in -mm, and who it was discussed with, and did a 
bunch more testing/investigation on the controversial patch and explained why I think 
it's not that controversial any more.

Ingo said a few different things (a bit too large to quote). 
- That it was not discussed. I explained that it was in fact discussed and provided
a bunch of pointers to the mail threads.
- That he thinks that cpuset is the way to do it. Again I explained why it's not.
And at the end he said:
> Also, i'd not mind some test-coverage in sched.git as well.

I far as I know "do not mind" does not mean "must go to" ;-). Also I replied that 
I did not mind either but I do not think that it has much (if anything) to do with
the scheduler.

Anyway. I think I mentioned that I did not mind -mm either. I think it's ready for
the mainline. But if people still strongly feel that it has to be in -mm that's fine.
Lets just do s/Linus/Andrew/ on the first line and move on. But if Linus pulls it now
even better ;-)
  
Andrew, Linus, I'll let you guys decide which tree it needs to go.

Max
