Return-Path: <linux-kernel-owner+w=401wt.eu-S965550AbXDIPi3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965550AbXDIPi3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Apr 2007 11:38:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965578AbXDIPi3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Apr 2007 11:38:29 -0400
Received: from smtpq1.groni1.gr.home.nl ([213.51.130.200]:47645 "EHLO
	smtpq1.groni1.gr.home.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965550AbXDIPi2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Apr 2007 11:38:28 -0400
Message-ID: <461A5DA2.7090001@gmail.com>
Date: Mon, 09 Apr 2007 17:37:06 +0200
From: Rene Herman <rene.herman@gmail.com>
User-Agent: Thunderbird 1.5.0.10 (X11/20070221)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Gene Heskett <gene.heskett@gmail.com>, linux-kernel@vger.kernel.org,
       Con Kolivas <kernel@kolivas.org>, Mike Galbraith <efault@gmx.de>,
       Andrew Morton <akpm@linux-foundation.org>, ck list <ck@vds.kolivas.org>
Subject: Re: Ten percent test
References: <200703290237.38777.kernel@kolivas.org> <200704071423.47790.gene.heskett@gmail.com> <20070407185220.GA31725@elte.hu> <200704071630.25830.gene.heskett@gmail.com> <20070408104125.GB11123@elte.hu> <461939A4.2020305@gmail.com> <20070409135355.GA11244@elte.hu>
In-Reply-To: <20070409135355.GA11244@elte.hu>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
X-AtHome-MailScanner-Information: Please contact support@home.nl for more information
X-AtHome-MailScanner: Found to be clean
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/09/2007 03:53 PM, Ingo Molnar wrote:

> In any case, it would be very nice if you could try Mike's latest
> patch, how does it work on your setup? (i've attached it)

Can do. Note that "my setup" in that case consisted of browsing around 
eBay in firefox with ogg123 playing audio directly to ALSA in an xterm 
as the only other thing running. That is, just about as basic a Linux 
desktop as imagineable.

Testing Mike's latest will have to wait a bit though; I'm currently 
testing the latest incarnation of SD (against 2.6.20.6). For people 
who've lost track of what and where, it's available as:

http://ck.kolivas.org/patches/staircase-deadline/2.6.20.5-sd-0.39.patch

and versus 2.6.21-rc5 as:

http://ck.kolivas.org/patches/staircase-deadline/2.6.21-rc5-sd-0.39.patch

For the moment it is giving me a snappy feeling desktop on this Duron 
1300, with ogg123 playing in an xterm without audio underruns, with a 
make -j2 kernel compile running (not niced) and me browsing around in 
firefox.

Mike latest would probably also support this load without much problem. 
Given that I feel the basic idea of SD is better than mainline though, 
I'll be concentrating on using SD for a bit for now.

Rene.

