Return-Path: <linux-kernel-owner+w=401wt.eu-S1757244AbYGOSeJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757244AbYGOSeJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2008 14:34:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758786AbYGOSdk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jul 2008 14:33:40 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:52491 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758737AbYGOSdi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2008 14:33:38 -0400
Message-ID: <487CED7C.4060401@garzik.org>
Date: Tue, 15 Jul 2008 14:33:32 -0400
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
References: <1216077806.27455.85.camel@shinybook.infradead.org> <20080714164119.99c33d5b.akpm@linux-foundation.org> <20080714165956.7fe2d4ee@infradead.org> <alpine.DEB.1.10.0807141704120.14223@asgard.lang.hm> <alpine.LFD.1.10.0807141729200.3017@woody.linux-foundation.org> <alpine.DEB.1.10.0807141750290.14223@asgard.lang.hm> <alpine.LFD.1.10.0807141756361.3017@woody.linux-foundation.org> <alpine.DEB.1.10.0807141805300.14223@asgard.lang.hm> <alpine.LFD.1.10.0807141903260.3017@woody.linux-foundation.org> <487C585C.2060002@garzik.org> <alpine.LFD.1.10.0807150803580.3017@woody.linux-foundation.org> <487CD7FE.9010209@garzik.org> <alpine.LFD.1.10.0807151008450.3017@woody.linux-foundation.org> <487CDEC0.3090004@garzik.org> <alpine.LFD.1.10.0807151041080.3017@woody.linux-foundation.org> <alpine.LFD.1.10.0807151042170.3017@woody.linux-foundation.org> <487CE85D.8050107@garzik.org> <alpine.LFD.1.10.0807151120280.3017@woody.linux-foundation.org>
In-Reply-To: <alpine.LFD.1.10.0807151120280.3017@woody.linux-foundation.org>
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
>> Can't you see that changing build processes takes time?  Fixing driver disk
>> creation tools take time?  Validating that each driver is packaged with its
>> correct firmware takes time?
> 
> Umm. Can't you see that if we don't start doing it, it will never get done 
> AT ALL?
> 
> Yes, this will take time.

Which, by implication, means that userland is not -already- prepared.

Which means that if you don't have a recent userland of a mainstream 
distro, the result is non-working drivers.

Which is the type of regression I thought we did not want.


> But that's not an argument for not merging it. Quite the reverse.

This is not an either/or proposition, and that is what you are missing.

The change should go in _while at the same time_ not creating regressions.

The change is not the problem.

That the change exists without the ability to recreate similar outputs 
(i.e. firmware in module) is the problem.

	Jeff


