Return-Path: <linux-kernel-owner+w=401wt.eu-S1756384AbXJaNUT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756384AbXJaNUT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2007 09:20:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758615AbXJaNT7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Oct 2007 09:19:59 -0400
Received: from mx1.redhat.com ([66.187.233.31]:43221 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755515AbXJaNT5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2007 09:19:57 -0400
From: "Arnaldo Carvalho de Melo" <acme@redhat.com>
Date: Wed, 31 Oct 2007 11:18:55 -0200
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Jeff Garzik <jeff@garzik.org>, Nick Piggin <nickpiggin@yahoo.com.au>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, netdev@vger.kernel.org, trond.myklebust@fys.uio.no
Subject: Re: [PATCH 00/33] Swap over NFS -v14
Message-ID: <20071031131855.GE3962@ghostprotocols.net>
Mail-Followup-To: Arnaldo Carvalho de Melo <acme@redhat.com>,
	Peter Zijlstra <a.p.zijlstra@chello.nl>,
	Jeff Garzik <jeff@garzik.org>,
	Nick Piggin <nickpiggin@yahoo.com.au>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org,
	netdev@vger.kernel.org, trond.myklebust@fys.uio.no
References: <20071030160401.296770000@chello.nl> <200710311426.33223.nickpiggin@yahoo.com.au> <1193830033.27652.159.camel@twins> <47287220.8050804@garzik.org> <1193835413.27652.205.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1193835413.27652.205.camel@twins>
X-Url: http://oops.ghostprotocols.net:81/blog
Organization: OOPS Labs
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Em Wed, Oct 31, 2007 at 01:56:53PM +0100, Peter Zijlstra escreveu:
> On Wed, 2007-10-31 at 08:16 -0400, Jeff Garzik wrote:
> > Thoughts:
> > 
> > 1) I absolutely agree that NFS is far more prominent and useful than any 
> > network block device, at the present time.
> > 
> > 
> > 2) Nonetheless, swap over NFS is a pretty rare case.  I view this work 
> > as interesting, but I really don't see a huge need, for swapping over 
> > NBD or swapping over NFS.  I tend to think swapping to a remote resource 
> > starts to approach "migration" rather than merely swapping.  Yes, we can 
> > do it...  but given the lack of burning need one must examine the price.
> 
> There is a large corporate demand for this, which is why I'm doing this.
> 
> The typical usage scenarios are:
>  - cluster/blades, where having local disks is a cost issue (maintenance
>    of failures, heat, etc)
>  - virtualisation, where dumping the storage on a networked storage unit
>    makes for trivial migration and what not..
> 
> But please, people who want this (I'm sure some of you are reading) do
> speak up. I'm just the motivated corporate drone implementing the
> feature :-)

Keep it up, Dave already mentioned iSCSI, there is AoE, there are RT
sockets, you name it, the networking bits we've talked about several
times, they look OK, so I'm sorry for not going over all of them in
detail, but you have my support neverthless.

- Arnaldo
