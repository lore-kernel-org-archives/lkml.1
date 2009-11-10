Return-Path: <linux-kernel-owner+w=401wt.eu-S1758223AbZKJVW3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758223AbZKJVW3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Nov 2009 16:22:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754692AbZKJVW2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Nov 2009 16:22:28 -0500
Received: from e4.ny.us.ibm.com ([32.97.182.144]:50539 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754842AbZKJVW1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Nov 2009 16:22:27 -0500
Date: Tue, 10 Nov 2009 13:22:43 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: William Allen Simpson <william.allen.simpson@gmail.com>
Cc: Linux Kernel Developers <linux-kernel@vger.kernel.org>,
       Linux Kernel Network Developers <netdev@vger.kernel.org>,
       Eric Dumazet <eric.dumazet@gmail.com>
Subject: Re: [PATCH resent] Documentation: rw_lock lessons learned
Message-ID: <20091110212243.GW8424@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <4AF9C540.5090403@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4AF9C540.5090403@gmail.com>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 10, 2009 at 02:55:44PM -0500, William Allen Simpson wrote:
> In recent weeks, two different network projects erroneously
> strayed down the rw_lock path.  Update the Documentation
> based upon comments in those threads.
>
> Signed-off-by: William.Allen.Simpson@gmail.com
> ---
>   Documentation/spinlocks.txt |   14 ++++++++++++++
>   1 files changed, 14 insertions(+), 0 deletions(-)
>

> diff --git a/Documentation/spinlocks.txt b/Documentation/spinlocks.txt
> index 619699d..c112052 100644
> --- a/Documentation/spinlocks.txt
> +++ b/Documentation/spinlocks.txt
> @@ -233,4 +233,18 @@ indeed), while write-locks need to protect themselves against interrupts.
> 
>  		Linus

As you might guess, works for me!!!

Acked-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>

> +----
> +
> +The implications of spin_locks on memory are further described in:
> +
> +  Documentation/memory-barriers.txt
> +    (5) LOCK operations.
> +    (6) UNLOCK operations.
> +
> +----
> +
> +We are working hard to remove reader-writer spinlocks (rw_lock) from the
> +network stack, so please don't add a new one.  Instead, see:
> +
> +  Documentation/RCU/rcu.txt
> 
> -- 
> 1.6.3.3
> 
> 

