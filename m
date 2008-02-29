Return-Path: <linux-kernel-owner+w=401wt.eu-S932225AbYB2Nbc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932225AbYB2Nbc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Feb 2008 08:31:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759442AbYB2NbM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Feb 2008 08:31:12 -0500
Received: from scrub.xs4all.nl ([194.109.195.176]:48245 "EHLO scrub.xs4all.nl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932435AbYB2NbK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Feb 2008 08:31:10 -0500
Date: Fri, 29 Feb 2008 14:31:02 +0100 (CET)
From: Roman Zippel <zippel@linux-m68k.org>
X-X-Sender: roman@scrub.home
To: Ray Lee <ray-lk@madrabbit.org>
cc: john stultz <johnstul@us.ibm.com>, lkml <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH] Remove obsolete CLOCK_TICK_ADJUST
In-Reply-To: <2c0942db0802282225j7d01eee3vbe6bbb7b93e86e47@mail.gmail.com>
Message-ID: <Pine.LNX.4.64.0802291422070.2723@scrub.home>
References: <1201142334.6383.40.camel@localhost.localdomain> 
 <Pine.LNX.4.64.0802120335170.3378@scrub.home>  <1202963796.6195.141.camel@localhost.localdomain>
  <Pine.LNX.4.64.0802150436300.1822@scrub.home>  <1203382940.5984.242.camel@localhost>
  <Pine.LNX.4.64.0802190219360.2723@scrub.home>  <1203472250.6123.98.camel@localhost>
  <Pine.LNX.4.64.0802200348230.2723@scrub.home>  <1203647951.6150.80.camel@localhost.localdomain>
  <Pine.LNX.4.64.0802290547320.2723@scrub.home>
 <2c0942db0802282225j7d01eee3vbe6bbb7b93e86e47@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Thu, 28 Feb 2008, Ray Lee wrote:

> >  Revert bbe4d18ac2e058c56adb0cd71f49d9ed3216a405 and
> >  e13a2e61dd5152f5499d2003470acf9c838eab84 and remove CLOCK_TICK_ADJUST
> >  completely. Add a optional kernel parameter ntp_tick_adj instead to allow
> >  adjusting of a large base drift and thus keeping ntpd happy.
> 
> Wait, so you're saying that something that the kernel correctly
> figures out on its own today should instead be a kernel parameter,
> with users having to supply it explicitly? Am I confused?
> 
> If I'm not confused, would you'd be so kind to explain to the peanut
> gallery over here why this is a good thing?

Sorry, for causing this confusion.
Unless you run a computer with the PIT or jiffies clock, this value is 
just a random value added to the calculation.
Even if you use the PIT clock, the drift isn't large enough to be worried 
about it with standard configurations. You have to manually set HZ to 2000 
and use the PIT clock, then you might have a need for this parameter.

bye, Roman
