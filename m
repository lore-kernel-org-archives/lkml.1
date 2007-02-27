Return-Path: <linux-kernel-owner+w=401wt.eu-S965267AbXB0APX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965267AbXB0APX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Feb 2007 19:15:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965280AbXB0APW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Feb 2007 19:15:22 -0500
Received: from tmailer.gwdg.de ([134.76.10.23]:37682 "EHLO tmailer.gwdg.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965267AbXB0APT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Feb 2007 19:15:19 -0500
Date: Tue, 27 Feb 2007 01:14:00 +0100 (MET)
From: Jan Engelhardt <jengelh@linux01.gwdg.de>
To: Stephen Hemminger <shemminger@linux-foundation.org>
cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [RFC] div64_64 support
In-Reply-To: <20070226160708.3c7a8d29@freekitty>
Message-ID: <Pine.LNX.4.61.0702270111200.23355@yvahk01.tjqt.qr>
References: <20070223170527.4ca695b2@freekitty> <Pine.LNX.4.61.0702262108010.23355@yvahk01.tjqt.qr>
 <20070226143127.5c74bec9@freekitty> <Pine.LNX.4.61.0702262348140.23355@yvahk01.tjqt.qr>
 <20070226154413.4ead571a@freekitty> <Pine.LNX.4.61.0702270103060.23355@yvahk01.tjqt.qr>
 <20070226160708.3c7a8d29@freekitty>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Spam-Report: Content analysis: 0.0 points, 6.0 required
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Feb 26 2007 16:07, Stephen Hemminger wrote:
>> On Feb 26 2007 15:44, Stephen Hemminger wrote:
>> >> >-		x = (2 * x + (uint32_t) div64_64(a, x*x)) / 3;
>> >> >+		x = (2 * x + (u32) (a / x*x)) / 3;
>> >> 
>> >> Previously there was div64_64(a, x*x) which is equivalent to
>> >> (a)/(x*x), or just: a/(x^2). But now you do a/x*x, which is
>> >> equivalent to a*x/x (in the domain of real numbers). Furthermore,
>> >> a/x*x is a-(a%x), which does not even remotely match a/(x^2).
>> >> 
>> >Been there, done that, don't want to repeat it...
>> 
>> I am sorry I don't quite follow.
>
>Once before a missed paren's caused a TCP congestion window bug that
>took 6 months before it was found...

Hah, just as I expected.

|On Tue, 27 Feb 2007 00:02:50 +0100 (MET), Jan Engelhardt wrote:
|>Then our reviewers should catch it, and if not, the janitors will.


Jan
-- 
