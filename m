Return-Path: <linux-kernel-owner+w=401wt.eu-S1765035AbXG2Q0w@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765035AbXG2Q0w (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jul 2007 12:26:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763596AbXG2Q0n
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Jul 2007 12:26:43 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:48480 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762701AbXG2Q0m (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jul 2007 12:26:42 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Adrian Bunk <bunk@stusta.de>
Subject: Re: [2.6 patch] make kernel/power/main.c:suspend_enter() static
Date: Sun, 29 Jul 2007 18:35:19 +0200
User-Agent: KMail/1.9.5
Cc: pavel@suse.cz, linux-pm@lists.linux-foundation.org,
       linux-kernel@vger.kernel.org
References: <20070729145742.GP16817@stusta.de>
In-Reply-To: <20070729145742.GP16817@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200707291835.20105.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday, 29 July 2007 16:57, Adrian Bunk wrote:
> suspend_enter() can now become static.
> 
> Signed-off-by: Adrian Bunk <bunk@stusta.de>
> 
> ---

Acked-by: Rafael J. Wysocki <rjw@sisk.pl>

>  kernel/power/main.c  |    2 +-
>  kernel/power/power.h |    1 -
>  2 files changed, 1 insertion(+), 2 deletions(-)
> 
> --- linux-2.6.23-rc1-mm1/kernel/power/power.h.old	2007-07-26 14:49:29.000000000 +0200
> +++ linux-2.6.23-rc1-mm1/kernel/power/power.h	2007-07-26 14:49:36.000000000 +0200
> @@ -177,7 +177,6 @@
>  				unsigned int, char *);
>  
>  /* kernel/power/main.c */
> -extern int suspend_enter(suspend_state_t state);
>  extern int suspend_devices_and_enter(suspend_state_t state);
>  extern struct blocking_notifier_head pm_chain_head;
>  
> --- linux-2.6.23-rc1-mm1/kernel/power/main.c.old	2007-07-26 14:49:44.000000000 +0200
> +++ linux-2.6.23-rc1-mm1/kernel/power/main.c	2007-07-26 14:50:05.000000000 +0200
> @@ -120,7 +120,7 @@
>   *
>   *	This function should be called after devices have been suspended.
>   */
> -int suspend_enter(suspend_state_t state)
> +static int suspend_enter(suspend_state_t state)
>  {
>  	int error = 0;
>  
> 
> 
> 

-- 
"Premature optimization is the root of all evil." - Donald Knuth
