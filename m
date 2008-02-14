Return-Path: <linux-kernel-owner+w=401wt.eu-S934077AbYBNAb3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934077AbYBNAb3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2008 19:31:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934876AbYBNA1M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Feb 2008 19:27:12 -0500
Received: from sj-iport-2.cisco.com ([171.71.176.71]:15626 "EHLO
	sj-iport-2.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934779AbYBNA1I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2008 19:27:08 -0500
To: Ingo Molnar <mingo@elte.hu>
Cc: David Miller <davem@davemloft.net>, linux-kernel@vger.kernel.org
Subject: Re: Strange hang on ia64 with CONFIG_PRINTK_TIME=y
X-Message-Flag: Warning: May contain useful information
References: <adazlu5tlve.fsf@cisco.com>
	<20080212.230156.33759433.davem@davemloft.net>
	<20080213125725.GC6344@elte.hu> <20080213130236.GA8345@elte.hu>
From: Roland Dreier <rdreier@cisco.com>
Date: Wed, 13 Feb 2008 16:26:46 -0800
In-Reply-To: <20080213130236.GA8345@elte.hu> (Ingo Molnar's message of "Wed, 13 Feb 2008 14:02:36 +0100")
Message-ID: <adatzkcs7qx.fsf@cisco.com>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) XEmacs/21.4.21 (linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 14 Feb 2008 00:26:46.0972 (UTC) FILETIME=[487837C0:01C86EA0]
Authentication-Results: sj-dkim-4; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim4002 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 > > so .. how about the patch below? Note that we already had an "early 
 > > bootup" special (the rq->idle check), it's now just made explicit via 
 > > the scheduler_running flag.
 > 
 > the one below even builds. (untested otherwise)

I just tried this... it doesn't work on top of current git (same
behavior: hang before the kernel prints anything).

I also tried reverting 19ef9309 on top of a checkout of the tree state
at 19ef9309, and that hung before printing anything too.

 - R.

