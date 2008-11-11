Return-Path: <linux-kernel-owner+w=401wt.eu-S1756297AbYKKOGa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756297AbYKKOGa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2008 09:06:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755975AbYKKOGS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Nov 2008 09:06:18 -0500
Received: from wf-out-1314.google.com ([209.85.200.175]:1955 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755837AbYKKOGR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2008 09:06:17 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:in-reply-to:references:x-mailer
         :mime-version:content-type:content-transfer-encoding;
        b=mEFc6lvm097uSWsA2mmjgeSZ3FpF0wwKzzl00ljWLkWtT45jb1pocvVGnnFDq35TjF
         AJUWXW0AIlfprAnDwO5hAiVRgTCFanTV2zvia4uBGAwTKdeQtjKk1slOQJIJ2cpcnbA8
         /4phIdOmD3lx5LFvoexYh5O0TxThTuEiJeg3Y=
Date: Tue, 11 Nov 2008 08:06:11 -0600
From: "J. K. Cliburn" <jcliburn@gmail.com>
To: David Madore <david.madore@ens.fr>
Cc: Linux Kernel Mailing-List <linux-kernel@vger.kernel.org>,
       Linux NetDev Mailing-List <netdev@vger.kernel.org>,
       atl1-devel@lists.sourceforge.net
Subject: Re: atl1e Ethernet driver not seeing packets sent to
 33:33:00:00:00:01 multicast
Message-ID: <20081111080611.7f6d4371@osprey.hogchain.net>
In-Reply-To: <20081111133108.GA7124@clipper.ens.fr>
References: <20081111133108.GA7124@clipper.ens.fr>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.12; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 11 Nov 2008 14:31:08 +0100
David Madore <david.madore@ens.fr> wrote:

> Hi,
> 
> This is on Ubuntu 8.10 "Intrepid Ibex" using its stock kernel
> (2.6.27-7.16), with an Eee PC 901 whose Ethernet adapter is (according
> to lspci):
> 
> 04:00.0 Ethernet controller: Attansic Technology Corp. L1 Gigabit
> Ethernet Adapter (rev b0)

Just to verify your system is fitted with the L1e and not the L1 chip,
can you please provide the output of lspci -vvnn?

> 
> using driver atl1e of said kernel.
> 
> _Unless_ the network device is put in promiscuous mode (e.g., by
> running tcpdump), it does not see packets sent to Ethernet multicast
> address 33:33:00:00:00:01.  E.g., IPv6 packets to ff02::1
> (ip6-allnodes) are not seen.
> 
> Practical consequence: IPv6 is broken, because router advertisements
> are not received.
> 
> ("ip maddr show" does give "link  33:33:00:00:00:01" among the
> subscribed multicast addresses, so it's not a config problem.)
> 
> Is this a known problem?  Is there a patch fixing it?
> 
> Until then, a workaround is to put the device in promiscuous mode.
> 
> Happy hacking,
> 
