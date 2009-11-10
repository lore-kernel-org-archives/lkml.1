Return-Path: <linux-kernel-owner+w=401wt.eu-S1758680AbZKJXUk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758680AbZKJXUk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Nov 2009 18:20:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758655AbZKJXUj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Nov 2009 18:20:39 -0500
Received: from slow3-v.mail.gandi.net ([217.70.178.89]:60606 "EHLO
	slow3-v.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758634AbZKJXUi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Nov 2009 18:20:38 -0500
Date: Tue, 10 Nov 2009 15:03:00 -0800
From: Josh Triplett <josh@joshtriplett.org>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, laijs@cn.fujitsu.com,
       dipankar@in.ibm.com, akpm@linux-foundation.org,
       mathieu.desnoyers@polymtl.ca, dvhltc@us.ibm.com, niv@us.ibm.com,
       tglx@linutronix.de, peterz@infradead.org, rostedt@goodmis.org,
       Valdis.Kletnieks@vt.edu, dhowells@redhat.com
Subject: Re: [PATCH tip/core/rcu 1/4] rcu: remove inline from
 forward-referenced functions
Message-ID: <20091110230259.GA14679@feather>
References: <20091110213651.GA21411@linux.vnet.ibm.com>
 <12578890422402-git-send-email->
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <12578890422402-git-send-email->
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 10, 2009 at 01:37:19PM -0800, Paul E. McKenney wrote:
> Some variants of gcc are reputed to dislike forward references to
> functions declared "inline".  Remove the "inline" keyword from such
> functions.
> 
> Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> ---
>  kernel/rcutree.h        |    2 +-
>  kernel/rcutree_plugin.h |    4 ++--
>  2 files changed, 3 insertions(+), 3 deletions(-)

Seems very reasonable.  For functions declared static and called once, GCC doesn't
really need any help figuring out that it should inline them.

Acked-by: Josh Triplett <josh@joshtriplett.org>
