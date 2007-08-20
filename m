Return-Path: <linux-kernel-owner+w=401wt.eu-S1761597AbXHTRIs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761597AbXHTRIs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Aug 2007 13:08:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760569AbXHTRIl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Aug 2007 13:08:41 -0400
Received: from web90414.mail.mud.yahoo.com ([216.252.100.166]:31955 "HELO
	web90414.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1760535AbXHTRIj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Aug 2007 13:08:39 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=X-YMail-OSG:Received:Date:From:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-ID;
  b=ve44FeneLkmVCNH50QaVZsPYb8iO/aUMbgaAg958G2x3OmYFbcjdCh92VJ2CF+pr4BQanHXvWlrhK6I6G5x5+ppP6YBLpw0rUOEpAMmuQzx9QSc1WkPuj3CrWcrwz82yeoFhFaU7YQNQuctnBikakaA6rI5lTEYFLIKGZvDv2s4=;
X-YMail-OSG: NORfJuEVM1m8z0OWjzpEwAlnLHjhqH4IIGi9eiPw.C5FTZbGTkAlEenITPjdsqF7BRi86HKTFg4ZvZm3GQMHHXfJKUuWaG7otp4GafqHwZl1kEzmqTGHXyOG4QKcKQ--
Date: Mon, 20 Aug 2007 10:08:37 -0700 (PDT)
From: James Corey <ploversegg@yahoo.com>
Subject: Re: 2.6.23-rc3 and SKY2 driver issue
To: Stephen Hemminger <shemminger@linux-foundation.org>
Cc: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>,
       linux-kernel@vger.kernel.org, Netdev <netdev@vger.kernel.org>
In-Reply-To: <20070820094727.2b92fad0@freepuppy.rosehill.hemminger.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Message-ID: <733696.77943.qm@web90414.mail.mud.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--- Stephen Hemminger
<shemminger@linux-foundation.org> wrote:

> On Mon, 20 Aug 2007 09:23:46 -0700 (PDT)
> James Corey <ploversegg@yahoo.com> wrote:
> 
> > 
> > --- Stephen Hemminger
> > <shemminger@linux-foundation.org> wrote:
> > 
> > > On Mon, 20 Aug 2007 08:42:21 -0700 (PDT)
> > > James Corey <ploversegg@yahoo.com> wrote:
> > > 
> > > > 
> > > > --- Stephen Hemminger
> > > > <shemminger@linux-foundation.org> wrote:
> > > > 
> > > > > On Thu, 16 Aug 2007 10:25:45 +0200
> > > > > "Michal Piotrowski"
> > > >
> > > > > Please reproduce with a more recent kernel?
> > > > 
> > > > Um, I thought 2.6.23rc WAS pretty recent. :-)
> > > > 
> > > > I'll check if there is something newer in the
> > > > repository now.
> > > > 
> > > 
> > > What is the chip version?  Please send console
> log:
> > > "dmesg | grep sky2"
> > > 
> > > 
> > > -- 
> > > Stephen Hemminger
> <shemminger@linux-foundation.org>
> > > 
> > 
> > 
> > Ah ... details.
> > 
> > Machine: 
> > 
> > Dell Optiplex 745
> > 
> > Kernel:
> > 
> > 2.6.23-rc3 #1 SMP Tue Aug 14 19:44:07 EDT 2007
> x86_64
> > x86_64 x86_64 GNU/Linux
> > 
> > Card:
> > 
> > D-Link DGE-550SX
> > 
> > # dmesg | grep sky2
> > sky2 0000:04:00.0: v1.16 addr 0xdf9fc000 irq 16
> > Yukon-XL (0xb3) rev 3
> > sky2 eth1: addr 00:17:9a:73:87:60
> > sky2 eth1: enabling interface
> > sky2 eth1: ram buffer 96K
> > sky2 eth1: Link is up at 1000 Mbps, full duplex,
> flow
> > control none
> 
> Okay, this is a fiber based card.  Does the error
> happen right away (ie all packets
> have bad sum), or is it sporadic (ie some magic
> packet or race in hardware).
> Also are you using regular (1500) or jumbo (9000)
> mtu?
> 

Regular MTU - 1500.

It runs fine for normal stuff, ssh etc, but a big
sftp will break it every time. My usual test is to
sftp a linux distro ISO from another machine to 
it. 






       
____________________________________________________________________________________
Need a vacation? Get great deals
to amazing places on Yahoo! Travel.
http://travel.yahoo.com/
