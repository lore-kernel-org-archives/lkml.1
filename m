Return-Path: <linux-kernel-owner+w=401wt.eu-S1758015AbYDDJxU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758015AbYDDJxU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Apr 2008 05:53:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752778AbYDDJxF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Apr 2008 05:53:05 -0400
Received: from moutng.kundenserver.de ([212.227.126.183]:64832 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752756AbYDDJxD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Apr 2008 05:53:03 -0400
From: Bodo Eggert <7eggert@gmx.de>
Subject: Re: GFP_ATOMIC page allocation failures.
To: Nick Piggin <nickpiggin@yahoo.com.au>, Jeff Garzik <jeff@garzik.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Chris Snook <csnook@redhat.com>, Dave Jones <davej@codemonkey.org.uk>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       NetDev <netdev@vger.kernel.org>, David Miller <davem@davemloft.net>,
       Linus Torvalds <torvalds@linux-foundation.org>
Reply-To: 7eggert@gmx.de
Date: Fri, 04 Apr 2008 11:52:34 +0200
References: <adYyJ-20N-11@gated-at.bofh.it> <aef6w-6rx-45@gated-at.bofh.it> <aefJ9-7KR-15@gated-at.bofh.it> <aeqF6-45P-29@gated-at.bofh.it>
User-Agent: KNode/0.10.4
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7Bit
Message-Id: <E1Jhib4-0000md-FP@be1.7eggert.dyndns.org>
X-be10.7eggert.dyndns.org-MailScanner-Information: See www.mailscanner.info for information
X-be10.7eggert.dyndns.org-MailScanner: Found to be clean
X-be10.7eggert.dyndns.org-MailScanner-From: 7eggert@gmx.de
X-Provags-ID: V01U2FsdGVkX19Pqd6uQU9Us49gWMIVLpzoPzdoGCmW2Cf+opU
 uMCN38UpbdikZlhhyu1p0pJE8ZzKXUNUTj5V8rV3BJpLneRuE+
 UKe+p4R8AhGKG6UCTuHWQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Nick Piggin <nickpiggin@yahoo.com.au> wrote:
> On Thursday 03 April 2008 05:18, Jeff Garzik wrote:

>> Turning to Nick's comment,
>>
>> > It's still actually nice to know how often it is happening even for
>> > these known good sites because too much can indicate a problem and
>> > that you could actually bring performance up by tuning some things.
>>
>> then create a counter or acculuation buffer somewhere.
>>
>> We don't need spew every time there is memory pressure of this magnitude.
> 
> Not a complete solution. Counter would be nice, but you need backtraces
> and want a way to more proactively warn the user/tester/developer.
> 
> I agree that I don't exactly like adding nowarns around, and I don't think
> places like driver writers should have to know about this stuff.

What about reverse ratelimiting: If the limit is reached, a backtrace will be
generated (and, off cause, positively ratelimited)?

