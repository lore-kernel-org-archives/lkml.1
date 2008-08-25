Return-Path: <linux-kernel-owner+w=401wt.eu-S1755313AbYHYSW5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755313AbYHYSW5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Aug 2008 14:22:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751698AbYHYSWs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Aug 2008 14:22:48 -0400
Received: from casper.infradead.org ([85.118.1.10]:40730 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750935AbYHYSWs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Aug 2008 14:22:48 -0400
Date: Mon, 25 Aug 2008 11:22:44 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Dave Jones <davej@codemonkey.org.uk>,
       Peter Zijlstra <peterz@infradead.org>,
       linux-kernel <linux-kernel@vger.kernel.org>, cpufreq@vger.kernel.org,
       Alok Kataria <akataria@vmware.com>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [BUG] cpufreq: constant cpu_khz
Message-ID: <20080825112244.34b2fe67@infradead.org>
In-Reply-To: <20080825175712.GA10848@elte.hu>
References: <1219646032.20732.10.camel@twins>
	<1219664106.8515.50.camel@twins>
	<20080825123926.GC8663@elte.hu>
	<20080825175547.GA26131@codemonkey.org.uk>
	<20080825175712.GA10848@elte.hu>
Organization: Intel
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.11; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 25 Aug 2008 19:57:12 +0200
Ingo Molnar <mingo@elte.hu> wrote:

> 
> * Dave Jones <davej@codemonkey.org.uk> wrote:
> 
> >  > hm, that too is due to the tsc.c unification - Alok Cc:-ed.
> >  > Applied your fix to x86/urgent.
> > 
> > ACKed-by: Dave Jones <davej@redhat.com>
> > 
> > Good catch Peter.  I'm puzzled how that bug was latent on 64bit for
> > so long with no-one realising though.
> 
> i think it's the combination of these two factors:
> 
>  - bootup frequently is typically full-speed, so we calibrate things 
>    right
> 
>  - cpufreq events are relatively slow-scale - and when they trigger
> the system is definitely not under load. So how precisely the
> scheduler functions isnt all that important in such scenarios -
> there's tons of CPU power available.
> 

- many many of the 64 bit capable cpus are constant-tsc anyway

