Return-Path: <linux-kernel-owner+w=401wt.eu-S1755297AbZGJMHT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755297AbZGJMHT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jul 2009 08:07:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754204AbZGJMHG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Jul 2009 08:07:06 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:53946 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751890AbZGJMHF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jul 2009 08:07:05 -0400
Date: Fri, 10 Jul 2009 01:21:39 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Mark Allyn <mark.a.allyn@intel.com>
Cc: linux-kernel@vger.kernel.org, alan@linux.intel.com,
       charles.f.johnson@intel.com
Subject: Re: [PATCH] This is the security processor driver for the Intel
	mid platform
Message-ID: <20090709232139.GF1469@ucw.cz>
References: <1247083262-17356-1-git-send-email-mark.a.allyn@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1247083262-17356-1-git-send-email-mark.a.allyn@intel.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> + *
> + *  CHANGES:
> + *
> + *  2009.06.26	Initial publish
> + * 
> + */

No changelogs in source files, please...

> +
> +  /* start address of resident */

Eh?

> +  unsigned long   message_size_in_words;
> +
> +};

> +struct sep_driver_realloc_cache_resident_t {
> +  /* base address */
> +  unsigned long   base_addr;

Most useless comment, ever.

> +  /* cache size in bytes*/
> +  unsigned long   cache_size_in_bytes;

...and more.
 
> +  /* new resident address */
> +  unsigned long   new_resident_addr;
> +
> +  /* new resident address */
> +  unsigned long   new_shared_area_addr;

Ouch. Copy & paste error?

> +  /* new base address */
> +  unsigned long   new_base_addr;

Did they tell you you have to document it, so you did? Bad comments
 are worse than no comments...  
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
