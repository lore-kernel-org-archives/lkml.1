Return-Path: <linux-kernel-owner+w=401wt.eu-S1753586AbYGELAZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753586AbYGELAZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Jul 2008 07:00:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751170AbYGELAQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 Jul 2008 07:00:16 -0400
Received: from one.firstfloor.org ([213.235.205.2]:60329 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751025AbYGELAP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Jul 2008 07:00:15 -0400
Message-ID: <486F543D.8010409@firstfloor.org>
Date: Sat, 05 Jul 2008 13:00:13 +0200
From: Andi Kleen <andi@firstfloor.org>
User-Agent: Thunderbird 1.5.0.12 (X11/20060911)
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: Joe Peterson <joe@skyrush.com>, Elias Oltmanns <eo@nebensachen.de>,
       =?ISO-8859-1?Q?T=F6r=F6k_Edwin?= <edwintorok@gmail.com>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: Ctrl+C doesn't interrupt process waiting for I/O
References: <48661488.10304@gmail.com>	<87fxqurqpz.fsf@denkblock.local>	<486E83C3.1040509@skyrush.com>	<20080704212335.4ffc8230@lxorguk.ukuu.org.uk>	<871w29s5u2.fsf@basil.nowhere.org>	<20080704221457.1f147225@lxorguk.ukuu.org.uk>	<486E97F2.8020605@firstfloor.org>	<20080704224441.63204bc4@lxorguk.ukuu.org.uk>	<486E9F91.6010701@firstfloor.org> <20080705113434.41109492@lxorguk.ukuu.org.uk>
In-Reply-To: <20080705113434.41109492@lxorguk.ukuu.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Cox wrote:
>> So what kind of data do you want? Someone watching a wallclock while
>> comparing Ctrl-Z+kill versus Ctrl-C on a IO intensive process?
> 
> Latency traces with timestamps might be quite useful, they'd probably
> also tell you why it happened.

Ok so you're asking someone else to debug it.

 I can't reproduce it, nobody has provided
> numbers so even if I wanted to work on it I couldn't do much.

Well we had a patch (although I haven't tried it yet)

http://marc.info/?l=linux-kernel&m=121489861508496&w=2

Is that not concrete enough?

> Instead I have lots of real tty, ATA and other work that needs doing
> which has quantified data,

All the reporters provided time stamp traces? @)

-Andi
