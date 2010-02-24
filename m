Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758250Ab0BXVtI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Feb 2010 16:49:08 -0500
Received: from cantor2.suse.de ([195.135.220.15]:59998 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758219Ab0BXVtH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Feb 2010 16:49:07 -0500
Date: Wed, 24 Feb 2010 13:44:42 -0800
From: Greg KH <gregkh@suse.de>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: linux-kernel@vger.kernel.org, devicetree-discuss@lists.ozlabs.org,
       kay.sievers@vrfy.org, benh@kernel.crashing.org
Subject: Re: [RFC] driver-core: Add device node pointer to struct device
Message-ID: <20100224214442.GB18437@suse.de>
References: <20100224210514.16289.86611.stgit@angua>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100224210514.16289.86611.stgit@angua>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 24, 2010 at 02:10:30PM -0700, Grant Likely wrote:
> Greg and Kay,
> 
> This is a patch from a larger series of OF related cleanup patches.  This
> one adds a new 'of_node' member to struct device, conditional upon
> CONFIG_OF.  The goal is to move of_node out of archdata because all
> arches using CONFIG_OF need it.
> 
> Before I commit too much effort down this path, I want to get your
> feedback.  Do you have any objections to this change to struct device?
> 
> @@ -414,6 +415,9 @@ struct device {
>  					     override */
>  	/* arch specific additions */
>  	struct dev_archdata	archdata;
> +#ifdef CONFIG_OF
> +	struct device_node	*of_node;
> +#endif

No objection from me, but do we really need the #ifdef here?

> Full patch follows...

Do you want to take this patch through your tree?  If so, feel free to
add:
	Acked-by: Greg Kroah-Hartman <gregkh@suse.de>

to the patch.

If not, let me know and I'll take it through my tree.

Glad to see this work coming along, nice job.

thanks,

greg k-h
