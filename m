Return-Path: <linux-kernel-owner+w=401wt.eu-S938878AbXFHK6a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S938878AbXFHK6a (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2007 06:58:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S937590AbXFHK6V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Jun 2007 06:58:21 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:54231 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S937387AbXFHK6U (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2007 06:58:20 -0400
Date: Fri, 8 Jun 2007 12:58:08 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Andrew Morton <akpm@linux-foundation.org>,
       Andi Kleen <andi@firstfloor.org>
Cc: =?iso-8859-1?Q?Bj=F6rn?= Steinbrink <B.Steinbrink@gmx.de>,
       "Udo A. Steinberg" <us15@os.inf.tu-dresden.de>,
       Michal Piotrowski <michal.k.k.piotrowski@gmail.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, ak@suse.de
Subject: Re: [PATCH] Fix interchanged parameters to
	release_{evntsel,perfctr}_nmi
Message-ID: <20070608105808.GA10190@elte.hu>
References: <465C2225.2000100@googlemail.com> <20070603150246.5151dda6@laptop.hypervisor.org> <20070608060244.GA2369@atjola.homenet> <20070607234153.09c32b49.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070607234153.09c32b49.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.14 (2007-02-12)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.1.7
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Andrew Morton <akpm@linux-foundation.org> wrote:

> Half of this (the first hunk) has been in Andi's tree for a day or 
> two.
> 
> I shall drop Andi's patch, queue this one up and shall send this off 
> to Linus if nothing else happens in the next couple of days.

this patch does not fix the NMI watchdog bootup lockup i can reproduce, 
it still occurs in -rc4 too. Andi, could you please react to my report? 
See the "2.6.22-rc3 nmi watchdog hang" thread on lkml.

	Ingo
