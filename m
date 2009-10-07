Return-Path: <linux-kernel-owner+w=401wt.eu-S933532AbZJGNSN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933532AbZJGNSN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Oct 2009 09:18:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933139AbZJGNSM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Oct 2009 09:18:12 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:37697 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933136AbZJGNSM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Oct 2009 09:18:12 -0400
Subject: Re: [PATCH tip/core/rcu 2/3] rcu: make hot-unplugged CPU
 relinquish its own RCU callbacks
From: Steven Rostedt <rostedt@goodmis.org>
Reply-To: rostedt@goodmis.org
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, laijs@cn.fujitsu.com,
       dipankar@in.ibm.com, akpm@linux-foundation.org,
       mathieu.desnoyers@polymtl.ca, josh@joshtriplett.org, dvhltc@us.ibm.com,
       niv@us.ibm.com, tglx@linutronix.de, peterz@infradead.org,
       Valdis.Kletnieks@vt.edu, dhowells@redhat.com
In-Reply-To: <1254890898456-git-send-email->
References: <20091007044748.GA12763@linux.vnet.ibm.com>
	 <1254890898456-git-send-email->
Content-Type: text/plain
Organization: Kihon Technologies Inc.
Date: Wed, 07 Oct 2009 09:16:12 -0400
Message-Id: <1254921372.1696.132.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Paul,

Still suffering jetlag? ;-)

On Tue, 2009-10-06 at 21:48 -0700, Paul E. McKenney wrote:
> From: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> 
> The current interaction between RCU and CPU hotplug requires that
> RCU block in CPU notifiers waiting for callbacks to drain.  This can
> be greatly simplified by haing each CPU relinquish its own callbacks,
                           having

> and for both _rcu_barrier() and CPU_DEAD notifiers to adopt all callbacks
> that were previously relinquished.  This change also eliminates the
> possibility of certain types of hangs due to the previous practice of
> waiting for callbacks to be invoked from within CPU notifiers.  If you
> don't every wait, you cannot hang.
        ever

;-)

> 
> Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>

-- Steve


