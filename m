Return-Path: <linux-kernel-owner+w=401wt.eu-S1760895AbYBFWUw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760895AbYBFWUw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2008 17:20:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760084AbYBFWUh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Feb 2008 17:20:37 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:60581 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760113AbYBFWUg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2008 17:20:36 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [Regression] 2.6.24-git9: RT sched mishandles artswrapper (bisected)
Date: Wed, 6 Feb 2008 23:18:27 +0100
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: Dmitry Adamushko <dmitry.adamushko@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Steven Rostedt <rostedt@goodmis.org>
References: <200802010237.59320.rjw@sisk.pl> <200802062250.07758.rjw@sisk.pl> <1202335261.6274.11.camel@lappy>
In-Reply-To: <1202335261.6274.11.camel@lappy>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200802062318.28172.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, 6 of February 2008, Peter Zijlstra wrote:
> 
> On Wed, 2008-02-06 at 22:50 +0100, Rafael J. Wysocki wrote:
> > On Wednesday, 6 of February 2008, Peter Zijlstra wrote:
> 
> > > Well, that whole queue.
> > 
> > It doesn't compile for me.
> 
> I did solve some compile issues since posting, Ingo should have the
> compiling version in sched-devel soonish (don't know if he pushed it
> already).

Can you point me to the cleaned up version, please?

> > > Your test program just failed to obtain realtime scheduling
> > 
> > Well, it shouldn't.  The expected result is to obtain realtime scheduling
> > or we will break existing setups.
> 
> Thats a case of wrong expectations in my book. You enabled group
> scheduling and hence behaviour changes.

So, I'd have to unset FAIR_GROUP_SCHED to obtain the previous behavior?

> There is just nothing much one can do about it, if you don't assign bandwidth
> to a group, it won't be able to run anything. Better to refuse to run, than to sit
> idle, right? 

As a general rule, probably yes.

> But I appreciate the situation, therefore I made the whole rt-group
> scheduling a separate .config option (which defaults to n)

Which is introduced by the new patches, isn't it?
