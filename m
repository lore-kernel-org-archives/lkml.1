Return-Path: <linux-kernel-owner+w=401wt.eu-S1760596AbYDUI7Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760596AbYDUI7Y (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2008 04:59:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754900AbYDUI7H
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Apr 2008 04:59:07 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:41192
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1754539AbYDUI7G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2008 04:59:06 -0400
Date: Mon, 21 Apr 2008 01:59:06 -0700 (PDT)
Message-Id: <20080421.015906.239470094.davem@davemloft.net>
To: bunk@kernel.org
Cc: mingo@elte.hu, linville@tuxdriver.com, tomas.winkler@intel.com,
       linux-kernel@vger.kernel.org, kaber@trash.net,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       netdev@vger.kernel.org, netfilter-devel@vger.kernel.org,
       mabbas@linux.intel.com, ischram@telenet.be, rjw@sisk.pl
Subject: Re: [build bug] nf_nat_proto_sctp.c:(.text+0x6d173): undefined
 reference to `crc32c_le'
From: David Miller <davem@davemloft.net>
In-Reply-To: <20080421084402.GF26897@cs181133002.pp.htv.fi>
References: <20080421062244.GA862@elte.hu>
	<20080420.235354.104901823.davem@davemloft.net>
	<20080421084402.GF26897@cs181133002.pp.htv.fi>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Adrian Bunk <bunk@kernel.org>
Date: Mon, 21 Apr 2008 11:44:02 +0300

> On Sun, Apr 20, 2008 at 11:53:54PM -0700, David Miller wrote:
> > From: Ingo Molnar <mingo@elte.hu>
> > Date: Mon, 21 Apr 2008 08:22:44 +0200
> > 
> > >   net/built-in.o: In function `sctp_manip_pkt':
> > >   nf_nat_proto_sctp.c:(.text+0x6d173): undefined reference to `crc32c_le'
> > >   nf_nat_proto_sctp.c:(.text+0x6d180): undefined reference to `crc32c_le'
> > >   nf_nat_proto_sctp.c:(.text+0x6d196): undefined reference to `crc32c_le'
> > >   nf_nat_proto_sctp.c:(.text+0x6d1c6): undefined reference to `crc32c_le'
> > > 
> > >   http://redhat.com/~mingo/misc/config-Mon_Apr_21_01_52_14_CEST_2008.bad
> > 
> > Thanks for your report Ingo.
> > 
> > Patrick, I'm not so sure how to fix this, or even what's wrong.
> > 
> > NF_NAT_PROTO_SCTP does a proper select on LIBCRC32C, but somehow
> > NF_NAT_PROTO_SCTP=y and LIBCRC32C=m.
> >...
> 
> You added the select on Saturday after Pete Clements reported the same 
> issue.
> 
> The select is not yet in Linus' tree.

Thanks for catching that Adrian.
