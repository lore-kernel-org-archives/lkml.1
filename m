Return-Path: <linux-kernel-owner+w=401wt.eu-S1756177AbXFXO3R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756177AbXFXO3R (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Jun 2007 10:29:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751453AbXFXO3J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 Jun 2007 10:29:09 -0400
Received: from ug-out-1314.google.com ([66.249.92.171]:55919 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751239AbXFXO3G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Jun 2007 10:29:06 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=jB0j2iIWURcqAz6itSLulpwl/4g/10TrglIN0FZq0KGfsLKb763VdGRqt2SJFTGtiW8CT8kdgwG6rseY6w2HRBKHHLSfRDQ/EvhpAHKk3K6VkPHu/4yYV8OweyhzPL61GF2uaIU/fdx6eBeAcwWbsm+8uq+Aon1QX1YGN4aJCAI=
Date: Sun, 24 Jun 2007 18:30:59 +0400
From: Alexey Dobriyan <adobriyan@gmail.com>
To: Michael Buesch <mb@bu3sch.de>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] hw_random: add quality categories
Message-ID: <20070624143059.GA2944@martell.zuzino.mipt.ru>
References: <200706241555.22957.mb@bu3sch.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200706241555.22957.mb@bu3sch.de>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 24, 2007 at 03:55:22PM +0200, Michael Buesch wrote:
> This adds quality categories for hardware random number generators.

> +static const char * hwrng_quality_string(enum hwrng_quality qual)
> +{
> +	switch (qual) {
> +	case HWRNG_QUAL_HIGH:
> +		return "high";
> +	case HWRNG_QUAL_NORMAL:
> +		return "normal";
> +	case HWRNG_QUAL_LOW:
> +		return "low";
> +	case HWRNG_QUAL_PSEUDO:
> +		return "pseudo";

And how are you going to extend this in future? HWRNG_QUAL_SUPERB ?

