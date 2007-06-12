Return-Path: <linux-kernel-owner+w=401wt.eu-S1756620AbXFKX7U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756620AbXFKX7U (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jun 2007 19:59:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753916AbXFKX7O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Jun 2007 19:59:14 -0400
Received: from holomorphy.com ([66.93.40.71]:41310 "EHLO holomorphy.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752828AbXFKX7N (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jun 2007 19:59:13 -0400
Date: Mon, 11 Jun 2007 17:00:26 -0700
From: William Lee Irwin III <wli@holomorphy.com>
To: Adrian Bunk <bunk@stusta.de>
Cc: linux-kernel@vger.kernel.org, Mark Lord <lkml@rtr.ca>,
       Andi Kleen <ak@suse.de>, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: divorce CONFIG_X86_PAE from CONFIG_HIGHMEM64G
Message-ID: <20070612000026.GC6909@holomorphy.com>
References: <20070608023551.GJ15426@holomorphy.com> <20070611235235.GR3588@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070611235235.GR3588@stusta.de>
Organization: The Domain of Holomorphy
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 07, 2007 at 07:35:51PM -0700, William Lee Irwin III wrote:
>> +	  PAE is required for NX support, and furthermore enables
>> +	  larger swapspace support for non-overcommit purposes. It
>> +	  has the cost of more pagetable lookup overhead, and also
>> +	  consumes more pagetable space per process.

On Tue, Jun 12, 2007 at 01:52:35AM +0200, Adrian Bunk wrote:
> It's not specific to this help text, but I start becoming a bit picky 
> about this issues:
> If you understand this help text after reading it, you don't need a help 
> text for this option...  ;-)
> What is "NX support"?
> What are "non-overcommit purposes"?
> What is "pagetable lookup overhead"?
> And if in doubt, should I say Y or N?
> "System administrator who knows which hardware components he put into 
> the computer and which filesystems his data is on" might be a good 
> description for the average kconfig user, and these are the people who 
> should understand this help text.

I would like to have some place to explain issues such as those, but
there are as of yet no designated places for tutorial-level information.

If such a place were provided, I would provide storybook commentary to
explain all those. Similarly actually holds for kernel function docbook.


-- wli
