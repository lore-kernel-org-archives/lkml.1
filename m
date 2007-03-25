Return-Path: <linux-kernel-owner+w=401wt.eu-S964790AbXCYCCq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964790AbXCYCCq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Mar 2007 22:02:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964817AbXCYCAp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 24 Mar 2007 22:00:45 -0400
Received: from sj-iport-3-in.cisco.com ([171.71.176.72]:12350 "EHLO
	sj-iport-3.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964806AbXCYCAf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Mar 2007 22:00:35 -0400
To: Greg KH <gregkh@suse.de>
Cc: "Kok, Auke" <auke-jan.h.kok@intel.com>,
       "Williams, Mitch A" <mitch.a.williams@intel.com>,
       linux-kernel@vger.kernel.org, mingo@redhat.com,
       "Ronciak, John" <john.ronciak@intel.com>,
       "Brandeburg, Jesse" <jesse.brandeburg@intel.com>
Subject: Re: [PATCH 2.6.20.3] Flush writes to MSI-X table
X-Message-Flag: Warning: May contain useful information
References: <20070323222207.GB22500@suse.de>
	<08FE5CC30C9A3F41BF819A502CF7BF6EF55DD2@fmsmsx411.amr.corp.intel.com>
	<20070324002802.GA18061@suse.de> <20070324003030.GA18615@suse.de>
	<4605B555.3020107@intel.com> <20070324234154.GA10057@suse.de>
From: Roland Dreier <rdreier@cisco.com>
Date: Sat, 24 Mar 2007 19:00:32 -0700
In-Reply-To: <20070324234154.GA10057@suse.de> (Greg KH's message of "Sat, 24 Mar 2007 16:41:54 -0700")
Message-ID: <adak5x6m69r.fsf@cisco.com>
User-Agent: Gnus/5.1007 (Gnus v5.10.7) XEmacs/21.4.19 (linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 25 Mar 2007 02:00:33.0044 (UTC) FILETIME=[5F342D40:01C76E81]
Authentication-Results: sj-dkim-1; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim1004 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

 > I don't understand your need to try to rush an api change like this in
 > so quickly in an area that has a lot of churn and disagreement lately.
 > _Especially_ so late in the release cycle, and with no hardware publicly
 > availble.

I'm not sure I understood this thread properly, but if I did understand
correctly then this bug affects IRQ balancing on any device with MSI-X
enabled.  In which case, there's plenty of publicly available hardware
with MSI-X support (including drivers in the mainline tree for a long
time).  A quick grep for pci_enable_msix finds plenty of drivers using
MSI-X now: cciss, ib_mthca, cxgb3, forcedeth, s2io, qla2xxx.

 - R.
