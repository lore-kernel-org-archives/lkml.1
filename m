Return-Path: <linux-kernel-owner+w=401wt.eu-S1759456AbZF2OAn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759456AbZF2OAn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jun 2009 10:00:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756782AbZF2OAY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Jun 2009 10:00:24 -0400
Received: from casper.infradead.org ([85.118.1.10]:36617 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752786AbZF2OAV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jun 2009 10:00:21 -0400
Date: Mon, 29 Jun 2009 07:01:23 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: Luming Yu <luming.yu@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       suresh.b.siddha@intel.com, venkatesh.pallipadi@intel.com,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [RFC patch] Use IPI_shortcut for lapic timer broadcast
Message-ID: <20090629070123.5e874497@infradead.org>
In-Reply-To: <3877989d0906290143y3b5306f4s4a990ecbfbfc49b6@mail.gmail.com>
References: <3877989d0906282347i311eb14bp80a7c80878219c31@mail.gmail.com>
	<20090629072047.GB20225@elte.hu>
	<3877989d0906290104q11a767b6qcc1acc4c2d1feba6@mail.gmail.com>
	<20090629081615.GB571@elte.hu>
	<3877989d0906290121l15705d2cn72e4c49dd96ed950@mail.gmail.com>
	<20090629083035.GA4017@elte.hu>
	<3877989d0906290143y3b5306f4s4a990ecbfbfc49b6@mail.gmail.com>
Organization: Intel
X-Mailer: Claws Mail 3.7.1 (GTK+ 2.14.7; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 29 Jun 2009 16:43:16 +0800
Luming Yu <luming.yu@gmail.com> wrote:

> > Even a Pentium-5 100 MHz dual box was able to do cross-CPU IPIs
> > within 10-20 microseconds more than a decade ago - so 50-100 usecs
> > latency on a modern platform is totally out of this planet and will
> > hurt Linux performance big time. And the worst thing about it is
> > that none of the usual performance metrics will really show _why_
> > performance is tanking ...
> >
> 
> 
> Please note this is deep-C-state related.
> C state does add extra latency.. but I don't know how much...

C states normally only add on the "wait for" side, not on the "send"
side.

(RHEL5 is rather old, so it may have done things a bit different)

Maybe it is time for mainline to not allow a !NO_HZ config....


-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
