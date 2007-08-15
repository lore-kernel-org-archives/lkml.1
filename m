Return-Path: <linux-kernel-owner+w=401wt.eu-S1758993AbXHOLQS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758993AbXHOLQS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2007 07:16:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753179AbXHOLQB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Aug 2007 07:16:01 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:47335 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752677AbXHOLQA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2007 07:16:00 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Adrian Bunk <bunk@kernel.org>
Subject: Re: [2.6 patch] make kernel/power/main.c:suspend_enter() static
Date: Wed, 15 Aug 2007 13:25:34 +0200
User-Agent: KMail/1.9.5
Cc: Andrew Morton <akpm@linux-foundation.org>, pavel@suse.cz,
       linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org
References: <20070814212626.GB18945@stusta.de>
In-Reply-To: <20070814212626.GB18945@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200708151325.35648.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, 14 August 2007 23:26, Adrian Bunk wrote:
> suspend_enter() can now become static.
> 
> Signed-off-by: Adrian Bunk <bunk@kernel.org>

Acked-by: Rafael J. Wysocki <rjw@sisk.pl>

> ---
> 
> This patch has been sent on:
> - 29 Jul 2007
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
