Return-Path: <linux-kernel-owner+w=401wt.eu-S1756218AbYGOH5f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756218AbYGOH5f (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2008 03:57:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753763AbYGOH51
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jul 2008 03:57:27 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:57057 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750942AbYGOH51 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2008 03:57:27 -0400
Message-ID: <487C585C.2060002@garzik.org>
Date: Tue, 15 Jul 2008 03:57:16 -0400
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
References: <1216077806.27455.85.camel@shinybook.infradead.org> <20080714164119.99c33d5b.akpm@linux-foundation.org> <20080714165956.7fe2d4ee@infradead.org> <alpine.DEB.1.10.0807141704120.14223@asgard.lang.hm> <alpine.LFD.1.10.0807141729200.3017@woody.linux-foundation.org> <alpine.DEB.1.10.0807141750290.14223@asgard.lang.hm> <alpine.LFD.1.10.0807141756361.3017@woody.linux-foundation.org> <alpine.DEB.1.10.0807141805300.14223@asgard.lang.hm> <alpine.LFD.1.10.0807141903260.3017@woody.linux-foundation.org>
In-Reply-To: <alpine.LFD.1.10.0807141903260.3017@woody.linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.5 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds wrote:
> On Mon, 14 Jul 2008, david@lang.hm wrote:
>> On Mon, 14 Jul 2008, Linus Torvalds wrote:
>>> That's a totally bogus argument.
>> you misunderstood me. the people pushing request_firmware() are doing so on
>> the basis that they won't have to use kernel ram to hold the firmware. the
>> people pushing for having the option of building the firmware into the module
>> are acknowleding that this may use a little more ram, but they see it as being
>> more reliable.
> 
> I'm just saying that it's a totally bogus argument to claim that it takes 
> less memory - Either way.

Agreed.


> As to reliability, I don't buy that, especially with a generic interface, 
> and with a way to link the thing in-kernel anyway. Using common 
> infrastructure is going to be more reliable.

A more complex, multi-file inter-dependent system is more reliable than 
a single-file driver with built-in firmware, doing the same thing?

Come _on_.

There are good arguments for request_firmware(), but that ain't it.


> The argument for request_firmware() is that it's a good _single_ interface 
> to the whole firmware issue, allowing us to split up the driver from the 
> firmware without every driver having to do some hack of its own.

Agreed.

	Jeff


