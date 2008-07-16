Return-Path: <linux-kernel-owner+w=401wt.eu-S1761509AbYGPA2h@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761509AbYGPA2h (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2008 20:28:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760578AbYGPA1Y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jul 2008 20:27:24 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34707 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758909AbYGPA1W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2008 20:27:22 -0400
Date: Tue, 15 Jul 2008 17:26:34 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Alexandre Oliva <oliva@lsd.ic.unicamp.br>
cc: David Woodhouse <dwmw2@infradead.org>, Willy Tarreau <w@1wt.eu>,
       Jeff Garzik <jeff@garzik.org>, Arjan van de Ven <arjan@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>, alan@lxorguk.ukuu.org.uk,
       linux-kernel@vger.kernel.org
Subject: Re: [GIT *] Allow request_firmware() to be satisfied from in-kernel,
 use it in more drivers.
In-Reply-To: <orskua1yek.fsf@oliva.athome.lsd.ic.unicamp.br>
Message-ID: <alpine.LFD.1.10.0807151724330.2867@woody.linux-foundation.org>
References: <1216077806.27455.85.camel@shinybook.infradead.org> <20080714164119.99c33d5b.akpm@linux-foundation.org> <20080714165956.7fe2d4ee@infradead.org> <487C0365.5030203@garzik.org> <alpine.LFD.1.10.0807141911270.3017@woody.linux-foundation.org>
 <487C09EB.1050903@garzik.org> <alpine.LFD.1.10.0807141928540.3017@woody.linux-foundation.org> <487C1648.5070409@garzik.org> <alpine.LFD.1.10.0807142027140.3017@woody.linux-foundation.org> <20080715050654.GH1369@1wt.eu> <1216099930.27455.205.camel@shinybook.infradead.org>
 <orskua1yek.fsf@oliva.athome.lsd.ic.unicamp.br>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 15 Jul 2008, Alexandre Oliva wrote:
> 
> Hey, how about a config option that turns firwmare files into
> stand-alone kernel modules that register the blob into the
> request_firmware internal list, and MODULE_FIRMWARE into a module
> dependency?

I think that should work fine from a technical angle, and I don't disagree 
per se, but it really is very ugly.

Wouldn't it be much simpler to just require people to have a reasonably 
up-to-date mkinitrd. Apparently it's not available _everywhere_, but if we 
check for this up-front (even if we can apparently only do so at "make 
install" time due to the root requirements), wouldn't that really solve 
the issue with much less work?

			Linus
