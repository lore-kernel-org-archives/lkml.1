Return-Path: <linux-kernel-owner+w=401wt.eu-S1755256AbZEKTTP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755256AbZEKTTP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 May 2009 15:19:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752997AbZEKTS6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 May 2009 15:18:58 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50540 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752733AbZEKTS6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 May 2009 15:18:58 -0400
Date: Mon, 11 May 2009 12:14:42 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Johannes Berg <johannes@sipsolutions.net>
cc: Parag Warudkar <parag.lkml@gmail.com>,
       "John W. Linville" <linville@tuxdriver.com>,
       LKML <linux-kernel@vger.kernel.org>, niel.lambrechts@gmail.com
Subject: Re: Probe Timeouts with 47afbaf5af9454a7a1a64591e20cbfcc27ca67a8
In-Reply-To: <1242067939.3873.45.camel@johannes.local>
Message-ID: <alpine.LFD.2.01.0905111157561.3586@localhost.localdomain>
References: <f7848160904301838q4883106fq8d31e2e7c0b10a14@mail.gmail.com>  <1241165805.13562.2.camel@johannes.local>  <f7848160905010619n74372488n45a7b7abccfe5ea7@mail.gmail.com>  <alpine.LFD.2.01.0905111046310.3586@localhost.localdomain> 
 <1242066170.3873.43.camel@johannes.local>  <alpine.LFD.2.01.0905111126320.3586@localhost.localdomain> <1242067939.3873.45.camel@johannes.local>
User-Agent: Alpine 2.01 (LFD 1184 2008-12-16)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 11 May 2009, Johannes Berg wrote:
> 
> Curious really, since with that fix and a revert it would go to -1 dBm.
> The only explanation I have is that then the Intel card defaults to some
> safe value because it doesn't support values < 0.

Well, since I'm testing this laptop for any corner cases, the non-working 
case had actually been tested with things like multiple suspend-to-ram 
cycles (while doing accelerated 3D and sound at the same time), along with 
testing anything else I could think of. And everything worked, but 
wireless wouldn't associate.

Reverting and rebooting, and it worked. But then when I wanted to 
double-check (sadly _after_ having already sent out the complaint), I 
now cannot get it to not work even without the revert.

And I've re-done all the STR testing, and that isn't the cause of it.

Oh well.

I don't actually tend to _use_ that laptop, it gets dug out for release 
and distro testing and for some very occasional travel.  I've not had 
issues with wireless on that thing before (apart from any normal iwl 
issues), but maybe it just happened to take a really really long time to 
associate that one time.

				Linus
