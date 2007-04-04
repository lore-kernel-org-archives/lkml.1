Return-Path: <linux-kernel-owner+w=401wt.eu-S1752209AbXDDWAG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752209AbXDDWAG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Apr 2007 18:00:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752228AbXDDWAG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Apr 2007 18:00:06 -0400
Received: from homer.mvista.com ([63.81.120.158]:39168 "EHLO
	gateway-1237.mvista.com" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1752209AbXDDWAE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Apr 2007 18:00:04 -0400
Subject: Re: + clocksource-driver-initialize-list-value.patch added to -mm
	tree
From: Daniel Walker <dwalker@mvista.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Andrew Morton <akpm@linux-foundation.org>, tglx@linutronix.de,
       johnstul@us.ibm.com, LKML <linux-kernel@vger.kernel.org>,
       heiko.carstens@de.ibm.com
In-Reply-To: <20070404213404.GA21742@elte.hu>
References: <200704010523.l315NXJP004063@shell0.pdx.osdl.net>
	 <1175417035.28263.42.camel@localhost.localdomain>
	 <1175704712.15973.35.camel@imap.mvista.com>
	 <20070404125853.1cf9b7b7.akpm@linux-foundation.org>
	 <1175717425.15973.61.camel@imap.mvista.com>
	 <20070404203647.GA12563@elte.hu>
	 <1175719489.15973.66.camel@imap.mvista.com>
	 <20070404211514.GA18600@elte.hu>
	 <1175722246.15973.78.camel@imap.mvista.com>
	 <20070404213404.GA21742@elte.hu>
Content-Type: text/plain
Date: Wed, 04 Apr 2007 14:59:14 -0700
Message-Id: <1175723954.15973.96.camel@imap.mvista.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2.1 (2.8.2.1-3.fc6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-04-04 at 23:34 +0200, Ingo Molnar wrote:
> * Daniel Walker <dwalker@mvista.com> wrote:
> 
> > > but why do you call that a simplification? Remove 5 lines of code 
> > > from the generic code, by adding +1 line to every clocksource 
> > > driver, totalling to like +20 lines at the moment?
> > 
> > I guess I don't look at it in terms of lines .. Why do you think 
> > reciting a line count diminishes the "simplification" claim? The 20+ 
> > lines that I added to each clocksource don't have a size or runtime 
> > effect ..
> 
> but they have a robustness and maintainability effect. Key is to keep 
> drivers _simple_ and hard to mess up. If it's 5 extra lines of code to 
> simplify a driver then we just do it. This is maintainance 101.
> 
> i cannot believe you are still arguing this. I explained this to you 
> many weeks ago!

I vaguely remember, but I don't think this creates a maintenance
issue .. It's not related to maintenance , it's an issue of creating a
new clocksource .. My perspective is that it has even less an effect
than the CLOCK_SOURCE_IS_CONTINUOUS field .. People actually have to
research that field, but list initialization is fairly clear.

The majority method for creating these clocksources is copy&paste, so
I'm not sure nano argument on this subject particularly relevant ..

Daniel

