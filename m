Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932306Ab0CDUGc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Mar 2010 15:06:32 -0500
Received: from mail.openrapids.net ([64.15.138.104]:58269 "EHLO
	blackscsi.openrapids.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S932245Ab0CDUGa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Mar 2010 15:06:30 -0500
Date: Thu, 4 Mar 2010 15:06:27 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: ltt-dev@lists.casi.polymtl.ca, linux-kernel@vger.kernel.org,
       rp@svcs.cs.pdx.edu
Cc: pierre-marc.fournier@polymtl.ca, Paolo Bonzini <pbonzini@redhat.com>,
       Jon Bernard <jbernard@debian.org>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: =?iso-8859-1?Q?=5BRELEASE=5D=A0Userspac?=
	=?iso-8859-1?Q?e?= RCU 0.4.2
Message-ID: <20100304200627.GA24725@Krystal>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Editor: vi
X-Info: http://www.efficios.com
X-Operating-System: Linux/2.6.26-2-686 (i686)
X-Uptime: 15:00:10 up 40 days, 22:37,  5 users,  load average: 0.16, 0.59,
	0.66
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

I just released liburcu 0.4.2. It includes patches from Paolo Bonzini which adds
generic uatomic ops support for architectures not explicitely supported by
liburcu. So, basically, we get ia64 and alpha support for free when the compiler
used is gcc 4.0-4.5. It comes with a huge cleanup and refactoring, removing
duplicated code.

There is also a small bugfix in urcu-bp, the User-Space Tracing (UST) version of
the library (this flavor does not require explicit reader thread
registration/unregistration). There was a garbage collection bug that did not
set the old per-thread counter to 0, which could cause an assertion to trigger
if the entry was re-used by a newly spawned thread.

Thanks,

Mathieu

-- 
Mathieu Desnoyers
Operating System Efficiency Consultant
EfficiOS Inc.
http://www.efficios.com
