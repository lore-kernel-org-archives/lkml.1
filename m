Return-Path: <linux-kernel-owner+w=401wt.eu-S1755205AbYGOIHw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755205AbYGOIHw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2008 04:07:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752380AbYGOIHf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jul 2008 04:07:35 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:41304 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751867AbYGOIHe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2008 04:07:34 -0400
Message-ID: <487C5ABE.2010907@garzik.org>
Date: Tue, 15 Jul 2008 04:07:26 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: David Woodhouse <dwmw2@infradead.org>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>, alan@lxorguk.ukuu.org.uk,
       linux-kernel@vger.kernel.org
Subject: Re: [GIT *] Allow request_firmware() to be satisfied from	in-kernel,
 use it in more drivers.
References: <1216077806.27455.85.camel@shinybook.infradead.org>	 <20080714164119.99c33d5b.akpm@linux-foundation.org>	 <20080714165956.7fe2d4ee@infradead.org> <487C0365.5030203@garzik.org>	 <alpine.LFD.1.10.0807141911270.3017@woody.linux-foundation.org>	 <487C09EB.1050903@garzik.org>	 <alpine.LFD.1.10.0807141928540.3017@woody.linux-foundation.org>	 <487C1648.5070409@garzik.org>	 <alpine.LFD.1.10.0807142027140.3017@woody.linux-foundation.org>	 <487C500F.8000109@garzik.org> <1216107418.27455.236.camel@shinybook.infradead.org>
In-Reply-To: <1216107418.27455.236.camel@shinybook.infradead.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.5 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Woodhouse wrote:
> On Tue, 2008-07-15 at 03:21 -0400, Jeff Garzik wrote:
>> * forced a flag day build process change upon all distros/builders who 
>> switch to >= 2.6.27.  no build script updates == non-working drivers.
> 
> Jeff, we don't usually call it a 'flag day' when it's just the normal
> and uninteresting case that you update the upstream version of the
> package, and you need minor tweaks to how you package it. That happens
> all the time. A general rule of thumb is to stop drinking at least 4
> hours before undertaking a full version upgrade of _any_ package you
> maintain.
> 
> You could argue that converting a wireless driver to use mac80211 would
> break ipkg distributions too. And call that a 'flag day'.
> 
> But that would be silly. Wouldn't it?

Normally, one can upgrade the kernel, not upgrade userland, and happily 
continue working.

With this change, there are several exceptions where this is not the 
case, across all driver types -- media, wan, char, net, scsi, ...

Package manifests, build scripts and other details MUST be updated, or 
these drivers will not work as they did in kernels <= 2.6.26.

That is not an opinion, that is a simple fact of life with the kernel as 
of 50515af207d410c9f228380e529c56f43c3de0bd.

And yes, for the people who have to clean up the mess, I call that a 
flag day.

	Jeff



