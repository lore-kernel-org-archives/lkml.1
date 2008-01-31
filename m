Return-Path: <linux-kernel-owner+w=401wt.eu-S933830AbYAaNJr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933830AbYAaNJr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2008 08:09:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765842AbYAaNJf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Jan 2008 08:09:35 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:50114 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1765563AbYAaNJe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2008 08:09:34 -0500
Date: Thu, 31 Jan 2008 14:09:19 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Yinghai Lu <Yinghai.Lu@Sun.COM>
Cc: Andi Kleen <ak@suse.de>, Christoph Lameter <clameter@sgi.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/4] print out node_data addr and bootmap_start addr
Message-ID: <20080131130919.GB8499@elte.hu>
References: <200801291041.10490.yinghai.lu@sun.com> <200801291113.55164.yinghai.lu@sun.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200801291113.55164.yinghai.lu@sun.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Yinghai Lu <Yinghai.Lu@Sun.COM> wrote:

> [PATCH 1/4] print out node_data addr and bootmap_start addr

thanks, applied.

>  	nodedata_phys = __pa(node_data[nodeid]);
> +	printk(KERN_INFO "  NODE_DATA [%016lx - %016lx]\n", nodedata_phys,
> +		nodedata_phys + pgdat_size - 1);

> +	printk(KERN_INFO "  bootmap [%016lx -  %016lx] pages %lx\n",
> +		 bootmap_start, bootmap_start + bootmap_size - 1,
> +		 bootmap_pages);

did this help you find the bootmap alignment bug crash?

	Ingo
