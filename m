Return-Path: <linux-kernel-owner+w=401wt.eu-S1764943AbXKPEoW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764943AbXKPEoW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2007 23:44:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757636AbXKPEoO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Nov 2007 23:44:14 -0500
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:46670 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756047AbXKPEoN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2007 23:44:13 -0500
Date: Fri, 16 Nov 2007 13:45:20 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, apw@shadowen.org,
       kamalesh@linux.vnet.ibm.com
Subject: Re: [PATCH][2.6.24-rc2-mm1] memory hotplug x86_64 fix [2/3] fix
 section mismatch in vmammap_allock_block
Message-Id: <20071116134520.44310792.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20071115165330.9448eab6.akpm@linux-foundation.org>
References: <20071113175906.497a1a6a.akpm@linux-foundation.org>
	<20071115132919.f2bf4946.kamezawa.hiroyu@jp.fujitsu.com>
	<20071115005657.99856c28.akpm@linux-foundation.org>
	<20071115181816.1f0cb905.kamezawa.hiroyu@jp.fujitsu.com>
	<20071115193016.daabe91e.kamezawa.hiroyu@jp.fujitsu.com>
	<20071115193544.eb0629e1.kamezawa.hiroyu@jp.fujitsu.com>
	<20071115165330.9448eab6.akpm@linux-foundation.org>
Organization: Fujitsu
X-Mailer: Sylpheed 2.4.2 (GTK+ 2.10.11; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 15 Nov 2007 16:53:30 -0800
Andrew Morton <akpm@linux-foundation.org> wrote:
> > -		return __alloc_bootmem_node(NODE_DATA(node), size, size,
> > +		return __earlyonly_bootmem_alloc(node, size, size,
> >  				__pa(MAX_DMA_ADDRESS));
> >  }
> >  
> 
> AFACIT this is applicable to mainline?
> 
> 
yes. I think so.

Thanks,
-Kame

