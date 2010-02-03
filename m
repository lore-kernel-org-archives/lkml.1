Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757780Ab0BCUEx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Feb 2010 15:04:53 -0500
Received: from dallas.jonmasters.org ([72.29.103.172]:47439 "EHLO
	dallas.jonmasters.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753843Ab0BCUEv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Feb 2010 15:04:51 -0500
Subject: Re: [PATCH] netfilter: per netns nf_conntrack_cachep
From: Jon Masters <jonathan@jonmasters.org>
To: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Patrick McHardy <kaber@trash.net>, Eric Dumazet <eric.dumazet@gmail.com>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       netdev <netdev@vger.kernel.org>,
       netfilter-devel <netfilter-devel@vger.kernel.org>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
In-Reply-To: <20100203195338.GB5576@x200>
References: <4B685756.8010107@trash.net> <1265130426.2861.158.camel@tonnant>
	 <b6fcc0a1002020958u17315624u4d54d06a413be6bb@mail.gmail.com>
	 <1265134598.2861.191.camel@tonnant> <4B6870AF.6060109@trash.net>
	 <4B6967BC.600@trash.net> <1265222289.2861.290.camel@tonnant>
	 <20100203190948.GA5182@x200> <1265226227.2861.302.camel@tonnant>
	 <1265226371.2861.303.camel@tonnant>  <20100203195338.GB5576@x200>
Content-Type: text/plain
Organization: World Organi[sz]ation of Broken Dreams
Date: Wed, 03 Feb 2010 15:04:29 -0500
Message-Id: <1265227469.2861.311.camel@tonnant>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 (2.26.3-1.fc11) 
Content-Transfer-Encoding: 7bit
X-SA-Do-Not-Run: Yes
X-SA-Exim-Connect-IP: 127.0.0.1
X-SA-Exim-Mail-From: jonathan@jonmasters.org
X-SA-Exim-Scanned: No (on dallas.jonmasters.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-02-03 at 21:53 +0200, Alexey Dobriyan wrote:
> On Wed, Feb 03, 2010 at 02:46:11PM -0500, Jon Masters wrote:
> > On Wed, 2010-02-03 at 14:44 -0500, Jon Masters wrote:
> > > On Wed, 2010-02-03 at 21:09 +0200, Alexey Dobriyan wrote:
> > > > On Wed, Feb 03, 2010 at 01:38:09PM -0500, Jon Masters wrote:
> > 
> > > > > I also think it is necessary to expose net namespace layout
> > > > 
> > > > Not necessary. Why?
> > > 
> > > How am I as a sysadmin supposed to figure out which net namespaces exist
> > > on my system, and as a developer, supposed to debug these situations?
> > 
> > (without Jason's excellent kgdb patches, which really help)
> 
> Oh! Just like as usual, thinking and looking at oops and code.
> 
> Because when box is dead, netns info is not goint to be printed
> anyway.

It would really have been helpful over the weekend to have just been
able to look around in sysfs to see what was going on with namespaces.
I'm not saying it can't be done in a debugger, or by poking at
backtraces, but it's easier to say to the many people who had this
problem in Fedora kernels "tell me what this file says" just like we do
for slab, memory, whatever other information. Just a suggestion.

> And what do you want to see at it?

Just an ability to walk through which namespaces exist (debugfs even)
and which resources are currently assigned to them. Somehow. I didn't
give it a lot of thought, but something would be useful.

Jon.


