Return-Path: <linux-kernel-owner+w=401wt.eu-S1753544AbXDTBPz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753544AbXDTBPz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Apr 2007 21:15:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754358AbXDTBPz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Apr 2007 21:15:55 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:47642 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753544AbXDTBPx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Apr 2007 21:15:53 -0400
Date: Thu, 19 Apr 2007 18:15:53 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Maxim Levitsky <maximlevitsky@gmail.com>
cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Nick Piggin <nickpiggin@yahoo.com.au>, Paul Jackson <pj@sgi.com>,
       Dave Chinner <dgc@sgi.com>, Andi Kleen <ak@suse.de>
Subject: Re: [RFC 0/8] Variable Order Page Cache
In-Reply-To: <200704200258.24749.maximlevitsky@gmail.com>
Message-ID: <Pine.LNX.4.64.0704191815180.14874@schroedinger.engr.sgi.com>
References: <20070419163504.11948.58487.sendpatchset@schroedinger.engr.sgi.com>
 <200704200258.24749.maximlevitsky@gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 20 Apr 2007, Maxim Levitsky wrote:

> First of all, today, packet writing on cd/dvd doesn't work well, it is very 
> slow because 
> now all file-systems are limited to 4k-barrier and cd/dvd can write only 
> 32k/64k packets.
> This is why a pktcdvd was written and it emulates those 4k sectors by doing 
> read/modify/write cycle
> This cause a lot of seeks and read/writing switches and thus it is very slow.
> 
> By introducing a bigger that 4k page cache a dvd/cd can be divided is 64k/32k 
> blocks that will be read an written freely
> (Although dvd can read 2k  I don't think that reading a 64k block will hurt 
> since most of time drive is busy seeking and locating a specific sector)
> 
> Now I thinking to implement this in an other way, I mean I want to teach udf 
> filesystem to to packet writing on its own, bypassing disk cache (but not page 
> cache)
> 
> Secondary 32/64k limitation is present of flash devices too, so they can 
> benefit too, and I almost sure that future hard disks will use bigger block 
> size too.
> 
> To summarize I want to tell that bigger pagesize will allow devices that have 
> big hardware sectors to work fine in linux.

Great arguments in support of this feature. Thank you.

