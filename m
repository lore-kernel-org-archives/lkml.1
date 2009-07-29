Return-Path: <linux-kernel-owner+w=401wt.eu-S1753844AbZG2J7O@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753844AbZG2J7O (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jul 2009 05:59:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753750AbZG2J7O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Jul 2009 05:59:14 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:33586 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753713AbZG2J7N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jul 2009 05:59:13 -0400
Subject: Re: futexes: Still infinite loop in get_futex_key() in 2.6.31-rc4
From: Peter Zijlstra <peterz@infradead.org>
To: Jens Rosenboom <jens@mcbone.net>
Cc: Sonny Rao <sonnyrao@us.ibm.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>
In-Reply-To: <1248861443.6757.20.camel@fnki-nb00130>
References: <1248681637.7279.12.camel@fnki-nb00130>
	 <1248694266.6987.1594.camel@twins>  <1248697004.7279.31.camel@fnki-nb00130>
	 <1248697409.6987.1617.camel@twins>  <1248698755.7279.47.camel@fnki-nb00130>
	 <1248701812.6987.1637.camel@twins>  <1248848568.6757.13.camel@fnki-nb00130>
	 <1248861443.6757.20.camel@fnki-nb00130>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Wed, 29 Jul 2009 12:01:50 +0200
Message-Id: <1248861710.6987.3064.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-07-29 at 11:57 +0200, Jens Rosenboom wrote:
> On Wed, 2009-07-29 at 08:22 +0200, Jens Rosenboom wrote:
> > On Mon, 2009-07-27 at 15:36 +0200, Peter Zijlstra wrote:
> > [...]
> > > Bugger.. how easy it is to reproduce?
> > 
> > Okay, my colleague found the right combination of scripts, take the two
> > attached, run them both a couple of times in parallel for some hours,
> > and get a stuck ps. This happens both on an old 2.6.29.1 I happened to
> > still have on one machine as with 2.6.31-rc4. Both of them dual-core
> > Opterons as the original one. If you want further tracebacks or other
> > information, let me know.
> 
> Forget about null.pl even, just run pees.pl twice and a top to watch it,
> has worked for me within less than an hour several times now.

Thanks, I'll give it a go..
