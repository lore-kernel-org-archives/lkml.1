Return-Path: <linux-kernel-owner+w=401wt.eu-S1753330Ab0AHCsI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753330Ab0AHCsI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jan 2010 21:48:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753155Ab0AHCsH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jan 2010 21:48:07 -0500
Received: from kirsty.vergenet.net ([202.4.237.240]:48045 "EHLO
	kirsty.vergenet.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752939Ab0AHCsE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jan 2010 21:48:04 -0500
Date: Fri, 8 Jan 2010 13:48:02 +1100
From: Simon Horman <horms@verge.net.au>
To: Joe Perches <joe@perches.com>
Cc: David Miller <davem@davemloft.net>, macro@linux-mips.org,
       hartleys@visionengravers.com, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org
Subject: Re: [PATCH] lib/vsprintf.c: Add %pMF to format FDDI bit reversed
 MAC addresses
Message-ID: <20100108024802.GB2465@verge.net.au>
References: <BD79186B4FD85F4B8E60E381CAEE19090208954A@mi8nycmail19.Mi8.com>
 <1262888625.10429.23.camel@Joe-Laptop.home>
 <alpine.LFD.2.00.1001072037170.13474@eddie.linux-mips.org>
 <20100107.140942.135976087.davem@davemloft.net>
 <20100108000843.GI2436@verge.net.au>
 <1262915508.10429.99.camel@Joe-Laptop.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1262915508.10429.99.camel@Joe-Laptop.home>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 07, 2010 at 05:51:48PM -0800, Joe Perches wrote:
> On Fri, 2010-01-08 at 11:08 +1100, Simon Horman wrote:
> > In the vein of this, would it be worth adding some modifier to %i4 to
> > print addresses for ftp helpers? That is, %u,%u,%u,%u. I think
> > there are currently two users of that format string after Joe's latest
> > round of updates.
> 
> I think not.  I think the comma separated uses
> are unusual enough to not support in lib/vsprintf.

Sounds reasonable.

> I did submit a patch to support format strings
> for le32 and u32 ipv4 addresses.
> 
> > The users are net/netfilter/ipvs/ip_vs_ftp.c and
> > net/ipv4/netfilter/nf_nat_ftp.c. Prior to Joe's latest
> > changes ip_vs_ftp.c used %d,%d,%d,%d.
> 
> I submitted a couple of patches that should help.
> 
> o eventually remove NIPQUAD and NIPQUAD_FMT
> o consolidate the 2 netfilter "%u,%u,%u,%u" uses
>   to a single function

