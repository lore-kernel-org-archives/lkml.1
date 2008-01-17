Return-Path: <linux-kernel-owner+w=401wt.eu-S1755875AbYAQTOa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755875AbYAQTOa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2008 14:14:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753101AbYAQTOU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jan 2008 14:14:20 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:45246 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752667AbYAQTOT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2008 14:14:19 -0500
Date: Thu, 17 Jan 2008 11:13:55 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Zan Lynx <zlynx@acm.org>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, Len Brown <lenb@kernel.org>,
       linux-kernel@vger.kernel.org
Subject: Re: echo mem > /sys/power/state
Message-Id: <20080117111355.29554f38.akpm@linux-foundation.org>
In-Reply-To: <1200591411.34145.4.camel@localhost>
References: <20080116222445.6f7ff66e.akpm@linux-foundation.org>
	<1200591411.34145.4.camel@localhost>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 17 Jan 2008 10:36:51 -0700 Zan Lynx <zlynx@acm.org> wrote:

> 
> On Wed, 2008-01-16 at 22:24 -0800, Andrew Morton wrote:
> > So I take everyone's latest and greatest product and injudiciously type the
> > above command.  The result five minutes later is at
> > http://userweb.kernel.org/~akpm/borkage.jpg.  See if you can count all the bugs.
> > 
> > Sorry, but I've had it with this stuff and I'm tired of fixing everyone else's
> > stuff.  I'm just going to ship it.  Good luck.
> 
> Heh.  Laptop suspend to anything has been so broken for so long in the
> -mm series on my Compaq R3000 that I didn't even know it was ever
> supposed to work.

It gets broken more often than anything else.  I do test each release on
two laptops and I get to do a lot of bisection searching and
grumpygramming as a result.

Probably it would be more efficient to have the people who wrote the code
also test it.
