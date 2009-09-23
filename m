Return-Path: <linux-kernel-owner+w=401wt.eu-S1753313AbZIWTKz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753313AbZIWTKz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Sep 2009 15:10:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752788AbZIWTKz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Sep 2009 15:10:55 -0400
Received: from relay1-v.mail.gandi.net ([217.70.178.75]:54543 "EHLO
	relay1-v.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752707AbZIWTKy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Sep 2009 15:10:54 -0400
Date: Wed, 23 Sep 2009 12:10:26 -0700
From: Josh Triplett <josh@joshtriplett.org>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, laijs@cn.fujitsu.com,
       dipankar@in.ibm.com, akpm@linux-foundation.org,
       mathieu.desnoyers@polymtl.ca, dvhltc@us.ibm.com, niv@us.ibm.com,
       tglx@linutronix.de, peterz@infradead.org, rostedt@goodmis.org,
       Valdis.Kletnieks@vt.edu, dhowells@redhat.com
Subject: Re: [PATCH tip/core/rcu 0/4] Josh and Ingo review feedback and
 Bloatwatch RCU
Message-ID: <20090923191025.GE6763@feather>
References: <20090923165012.GA13801@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090923165012.GA13801@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 23, 2009 at 09:50:12AM -0700, Paul E. McKenney wrote:
> This patch set applies two sets of review feedback from Josh Triplett
> and checkpatch feedback from Ingo Molnar.  It also contains a forward-port
> of Bloatwatch RCU, courtesy of David Howells.
> 
> This series is a respin of http://lkml.org/lkml/2009/9/22/554, including
> improved changelogs and Peter Zijlstra's Acked-by for the first two
> patches in the series.
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

That'll teach me to read my inbox in order. :)

For the newer series, again:
Acked-by: Josh Triplett <josh@joshtriplett.org>
