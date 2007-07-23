Return-Path: <linux-kernel-owner+w=401wt.eu-S1761566AbXGWG0y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761566AbXGWG0y (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jul 2007 02:26:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757052AbXGWG0q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jul 2007 02:26:46 -0400
Received: from pasmtpa.tele.dk ([80.160.77.114]:44190 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756308AbXGWG0p (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jul 2007 02:26:45 -0400
Date: Mon, 23 Jul 2007 08:27:59 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Paul Mackerras <paulus@samba.org>, Alan Modra <amodra@bigpond.net.au>
Cc: Roland McGrath <roland@redhat.com>, David Miller <davem@davemloft.net>,
       Adrian Bunk <bunk@stusta.de>, linux-kernel@vger.kernel.org
Subject: Re: "build-id" changes break sparc64
Message-ID: <20070723062759.GB3933@uranus.ravnborg.org>
References: <20070722.012321.79430375.davem@davemloft.net> <20070723060155.2B3824D0489@magilla.localdomain> <18084.18177.369567.679866@cargo.ozlabs.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <18084.18177.369567.679866@cargo.ozlabs.ibm.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 23, 2007 at 04:13:21PM +1000, Paul Mackerras wrote:
> Roland McGrath writes:
> 
> > It turns out the problem here is that some .o files wind up with their own
> > .note.gnu.build-id sections.  I got the makefile magic wrong, thinking that
> > LDFLAGS_MODULE was a variable specifically for .ko links.  It's also used
> > in cmd_link_multi-m.
> 
> Alan Modra (binutils hacker) has said to me in the past that using
> ld -r to combine the objects in each directory is bad; he would much
> rather that we gave all the individual objects to the final link,
> since that enables ld to do better optimizations on some targets.  We
> could actually do that quite easily by making the built-in.o files be
> linker scripts listing the individual objects rather than creating
> them with ld -r.

Should be doable without to much pain.
Alan can you please share with us exactly why this is better and what we may
run into of problems doing so.
A sample script would be nice too....

	Sam
