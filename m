Return-Path: <linux-kernel-owner+w=401wt.eu-S1760756AbXHTQsS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760756AbXHTQsS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Aug 2007 12:48:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760165AbXHTQsE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Aug 2007 12:48:04 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:52550 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760158AbXHTQsD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Aug 2007 12:48:03 -0400
Date: Mon, 20 Aug 2007 09:47:27 -0700
From: Stephen Hemminger <shemminger@linux-foundation.org>
To: James Corey <ploversegg@yahoo.com>
Cc: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>,
       linux-kernel@vger.kernel.org, Netdev <netdev@vger.kernel.org>
Subject: Re: 2.6.23-rc3 and SKY2 driver issue
Message-ID: <20070820094727.2b92fad0@freepuppy.rosehill.hemminger.net>
In-Reply-To: <624025.57129.qm@web90408.mail.mud.yahoo.com>
References: <20070820090227.6ceb2934@freepuppy.rosehill.hemminger.net>
	<624025.57129.qm@web90408.mail.mud.yahoo.com>
Organization: Linux Foundation
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.10.14; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 20 Aug 2007 09:23:46 -0700 (PDT)
James Corey <ploversegg@yahoo.com> wrote:

> 
> --- Stephen Hemminger
> <shemminger@linux-foundation.org> wrote:
> 
> > On Mon, 20 Aug 2007 08:42:21 -0700 (PDT)
> > James Corey <ploversegg@yahoo.com> wrote:
> > 
> > > 
> > > --- Stephen Hemminger
> > > <shemminger@linux-foundation.org> wrote:
> > > 
> > > > On Thu, 16 Aug 2007 10:25:45 +0200
> > > > "Michal Piotrowski"
> > >
> > > > Please reproduce with a more recent kernel?
> > > 
> > > Um, I thought 2.6.23rc WAS pretty recent. :-)
> > > 
> > > I'll check if there is something newer in the
> > > repository now.
> > > 
> > 
> > What is the chip version?  Please send console log:
> > "dmesg | grep sky2"
> > 
> > 
> > -- 
> > Stephen Hemminger <shemminger@linux-foundation.org>
> > 
> 
> 
> Ah ... details.
> 
> Machine: 
> 
> Dell Optiplex 745
> 
> Kernel:
> 
> 2.6.23-rc3 #1 SMP Tue Aug 14 19:44:07 EDT 2007 x86_64
> x86_64 x86_64 GNU/Linux
> 
> Card:
> 
> D-Link DGE-550SX
> 
> # dmesg | grep sky2
> sky2 0000:04:00.0: v1.16 addr 0xdf9fc000 irq 16
> Yukon-XL (0xb3) rev 3
> sky2 eth1: addr 00:17:9a:73:87:60
> sky2 eth1: enabling interface
> sky2 eth1: ram buffer 96K
> sky2 eth1: Link is up at 1000 Mbps, full duplex, flow
> control none

Okay, this is a fiber based card.  Does the error happen right away (ie all packets
have bad sum), or is it sporadic (ie some magic packet or race in hardware).
Also are you using regular (1500) or jumbo (9000) mtu?


-- 
Stephen Hemminger <shemminger@linux-foundation.org>
