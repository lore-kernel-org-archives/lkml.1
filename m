Return-Path: <linux-kernel-owner+w=401wt.eu-S1753162AbZGXPWi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753162AbZGXPWi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Jul 2009 11:22:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752497AbZGXPWh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Jul 2009 11:22:37 -0400
Received: from tomts10-srv.bellnexxia.net ([209.226.175.54]:51297 "EHLO
	tomts10-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752349AbZGXPWh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Jul 2009 11:22:37 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApIFAItpaUpMQWXi/2dsb2JhbACBUdMWhA0F
Date: Fri, 24 Jul 2009 11:22:32 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, laijs@cn.fujitsu.com,
       dipankar@in.ibm.com, akpm@linux-foundation.org,
       josht@linux.vnet.ibm.com, dvhltc@us.ibm.com, niv@us.ibm.com,
       tglx@linutronix.de, peterz@infradead.org, rostedt@goodmis.org
Subject: Re: [PATCH RFC -tip 2/4] Renamings to increase RCU clarity
Message-ID: <20090724152232.GB2419@Krystal>
References: <20090724001429.GA17374@linux.vnet.ibm.com> <20090724002008.GB18282@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <20090724002008.GB18282@linux.vnet.ibm.com>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 11:21:34 up 146 days, 11:47,  3 users,  load average: 0.78, 0.45,
	0.40
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Paul E. McKenney (paulmck@linux.vnet.ibm.com) wrote:
> Make RCU-sched, RCU-bh, and RCU-preempt be underlying implementations,
> with "RCU" defined in terms of one of the three.  Update the outdated
> rcu_qsctr_inc() names, as these functions no longer increment anything.

Sounds good, as long as RCU-sched can still be accessed directly for
tracing purpose (which seems to be the case here).

Thanks,

Mathieu

> 
> Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> ---

[...]

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
