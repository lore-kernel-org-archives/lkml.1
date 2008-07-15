Return-Path: <linux-kernel-owner+w=401wt.eu-S1756412AbYGOS4A@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756412AbYGOS4A (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2008 14:56:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756818AbYGOSzl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jul 2008 14:55:41 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:42005 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756616AbYGOSzk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2008 14:55:40 -0400
Message-ID: <487CF29E.5000009@garzik.org>
Date: Tue, 15 Jul 2008 14:55:26 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
       Frans Pop <elendil@planet.nl>, arjan@infradead.org,
       akpm@linux-foundation.org, dwmw2@infradead.org,
       alan@lxorguk.ukuu.org.uk, linux-kernel@vger.kernel.org
Subject: Re: [GIT *] Allow request_firmware() to be satisfied from in-kernel,
 use it in more drivers.
References: <1216077806.27455.85.camel@shinybook.infradead.org> <20080714164119.99c33d5b.akpm@linux-foundation.org> <20080714165956.7fe2d4ee@infradead.org> <487C0365.5030203@garzik.org> <487C0365.5030203@garzik.org> <alpine.LFD.1.10.0807141911270.3017@woody.linux-foundation.org> <200807151757.10626.elendil@planet.nl> <20080715180535.GA6080@khazad-dum.debian.net> <487CE917.3000000@garzik.org> <alpine.LFD.1.10.0807151122010.3017@woody.linux-foundation.org>
In-Reply-To: <alpine.LFD.1.10.0807151122010.3017@woody.linux-foundation.org>
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
> 
>> Henrique de Moraes Holschuh wrote:
>>> On Tue, 15 Jul 2008, Frans Pop wrote:
>>>> If I were able to compile firmware into the modules, the problem would be
>>>> solved in one go.
>>> And this thread would have been shorter, even. I hope someone decides to
>>> write that support instead of complaining ;-)
>> I've volunteered -- but if Linus and David will reject my code out of hand,
>> there is not much point in writing it.
> 
> Quite frankly, I don't think it's something to reject out of hand, but it 
> does sound pretty damn stupid.
> 
> Why compile them into the module, when that's just the _inflexible_ model?

Because it works today.

Because that is what people and their scripts expect, today.

Because people should not be forced to fix all their firmware-related 
breakage immediately, just to boot 2.6.27.


> I'm not seeing why you cannot accept change.

It is highly feasible to do the change without breaking stuff and 
removing choice.

Beer can be great tasting AND less filling.

	Jeff


