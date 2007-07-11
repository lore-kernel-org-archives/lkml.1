Return-Path: <linux-kernel-owner+w=401wt.eu-S933549AbXGKW70@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933549AbXGKW70 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2007 18:59:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761589AbXGKW7T
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jul 2007 18:59:19 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:59767 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757919AbXGKW7S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2007 18:59:18 -0400
Date: Wed, 11 Jul 2007 15:58:23 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Chris Wright <chrisw@sous-sol.org>
cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
       Andi Kleen <andi@firstfloor.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Arjan van de Ven <arjan@infradead.org>
Subject: Re: x86 status was Re: -mm merge plans for 2.6.23
In-Reply-To: <20070711225139.GB4306@sequoia.sous-sol.org>
Message-ID: <alpine.LFD.0.999.0707111557150.20061@woody.linux-foundation.org>
References: <20070710013152.ef2cd200.akpm@linux-foundation.org>
 <p734pkbyuu4.fsf@bingen.suse.de> <20070711174252.GA16793@elte.hu>
 <alpine.LFD.0.999.0707111438530.20061@woody.linux-foundation.org>
 <1184191488.12353.160.camel@chaos> <alpine.LFD.0.999.0707111518020.20061@woody.linux-foundation.org>
 <20070711225139.GB4306@sequoia.sous-sol.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 11 Jul 2007, Chris Wright wrote:
> 
> That's not quite right.  Leaving the code unchanged caused breakage
> already.  The PIT is damn stupid and can be sensitive to how quickly it's
> programmed.  So code that enable/disable didn't change, but frequency
> with which it is called did and broke some random boxes.

Sure. We cannot avoid *all* problems. Bugs happen. 

But at least we could try to make sure that there aren't totally 
unnecessary changes in that switch-over patch. Which there definitely 
were, as far as I can tell.

		Linus
