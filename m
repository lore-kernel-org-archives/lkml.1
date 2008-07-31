Return-Path: <linux-kernel-owner+w=401wt.eu-S1757217AbYGaUvX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757217AbYGaUvX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2008 16:51:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752912AbYGaUvO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Jul 2008 16:51:14 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:59615 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752201AbYGaUvO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2008 16:51:14 -0400
Date: Thu, 31 Jul 2008 22:50:46 +0200
From: Ingo Molnar <mingo@elte.hu>
To: David Brownell <david-b@pacbell.net>
Cc: Clemens Ladisch <clemens@ladisch.de>, lkml <linux-kernel@vger.kernel.org>,
       bob.picco@hp.com, venkatesh.pallipadi@intel.com,
       Vojtech Pavlik <vojtech@suse.cz>,
       the arch/x86 maintainers <x86@kernel.org>,
       Adrian Bunk <bunk@kernel.org>
Subject: Re: [patch 2.6.27-rc1] /dev/hpet - fixes and cleanup
Message-ID: <20080731205046.GB25138@elte.hu>
References: <200807221508.56672.david-b@pacbell.net> <20080731164658.GG26393@elte.hu> <20080731165519.GA8631@elte.hu> <200807311259.56870.david-b@pacbell.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <200807311259.56870.david-b@pacbell.net>
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


* David Brownell <david-b@pacbell.net> wrote:

> On Thursday 31 July 2008, Ingo Molnar wrote:
> >   drivers/built-in.o: In function `hpet_alloc':
> >   : undefined reference to `__udivdi3'
> >   drivers/built-in.o: In function `hpet_alloc':
> >   : undefined reference to `__umoddi3'
> 
> Verified on 64 and 32 bit builds.

applied to tip/timers/hpet - thanks David!

	Ingo
