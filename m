Return-Path: <linux-kernel-owner+w=401wt.eu-S1762193AbXGEWaZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762193AbXGEWaZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jul 2007 18:30:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760020AbXGEWaM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Jul 2007 18:30:12 -0400
Received: from mx1.redhat.com ([66.187.233.31]:59421 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758575AbXGEWaK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jul 2007 18:30:10 -0400
Message-Id: <200707052228.l65MSdvA025440@pasta.boston.redhat.com>
To: "Chris Friesen" <cfriesen@nortel.com>
cc: Clemens Koller <clemens.koller@anagramm.de>,
       Chris Wright <chrisw@sous-sol.org>, Uli Luckas <u.luckas@road.de>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.21.5 june 30th to july 1st date hang?
In-Reply-To: Your message of "Thu, 05 Jul 2007 11:48:33 MDT."
             <468D2EF1.7050908@nortel.com>
Date: Thu, 05 Jul 2007 18:28:39 -0400
From: Ernie Petrides <petrides@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, 5-Jul-2007 at 11:48 MDT, "Chris Friesen" wrote:

> Clemens Koller wrote:
> 
> > Okay, we all survived Y2K and this little glitch. Puh! ;-)
> > Can you please explain in which configuration this problem got triggered.
> 
> As far as I can tell many kernel versions contained the source code bug. 
>   (I'd like some more information on exactly what the problem was if 
> anyone cares to share..the proposed patch didn't give much in the way of 
> specifics.)
> 
> However, in order to trigger the problem you also need to have NTP 
> servers that were erroneously broadcasting the addition of a leap second.
> 
> So most people didn't see the issue because there wasn't supposed to be 
> a leap second added this year...but they would have seen it the next 
> time a leap second was added.

Only kernels built with the CONFIG_HIGH_RES_TIMERS option enabled were
vulnerable.

Cheers.  -ernie
