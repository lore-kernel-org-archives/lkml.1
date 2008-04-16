Return-Path: <linux-kernel-owner+w=401wt.eu-S1761619AbYDPTa3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761619AbYDPTa3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2008 15:30:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751536AbYDPTaV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Apr 2008 15:30:21 -0400
Received: from gir.skynet.ie ([193.1.99.77]:41874 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750847AbYDPTaU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2008 15:30:20 -0400
Date: Wed, 16 Apr 2008 20:30:18 +0100
From: Mel Gorman <mel@csn.ul.ie>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/4] Add a basic debugging framework for memory initialisation
Message-ID: <20080416193017.GA13968@csn.ul.ie>
References: <20080416135058.1346.65546.sendpatchset@skynet.skynet.ie> <20080416135118.1346.72244.sendpatchset@skynet.skynet.ie> <20080416140431.GD24383@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <20080416140431.GD24383@elte.hu>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On (16/04/08 16:04), Ingo Molnar didst pronounce:
> 
> * Mel Gorman <mel@csn.ul.ie> wrote:
> 
> > +static __init int set_mminit_debug_level(char *str)
> > +{
> > +	get_option(&str, &mminit_debug_level);
> > +	return 0;
> > +}
> > +early_param("mminit_debug_level", set_mminit_debug_level);
> 
> another small suggestion: could you please also add a Kconfig method of 
> enabling it, dependent on KERNEL_DEBUG, default-off (for now). The best 
> would be not a numeric switch but something that gets randomized by 
> "make randconfig". I.e. an on/off switch kind of things.
> 

Makes sense. I've this and your other suggestions incorporated. It'll be
part of V2.

-- 
Mel Gorman
Part-time Phd Student                          Linux Technology Center
University of Limerick                         IBM Dublin Software Lab
