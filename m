Return-Path: <linux-kernel-owner+w=401wt.eu-S1752392AbZAFJmB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752392AbZAFJmB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2009 04:42:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751559AbZAFJlq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Jan 2009 04:41:46 -0500
Received: from 1wt.eu ([62.212.114.60]:1126 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754487AbZAFJlp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2009 04:41:45 -0500
Date: Tue, 6 Jan 2009 10:41:38 +0100
From: Willy Tarreau <w@1wt.eu>
To: Jarek Poplawski <jarkao2@gmail.com>
Cc: Jens Axboe <jens.axboe@oracle.com>, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org
Subject: Re: Data corruption issue with splice() on 2.6.27.10
Message-ID: <20090106094138.GE25644@1wt.eu>
References: <20081224152841.GB13113@1wt.eu> <20090106085442.GA9513@ff.dom.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090106085442.GA9513@ff.dom.local>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jarek,

On Tue, Jan 06, 2009 at 08:54:42AM +0000, Jarek Poplawski wrote:
> On 24-12-2008 16:28, Willy Tarreau wrote:
> > Hi Jens,
> > 
> > I'm facing a data corruption problem with splice() between two
> > non-blocking TCP sockets on 2.6.27.10. I could finally write a
> > simpler proof of concept, and capture a snapshot of the issue
> > with the associated strace result.
> ...
> > I found an analysis [1] for a potential corruption problem between two
> > sockets, but I noticed there were no responses and I did not fully
> > understand the report anyway.
> > 
> > What can I do to help debug the problem ? I'm really willing to help
> > getting this fixed, and I also have at least one user who definitely
> > wants splice() to work because the recv/send model currently limits
> > haproxy to 3 Gbps on his machines, while I have no problem reaching
> > 10 Gbps with splice().
> ...
> > ----
> > [1] http://lkml.org/lkml/2008/2/26/210
> 
> Great story! Alas I don't understand this fully either, but it seems
> Changli Gao was concerned with sendpage sending this "as pages", so
> when NETIF_F_SG flag is available. Did you try this without SG btw?

No I did not. I can try, it's not too hard. It would in part defeat the
purpose of the mechanism (especially at 10 Gbps) but at least it will
help narrow the problem down.

Thanks for the tip, I'll keep you informed !
Willy

