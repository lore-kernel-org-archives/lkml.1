Return-Path: <linux-kernel-owner+w=401wt.eu-S1763846AbYJJVe2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763846AbYJJVe2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Oct 2008 17:34:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762611AbYJJVeH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Oct 2008 17:34:07 -0400
Received: from e1.ny.us.ibm.com ([32.97.182.141]:53864 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1764245AbYJJVeE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Oct 2008 17:34:04 -0400
Date: Fri, 10 Oct 2008 14:33:57 -0700
From: Gary Hade <garyhade@us.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Gary Hade <garyhade@us.ibm.com>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org, y-goto@jp.fujitsu.com, pbadari@us.ibm.com,
       mel@csn.ul.ie, lcm@us.ibm.com, mingo@elte.hu, greg@kroah.com,
       dave@linux.vnet.ibm.com, nish.aravamudan@gmail.com
Subject: Re: [PATCH 1/2] [REPOST] mm: show node to memory section
	relationship with symlinks in sysfs
Message-ID: <20081010213357.GD7369@us.ibm.com>
References: <20081009192115.GB8793@us.ibm.com> <20081010124239.f92b5568.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081010124239.f92b5568.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 10, 2008 at 12:42:39PM -0700, Andrew Morton wrote:
> On Thu, 9 Oct 2008 12:21:15 -0700
> Gary Hade <garyhade@us.ibm.com> wrote:
> 
> > Show node to memory section relationship with symlinks in sysfs
> > 
> > Add /sys/devices/system/node/nodeX/memoryY symlinks for all
> > the memory sections located on nodeX.  For example:
> > /sys/devices/system/node/node1/memory135 -> ../../memory/memory135
> > indicates that memory section 135 resides on node1.
> 
> I'm not seeing here a description of why the kernel needs this feature.
> Why is it useful?  How will it be used?  What value does it have to
> our users?

Sorry, I should have included that.  In our case, it is another
small step towards eventual total node removal.  We will need to
know which memory sections to offline for whatever node is targeted
for removal.  However, I suspect that exposing the node to section
information to user-level could be useful for other purposes.
For example, I have been thinking that using memory hotremove
functionality to modify the amount of available memory on specific
nodes without having to physically add/remove DIMMs might be useful
to those that test application or benchmark performance on a
multi-node system in various memory configurations.

Gary

-- 
Gary Hade
System x Enablement
IBM Linux Technology Center
503-578-4503  IBM T/L: 775-4503
garyhade@us.ibm.com
http://www.ibm.com/linux/ltc
