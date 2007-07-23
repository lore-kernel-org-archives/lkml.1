Return-Path: <linux-kernel-owner+w=401wt.eu-S1762578AbXGWWYQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762578AbXGWWYQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jul 2007 18:24:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751965AbXGWWYF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jul 2007 18:24:05 -0400
Received: from gate.crashing.org ([63.228.1.57]:58215 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751716AbXGWWYD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jul 2007 18:24:03 -0400
Subject: Re: Power Management framework proposal
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Arjan van de Ven <arjan@infradead.org>
Cc: david@lang.hm, LKML <linux-kernel@vger.kernel.org>,
       linux-pm <linux-pm@lists.linux-foundation.org>
In-Reply-To: <1185125189.2714.13.camel@laptopd505.fenrus.org>
References: <Pine.LNX.4.64.0707212339550.6350@asgard.lang.hm>
	 <1185125189.2714.13.camel@laptopd505.fenrus.org>
Content-Type: text/plain
Date: Tue, 24 Jul 2007 08:23:25 +1000
Message-Id: <1185229405.5439.148.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2007-07-22 at 10:26 -0700, Arjan van de Ven wrote:
> On Sat, 2007-07-21 at 23:49 -0700, david@lang.hm wrote:
> 
> > this approach would allow the transition of ALL drivers to the new mode of 
> > operation in one fell swoop, and then adding additional power management 
> > features is just adding to the existing list rather then implementing new 
> > functions.
> 
> 
> I have a concern with this approach though. It seems to assume that
> there is one global thing somewhere that sets the system state; in my
> experience that is the wrong approach; in fact there is a very definite
> evidence that there are many decisions on power that are to be made
> local at a high frequency. An example of this is the processor speed;
> the ondemand governer does exactly this for the cpus that can switch
> speeds fast; it's just impossible to beat such a local, fast decision
> with anything on a global scale.
> 
> On the other hand, some things (the high level goals and constraints)
> are obviously global.

I think we need a set of constraints that trickle down the power tree
and limit what a given driver can do locally.

Ben.

