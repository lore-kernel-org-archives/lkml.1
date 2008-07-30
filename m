Return-Path: <linux-kernel-owner+w=401wt.eu-S1758026AbYG3T4V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758026AbYG3T4V (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2008 15:56:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753836AbYG3T4A
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jul 2008 15:56:00 -0400
Received: from 1wt.eu ([62.212.114.60]:2277 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755424AbYG3Tz7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2008 15:55:59 -0400
Date: Wed, 30 Jul 2008 21:55:48 +0200
From: Willy Tarreau <w@1wt.eu>
To: Richard Hartmann <richih.mailinglist@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: iptables, NAT, DNS & Dan Kaminsky
Message-ID: <20080730195548.GA615@1wt.eu>
References: <2d460de70807300753w33c43340xaa52c54add501306@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2d460de70807300753w33c43340xaa52c54add501306@mail.gmail.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 30, 2008 at 04:53:57PM +0200, Richard Hartmann wrote:
> Hi all,
> 
> as you are very likely all aware, Dan Kaminsky uncovered a major exploit
> in RFC-compliant DNS caching servers the successful execution of which
> relies on port prediction/guessing.
> 
> After quite some research, I have come up with the following facts which
> I want to cross-check with you guys so I can be _sure_.
> 
> 
> 1) The --random target for SNAT exists since 2.6.22 to allow 'fixing' of
> broken DNS servers in your NATted LAN along the lines of
> 
> iptables -t nat -I POSTROUTING 1 -p udp -s 1.2.3.4 --dport 53 -j SNAT \
> --to 1.2.3.4 --random
> 
> Is that correct?
> 
> 
> 2) Unless there is a collision, the original UDP source ports for
> requests are kept the same. I.e. boxes within the NATted LAN which use
> random UDP ports are secure and neither the 2.4.x nor the 2.6.x series
> of kernels will make those ports predictable while NATting the packets.
> Is that correct?
> 
> 
> 3) Ever since a commit that went into 2.6.24 [1], UDP ports that are
> NATted are randomized by the NATting forewarder, anyway. This means that
> any DNS lookup made from within a NATted LAN secured with iptables to a
> DNS server outside of said NAT is secure by default.
> Is that correct?
> 
> 
> Thanks for any and all input. I am sure many people would like
> clarification on those points.

Richard,

you should re-post your question to relevant lists. I think that
the netfilter ML would be more appropriate. The list you posted to
is about Linux kernel development, which has nothing to do with
how to setup iptables rules, so I don't think you'll find useful
answers here, if any. And BTW I don't think that many of the people
reading LKML care a dime about the "exploit" for poorly configured
DNS servers.

Regards,
Willy

