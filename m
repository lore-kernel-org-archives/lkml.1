Return-Path: <linux-kernel-owner+w=401wt.eu-S1763004AbXIKI0U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763004AbXIKI0U (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Sep 2007 04:26:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752711AbXIKI0M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Sep 2007 04:26:12 -0400
Received: from smtp.ocgnet.org ([64.20.243.3]:60838 "EHLO smtp.ocgnet.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755669AbXIKI0L (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Sep 2007 04:26:11 -0400
Date: Tue, 11 Sep 2007 17:25:59 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Yasunori Goto <y-goto@jp.fujitsu.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org
Subject: Re: [PATCH -mm] mm: Fix memory hotplug + sparsemem build.
Message-ID: <20070911082559.GA19732@linux-sh.org>
Mail-Followup-To: Paul Mundt <lethal@linux-sh.org>,
	Yasunori Goto <y-goto@jp.fujitsu.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org
References: <20070911072507.GB19260@linux-sh.org> <20070911170921.F137.Y-GOTO@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070911170921.F137.Y-GOTO@jp.fujitsu.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Goto-san,

On Tue, Sep 11, 2007 at 05:18:01PM +0900, Yasunori Goto wrote:
> >  	if (onlined_pages)
> > -		node_set_state(zone->node, N_HIGH_MEMORY);
> > +		node_set_state(zone_to_nid(zone), N_HIGH_MEMORY);
> >  
> >  	setup_per_zone_pages_min();
> 
> Thanks Paul-san. 
> 
> I also have another issue around here.
> (Kswapd doesn't run on memory less node now. It should run when
>  the node has memory.)
> 
> I would like to merge them like following if you don't mind.
> 
Looks fine to me!
