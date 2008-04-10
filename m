Return-Path: <linux-kernel-owner+w=401wt.eu-S1758279AbYDJUiX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758279AbYDJUiX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Apr 2008 16:38:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754544AbYDJUiQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Apr 2008 16:38:16 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:53645 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753373AbYDJUiP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Apr 2008 16:38:15 -0400
Date: Thu, 10 Apr 2008 22:38:00 +0200
From: Ingo Molnar <mingo@elte.hu>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, Pavel Machek <pavel@ucw.cz>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Anvin" <hpa@zytor.com>,
       Arjan van de Ven <arjan@infradead.org>
Subject: Re: x86 git tree broken
Message-ID: <20080410203800.GA14560@elte.hu>
References: <200804102159.14563.rjw@sisk.pl> <20080410201339.GD4323@elte.hu> <200804102225.01177.rjw@sisk.pl> <20080410202914.GD9582@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080410202914.GD9582@elte.hu>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0005]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Ingo Molnar <mingo@elte.hu> wrote:

> > > > First, the X server doesn't want to start (it says it couldn't 
> > > > mmap the framebuffer).
> > > 
> > > could you send your .config?
> > 
> > Attached.
> 
> could you disable this option:
> 
>  CONFIG_NONPROMISC_DEVMEM=y
> 
> does it help with the X problem?

btw., Xorg works fine here on a comparable AMD system - but i use a 
rather new distro (Fedora 8) which has Xorg 7.2.

	Ingo
