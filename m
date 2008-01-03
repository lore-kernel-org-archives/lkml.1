Return-Path: <linux-kernel-owner+w=401wt.eu-S1755486AbYACVet@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755486AbYACVet (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jan 2008 16:34:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752519AbYACVem
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Jan 2008 16:34:42 -0500
Received: from sj-iport-3-in.cisco.com ([171.71.176.72]:7084 "EHLO
	sj-iport-3.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752781AbYACVel (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jan 2008 16:34:41 -0500
X-IronPort-AV: E=Sophos;i="4.24,240,1196668800"; 
   d="scan'208";a="17022621"
To: David Dillow <dillowda@ornl.gov>
Cc: torvalds@linux-foundation.org, general@lists.openfabrics.org,
       linux-kernel@vger.kernel.org
Subject: Re: [GIT PULL] please pull infiniband.git for-linus
X-Message-Flag: Warning: May contain useful information
References: <adak5mqu5i8.fsf@cisco.com>
	<1199385590.7561.11.camel@lap75545.ornl.gov>
	<adafxxeu495.fsf@cisco.com>
	<1199391187.7561.38.camel@lap75545.ornl.gov>
	<1199391609.7561.46.camel@lap75545.ornl.gov>
From: Roland Dreier <rdreier@cisco.com>
Date: Thu, 03 Jan 2008 13:34:24 -0800
In-Reply-To: <1199391609.7561.46.camel@lap75545.ornl.gov> (David Dillow's message of "Thu, 03 Jan 2008 15:20:09 -0500")
Message-ID: <ada3atetwyn.fsf@cisco.com>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) XEmacs/21.4.20 (linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 03 Jan 2008 21:34:24.0876 (UTC) FILETIME=[6929DAC0:01C84E50]
Authentication-Results: sj-dkim-3; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim3002 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 > @@ -423,8 +423,8 @@ static void srp_remove_work(struct work_struct *work)
 >  	list_del(&target->list);
 >  	spin_unlock(&target->srp_host->target_lock);
 >  
 > -	srp_remove_host(target->scsi_host);
 >  	scsi_remove_host(target->scsi_host);
 > +	srp_remove_host(target->scsi_host);

Thanks... I just confirmed (by crashing my system) that either this
change or the fix to the srp transport class is needed too.  I think
we have time before 2.6.24 final to get the right fix in, so I'll wait
until tomorrow before asking Linus to pull this.

 - R.

