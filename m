Return-Path: <linux-kernel-owner+w=401wt.eu-S1754656AbXEGRsg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754656AbXEGRsg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 May 2007 13:48:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754654AbXEGRse
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 May 2007 13:48:34 -0400
Received: from mga03.intel.com ([143.182.124.21]:33336 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754606AbXEGRsd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 May 2007 13:48:33 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.14,502,1170662400"; 
   d="scan'208";a="225303391"
Date: Mon, 7 May 2007 10:46:08 -0700
From: "Siddha, Suresh B" <suresh.b.siddha@intel.com>
To: Christoph Lameter <clameter@sgi.com>
Cc: "Siddha, Suresh B" <suresh.b.siddha@intel.com>,
       "Yu, Fenghua" <fenghua.yu@intel.com>, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/2] Add percpu smp cacheline align section
Message-ID: <20070507174608.GB21638@linux-os.sc.intel.com>
References: <33E1C72C74DBE747B7B59C1740F7443701A2F0AB@orsmsx417.amr.corp.intel.com> <20070505001222.GA26142@linux-os.sc.intel.com> <Pine.LNX.4.64.0705050951040.27326@schroedinger.engr.sgi.com> <20070507171129.GA21638@linux-os.sc.intel.com> <Pine.LNX.4.64.0705071029470.5447@schroedinger.engr.sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0705071029470.5447@schroedinger.engr.sgi.com>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 07, 2007 at 10:30:16AM -0700, Christoph Lameter wrote:
> Call this area "cpu shared" or so?

Sure. cacheline_algined_in_smp was sort of indicating this. But this
name is short and also will clear the confusion.

But this still need to tap into per cpu infrastructure, so that the
new area can be allocated for each cpu during boot time..

thanks,
suresh
