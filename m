Return-Path: <linux-kernel-owner+w=401wt.eu-S1755242AbYAEXpe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755242AbYAEXpe (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Jan 2008 18:45:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753213AbYAEXp0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 Jan 2008 18:45:26 -0500
Received: from rtr.ca ([76.10.145.34]:1072 "EHLO mail.rtr.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752558AbYAEXpZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Jan 2008 18:45:25 -0500
Message-ID: <47801690.3090106@rtr.ca>
Date: Sat, 05 Jan 2008 18:45:20 -0500
From: Mark Lord <lkml@rtr.ca>
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Adrian Bunk <bunk@kernel.org>
Subject: Re: 2.6.24-rc6-git12: Reported regressions from 2.6.23
References: <200801052042.56042.rjw@sisk.pl>
In-Reply-To: <200801052042.56042.rjw@sisk.pl>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rafael J. Wysocki wrote:
> This message contains a list of some regressions from 2.6.23 reported since
> 2.6.24-rc1 was released, for which there are no fixes in the mainline I know
> of.  If any of them have been fixed already, please let me know.
..
> Subject		: 20000+ wake-ups/second in 2.6.24
> Submitter	: Mark Lord <lkml@rtr.ca>
> Date		: 2007-12-02 04:23
> References	: http://lkml.org/lkml/2007/12/1/141
> 		  http://bugzilla.kernel.org/show_bug.cgi?id=9489
> Handled-By	: Arjan van de Ven <arjan@infradead.org>
> 
..

I have only seen that one once, and I think it was Arjan who said
that it has been observed rarely by other people as well.
The bugzilla entry is mostly just to track the darned thing,
but it seems unlikely that anyone will find/fix it for 2.6.24.
No big deal, but it would be good to have somebody knowledgeable
in clocks/interrupts try and track it down.

I wonder if it's just a babbling IRQ on resume, before the driver
has run it's resume code or something ?

Cheers
