Return-Path: <linux-kernel-owner+w=401wt.eu-S934264AbYAaSgd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934264AbYAaSgd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2008 13:36:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763258AbYAaSg0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Jan 2008 13:36:26 -0500
Received: from sca-es-mail-1.Sun.COM ([192.18.43.132]:41566 "EHLO
	sca-es-mail-1.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752956AbYAaSgZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2008 13:36:25 -0500
Date: Thu, 31 Jan 2008 10:53:55 -0800
From: Yinghai Lu <Yinghai.Lu@Sun.COM>
Subject: Re: [PATCH 1/4] print out node_data addr and bootmap_start addr
In-reply-to: <20080131130919.GB8499@elte.hu>
To: Ingo Molnar <mingo@elte.hu>
Cc: Andi Kleen <ak@suse.de>, Christoph Lameter <clameter@sgi.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Message-id: <200801311053.56470.yinghai.lu@sun.com>
Organization: SUN
MIME-version: 1.0
Content-type: text/plain; charset=iso-8859-1
Content-transfer-encoding: 7BIT
Content-disposition: inline
References: <200801291041.10490.yinghai.lu@sun.com>
 <200801291113.55164.yinghai.lu@sun.com> <20080131130919.GB8499@elte.hu>
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 31 January 2008 05:09:19 am Ingo Molnar wrote:
> 
> * Yinghai Lu <Yinghai.Lu@Sun.COM> wrote:
> 
> > [PATCH 1/4] print out node_data addr and bootmap_start addr
> 
> thanks, applied.
> 
> >  	nodedata_phys = __pa(node_data[nodeid]);
> > +	printk(KERN_INFO "  NODE_DATA [%016lx - %016lx]\n", nodedata_phys,
> > +		nodedata_phys + pgdat_size - 1);
> 
> > +	printk(KERN_INFO "  bootmap [%016lx -  %016lx] pages %lx\n",
> > +		 bootmap_start, bootmap_start + bootmap_size - 1,
> > +		 bootmap_pages);
> 
> did this help you find the bootmap alignment bug crash?

yes.

YH
