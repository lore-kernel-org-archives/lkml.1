Return-Path: <linux-kernel-owner+w=401wt.eu-S1759013AbYH2Uql@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759013AbYH2Uql (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Aug 2008 16:46:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753498AbYH2Uqa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Aug 2008 16:46:30 -0400
Received: from palinux.external.hp.com ([192.25.206.14]:35591 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754593AbYH2Uqa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Aug 2008 16:46:30 -0400
Date: Fri, 29 Aug 2008 14:46:27 -0600
From: Matthew Wilcox <matthew@wil.cx>
To: Marcel Holtmann <holtmann@linux.intel.com>
Cc: Andi Kleen <andi@firstfloor.org>, Greg KH <greg@kroah.com>,
       bgmerrell@novell.com, hirofuchi@users.sourceforge.net,
       linux-kernel@vger.kernel.org, usbip-devel@lists.sourceforge.net
Subject: Re: USBIP protocol
Message-ID: <20080829204627.GB1239@parisc-linux.org>
References: <20080829140224.GC1968@parisc-linux.org> <87ej47q5k8.fsf@basil.nowhere.org> <1220049103.7145.23.camel@californication>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1220049103.7145.23.camel@californication>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 30, 2008 at 12:31:43AM +0200, Marcel Holtmann wrote:
> Hi Matthew,
> 
> > > I'm in the middle of implementing a userspace client for usbip and I
> > > strongly feel that the protocol needs to be changed before it is merged.
> > >
> > >  - I'm unconvinced that TCP is the correct protocol to be running this over.
> > >    I understand the reluctance to use UDP, but the protocol is fundamentally
> > >    packet-based.  If TCP is used, the delimitation of packets within the
> > >    stream needs to be much more robust. 
> > 
> > If you want reliable transport with record boundaries an alternative
> > would be also SCTP. Main drawback is that firewalls often don't support it
> > though (but presumably that wouldn't be a big issue for this)
> 
> I would also have proposed SCTP. The telco carries seems be very happy
> with it.

I'm actually looking into the sunrpc protocol.  That has the advantages:
 - Already has an in-kernel implementation
 - Widely understood and properly documented
 - Can be run over TCP or UDP or even RDMA

-- 
Matthew Wilcox				Intel Open Source Technology Centre
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
