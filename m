Return-Path: <linux-kernel-owner+w=401wt.eu-S1755444AbZCKNfc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755444AbZCKNfc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Mar 2009 09:35:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753771AbZCKNfX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Mar 2009 09:35:23 -0400
Received: from mx1.emlix.com ([193.175.82.87]:34347 "EHLO mx1.emlix.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752487AbZCKNfW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Mar 2009 09:35:22 -0400
Date: Wed, 11 Mar 2009 14:36:00 +0100
From: Johannes Weiner <jw@emlix.com>
To: Chris Zankel <chris@zankel.net>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [patch 1/7] xtensa: kernel/traps.c: include hardirq.h
References: <20090302164257.477296438@emlix.com> <E1LeBSI-0003Yl-Oq@mailer.emlix.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1LeBSI-0003Yl-Oq@mailer.emlix.com>
User-Agent: Mutt/1.4.2.3i
Message-Id: <E1LhOad-0000ch-KG@mailer.emlix.com>
Organization: emlix gmbh, Goettingen, Germany
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 02, 2009 at 05:42:58PM +0100, Johannes Weiner wrote:
> The file refers to in_interrupt() so hardirq.h must be included.
> 
> Signed-off-by: Johannes Weiner <jw@emlix.com>
> ---
>  arch/xtensa/kernel/traps.c |    1 +
>  1 file changed, 1 insertion(+)
> 
> --- a/arch/xtensa/kernel/traps.c
> +++ b/arch/xtensa/kernel/traps.c
> @@ -25,6 +25,7 @@
>  
>  #include <linux/kernel.h>
>  #include <linux/sched.h>
> +#include <linux/hardirq.h>
>  #include <linux/init.h>
>  #include <linux/module.h>
>  #include <linux/stringify.h>

This is obsoleted by Alexey's fix in mainline:

	5a891ed xtensa: fix compilation somewhat
