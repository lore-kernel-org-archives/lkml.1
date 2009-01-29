Return-Path: <linux-kernel-owner+w=401wt.eu-S1754990AbZA2Wyr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754990AbZA2Wyr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2009 17:54:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757523AbZA2Wy0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Jan 2009 17:54:26 -0500
Received: from dallas.jonmasters.org ([72.29.103.172]:60299 "EHLO
	dallas.jonmasters.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756524AbZA2WyZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2009 17:54:25 -0500
Subject: Re: Creating the RT git tree
From: Jon Masters <jonathan@jonmasters.org>
To: john stultz <johnstul@us.ibm.com>
Cc: Steven Rostedt <rostedt@goodmis.org>,
       linux-rt-users <linux-rt-users@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <peterz@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
       Clark Williams <clark.williams@gmail.com>,
       Gregory Haskins <ghaskins@novell.com>
In-Reply-To: <1233267328.3937.66.camel@perihelion.bos.jonmasters.org>
References: <alpine.DEB.1.10.0812161556460.25356@gandalf.stny.rr.com>
	 <1233263200.3937.44.camel@perihelion.bos.jonmasters.org>
	 <1f1b08da0901291407q7aeaa13es730bad17abda9b66@mail.gmail.com>
	 <1233267328.3937.66.camel@perihelion.bos.jonmasters.org>
Content-Type: text/plain
Organization: World Organi[sz]ation of Broken Dreams
Date: Thu, 29 Jan 2009 17:54:12 -0500
Message-Id: <1233269652.3937.74.camel@perihelion.bos.jonmasters.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 (2.22.3.1-1.fc9) 
Content-Transfer-Encoding: 7bit
X-SA-Do-Not-Run: Yes
X-SA-Exim-Connect-IP: 74.92.29.237
X-SA-Exim-Mail-From: jonathan@jonmasters.org
X-SA-Exim-Scanned: No (on dallas.jonmasters.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-01-29 at 17:15 -0500, Jon Masters wrote:
> On Thu, 2009-01-29 at 14:07 -0800, john stultz wrote:
> 
> > git log -r origin/linus..origin/rt/threadirqs
> 
> Ok. So perhaps it's the branch creation during:
> 
> git checkout -b threadirqs origin/rt/threadirqs
> 
> Because yeah, that does show what I want. This is weird. Is there some
> git expert who can tell me why I'm seeing linus merges in my local
> branch? My local branch should be simply the same as the remote one...

Bah. I think I was just fat-fingering something. Ok, so it does actually
work if I do this:

git log master...threadirqs

or replace master with $whatever. Ok, that's really what I wanted. It
would be nice if a branch could be setup without all the merge history
builtin - that's supposed to be in the rt-master and so forth
branches...but whatever.

Jon.


