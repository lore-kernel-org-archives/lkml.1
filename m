Return-Path: <linux-kernel-owner+w=401wt.eu-S1030510AbXEDPiI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030510AbXEDPiI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 May 2007 11:38:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030780AbXEDPiI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 May 2007 11:38:08 -0400
Received: from amsfep17-int.chello.nl ([213.46.243.15]:12141 "EHLO
	amsfep18-int.chello.nl" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1030510AbXEDPiG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 May 2007 11:38:06 -0400
Subject: Re: [PATCH 00/40] Swap over Networked storage -v12
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Daniel Walker <dwalker@mvista.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, netdev@vger.kernel.org,
       Trond Myklebust <trond.myklebust@fys.uio.no>,
       Thomas Graf <tgraf@suug.ch>, David Miller <davem@davemloft.net>,
       James Bottomley <James.Bottomley@SteelEye.com>,
       Mike Christie <michaelc@cs.wisc.edu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Daniel Phillips <phillips@google.com>
In-Reply-To: <1178292179.7997.12.camel@imap.mvista.com>
References: <20070504102651.923946304@chello.nl>
	 <1178292179.7997.12.camel@imap.mvista.com>
Content-Type: text/plain
Date: Fri, 04 May 2007 17:38:01 +0200
Message-Id: <1178293081.24217.46.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2007-05-04 at 08:22 -0700, Daniel Walker wrote:
> On Fri, 2007-05-04 at 12:26 +0200, Peter Zijlstra wrote:
> 
> > 1) introduce the memory reserve and make the SLAB allocator play nice with it.
> >    patches 01-10
> > 
> > 2) add some needed infrastructure to the network code
> >    patches 11-13
> > 
> > 3) implement the idea outlined above
> >    patches 14-20
> > 
> > 4) teach the swap machinery to use generic address_spaces
> >    patches 21-24
> > 
> > 5) implement swap over NFS using all the new stuff
> >    patches 25-31
> > 
> > 6) implement swap over iSCSI
> >    patches 32-40
> 
> This is kind of a lot of patches all at once .. Have you release any of
> these patch sets prior to this release ? 

Like the -v12 suggests, this is the 12th posting of this patch set.
Some is the same, some has changed.

