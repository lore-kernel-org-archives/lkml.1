Return-Path: <linux-kernel-owner+w=401wt.eu-S1760322AbXHVKaR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760322AbXHVKaR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2007 06:30:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757810AbXHVKaB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Aug 2007 06:30:01 -0400
Received: from ns.suse.de ([195.135.220.2]:57543 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751053AbXHVKaB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2007 06:30:01 -0400
Date: Wed, 22 Aug 2007 13:23:52 +0200
From: Andi Kleen <ak@suse.de>
To: Avi Kivity <avi@qumranet.com>
Cc: Andi Kleen <ak@suse.de>, Rusty Russell <rusty@rustcorp.com.au>,
       Andrew Morton <akpm@osdl.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Chris Wright <chrisw@sous-sol.org>,
       Virtualization Mailing List <virtualization@lists.osdl.org>
Subject: Re: [PATCH] Add I/O hypercalls for i386 paravirt
Message-ID: <20070822112352.GQ32640@bingen.suse.de>
References: <46CBC842.4070100@vmware.com> <46CBCADF.2070400@qumranet.com> <1187763956.6174.48.camel@localhost.localdomain> <20070822103545.GG2642@bingen.suse.de> <46CC0719.2080103@qumranet.com> <20070822110810.GO32640@bingen.suse.de> <46CC0EAF.3000805@qumranet.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46CC0EAF.3000805@qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 22, 2007 at 01:23:43PM +0300, Avi Kivity wrote:
> Andi Kleen wrote:
> >>I don't see why it's intrusive -- they all use the APIs, right?
> >>    
> >
> >Yes, but it still changes them. It might have a larger impact
> >on code size for example. 
> >  
> 
> Only if CONFIG_PARAVIRT is defined.  

Which eventually distribution kernels will do.

> And even then, all the performance 
> sensitive stuff uses mmio, no?

Not worried about performance, but just impact on code size etc.

-Andi
