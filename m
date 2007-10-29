Return-Path: <linux-kernel-owner+w=401wt.eu-S1754163AbXJ2WtP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754163AbXJ2WtP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2007 18:49:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751948AbXJ2WtB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Oct 2007 18:49:01 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:38555 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751640AbXJ2WtA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2007 18:49:00 -0400
Date: Mon, 29 Oct 2007 15:48:54 -0700
From: Paul Jackson <pj@sgi.com>
To: Andi Kleen <ak@suse.de>
Cc: Lee.Schermerhorn@hp.com, rientjes@google.com, clameter@sgi.com,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [patch 2/2] cpusets: add interleave_over_allowed option
Message-Id: <20071029154854.81fd606d.pj@sgi.com>
In-Reply-To: <200710292208.30033.ak@suse.de>
References: <alpine.DEB.0.9999.0710251540210.11929@chino.kir.corp.google.com>
	<1193674988.5035.93.camel@localhost>
	<20071029123558.fb077ca9.pj@sgi.com>
	<200710292208.30033.ak@suse.de>
Organization: SGI
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.3; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> So the user space asks for 8 nodes because it knows the machine
> has that many from /sys and it only gets 4 if a cpuset says so? That's
> just bad semantics. And is not likely to make the user programs happy.

That's no different than what can happen today -- if a task actually
is in an 8 node cpuset, sets up its mempolicies accordingly, and then
gets shoe horned into a 4 node cpuset.

It's not good or bad; it's just interactions between two mechanisms.

If your app doesn't run well in a small cpuset, don't run it there
(or do run it there, poorly ;).

-- 
                  I won't rest till it's the best ...
                  Programmer, Linux Scalability
                  Paul Jackson <pj@sgi.com> 1.925.600.0401
