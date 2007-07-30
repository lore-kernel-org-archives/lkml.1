Return-Path: <linux-kernel-owner+w=401wt.eu-S938900AbXG3JZe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S938900AbXG3JZe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jul 2007 05:25:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933839AbXG3JZ0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jul 2007 05:25:26 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:33253 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933366AbXG3JZZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jul 2007 05:25:25 -0400
Date: Mon, 30 Jul 2007 11:25:14 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Daniel Walker <dwalker@mvista.com>
Cc: linux-kernel@vger.kernel.org, linux-rt-users@vger.kernel.org
Subject: Re: [PATCH -rt 3/9] Fix jiffies wrap issue in update_times
Message-ID: <20070730092514.GC25640@elte.hu>
References: <20070730024534.369897977@mvista.com> <20070730024719.502748134@mvista.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070730024719.502748134@mvista.com>
User-Agent: Mutt/1.5.14 (2007-02-12)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.1.7-deb
	-1.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Daniel Walker <dwalker@mvista.com> wrote:

> In prior -rt verisons the last_tick value was called wall_jiffies and 
> was initialized in this same way as below. If this value isn't 
> initialized the calc_load function gets skewed for several minutes 
> right after boot up. Skewed meaning always zero.

thanks, applied.

	Ingo
