Return-Path: <linux-kernel-owner+w=401wt.eu-S1755374Ab0ANFpc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755374Ab0ANFpc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jan 2010 00:45:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755301Ab0ANFpb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Jan 2010 00:45:31 -0500
Received: from casper.infradead.org ([85.118.1.10]:57352 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755289Ab0ANFpb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jan 2010 00:45:31 -0500
Date: Wed, 13 Jan 2010 21:45:28 -0800
From: Arjan van de Ven <arjan@infradead.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, tglx@tglx.de, mingo@elte.hu,
       Cyrill Gorcunov <gorcunov@gmail.com>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH] timers: Introduce the concept of timer slack for legacy
 timers
Message-ID: <20100113214528.41e2de4a@infradead.org>
In-Reply-To: <20100113135219.f7e8a2f9.akpm@linux-foundation.org>
References: <20100109133744.29829988@infradead.org>
	<20100113135219.f7e8a2f9.akpm@linux-foundation.org>
Organization: Intel
X-Mailer: Claws Mail 3.7.3 (GTK+ 2.16.6; i586-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 13 Jan 2010 13:52:19 -0800
Andrew Morton <akpm@linux-foundation.org> wrote:

> I suppose this could be inlined.

.. and then I expand it a bit in a few weeks and guess who complains an
inline gets too big ? ;-)


> OK, so by default this causes every timer in the system to have a bit
> of slack (unless they're really short-term?), 

0.4%.. so yeah you need to sleep a little before it rounds up to 1 ;)


>so the feature does get
> runtime tested.

yep..

> 
> But the set_timer_slack() interface has no callers.  Perhaps it
> should?

I have some callers pending, and I thought I posted those to lkml but
maybe I did not.


-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
