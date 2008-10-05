Return-Path: <linux-kernel-owner+w=401wt.eu-S1754847AbYJEMDT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754847AbYJEMDT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Oct 2008 08:03:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753748AbYJEMDA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 5 Oct 2008 08:03:00 -0400
Received: from relay.2ka.mipt.ru ([194.85.80.65]:43359 "EHLO 2ka.mipt.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753731AbYJEMC7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Oct 2008 08:02:59 -0400
Date: Sun, 5 Oct 2008 16:01:37 +0400
From: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Natalie Protasevich <protasnb@gmail.com>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Network Development <netdev@vger.kernel.org>
Subject: Re: 2.6.27-rc8-git7: Reported regressions from 2.6.26
Message-ID: <20081005120136.GA22457@2ka.mipt.ru>
References: <0pOgGB.A.uLG.E475IB@wind> <20081005071421.GA17685@2ka.mipt.ru> <200810051302.20896.rjw@sisk.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200810051302.20896.rjw@sisk.pl>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 05, 2008 at 01:02:20PM +0200, Rafael J. Wysocki (rjw@sisk.pl) wrote:
> > Just for the reference, this one regresses from the 2.6.23.
> 
> Still, tbench results from 2.6.26 are better than from 2.6.27-rc.
> That's why it's still on the list, but if you think that's not relevant, please
> let me know and I'll drop it.

I meant it continuously regresses from .23 including 26-27 timeframe.
There were at least two changes in 26-27 which caused tbench regression
in this particular time interval. One of them enabled TSO over loopback
by default, so one can turn it off via ethtools or this patch:
http://marc.info/?l=linux-netdev&m=122263663631600&w=2

another (hopefully) one I'm trying to find out, which is a bit complex
and slow, since e1000 driver changes in the middle of the 26-27
timeframe does not allow my testing machines to boot.

So, there is a regression (partially resolved), but it is only part of
the problem.

-- 
	Evgeniy Polyakov
