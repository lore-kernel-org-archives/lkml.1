Return-Path: <linux-kernel-owner+w=401wt.eu-S1752921AbYC2MiZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752921AbYC2MiZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Mar 2008 08:38:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751155AbYC2MiR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 29 Mar 2008 08:38:17 -0400
Received: from smtpeu1.atmel.com ([195.65.72.27]:34821 "EHLO bagnes.atmel.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750918AbYC2MiQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Mar 2008 08:38:16 -0400
Date: Sat, 29 Mar 2008 13:36:47 +0100
From: Haavard Skinnemoen <haavard.skinnemoen@atmel.com>
To: Pavel Machek <pavel@ucw.cz>
Cc: Dmitry Baryshkov <dbaryshkov@gmail.com>, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, hskinnemoen@atmel.com,
       domen.puncer@telargo.com, lethal@linux-sh.org, tony@atomide.com,
       rmk+kernel@arm.linux.org.uk, paul@pwsan.com
Subject: Re: [PATCH 1/3] Clocklib: add generic framework for managing
 clocks.
Message-ID: <20080329133647.3799e792@hskinnemo-gx620.norway.atmel.com>
In-Reply-To: <20080328142340.GE4404@ucw.cz>
References: <20080326154913.GA15326@doriath.ww600.siemens.net>
	<20080326155203.GA15405@doriath.ww600.siemens.net>
	<20080326170441.795fb928@hskinnemo-gx620.norway.atmel.com>
	<20080328142340.GE4404@ucw.cz>
Organization: Atmel Norway
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.12.5; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 29 Mar 2008 12:36:48.0402 (UTC) FILETIME=[8E550720:01C89199]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pavel Machek <pavel@ucw.cz> wrote:
> > Hmm...this is exactly twice as big as the struct I'm currently using,
> > it doesn't contain all the fields I need, and it's undocumented.  
> 
> Like unifying 15-or-so versions of clock framework that are out there?

I'm not complaining about the goal of this patchset, I'm just arguing
about the price. And I do think we managed to come to an agreement
later in the thread (which is actually cheaper than what I currently
have!)

> > I have quite a few clocks, so the increased memory consumption is quite
> > significant. What are the advantages of this?  
> 
> How many clocks do you have?

55 currently, and there are still a few clocks that haven't been wired
up yet. So shaving off a few bytes can make a big difference, and other
platforms have even more clocks.

Haavard
