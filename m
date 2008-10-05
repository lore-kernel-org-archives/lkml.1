Return-Path: <linux-kernel-owner+w=401wt.eu-S1755909AbYJEP4b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755909AbYJEP4b (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Oct 2008 11:56:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754341AbYJEP4X
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 5 Oct 2008 11:56:23 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:36525 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754315AbYJEP4X (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Oct 2008 11:56:23 -0400
Date: Sun, 5 Oct 2008 17:56:14 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Chuck Ebbert <cebbert@redhat.com>, Andi Kleen <andi@firstfloor.org>,
       linux-kernel@vger.kernel.org, Arjan van de Ven <arjan@infradead.org>
Subject: Re: <PING> Re: [patch x86/core] x86: allow number of additional
	hotplug CPUs to be set at compile time
Message-ID: <20081005155614.GA5356@elte.hu>
References: <20081002152521.16c4835b@redhat.com> <20081002194409.GB8318@one.firstfloor.org> <20081002160907.68d79e0b@redhat.com> <20081002204018.GD8318@one.firstfloor.org> <87ljx4nw09.fsf_-_@basil.nowhere.org> <20081004183014.769836ff@redhat.com> <20081005102835.GA8947@elte.hu> <alpine.LFD.2.00.0810051626150.3398@apollo> <20081005152025.GA27066@elte.hu> <alpine.LFD.2.00.0810051732380.3398@apollo>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.0810051732380.3398@apollo>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00,DNS_FROM_SECURITYSAGE autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
	0.0 DNS_FROM_SECURITYSAGE  RBL: Envelope sender in
	blackholes.securitysage.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Thomas Gleixner <tglx@linutronix.de> wrote:

> > and no way can any of this go into v2.6.27: this is fragile code 
> > with a lot of historic baggage and the original error is non-fatal 
> > to begin with. It can easily be backported to .27.1 if testing shows 
> > that it has no other adverse side-effects.
> 
> Please lets get rid of all this.
> 
> Thanks,
> 
> 	tglx
> ---------------->
> >From 344707c1f43dd0d080828497aacb60c0cc0a8c13 Mon Sep 17 00:00:00 2001
> From: Thomas Gleixner <tglx@linutronix.de>
> Date: Sun, 5 Oct 2008 17:27:56 +0200
> Subject: [PATCH] x86, smpboot: remove additional_cpus
> 
> remove remainder of additional_cpus logic. We now just listen to the
> disabled_cpus value like we did for years. disabled_cpus is always >=
> 0 so no need for an extra check.
>
> Signed-off-by: Thomas Gleixner <tglx@linutronix.de>

applied to tip/x86/core - thanks Thomas!

	Ingo
