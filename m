Return-Path: <linux-kernel-owner+w=401wt.eu-S1753989AbXLDR2W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753989AbXLDR2W (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Dec 2007 12:28:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751547AbXLDR2B
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Dec 2007 12:28:01 -0500
Received: from relay.2ka.mipt.ru ([194.85.82.65]:50972 "EHLO 2ka.mipt.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751239AbXLDR2A (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Dec 2007 12:28:00 -0500
Date: Tue, 4 Dec 2007 20:21:47 +0300
From: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
To: Christoph Hellwig <hch@infradead.org>
Cc: Mike Snitzer <snitzer@gmail.com>, lkml <linux-kernel@vger.kernel.org>,
       netdev@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [0/4] DST: Distributed storage.
Message-ID: <20071204172146.GA21838@2ka.mipt.ru>
References: <aqqqqasdzxczc036@2ka.mipt.ru> <11967790263179@2ka.mipt.ru> <170fa0d20712040725o506a47cayb137993041ec3a63@mail.gmail.com> <20071204165625.GA14995@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071204165625.GA14995@infradead.org>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 04, 2007 at 04:56:26PM +0000, Christoph Hellwig (hch@infradead.org) wrote:
> > >  * fixed bug with XFS metadata update (it can provide slab pages to the
> > >         DST, so it is not allowed to transfer them using ->sendpage())
> 
> xfs hasn't been doing that anymore for quite a while.  Block drivers
> don't need hacks for it anymore, epsecially as it's not reliably
> detectable.

I use 2.6.22 and it is there, maybe it was changed later.
Right now it can be detected quite trivially, but can result in a little
more bio startup overhead, I just did not know that it was allowed and
thus did not have a check in the DST.

-- 
	Evgeniy Polyakov
