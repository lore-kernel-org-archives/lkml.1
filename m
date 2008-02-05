Return-Path: <linux-kernel-owner+w=401wt.eu-S1758853AbYBEAn0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758853AbYBEAn0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2008 19:43:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758145AbYBEAm6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Feb 2008 19:42:58 -0500
Received: from srv5.dvmed.net ([207.36.208.214]:46080 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757961AbYBEAm4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2008 19:42:56 -0500
Message-ID: <47A7B0FA.1090403@garzik.org>
Date: Mon, 04 Feb 2008 19:42:34 -0500
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Matt Mackall <mpm@selenic.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       "Nicholas A. Bellinger" <nab@linux-iscsi.org>,
       James Bottomley <James.Bottomley@HansenPartnership.com>,
       Vladislav Bolkhovitin <vst@vlnb.net>,
       Bart Van Assche <bart.vanassche@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
       linux-scsi@vger.kernel.org, scst-devel@lists.sourceforge.net,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: Integration of SCST in the mainstream Linux kernel
References: <e2e108260801230622x42045058v926e84c60f2be7f4@mail.gmail.com>  <1201639331.3069.58.camel@localhost.localdomain>  <47A05CBD.5050803@vlnb.net> <47A7049A.9000105@vlnb.net>  <1202139015.3096.5.camel@localhost.localdomain> <47A73C86.3060604@vlnb.net>  <1202144767.3096.38.camel@localhost.localdomain>  <47A7488B.4080000@vlnb.net>  <1202145901.3096.49.camel@localhost.localdomain>  <alpine.LFD.1.00.0802041018390.3034@hp.linux-foundation.org>  <1202151989.11265.576.camel@haakon2.linux-iscsi.org>  <alpine.LFD.1.00.0802041130140.3034@hp.linux-foundation.org>  <20080204224314.113afe7b@core> <1202170060.17934.142.camel@cinder.waste.org> <alpine.LFD.1.00.0802041620110.3237@woody.linux-foundation.org>
In-Reply-To: <alpine.LFD.1.00.0802041620110.3237@woody.linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.3 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds wrote:
> On Mon, 4 Feb 2008, Matt Mackall wrote:
>> But ATAoE is boring because it's not IP. Which means no routing,
>> firewalls, tunnels, congestion control, etc.
> 
> The thing is, that's often an advantage. Not just for performance.
> 
>> NBD and iSCSI (for all its hideous growths) can take advantage of these
>> things.
> 
> .. and all this could equally well be done by a simple bridging protocol 
> (completely independently of any AoE code).
> 
> The thing is, iSCSI does things at the wrong level. It *forces* people to 
> use the complex protocols, when it's a known that a lot of people don't 
> want it. 
> 
> Which is why these AoE and FCoE things keep popping up. 
> 
> It's easy to bridge ethernet and add a new layer on top of AoE if you need 
> it. In comparison, it's *impossible* to remove an unnecessary layer from 
> iSCSI.
> 
> This is why "simple and low-level is good". It's always possible to build 
> on top of low-level protocols, while it's generally never possible to 
> simplify overly complex ones.

Never discount "easy" and "just works", which is what IP (and TCP) gives 
you...

Sure you can use a bridging protocol and all that jazz, but I wager, to 
a network admin yet-another-IP-application is easier to evaluate, deploy 
and manage on existing networks.

	Jeff



