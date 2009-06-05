Return-Path: <linux-kernel-owner+w=401wt.eu-S1755420AbZFET3u@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755420AbZFET3u (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Jun 2009 15:29:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753391AbZFET3e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Jun 2009 15:29:34 -0400
Received: from woodchuck.wormnet.eu ([77.75.105.223]:42281 "EHLO
	woodchuck.wormnet.eu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753288AbZFET3d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Jun 2009 15:29:33 -0400
Date: Fri, 5 Jun 2009 20:29:34 +0100
From: Alexander Clouter <alex@digriz.org.uk>
To: david@lang.hm
Cc: linux-kernel@vger.kernel.org, sefi@s-e-f-i.de
Subject: Re: When does Linux drop UDP packets?
Message-ID: <20090605192933.GH2014@woodchuck>
References: <20090604145347.GA27692@miyuki> <buslf6-j24.ln1@woodchuck.wormnet.eu> <alpine.DEB.1.10.0906041618200.7953@asgard> <20090605191025.GG2014@woodchuck> <alpine.DEB.1.10.0906051214140.9159@asgard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.1.10.0906051214140.9159@asgard>
Organization: diGriz
X-URL: http://www.digriz.org.uk/
X-JabberID: alex@digriz.org.uk
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

* david@lang.hm <david@lang.hm> [2009-06-05 12:15:27-0700]:
> 
> On Fri, 5 Jun 2009, Alexander Clouter wrote:
> 
> > * david@lang.hm <david@lang.hm> [2009-06-04 16:19:56-0700]:
> > > 
> > > On Thu, 4 Jun 2009, Alexander Clouter wrote:
> > > >
> > > > It's dead easy to transmit and receive multicast traffic, broadcasting
> > > > network traffic is so 1980's :)
> > > 
> > > there is only a difference between multicast and broadcast traffic if you
> > > are spanning subnets.
> > > 
> > Well yes and no.  Broadcast traffic is *always* handled by the kernel as
> > only the kernel can tell if it is interested in it or not.  With
> > multicast the NIC is configured to only pass particular
> > Ethernet multicast packets up to the kernel.
> > 
> > By using broadcast traffic the load (okay, hardly a big problem
> > now-a-days) hits *all* the workstations on the subnet, with multicast,
> > only those interested in the traffic receive it.
> 
> true, but only for some NICs, and even those tend to have a fairly small  
> number of slots for the filters. past these limits the OS handles it all  
> just like broadcasts.
> 
I *think* only the early ones have a naff non-hashing based to filter 
multicast flows, could be wrong though.

Either way, as a packet pusher by day, I dream of the venduh's 
discovering that multicast can be used for device discovery rather than 
expecting everything to be on the same subnet :-/

In this day and age, using broadcast to do a job is just plain lazy and 
braindead.

Cheers

-- 
Alexander Clouter
.sigmonster says: Misuse may cause suffocation.
