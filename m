Return-Path: <linux-kernel-owner+w=401wt.eu-S1760179AbXEKMDA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760179AbXEKMDA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 May 2007 08:03:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756674AbXEKMCx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 May 2007 08:02:53 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:57662 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755724AbXEKMCw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 May 2007 08:02:52 -0400
From: Christian <christiand59@web.de>
To: Ingo Molnar <mingo@elte.hu>
Subject: Re: [patch] CFS scheduler, -v11
Date: Fri, 11 May 2007 14:01:59 +0200
User-Agent: KMail/1.9.6
Cc: linux-kernel@vger.kernel.org, Kasper Sandberg <lkml@metanurb.dk>
References: <20070508150431.GA26977@elte.hu> <200705102051.09432.christiand59@web.de> <20070510200500.GB18741@elte.hu>
In-Reply-To: <20070510200500.GB18741@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200705111401.59825.christiand59@web.de>
X-Provags-ID: V01U2FsdGVkX18VWro2ec1nvBCzYItYHQRAqtdG6vZIGPRP27C
 4Z72bPl5MTAkAfx1acm+kEhfxQ6M9nOeMfHDT+9jX164MDrvYe
 qZ4DCyAWy0lwmtQz4u3Mg==
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 10 May 2007 22:05:00 Ingo Molnar wrote:
> * Christian <christiand59@web.de> wrote:
> > > > Desktop performance without any manual renicing is excellent, even
> > > > with make -j20. Gaming performance is at least on par with SD now!
> > > > I've tried to
> > >
> > > Which games are you trying? and have you tried other workloads then
> > > make -j20?
> > >
> > > try have a window with some 3d game open, and a browser besides it,
> > > and press a link. i cant seem to get smooth results with CFS.
>
> [...]
>
> > I've tried many different workloads, kernel compile (normal -j4),
> > extreme kernel compile (-j20) and Browsing/Open Office. GLXGears,
> > Briquolo and enemy-territory work relly well under these loads.
>
> do you have CONFIG_PREEMPT enabled - while perhaps Kasper has it
> disabled? Kasper, if so, could you try a quick test with CONFIG_PREEMPT
> enabled, does that make any difference to your gaming-smoothness
> results? [it's not a real solution, but this would help us narrow down
> the smoothness problem you are seeing.]

Yes, I have enabled full preemption and 1000 HZ.

-Christian


