Return-Path: <linux-kernel-owner+w=401wt.eu-S933456AbXFEWFE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933456AbXFEWFE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jun 2007 18:05:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765783AbXFEWEv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Jun 2007 18:04:51 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:45869 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1764122AbXFEWEu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jun 2007 18:04:50 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Adrian Bunk <bunk@stusta.de>
Subject: Re: [-mm patch] kernel/power/disk.c: make code static
Date: Wed, 6 Jun 2007 00:10:44 +0200
User-Agent: KMail/1.9.5
Cc: Andrew Morton <akpm@linux-foundation.org>, pavel@suse.cz,
       linux-kernel@vger.kernel.org, linux-pm@lists.linux-foundation.org
References: <20070530235823.793f00d9.akpm@linux-foundation.org> <20070605215049.GI5500@stusta.de>
In-Reply-To: <20070605215049.GI5500@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200706060010.45107.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, 5 June 2007 23:50, Adrian Bunk wrote:
> On Wed, May 30, 2007 at 11:58:23PM -0700, Andrew Morton wrote:
> >...
> > Changes since 2.6.22-rc2-mm1:
> >...
> > +swsusp-remove-code-duplication-between-diskc-and-userc.patch
> >...
> >  freezer/swsusp updates
> >...
> 
> This patch makes needlessly global code static.
> 
> Signed-off-by: Adrian Bunk <bunk@stusta.de>

ACK

Rafael


> ---
> 
>  kernel/power/disk.c |    4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> --- linux-2.6.22-rc3-mm1/kernel/power/disk.c.old	2007-06-05 22:12:07.000000000 +0200
> +++ linux-2.6.22-rc3-mm1/kernel/power/disk.c	2007-06-05 22:13:37.000000000 +0200
> @@ -45,7 +45,7 @@
>  
>  static int hibernation_mode = HIBERNATION_SHUTDOWN;
>  
> -struct hibernation_ops *hibernation_ops;
> +static struct hibernation_ops *hibernation_ops;
>  
>  /**
>   * hibernation_set_ops - set the global hibernate operations
> @@ -231,7 +231,7 @@
>   *	to power off or reboot.
>   */
>  
> -void power_down(void)
> +static void power_down(void)
>  {
>  	switch (hibernation_mode) {
>  	case HIBERNATION_TEST:
> 
> 
> 

-- 
"Premature optimization is the root of all evil." - Donald Knuth
