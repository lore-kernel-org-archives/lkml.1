Return-Path: <linux-kernel-owner+w=401wt.eu-S1030357AbXCSQgL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030357AbXCSQgL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2007 12:36:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030361AbXCSQgK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Mar 2007 12:36:10 -0400
Received: from ottawa-hs-64-26-128-89.s-ip.magma.ca ([64.26.128.89]:1557 "EHLO
	mail.rtr.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030357AbXCSQgJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2007 12:36:09 -0400
Message-ID: <45FEBBF5.9060002@rtr.ca>
Date: Mon, 19 Mar 2007 12:36:05 -0400
From: Mark Lord <lkml@rtr.ca>
User-Agent: Thunderbird 1.5.0.10 (X11/20070221)
MIME-Version: 1.0
To: Xavier Bestel <xavier.bestel@free.fr>
Cc: Al Boldi <a1426z@gawab.com>, Mike Galbraith <efault@gmx.de>,
       Con Kolivas <kernel@kolivas.org>, ck@vds.kolivas.org,
       Serge Belyshev <belyshev@depni.sinp.msu.ru>,
       Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Nicholas Miell <nmiell@comcast.net>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: RSDL v0.31
References: <200703042335.26785.a1426z@gawab.com>	 <200703172048.46267.kernel@kolivas.org>	 <1174125534.7734.2.camel@Homer.simpson.net>	 <200703172355.30989.a1426z@gawab.com>  <45FEB54A.3040602@rtr.ca> <1174321617.30876.69.camel@frg-rhel40-em64t-04>
In-Reply-To: <1174321617.30876.69.camel@frg-rhel40-em64t-04>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Xavier Bestel wrote:
> On Mon, 2007-03-19 at 12:07 -0400, Mark Lord wrote:
>> Dell notebook, single P-M-2GHz, ATI X300, open source X.org:
>> (1) build a kernel in one window with "make -j$((NUMBER_OF_CPUS + 1))".
>> (2) try to read email and/or surf in Firefox/Thunderbird.
>>
>> Stock scheduler wins easily, no contest.
> 
> What happens when you renice X ?

Dunno -- not necessary with the stock scheduler.
Nicing the "make" helped with RSDL, though.
But again, the stock scheduler "just works" in that regard.

I agree with Ingo -- the auto-renice feature is something
very useful for desktops, and is missing from RSDL.

Cheers
