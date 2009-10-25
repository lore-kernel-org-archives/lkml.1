Return-Path: <linux-kernel-owner+w=401wt.eu-S1753830AbZJYR2N@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753830AbZJYR2N (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Oct 2009 13:28:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753817AbZJYR2M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 Oct 2009 13:28:12 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:52805 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753816AbZJYR2M (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Oct 2009 13:28:12 -0400
Date: Sun, 25 Oct 2009 18:27:18 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Arjan van de Ven <arjan@infradead.org>
Cc: Dmitry Adamushko <dmitry.adamushko@gmail.com>,
       Tigran Aivazian <tigran@aivazian.fsnet.co.uk>,
       Mike Travis <travis@sgi.com>, Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jack Steiner <steiner@sgi.com>, "H. Peter Anvin" <hpa@zytor.com>,
       x86@kernel.org, Andreas Mohr <andi@lisas.de>,
       Hugh Dickins <hugh@veritas.com>, Hannes Eder <hannes@hanneseder.net>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 6/8] SGI x86_64 UV: Limit the number of microcode
	messages
Message-ID: <20091025172718.GA20060@elte.hu>
References: <20091023233743.439628000@alcatraz.americas.sgi.com> <20091023233756.941535000@alcatraz.americas.sgi.com> <b647ffbd0910241309u7b2f8c94t1f886ef31882539e@mail.gmail.com> <Pine.LNX.4.61.0910242207180.2439@ginsburg.homenet> <b647ffbd0910241545g4697a170peb00e541298d5a30@mail.gmail.com> <20091025163704.GE20391@elte.hu> <20091025101118.522a7aa4@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091025101118.522a7aa4@infradead.org>
User-Agent: Mutt/1.5.19 (2009-01-05)
X-ELTE-SpamScore: 0.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=0.0 required=5.9 tests=none autolearn=no SpamAssassin version=3.2.5
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Arjan van de Ven <arjan@infradead.org> wrote:

> On Sun, 25 Oct 2009 17:37:04 +0100
> Ingo Molnar <mingo@elte.hu> wrote:
> 
> > 
> > Having the precise microcode version printed (or exposed somewhere in 
> > /sys) is useful - sometimes when there's a weird crash in some
> > prototype CPU one of the first questions from hw vendors is 'which
> > precise microcode version was that?'.
> 
> something like /sys/devices/system/cpu/cpu0/microcode/version ?
> 
> (yes that is there today ;-)

yeah, i used that for a bug recently.

Nevertheless it makes sense to print the boot CPU message too - for bugs 
that crash before we can read out 
/sys/devices/system/cpu/cpu0/microcode/version.

	Ingo
