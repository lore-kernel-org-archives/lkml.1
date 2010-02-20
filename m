Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752217Ab0BTHSR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Feb 2010 02:18:17 -0500
Received: from mtagate1.de.ibm.com ([195.212.17.161]:36798 "EHLO
	mtagate1.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751261Ab0BTHSQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Feb 2010 02:18:16 -0500
Date: Sat, 20 Feb 2010 09:18:05 +0200
From: Muli Ben-Yehuda <muli@il.ibm.com>
To: "Darrick J. Wong" <djwong@us.ibm.com>
Cc: Ingo Molnar <mingo@elte.hu>, "Jon D. Mason" <jdmason@kudzu.us>,
       discuss@x86-64.org, Corinna Schultz <coschult@us.ibm.com>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] calgary: Increase the maximum PHB bus number
Message-ID: <20100220071805.GJ9746@il.ibm.com>
References: <20091209005901.GX10295@tux1.beaverton.ibm.com>
 <20091209090346.GN2452@tyrion.haifa.ibm.com>
 <20100218183750.GL29604@tux1.beaverton.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100218183750.GL29604@tux1.beaverton.ibm.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 18, 2010 at 10:37:50AM -0800, Darrick J. Wong wrote:
> On Wed, Dec 09, 2009 at 11:03:46AM +0200, Muli Ben-Yehuda wrote:
> > On Tue, Dec 08, 2009 at 04:59:01PM -0800, Darrick J. Wong wrote:
> > 
> > > -#define MAX_NUM_OF_PHBS		8 /* how many PHBs in total? */
> > > -#define MAX_NUM_CHASSIS		8 /* max number of chassis */
> > > -/* MAX_PHB_BUS_NUM is the maximal possible dev->bus->number */
> > > -#define MAX_PHB_BUS_NUM		(MAX_NUM_OF_PHBS * MAX_NUM_CHASSIS * 2)
> > > +/*
> > > +   The maximum PHB bus number.
> > > +   x3950M2 (rare): 8 chassis, 48 PHBs per chassis = 384
> > > +   x3950M2: 4 chassis, 48 PHBs per chassis        = 192
> > > +   x3950 (PCIE): 8 chassis, 32 PHBs per chassis   = 256
> > > +   x3950 (PCIX): 8 chassis, 16 PHBs per chassis   = 128
> > > +*/
> > > +#define MAX_PHB_BUS_NUM		384
> > > +
> > >  #define PHBS_PER_CALGARY	4
> > 
> > We'll end up wasting a few bytes on small systems, but I don't think
> > it's enough to matter on these fairly large systems. As far as I'm
> > concerned, patch is fine.
> > 
> > Acked-by: Muli Ben-Yehuda <muli@il.ibm.com>
> 
> Hmm... has this patch been queued up by anyone for the .34 merge
> window?

I don't maintain a separate Calgary patchset anymore, hopefully Ingo
or one of the other x86 maintainers have picked it up?

Cheers,
Muli
