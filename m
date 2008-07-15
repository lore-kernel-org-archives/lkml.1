Return-Path: <linux-kernel-owner+w=401wt.eu-S1756208AbYGODP4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756208AbYGODP4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2008 23:15:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756883AbYGODPh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Jul 2008 23:15:37 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:52342 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756744AbYGODPg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2008 23:15:36 -0400
Message-ID: <487C1648.5070409@garzik.org>
Date: Mon, 14 Jul 2008 23:15:20 -0400
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
References: <1216077806.27455.85.camel@shinybook.infradead.org> <20080714164119.99c33d5b.akpm@linux-foundation.org> <20080714165956.7fe2d4ee@infradead.org> <487C0365.5030203@garzik.org> <alpine.LFD.1.10.0807141911270.3017@woody.linux-foundation.org> <487C09EB.1050903@garzik.org> <alpine.LFD.1.10.0807141928540.3017@woody.linux-foundation.org>
In-Reply-To: <alpine.LFD.1.10.0807141928540.3017@woody.linux-foundation.org>
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
> On Mon, 14 Jul 2008, Jeff Garzik wrote:
>> My complaints are about --not breaking stuff--, not request_firmware().
> 
> Guys, request_firmware() has been around for about five years now.
> 
> If this discussion had happened in 2003, I'd agree.
> 
> As it is, I think it's time to just face it - many people do want to have 
> a unified interface (and yes, I obviously count myself in that group), and 
> you can't just continue do nothing and ignore that.
> 
> Your argument seems to be that you don't want to break anything, but 
> you've also clearly not wanted to _fix_ anything for the last five years. 
> 
> At some point, somebody has to just do it. And five years is _way_ long 
> enough.

In threads of years past, you've agreed with the plainly obvious -- 
built-in firmware is obviously more reliable, and is more likely to 
produce a working driver.

It doesn't break anything to keep this feature.

Keeping this feature doesn't prevent any other fixes.

Keeping this feature closes the window for potential regressions.

And keeping this feature means Linux users can make a _choice_, rather 
than forcing /lib/firmware on them.

Do you really think embedded system and micro distro authors are in 100% 
agreement that /lib/firmware is best for their situation?  Really?

	Jeff


