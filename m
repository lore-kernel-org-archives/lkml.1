Return-Path: <linux-kernel-owner+w=401wt.eu-S932621AbXG2Q3i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932621AbXG2Q3i (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jul 2007 12:29:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763928AbXG2Q33
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Jul 2007 12:29:29 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:48508 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761549AbXG2Q32 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jul 2007 12:29:28 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Adrian Bunk <bunk@stusta.de>
Subject: Re: [2.6 patch] unexport pm_power_off_prepare
Date: Sun, 29 Jul 2007 18:38:18 +0200
User-Agent: KMail/1.9.5
Cc: pavel@suse.cz, linux-pm@lists.linux-foundation.org,
       linux-kernel@vger.kernel.org
References: <20070729145935.GJ16817@stusta.de>
In-Reply-To: <20070729145935.GJ16817@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200707291838.19309.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday, 29 July 2007 16:59, Adrian Bunk wrote:
> This patch removes the unused EXPORT_SYMBOL(pm_power_off_prepare).
> 
> Signed-off-by: Adrian Bunk <bunk@stusta.de>

Acked-by: Rafael J. Wysocki <rjw@sisk.pl>

> ---
> --- linux-2.6.23-rc1-mm1/kernel/sys.c.old	2007-07-28 07:38:45.000000000 +0200
> +++ linux-2.6.23-rc1-mm1/kernel/sys.c	2007-07-28 07:38:59.000000000 +0200
> @@ -104,7 +104,6 @@ EXPORT_SYMBOL(cad_pid);
>   */
>  
>  void (*pm_power_off_prepare)(void);
> -EXPORT_SYMBOL(pm_power_off_prepare);
>  
>  static int set_one_prio(struct task_struct *p, int niceval, int error)
>  {
> 
> 
> 

-- 
"Premature optimization is the root of all evil." - Donald Knuth
