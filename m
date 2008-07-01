Return-Path: <linux-kernel-owner+w=401wt.eu-S1761149AbYGAW2o@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761149AbYGAW2o (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2008 18:28:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755116AbYGAW2f
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Jul 2008 18:28:35 -0400
Received: from mga09.intel.com ([134.134.136.24]:16235 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754800AbYGAW2e (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2008 18:28:34 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.27,733,1204531200"; 
   d="scan'208";a="301647885"
Subject: Re: [problem] raid performance loss with 2.6.26-rc8 on 32-bit x86
	(bisected)
From: Dan Williams <dan.j.williams@intel.com>
To: Mel Gorman <mel@csn.ul.ie>
Cc: Andy Whitcroft <apw@shadowen.org>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org, NeilBrown <neilb@suse.de>,
       babydr@baby-dragons.com, cl@linux-foundation.org,
       lee.schermerhorn@hp.com
In-Reply-To: <20080701190741.GB16501@csn.ul.ie>
References: <1214877439.7885.40.camel@dwillia2-linux.ch.intel.com>
	 <20080701080910.GA10865@csn.ul.ie> <20080701175855.GI32727@shadowen.org>
	 <20080701190741.GB16501@csn.ul.ie>
Content-Type: text/plain
Date: Tue, 01 Jul 2008 15:28:32 -0700
Message-Id: <1214951312.26855.26.camel@dwillia2-linux.ch.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-5.fc8) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Tue, 2008-07-01 at 12:07 -0700, Mel Gorman wrote:
> This looks kinda promising and depends heavily on how this patch was
> tested in isolation. Dan, can you post the patch you use on 2.6.25
> because the commit in question should not have applied cleanly please?

?

I have not tested this patch (54a6eb5c) in isolation.  The patch that
was applied to 2.6.25 was the raid5 performance enhancement patch.  It
is no longer in the equation since the problem is reproducible with
stock raid0.

--
Dan

