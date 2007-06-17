Return-Path: <linux-kernel-owner+w=401wt.eu-S1759552AbXFQK6S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759552AbXFQK6S (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Jun 2007 06:58:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757980AbXFQK6E
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Jun 2007 06:58:04 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:33128 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758056AbXFQK6D (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Jun 2007 06:58:03 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Soeren Sonnenburg <kernel@nn7.de>
Subject: Re: git-current: slub breaks s2ram with fglrx...
Date: Sun, 17 Jun 2007 13:04:45 +0200
User-Agent: KMail/1.9.5
Cc: Linux Kernel <linux-kernel@vger.kernel.org>,
       Michal Piotrowski <michal.k.k.piotrowski@gmail.com>,
       Stefan Seyfried <seife@suse.de>, Christoph Lameter <clameter@sgi.com>
References: <1182073786.3841.11.camel@localhost>
In-Reply-To: <1182073786.3841.11.camel@localhost>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200706171304.46181.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday, 17 June 2007 11:49, Soeren Sonnenburg wrote:
> OK,
> 
> I've found the second root for my 
> 
> '2.6.22-rc regression: s2ram fails to suspend + fails to resume w/ Xorg':
> 
> The first one was just the wrong coretemp patch (already fixed by Jean).
> 
> The second one happens only with Xorg/fglrx loaded and slub enabled, as
> I've found after a useless git bisect session, I've traced down the
> other s2ram does not work problem to be caused by slub ... FYI: I am now
> on git-current which should be rc5:
> 
> slab & fglrx works
> slub & console works
> slub & X11+fglrx creates hangs on suspend (black screen - no further
> idea ...)
> 
> It should be noted that withouth the proprietary  fglrx.ko module loaded
> the machine just reboots on s2ram (though IIRC without fglrx.ko loaded
> it worked with 2.6.19 or so...)
> 
> Is this a kernel thing or yet another bug in fglrx ?

I have no idea.

I guess we should let Christoph know about it (CC added), but I'm afraid
we won't be able to figure out what's wrong without access to the driver's
source code ...

Greetings,
Rafael


-- 
"Premature optimization is the root of all evil." - Donald Knuth
