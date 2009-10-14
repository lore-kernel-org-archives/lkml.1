Return-Path: <linux-kernel-owner+w=401wt.eu-S1762087AbZJNWhh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762087AbZJNWhh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Oct 2009 18:37:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759254AbZJNWhg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Oct 2009 18:37:36 -0400
Received: from tomts36.bellnexxia.net ([209.226.175.93]:61593 "EHLO
	tomts36-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756715AbZJNWhf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Oct 2009 18:37:35 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AqYEAIvt1UpMRK1g/2dsb2JhbACBUdhfhC4E
Date: Wed, 14 Oct 2009 18:36:57 -0400
From: Mathieu Desnoyers <compudj@krystal.dyndns.org>
To: Josh Triplett <josh@joshtriplett.org>, Jon Bernard <jbernard@debian.org>,
       Jan Blunck <jblunck@suse.de>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Pierre Habouzit <madcoder@debian.org>,
       Steven Munroe <munroesj@linux.vnet.ibm.com>,
       Bert Wesarg <bert.wesarg@googlemail.com>,
       Pierre-Marc Fournier <pierre-marc.fournier@polymtl.ca>
Cc: ltt-dev@lists.casi.polymtl.ca, rp@svcs.cs.pdx.edu,
       linux-kernel@vger.kernel.org
Subject: Userspace RCU 0.2.3
Message-ID: <20091014223657.GC6458@Krystal>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.27.31-grsec (i686)
X-Uptime: 18:17:04 up 57 days,  9:06,  2 users,  load average: 0.25, 0.30,
	0.32
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I just released lib urcu 0.2.3, which is now using autotools. I also
integrated automatic architecture detection for old 386 which lack
cmpxchg (using a fall-back if necessary). I also use a lock; addl
instead of mfence on x86-32 to support a larger variety of older Intel
CPUs.

The build system detects if NR_futex is available in the system
headers. It falls back on a more portable alternative if they are not
available.

There are also new configuration modes to ./configure for UP-only
systems.

As always, the tarballs are available at http://www.lttng.org/urcu

Mathieu

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
