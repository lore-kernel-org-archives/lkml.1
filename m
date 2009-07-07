Return-Path: <linux-kernel-owner+w=401wt.eu-S1758913AbZGGQbK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758913AbZGGQbK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jul 2009 12:31:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757940AbZGGQa5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Jul 2009 12:30:57 -0400
Received: from e2.ny.us.ibm.com ([32.97.182.142]:55118 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755973AbZGGQa4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jul 2009 12:30:56 -0400
Date: Tue, 7 Jul 2009 09:30:53 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Jaswinder Singh Rajput <jaswinder@kernel.org>
Cc: trivial <trivial@kernel.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 16/22] trivial: fix typo "that that" in multiple files
Message-ID: <20090707163053.GD6692@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <1246975428.3613.10.camel@ht.satnam> <1246976551.3613.33.camel@ht.satnam>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1246976551.3613.33.camel@ht.satnam>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 07, 2009 at 07:52:31PM +0530, Jaswinder Singh Rajput wrote:
> 
> Replaced "that that" with "that" in multiple files
> 
> Signed-off-by: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
> ---
>  Documentation/RCU/rcu.txt                |    2 +-
>  Documentation/block/as-iosched.txt       |    2 +-
>  Documentation/kernel-parameters.txt      |    2 +-
>  Documentation/memory-barriers.txt        |    2 +-
>  Documentation/networking/ipvs-sysctl.txt |    2 +-
>  Documentation/trace/ftrace.txt           |    2 +-
>  arch/ia64/hp/sim/simeth.c                |    2 +-
>  arch/m68k/kernel/head.S                  |    4 ++--
>  arch/powerpc/kernel/ftrace.c             |    4 ++--
>  arch/s390/lib/delay.c                    |    2 +-
>  block/cfq-iosched.c                      |    2 +-
>  crypto/twofish_common.c                  |    2 +-
>  drivers/char/rio/riointr.c               |    2 +-
>  drivers/input/serio/hp_sdc.c             |    2 +-
>  drivers/net/bonding/bond_alb.c           |    2 +-
>  drivers/s390/char/tape_34xx.c            |    2 +-
>  drivers/usb/wusbcore/wa-xfer.c           |    2 +-
>  fs/configfs/dir.c                        |    2 +-
>  fs/direct-io.c                           |    2 +-
>  fs/jbd/checkpoint.c                      |    2 +-
>  fs/jbd2/checkpoint.c                     |    2 +-
>  fs/ntfs/layout.h                         |    2 +-
>  fs/xfs/xfs_trans.c                       |    2 +-
>  include/linux/ieee80211.h                |    2 +-
>  24 files changed, 26 insertions(+), 26 deletions(-)
> 
> diff --git a/Documentation/RCU/rcu.txt b/Documentation/RCU/rcu.txt
> index 7aa2002..1f3f992 100644
> --- a/Documentation/RCU/rcu.txt
> +++ b/Documentation/RCU/rcu.txt
> @@ -30,7 +30,7 @@ o	How can the updater tell when a grace period has completed
>  	Just as with spinlocks, RCU readers are not permitted to
>  	block, switch to user-mode execution, or enter the idle loop.
>  	Therefore, as soon as a CPU is seen passing through any of these
> -	three states, we know that that CPU has exited any previous RCU
> +	three states, we know that CPU has exited any previous RCU
>  	read-side critical sections.  So, if we remove an item from a
>  	linked list, and then wait until all CPUs have switched context,
>  	executed in user mode, or executed in the idle loop, we can

As David Howells noted, this is not correct.  To fix the admittedly
awkward phrasing, how about the following?

	Just as with spinlocks, RCU readers are not permitted to block,
	switch to user-mode execution, or enter the idle loop.	Therefore,
	as soon as a given CPU is seen passing through any of these
	three states, we know that this CPU has exited any previous RCU
	read-side critical sections.  So, if we remove an item from a
	linked list, and then wait until all CPUs have switched context,
	executed in user mode, or executed in the idle loop, we can

							Thanx, Paul
