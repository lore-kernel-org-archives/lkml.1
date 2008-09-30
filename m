Return-Path: <linux-kernel-owner+w=401wt.eu-S1753958AbYI3X3u@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753958AbYI3X3u (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2008 19:29:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752812AbYI3X3l
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Sep 2008 19:29:41 -0400
Received: from e4.ny.us.ibm.com ([32.97.182.144]:37485 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751983AbYI3X3l (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2008 19:29:41 -0400
Date: Tue, 30 Sep 2008 16:29:32 -0700
From: Gary Hade <garyhade@us.ibm.com>
To: Yasunori Goto <y-goto@jp.fujitsu.com>
Cc: Gary Hade <garyhade@us.ibm.com>, linux-mm@kvack.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Badari Pulavarty <pbadari@us.ibm.com>, Mel Gorman <mel@csn.ul.ie>,
       Chris McDermott <lcm@us.ibm.com>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>, Greg KH <greg@kroah.com>,
       Dave Hansen <dave@linux.vnet.ibm.com>,
       Nish Aravamudan <nish.aravamudan@gmail.com>
Subject: Re: [PATCH] mm: show node to memory section relationship with
	symlinks in sysfs
Message-ID: <20080930232932.GB7123@us.ibm.com>
References: <20080929200509.GC21255@us.ibm.com> <20080930163324.44A7.E1E9C6FF@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080930163324.44A7.E1E9C6FF@jp.fujitsu.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 30, 2008 at 05:06:08PM +0900, Yasunori Goto wrote:
> 
> > +#ifdef CONFIG_MEMORY_HOTPLUG_SPARSE
> > +int register_mem_sect_under_node(struct memory_block *mem_blk)
>         :
> 
> I think this patch is convenience even when memory hotplug is disabled.
> CONFIG_SPARSEMEM seems better than CONFIG_MEMORY_HOTPLUG_SPARSE.

Yes, this would be nice but unfortunately the presence of the
memory section directories that are referenced by the symlinks
also depend on CONFIG_MEMORY_HOTPLUG_SPARSE being enabled.  Removal
of the memory hotplug dependency for the code in drivers/base/memory.c
will require more than a simple CONFIG_MEMORY_HOTPLUG_SPARSE to
CONFIG_SPARSEMEM dependency change.  I am still looking at this.

Thanks for the review and testing.

Gary

-- 
Gary Hade
System x Enablement
IBM Linux Technology Center
503-578-4503  IBM T/L: 775-4503
garyhade@us.ibm.com
http://www.ibm.com/linux/ltc
