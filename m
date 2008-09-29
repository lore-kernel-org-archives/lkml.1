Return-Path: <linux-kernel-owner+w=401wt.eu-S1753542AbYI2IGf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753542AbYI2IGf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2008 04:06:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751650AbYI2IGT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Sep 2008 04:06:19 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:39445 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751412AbYI2IGS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2008 04:06:18 -0400
Date: Mon, 29 Sep 2008 10:06:10 +0200
From: Ingo Molnar <mingo@elte.hu>
To: dcg <diegocg@gmail.com>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH] x86_64: be less annoying on boot
Message-ID: <20080929080610.GA18663@elte.hu>
References: <20080924183517.GA24209@nostromo.devel.redhat.com> <20080925091558.GE16734@elte.hu> <20080925161300.GA17162@nostromo.devel.redhat.com> <20080927185027.GB17867@elte.hu> <20080927211131.2e0b60f0@diego-desktop> <20080927191824.GC18619@elte.hu> <20080928184946.47bb63d9@diego-desktop>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20080928184946.47bb63d9@diego-desktop>
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


* dcg <diegocg@gmail.com> wrote:

> El Sat, 27 Sep 2008 21:18:24 +0200, Ingo Molnar <mingo@elte.hu> escribió:
> 
> > could you please send a patch that only calls that early_printk() if 
> > console_loglevel == 10? (i.e. if "debug" has been passed)
> 
> 
> Sure, here it is.
> 
> 
> 
> Honour "quiet" boot parameter in early_printk() calls
> 
> 
> Signed-off-by: Diego Calleja <diegocg@gmail.com>

applied to tip/x86/debug, thanks Diego.

If anyone can see other too-verbose-bootup-message annoyances during 
default distro bootups, please send patches.

	Ingo
