Return-Path: <linux-kernel-owner+w=401wt.eu-S1753248AbZCSOQD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753248AbZCSOQD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Mar 2009 10:16:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753148AbZCSOPs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Mar 2009 10:15:48 -0400
Received: from charlotte.tuxdriver.com ([70.61.120.58]:43892 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752311AbZCSOPr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Mar 2009 10:15:47 -0400
Date: Thu, 19 Mar 2009 10:13:11 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Jeff Chua <jeff.chua.linux@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Adrian Bunk <bunk@kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Network Development <netdev@vger.kernel.org>
Subject: Re: 2.6.29-rc8: Reported regressions from 2.6.28
Message-ID: <20090319141311.GA3587@tuxdriver.com>
References: <b6a2187b0903142006u546fad9eme66f9ea7b464b81f@mail.gmail.com> <1237140665.24621.2.camel@johannes.local> <alpine.LFD.2.00.0903151136310.3131@localhost.localdomain> <1237143683.24621.7.camel@johannes.local> <20090315202603.GA9077@elte.hu> <b6a2187b0903160624gb9d207dv301506e589d93ed4@mail.gmail.com> <1237317742.31814.28.camel@johannes.local> <b6a2187b0903181958ke11abe7tdcbc4efeb950954d@mail.gmail.com> <b6a2187b0903182149x77e416ecuf73be2970173c601@mail.gmail.com> <1237455534.5100.56.camel@johannes.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1237455534.5100.56.camel@johannes.local>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 19, 2009 at 10:38:54AM +0100, Johannes Berg wrote:
> On Thu, 2009-03-19 at 12:49 +0800, Jeff Chua wrote:
> 
> > Ignore the above loop thing. The cause seems to be this one instead.
> > 
> > 
> > # this needs patch to work ...
> > iwconfig wlan0 mode Managed
> > ifconfig wlan0 up
> > iwconfig wlan0 essid xxx
> > iwconfig wlan0 key restricted xxx
> > iwconfig wlan0 ap auto channel auto
> 
> If you swap the key and essid lines, it will probably always work. But
> I've yet to analyse your data to see why it doesn't in the other case.

That is what I was going to suggest.  I go so far as to say that you
should set everything else before doing the "iwconfig wlan0 essid
xxx" bit.

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
