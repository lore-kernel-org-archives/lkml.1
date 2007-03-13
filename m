Return-Path: <linux-kernel-owner+w=401wt.eu-S932437AbXCMTBB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932437AbXCMTBB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2007 15:01:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932583AbXCMTBA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Mar 2007 15:01:00 -0400
Received: from extu-mxob-2.symantec.com ([216.10.194.135]:19093 "EHLO
	extu-mxob-2.symantec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932437AbXCMTBA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2007 15:01:00 -0400
X-AuditID: d80ac287-9edd6bb000000de9-ea-45f6f4eb1d6a 
Date: Tue, 13 Mar 2007 19:00:59 +0000 (GMT)
From: Hugh Dickins <hugh@veritas.com>
X-X-Sender: hugh@blonde.wat.veritas.com
To: Alan Stern <stern@rowland.harvard.edu>
cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       Oliver Neukum <oneukum@suse.de>, Maneesh Soni <maneesh@in.ibm.com>,
       gregkh@suse.de, Richard Purdie <rpurdie@rpsys.net>,
       James Bottomley <James.Bottomley@SteelEye.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Kernel development list <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.21-rc suspend regression: sysfs deadlock
In-Reply-To: <Pine.LNX.4.44L0.0703131046030.2509-100000@iolanthe.rowland.org>
Message-ID: <Pine.LNX.4.64.0703131854130.6506@blonde.wat.veritas.com>
References: <Pine.LNX.4.44L0.0703131046030.2509-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-OriginalArrivalTime: 13 Mar 2007 19:00:59.0029 (UTC) FILETIME=[EFC71450:01C765A1]
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 13 Mar 2007, Alan Stern wrote:
> 
> The consensus is that we would be better off keeping Oliver's original 
> patch without your silly change, and instead fixing the particular method 
> call that deadlocked.  Can you please try out the patch below with 
> everything else as it was before?  It should solve your problem.

Yep, it works fine with your patch in and my silly reverted, thanks.
But (I was about to say, even before seeing Cornelia's reply, honest!)
I think you do need to check (audit the source? or is some runtime
check possible?) for other such "suicidal" sysfs files, which
seemed to (sysfs-ignorant) me to pose the real problem.

Hugh
