Return-Path: <linux-kernel-owner+w=401wt.eu-S934872AbYEVWwh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934872AbYEVWwh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2008 18:52:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758990AbYEVWwP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 May 2008 18:52:15 -0400
Received: from kirk.serum.com.pl ([213.77.9.205]:61202 "EHLO serum.com.pl"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1758291AbYEVWwO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2008 18:52:14 -0400
Date: Thu, 22 May 2008 23:51:43 +0100 (BST)
From: "Maciej W. Rozycki" <macro@linux-mips.org>
To: Thomas Gleixner <tglx@linutronix.de>
cc: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/8] x86: Timer through APIC and related clean-ups
In-Reply-To: <alpine.LFD.1.10.0805222029020.3295@apollo.tec.linutronix.de>
Message-ID: <Pine.LNX.4.55.0805222344530.13339@cliff.in.clinika.pl>
References: <Pine.LNX.4.55.0805212158350.4894@cliff.in.clinika.pl>
 <alpine.LFD.1.10.0805222029020.3295@apollo.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 22 May 2008, Thomas Gleixner wrote:

> >  As there are some interdependencies the patches are best applied in the 
> > order I am sending them; see also the paragraph above.
> 
> Looks really good. Applied. Thanks,

 As a follow-on I think it might be a good idea to wrap timer_ack into
get_timer_ack() and set_timer_ack() expanding as necessary so that the
related 32-bit and 64-bit code can get unified.

  Maciej
