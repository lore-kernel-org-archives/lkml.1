Return-Path: <linux-kernel-owner+w=401wt.eu-S933017AbXA2AVB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933017AbXA2AVB (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Jan 2007 19:21:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933012AbXA2AVB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Jan 2007 19:21:01 -0500
Received: from mailout.stusta.mhn.de ([141.84.69.5]:42814 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S933002AbXA2AVA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Jan 2007 19:21:00 -0500
Date: Mon, 29 Jan 2007 01:21:08 +0100
From: Adrian Bunk <bunk@stusta.de>
To: David Miller <davem@davemloft.net>
Cc: randy.dunlap@oracle.com, akpm@osdl.org, linux-kernel@vger.kernel.org,
       netfilter@lists.netfilter.org, netdev@vger.kernel.org, kaber@trash.net
Subject: Re: [2.6 patch] NF_CONNTRACK_H323 must depend on (IPV6 || IPV6=n)
Message-ID: <20070129002108.GC6017@stusta.de>
References: <20070128222136.GZ6017@stusta.de> <20070128.155348.39160134.davem@davemloft.net> <20070129000011.GB6017@stusta.de> <20070128.160442.48527586.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070128.160442.48527586.davem@davemloft.net>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 28, 2007 at 04:04:42PM -0800, David Miller wrote:
> From: Adrian Bunk <bunk@stusta.de>
> Date: Mon, 29 Jan 2007 01:00:11 +0100
> 
> > On Sun, Jan 28, 2007 at 03:53:48PM -0800, David Miller wrote:
> > > Adrian is this the correct way to constrain the selection between
> > > "n" and "m" in this kind of situation?  I thought doing something
> > > like "depends on IPV6" is sufficient to achieve that?
> > 
> > "depends on IPV6" would fix the bug - but it would also make 
> > NF_CONNTRACK_H323 unavailable for all people without IPV6 support in 
> > their kernel.
> 
> Yes, that is an issue.
> 
> I guess with some slightly ugly ifdefs we could support the
> whole matrix of possibilities.  But perhaps that's undesirable
> for another reason.
>...

This depends on what NF_CONNTRACK_H323=y, IPV6=m is supposed to be:
- not allowed (NF_CONNTRACK_H323 must be modular) or
- NF_CONNTRACK_H323 can only be used for IPV4

My patch implements the first case.

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

