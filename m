Return-Path: <linux-kernel-owner+w=401wt.eu-S1756891AbYGGSze@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756891AbYGGSze (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2008 14:55:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755715AbYGGSzA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Jul 2008 14:55:00 -0400
Received: from waste.org ([66.93.16.53]:50786 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755592AbYGGSy7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2008 14:54:59 -0400
Subject: Re: *sigh* /proc/*/pagemap
From: Matt Mackall <mpm@selenic.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Alexey Dobriyan <adobriyan@gmail.com>, torvalds@linuxfoundation.org,
       akpm@linuxfoundation.org, linux-kernel@vger.kernel.org,
       Dave Hansen <dave@linux.vnet.ibm.com>
In-Reply-To: <alpine.LFD.1.10.0807071130540.11076@woody.linux-foundation.org>
References: <b6fcc0a0807041807p24cce461m419d7b54fce72d34@mail.gmail.com>
	 <20080704185312.052e7145.akpm@linux-foundation.org>
	 <alpine.LFD.1.10.0807051036000.2815@woody.linux-foundation.org>
	 <1215454997.11311.165.camel@calx>
	 <alpine.LFD.1.10.0807071130540.11076@woody.linux-foundation.org>
Content-Type: text/plain
Date: Mon, 07 Jul 2008 13:51:05 -0500
Message-Id: <1215456665.11311.179.camel@calx>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Mon, 2008-07-07 at 11:34 -0700, Linus Torvalds wrote:
> 
> On Mon, 7 Jul 2008, Matt Mackall wrote:
> > 
> > It exists to make the VM stop being a big black box. Before now the VM
> > exposed little beyond statistics, many of which are basically
> > meaningless (RSS?). With pagemap, you can actually see precisely where
> > things are getting allocated, how they're getting shared, etc. Think
> > NUMA, think cell phones.
> 
> Umm. How about setting it under CONFIG_DEBUG_VM or something like that 
> then?

I'm certainly not suggesting it's only or even primarily for NUMA or
embedded, just -most obviously- useful for them. Fact is, people have
been interested enough in this POS that I've been getting patches from
all over. Nor is it about debugging the VM, per se. It's about having
transparency in a critical area of the kernel. What pages of my browser
are never swapped in? What is the memory footprint of my forking server,
really? Why the hell can't I get a huge page? Etc.

> Right now it's not even _asked_ about, unless you're EMBEDDED, and 
> defaults to 'y'. Which means that it has all the downsides, an none of the 
> upsides, for 99.99% of all users.

That's what I'd done originally (it's certainly -my- inclination).
Various people (Rusty comes to mind) convinced me to go the other way.

-- 
Mathematics is the supreme nostalgia of our time.

