Return-Path: <linux-kernel-owner+w=401wt.eu-S1759883AbYAUOfZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759883AbYAUOfZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2008 09:35:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754119AbYAUOfP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Jan 2008 09:35:15 -0500
Received: from gir.skynet.ie ([193.1.99.77]:60592 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754068AbYAUOfO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2008 09:35:14 -0500
Date: Mon, 21 Jan 2008 14:35:09 +0000
From: Mel Gorman <mel@csn.ul.ie>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: mingo@elte.hu, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
       apw@shadowen.org
Subject: Re: [PATCH 0/2] Relax restrictions on setting CONFIG_NUMA on x86
Message-ID: <20080121143508.GA8485@csn.ul.ie>
References: <20080118153529.12646.5260.sendpatchset@skynet.skynet.ie> <20080121093702.8FC2.KOSAKI.MOTOHIRO@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <20080121093702.8FC2.KOSAKI.MOTOHIRO@jp.fujitsu.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On (21/01/08 09:38), KOSAKI Motohiro didst pronounce:
> Hi 
> 
> > A fix[1] was merged to the x86.git tree that allowed NUMA kernels to boot
> > on normal x86 machines (and not just NUMA-Q, Summit etc.). I took a look
> > at the restrictions on setting NUMA on x86 to see if they could be lifted.
> 
> Interesting!
> 
> I will test tomorrow.

Thanks.

> I think this patch become easy to the porting of fakenuma.
> 

It would be great if that was available, particularly if it could fake
memoryless nodes as that is a place where we've found a few
difficult-to-reproduce bugs.

-- 
Mel Gorman
Part-time Phd Student                          Linux Technology Center
University of Limerick                         IBM Dublin Software Lab
