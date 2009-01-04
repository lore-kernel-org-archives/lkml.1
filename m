Return-Path: <linux-kernel-owner+w=401wt.eu-S1758671AbZADR1P@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758671AbZADR1P (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Jan 2009 12:27:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754945AbZADR07
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Jan 2009 12:26:59 -0500
Received: from yw-out-2324.google.com ([74.125.46.29]:63031 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754513AbZADR07 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Jan 2009 12:26:59 -0500
Message-ID: <f73f7ab80901040926t49ec20f5oac8750813bfb3622@mail.gmail.com>
Date: Sun, 4 Jan 2009 12:26:56 -0500
From: "Kyle Moffett" <kyle@moffetthome.net>
To: "Sitsofe Wheeler" <sitsofe@yahoo.com>
Subject: Re: Bug: Status/Summary of slashdot leap-second crash on new years 2008-2009
Cc: david@lang.hm, "David Newall" <davidn@davidnewall.com>,
       "Ben Goodger" <goodgerster@gmail.com>,
       "Robert Hancock" <hancockr@shaw.ca>, linux-kernel@vger.kernel.org,
       linasvepstas@gmail.com, "Jeffrey J. Kosowsky" <jeff@kosowsky.org>,
       MentalMooMan <slashdot@jameshallam.info>,
       "Travis Crump" <pretzalz@techhouse.org>, burdell@iruntheinter.net
In-Reply-To: <4960E0BB.4070500@yahoo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <fa.dw2l5ZM+UL3xoF6IYh5RLMmbYfw@ifi.uio.no>
	 <fa.XOM1F85uBvmj4QzZKaDu36nYBk0@ifi.uio.no>
	 <fa.rviZJBmVqkAE5uxDjhJOpIuKT4g@ifi.uio.no>
	 <fa.OPVERUiJ763jH2/QynTxgBgoKYw@ifi.uio.no>
	 <fa.v3FUjJ43bw2G7KiZGaxqL3tD4xo@ifi.uio.no>
	 <fa.BrNhgY8S+TEOLMiPd27M7YHo9bI@ifi.uio.no>
	 <4960E0BB.4070500@yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 4, 2009 at 11:15 AM, Sitsofe Wheeler <sitsofe@yahoo.com> wrote:
> Windows is also known not to do it without slewing:
> http://www.meinberg.de/english/info/leap-second.htm#os .

Well... Microsoft "[does] not guarantee and [does] not support the
accuracy of the W32Time service between nodes on a network. The
W32Time service is not a full-featured NTP solution that meets
time-sensitive application needs."  (See
http://support.microsoft.com/kb/939322).  The w32time daemon is not
guaranteed to be within a few seconds of UTC at *any* time of the
year, let alone immediately after a leap-second.  In addition, windows
does not have any built-in interpolation between timer ticks, so time
increases in ~15ms steps regardless of how accurate your clock is.

Cheers,
Kyle Moffett
