Return-Path: <linux-kernel-owner+w=401wt.eu-S1756570AbZCFP5g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756570AbZCFP5g (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Mar 2009 10:57:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756273AbZCFP4Y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Mar 2009 10:56:24 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:39432 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756082AbZCFP4W (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Mar 2009 10:56:22 -0500
Date: Fri, 6 Mar 2009 16:55:27 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Daniel Walker <dwalker@fifo99.com>, Randy Dunlap <randy.dunlap@oracle.com>,
       Yinghai Lu <yinghai@kernel.org>, mingo@redhat.com, hpa@zytor.com,
       linux-kernel@vger.kernel.org, ebiederm@xmission.com,
       akpm@linux-foundation.org, gregkh@suse.de, tglx@linutronix.de,
       sarah.a.sharp@intel.com, linux-tip-commits@vger.kernel.org
Subject: Re: [tip:x86/doc] x86/doc: mini-howto for using earlyprintk=dbgp
Message-ID: <20090306155527.GA24448@elte.hu>
References: <1236298195.5937.112.camel@desktop> <Pine.LNX.4.44L0.0903060958130.3461-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.0903060958130.3461-100000@iolanthe.rowland.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Alan Stern <stern@rowland.harvard.edu> wrote:

> On Thu, 5 Mar 2009, Daniel Walker wrote:
> 
> > On Thu, 2009-03-05 at 15:59 -0800, Randy Dunlap wrote:
> > 
> > > > - a.) Host/target system needs to have USB debug port capability.
> > > > + a.) You will need two USB ports. One on the client/console system and one on 
> > > > +     the target system.
> > > > + 
> > > > + b.) The client/console and target USB ports must have the debug port
> > > > +     capability.
> > > 
> > > Is that correct on the (ugh, I think that the naming/terminology is
> > > still mucked up, but you didn't do that) host/target system?
> > > 
> > > On the client/console (which I would call the host and I would call the
> > > "Host/target" here just the Target system), a USB debug port is needed,
> > > but on the Host/target, it should just look like a USB device.
> > > At least that was the intent AFAIK/IIRC.  No?
> > > 
> > 
> > >From the rest of document I assumed Host/target was referring to both
> > sides of the connection. So you would need USB on both sides for this
> > thing to work. I assumed Client/console was just the host. I guess that
> > is all kind of confusing tho ..
> 
> The term "Host" is too confusing to be used here; it has too 
> many other meanings.  "Target" is good.

I used Host/Target for that reason, consistently so. The combo 
gives us the best of both worlds.

> "Client" is probably okay too, but I don't like "Console" so 
> much because both machines will have a console.  "Debugging 
> console" is more accurate but also more cumbersome.

I used client/console term for that reason.

> > The document indicates you need this one capability on your 
> > USB port in addition to the USB device (check the complete 
> > document for how to find the capability). So both host and 
> > target need this one capability, and then you also need the 
> > USB device for the whole thing to work.
> 
> In fact the original document was rather clear about this; it 
> says only that the target machine needs the debug capability.  
> The client machine uses its normal USB driver and treats the 
> debugging cable as a normal USB serial device.

yes.

btw., i think this document is being over-engineered. 
Significantly so.

	Ingo
