Return-Path: <linux-kernel-owner+w=401wt.eu-S1753537AbXFTUkS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753537AbXFTUkS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2007 16:40:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750978AbXFTUkF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Jun 2007 16:40:05 -0400
Received: from tayrelbas04.tay.hp.com ([161.114.80.247]:43349 "EHLO
	tayrelbas04.tay.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750881AbXFTUkB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2007 16:40:01 -0400
Date: Wed, 20 Jun 2007 13:39:44 -0700
From: Stephane Eranian <eranian@hpl.hp.com>
To: David Rientjes <rientjes@google.com>
Cc: Robert Richter <robert.richter@amd.com>, Andi Kleen <andi@firstfloor.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [patch 2/8] 2.6.22-rc3 perfmon2 : Debug messages added
Message-ID: <20070620203944.GB26200@frankl.hpl.hp.com>
Reply-To: eranian@hpl.hp.com
References: <20070620182126.248753000@amd.com> <20070620184113.GC5874@erda.amd.com> <alpine.DEB.0.99.0706201245490.4562@chino.kir.corp.google.com> <20070620202216.GA26200@frankl.hpl.hp.com> <alpine.DEB.0.99.0706201326310.6935@chino.kir.corp.google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.0.99.0706201326310.6935@chino.kir.corp.google.com>
User-Agent: Mutt/1.4.1i
Organisation: HP Labs Palo Alto
Address: HP Labs, 1U-17, 1501 Page Mill road, Palo Alto, CA 94304, USA.
E-mail: eranian@hpl.hp.com
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 20, 2007 at 01:28:50PM -0700, David Rientjes wrote:
> On Wed, 20 Jun 2007, Stephane Eranian wrote:
> 
> > > After commenting on your first set of patches, I've been using it a little 
> > > more.  In my use, these debugging messages weren't very helpful because 
> > > "pfm_file_ops" can indicate pfm_mmap, pfm_read, pfm_poll, etc.  Could 
> > > these be changed to be more specific based on the function they're in?
> > > 
> > the PFM_DBG() macro adds the CPU, function name and line number to the
> > printed string.
> > 
> 
> That's not the case in what I currently have in my tree, I'll go back and 
> see what I'm missing.

Bizarre. Becuase if you've disabled CONFIG_PERFMON_DEBUG, then all the PFM_DBG()
are removed. 

> 
> What's the current status of the perfmon2 patchset that Robert's work is 
> based on?

Well, I have been hacking on it a lot especially to allow Oprofile and
perfmon2 to co-exist (mutual-exclusion). I am hoping to release something
before I fly to OLS next week. I have started integrating  Robert's patches.
I also have to integrate IBM's Cell support patch.

-- 
-Stephane
