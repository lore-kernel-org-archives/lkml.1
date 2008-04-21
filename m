Return-Path: <linux-kernel-owner+w=401wt.eu-S1755221AbYDUIo6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755221AbYDUIo6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2008 04:44:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753980AbYDUIoq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Apr 2008 04:44:46 -0400
Received: from smtp4.pp.htv.fi ([213.243.153.38]:32810 "EHLO smtp4.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753966AbYDUIop (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2008 04:44:45 -0400
Date: Mon, 21 Apr 2008 11:44:02 +0300
From: Adrian Bunk <bunk@kernel.org>
To: David Miller <davem@davemloft.net>
Cc: mingo@elte.hu, linville@tuxdriver.com, tomas.winkler@intel.com,
       linux-kernel@vger.kernel.org, kaber@trash.net,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       netdev@vger.kernel.org, netfilter-devel@vger.kernel.org,
       mabbas@linux.intel.com, ischram@telenet.be, rjw@sisk.pl
Subject: Re: [build bug] nf_nat_proto_sctp.c:(.text+0x6d173): undefined
	reference to `crc32c_le'
Message-ID: <20080421084402.GF26897@cs181133002.pp.htv.fi>
References: <20080421062244.GA862@elte.hu> <20080420.235354.104901823.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20080420.235354.104901823.davem@davemloft.net>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Apr 20, 2008 at 11:53:54PM -0700, David Miller wrote:
> From: Ingo Molnar <mingo@elte.hu>
> Date: Mon, 21 Apr 2008 08:22:44 +0200
> 
> >   net/built-in.o: In function `sctp_manip_pkt':
> >   nf_nat_proto_sctp.c:(.text+0x6d173): undefined reference to `crc32c_le'
> >   nf_nat_proto_sctp.c:(.text+0x6d180): undefined reference to `crc32c_le'
> >   nf_nat_proto_sctp.c:(.text+0x6d196): undefined reference to `crc32c_le'
> >   nf_nat_proto_sctp.c:(.text+0x6d1c6): undefined reference to `crc32c_le'
> > 
> >   http://redhat.com/~mingo/misc/config-Mon_Apr_21_01_52_14_CEST_2008.bad
> 
> Thanks for your report Ingo.
> 
> Patrick, I'm not so sure how to fix this, or even what's wrong.
> 
> NF_NAT_PROTO_SCTP does a proper select on LIBCRC32C, but somehow
> NF_NAT_PROTO_SCTP=y and LIBCRC32C=m.
>...

You added the select on Saturday after Pete Clements reported the same 
issue.

The select is not yet in Linus' tree.

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

