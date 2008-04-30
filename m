Return-Path: <linux-kernel-owner+w=401wt.eu-S1764532AbYD3XMW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764532AbYD3XMW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2008 19:12:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758505AbYD3XMN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Apr 2008 19:12:13 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33238 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752076AbYD3XMM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2008 19:12:12 -0400
Date: Wed, 30 Apr 2008 16:11:30 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Mariusz Kozlowski <m.kozlowski@tuxland.pl>
Cc: dpn@isomerica.net, torvalds@linux-foundation.org, rjw@sisk.pl,
       davem@davemloft.net, linux-kernel@vger.kernel.org, jirislaby@gmail.com
Subject: Re: Slow DOWN, please!!!
Message-Id: <20080430161130.4328b830.akpm@linux-foundation.org>
In-Reply-To: <200805010053.31894.m.kozlowski@tuxland.pl>
References: <20080429.190352.137408408.davem@davemloft.net>
	<4818DAC4.0@isomerica.net>
	<20080430135938.82e46e67.akpm@linux-foundation.org>
	<200805010053.31894.m.kozlowski@tuxland.pl>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 1 May 2008 00:53:31 +0200
Mariusz Kozlowski <m.kozlowski@tuxland.pl> wrote:

> Hello,
> 
> > > Perhaps we should be clear and simple about what potential testers 
> > > should be running at any given point in time.  With -mm, linux-next, 
> > > linux-2.6, etc, as a newcomer I find it difficult to know where my 
> > > testing time and energy is best directed.
> 
> Speaking of energy and time of a tester. I'd like to know where these resources
> should be directed from the arch point of view. Once I had a plan to buy as
> many arches as I could get and run a farm of test boxes 8-) But that's hard
> because of various reasons (money, time, room, energy). What arches need more
> attention? Which are forgotten? Which are going away? For example does buying
> an alphaserver DS 20 (hey - it's cheap) and running tests on it makes sense
> these days?
> 

gee.

I think to a large extent this problem solves itself - the "more important"
architectures have more people using them, so they get more testing and
more immediate testing.

However there are gaps.  I'd say that arm is one of the more important
architectures, but many people who are interested in arm tend to shy away
from bleeding-edge kernels for various reasons.  Mainly because they have
real products to get out the door, rather than dinking around with mainline
kernel developement.  So testing bleeding-edge on some arm systems would be
good, I expect.

otoh, the platform we break most often is surely plain-old-PCs.  If it's
bugs you're looking for, I expect that dumpster-diving for as many
different PCs as you can and trying to get them to boot (let alone suspend
and resume!) would keep you entertained ;)

