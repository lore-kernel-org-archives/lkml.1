Return-Path: <linux-kernel-owner+w=401wt.eu-S1762455AbYGOSPR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762455AbYGOSPR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2008 14:15:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756011AbYGOSPD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jul 2008 14:15:03 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:39865 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757029AbYGOSPB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2008 14:15:01 -0400
Message-ID: <487CE917.3000000@garzik.org>
Date: Tue, 15 Jul 2008 14:14:47 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
CC: Frans Pop <elendil@planet.nl>,
       Linus Torvalds <torvalds@linux-foundation.org>, arjan@infradead.org,
       akpm@linux-foundation.org, dwmw2@infradead.org,
       alan@lxorguk.ukuu.org.uk, linux-kernel@vger.kernel.org
Subject: Re: [GIT *] Allow request_firmware() to be satisfied from	in-kernel,
 use it in more drivers.
References: <1216077806.27455.85.camel@shinybook.infradead.org> <20080714164119.99c33d5b.akpm@linux-foundation.org> <20080714165956.7fe2d4ee@infradead.org> <487C0365.5030203@garzik.org> <487C0365.5030203@garzik.org> <alpine.LFD.1.10.0807141911270.3017@woody.linux-foundation.org> <200807151757.10626.elendil@planet.nl> <20080715180535.GA6080@khazad-dum.debian.net>
In-Reply-To: <20080715180535.GA6080@khazad-dum.debian.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.5 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Henrique de Moraes Holschuh wrote:
> On Tue, 15 Jul 2008, Frans Pop wrote:
>> If I were able to compile firmware into the modules, the problem would be 
>> solved in one go.
> 
> And this thread would have been shorter, even. I hope someone decides to
> write that support instead of complaining ;-)

I've volunteered -- but if Linus and David will reject my code out of 
hand, there is not much point in writing it.


>> [2] As one of the developers for Debian Installer I'm not looking forward 
>> to the complications that is going to cause for us and users.
> 
> That was my point.  These firmware loading changes are good, but there is a
> lot of crap missing (most of it NOT in the kernel) before it can be exposed
> to ordinary users.

100% agreed.

That's the point I've been trying to make all along.

The end goal is good, but it's not at all ready for normal users.


> And without firmware-in-the-module support (which is the ONLY scenario where
> the entire userspace will not notice anything different), this WILL cause
> problem to distros, we will need to scramble up and fix it all before we can
> package 2.6.26.  I don't know if this is a big problem, though.  The work
> will need to be done sooner or later anyway, and we should have enough time
> to do so as long as we don't care for packaging the early -rc.

Agreed.

	Jeff


