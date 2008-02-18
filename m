Return-Path: <linux-kernel-owner+w=401wt.eu-S1758828AbYBREam@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758828AbYBREam (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Feb 2008 23:30:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756308AbYBREad
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Feb 2008 23:30:33 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:44132 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755908AbYBREac (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Feb 2008 23:30:32 -0500
Date: Mon, 18 Feb 2008 05:30:19 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Joe Perches <joe@perches.com>
Cc: Paolo Ciarrocchi <paolo.ciarrocchi@gmail.com>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       "tglx@linutronix.de" <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH] x86: Coding style fixes for
	arch/x86/kernel/cpu/centaur.c
Message-ID: <20080218043019.GA21151@elte.hu>
References: <20080217233023.26764dc9@paolo-desktop> <20080218025645.GB30201@elte.hu> <1203304344.7181.45.camel@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1203304344.7181.45.camel@localhost>
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


* Joe Perches <joe@perches.com> wrote:

> > +		if (e820.map[i].type == E820_RESERVED) {
> > +			if (e820.map[i].addr >= 0x100000UL &&
> > +						e820.map[i].addr < clip)
> >  				clip = e820.map[i].addr;
> 
> Doesn't this look better as:
> 
> +			if (e820.map[i].addr >= 0x100000UL &&
> +			    e820.map[i].addr < clip)

yeah, it does - i've changed that.

	Ingo
