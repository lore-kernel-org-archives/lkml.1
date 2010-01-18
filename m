Return-Path: <linux-kernel-owner+w=401wt.eu-S1754881Ab0ARXgO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754881Ab0ARXgO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jan 2010 18:36:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754328Ab0ARXgO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Jan 2010 18:36:14 -0500
Received: from relay2-v.mail.gandi.net ([217.70.178.76]:42002 "EHLO
	relay2-v.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754238Ab0ARXgN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jan 2010 18:36:13 -0500
Date: Mon, 18 Jan 2010 15:36:04 -0800
From: Josh Triplett <josh@joshtriplett.org>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, laijs@cn.fujitsu.com,
       dipankar@in.ibm.com, akpm@linux-foundation.org,
       mathieu.desnoyers@polymtl.ca, dvhltc@us.ibm.com, niv@us.ibm.com,
       tglx@linutronix.de, peterz@infradead.org, rostedt@goodmis.org,
       Valdis.Kletnieks@vt.edu, dhowells@redhat.com
Subject: Re: [PATCH tip/core/rcu 8/9] idr: apply lockdep-based diagnostics
 to rcu_dereference() uses
Message-ID: <20100118233604.GE29076@feather>
References: <20100115010157.GA28221@linux.vnet.ibm.com>
 <12635173672978-git-send-email->
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <12635173672978-git-send-email->
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 14, 2010 at 05:02:45PM -0800, Paul E. McKenney wrote:
> From: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> 
> Because idr can be used with any of a number of locks or with any
> flavor of RCU, just disable the lockdep-based diagnostics.  If idr
> needs diagnostics, the check expression will need to be passed into
> the relevant idr primitives as an additional argument.
> 
> Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>

The subject line of this patch seems wrong.  Like the preceding patches
for radix tree and list operations, this *disables* the checking by
using _raw.

- Josh Triplett
