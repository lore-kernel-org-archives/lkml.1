Return-Path: <linux-kernel-owner+w=401wt.eu-S1762325AbYGOCtV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762325AbYGOCtV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2008 22:49:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755547AbYGOCtG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Jul 2008 22:49:06 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:48722 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755495AbYGOCtD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2008 22:49:03 -0400
Subject: Re: [GIT *] Allow request_firmware() to be satisfied from
	in-kernel, use it in more drivers.
From: David Woodhouse <dwmw2@infradead.org>
To: Jeff Garzik <jeff@garzik.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>, alan@lxorguk.ukuu.org.uk,
       linux-kernel@vger.kernel.org
In-Reply-To: <487C09EB.1050903@garzik.org>
References: <1216077806.27455.85.camel@shinybook.infradead.org>
	 <20080714164119.99c33d5b.akpm@linux-foundation.org>
	 <20080714165956.7fe2d4ee@infradead.org> <487C0365.5030203@garzik.org>
	 <alpine.LFD.1.10.0807141911270.3017@woody.linux-foundation.org>
	 <487C09EB.1050903@garzik.org>
Content-Type: text/plain
Date: Mon, 14 Jul 2008 19:48:32 -0700
Message-Id: <1216090112.27455.173.camel@shinybook.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.2 (2.22.2-2.fc9) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2008-07-14 at 22:22 -0400, Jeff Garzik wrote:
> You have to look at the build process, second stage image builders, 
> embedded system image creators, and other "hangers on" that do not look 
> and behave like a mainstream Linux distro.
> 
> It is a mistake to assume that all systems are _already_ prepared to 
> install and digest new /lib/firmware files that the kernel build now 
> spits out.

I didn't just assume it. I checked the major distributions -- and they
_do_ check the MODULE_FIRMWARE() tags in the modules they include, and
include the corresponding firmware. The firmware loader has been around
for a _long_ time now, and they've had to support this for almost as
long.

Yes, there are occasional bugs -- and I'm sure there _are_ some minor
distributions or 'image creators' out there which still don't cope.

But that isn't a new problem -- and it's certainly not _caused_ by us
updating a small handful of the older drivers to match what modern
drivers do.

-- 
dwmw2

