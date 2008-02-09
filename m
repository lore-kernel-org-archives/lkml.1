Return-Path: <linux-kernel-owner+w=401wt.eu-S1756972AbYBIErj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756972AbYBIErj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2008 23:47:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753244AbYBIErc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Feb 2008 23:47:32 -0500
Received: from scrub.xs4all.nl ([194.109.195.176]:2181 "EHLO scrub.xs4all.nl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752108AbYBIErc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2008 23:47:32 -0500
Date: Sat, 9 Feb 2008 05:47:18 +0100 (CET)
From: Roman Zippel <zippel@linux-m68k.org>
X-X-Sender: roman@scrub.home
To: john stultz <johnstul@us.ibm.com>
cc: lkml <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH] correct inconsistent ntp interval/tick_length usage
In-Reply-To: <1202523452.6174.45.camel@localhost.localdomain>
Message-ID: <Pine.LNX.4.64.0802090543150.3378@scrub.home>
References: <1201142334.6383.40.camel@localhost.localdomain> 
 <Pine.LNX.4.64.0801251349120.17507@scrub.home>  <1201573686.6766.13.camel@localhost>
  <Pine.LNX.4.64.0801290439480.17507@scrub.home>  <1201659263.6766.40.camel@localhost>
  <Pine.LNX.4.64.0801310251090.17507@scrub.home>  <1201745776.6195.14.camel@localhost.localdomain>
  <Pine.LNX.4.64.0801310404480.17507@scrub.home>  <1201914175.6216.46.camel@jstultz-laptop>
  <Pine.LNX.4.64.0802081718040.3378@scrub.home> <1202523452.6174.45.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Fri, 8 Feb 2008, john stultz wrote:

>  
>  	clock = clocksource_get_next();
> -	clocksource_calculate_interval(clock,
> -		(unsigned long)(current_tick_length()>>TICK_LENGTH_SHIFT));
> +	clocksource_calculate_interval(clock, NTP_INTERVAL_LENGTH);
>  	clock->cycle_last = clocksource_read(clock);
>  

Only now I noticed that the first patch had been merged without any 
further question. :-(
What point is there in reviewing patches, if everything is merged anyway. :-(

bye, Roman
