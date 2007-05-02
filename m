Return-Path: <linux-kernel-owner+w=401wt.eu-S2993067AbXEBMR6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2993067AbXEBMR6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2007 08:17:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2993078AbXEBMR5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 May 2007 08:17:57 -0400
Received: from 85-218-34-145.dclient.lsne.ch ([85.218.34.145]:47920 "EHLO vdr"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S2993067AbXEBMR5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2007 08:17:57 -0400
Date: Wed, 2 May 2007 14:17:53 +0200
From: Gregoire Favre <Gregoire.Favre@gmail.com>
To: Andi Kleen <ak@suse.de>
Cc: Jon Burgess <jburgess777@googlemail.com>, linux-dvb@linuxtv.org,
       v4l-dvb-maintainer@linuxtv.org,
       Markus Rechberger <mrechberger@gmail.com>, linux-kernel@vger.kernel.org,
       Lee Revell <rlrevell@joe-job.com>
Subject: Re: [PATCH] Re: More than 2Gb problem (dvb related) ?
Message-ID: <20070502121753.GA6539@gmail.com>
References: <20070427111047.GB10284@gmail.com> <20070501094153.GC6895@gmail.com> <1178057515.25218.24.camel@localhost.localdomain> <200705021135.32835.ak@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <200705021135.32835.ak@suse.de>
X-Operating-System: Linux 2.6.21.1
User-Agent: Mutt/1.5.15 (2007-04-06)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 02, 2007 at 11:35:32AM +0200, Andi Kleen wrote:

> Does this patch help?

So far so good :-)

Thank you very much.

> Index: linux/mm/vmalloc.c
> ===================================================================
> --- linux.orig/mm/vmalloc.c
> +++ linux/mm/vmalloc.c
> @@ -431,7 +431,7 @@ void *__vmalloc_area_node(struct vm_stru
>  		area->flags |= VM_VPAGES;
>  	} else {
>  		pages = kmalloc_node(array_size,
> -				(gfp_mask & ~(__GFP_HIGHMEM | __GFP_ZERO)),
> +				(gfp_mask & GFP_LEVEL_MASK),
>  				node);
>  	}
>  	area->pages = pages;
-- 
Grégoire FAVRE  http://gregoire.favre.googlepages.com  http://www.gnupg.org
               http://picasaweb.google.com/Gregoire.Favre
