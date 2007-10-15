Return-Path: <linux-kernel-owner+w=401wt.eu-S1763536AbXJOJwq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763536AbXJOJwq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2007 05:52:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758323AbXJOJwg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Oct 2007 05:52:36 -0400
Received: from static-71-162-243-5.phlapa.fios.verizon.net ([71.162.243.5]:51356
	"EHLO grelber.thyrsus.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758235AbXJOJwf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2007 05:52:35 -0400
From: Rob Landley <rob@landley.net>
Organization: Boundaries Unlimited
To: Nick Piggin <nickpiggin@yahoo.com.au>
Subject: Re: OOM killer gripe (was Re: What still uses the block layer?)
Date: Mon, 15 Oct 2007 04:52:30 -0500
User-Agent: KMail/1.9.6
Cc: Theodore Tso <tytso@mit.edu>,
       James Bottomley <James.Bottomley@steeleye.com>,
       Matthew Wilcox <matthew@wil.cx>, linux-kernel@vger.kernel.org,
       linux-scsi@vger.kernel.org, Suparna Bhattacharya <suparna@in.ibm.com>,
       Nick Piggin <piggin@cyberone.com.au>
References: <200710112011.22000.rob@landley.net> <200710150304.00901.rob@landley.net> <200710152337.45252.nickpiggin@yahoo.com.au>
In-Reply-To: <200710152337.45252.nickpiggin@yahoo.com.au>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200710150452.30939.rob@landley.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 15 October 2007 8:37:44 am Nick Piggin wrote:
> > Virtual memory isn't perfect.  I've _always_ been able to come up with
> > examples where it just doesn't work for me.  This doesn't mean VM
> > overcommit should be abolished, because it's useful more often than not.
>
> I hate to go completely offtopic here, but disks are so incredibly
> slow when compared to RAM that there is really nothing the kernel
> can do about this.

I know.

> Presumably the job will finish, given infinite 
> time.

I gave it about half an hour, then it locked solid and stopped writing to the 
disk at all.  (I gave it another 5 minutes at that point, then held down the 
power button.)

Lost about 50 open konqueror tabs...

> How much swap do you have configured?

2 gigs, same as ram.

> You really shouldn't configure 
> so much unless you do want the kernel to actually use it all, right?

Two words: "Software suspend".  I've actually been thinking of increasing it 
on the next install...

> Because if we're not really conservative about OOM killing, then the
> user who actually really did want to use all the swap they configured
> gets angry when we kill their jobs without using it all.

I tend to lower "swappiness" and when that happens all sorts of stuff goes 
weird.  Software suspend used to say says it can't free enough memory if I 
put swappiness at 0 (dunno if it still does).  This time the OOM killer never 
triggered before hard deadlock.  (I think I had it around 20 or 40 or some 
such.)

> Would an oom-kill-someone-now sysrq be of help, I wonder?

*shrug* It might.  I was a letting it run hoping it would complete itself when 
it locked solid.  (The keyboard LEDs weren't flashing, so I don't _think_ it 
paniced.  I was in X so I wouldn't have seen a message...)

(To be honest, I can never remember how to trigger sysrq on a laptop keyboard.  
Presumably X won't intercept it the way it does alt-f1 and ctrl-alt-del...)

Rob
-- 
"One of my most productive days was throwing away 1000 lines of code."
  - Ken Thompson.
