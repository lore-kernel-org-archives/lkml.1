Return-Path: <linux-kernel-owner+w=401wt.eu-S1755454AbZJTGym@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755454AbZJTGym (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Oct 2009 02:54:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755349AbZJTGyl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Oct 2009 02:54:41 -0400
Received: from mailout-apollo.uni-duesseldorf.de ([134.99.128.36]:55530 "EHLO
	mail.rz.uni-duesseldorf.de" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754730AbZJTGyl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Oct 2009 02:54:41 -0400
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: TEXT/PLAIN; charset=US-ASCII
Date: Tue, 20 Oct 2009 08:51:08 +0200 (CEST)
From: Michael Schmitz <schmitz@biophys.uni-duesseldorf.de>
Subject: Re: Fwd: [PATCH] [RFC] ataflop: remove buggy IRQ disable from
 do_fd_request()
In-reply-to: <alpine.LSU.2.00.0910190932030.8582@wotan.suse.de>
To: Jiri Kosina <jkosina@suse.cz>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>,
       linux-m68k <linux-m68k@vger.kernel.org>, Tejun Heo <tj@kernel.org>,
       Jens Axboe <jens.axboe@oracle.com>, linux-kernel@vger.kernel.org
Message-id: <alpine.DEB.2.00.0910200847320.8658@zirkon.biophys.uni-duesseldorf.de>
References: <alpine.LSU.2.00.0910091141150.19284@wotan.suse.de>
 <10f740e80910100201n30367714uc57ec3c9c39b92af@mail.gmail.com>
 <alpine.DEB.2.00.0910110846420.20140@zirkon.biophys.uni-duesseldorf.de>
 <alpine.LSU.2.00.0910121106330.19284@wotan.suse.de>
 <alpine.DEB.2.00.0910182126120.6395@zirkon.biophys.uni-duesseldorf.de>
 <alpine.LSU.2.00.0910190932030.8582@wotan.suse.de>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jiri,

> > > Please elaborate a little bit more which of the two points above you base 
> > > your NACK on.
> > 
> > The removal of local_irq_disable() (which should have been local_irq_enable()) 
> > just raised a flag, and I didn't immediately see why the interrupt enable had 
> > been commented out. 
> 
> Yes, it has been commented out in a very non-intuitive way.

That. too :-) What I meant to say - the reason why someone chose to comment out 
the original sti() wasn't really clear. I guess the reason for that particular 
change has been lost in the pre-git or bk era.
 
> > With a bit of further thought on the matter I am satisfied that this patch will 
> > not impact on driver function at all, and do not wish to sustain my objection.
> > 
> > IOW: Ack, and my sincere apologies for wasting your time. 
> 
> Thanks, I have added
> 
> 	Acked-by: Michael Schmitz <schmitz@biophys.uni-duesseldorf.de>
> 
> to the patch changelog in my tree.

That's right ...

	Michael

