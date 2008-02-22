Return-Path: <linux-kernel-owner+w=401wt.eu-S1763346AbYBVGA5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763346AbYBVGA5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Feb 2008 01:00:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752499AbYBVGAt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Feb 2008 01:00:49 -0500
Received: from pythia.bakeyournoodle.com ([203.82.209.197]:52822 "EHLO
	pythia.bakeyournoodle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752339AbYBVGAs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Feb 2008 01:00:48 -0500
Date: Fri, 22 Feb 2008 16:58:02 +1100
To: Ingo Molnar <mingo@elte.hu>
Cc: Rusty Russell <rusty@rustcorp.com.au>, linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>, lguest@ozlabs.org
Subject: Re: [PATCH] Fix building lguest as module.
Message-ID: <20080222055802.GQ6887@bakeyournoodle.com>
References: <20080201124520.GA29900@elte.hu> <20080201170551.GA3825@elte.hu> <200802040711.11280.rusty@rustcorp.com.au> <20080219034404.GT6887@bakeyournoodle.com> <20080219073205.GA12375@elte.hu> <20080219135401.GA9192@elte.hu> <20080219233520.GB6887@bakeyournoodle.com> <20080220100139.GB3881@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20080220100139.GB3881@elte.hu>
User-Agent: Mutt/1.5.13 (2006-08-11)
From: tony@bakeyournoodle.com (Tony Breeds)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 20, 2008 at 11:01:40AM +0100, Ingo Molnar wrote:
> 
> * Tony Breeds <tony@bakeyournoodle.com> wrote:
> 
> > I've attached the .config FWIW
> 
> indeed you are right...
> 
> I fixed this build failure too - could you check whether x86.git#test 
> (which has all these lguest build fixes) works fine for you:
> 
>    http://people.redhat.com/mingo/x86.git/README
> 
> ? Thanks,

Sure that works.  I'm not conviniced that your patch is right as it
treats gust and host support as the same thing.  Having said that we're
only talkign about a few constants, so I don't think it's worth anymore
time.  If it's not right it can be fixed later by those that know
better.

Yours Tony

  linux.conf.au    http://www.marchsouth.org/
  Jan 19 - 24 2009 The Australian Linux Technical Conference!

