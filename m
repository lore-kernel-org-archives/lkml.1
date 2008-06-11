Return-Path: <linux-kernel-owner+w=401wt.eu-S1763899AbYFKQcz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763899AbYFKQcz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2008 12:32:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753443AbYFKQcr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jun 2008 12:32:47 -0400
Received: from casper.infradead.org ([85.118.1.10]:41945 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750811AbYFKQcr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2008 12:32:47 -0400
Date: Wed, 11 Jun 2008 09:32:29 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: "Ray Lee" <ray-lk@madrabbit.org>
Cc: "Jan Engelhardt" <jengelh@medozas.de>,
       "Kok, Auke" <auke-jan.h.kok@intel.com>,
       "solsTiCe d'Hiver" <solstice.dhiver@gmail.com>,
       linux-kernel@vger.kernel.org
Subject: Re: PROBLEM: no cpu MHz in /proc/cpuinfo on 2.6.25.4-rt6
Message-ID: <20080611093229.5ddf7e3f@infradead.org>
In-Reply-To: <2c0942db0806110908i7d99b47ej155ae11d6d832077@mail.gmail.com>
References: <200806102152.23286.solstice.dhiver@gmail.com>
	<20080610131314.5f7069e6@infradead.org>
	<484EE71A.40002@intel.com>
	<alpine.LNX.1.10.0806111440480.20733@fbirervta.pbzchgretzou.qr>
	<20080611063639.5e1eea5b@infradead.org>
	<2c0942db0806110908i7d99b47ej155ae11d6d832077@mail.gmail.com>
Organization: Intel
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.12.10; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 11 Jun 2008 09:08:40 -0700
"Ray Lee" <ray-lk@madrabbit.org> wrote:

> On Wed, Jun 11, 2008 at 6:36 AM, Arjan van de Ven
> <arjan@infradead.org> wrote:
> > CPU frequency is...
> > 1) not something that is fixed; it changes all the time
> 
> Not necessarily true of setups where jackd is running.

in case you didn't realize, your cpu itself will change it's frequency
under you, even if you don't use things like ondemand cpufreq governor.
(Intel calls this "Intel Dynamic Acceleration technology", and it's
already in all current Intel based laptops)


> Again, that won't be happening when jackd is running.
> 
> > Userland apps that use "cpu frequency" seem to be buggy to me, at
> > least I don't believe that they understand the complexities about
> > what this means,
> 
> It doesn't appear you understand what jackd is and what lengths users
> will go to to configure their systems for running it smoothly and
> reliably.

I understand that jackd tries to squeeze the last bit out of things.
But really, the cpu frequency doesn't fit into that because it's
dynamic.

> 
> > and I don't believe that the decisions they make based on
> > this will be made correctly.
> 
> Please go read the jackd designs slides from the 2003 presentation on
> the jack website [1]. The author has a clue, and is quite aware of how
> computers work

I read this now; I don't see anything about using the CPU frequency in
there.....


-- 
If you want to reach me at my work email, use arjan@linux.intel.com
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
