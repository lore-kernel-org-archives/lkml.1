Return-Path: <linux-kernel-owner+w=401wt.eu-S1754444AbYAYDRO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754444AbYAYDRO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2008 22:17:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752249AbYAYDQ7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Jan 2008 22:16:59 -0500
Received: from mga01.intel.com ([192.55.52.88]:30878 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752002AbYAYDQ6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2008 22:16:58 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.25,247,1199692800"; 
   d="scan'208";a="507892172"
Subject: Re: [RFC] some page can't be migrated
From: Shaohua Li <shaohua.li@intel.com>
To: Christoph Lameter <clameter@sgi.com>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>, lkml <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <Pine.LNX.4.64.0801241911470.31975@schroedinger.engr.sgi.com>
References: <1201069357.32059.13.camel@sli10-desk.sh.intel.com>
	 <200801251403.23236.nickpiggin@yahoo.com.au>
	 <1201230571.28282.2.camel@sli10-desk.sh.intel.com>
	 <Pine.LNX.4.64.0801241911470.31975@schroedinger.engr.sgi.com>
Content-Type: text/plain
Date: Fri, 25 Jan 2008 11:18:16 +0800
Message-Id: <1201231096.28282.5.camel@sli10-desk.sh.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Thu, 2008-01-24 at 19:12 -0800, Christoph Lameter wrote:
> On Fri, 25 Jan 2008, Shaohua Li wrote:
> 
> > the page is still in lru list. Memory hot remove will try to migrate the
> > page.
> 
> So this is an abandoned page with a refcount that only exists because of 
> fs private data?
Yes, this is what I observed.

> Truncate race?
truncate_complete_page could fail to remove fs private data, this is the
comments say.

Thanks,
Shaohua

