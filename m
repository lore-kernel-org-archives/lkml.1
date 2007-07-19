Return-Path: <linux-kernel-owner+w=401wt.eu-S1764588AbXGSVDr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764588AbXGSVDr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2007 17:03:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757514AbXGSVDl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jul 2007 17:03:41 -0400
Received: from cantor2.suse.de ([195.135.220.15]:50310 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755808AbXGSVDk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2007 17:03:40 -0400
From: Andi Kleen <ak@suse.de>
Organization: SUSE Linux Products GmbH, Nuernberg, GF: Markus Rex, HRB 16746 (AG Nuernberg)
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: kmalloc zero size changes break i386
Date: Thu, 19 Jul 2007 23:03:35 +0200
User-Agent: KMail/1.9.6
Cc: Roland Dreier <rdreier@cisco.com>, Pekka Enberg <penberg@cs.helsinki.fi>,
       Christoph Lameter <clameter@sgi.com>, linux-kernel@vger.kernel.org,
       "Michael S. Tsirkin" <mst@dev.mellanox.co.il>
References: <200707191201.35777.ak@suse.de> <alpine.LFD.0.999.0707191107570.27353@woody.linux-foundation.org> <alpine.LFD.0.999.0707191218470.27353@woody.linux-foundation.org>
In-Reply-To: <alpine.LFD.0.999.0707191218470.27353@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200707192303.35743.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 19 July 2007 21:19:29 Linus Torvalds wrote:
> 
> On Thu, 19 Jul 2007, Linus Torvalds wrote:
> > 
> > Does something like this fix it?
> > 
> > Christoph, please go over this and see if there are other cases like that.
> 
> Actually, here's a better version, I think.
> 
> Andi, does this patch fix your problem?

No, unfortunately not.

e.g. I see it in a git checkout (with head 589f1e81bde732dd0b1bc5d01b6bddd4bcb4527b),
but not in plain -git12, but when I readd my x86 patchkit to -git12 it happens 
again. I also switched to slub in the config and I also still see it. 
Trying to bisect that right now.

-Andi
