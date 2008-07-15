Return-Path: <linux-kernel-owner+w=401wt.eu-S1762922AbYGOTJo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762922AbYGOTJo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2008 15:09:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758004AbYGOTJc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jul 2008 15:09:32 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:38541 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758282AbYGOTJb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2008 15:09:31 -0400
Message-ID: <487CF5E4.2070400@garzik.org>
Date: Tue, 15 Jul 2008 15:09:24 -0400
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
References: <1216077806.27455.85.camel@shinybook.infradead.org> <20080714164119.99c33d5b.akpm@linux-foundation.org> <20080714165956.7fe2d4ee@infradead.org> <alpine.DEB.1.10.0807141704120.14223@asgard.lang.hm> <alpine.LFD.1.10.0807141729200.3017@woody.linux-foundation.org> <alpine.DEB.1.10.0807141750290.14223@asgard.lang.hm> <alpine.LFD.1.10.0807141756361.3017@woody.linux-foundation.org> <alpine.DEB.1.10.0807141805300.14223@asgard.lang.hm> <alpine.LFD.1.10.0807141903260.3017@woody.linux-foundation.org> <487C585C.2060002@garzik.org> <alpine.LFD.1.10.0807150803580.3017@woody.linux-foundation.org> <487CD7FE.9010209@garzik.org> <alpine.LFD.1.10.0807151008450.3017@woody.linux-foundation.org> <487CDEC0.3090004@garzik.org> <alpine.LFD.1.10.0807151041080.3017@woody.linux-foundation.org> <487CEA73.9000408@garzik.org> <alpine.LFD.1.10.0807151124510.3017@woody.linux-foundation.org> <487CF01E.6000208@garzik.org> <alpine.LFD.1.10.0807151153020.3351@woody.linux-foundation.org>
In-Reply-To: <alpine.LFD.1.10.0807151153020.3351@woody.linux-foundation.org>
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
>> That does not eliminate all problems, because build processes still have
>> hardcoded assumptions about outputs.
> 
> Tough. They need to get fixed.
> 
> What's the downside of fixing them, again?

Yes, they need fixing.

But without firmware-in-module this would be akin to adding kernel 
module support in version 1.0.1, and forcing all distros to fix their 
stuff immediately in order to upgrade from version 1.0.0.

Permitting firmware-in-module means you do not force each distro, build 
script, and user immediately into the new regime, with the associated 
long list of breakage examples.

It's just sad because it feels "not the Linux way".

The way this was rolled out just feels "harder", far less friendly on 
the distros -- our customers -- than most other transitions.  Not as 
hard as vmlinuz->kmodule and IDE->libata transitions, I grant, but still 
  not the way we usually do things.

Nobody was ever objecting to request_firmware().  It was always about 
the removal of firmware-in-module and associated forced breakage on 
distros and build processes.  The fallout of _that_ is the rich source 
of breakage examples I've been pulling from.

	Jeff



