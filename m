Return-Path: <linux-kernel-owner+w=401wt.eu-S2993131AbXDSHJx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2993131AbXDSHJx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Apr 2007 03:09:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2993145AbXDSHJv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Apr 2007 03:09:51 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:40865 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S2993131AbXDSHJb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Apr 2007 03:09:31 -0400
Date: Thu, 19 Apr 2007 09:09:24 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Mike Galbraith <efault@gmx.de>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [Announce] [patch] Modular Scheduler Core and Completely Fair Scheduler [CFS]
Message-ID: <20070419070921.GA28528@elte.hu>
References: <20070418055525.GS11115@waste.org> <alpine.LFD.0.98.0704180742470.2828@woody.linux-foundation.org> <20070418152355.GU11115@waste.org> <alpine.LFD.0.98.0704181012470.2828@woody.linux-foundation.org> <20070418174945.GA7930@elte.hu> <20070418175936.GA11980@elte.hu> <alpine.LFD.0.98.0704181223190.2828@woody.linux-foundation.org> <Pine.LNX.4.64.0704181304250.25880@alien.or.mcafeemobile.com> <20070418214816.GA10902@elte.hu> <1176965560.6408.60.camel@Homer.simpson.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1176965560.6408.60.camel@Homer.simpson.net>
User-Agent: Mutt/1.4.2.2i
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.0.3
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Mike Galbraith <efault@gmx.de> wrote:

> With a heavily reniced X (perfectly fine), that should indeed solve my 
> daily usage pattern nicely (always need godmode for shells, but not 
> for mozilla and ilk. 50/50 split automatic without renice of entire 
> gui)

how about the first-approximation solution i suggested in the previous 
mail: to add a per UID default nice level? (With this default defaulting 
to '-10' for all root-owned processes, and defaulting to '0' for 
everything else.) That would solve most of the current CFS regressions 
at hand.

	Ingo
