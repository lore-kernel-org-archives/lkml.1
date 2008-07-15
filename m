Return-Path: <linux-kernel-owner+w=401wt.eu-S1761775AbYGOCW4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761775AbYGOCW4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2008 22:22:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761564AbYGOCWn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Jul 2008 22:22:43 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:52769 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760719AbYGOCWm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2008 22:22:42 -0400
Message-ID: <487C09EB.1050903@garzik.org>
Date: Mon, 14 Jul 2008 22:22:35 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Arjan van de Ven <arjan@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       David Woodhouse <dwmw2@infradead.org>, alan@lxorguk.ukuu.org.uk,
       linux-kernel@vger.kernel.org
Subject: Re: [GIT *] Allow request_firmware() to be satisfied from in-kernel,
 use it in more drivers.
References: <1216077806.27455.85.camel@shinybook.infradead.org> <20080714164119.99c33d5b.akpm@linux-foundation.org> <20080714165956.7fe2d4ee@infradead.org> <487C0365.5030203@garzik.org> <alpine.LFD.1.10.0807141911270.3017@woody.linux-foundation.org>
In-Reply-To: <alpine.LFD.1.10.0807141911270.3017@woody.linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.5 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds wrote:
> On Mon, 14 Jul 2008, Jeff Garzik wrote:
>> IMO the newly added /inability/ to build firmware into kernel modules is a
>> clear regression.
> 
> IMO you're being stupid.
> 
> How about explainign why it makes any difference what-so-ever?
> 
> If you can load the module, you can load the firmware. Claiming anything 
> else is just _stupid_.

False -- for every router build script, driver disk build script, etc. 
that has not yet been updated to copy both a module and the 
/lib/firmware that the kernel tree is newly spitting out.

And for every case, the breakage is completely silent, until one boots 
into a firmware-less image and loads drivers.


> And if you cannot see the advantage of having _one_ interface to firmware 
> loading, instead of each driver picking a random approach, I don't know 
> what to say.

It's a great approach!  As I've said over and over and over (and now 
over) again.

My complaints are about --not breaking stuff--, not request_firmware().

You have to look at the build process, second stage image builders, 
embedded system image creators, and other "hangers on" that do not look 
and behave like a mainstream Linux distro.

It is a mistake to assume that all systems are _already_ prepared to 
install and digest new /lib/firmware files that the kernel build now 
spits out.

And the consequences of that assumption is a non-working driver, often a 
non-booting system, not just a few quirks here and there.

	Jeff



