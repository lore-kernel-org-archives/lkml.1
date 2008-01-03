Return-Path: <linux-kernel-owner+w=401wt.eu-S1755789AbYACVde@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755789AbYACVde (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jan 2008 16:33:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752823AbYACVdZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Jan 2008 16:33:25 -0500
Received: from sj-iport-3-in.cisco.com ([171.71.176.72]:32441 "EHLO
	sj-iport-3.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752793AbYACVdX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jan 2008 16:33:23 -0500
X-IronPort-AV: E=Sophos;i="4.24,240,1196668800"; 
   d="scan'208";a="17022060"
To: David Dillow <dave@thedillows.org>
Cc: FUJITA Tomonori <tomof@acm.org>, fujita.tomonori@lab.ntt.co.jp,
       linux-kernel@vger.kernel.org, general@lists.openfabrics.org
Subject: Re: [ofa-general] Re: list corruption on ib_srp load in v2.6.24-rc5
X-Message-Flag: Warning: May contain useful information
References: <20071223014407L.tomof@acm.org>
	<1198689251.25003.2.camel@lap75545.ornl.gov>
	<adaprwkundh.fsf@cisco.com> <20080103173330T.tomof@acm.org>
	<1199390957.7561.33.camel@lap75545.ornl.gov>
	<1199393485.7561.51.camel@lap75545.ornl.gov>
From: Roland Dreier <rdreier@cisco.com>
Date: Thu, 03 Jan 2008 13:33:14 -0800
In-Reply-To: <1199393485.7561.51.camel@lap75545.ornl.gov> (David Dillow's message of "Thu, 03 Jan 2008 15:51:25 -0500")
Message-ID: <ada7iiqtx0l.fsf@cisco.com>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) XEmacs/21.4.20 (linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 03 Jan 2008 21:33:15.0139 (UTC) FILETIME=[3F98D530:01C84E50]
Authentication-Results: sj-dkim-3; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim3002 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 > +	if (scsi_is_srp_rport(dev))
 > +		srp_rport_del(dev_to_rport(dev));

This has the ring of truth to me as the right fix, although I
certainly don't know the details of this code... Fujita-san?

 - R.
