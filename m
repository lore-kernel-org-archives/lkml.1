Return-Path: <linux-kernel-owner+w=401wt.eu-S1753376AbYLAWVW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753376AbYLAWVW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2008 17:21:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752251AbYLAWVE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Dec 2008 17:21:04 -0500
Received: from waste.org ([66.93.16.53]:43764 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751570AbYLAWVD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2008 17:21:03 -0500
Subject: Re: [RESEND][PATCH] Add /proc/mempool to display mempool usage
From: Matt Mackall <mpm@selenic.com>
To: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, randy.dunlap@oracle.com,
       greg@kroah.com, adobriyan@gmail.com, remi.colinet@gmail.com,
       linux-kernel@vger.kernel.org, linux-api@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
In-Reply-To: <84144f020812011402v3cb3ab24pf5cb6310f2d00c5b@mail.gmail.com>
References: <1227980689.6354.24.camel@localhost.localdomain>
	 <20081129214207.GA6747@x200.localdomain> <20081129234907.GA2340@kroah.com>
	 <20081201101245.0a2f3123.randy.dunlap@oracle.com>
	 <1228158811.3196.88.camel@calx>
	 <20081201120210.1ed16bd5.akpm@linux-foundation.org>
	 <84144f020812011207q29fe4b3fq11a9e55f171cf743@mail.gmail.com>
	 <alpine.LFD.2.00.0812011210030.3256@nehalem.linux-foundation.org>
	 <84144f020812011402v3cb3ab24pf5cb6310f2d00c5b@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Date: Mon, 01 Dec 2008 16:20:34 -0600
Message-Id: <1228170034.3196.107.camel@calx>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2008-12-02 at 00:02 +0200, Pekka Enberg wrote:
> Hi Linus,
> 
> On Mon, 1 Dec 2008, Pekka Enberg wrote:
> >> Hmm, I thought Documentation/ABI/ was supposed to tell us what's an
> >> ABI you can depend on and what's not. I mean, you shouldn't be
> >> depending on anything but the interfaces documented in
> >> Documentation/ABI/stable/, no?
> 
> On Mon, Dec 1, 2008 at 10:12 PM, Linus Torvalds
> <torvalds@linux-foundation.org> wrote:
> > Who is the f*cking MORON that thinks that "documentation" has any meaning
> > what-so-ever?
> 
> Me, I suppose. At least that's the impression I got when being asked
> to document any new kmemtrace debugfs files, for example.
> 
> On Mon, Dec 1, 2008 at 10:12 PM, Linus Torvalds
> <torvalds@linux-foundation.org> wrote:
> > The fact that something is documented (whether correctly or not) has
> > absolutely _zero_ impact on anything at all. What makes something an ABI
> > is that it's useful and available. The only way something isn't an ABI is
> > by _explicitly_ making sure that it's not available even by mistake in a
> > stable form for binary use.
> 
> OK, but why do we have those different ABI "stages" in
> Documentation/ABI then? The README file there seems to contradict what
> you say. Or maybe I'm reading it wrong...

If the terrain and the map do not agree, follow the terrain. – Swedish
army manual.

If code uses a public interface and we break that interface, we will get
unhappy users. Putting stuff in debugfs/ in a released kernel makes it
public. That's the terrain.

-- 
Mathematics is the supreme nostalgia of our time.

