Return-Path: <linux-kernel-owner+w=401wt.eu-S932420Ab0AFR35@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932420Ab0AFR35 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jan 2010 12:29:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932194Ab0AFR34
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jan 2010 12:29:56 -0500
Received: from gir.skynet.ie ([193.1.99.77]:35979 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932244Ab0AFR34 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jan 2010 12:29:56 -0500
Date: Wed, 6 Jan 2010 17:29:45 +0000
From: Mel Gorman <mel@csn.ul.ie>
To: Adam Litke <agl@us.ibm.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>,
       Christoph Lameter <cl@linux-foundation.org>,
       Avi Kivity <avi@redhat.com>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org
Subject: Re: [PATCH 2/7] Export unusable free space index via
	/proc/pagetypeinfo
Message-ID: <20100106172945.GA5426@csn.ul.ie>
References: <1262795169-9095-1-git-send-email-mel@csn.ul.ie> <1262795169-9095-3-git-send-email-mel@csn.ul.ie> <1262797848.3579.8.camel@aglitke>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <1262797848.3579.8.camel@aglitke>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 06, 2010 at 11:10:48AM -0600, Adam Litke wrote:
> On Wed, 2010-01-06 at 16:26 +0000, Mel Gorman wrote:
> > +/*
> > + * Return an index indicating how much of the available free memory is
> > + * unusable for an allocation of the requested size.
> > + */
> > +int unusable_free_index(struct zone *zone,
> > +				unsigned int order,
> > +				struct config_page_info *info)
> > +{
> > +	/* No free memory is interpreted as all free memory is unusable */
> > +	if (info->free_pages == 0)
> > +		return 100;
> 
> Should the above be 1000?
> 

Yes. Fortunately, the value is not actually used by any of the code.
It's for consumption by people or tools.

Thanks

-- 
Mel Gorman
Part-time Phd Student                          Linux Technology Center
University of Limerick                         IBM Dublin Software Lab
