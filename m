Return-Path: <linux-kernel-owner+w=401wt.eu-S1422795AbXCBDVp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422795AbXCBDVp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Mar 2007 22:21:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422798AbXCBDVp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Mar 2007 22:21:45 -0500
Received: from e35.co.us.ibm.com ([32.97.110.153]:50346 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422795AbXCBDVo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Mar 2007 22:21:44 -0500
Date: Thu, 1 Mar 2007 19:21:35 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Josh Triplett <josh@freedesktop.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] rcutorture: Mark rcu_torture_init as __init
Message-ID: <20070302032135.GA32602@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <45E7297F.4030901@freedesktop.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <45E7297F.4030901@freedesktop.org>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 01, 2007 at 11:29:03AM -0800, Josh Triplett wrote:

Acked-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> Signed-off-by: Josh Triplett <josh@freedesktop.org>
> ---
> The corresponding rcu_torture_cleanup cannot get marked as __exit, because
> rcu_torture_init uses it to clean up if init fails.
> 
>  kernel/rcutorture.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/kernel/rcutorture.c b/kernel/rcutorture.c
> index 7258bcb..df49eca 100644
> --- a/kernel/rcutorture.c
> +++ b/kernel/rcutorture.c
> @@ -866,7 +866,7 @@ rcu_torture_cleanup(void)
>  		rcu_torture_print_module_parms("End of test: SUCCESS");
>  }
>  
> -static int
> +static int __init
>  rcu_torture_init(void)
>  {
>  	int i;
> 


