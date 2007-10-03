Return-Path: <linux-kernel-owner+w=401wt.eu-S1756909AbXJCCWh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756909AbXJCCWh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Oct 2007 22:22:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753528AbXJCCWa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Oct 2007 22:22:30 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:49478 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753003AbXJCCW3 (ORCPT
	<rfc822;@relay.sgi.com:linux-kernel@vger.kernel.org>);
	Tue, 2 Oct 2007 22:22:29 -0400
Date: Wed, 3 Oct 2007 12:22:05 +1000
From: David Chinner <dgc@sgi.com>
To: Fengguang Wu <wfg@mail.ustc.edu.cn>
Cc: David Chinner <dgc@sgi.com>, Andrew Morton <akpm@osdl.org>,
       linux-kernel@vger.kernel.org, Ken Chen <kenchen@google.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Michael Rubin <mrubin@google.com>
Subject: Re: [PATCH 4/5] writeback: remove pages_skipped accounting in __block_write_full_page()
Message-ID: <20071003022205.GK23367404@sgi.com>
References: <20071002084143.110486039@mail.ustc.edu.cn> <20071002090254.873023041@mail.ustc.edu.cn> <20071002215518.GK995458@sgi.com> <20071003014333.GB6501@mail.ustc.edu.cn>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071003014333.GB6501@mail.ustc.edu.cn>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 03, 2007 at 09:43:33AM +0800, Fengguang Wu wrote:
> On Wed, Oct 03, 2007 at 07:55:18AM +1000, David Chinner wrote:
> > > 
> > > do not quite agree with each other. The page writeback should be skipped for
> > > 'locked buffer', but here it is 'clean buffer'!
> > 
> > Ok, so that means we need an equivalent fix in xfs_start_page_writeback()
> > as it will skip pages with clean buffers just like this. Something like
> > this (untested)?
> 
> Sure OK - as long as it is 'no write because of clean buffer'.

Yes, that's the case here.

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
