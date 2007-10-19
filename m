Return-Path: <linux-kernel-owner+w=401wt.eu-S966653AbXJSOxv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966653AbXJSOxv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Oct 2007 10:53:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933230AbXJSOxn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Oct 2007 10:53:43 -0400
Received: from www.tglx.de ([62.245.132.106]:38789 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933050AbXJSOxm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Oct 2007 10:53:42 -0400
Date: Fri, 19 Oct 2007 16:53:22 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Jeff Garzik <jeff@garzik.org>
cc: LKML <linux-kernel@vger.kernel.org>,
       Eric Biederman <ebiederm@xmission.com>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH 0/9] Remove 'irq' argument from all irq handlers
In-Reply-To: <20071019075443.GA6407@havoc.gtf.org>
Message-ID: <alpine.LFD.0.9999.0710191649120.22770@localhost.localdomain>
References: <20071019075443.GA6407@havoc.gtf.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 19 Oct 2007, Jeff Garzik wrote:
> 
> WARNING NOT FOR MERGE WARNING NOT FOR MERGE WARNING NOT FOR MERGE
> 
> This posting is just to demonstrate something that I have been keeping
> alive in the background.  I have no urge to push it upstream anytime
> soon.
> 
> The overwhelming majority of drivers do not ever bother with the 'irq'
> argument that is passed to each driver's irq handler.
> 
> Of the minority of drivers that do use the arg, the majority of those
> have the irq number stored in their private-info structure somewhere.
> 
> There are a tiny few -- a couple Mac drivers -- which do weird things
> with that argument, but that's it.

Jeff,

thanks for doing this.

Full ACK.

We should do this right at the edge of -rc1. And let's do this right
now in .24 and not drag it out for no good reason.

Thanks,

	tglx
