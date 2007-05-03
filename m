Return-Path: <linux-kernel-owner+w=401wt.eu-S1031300AbXECUz1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031300AbXECUz1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2007 16:55:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031335AbXECUz1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 May 2007 16:55:27 -0400
Received: from 1wt.eu ([62.212.114.60]:2476 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1031325AbXECUz0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2007 16:55:26 -0400
Date: Thu, 3 May 2007 22:55:23 +0200
From: Willy Tarreau <w@1wt.eu>
To: =?iso-8859-1?Q?=D8yvind_V=E5gen_J=E6gtnes?= <lorrides@gmail.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Routing 600+ vlan's via linux problems (looks like arp problems)
Message-ID: <20070503205523.GC943@1wt.eu>
References: <d20c3b7d0705031325r13834382r38ea31f26965c50@mail.gmail.com> <20070503205341.GB943@1wt.eu>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20070503205341.GB943@1wt.eu>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 03, 2007 at 10:53:41PM +0200, Willy Tarreau wrote:
> On Thu, May 03, 2007 at 10:25:48PM +0200, Øyvind Vågen Jægtnes wrote:
> > Hi,
> > 
> > We have a one gigabit internet connection that is normally
> > routed by a hardware juniper router. The drive in this is down
> > and we need to use a linux machine (Pentium D 3 ghz) as a
> > temporary router.
> > Now setting up all the 600 vlans and assigning ip addresses
> > is no problem. We have testet all by using a laptop, setting up
> > 600 vlan interfaces on this and running dhcpclient on all.
> > This worked just fine, all the interfaces got address.
> > 
> > Now for the real setup.
> > We closed the mac of the juniper to the network card that
> > would be connected to the internal LAN, set up the interfaces,
> > and swapped cables. This worked fine for approximately 100
> > of the computers that are connected, but the rest would not
> > get IP. The connected 100 computers were routed just fine.
> > 
> > What we think the problem is, is that the arp cache on the
> > linux router seems strange. It can resolve the MAC for the
> > 100 clients that actually got through.
> > For the rest all we see in the arp cache is (incomplete)
> 
> I suspect that your arp cache is full (128 entries by default).
> Check /proc/sys/net/ipv4/neigh/gc_thresh1 (128 for me). You can
                                ^ insert /default/ here.

> set it as high as gc_thresh2 (512 for me), and I don't know what
> happens above.

Willy

