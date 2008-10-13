Return-Path: <linux-kernel-owner+w=401wt.eu-S1760091AbYJMQks@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760091AbYJMQks (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Oct 2008 12:40:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756578AbYJMQkk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Oct 2008 12:40:40 -0400
Received: from e35.co.us.ibm.com ([32.97.110.153]:54547 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756383AbYJMQkk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Oct 2008 12:40:40 -0400
Subject: Re: [PATCH 1/2] [REPOST] mm: show node to memory section
	relationship with symlinks in sysfs
From: Dave Hansen <dave@linux.vnet.ibm.com>
To: Gary Hade <garyhade@us.ibm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org, y-goto@jp.fujitsu.com, pbadari@us.ibm.com,
       mel@csn.ul.ie, lcm@us.ibm.com, mingo@elte.hu, greg@kroah.com,
       nish.aravamudan@gmail.com
In-Reply-To: <20081013163416.GA7340@us.ibm.com>
References: <20081009192115.GB8793@us.ibm.com>
	 <20081010124239.f92b5568.akpm@linux-foundation.org>
	 <20081010213357.GD7369@us.ibm.com>
	 <20081010145950.f51def29.akpm@linux-foundation.org>
	 <20081010231844.GA1718@us.ibm.com>
	 <20081010163230.ae9d964d.akpm@linux-foundation.org>
	 <20081013163416.GA7340@us.ibm.com>
Content-Type: text/plain
Date: Mon, 13 Oct 2008 09:40:35 -0700
Message-Id: <1223916035.29877.10.camel@nimitz>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2008-10-13 at 09:34 -0700, Gary Hade wrote:
> I understand your concerns about adding possibly frivolous interfaces
> but in this case we are simply eliminating a very obvious hole in the
> existing set of memory hot-add/remove interfaces.  In general, it
> makes absolutely no sense to provide a resource add/remove mechanism
> without telling the user where the resource is physically located.

Does it help we export the phys_index (basically the section number) as
part of the section directory?

I don't think we export the physical memory ranges of NUMA nodes.  But,
if we did that as well, it would allow userspace to do this association
without troubling the kernel with maintaining it.

-- Dave

