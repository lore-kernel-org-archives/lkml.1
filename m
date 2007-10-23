Return-Path: <linux-kernel-owner+w=401wt.eu-S1753387AbXJWGgb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753387AbXJWGgb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2007 02:36:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752491AbXJWGgR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Oct 2007 02:36:17 -0400
Received: from www.tglx.de ([62.245.132.106]:33439 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752235AbXJWGgQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2007 02:36:16 -0400
Date: Tue, 23 Oct 2007 08:35:57 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
cc: Mark Lord <lkml@rtr.ca>, Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: Regression: 2.6.23-rc9 okay, 2.6.23.1 resume problems
In-Reply-To: <200710230113.25667.rjw@sisk.pl>
Message-ID: <alpine.LFD.0.9999.0710230835100.3167@localhost.localdomain>
References: <4712786B.3040009@rtr.ca> <200710170207.02732.rjw@sisk.pl> <471CAF88.2010806@rtr.ca> <200710230113.25667.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 23 Oct 2007, Rafael J. Wysocki wrote:

> On Monday, 22 October 2007 16:11, Mark Lord wrote:
> > Rafael,
> > 
> > What happens to the jiffies variable on resume from RAM, and from DISK?
> > Do we restore it to the value it had at suspend,
> > or just leave it be with whatever?
> > 
> > The answer has to be "restore the value it had at suspend time",
> > but I figured I'd check here anyway.
> > 
> > ??
> 
> Well, frankly, I've lost track of that recently, but it seems that we just use
> the pre-suspend jiffies (at least in the current -git).
> 
> Thomas knows better, I guess. :-)

We use the pre-suspend value if nothing else fiddled in the variable.

   tglx
