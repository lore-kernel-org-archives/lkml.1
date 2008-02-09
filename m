Return-Path: <linux-kernel-owner+w=401wt.eu-S1755217AbYBIFM7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755217AbYBIFM7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Feb 2008 00:12:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751040AbYBIFMv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 Feb 2008 00:12:51 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:40099 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751001AbYBIFMu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Feb 2008 00:12:50 -0500
Date: Fri, 8 Feb 2008 21:04:03 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Roman Zippel <zippel@linux-m68k.org>
Cc: john stultz <johnstul@us.ibm.com>, lkml <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH] correct inconsistent ntp interval/tick_length usage
Message-Id: <20080208210403.a78502ea.akpm@linux-foundation.org>
In-Reply-To: <Pine.LNX.4.64.0802090543150.3378@scrub.home>
References: <1201142334.6383.40.camel@localhost.localdomain>
	<Pine.LNX.4.64.0801251349120.17507@scrub.home>
	<1201573686.6766.13.camel@localhost>
	<Pine.LNX.4.64.0801290439480.17507@scrub.home>
	<1201659263.6766.40.camel@localhost>
	<Pine.LNX.4.64.0801310251090.17507@scrub.home>
	<1201745776.6195.14.camel@localhost.localdomain>
	<Pine.LNX.4.64.0801310404480.17507@scrub.home>
	<1201914175.6216.46.camel@jstultz-laptop>
	<Pine.LNX.4.64.0802081718040.3378@scrub.home>
	<1202523452.6174.45.camel@localhost.localdomain>
	<Pine.LNX.4.64.0802090543150.3378@scrub.home>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 9 Feb 2008 05:47:18 +0100 (CET) Roman Zippel <zippel@linux-m68k.org> wrote:

> Hi,
> 
> On Fri, 8 Feb 2008, john stultz wrote:
> 
> >  
> >  	clock = clocksource_get_next();
> > -	clocksource_calculate_interval(clock,
> > -		(unsigned long)(current_tick_length()>>TICK_LENGTH_SHIFT));
> > +	clocksource_calculate_interval(clock, NTP_INTERVAL_LENGTH);
> >  	clock->cycle_last = clocksource_read(clock);
> >  
> 
> Only now I noticed that the first patch had been merged without any 
> further question. :-(
> What point is there in reviewing patches, if everything is merged anyway. :-(
> 

oops, mistake, sorry.  There's plenty of time to fix it though.
