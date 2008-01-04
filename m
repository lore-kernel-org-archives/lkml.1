Return-Path: <linux-kernel-owner+w=401wt.eu-S1754112AbYADRvk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754112AbYADRvk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jan 2008 12:51:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752593AbYADRvc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Jan 2008 12:51:32 -0500
Received: from pasmtpb.tele.dk ([80.160.77.98]:58374 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752327AbYADRvb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jan 2008 12:51:31 -0500
Date: Fri, 4 Jan 2008 18:51:28 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Andi Kleen <ak@suse.de>
Cc: Ingo Molnar <mingo@elte.hu>, peterz@infradead.org,
       linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH x86] [5/16] Replace hard coded reservations in x86-64 early boot code with dynamic table II
Message-ID: <20080104175128.GB31382@uranus.ravnborg.org>
References: <20080103442.621670000@suse.de> <200801041338.08093.ak@suse.de> <20080104144140.GA4203@elte.hu> <200801041603.58358.ak@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200801041603.58358.ak@suse.de>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> 
> In a minor way -- it is far less important than let's say good high level
> comments or clear code flow. 
> 
> e.g. this patch imho is a major improvement in code clarity and logic
> and makes previously quite fragile code much simpler and more approachable
> and easier changeable (I can say this because I was responsible for the 
> original mess -- only excuse is that it has grown over time). And then when 
> people don't see these advantages and just talk about tabs<->spaces that is 
> quite annoying.

It is great to have all the obvious style issues fixed no matter how much
the code clarity and logic is improved. For the simple reason that with
obvious coding style issues fixed you do not get distracted.

And I do not understand why people has any problem with that when we talk
about patches.

What is then considered "obvious style issues" are today implemented
as errors / warnings in checkpatch for the most part. Not everyone
agrees with what checkpatch says are errors/warnings but this is at
least an more or less unambigious way to express these obvious cases.
And this is far better than the maintainers choice of the day style.
 
> Same for tabs versus spaces. That is something no human should
> need to care about. And it is something a machine can handle fine too 
> anyways.
Things turn red in my vi if no-one cares - and I have no magic tool
to fix it here.
No-one should submit patches with white-space errors - thank you.

	Sam
