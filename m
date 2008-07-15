Return-Path: <linux-kernel-owner+w=401wt.eu-S1761559AbYGORCN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761559AbYGORCN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2008 13:02:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755648AbYGORB6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jul 2008 13:01:58 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:36262 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755570AbYGORB5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2008 13:01:57 -0400
Message-ID: <487CD7FE.9010209@garzik.org>
Date: Tue, 15 Jul 2008 13:01:50 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: david@lang.hm, Arjan van de Ven <arjan@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       David Woodhouse <dwmw2@infradead.org>, alan@lxorguk.ukuu.org.uk,
       linux-kernel@vger.kernel.org
Subject: Re: [GIT *] Allow request_firmware() to be satisfied from in-kernel,
 use it in more drivers.
References: <1216077806.27455.85.camel@shinybook.infradead.org> <20080714164119.99c33d5b.akpm@linux-foundation.org> <20080714165956.7fe2d4ee@infradead.org> <alpine.DEB.1.10.0807141704120.14223@asgard.lang.hm> <alpine.LFD.1.10.0807141729200.3017@woody.linux-foundation.org> <alpine.DEB.1.10.0807141750290.14223@asgard.lang.hm> <alpine.LFD.1.10.0807141756361.3017@woody.linux-foundation.org> <alpine.DEB.1.10.0807141805300.14223@asgard.lang.hm> <alpine.LFD.1.10.0807141903260.3017@woody.linux-foundation.org> <487C585C.2060002@garzik.org> <alpine.LFD.1.10.0807150803580.3017@woody.linux-foundation.org>
In-Reply-To: <alpine.LFD.1.10.0807150803580.3017@woody.linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.5 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds wrote:
> 
> On Tue, 15 Jul 2008, Jeff Garzik wrote:
>> A more complex, multi-file inter-dependent system is more reliable than a
>> single-file driver with built-in firmware, doing the same thing?
> 
> I'm not interested in your made-up arguments.

It's a simple question...  you claimed A was more reliable than B, even 
though A is a more complex system than B.

I'm curious how that works, especially given that you have claimed the 
_exact opposite_ in years past, by pointing out how firmware separation 
could mean no-boot.


> Please just build everything statically. Don't use modules. They are 
> clearly too complex for you, adn everybody is happy.

Can't you make a simple, objective, technical comparison between two 
systems?

firmware-outside-driver has more utility and flexibility, but more 
things can go wrong, like driver present/firmware absent case that 
happens every day with today's wireless drivers.

firmware-inside-driver guarantees without _any_ doubt that the firmware 
is present, if the driver is guarantee.  There is no guarantee more 
solid than that.

	Jeff


