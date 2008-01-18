Return-Path: <linux-kernel-owner+w=401wt.eu-S1761286AbYARM4g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761286AbYARM4g (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2008 07:56:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758586AbYARM4a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jan 2008 07:56:30 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:48761 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758323AbYARM43 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2008 07:56:29 -0500
Date: Fri, 18 Jan 2008 13:56:13 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
Cc: tglx@linutronix.de, hpa@zytor.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] x86: move warning message of polling idle and HT
	enabled
Message-ID: <20080118125613.GP11044@elte.hu>
References: <478BB226.6090105@ct.jp.nec.com> <20080114190904.GA2288@elte.hu> <478C1475.7060706@ct.jp.nec.com> <20080115132607.GE7025@elte.hu> <478D01E4.8010000@ct.jp.nec.com> <478D0298.9060103@ct.jp.nec.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <478D0298.9060103@ct.jp.nec.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.1
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.1 required=5.9 tests=BAYES_05 autolearn=no SpamAssassin version=3.2.3
	-1.1 BAYES_05               BODY: Bayesian spam probability is 1 to 5%
	[score: 0.0346]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com> wrote:

> The warning message at idle_setup() is never shown because 
> smp_num_sibling hasn't been updated at this point yet.
> 
> Move this polling idle and HT enabled warning to 
> select_idle_routine(). I also implement this warning on 64-bit kernel.

thanks, applied.

	Ingo
