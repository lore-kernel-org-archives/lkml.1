Return-Path: <linux-kernel-owner+w=401wt.eu-S1752803AbYK2Giu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752803AbYK2Giu (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Nov 2008 01:38:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750836AbYK2Gih
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 29 Nov 2008 01:38:37 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:47800 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750701AbYK2Gig (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Nov 2008 01:38:36 -0500
Date: Sat, 29 Nov 2008 01:38:17 -0500
From: Christoph Hellwig <hch@infradead.org>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Ingo Molnar <mingo@elte.hu>, Eric Dumazet <dada1@cosmosbay.com>,
       David Miller <davem@davemloft.net>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       linux-kernel@vger.kernel.org, kernel-testers@vger.kernel.org,
       Mike Galbraith <efault@gmx.de>,
       Linux Netdev List <netdev@vger.kernel.org>,
       Christoph Lameter <cl@linux-foundation.org>,
       Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 0/6] fs: Scalability of sockets/pipes
	allocation/deallocation on SMP
Message-ID: <20081129063816.GA869@infradead.org>
References: <49267694.1030506@cosmosbay.com> <20081121.010508.40225532.davem@davemloft.net> <4926AEDB.10007@cosmosbay.com> <4926D022.5060008@cosmosbay.com> <20081121152148.GA20388@elte.hu> <4926D39D.9050603@cosmosbay.com> <20081121153453.GA23713@elte.hu> <492DDB6A.8090806@cosmosbay.com> <20081128180318.GL10487@elte.hu> <1227898076.7392.16.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1227898076.7392.16.camel@twins>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 28, 2008 at 07:47:56PM +0100, Peter Zijlstra wrote:
> > Wow, that's incredibly impressive! :-)
> 
> Yeah, we got a similar speedup on -rt by pushing those super-block files
> list into per-cpu lists and doing crazy locking on them.
> 
> Of course avoiding them all together, like done here is a nicer option
> but is sadly not a possibility for regular files (until hch gets around
> to removing the need for the list).

We should have finished this long ago, thanks for the reminder.

