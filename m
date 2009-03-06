Return-Path: <linux-kernel-owner+w=401wt.eu-S1756458AbZCFQQm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756458AbZCFQQm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Mar 2009 11:16:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756035AbZCFQQW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Mar 2009 11:16:22 -0500
Received: from fifo99.com ([67.223.236.141]:50835 "EHLO fifo99.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755021AbZCFQQV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Mar 2009 11:16:21 -0500
Subject: Re: [tip:x86/doc] x86/doc: mini-howto for using earlyprintk=dbgp
From: Daniel Walker <dwalker@fifo99.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Alan Stern <stern@rowland.harvard.edu>,
       Randy Dunlap <randy.dunlap@oracle.com>, Yinghai Lu <yinghai@kernel.org>,
       mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       ebiederm@xmission.com, akpm@linux-foundation.org, gregkh@suse.de,
       tglx@linutronix.de, sarah.a.sharp@intel.com,
       linux-tip-commits@vger.kernel.org
In-Reply-To: <20090306155527.GA24448@elte.hu>
References: <1236298195.5937.112.camel@desktop>
	 <Pine.LNX.4.44L0.0903060958130.3461-100000@iolanthe.rowland.org>
	 <20090306155527.GA24448@elte.hu>
Content-Type: text/plain
Date: Fri, 06 Mar 2009 08:16:19 -0800
Message-Id: <1236356179.5937.143.camel@desktop>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-03-06 at 16:55 +0100, Ingo Molnar wrote:

> > > 
> > > >From the rest of document I assumed Host/target was referring to both
> > > sides of the connection. So you would need USB on both sides for this
> > > thing to work. I assumed Client/console was just the host. I guess that
> > > is all kind of confusing tho ..
> > 
> > The term "Host" is too confusing to be used here; it has too 
> > many other meanings.  "Target" is good.
> 
> I used Host/Target for that reason, consistently so. The combo 
> gives us the best of both worlds.

What meaning of Host did you intend? Is Host/Target just referring to
one machine in this scenario or both?

> > "Client" is probably okay too, but I don't like "Console" so 
> > much because both machines will have a console.  "Debugging 
> > console" is more accurate but also more cumbersome.
> 
> I used client/console term for that reason.

Same questions for this as above, one machine or both? I think it's
clear from the text when you read it all (not to mention this doesn't
seem like a sophisticated setup), but if someone had trouble with this
they might start reading into the terms and get more confused.

> > > The document indicates you need this one capability on your 
> > > USB port in addition to the USB device (check the complete 
> > > document for how to find the capability). So both host and 
> > > target need this one capability, and then you also need the 
> > > USB device for the whole thing to work.
> > 
> > In fact the original document was rather clear about this; it 
> > says only that the target machine needs the debug capability.  
> > The client machine uses its normal USB driver and treats the 
> > debugging cable as a normal USB serial device.
> 
> yes.
> 
> btw., i think this document is being over-engineered. 
> Significantly so.

I agree (but what are you going to do?)

Daniel

