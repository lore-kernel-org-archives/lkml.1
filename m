Return-Path: <linux-kernel-owner+w=401wt.eu-S1753396AbXFQPZZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753396AbXFQPZZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Jun 2007 11:25:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751559AbXFQPZK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Jun 2007 11:25:10 -0400
Received: from nn7.de ([85.214.94.156]:33516 "EHLO nn7.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751515AbXFQPZI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Jun 2007 11:25:08 -0400
Subject: Re: git-current: slub breaks s2ram with fglrx...
From: Soeren Sonnenburg <kernel@nn7.de>
To: "Rafael J\. Wysocki" <rjw@sisk.pl>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>,
       Michal Piotrowski <michal.k.k.piotrowski@gmail.com>,
       Stefan Seyfried <seife@suse.de>, Christoph Lameter <clameter@sgi.com>
In-Reply-To: <200706171304.46181.rjw@sisk.pl>
References: <1182073786.3841.11.camel@localhost>
	 <200706171304.46181.rjw@sisk.pl>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Sun, 17 Jun 2007 17:25:05 +0200
Message-Id: <1182093905.3841.23.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.2 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2007-06-17 at 13:04 +0200, Rafael J. Wysocki wrote:
> On Sunday, 17 June 2007 11:49, Soeren Sonnenburg wrote:
> > OK,
[...]
> > slab & fglrx works
> > slub & console works
> > slub & X11+fglrx creates hangs on suspend (black screen - no further
> > idea ...)
> > 
> > It should be noted that withouth the proprietary  fglrx.ko module loaded
> > the machine just reboots on s2ram (though IIRC without fglrx.ko loaded
> > it worked with 2.6.19 or so...)
> > 
> > Is this a kernel thing or yet another bug in fglrx ?
> 
> I have no idea.
> 
> I guess we should let Christoph know about it (CC added), but I'm afraid
> we won't be able to figure out what's wrong without access to the driver's
> source code ...

I have one question: What if I don't load fglrx.ko but still use the
proprietary binary driver for xorg. Shouldn't s2ram work with that ? And
if not is this considered a kernel bug or still a ati-binary driver
bug ?

Soeren
-- 
Sometimes, there's a moment as you're waking, when you become aware of
the real world around you, but you're still dreaming.
