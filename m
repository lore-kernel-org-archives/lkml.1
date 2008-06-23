Return-Path: <linux-kernel-owner+w=401wt.eu-S1757277AbYFXAOZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757277AbYFXAOZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2008 20:14:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755669AbYFXAN5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jun 2008 20:13:57 -0400
Received: from threatwall.zlynx.org ([199.45.143.218]:33568 "EHLO zlynx.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754065AbYFXAN4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2008 20:13:56 -0400
X-Greylist: delayed 1474 seconds by postgrey-1.27 at vger.kernel.org; Mon, 23 Jun 2008 20:13:56 EDT
Message-ID: <4860365F.5000609@acm.org>
Date: Mon, 23 Jun 2008 17:48:47 -0600
From: Zan Lynx <zlynx@acm.org>
User-Agent: Thunderbird 2.0.0.14 (Macintosh/20080421)
MIME-Version: 1.0
To: Nick Piggin <nickpiggin@yahoo.com.au>
CC: Ryan Hope <rmh3093@gmail.com>, Peter Zijlstra <peterz@infradead.org>,
       linux-mm@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [BUG] Lockless patches cause hardlock under heavy IO
References: <48f7fe350806181415l4eba61b3i1d206de03147575e@mail.gmail.com> <1214147244.3223.307.camel@lappy.programming.kicks-ass.net> <48f7fe350806220818n52cc36e9v28bdc6cf2c4cf841@mail.gmail.com> <200806231229.42943.nickpiggin@yahoo.com.au>
In-Reply-To: <200806231229.42943.nickpiggin@yahoo.com.au>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Envelope-From: zlynx@acm.org
X-Spam-Id: 20080623/1KAvmB-0007Gz-TP-linux-kernel@vger.kernel.org:zlynx@acm.org:199.45.143.218
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Nick Piggin wrote:
> On Monday 23 June 2008 01:18, Ryan Hope wrote:
>> Well in the current version of the patchset we are using, one user
>> would start playing some game (disabling "Disable Heap Randomization"
>> fixed the hardlocks for him... the other user got hardlocks when
>> copying an ISO from a reiser4 partition to a reiserfs partition
>> (disabling swap fixed the issue for him).
> 
> Hmm, nobody has reported such a hang with -mm yet, so maybe it
> is another interaction in the patchset. OTOH, probably nobody
> much uses -mm and reiser4, and reiser4 does lots of weird fiddling
> with pagecache so it could be broken in -mm even.

I have been running and testing -mm with reiser4 for a couple years now.
 I haven't been able to run -mm recently because I've been hitting the
copy_user bug Linus fixed for AMD64 but Andrew hasn't updated yet (no
complaints, Andrew) and I'm too lazy to manually patch.
