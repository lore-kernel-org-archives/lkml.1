Return-Path: <linux-kernel-owner+w=401wt.eu-S1759153AbXKNVSW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759153AbXKNVSW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2007 16:18:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754501AbXKNVSM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Nov 2007 16:18:12 -0500
Received: from mgw2.diku.dk ([130.225.96.92]:35268 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754237AbXKNVSL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2007 16:18:11 -0500
Date: Wed, 14 Nov 2007 22:18:07 +0100 (CET)
From: Julia Lawall <julia@diku.dk>
To: Roland Dreier <rdreier@cisco.com>
Cc: rolandd@cisco.com, mshefty@ichips.intel.com, halr@voltaire.com,
       openib-general@openib.org, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org
Subject: Re: [PATCH 3/4] drivers/infiniband: Drop redundant includes of
 moduleparam.h
In-Reply-To: <adalk90zgwz.fsf@cisco.com>
Message-ID: <Pine.LNX.4.64.0711142214120.31186@tyr.diku.dk>
References: <Pine.LNX.4.64.0711132234110.18337@ask.diku.dk> <adalk90zgwz.fsf@cisco.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 14 Nov 2007, Roland Dreier wrote:

> > Drop #include <linux/moduleparam.h> in files that also include #include
> > <linux/module.h>.  module.h includes moduleparam.h already.
>
> Do we want to make this sort of source code change?  I thought that
> the consensus about the kernel was that we wanted to avoid relying of
> implicit includes of <Y.h> by <X.h> -- in this case a better change
> would actually seem to be to explicitly include moduleparam.h in files
> using module parameters and then remove the include from module.h.

Someone else made a similar comment, so it seems reasonable to forget 
about the patches.

I could easily make a patch to go the other way if there is an interest in 
that.  On the other hand, perhaps the concensus is to just leave things 
as they are.

julia

