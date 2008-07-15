Return-Path: <linux-kernel-owner+w=401wt.eu-S1756214AbYGOFNu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756214AbYGOFNu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2008 01:13:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752714AbYGOFNm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jul 2008 01:13:42 -0400
Received: from 1wt.eu ([62.212.114.60]:3979 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752226AbYGOFNm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2008 01:13:42 -0400
Date: Tue, 15 Jul 2008 07:12:25 +0200
From: Willy Tarreau <w@1wt.eu>
To: David Woodhouse <dwmw2@infradead.org>
Cc: Jeff Garzik <jeff@garzik.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>, alan@lxorguk.ukuu.org.uk,
       linux-kernel@vger.kernel.org
Subject: Re: [GIT *] Allow request_firmware() to be satisfied from in-kernel, use it in more drivers.
Message-ID: <20080715051224.GI1369@1wt.eu>
References: <1216077806.27455.85.camel@shinybook.infradead.org> <20080714164119.99c33d5b.akpm@linux-foundation.org> <20080714165956.7fe2d4ee@infradead.org> <487C0365.5030203@garzik.org> <alpine.LFD.1.10.0807141911270.3017@woody.linux-foundation.org> <487C09EB.1050903@garzik.org> <1216090112.27455.173.camel@shinybook.infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1216090112.27455.173.camel@shinybook.infradead.org>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 14, 2008 at 07:48:32PM -0700, David Woodhouse wrote:
> On Mon, 2008-07-14 at 22:22 -0400, Jeff Garzik wrote:
> > You have to look at the build process, second stage image builders, 
> > embedded system image creators, and other "hangers on" that do not look 
> > and behave like a mainstream Linux distro.
> > 
> > It is a mistake to assume that all systems are _already_ prepared to 
> > install and digest new /lib/firmware files that the kernel build now 
> > spits out.
> 
> I didn't just assume it. I checked the major distributions -- and they
> _do_ check the MODULE_FIRMWARE() tags in the modules they include, and
> include the corresponding firmware. The firmware loader has been around
> for a _long_ time now, and they've had to support this for almost as
> long.

David, "being around" and "being heavily used" are not the same. My
experience with firmware is limited to WiFi drivers. I've never seen
that annoying thing on a server yet. Not that it does not exist there,
just that fortunately I've not being facing it.

> Yes, there are occasional bugs -- and I'm sure there _are_ some minor
> distributions or 'image creators' out there which still don't cope.
> 
> But that isn't a new problem -- and it's certainly not _caused_ by us
> updating a small handful of the older drivers to match what modern
> drivers do.

Pardon? If by "updating" you mean you keep backwards compatibility, OK.
But if by "updating" you mean "breaking existing behaviour", yes, it
is your change which will cause the problems.

Willy

