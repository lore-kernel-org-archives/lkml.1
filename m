Return-Path: <linux-kernel-owner+w=401wt.eu-S1759479AbYHOOeF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759479AbYHOOeF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Aug 2008 10:34:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755841AbYHOOdz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Aug 2008 10:33:55 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:54723 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754436AbYHOOdy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Aug 2008 10:33:54 -0400
Date: Fri, 15 Aug 2008 16:33:38 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Li Zefan <lizf@cn.fujitsu.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86: remove nesting CONFIG_HOTPLUG_CPU
Message-ID: <20080815143338.GG12954@elte.hu>
References: <489676EE.8000505@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <489676EE.8000505@cn.fujitsu.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.1
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.1 required=5.9 tests=BAYES_05 autolearn=no SpamAssassin version=3.2.3
	-1.1 BAYES_05               BODY: Bayesian spam probability is 1 to 5%
	[score: 0.0365]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Li Zefan <lizf@cn.fujitsu.com> wrote:

> prefill_possible_map() is defined inside CONFIG_HOTPLUG_CPU, so the 
> nesting CONFIG_HOTPLUG_CPU is just redundant.

applied to tip/x86/cleanups - thanks.

	Ingo
