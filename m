Return-Path: <linux-kernel-owner+w=401wt.eu-S932215AbXB1SZG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932215AbXB1SZG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Feb 2007 13:25:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932225AbXB1SZF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Feb 2007 13:25:05 -0500
Received: from mtl.rackplans.net ([69.90.0.18]:41314 "EHLO mtl.rackplans.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932222AbXB1SZD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Feb 2007 13:25:03 -0500
Date: Wed, 28 Feb 2007 13:25:00 -0500 (EST)
From: Gerhard Mack <gmack@innerfire.net>
X-X-Sender: gmack@mtl.rackplans.net
To: Charles Shannon Hendrix <shannon@widomaker.com>
cc: linux-kernel@vger.kernel.org
Subject: Re: 2.6.20 SATA error
In-Reply-To: <20070228111412.4d8a2d72@daydream.goid.lan>
Message-ID: <Pine.LNX.4.64.0702281220510.12067@mtl.rackplans.net>
References: <Pine.LNX.4.64.0702280739510.21113@mtl.rackplans.net>
 <20070228111412.4d8a2d72@daydream.goid.lan>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 28 Feb 2007, Charles Shannon Hendrix wrote:

> On Wed, 28 Feb 2007 07:40:23 -0500 (EST)
> Gerhard Mack <gmack@innerfire.net> wrote:
> 
> > hello, 
> > 
> > Can someone tell me what this means?
> > ata1.00: exception Emask 0x0 SAct 0x0 SErr 0x400000 action 0x2 frozen
> > ata1.00: cmd 35/00:00:40:a6:23/00:04:00:00:00/e0 tag 0 cdb 0x0 data 524288 
> > out
> >          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
> > ata1: port is slow to respond, please be patient (Status 0xd0)
> > ata1: port failed to respond (30 secs, Status 0xd0)
> > ata1: soft resetting port
> > ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
> > ata1.00: configured for UDMA/100
> 
> I am fairly certain this is a bug in the 2.6.20 kernel.
> 
> I never see it in 2.6.19*, just 2.6.20.
> 
> It is some kind of but in the SATA code paths, or at least that's all it
> appears to affect on my system.
> 
> What chipset do you have?
> 
> I have an nforce4 chipset.
> 
> In another thread, I think they were saying it was either a SATA chipset
> driver bug, or a problem in libata core.

I also have an nforce4.

	Gerhard


--
Gerhard Mack

gmack@innerfire.net

<>< As a computer I find your faith in technology amusing.
