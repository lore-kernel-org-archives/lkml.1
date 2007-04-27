Return-Path: <linux-kernel-owner+w=401wt.eu-S1755216AbXD0DMq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755216AbXD0DMq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2007 23:12:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755212AbXD0DMq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Apr 2007 23:12:46 -0400
Received: from sj-iport-5.cisco.com ([171.68.10.87]:26959 "EHLO
	sj-iport-5.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755211AbXD0DMo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2007 23:12:44 -0400
X-IronPort-AV: i="4.14,457,1170662400"; 
   d="scan'208"; a="416154857:sNHT44688932"
To: Steve Wise <swise@opengridcomputing.com>
Cc: jeff@garzik.org, divy@chelsio.com, general@lists.openfabrics.org,
       linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH 2.6.22 5/5] iw_cxgb3: Update required firmware revision to 4.0.0.
X-Message-Flag: Warning: May contain useful information
References: <20070426202057.24234.56383.stgit@dell3.ogc.int>
	<20070426202126.24234.71523.stgit@dell3.ogc.int>
From: Roland Dreier <rdreier@cisco.com>
Date: Thu, 26 Apr 2007 20:12:42 -0700
In-Reply-To: <20070426202126.24234.71523.stgit@dell3.ogc.int> (Steve Wise's message of "Thu, 26 Apr 2007 15:21:26 -0500")
Message-ID: <adaps5qo6hh.fsf@cisco.com>
User-Agent: Gnus/5.1007 (Gnus v5.10.7) XEmacs/21.4.19 (linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 27 Apr 2007 03:12:43.0044 (UTC) FILETIME=[EBB77E40:01C78879]
Authentication-Results: sj-dkim-6; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim6002 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

 > Update required firmware revision to 4.0.0.

Hmm... should we fold this into the earlier patch, which actually
needs this new FW?  Or at least merge this patch first?

Also, is it cool with everyone to require a new FW, even for users who
might not be using (or even building) the RDMA driver?  I'm not sure
what a good solution would be really, so maybe the pain of forcing
everyone to update FW is the least bad thing to do.

 - R.
