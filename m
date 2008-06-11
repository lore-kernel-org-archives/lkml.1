Return-Path: <linux-kernel-owner+w=401wt.eu-S1756882AbYFKJjT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756882AbYFKJjT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2008 05:39:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753985AbYFKJiv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jun 2008 05:38:51 -0400
Received: from gw-colo-pa.panasas.com ([66.238.117.130]:26498 "EHLO
	cassoulet.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753836AbYFKJiu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2008 05:38:50 -0400
Message-ID: <484F98C5.3040202@panasas.com>
Date: Wed, 11 Jun 2008 12:20:05 +0300
From: Boaz Harrosh <bharrosh@panasas.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Adrian Bunk <bunk@kernel.org>
CC: Greg KH <greg@kroah.com>, linux-kernel@vger.kernel.org,
       David Woodhouse <dwmw2@infradead.org>,
       James Bottomley <James.Bottomley@HansenPartnership.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [2.6 patch] always enable FW_LOADER unless EMBEDDED=y
References: <20080610160408.GB11685@cs181133002.pp.htv.fi> <20080610162450.GB13538@kroah.com> <20080610181206.GF11685@cs181133002.pp.htv.fi> <20080610212859.GB26249@kroah.com> <20080611082320.GM11685@cs181133002.pp.htv.fi>
In-Reply-To: <20080611082320.GM11685@cs181133002.pp.htv.fi>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 11 Jun 2008 09:20:09.0743 (UTC) FILETIME=[585A09F0:01C8CBA4]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adrian Bunk wrote:
> 
> [1] and before anyone restarts the "kconfig is broken - select should 
>     follow dependencies" FUD: I've seen much talk and zero code for
>     this, and in my opinion the problem is much more difficult than
>     it appears at first sight
> 

I had this crazy idea, Perhaps it would be easier to reverse the problem.
Introduce a kind of Lazy_Enable mode. Which means config is enabled but
gets it's use_count bumped up every time someone is dependent on it.
At the end, for optimization, any Lazy_Enable with zero count, is dropped.
Is that at all possible in current infrastructure?
(I admit I never looked at the source)

Boaz
