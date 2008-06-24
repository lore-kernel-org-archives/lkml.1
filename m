Return-Path: <linux-kernel-owner+w=401wt.eu-S1760207AbYFXLtj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760207AbYFXLtj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2008 07:49:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753904AbYFXLta
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Jun 2008 07:49:30 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:41688 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754686AbYFXLt3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2008 07:49:29 -0400
Date: Tue, 24 Jun 2008 13:49:17 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Vegard Nossum <vegard.nossum@gmail.com>
Cc: Johannes Weiner <hannes@saeurebad.de>, Philippe Elie <phil.el@wanadoo.fr>,
       oprofile-list@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86/oprofile: disable preemption in nmi_shutdown
Message-ID: <20080624114917.GE21890@elte.hu>
References: <878wwylyej.fsf@skyscraper.fehenstaub.lan> <20080622074018.GA3163@damson.getinternet.no>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080622074018.GA3163@damson.getinternet.no>
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


* Vegard Nossum <vegard.nossum@gmail.com> wrote:

> From: Vegard Nossum <vegard.nossum@gmail.com>
> Date: Sat, 21 Jun 2008 23:44:19 +0200
> Subject: [PATCH] x86/oprofile: disable preemption in nmi_shutdown
> 
>     BUG: using smp_processor_id() in preemptible [00000000] code: oprofiled/27301
>     caller is nmi_shutdown+0x11/0x60
>     Pid: 27301, comm: oprofiled Not tainted 2.6.26-rc7 #25
>      [<c028a90d>] debug_smp_processor_id+0xbd/0xc0
>      [<c045fba1>] nmi_shutdown+0x11/0x60
>      [<c045dd4a>] oprofile_shutdown+0x2a/0x60
> 
> Note that we don't need this for the other functions, since they are 
> all called with on_each_cpu() (which disables preemption for us 
> anyway).

applied to tip/x86/oprofile - thanks Vegard.

	Ingo
