Return-Path: <linux-kernel-owner+w=401wt.eu-S935553AbXGRSUa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935553AbXGRSUa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2007 14:20:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933631AbXGRSUX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Jul 2007 14:20:23 -0400
Received: from one.firstfloor.org ([213.235.205.2]:46968 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933813AbXGRSUW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2007 14:20:22 -0400
Date: Wed, 18 Jul 2007 20:20:21 +0200
From: Andi Kleen <andi@firstfloor.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Andi Kleen <andi@firstfloor.org>, Jonathan Campbell <jon@nerdgrounds.com>,
       linux-kernel@vger.kernel.org, torvalds@transmeta.com
Subject: Re: Patches for REALLY TINY 386 kernels
Message-ID: <20070718182021.GA3898@one.firstfloor.org>
References: <469A8AED.7070207@nerdgrounds.com> <p737ioyxwyq.fsf@bingen.suse.de> <469E3806.4030804@zytor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <469E3806.4030804@zytor.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 18, 2007 at 08:55:50AM -0700, H. Peter Anvin wrote:
> Andi Kleen wrote:
> > 
> >> Already with these patches I can compile a zImage kernel that is 450kb
> >> large (890kb decompressed)
> > 
> > The important part is not how big the vmlinux is, but how much
> > memory is actually used after boot. 
> > 
> > I expect concentrating some of the dynamic data structures would
> > be more fruitful in fact.
> > 
> 
> Well, how big the vmlinux file is matters if it doesn't fit in memory
> with enough time to get to the phase where it is dumping the init
> sections.  

If you don't have enough memory for a few tens of KB of init sections
you're very unlikely to have enough memory for user space.

-Andi
