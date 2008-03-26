Return-Path: <linux-kernel-owner+w=401wt.eu-S1755347AbYCZOQo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755347AbYCZOQo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Mar 2008 10:16:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751324AbYCZOQg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Mar 2008 10:16:36 -0400
Received: from gir.skynet.ie ([193.1.99.77]:33185 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750717AbYCZOQf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Mar 2008 10:16:35 -0400
Date: Wed, 26 Mar 2008 14:16:32 +0000
From: Mel Gorman <mel@csn.ul.ie>
To: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: Daniel Yeisley <dan.yeisley@unisys.com>, linux-kernel@vger.kernel.org,
       akpm@osdl.org, Christoph Lameter <clameter@sgi.com>
Subject: Re: [PATCH] list_add corruption in slab.c
Message-ID: <20080326141632.GA2672@csn.ul.ie>
References: <1206464258.13473.11.camel@localhost.localdomain> <84144f020803251145m6672e0acv16d27aaae1acb4d9@mail.gmail.com> <1206477858.8810.3.camel@localhost.localdomain> <47E96B0A.2010906@cs.helsinki.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <47E96B0A.2010906@cs.helsinki.fi>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On (25/03/08 23:13), Pekka Enberg didst pronounce:
> Hi Daniel,
> 
> Daniel Yeisley wrote:
> >I actually saw that initkmem_list reference, but didn't change it since
> >my original patch fixed my list corruption.  Anyway, I made the changed
> >and tested it.  The system booted fine.
> 
> Yeah, but the second change is needed; otherwise we forget to fix up 
> some of the bootstrap caches.
> 
> > ???Signed-off-by: Dan Yeisley <dan.yeisley@unisys.com>
> 
> Reviewed-by: Pekka Enberg <penberg@cs.helsinki.fi>
> 
> Mel, as this change is related to the memoryless node fix that went in 
> 2.6.24, any chance you'd give this patch a spin on your machines so we 
> can get the fix in 2.6.25 and 2.6.24-stable?
> 

Of course. Tested against 2.6.25-rc5 on normal and memoryless machines
running just kernbench. So far, I have seen no problems.

-- 
Mel Gorman
Part-time Phd Student                          Linux Technology Center
University of Limerick                         IBM Dublin Software Lab
