Return-Path: <linux-kernel-owner+w=401wt.eu-S1761580AbXJQUMc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761580AbXJQUMc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2007 16:12:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753535AbXJQUMV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Oct 2007 16:12:21 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:41443 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760188AbXJQUMU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2007 16:12:20 -0400
Date: Wed, 17 Oct 2007 13:10:54 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: akepner@sgi.com
Cc: tony.luck@intel.com, grundler@parisc-linux.org, jbarnes@virtuousgeek.org,
       jes@sgi.com, randy.dunlap@oracle.com, rdreier@cisco.com,
       James.Bottomley@steeleye.com, davem@davemloft.net,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] dma: add dma_flags_set/get_*() interfaces
Message-Id: <20071017131054.d3d88c62.akpm@linux-foundation.org>
In-Reply-To: <20071017160327.GP5601@sgi.com>
References: <20071017014128.GJ5601@sgi.com>
	<20071016202728.81450e25.akpm@linux-foundation.org>
	<20071017160327.GP5601@sgi.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 17 Oct 2007 09:03:27 -0700
akepner@sgi.com wrote:

> > 
> > What would be the cost of doing this cleanly and either redefining
> > dma_data_direction to be a field-of-bits or just leave dma_data_direction
> > alone (it is quite unrelated to this work, isn't it?) and adding new
> > fields/arguments to manage this new functionality?
> 
> It'd be significantly more work to do change or add arguments 
> to the dma_map_* functions. But if that's what I need to do to 
> get this accepted, I'll back up and have another go at it.

I don't have any particularly strong opinions on which would be the best
way to clean this up.  Hopefully someone who is more involved with the DMA
mapping interfaces can help out.

It wouldn't be efficient for you to implement something new, only to have
it criticized again.  I'd suggest that you come up with a concrete
design, describe to us what you propose to do and let's take it from there.

