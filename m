Return-Path: <linux-kernel-owner+w=401wt.eu-S1753011AbZFETKc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753011AbZFETKc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Jun 2009 15:10:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752173AbZFETKZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Jun 2009 15:10:25 -0400
Received: from woodchuck.wormnet.eu ([77.75.105.223]:42605 "EHLO
	woodchuck.wormnet.eu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752153AbZFETKZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Jun 2009 15:10:25 -0400
Date: Fri, 5 Jun 2009 20:10:25 +0100
From: Alexander Clouter <alex@digriz.org.uk>
To: david@lang.hm
Cc: linux-kernel@vger.kernel.org, sefi@s-e-f-i.de
Subject: Re: When does Linux drop UDP packets?
Message-ID: <20090605191025.GG2014@woodchuck>
References: <20090604145347.GA27692@miyuki> <buslf6-j24.ln1@woodchuck.wormnet.eu> <alpine.DEB.1.10.0906041618200.7953@asgard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.1.10.0906041618200.7953@asgard>
Organization: diGriz
X-URL: http://www.digriz.org.uk/
X-JabberID: alex@digriz.org.uk
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

* david@lang.hm <david@lang.hm> [2009-06-04 16:19:56-0700]:
> 
> On Thu, 4 Jun 2009, Alexander Clouter wrote:
> 
> > Philipp Reh <sefi@s-e-f-i.de> wrote:
> > > 
> > > I have the following setting in which a client that resides on the same
> > > physical network as a server wants to receive any UDP packet that
> > > arrives on any of its interfaces sent by that server.
> > > 
> > Read up about multicasting, it will do what you want, does not depend on
> > the IP address of the destination workstation and will also cross
> > subnets if you want it to.
> > 
> > It's dead easy to transmit and receive multicast traffic, broadcasting
> > network traffic is so 1980's :)
> 
> there is only a difference between multicast and broadcast traffic if you  
> are spanning subnets.
>
Well yes and no.  Broadcast traffic is *always* handled by the kernel as 
only the kernel can tell if it is interested in it or not.  With 
multicast the NIC is configured to only pass particular 
Ethernet multicast packets up to the kernel.

By using broadcast traffic the load (okay, hardly a big problem 
now-a-days) hits *all* the workstations on the subnet, with multicast, 
only those interested in the traffic receive it.

Cheers

-- 
Alexander Clouter
.sigmonster says: You were s'posed to laugh!
