Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757707Ab0BCTyU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Feb 2010 14:54:20 -0500
Received: from dallas.jonmasters.org ([72.29.103.172]:57120 "EHLO
	dallas.jonmasters.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757472Ab0BCTyR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Feb 2010 14:54:17 -0500
Subject: Re: [PATCH] netfilter: per netns nf_conntrack_cachep
From: Jon Masters <jonathan@jonmasters.org>
To: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Patrick McHardy <kaber@trash.net>, Eric Dumazet <eric.dumazet@gmail.com>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       netdev <netdev@vger.kernel.org>,
       netfilter-devel <netfilter-devel@vger.kernel.org>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
In-Reply-To: <20100203195153.GA5576@x200>
References: <1265129192.2861.141.camel@tonnant> <4B685756.8010107@trash.net>
	 <1265130426.2861.158.camel@tonnant>
	 <b6fcc0a1002020958u17315624u4d54d06a413be6bb@mail.gmail.com>
	 <1265134598.2861.191.camel@tonnant> <4B6870AF.6060109@trash.net>
	 <4B6967BC.600@trash.net> <1265222289.2861.290.camel@tonnant>
	 <20100203190948.GA5182@x200> <1265226227.2861.302.camel@tonnant>
	 <20100203195153.GA5576@x200>
Content-Type: text/plain
Organization: World Organi[sz]ation of Broken Dreams
Date: Wed, 03 Feb 2010 14:53:58 -0500
Message-Id: <1265226838.2861.307.camel@tonnant>
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

On Wed, 2010-02-03 at 21:51 +0200, Alexey Dobriyan wrote:
> On Wed, Feb 03, 2010 at 02:43:47PM -0500, Jon Masters wrote:
> > On Wed, 2010-02-03 at 21:09 +0200, Alexey Dobriyan wrote:
> > > On Wed, Feb 03, 2010 at 01:38:09PM -0500, Jon Masters wrote:

> > > > I also think it is necessary to expose net namespace layout
> > > 
> > > Not necessary. Why?
> > 
> > How am I as a sysadmin supposed to figure out which net namespaces exist
> > on my system, and as a developer, supposed to debug these situations?
> 
> We don't expose many relations to userspace, and it's generally fine.

I can see slabs via /proc, memory layout, heck I can even expose the
kernel page tables if I really want to. I guess that's not too many :)

> As a developer you fire a debugger and look at net_namespace_list.

Yeah, but being able to cat a nice file is always handy.

Jon.


