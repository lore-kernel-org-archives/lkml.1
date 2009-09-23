Return-Path: <linux-kernel-owner+w=401wt.eu-S1753266AbZIWTEv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753266AbZIWTEv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Sep 2009 15:04:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752322AbZIWTEt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Sep 2009 15:04:49 -0400
Received: from relay4-v.mail.gandi.net ([217.70.178.78]:40100 "EHLO
	relay4-v.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752209AbZIWTEt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Sep 2009 15:04:49 -0400
Date: Wed, 23 Sep 2009 12:04:28 -0700
From: Josh Triplett <josh@joshtriplett.org>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, laijs@cn.fujitsu.com,
       dipankar@in.ibm.com, akpm@linux-foundation.org,
       mathieu.desnoyers@polymtl.ca, dvhltc@us.ibm.com, niv@us.ibm.com,
       tglx@linutronix.de, peterz@infradead.org, rostedt@goodmis.org,
       Valdis.Kletnieks@vt.edu, dhowells@redhat.com
Subject: Re: [PATCH tip/core/rcu 0/4] Josh and Ingo review feedback and
 bloatwatch RCU
Message-ID: <20090923190427.GD6763@feather>
References: <20090922222443.GA3178@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090922222443.GA3178@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 22, 2009 at 03:24:43PM -0700, Paul E. McKenney wrote:
> This patch set applies two sets of review feedback from Josh Triplett and
> checkpatch feedback from Ingo Molnar.  It also contains a forward-port
> of Bloatwatch RCU, courtesy of David Howells.
> 
>  b/include/linux/hardirq.h  |   24 ++++
>  b/include/linux/rcupdate.h |    4 
>  b/include/linux/rcutiny.h  |  103 ++++++++++++++++++
>  b/include/linux/rcutree.h  |    1 
>  b/init/Kconfig             |    9 +
>  b/init/main.c              |    1 
>  b/kernel/Makefile          |    1 
>  b/kernel/rcupdate.c        |    3 
>  b/kernel/rcutiny.c         |  246 ++++++++++++++++++++++++++++++++++++++++++++-
>  b/kernel/rcutorture.c      |    4 
>  b/kernel/rcutree.c         |   29 +++--
>  b/kernel/rcutree.h         |    6 -
>  b/kernel/rcutree_plugin.h  |   51 ++++-----
>  b/kernel/rcutree_trace.c   |   13 +-
>  include/linux/rcupdate.h   |    6 +
>  include/linux/rcutree.h    |   12 +-
>  kernel/rcupdate.c          |    4 
>  kernel/rcutree.c           |   95 ++++++-----------
>  kernel/rcutree.h           |   57 ++++++++--
>  kernel/rcutree_plugin.h    |   24 +++-
>  20 files changed, 557 insertions(+), 136 deletions(-)

For all four patches:
Acked-by: Josh Triplett <josh@joshtriplett.org>

- Josh Triplett
