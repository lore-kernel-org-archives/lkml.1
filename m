Return-Path: <linux-kernel-owner+w=401wt.eu-S1761280AbYC0QyS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761280AbYC0QyS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Mar 2008 12:54:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757222AbYC0Qx7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Mar 2008 12:53:59 -0400
Received: from relay2.sgi.com ([192.48.171.30]:36008 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1760832AbYC0Qx6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Mar 2008 12:53:58 -0400
Date: Thu, 27 Mar 2008 11:53:58 -0500 (CDT)
From: Alan Mayer <ajm@sgi.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Alan Mayer <ajm@sgi.com>, torvalds@linux-foundation.org,
       linux-kernel list <linux-kernel@vger.kernel.org>,
       Robin Holt <holt@sgi.com>, Jack Steiner <steiner@sgi.com>,
       Russ Anderson <rja@sgi.com>
Subject: Re: [PATCH] x86_64: resize NR_IRQS for large machines (re-submit)
In-Reply-To: <20080327163314.GA24180@elte.hu>
Message-ID: <Pine.SGI.3.96.1080327115108.7873204e-100000@fergus.americas.sgi.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> i think you got it right, yes. But ... this is just a quick first-look 
> suggestion from me, YMMV. Maybe you find a way to do it much easier to 
> just convert everything at once. I tend to do things more gradually, in 
> my experience it's very hard and time-consuming to change the world all 
> at once - it's hard both to you the developer (you dont know whether it 
> works until you have a very substantial amount of code written - while 
> in a more gradual approach it can be converted one by one perhaps) - and 
> it's hard for users and fellow kernel hackers.
> 
> 	Ingo
> 

I think I'll take a crack at it.  Doing it in phases means I can invest
a little less time and still give everyone a chance to see if they like
it.  And, the initial stuff seems like the area where people will be the
most likely to have problems and/or suggestions.  I have no idea how
long it will take to get something out there.  Stay tuned.

		--ajm


Lately it occurs to me,
What a long, strange trip it's been.
--
Alan J. Mayer
SGI
ajm@sgi.com
WORK: 651-683-3131
HOME: 651-407-0134
--

