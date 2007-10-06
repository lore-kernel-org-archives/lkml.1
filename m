Return-Path: <linux-kernel-owner+w=401wt.eu-S1763485AbXJFG3G@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763485AbXJFG3G (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Oct 2007 02:29:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751940AbXJFG2z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 6 Oct 2007 02:28:55 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:36596 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751656AbXJFG2y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Oct 2007 02:28:54 -0400
Date: Fri, 5 Oct 2007 23:28:49 -0700
From: Paul Jackson <pj@sgi.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: akpm@linux-foundation.org, nickpiggin@yahoo.com.au,
       randy.dunlap@oracle.com, menage@google.com,
       linux-kernel@vger.kernel.org, dino@in.ibm.com, cpw@sgi.com
Subject: Re: [PATCH] cpuset and sched domains: sched_load_balance flag fixes
Message-Id: <20071005232849.5eede577.pj@sgi.com>
In-Reply-To: <20071006062156.GA28237@elte.hu>
References: <20071003114401.32194.73464.sendpatchset@jackhammer.engr.sgi.com>
	<20071005161305.af27f452.akpm@linux-foundation.org>
	<20071005163918.46d40fed.pj@sgi.com>
	<20071006055324.GC23397@elte.hu>
	<20071005230141.63a1f6c3.pj@sgi.com>
	<20071006062156.GA28237@elte.hu>
Organization: SGI
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.3; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> i'd suggest we go with what we have now

Ok - I'll try sending this against 2.6.23-rc8-mm2
in a couple of hours, if it goes well.

> We cannot merge it via sched.git because it has some containers 
> (or other?) dependencies, right?

This sched_load_balance flag patch collides with the cgroup
(aka container) patches if I'm not careful, yes.

-- 
                  I won't rest till it's the best ...
                  Programmer, Linux Scalability
                  Paul Jackson <pj@sgi.com> 1.925.600.0401
