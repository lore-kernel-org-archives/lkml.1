Return-Path: <linux-kernel-owner+w=401wt.eu-S1755835AbZJLKOy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755835AbZJLKOy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Oct 2009 06:14:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755291AbZJLKOy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Oct 2009 06:14:54 -0400
Received: from cantor2.suse.de ([195.135.220.15]:43047 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755271AbZJLKOt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Oct 2009 06:14:49 -0400
Date: Mon, 12 Oct 2009 12:14:05 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
X-X-Sender: jikos@twin.jikos.cz
To: Joe Perches <joe@perches.com>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Wolfram Sang <w.sang@pengutronix.de>,
       Grant Likely <grant.likely@secretlab.ca>,
       Anton Vorontsov <avorontsov@ru.mvista.com>
Subject: Re: [PATCH 2/3] MAINTAINERS: Document new "K:" entry type
In-Reply-To: <6773e26fed99c1e686bf6efa3dd59eba525c7633.1255153863.git.joe@perches.com>
Message-ID: <alpine.LRH.2.00.0910121211250.12171@twin.jikos.cz>
References: <cover.1255153863.git.joe@perches.com> <6773e26fed99c1e686bf6efa3dd59eba525c7633.1255153863.git.joe@perches.com>
User-Agent: Alpine 2.00 (LRH 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 9 Oct 2009, Joe Perches wrote:

> diff --git a/MAINTAINERS b/MAINTAINERS
> index e1da925..4407de2 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -65,43 +65,51 @@ trivial patch so apply some common sense.
>  
>  8.	Happy hacking.
>  
> -		-----------------------------------
> -
> -Maintainers List (try to look for most precise areas first)
> +Descriptions of section entries:
[ ... ]
> +	K: Keyword perl extended regex pattern to match content in a
> +	   patch or file.  For instance:
> +	   K: of_get_profile
> +	      matches patches or files that contain "of_get_profile"
> +	   K: \b(printk|pr_(info|err))\b
> +	      matches patches or files that contain one or more of the words
> +	      printk, pr_info or pr_err
> +	   One regex pattern per line.  Multiple K: lines acceptable.

What expressions do you expect people will be using here? (the example 
with printk() doesn't really demonstrate usefulness of this).

-- 
Jiri Kosina
SUSE Labs, Novell Inc.

