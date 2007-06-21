Return-Path: <linux-kernel-owner+w=401wt.eu-S1754711AbXFUKcS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754711AbXFUKcS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jun 2007 06:32:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752234AbXFUKcH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Jun 2007 06:32:07 -0400
Received: from outbound-sin.frontbridge.com ([207.46.51.80]:15469 "EHLO
	outbound4-sin-R.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752169AbXFUKcG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jun 2007 06:32:06 -0400
X-BigFish: VP
X-MS-Exchange-Organization-Antispam-Report: OrigIP: 163.181.251.8;Service: EHS
X-Server-Uuid: 8C3DB987-180B-4465-9446-45C15473FD3E
Date: Thu, 21 Jun 2007 12:30:47 +0200
From: "Robert Richter" <robert.richter@amd.com>
To: "Stephane Eranian" <eranian@hpl.hp.com>
cc: "David Rientjes" <rientjes@google.com>, "Andi Kleen" <andi@firstfloor.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [patch 2/8] 2.6.22-rc3 perfmon2 : Debug messages added
Message-ID: <20070621103047.GT24544@erda.amd.com>
References: <20070620182126.248753000@amd.com>
 <20070620184113.GC5874@erda.amd.com>
 <alpine.DEB.0.99.0706201245490.4562@chino.kir.corp.google.com>
 <20070620202216.GA26200@frankl.hpl.hp.com>
MIME-Version: 1.0
In-Reply-To: <20070620202216.GA26200@frankl.hpl.hp.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
X-OriginalArrivalTime: 21 Jun 2007 10:30:47.0950 (UTC)
 FILETIME=[3B761AE0:01C7B3EF]
X-WSS-ID: 6A648C1E1S41022688-01-01
Content-Type: text/plain;
 charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 20.06.07 13:22:16, Stephane Eranian wrote:
> David,
> 
> On Wed, Jun 20, 2007 at 12:49:05PM -0700, David Rientjes wrote:
> > On Wed, 20 Jun 2007, Robert Richter wrote:
> > 
> > > Debug messages added for better debugging.
> > > 
> > 
> > And you added BUG_ON()'s.
> > 
> > > Signed-off-by: Robert Richter <robert.richter@amd.com>
> > > 
> > > Index: linux-2.6.22-rc3/perfmon/perfmon_file.c
> > > ===================================================================
> > > --- linux-2.6.22-rc3.orig/perfmon/perfmon_file.c
> > > +++ linux-2.6.22-rc3/perfmon/perfmon_file.c
> > > @@ -192,6 +192,8 @@ static int pfm_mmap(struct file *file, s
> > >  	unsigned long flags;
> > >  	int ret;
> > >  
> > > +	PFM_DBG("pfm_file_ops");
> > 
> > After commenting on your first set of patches, I've been using it a little 
> > more.  In my use, these debugging messages weren't very helpful because 
> > "pfm_file_ops" can indicate pfm_mmap, pfm_read, pfm_poll, etc.  Could 
> > these be changed to be more specific based on the function they're in?
> > 
> the PFM_DBG() macro adds the CPU, function name and line number to the
> printed string.

Right, I had this in mind.

-Robert

-- 
AMD Saxony, Dresden, Germany
Operating System Research Center
email: robert.richter@amd.com



