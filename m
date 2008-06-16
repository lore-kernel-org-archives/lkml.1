Return-Path: <linux-kernel-owner+w=401wt.eu-S1758925AbYFPIKD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758925AbYFPIKD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2008 04:10:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760780AbYFPIJp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Jun 2008 04:09:45 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:33212 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760752AbYFPIJm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2008 04:09:42 -0400
Date: Mon, 16 Jun 2008 10:09:20 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Yinghai Lu <yhlu.kernel@gmail.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Ying Huang <ying.huang@intel.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86: use add_highpages_with_active_regions for high
	pages init v2
Message-ID: <20080616080920.GB12141@elte.hu>
References: <200806132005.45836.yhlu.kernel@gmail.com> <200806140056.32601.yhlu.kernel@gmail.com> <200806141832.53668.yhlu.kernel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200806141832.53668.yhlu.kernel@gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Yinghai Lu <yhlu.kernel@gmail.com> wrote:

> use early_node_map to init high pages, so can remove page_is_ram and 
> page_is_reserved_early in the big loop with add_one_highpage
> 
> also remove the page_is_reserved_early that is not needed.
> 
> v2: fix other platform compiling

applied to tip/x86/mpparse, thanks.

	Ingo
