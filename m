Return-Path: <linux-kernel-owner+w=401wt.eu-S1755062AbXFKXwb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755062AbXFKXwb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jun 2007 19:52:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752313AbXFKXwZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Jun 2007 19:52:25 -0400
Received: from mailout.stusta.mhn.de ([141.84.69.5]:60179 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751677AbXFKXwY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jun 2007 19:52:24 -0400
Date: Tue, 12 Jun 2007 01:52:35 +0200
From: Adrian Bunk <bunk@stusta.de>
To: William Lee Irwin III <wli@holomorphy.com>
Cc: linux-kernel@vger.kernel.org, Mark Lord <lkml@rtr.ca>,
       Andi Kleen <ak@suse.de>, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: divorce CONFIG_X86_PAE from CONFIG_HIGHMEM64G
Message-ID: <20070611235235.GR3588@stusta.de>
References: <20070608023551.GJ15426@holomorphy.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20070608023551.GJ15426@holomorphy.com>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 07, 2007 at 07:35:51PM -0700, William Lee Irwin III wrote:
>...
>  config X86_PAE
>...
> +	help
> +	  PAE is required for NX support, and furthermore enables
> +	  larger swapspace support for non-overcommit purposes. It
> +	  has the cost of more pagetable lookup overhead, and also
> +	  consumes more pagetable space per process.
>...


It's not specific to this help text, but I start becoming a bit picky 
about this issues:

If you understand this help text after reading it, you don't need a help 
text for this option...  ;-)

What is "NX support"?
What are "non-overcommit purposes"?
What is "pagetable lookup overhead"?

And if in doubt, should I say Y or N?

"System administrator who knows which hardware components he put into 
the computer and which filesystems his data is on" might be a good 
description for the average kconfig user, and these are the people who 
should understand this help text.

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

