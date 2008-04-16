Return-Path: <linux-kernel-owner+w=401wt.eu-S1763691AbYDPOEu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763691AbYDPOEu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2008 10:04:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754824AbYDPOEn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Apr 2008 10:04:43 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:57451 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754655AbYDPOEm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2008 10:04:42 -0400
Date: Wed, 16 Apr 2008 16:04:31 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Mel Gorman <mel@csn.ul.ie>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/4] Add a basic debugging framework for memory
	initialisation
Message-ID: <20080416140431.GD24383@elte.hu>
References: <20080416135058.1346.65546.sendpatchset@skynet.skynet.ie> <20080416135118.1346.72244.sendpatchset@skynet.skynet.ie>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080416135118.1346.72244.sendpatchset@skynet.skynet.ie>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: 0.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=0.0 required=5.9 tests=none autolearn=no SpamAssassin version=3.2.3
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Mel Gorman <mel@csn.ul.ie> wrote:

> +static __init int set_mminit_debug_level(char *str)
> +{
> +	get_option(&str, &mminit_debug_level);
> +	return 0;
> +}
> +early_param("mminit_debug_level", set_mminit_debug_level);

another small suggestion: could you please also add a Kconfig method of 
enabling it, dependent on KERNEL_DEBUG, default-off (for now). The best 
would be not a numeric switch but something that gets randomized by 
"make randconfig". I.e. an on/off switch kind of things.

	Ingo
