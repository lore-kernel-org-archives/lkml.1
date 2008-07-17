Return-Path: <linux-kernel-owner+w=401wt.eu-S933098AbYGQVS4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933098AbYGQVS4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2008 17:18:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932285AbYGQVSr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jul 2008 17:18:47 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:37909 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932179AbYGQVSq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2008 17:18:46 -0400
Date: Thu, 17 Jul 2008 14:15:31 -0700
From: Greg KH <greg@kroah.com>
To: Jason Baron <jbaron@redhat.com>
Cc: Dominik Brodowski <linux@dominikbrodowski.net>,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       joe@perches.com, nick@nick-andrew.net, randy.dunlap@oracle.com
Subject: Re: [PATCH 6/7] dynamic debug v2 - convert cpufreq
Message-ID: <20080717211531.GA16569@kroah.com>
References: <20080715213613.GG23331@redhat.com> <20080715230731.GA15208@isilmar.linta.de> <20080717210531.GA13252@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080717210531.GA13252@redhat.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 17, 2008 at 05:05:32PM -0400, Jason Baron wrote:
> --- a/arch/x86/kernel/cpu/cpufreq/acpi-cpufreq.c
> +++ b/arch/x86/kernel/cpu/cpufreq/acpi-cpufreq.c
> @@ -25,6 +25,7 @@
>   * ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
>   */
>  
> +#include <linux/dynamic_debug_cpufreq.h>
>  #include <linux/kernel.h>
>  #include <linux/module.h>
>  #include <linux/init.h>

kernel.h includes dynamic_debug.h right?  Then why not just put the
_cpufreq.h stuff in the current cpufreq.h file(s)?

thanks,

greg k-h
