Return-Path: <linux-kernel-owner+w=401wt.eu-S1754439AbZIJVOt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754439AbZIJVOt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Sep 2009 17:14:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753613AbZIJVOs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Sep 2009 17:14:48 -0400
Received: from mga02.intel.com ([134.134.136.20]:21311 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752979AbZIJVOr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Sep 2009 17:14:47 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.44,366,1249282800"; 
   d="scan'208";a="447510972"
Subject: Re: iwlagn: order 2 page allocation failures
From: reinette chatre <reinette.chatre@intel.com>
To: Mel Gorman <mel@csn.ul.ie>
Cc: Frans Pop <elendil@planet.nl>, Larry Finger <Larry.Finger@lwfinger.net>,
       "John W. Linville" <linville@tuxdriver.com>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
       "ipw3945-devel@lists.sourceforge.net" 
	<ipw3945-devel@lists.sourceforge.net>,
       Andrew Morton <akpm@linux-foundation.org>,
       "cl@linux-foundation.org" <cl@linux-foundation.org>,
       "Krauss, Assaf" <assaf.krauss@intel.com>,
       Johannes Berg <johannes@sipsolutions.net>,
       "Abbas, Mohamed" <mohamed.abbas@intel.com>
In-Reply-To: <20090910090206.GA22276@csn.ul.ie>
References: <200909060941.01810.elendil@planet.nl>
	 <4AA67139.80301@lwfinger.net> <20090909150418.GI24614@csn.ul.ie>
	 <200909091759.33655.elendil@planet.nl> <20090909165545.GK24614@csn.ul.ie>
	 <1252526738.30150.91.camel@rc-desk>  <20090910090206.GA22276@csn.ul.ie>
Content-Type: text/plain
Date: Thu, 10 Sep 2009 14:14:50 -0700
Message-Id: <1252617290.30150.321.camel@rc-desk>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-09-10 at 02:02 -0700, Mel Gorman wrote:

> 
> As a total aside, there is still the problem that the driver is depending on
> order-2 allocations. On systems without swap, the allocation problem could be
> more severe as there are fewer pages the system can use to regain contiguity.

I looked more at the implementation and hardware interface but I do not
see a way around this. We have to provide 8k buffer to device, and we
have to make sure it is aligned. 

Do you have any suggestions?

Reinette

