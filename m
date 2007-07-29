Return-Path: <linux-kernel-owner+w=401wt.eu-S932597AbXG2Q24@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932597AbXG2Q24 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jul 2007 12:28:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764160AbXG2Q2p
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Jul 2007 12:28:45 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:48494 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763678AbXG2Q2n (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jul 2007 12:28:43 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Adrian Bunk <bunk@stusta.de>
Subject: Re: [2.6 patch] drivers/base/power/: make 2 functions static
Date: Sun, 29 Jul 2007 18:37:36 +0200
User-Agent: KMail/1.9.5
Cc: pavel@suse.cz, linux-pm@lists.linux-foundation.org,
       linux-kernel@vger.kernel.org
References: <20070729145650.GH16817@stusta.de>
In-Reply-To: <20070729145650.GH16817@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200707291837.37244.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday, 29 July 2007 16:56, Adrian Bunk wrote:
> suspend_device() and resume_device() can now become static.
> 
> Signed-off-by: Adrian Bunk <bunk@stusta.de>
> 
> ---

Acked-by: Rafael J. Wysocki <rjw@sisk.pl>
 
>  drivers/base/power/power.h   |    6 ------
>  drivers/base/power/resume.c  |    2 +-
>  drivers/base/power/suspend.c |    2 +-
>  3 files changed, 2 insertions(+), 8 deletions(-)
> 
> --- linux-2.6.23-rc1-mm1/drivers/base/power/power.h.old	2007-07-26 05:14:12.000000000 +0200
> +++ linux-2.6.23-rc1-mm1/drivers/base/power/power.h	2007-07-26 05:15:49.000000000 +0200
> @@ -55,12 +55,6 @@
>  
>  extern void dpm_resume(void);
>  extern void dpm_power_up(void);
> -extern int resume_device(struct device *);
> -
> -/*
> - * suspend.c
> - */
> -extern int suspend_device(struct device *, pm_message_t);
>  
>  #else /* CONFIG_PM */
>  
> --- linux-2.6.23-rc1-mm1/drivers/base/power/resume.c.old	2007-07-26 05:14:28.000000000 +0200
> +++ linux-2.6.23-rc1-mm1/drivers/base/power/resume.c	2007-07-26 05:14:39.000000000 +0200
> @@ -20,7 +20,7 @@
>   *
>   */
>  
> -int resume_device(struct device * dev)
> +static int resume_device(struct device * dev)
>  {
>  	int error = 0;
>  
> --- linux-2.6.23-rc1-mm1/drivers/base/power/suspend.c.old	2007-07-26 05:16:00.000000000 +0200
> +++ linux-2.6.23-rc1-mm1/drivers/base/power/suspend.c	2007-07-26 05:16:17.000000000 +0200
> @@ -54,7 +54,7 @@
>   *	@state:	Power state device is entering.
>   */
>  
> -int suspend_device(struct device * dev, pm_message_t state)
> +static int suspend_device(struct device * dev, pm_message_t state)
>  {
>  	int error = 0;
>  
> 
> 
> 

-- 
"Premature optimization is the root of all evil." - Donald Knuth
