Return-Path: <linux-kernel-owner+w=401wt.eu-S1761118AbYGORqW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761118AbYGORqW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2008 13:46:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753611AbYGORqN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jul 2008 13:46:13 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36227 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752531AbYGORqN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2008 13:46:13 -0400
Date: Tue, 15 Jul 2008 10:45:07 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Jeff Garzik <jeff@garzik.org>
cc: david@lang.hm, Arjan van de Ven <arjan@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       David Woodhouse <dwmw2@infradead.org>, alan@lxorguk.ukuu.org.uk,
       linux-kernel@vger.kernel.org
Subject: Re: [GIT *] Allow request_firmware() to be satisfied from in-kernel,
 use it in more drivers.
In-Reply-To: <alpine.LFD.1.10.0807151041080.3017@woody.linux-foundation.org>
Message-ID: <alpine.LFD.1.10.0807151042170.3017@woody.linux-foundation.org>
References: <1216077806.27455.85.camel@shinybook.infradead.org> <20080714164119.99c33d5b.akpm@linux-foundation.org> <20080714165956.7fe2d4ee@infradead.org> <alpine.DEB.1.10.0807141704120.14223@asgard.lang.hm> <alpine.LFD.1.10.0807141729200.3017@woody.linux-foundation.org>
 <alpine.DEB.1.10.0807141750290.14223@asgard.lang.hm> <alpine.LFD.1.10.0807141756361.3017@woody.linux-foundation.org> <alpine.DEB.1.10.0807141805300.14223@asgard.lang.hm> <alpine.LFD.1.10.0807141903260.3017@woody.linux-foundation.org> <487C585C.2060002@garzik.org>
 <alpine.LFD.1.10.0807150803580.3017@woody.linux-foundation.org> <487CD7FE.9010209@garzik.org> <alpine.LFD.1.10.0807151008450.3017@woody.linux-foundation.org> <487CDEC0.3090004@garzik.org> <alpine.LFD.1.10.0807151041080.3017@woody.linux-foundation.org>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 15 Jul 2008, Linus Torvalds wrote:
> 
> This is the "I'm too stupid to live" argument. I've already answered that. 
> What's so hard with "make firmware_install"?

Btw, that is by no means the only way to handle it either. As I said in 
other emails - about trying to find _productive_ questions to answer - 
maybe we could also just install it in the modules directory or some 
similar per-kernel location, and just teach request_firmware() to load 
binary blobs directly.

Then - horror of horrors - we could even make "make modules_install" do 
things like that automatically for you with some Makefile rule trickery.

See? There are _productive_ things you can do or ask others to do.

But singing the same "I'm so stupid that I cannot install the firmware" 
song over and over again doesn't make me think you are worth listening to.

			Linus
