Return-Path: <linux-kernel-owner+w=401wt.eu-S1760359AbXEXN2W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760359AbXEXN2W (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2007 09:28:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757752AbXEXN2M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 May 2007 09:28:12 -0400
Received: from nwd2mail11.analog.com ([137.71.25.57]:39587 "EHLO
	nwd2mail11.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757722AbXEXN2K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2007 09:28:10 -0400
X-IronPort-AV: i="4.14,573,1170651600"; 
   d="scan'208"; a="30831252:sNHT25670645"
From: Robin Getz <rgetz@blackfin.uclinux.org>
Organization: Blackfin uClinux org
To: "Paul Mundt" <lethal@linux-sh.org>
Subject: Re: how to allow board writers to customize driver behavior (watchdog here)
Date: Thu, 24 May 2007 09:29:51 -0400
User-Agent: KMail/1.9.5
Cc: "Mike Frysinger" <vapier.adi@gmail.com>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Bryan Wu" <Bryan.Wu@analog.com>
References: <8bd0f97a0705232121j32fcff72hd04b04e37507450e@mail.gmail.com> <20070524052312.GA2447@linux-sh.org>
In-Reply-To: <20070524052312.GA2447@linux-sh.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200705240929.51696.rgetz@blackfin.uclinux.org>
X-OriginalArrivalTime: 24 May 2007 13:27:16.0890 (UTC) FILETIME=[3F651FA0:01C79E07]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu 24 May 2007 01:23, Paul Mundt pondered:
> On Thu, May 24, 2007 at 12:21:47AM -0400, Mike Frysinger wrote:
> > is this completely bad mojo ?  is there some other mechanism that
> > provides what i want and i just dont know about it ?  or do i just
> > make people change the driver to fit their application, thus throwing
> > out the idea of keeping all board-specific details in just the boards
> > file ...
> 
> It sounds like your constraining your driver based on terminology.
> Watchdogs on most embedded platforms support either a 'reset' mode or
> otherwise act as periodic timers, trying to push both of these
> functionalities in to a watchdog driver is rather pointless.
> CONFIG_WATCHDOG implies 'reset' mode by definition.

I understand what you mean - typically - most people think of watchdog == 
reset.

But, calling it a periodic timer, and servicing it with the watchdog user 
space demon is even more confusing - isn't it?

-Robin
