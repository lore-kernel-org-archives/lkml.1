Return-Path: <linux-kernel-owner+w=401wt.eu-S1754784AbZBFE6w@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754784AbZBFE6w (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Feb 2009 23:58:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752115AbZBFE6o
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Feb 2009 23:58:44 -0500
Received: from tomts25-srv.bellnexxia.net ([209.226.175.188]:33795 "EHLO
	tomts25-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751259AbZBFE6n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Feb 2009 23:58:43 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AsIEAOtRi0lMQWt2/2dsb2JhbACBbsx7hBYG
Date: Thu, 5 Feb 2009 23:58:41 -0500
From: Mathieu Desnoyers <compudj@krystal.dyndns.org>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       ltt-dev@lists.casi.polymtl.ca, linux-kernel@vger.kernel.org
Cc: Robert Wisniewski <bob@watson.ibm.com>
Subject: [RFC git tree] Userspace RCU (urcu) for Linux (repost)
Message-ID: <20090206045841.GA12995@Krystal>
References: <20090206030543.GB8560@Krystal>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <20090206030543.GB8560@Krystal>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 23:56:23 up 36 days,  4:54,  5 users,  load average: 0.62, 0.41,
	0.27
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(sorry for repost, I got the ltt-dev email wrong in the previous one)

Hi Paul,

I figured out I needed some userspace RCU for the userspace tracing part
of LTTng (for quick read access to the control variables) to trace
userspace pthread applications. So I've done a quick-and-dirty userspace
RCU implementation.

It works so far, but I have not gone through any formal verification
phase. It seems to work on paper, and the tests are also OK (so far),
but I offer no guarantee for this 300-lines-ish 1-day hack. :-) If you
want to comment on it, it would be welcome. It's a userland-only
library. It's also currently x86-only, but only a few basic definitions
must be adapted in urcu.h to port it.

Here is the link to my git tree :

git://lttng.org/userspace-rcu.git

http://lttng.org/cgi-bin/gitweb.cgi?p=userspace-rcu.git;a=summary

Thanks,

Mathieu

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
