Return-Path: <linux-kernel-owner+w=401wt.eu-S1756879AbZADQQU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756879AbZADQQU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Jan 2009 11:16:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752333AbZADQQM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Jan 2009 11:16:12 -0500
Received: from ptb-relay02.plus.net ([212.159.14.146]:37211 "EHLO
	ptb-relay02.plus.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752279AbZADQQL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Jan 2009 11:16:11 -0500
Message-ID: <4960E0BB.4070500@yahoo.com>
Date: Sun, 04 Jan 2009 16:15:55 +0000
From: Sitsofe Wheeler <sitsofe@yahoo.com>
User-Agent: Thunderbird 2.0.0.19 (Macintosh/20081209)
MIME-Version: 1.0
To: david@lang.hm
CC: David Newall <davidn@davidnewall.com>, Kyle Moffett <kyle@moffetthome.net>,
       Ben Goodger <goodgerster@gmail.com>, Robert Hancock <hancockr@shaw.ca>,
       linux-kernel@vger.kernel.org, linasvepstas@gmail.com,
       "Jeffrey J. Kosowsky" <jeff@kosowsky.org>,
       MentalMooMan <slashdot@jameshallam.info>,
       Travis Crump <pretzalz@techhouse.org>, burdell@iruntheinter.net
Subject: Re: Bug: Status/Summary of slashdot leap-second crash on new years
 2008-2009
References: <fa.dw2l5ZM+UL3xoF6IYh5RLMmbYfw@ifi.uio.no> <fa.XOM1F85uBvmj4QzZKaDu36nYBk0@ifi.uio.no> <fa.rviZJBmVqkAE5uxDjhJOpIuKT4g@ifi.uio.no> <fa.OPVERUiJ763jH2/QynTxgBgoKYw@ifi.uio.no> <fa.v3FUjJ43bw2G7KiZGaxqL3tD4xo@ifi.uio.no> <fa.BrNhgY8S+TEOLMiPd27M7YHo9bI@ifi.uio.no>
In-Reply-To: <fa.BrNhgY8S+TEOLMiPd27M7YHo9bI@ifi.uio.no>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Plusnet-Relay: c983e8f5b81aad574b63d722a1bf12b4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

david@lang.hm wrote:
> so are you saying that other 'correct' OS's have patches issued every 
> time a leap second is declared so that they have an in-kernel table of 
> them to use to calculate the correct time?

I think the number of other "correct" OSes that actually step the time 
on leap seconds is not that large (at least doing the announcement via 
NTP). According to http://www.ntp.org/ntpfaq/NTP-s-algo-real.htm#AEN2499 
leap seconds are only changed via stepping if you have the right kernel 
discipline (notes on how to check whether a given OS has the kernel 
kernel discipline are mentioned on 
http://www.ntp.org/ntpfaq/NTP-s-algo-kernel.htm#AEN2220 ).

I have a feeling that OSX doesn't do it (there's a mailing list post 
from 2005 where someone was trying to add FreeBSD's ntp_adjtime to 
Darwin 
http://lists.apple.com/archives/Darwin-kernel/2005/Jan/msg00004.html ). 
Additionally folks I know using ntpd synchronized OSX machines said 
their machines were off by one second right after the new year.

Windows is also known not to do it without slewing: 
http://www.meinberg.de/english/info/leap-second.htm#os .
