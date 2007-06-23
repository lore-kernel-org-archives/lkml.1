Return-Path: <linux-kernel-owner+w=401wt.eu-S1754202AbXFWIB1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754202AbXFWIB1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Jun 2007 04:01:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751812AbXFWIBT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 Jun 2007 04:01:19 -0400
Received: from server145.whmcpanel.net ([69.72.254.178]:41986 "EHLO
	server459.whmcpanel.net" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1752085AbXFWIBS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Jun 2007 04:01:18 -0400
From: Alberto Gonzalez <info@gnebu.es>
To: Paolo Ornati <ornati@fastwebnet.it>
Subject: Re: Question about fair schedulers
Date: Sat, 23 Jun 2007 10:01:02 +0200
User-Agent: KMail/1.9.7
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <200706230007.15622.info@gnebu.es> <20070623090655.36d1794c@localhost>
In-Reply-To: <20070623090655.36d1794c@localhost>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200706231001.02497.info@gnebu.es>
X-PopBeforeSMTPSenders: info@gnebu.es
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - server459.whmcpanel.net
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - gnebu.es
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks for your thoughts.

On Saturday 23 June 2007, Paolo Ornati wrote:
> On Sat, 23 Jun 2007 00:07:15 +0200
>
> Alberto Gonzalez wrote:
> > My conclusion is that SD behaves as expected: it's more fair. But for a
> > desktop, shouldn't an "intelligently unfair" scheduler be better?
>
> "intelligently unfair" is what the current scheduler is (because of
> interactivity estimator).
>
> When it works (say 90% of the time) the desktop feels really good...
> but when it doesn't it can be a disaster.

I see. So you mean that in 90% of the cases the mainline scheduler behaves 
better than fair schedulers, but when its "logic" fails it behaves much worse 
(the other 10% cases)? In my very simple test scenario the mainline scheduler 
did behave much better. Maybe the problem comes with very complex scenarios 
like the ones I've seen when testing these 2 fair schedulers (something like 
compiling a kernel while you open 5 instances of glxgears, write an email, 
play music in Amarok and watch 2 HD videos all at the same time). The 
question would then be if these kind of situations are likely to happen in 
real world, or even if it doesn't make more sense to try to improve the logic 
of the mainline scheduler so that those 10% cases are handled better instead 
of writing a new one that would behave worse in 90% of the cases and better 
in the other 10%.

	Alberto.
