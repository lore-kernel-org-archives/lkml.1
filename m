Return-Path: <linux-kernel-owner+w=401wt.eu-S1755111AbXJBS1U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755111AbXJBS1U (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Oct 2007 14:27:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753331AbXJBS1H
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Oct 2007 14:27:07 -0400
Received: from sj-iport-6.cisco.com ([171.71.176.117]:64666 "EHLO
	sj-iport-6.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753000AbXJBS1E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Oct 2007 14:27:04 -0400
X-IronPort-AV: E=Sophos;i="4.21,221,1188802800"; 
   d="scan'208";a="229131820"
To: "Sean Hefty" <sean.hefty@intel.com>
Cc: <general@lists.openfabrics.org>, <linux-kernel@vger.kernel.org>,
       <netdev@vger.kernel.org>
Subject: Re: [ofa-general] InfiniBand/RDMA merge plans for 2.6.24
X-Message-Flag: Warning: May contain useful information
References: <adahclymos8.fsf@cisco.com>
	<000401c7f632$c993e8e0$65cc180a@amr.corp.intel.com>
	<adatzpyl1mm.fsf@cisco.com>
	<000001c7f6f7$074584e0$9c98070a@amr.corp.intel.com>
From: Roland Dreier <rdreier@cisco.com>
Date: Tue, 02 Oct 2007 11:26:53 -0700
In-Reply-To: <000001c7f6f7$074584e0$9c98070a@amr.corp.intel.com> (Sean Hefty's message of "Fri, 14 Sep 2007 10:45:23 -0700")
Message-ID: <adaprzxgyoi.fsf@cisco.com>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) XEmacs/21.4.20 (linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 02 Oct 2007 18:26:54.0054 (UTC) FILETIME=[CEBBE860:01C80521]
Authentication-Results: sj-dkim-1; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim1004 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

 > >OK -- just to make sure I'm understanding what you're saying: have you
 > >confirmed that your proposed [CM MRA] patches actually fix the issue?
 > 
 > Not directly.  I cannot easily test kernel patches on our larger, production
 > clusters.  We've seen the issue with specific applications on 512 and 1024
 > cores, but I've only been able to test the patch on a 48-core cluster.  I have
 > verified that it successfully increases the timeout to where it *should* work,
 > but cannot absolutely confirm that it will fix the problem.  I'm unlikely to
 > know that until the production clusters move to an OFED release (1.3?)
 > containing this patch.

Umm... this is a difficult situation for me to merge the changes then.
We're changing the CM retry behavior blind here.  How do we know that
the MRA changes don't make the scalability issue worse?

 - R.
