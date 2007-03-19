Return-Path: <linux-kernel-owner+w=401wt.eu-S1751602AbXCSQnQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751602AbXCSQnQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2007 12:43:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751597AbXCSQnP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Mar 2007 12:43:15 -0400
Received: from smtp25.orange.fr ([193.252.22.21]:52704 "EHLO smtp25.orange.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751558AbXCSQnO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2007 12:43:14 -0400
X-ME-UUID: 20070319164313868.D3F911C0009B@mwinf2533.orange.fr
Subject: Re: RSDL v0.31
From: Xavier Bestel <xavier.bestel@free.fr>
To: Mark Lord <lkml@rtr.ca>
Cc: Al Boldi <a1426z@gawab.com>, Mike Galbraith <efault@gmx.de>,
       Con Kolivas <kernel@kolivas.org>, ck@vds.kolivas.org,
       Serge Belyshev <belyshev@depni.sinp.msu.ru>,
       Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Nicholas Miell <nmiell@comcast.net>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <45FEBBF5.9060002@rtr.ca>
References: <200703042335.26785.a1426z@gawab.com>
	 <200703172048.46267.kernel@kolivas.org>
	 <1174125534.7734.2.camel@Homer.simpson.net>
	 <200703172355.30989.a1426z@gawab.com>  <45FEB54A.3040602@rtr.ca>
	 <1174321617.30876.69.camel@frg-rhel40-em64t-04>  <45FEBBF5.9060002@rtr.ca>
Content-Type: text/plain
Date: Mon, 19 Mar 2007 17:43:00 +0100
Message-Id: <1174322580.30876.72.camel@frg-rhel40-em64t-04>
Mime-Version: 1.0
X-Mailer: Evolution 2.0.2 (2.0.2-27) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-03-19 at 12:36 -0400, Mark Lord wrote:
> Xavier Bestel wrote:
> > On Mon, 2007-03-19 at 12:07 -0400, Mark Lord wrote:
> >> Dell notebook, single P-M-2GHz, ATI X300, open source X.org:
> >> (1) build a kernel in one window with "make -j$((NUMBER_OF_CPUS +
> 1))".
> >> (2) try to read email and/or surf in Firefox/Thunderbird.
> >>
> >> Stock scheduler wins easily, no contest.
> > 
> > What happens when you renice X ?
> 
> Dunno -- not necessary with the stock scheduler.

Could you try something like renice -10 $(pidof Xorg) ?

	Xav


