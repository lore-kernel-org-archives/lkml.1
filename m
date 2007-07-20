Return-Path: <linux-kernel-owner+w=401wt.eu-S1759278AbXGTDM4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759278AbXGTDM4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2007 23:12:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752425AbXGTDMu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jul 2007 23:12:50 -0400
Received: from byss.tchmachines.com ([208.76.80.75]:59525 "EHLO
	byss.tchmachines.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751306AbXGTDMt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2007 23:12:49 -0400
Date: Thu, 19 Jul 2007 20:12:44 -0700
From: Ravikiran G Thirumalai <kiran@scalex86.org>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org, shai@scalex86.org
Subject: Re: [patch] Change softlockup trigger limit using a kernel	parameter
Message-ID: <20070720031244.GA5990@localdomain>
References: <20070716222650.GA5947@localdomain> <20070718160858.75865461.akpm@linux-foundation.org> <20070719054121.GA15074@localdomain> <20070718230907.741ae56c.akpm@linux-foundation.org> <20070719091142.GA28723@elte.hu> <20070719183129.GB20298@localdomain> <20070719184536.GB10940@elte.hu> <469FB2A2.8040403@goop.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <469FB2A2.8040403@goop.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - byss.tchmachines.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - scalex86.org
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 19, 2007 at 11:51:14AM -0700, Jeremy Fitzhardinge wrote:
>Ingo Molnar wrote:
>> just in case someone sees false positives and wants to turn it off.
>
>Why not make 0=off?

A patch to disable softlockup during boot already went in.
http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=97842216b8400fe9d1a20468959e2989180f8f79

It uses kernel boot parameter to disable softlockup, not exactly disabling
softlockup at run time though.  Do we still need 0=off?

Thanks,
Kiran
