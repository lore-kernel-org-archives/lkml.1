Return-Path: <linux-kernel-owner+w=401wt.eu-S1756650AbXIJSaY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756650AbXIJSaY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Sep 2007 14:30:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752922AbXIJSaK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Sep 2007 14:30:10 -0400
Received: from e4.ny.us.ibm.com ([32.97.182.144]:51730 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751004AbXIJSaI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Sep 2007 14:30:08 -0400
Date: Mon, 10 Sep 2007 11:30:04 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: linux-rt-users@vger.kernel.org, mingo@elte.hu, akpm@linux-foundation.org,
       dipankar@in.ibm.com, josht@linux.vnet.ibm.com, tytso@us.ibm.com,
       dvhltc@us.ibm.com, tglx@linutronix.de, a.p.zijlstra@chello.nl,
       bunk@kernel.org, ego@in.ibm.com, oleg@tv-sign.ru, srostedt@redhat.com
Subject: [PATCH RFC 0/9] RCU: Preemptible RCU
Message-ID: <20070910183004.GA3299@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Work in progress, still not for inclusion.  But code now complete!

This is a respin of the following prior posting:

http://lkml.org/lkml/2007/9/5/268

This release adds an additional patch that adds fixes to comments and RCU
documentation, along with one macro being renamed.  The rcutorture patch
has a modification to make it a bit more vicious to priority boosting
(though the current design relies on -rt latencies for much of the
priority-boost torturing effectiveness in this case -- run the test
in presence of CPU hotplug operations to get the same effect in -mm).
Next step is rebasing this to a more recent version of Linux.

						Thanx, Paul
