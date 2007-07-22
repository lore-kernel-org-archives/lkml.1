Return-Path: <linux-kernel-owner+w=401wt.eu-S1762856AbXGVVzq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762856AbXGVVzq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jul 2007 17:55:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752965AbXGVVzj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Jul 2007 17:55:39 -0400
Received: from dsl081-033-126.lax1.dsl.speakeasy.net ([64.81.33.126]:42158
	"EHLO bifrost.lang.hm" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755443AbXGVVzi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jul 2007 17:55:38 -0400
Date: Sun, 22 Jul 2007 14:54:09 -0700 (PDT)
From: david@lang.hm
X-X-Sender: dlang@asgard.lang.hm
To: Alan Stern <stern@rowland.harvard.edu>
cc: Miklos Szeredi <miklos@szeredi.hu>, nigel@suspend2.net, jbms@cmu.edu,
       rjw@sisk.pl, miltonm@bga.com, ying.huang@intel.com,
       linux-kernel@vger.kernel.org, linux-pm@lists.linux-foundation.org
Subject: Re: [linux-pm] Re: Hibernation considerations
In-Reply-To: <Pine.LNX.4.44L0.0707221608140.16031-100000@netrider.rowland.org>
Message-ID: <Pine.LNX.4.64.0707221451550.6350@asgard.lang.hm>
References: <Pine.LNX.4.44L0.0707221608140.16031-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 22 Jul 2007, Alan Stern wrote:

> On Sun, 22 Jul 2007, Miklos Szeredi wrote:
>
>>> The only thing to do is what Rafael has been working on: unfreeze
>>> things, hope the tasks sort themselves out, and try again.
>>
>> Have we some proof, that this will untangle the freezing tasks in a
>> limited time?  Or will it just make the problem harder to trigger?
>
> Of course there's no proof.  Just the opposite -- if things get hung up
> the first time, they might get hung up the second time.  And the
> third...
>
> But it ought to make the problem harder to trigger.  For the present
> that's a worthwhile improvement.

it gives the system more tries to find a spot in time where the deadlock 
doesn't happen, if you find one you can continue.

but even if things keep getting hung up, at least you are backing out of 
each try safely and can eventually tell the user "I give up, try shutting 
some things down and suspending again"

David Lang
