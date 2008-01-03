Return-Path: <linux-kernel-owner+w=401wt.eu-S1754967AbYACS5Q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754967AbYACS5Q (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jan 2008 13:57:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752258AbYACS5E
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Jan 2008 13:57:04 -0500
Received: from sj-iport-2-in.cisco.com ([171.71.176.71]:25494 "EHLO
	sj-iport-2.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752206AbYACS5D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jan 2008 13:57:03 -0500
X-IronPort-AV: E=Sophos;i="4.24,240,1196668800"; 
   d="scan'208";a="9596522"
To: David Dillow <dillowda@ornl.gov>
Cc: torvalds@linux-foundation.org, general@lists.openfabrics.org,
       linux-kernel@vger.kernel.org
Subject: Re: [GIT PULL] please pull infiniband.git for-linus
X-Message-Flag: Warning: May contain useful information
References: <adak5mqu5i8.fsf@cisco.com>
	<1199385590.7561.11.camel@lap75545.ornl.gov>
From: Roland Dreier <rdreier@cisco.com>
Date: Thu, 03 Jan 2008 10:56:54 -0800
In-Reply-To: <1199385590.7561.11.camel@lap75545.ornl.gov> (David Dillow's message of "Thu, 03 Jan 2008 13:39:50 -0500")
Message-ID: <adafxxeu495.fsf@cisco.com>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) XEmacs/21.4.20 (linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 03 Jan 2008 18:56:54.0820 (UTC) FILETIME=[687DBE40:01C84E3A]
Authentication-Results: sj-dkim-2; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim2002 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 > If we've got time before 2.6.24 final, I'd wait on this a bit.
 > ib_srp:srp_remove_work() has them reversed as well, and I'm currently
 > tracking down why it oopses when the srp_remove_host() happens before
 > the scsi_remove_host(), which is the documented call sequence.

I think the best thing to do is to merge this (assuming that Linus
gets to it), since it looks quite safe and definitely fixes a crash.
Then if we get to the root cause we can change the order of the calls
if it turns out a different fix is required.

 - R.
