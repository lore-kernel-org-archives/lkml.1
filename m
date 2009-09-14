Return-Path: <linux-kernel-owner+w=401wt.eu-S1756164AbZINR7o@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756164AbZINR7o (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Sep 2009 13:59:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756110AbZINR7i
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Sep 2009 13:59:38 -0400
Received: from gir.skynet.ie ([193.1.99.77]:58361 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756133AbZINR7h (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Sep 2009 13:59:37 -0400
Date: Mon, 14 Sep 2009 18:59:42 +0100
From: Mel Gorman <mel@csn.ul.ie>
To: Christoph Lameter <cl@linux-foundation.org>
Cc: Zhu Yi <yi.zhu@intel.com>, "Chatre, Reinette" <reinette.chatre@intel.com>,
       Frans Pop <elendil@planet.nl>, Larry Finger <Larry.Finger@lwfinger.net>,
       "John W. Linville" <linville@tuxdriver.com>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
       "ipw3945-devel@lists.sourceforge.net" 
	<ipw3945-devel@lists.sourceforge.net>,
       Andrew Morton <akpm@linux-foundation.org>,
       "Krauss, Assaf" <assaf.krauss@intel.com>,
       Johannes Berg <johannes@sipsolutions.net>,
       "Abbas, Mohamed" <mohamed.abbas@intel.com>
Subject: Re: iwlagn: order 2 page allocation failures
Message-ID: <20090914175942.GH11778@csn.ul.ie>
References: <4AA67139.80301@lwfinger.net> <20090909150418.GI24614@csn.ul.ie> <200909091759.33655.elendil@planet.nl> <20090909165545.GK24614@csn.ul.ie> <1252526738.30150.91.camel@rc-desk> <20090910090206.GA22276@csn.ul.ie> <1252617290.30150.321.camel@rc-desk> <20090911084717.GB32497@csn.ul.ie> <1252897270.5650.169.camel@debian> <alpine.DEB.1.10.0909141141200.24447@V090114053VZO-1>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <alpine.DEB.1.10.0909141141200.24447@V090114053VZO-1>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 14, 2009 at 11:42:15AM -0400, Christoph Lameter wrote:
> On Mon, 14 Sep 2009, Zhu Yi wrote:
> 
> > BTW, does SLAB/SLUB guarantee size of multiple PAGE_SIZE __kmalloc()
> > allocation align on PAGE_SIZE (or 256 bytes) boundary?
> 
> Page allocators guarantee page aligned data. Slab allocators do not.
> 
> You can create a slab that aligns objects on 256 byte boundary if you
> want.
> 

The allocation of buffers >= PAGE_SIZE even when allocated with
kmalloc() are page-aligned though right? It's not an explicit guarantee
but is it not always the case?

-- 
Mel Gorman
Part-time Phd Student                          Linux Technology Center
University of Limerick                         IBM Dublin Software Lab
