Return-Path: <linux-kernel-owner+w=401wt.eu-S1756077AbZEJCNV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756077AbZEJCNV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 May 2009 22:13:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755612AbZEJCNN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 May 2009 22:13:13 -0400
Received: from kroah.org ([198.145.64.141]:59777 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753883AbZEJCNN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 May 2009 22:13:13 -0400
Date: Sat, 9 May 2009 19:09:11 -0700
From: Greg KH <greg@kroah.com>
To: David Woodhouse <dwmw2@infradead.org>
Cc: Joerg Roedel <joerg.roedel@amd.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       reinette.chatre@intel.com, benh@kernel.crashing.org
Subject: Re: dma-debug: add a check dma memory leaks
Message-ID: <20090510020911.GA4722@kroah.com>
References: <200903302101.n2UL1O1n011970@hera.kernel.org> <1240005065.19059.19.camel@macbook.infradead.org> <20090421092016.GH17438@amd.com> <1241913552.24436.113.camel@macbook.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1241913552.24436.113.camel@macbook.infradead.org>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, May 10, 2009 at 12:59:12AM +0100, David Woodhouse wrote:
> Subject: Add BUS_NOTIFY_UNBOUND_DRIVER callback after driver removal
> 
> This adds a notifier callback which happens _after_ the driver has been
> unbound from the device, needed for things like the DMA debugging API
> which want to check that all DMA mappings have been correctly torn down.
> 
> Signed-off-by: David Woodhouse <David.Woodhouse@intel.com>

I don't understand.  Who wrote this patch, Joerg or you?  I have this in
my tree already as written by Joerg.

confused,

greg k-h
