Return-Path: <linux-kernel-owner+w=401wt.eu-S1761418AbYARM5D@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761418AbYARM5D (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2008 07:57:03 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759157AbYARM4x
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jan 2008 07:56:53 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:49022 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759286AbYARM4w (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2008 07:56:52 -0500
Date: Fri, 18 Jan 2008 13:56:39 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
Cc: tglx@linutronix.de, hpa@zytor.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] x86_64: move select_idle_routine() call after
	detect_ht()
Message-ID: <20080118125639.GQ11044@elte.hu>
References: <478BB226.6090105@ct.jp.nec.com> <20080114190904.GA2288@elte.hu> <478C1475.7060706@ct.jp.nec.com> <20080115132607.GE7025@elte.hu> <478D01E4.8010000@ct.jp.nec.com> <478D02F4.5060704@ct.jp.nec.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <478D02F4.5060704@ct.jp.nec.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
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


* Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com> wrote:

> Move the select_idle_routine() call to after the detect_ht() call at 
> identify_cpu() on 64-bit. This change is for printing the polling idle 
> and HT enabled warning message properly.

thanks, applied.

	Ingo
