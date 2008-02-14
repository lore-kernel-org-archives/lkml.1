Return-Path: <linux-kernel-owner+w=401wt.eu-S934437AbYBNATT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934437AbYBNATT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2008 19:19:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763122AbYBNATI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Feb 2008 19:19:08 -0500
Received: from vms040pub.verizon.net ([206.46.252.40]:60884 "EHLO
	vms040pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762125AbYBNATH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2008 19:19:07 -0500
Date: Wed, 13 Feb 2008 18:19:02 -0600
From: Corey Minyard <minyard@acm.org>
Subject: Re: [PATCH 7/8] IPMI: convert locked counters to atomics
In-reply-to: <20080213152645.9e589d0c.akpm@linux-foundation.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, openipmi-developer@lists.sourceforge.net
Message-id: <47B388F6.8040202@acm.org>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
References: <20080213163220.GG9830@minyard.local>
 <20080213152645.9e589d0c.akpm@linux-foundation.org>
User-Agent: Icedove 1.5.0.14pre (X11/20071018)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> The code forgot to initialise all of these.
>
> It just so happens that the all-bits-zero pattern works correctly for all
> current architectures, so the code should work OK.  But there is no reason
> (I hope) why an architecture cannot implement atomic_t as
>
> struct atomic_t {
> 	int counter;
> 	spinlock_t lock;
> };
>
> in which case the results of ATOMIC_INIT() may _not_ be all-zeroes, in
> which case the code will deadlock.
>
> So.  It works, but it's grubby.   Do you still wish to proceed?
>   
Thanks.  Don't proceed for now, I'll work up new patches.

-corey

