Return-Path: <linux-kernel-owner+w=401wt.eu-S1752553AbXFTUWl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752553AbXFTUWl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2007 16:22:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750800AbXFTUWd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Jun 2007 16:22:33 -0400
Received: from tayrelbas04.tay.hp.com ([161.114.80.247]:40217 "EHLO
	tayrelbas04.tay.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750753AbXFTUWc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2007 16:22:32 -0400
Date: Wed, 20 Jun 2007 13:22:16 -0700
From: Stephane Eranian <eranian@hpl.hp.com>
To: David Rientjes <rientjes@google.com>
Cc: Robert Richter <robert.richter@amd.com>, Andi Kleen <andi@firstfloor.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [patch 2/8] 2.6.22-rc3 perfmon2 : Debug messages added
Message-ID: <20070620202216.GA26200@frankl.hpl.hp.com>
Reply-To: eranian@hpl.hp.com
References: <20070620182126.248753000@amd.com> <20070620184113.GC5874@erda.amd.com> <alpine.DEB.0.99.0706201245490.4562@chino.kir.corp.google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.0.99.0706201245490.4562@chino.kir.corp.google.com>
User-Agent: Mutt/1.4.1i
Organisation: HP Labs Palo Alto
Address: HP Labs, 1U-17, 1501 Page Mill road, Palo Alto, CA 94304, USA.
E-mail: eranian@hpl.hp.com
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

David,

On Wed, Jun 20, 2007 at 12:49:05PM -0700, David Rientjes wrote:
> On Wed, 20 Jun 2007, Robert Richter wrote:
> 
> > Debug messages added for better debugging.
> > 
> 
> And you added BUG_ON()'s.
> 
> > Signed-off-by: Robert Richter <robert.richter@amd.com>
> > 
> > Index: linux-2.6.22-rc3/perfmon/perfmon_file.c
> > ===================================================================
> > --- linux-2.6.22-rc3.orig/perfmon/perfmon_file.c
> > +++ linux-2.6.22-rc3/perfmon/perfmon_file.c
> > @@ -192,6 +192,8 @@ static int pfm_mmap(struct file *file, s
> >  	unsigned long flags;
> >  	int ret;
> >  
> > +	PFM_DBG("pfm_file_ops");
> 
> After commenting on your first set of patches, I've been using it a little 
> more.  In my use, these debugging messages weren't very helpful because 
> "pfm_file_ops" can indicate pfm_mmap, pfm_read, pfm_poll, etc.  Could 
> these be changed to be more specific based on the function they're in?
> 
the PFM_DBG() macro adds the CPU, function name and line number to the
printed string.

-- 

-Stephane
