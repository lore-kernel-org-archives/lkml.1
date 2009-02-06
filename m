Return-Path: <linux-kernel-owner+w=401wt.eu-S1755026AbZBFNGw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755026AbZBFNGw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Feb 2009 08:06:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752528AbZBFNGn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Feb 2009 08:06:43 -0500
Received: from e9.ny.us.ibm.com ([32.97.182.139]:48005 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752089AbZBFNGm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Feb 2009 08:06:42 -0500
Date: Fri, 6 Feb 2009 05:06:40 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Mathieu Desnoyers <compudj@krystal.dyndns.org>
Cc: ltt-dev@lists.casi.polymtl.ca, linux-kernel@vger.kernel.org,
       Robert Wisniewski <bob@watson.ibm.com>
Subject: Re: [RFC git tree] Userspace RCU (urcu) for Linux (repost)
Message-ID: <20090206130640.GB10918@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20090206030543.GB8560@Krystal> <20090206045841.GA12995@Krystal>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090206045841.GA12995@Krystal>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 05, 2009 at 11:58:41PM -0500, Mathieu Desnoyers wrote:
> (sorry for repost, I got the ltt-dev email wrong in the previous one)
> 
> Hi Paul,
> 
> I figured out I needed some userspace RCU for the userspace tracing part
> of LTTng (for quick read access to the control variables) to trace
> userspace pthread applications. So I've done a quick-and-dirty userspace
> RCU implementation.
> 
> It works so far, but I have not gone through any formal verification
> phase. It seems to work on paper, and the tests are also OK (so far),
> but I offer no guarantee for this 300-lines-ish 1-day hack. :-) If you
> want to comment on it, it would be welcome. It's a userland-only
> library. It's also currently x86-only, but only a few basic definitions
> must be adapted in urcu.h to port it.
> 
> Here is the link to my git tree :
> 
> git://lttng.org/userspace-rcu.git
> 
> http://lttng.org/cgi-bin/gitweb.cgi?p=userspace-rcu.git;a=summary

Very cool!!!  I will take a look!

I will also point you at a few that I have put together:

git://git.kernel.org/pub/scm/linux/kernel/git/paulmck/perfbook.git

(In the CodeSamples/defer directory.)

							Thanx, Paul
