Return-Path: <linux-kernel-owner+w=401wt.eu-S935783AbXGRSiv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935783AbXGRSiv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2007 14:38:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760246AbXGRSim
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Jul 2007 14:38:42 -0400
Received: from one.firstfloor.org ([213.235.205.2]:38716 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757984AbXGRSil (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2007 14:38:41 -0400
Date: Wed, 18 Jul 2007 20:38:40 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Jan Engelhardt <jengelh@computergmbh.de>
Cc: Andi Kleen <andi@firstfloor.org>, "H. Peter Anvin" <hpa@zytor.com>,
       Jonathan Campbell <jon@nerdgrounds.com>, linux-kernel@vger.kernel.org,
       torvalds@transmeta.com
Subject: Re: Patches for REALLY TINY 386 kernels
Message-ID: <20070718183840.GC3898@one.firstfloor.org>
References: <469A8AED.7070207@nerdgrounds.com> <p737ioyxwyq.fsf@bingen.suse.de> <469E3806.4030804@zytor.com> <20070718182021.GA3898@one.firstfloor.org> <Pine.LNX.4.64.0707182024231.5385@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0707182024231.5385@fbirervta.pbzchgretzou.qr>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 18, 2007 at 08:29:27PM +0200, Jan Engelhardt wrote:
> 
> On Jul 18 2007 20:20, Andi Kleen wrote:
> >> 
> >> Well, how big the vmlinux file is matters if it doesn't fit in memory
> >> with enough time to get to the phase where it is dumping the init
> >> sections.  
> >
> >If you don't have enough memory for a few tens of KB of init sections
> >you're very unlikely to have enough memory for user space.
> 
> If the code was not too hackish, I would not buy that.
> Routers for example can run -- minus the userspace utilities required to set
> things up -- "without" userspace.

They still need memory for packets and other data structures. 
Without having enough memory to queue packets and keep the routing cache you cannot do 
any useful routing.

-Andi
