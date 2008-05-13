Return-Path: <linux-kernel-owner+w=401wt.eu-S1756726AbYEMMLX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756726AbYEMMLX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2008 08:11:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752391AbYEMMLQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 May 2008 08:11:16 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:47272 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752080AbYEMMLP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2008 08:11:15 -0400
Date: Tue, 13 May 2008 14:10:57 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Cyrill Gorcunov <gorcunov@gmail.com>
Cc: Pavel Machek <pavel@suse.cz>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       "H. Peter Anvin" <hpa@zytor.com>, Sam Ravnborg <sam@ravnborg.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86: wakeup.lds.S - section ordering fix
Message-ID: <20080513121057.GF32022@elte.hu>
References: <20080511184638.GE6942@cvg> <20080512135343.GA1725@elf.ucw.cz> <20080512141420.GA6913@cvg>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080512141420.GA6913@cvg>
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


* Cyrill Gorcunov <gorcunov@gmail.com> wrote:

> [Pavel Machek - Mon, May 12, 2008 at 03:53:43PM +0200]
> | On Sun 2008-05-11 22:46:38, Cyrill Gorcunov wrote:
> | > To allow linker to catch sections overlapping we have to declare
> | > them in appropriate order.
> | > 
> | > Signed-off-by: Cyrill Gorcunov <gorcunov@gmail.com>
> | > ---
> | > 
> | > Please test and review
> | 
> | Looks okay to me, but I can't easily test it right now.
> | 
> | But I think Rafael tested identical patch, you can add my ACK in such
> | case.
> 
> Yes, Rafael tested the same (in contents) patch. Actually there was a 
> bit time-screwed situation - I've proposed a solution, Peter was 
> agreed with, I said him that I'll cook a patch, meanwhile I've got an 
> internet connection problem, and at moment Rafael tested the same 
> patch he made by own. A bit funny situation ;) So I think in this 
> patch should be then:

applied, thanks.

	Ingo
