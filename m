Return-Path: <linux-kernel-owner+w=401wt.eu-S1754907AbYCUKo1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754907AbYCUKo1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Mar 2008 06:44:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753469AbYCUKoU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Mar 2008 06:44:20 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:57645 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752570AbYCUKoT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Mar 2008 06:44:19 -0400
Date: Fri, 21 Mar 2008 11:44:02 +0100
From: Ingo Molnar <mingo@elte.hu>
To: yhlu.kernel@gmail.com
Cc: Andrew Morton <akpm@linux-foundation.org>,
       "H. Peter Anvin" <hpa@zytor.com>, steve@lobefin.net,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       kernel list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86: trim mtrr don't close gap for resource allocation.
Message-ID: <20080321104402.GP20420@elte.hu>
References: <200803181237.33861.yhlu.kernel@gmail.com> <200803181255.10402.yhlu.kernel@gmail.com> <200803181644.20356.yhlu.kernel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200803181644.20356.yhlu.kernel@gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.1
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.1 required=5.9 tests=BAYES_05 autolearn=no SpamAssassin version=3.2.3
	-1.1 BAYES_05               BODY: Bayesian spam probability is 1 to 5%
	[score: 0.0236]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Yinghai Lu <yhlu.kernel.send@gmail.com> wrote:

> [PATCH] x86: trim mtrr don't close gap for resource allocation.
> 
> for
> 	http://bugzilla.kernel.org/show_bug.cgi?id=10232
> 
> use update_memory_range instead of add_memory_range directly to avoid 
> closing that gap.

thanks Yinghai, applied, and queued up for 2.6.25.

	Ingo
