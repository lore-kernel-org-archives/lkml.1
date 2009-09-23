Return-Path: <linux-kernel-owner+w=401wt.eu-S1752309AbZIWOnQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752309AbZIWOnQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Sep 2009 10:43:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752112AbZIWOnQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Sep 2009 10:43:16 -0400
Received: from fifo99.com ([67.223.236.141]:59088 "EHLO fifo99.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751596AbZIWOnP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Sep 2009 10:43:15 -0400
Subject: Re: checkpatch as a tool (was Re: [RFC][PATCH] SCHED_EDF
 scheduling class)
From: Daniel Walker <dwalker@fifo99.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Joe Perches <joe@perches.com>, Peter Zijlstra <peterz@infradead.org>,
       linux-kernel@vger.kernel.org, Steven Rostedt <rostedt@goodmis.org>,
       Jonathan Corbet <corbet@lwn.net>
In-Reply-To: <20090923122256.GA6390@elte.hu>
References: <1253615424.20345.76.camel@Palantir>
	 <1253625878.6575.34.camel@desktop> <1253628061.20345.173.camel@Palantir>
	 <1253637721.18939.3.camel@laptop> <20090922191117.GB24542@elte.hu>
	 <1253667103.25689.35.camel@desktop>
	 <1253667708.30020.134.camel@Joe-Laptop.home>
	 <20090923122256.GA6390@elte.hu>
Content-Type: text/plain
Date: Wed, 23 Sep 2009 07:43:10 -0700
Message-Id: <1253716990.20648.31.camel@desktop>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-09-23 at 14:22 +0200, Ingo Molnar wrote:
> He should consider not sending them at all. It's up to maintainers and 
> the developers involved with that code whether the small details that 
> checkpatch flags are important or not at a given point in the patch 
> cycle.
> 
> For example i use checkpatch all the time and i think it's a fantastic 
> tool, still i dont want another nuisance layer on lkml interfering with 
> the patch flow.
> 
> If a patch gets so far in the patch cycle that i'm thinking about 
> merging it, i might fix the checkpatch failures myself (often they are 
> trivial), and i might warn frequent contributors about repeat patterns 
> of small uncleanlinesses - or i might bounce the patch back to the 
> contributor. I also ignore certain classes of checkpatch warnings.
> 
> What Daniel is doing is basically a semi-mandatory checkpatch layer on 
> lkml and that's both a distraction and harmful as well. We dont need a 
> "checkpatch police" on lkml. We want an open, reasonable, human driven 
> patch process with very little buerocracy and no buerocrats.

I think short term you might be right, that it is a nuisance to deal
with these issues.. However, these are real code comments which is what
this list is designed for.. Long term I don't think I will be sending
many of these emails at all, in fact I've only been doing this 3 weeks
and I can already see a drop off in the number of errors that I'm
finding.. It's like advertising, as soon as people start seeing a lot of
checkpatch related emails, they start to remember to use the tool.

Not to mention that automated code review (in mass) is useful .. Our
eyes can miss things, and having a massively used tool that checks for
all the common problems that we encounter is a good thing.. For
instance, checkpatch already found a locked semaphore, and a mutex type
semaphore in the "Target_Core_Mod ConfigFS infrastructure", which I'm
sure no one would want to enter the kernel, but had been missed. It also
found one real code defect, 

http://lkml.indiana.edu/hypermail/linux/kernel/0909.1/00129.html

The more we use the tool the better the tool becomes, and the more real
problems can be caught prior to code inclusion ..

I could have a higher threshold for when these errors become note
worthy, and I've been struggling with that since I started doing this..
I don't think not commenting at all would be a good thing..

Daniel

