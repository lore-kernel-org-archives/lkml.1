Return-Path: <linux-kernel-owner+w=401wt.eu-S1758863AbYGOSpL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758863AbYGOSpL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2008 14:45:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754112AbYGOSo7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jul 2008 14:44:59 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:35189 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753208AbYGOSo6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2008 14:44:58 -0400
Message-ID: <487CF01E.6000208@garzik.org>
Date: Tue, 15 Jul 2008 14:44:46 -0400
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
References: <1216077806.27455.85.camel@shinybook.infradead.org> <20080714164119.99c33d5b.akpm@linux-foundation.org> <20080714165956.7fe2d4ee@infradead.org> <alpine.DEB.1.10.0807141704120.14223@asgard.lang.hm> <alpine.LFD.1.10.0807141729200.3017@woody.linux-foundation.org> <alpine.DEB.1.10.0807141750290.14223@asgard.lang.hm> <alpine.LFD.1.10.0807141756361.3017@woody.linux-foundation.org> <alpine.DEB.1.10.0807141805300.14223@asgard.lang.hm> <alpine.LFD.1.10.0807141903260.3017@woody.linux-foundation.org> <487C585C.2060002@garzik.org> <alpine.LFD.1.10.0807150803580.3017@woody.linux-foundation.org> <487CD7FE.9010209@garzik.org> <alpine.LFD.1.10.0807151008450.3017@woody.linux-foundation.org> <487CDEC0.3090004@garzik.org> <alpine.LFD.1.10.0807151041080.3017@woody.linux-foundation.org> <487CEA73.9000408@garzik.org> <alpine.LFD.1.10.0807151124510.3017@woody.linux-foundation.org>
In-Reply-To: <alpine.LFD.1.10.0807151124510.3017@woody.linux-foundation.org>
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
>> Which is why 'make modules_install' installs the firmware, or at least it did
>> before David W pushed upstream.
> 
> So you're literally just about making this be "make modules_install" 
> rather than "make firmware_install"
> 
> Ok. Are you going to be happy if "make modules_install" just copies the 
> firmware files of the affected modules too?

Re-read the above, and what you snipped.  My statement was

* upstream _already_ does this (installs firmware via modules_install)

* it is a good thing, because it means existing build scripts and 
processes will Do The Right Thing and produce a working driver

* thus eliminating the most common problem likely to be encountered

That does not eliminate all problems, because build processes still have 
hardcoded assumptions about outputs.

Restoring firmware-in-module ability closes the last logical hole, last 
fundamental flaw in the scheme, by permitting distros to reproduce 
precisely what they built in 2.6.26.

All of the regressions examples I am citing are cured by 
firmware-in-module, because they are all examples of problems that occur 
when you remove the ability to reproduce the same functional pieces as 
2.6.26.

	Jeff



