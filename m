Return-Path: <linux-kernel-owner+w=401wt.eu-S1765031AbXFEOlI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765031AbXFEOlI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jun 2007 10:41:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763602AbXFEOk4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Jun 2007 10:40:56 -0400
Received: from gw.goop.org ([64.81.55.164]:54572 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761140AbXFEOkz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jun 2007 10:40:55 -0400
Message-ID: <466575EE.70901@goop.org>
Date: Tue, 05 Jun 2007 07:40:46 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Rene Herman <rene.herman@gmail.com>
CC: "John Anthony Kazos Jr." <jakj@j-a-k-j.com>,
       Christoph Lameter <clameter@sgi.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org
Subject: Re: SLUB: Return ZERO_SIZE_PTR for kmalloc(0)
References: <Pine.LNX.4.64.0706011831170.10767@schroedinger.engr.sgi.com> <alpine.LFD.0.98.0706041143240.23741@woody.linux-foundation.org> <Pine.LNX.4.64.0706041200140.24550@schroedinger.engr.sgi.com> <84144f020706041213x1d241794u98e9b3ca29865033@mail.gmail.com> <Pine.LNX.4.64.0706041213540.24935@schroedinger.engr.sgi.com> <46646747.2080803@cs.helsinki.fi> <Pine.LNX.4.64.0706041532350.27125@schroedinger.engr.sgi.com> <20070604155355.bf29a3a8.akpm@linux-foundation.org> <Pine.LNX.4.64.0706041607560.27346@schroedinger.engr.sgi.com> <466523E0.3050605@gmail.com> <alpine.DEB.0.99.0706050804170.27388@sigma.j-a-k-j.com> <46655CEC.7070900@gmail.com>
In-Reply-To: <46655CEC.7070900@gmail.com>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Rene Herman wrote:
> No, what we have is a sizeof(pointer) sized pointer pointing to an
> object of size zero. ZERO_SIZE_PTR is butt-ugly. With a really ugly butt. 

It doesn't matter.  It will never, ever, be used by anything except the
kmalloc internals.  No client code should ever use the constant for
anything.

    J
