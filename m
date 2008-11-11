Return-Path: <linux-kernel-owner+w=401wt.eu-S1756909AbYKKOEo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756909AbYKKOEo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2008 09:04:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756653AbYKKOER
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Nov 2008 09:04:17 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:53452 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756560AbYKKOEQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2008 09:04:16 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH] x86: Make NUMA on 32-bit depend on BROKEN
Date: Tue, 11 Nov 2008 15:08:58 +0100
User-Agent: KMail/1.9.9
Cc: Andi Kleen <andi@firstfloor.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, Pavel Machek <pavel@suse.cz>,
       Peter Zijlstra <peterz@infradead.org>
References: <200811102152.47901.rjw@sisk.pl> <20081111094617.GB16496@elte.hu>
In-Reply-To: <20081111094617.GB16496@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200811111508.58886.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, 11 of November 2008, Ingo Molnar wrote:
> 
> * Rafael J. Wysocki <rjw@sisk.pl> wrote:
> 
> > From: Rafael J. Wysocki <rjw@sisk.pl>
> > Subject: x86: Make NUMA on 32-bit depend on BROKEN
> > 
> > While investigating the failure of hibernation on 32-bit x86 with 
> > CONFIG_NUMA set, as described in this message 
> > http://marc.info/?l=linux-kernel&m=122634118116226&w=4 I asked some 
> > people for help and I was told that it wasn't really worth the 
> > effort, because CONFIG_NUMA was generally broken on 32-bit x86 
> > systems and it shouldn't be used in such configs.  For this reason, 
> > make CONFIG_NUMA depend on BROKEN instead of EXPERIMENTAL on x86-32.
> 
> Actually, it works just fine on a wide range of 32-bit systems that i 
> have, so NAK.
> 
> Hibernation might not work but that's i believe a NUMA<->HIBERNATION 
> interaction issue, we need to fix that. Regular system bootup and 
> stress-tests work just fine.

OK, so it seems I'll have to find out what exactly happens. :-(

Thanks,
Rafael
