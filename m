Return-Path: <linux-kernel-owner+w=401wt.eu-S1755366AbYHMAqy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755366AbYHMAqy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Aug 2008 20:46:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754817AbYHMAq2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Aug 2008 20:46:28 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:39417 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754797AbYHMAq0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Aug 2008 20:46:26 -0400
Date: Tue, 12 Aug 2008 17:40:06 -0700
From: Greg KH <greg@kroah.com>
To: Christoph Lameter <cl@linux-foundation.org>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>, akpm@linux-foundation.org,
       Christoph Lameter <clameter@sgi.com>, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, Mel Gorman <mel@skynet.ie>,
       andi@firstfloor.org, Rik van Riel <riel@redhat.com>, mpm@selenic.com,
       Dave Chinner <david@fromorbit.com>
Subject: Re: [patch 01/19] slub: Add defrag_ratio field and sysfs support.
Message-ID: <20080813004006.GD22793@kroah.com>
References: <20080811150616.207532384@quilx.com> <20080811150653.575096604@quilx.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080811150653.575096604@quilx.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 11, 2008 at 08:06:17AM -0700, Christoph Lameter wrote:
> The defrag_ratio is used to set the threshold at which defragmentation
> should be attempted on a slab page.
> 
> The allocation ratio is measured by the percentage of the available slots
> allocated.
> 
> Add a defrag ratio field and set it to 30% by default. A limit of 30% specified
> that less than 3 out of 10 available slots for objects are in use before
> slab defragmeentation runs.

Any new sysfs file should also add documentation in Documentation/ABI.

Please add that to this patch.

thanks,

greg k-h
