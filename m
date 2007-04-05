Return-Path: <linux-kernel-owner+w=401wt.eu-S2992513AbXDELg3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992513AbXDELg3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Apr 2007 07:36:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992516AbXDELg2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Apr 2007 07:36:28 -0400
Received: from gateway-1237.mvista.com ([63.81.120.158]:27537 "EHLO
	gateway-1237.mvista.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2992513AbXDELg2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Apr 2007 07:36:28 -0400
Subject: Re: + clocksource-driver-initialize-list-value.patch added to -mm
	tree
From: Daniel Walker <dwalker@mvista.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>,
       Andrew Morton <akpm@linux-foundation.org>, tglx@linutronix.de,
       johnstul@us.ibm.com, LKML <linux-kernel@vger.kernel.org>,
       heiko.carstens@de.ibm.com
In-Reply-To: <20070405075101.GA14199@elte.hu>
References: <20070404203647.GA12563@elte.hu>
	 <1175719489.15973.66.camel@imap.mvista.com>
	 <20070404211514.GA18600@elte.hu>
	 <1175722246.15973.78.camel@imap.mvista.com>
	 <20070404213404.GA21742@elte.hu>
	 <1175723954.15973.96.camel@imap.mvista.com> <46143941.7050702@goop.org>
	 <1175731253.15973.106.camel@imap.mvista.com> <461440C9.8040902@goop.org>
	 <1175733279.15973.116.camel@imap.mvista.com>
	 <20070405075101.GA14199@elte.hu>
Content-Type: text/plain
Date: Thu, 05 Apr 2007 04:35:15 -0700
Message-Id: <1175772915.15973.125.camel@imap.mvista.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2.1 (2.8.2.1-3.fc6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2007-04-05 at 09:51 +0200, Ingo Molnar wrote:
> * Daniel Walker <dwalker@mvista.com> wrote:
> 
> > [...] Adding a list initializer doesn't change anything..
> 
> Daniel, you are still in denial. OF COURSE it changes something: it adds 
> a line of code to a driver, where that line was not needed before. 
> That's against the fundamental task of a driver model: TO KEEP THINGS 
> SIMPLE. Yes, this concept includes single-line changes as well.

If that's a fundemental rule then we need to expand our horizons to
something a little more flexible .. I understand what your saying, I do,
but it doesn't apply to this change or clocksources . The reason I think
that is because the potential is ~100 drivers or less, once you reach a
critical mass of drivers there's few if any to be added .. So from my
perspective there no reason to overly simplify the structure..

Daniel

