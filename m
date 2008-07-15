Return-Path: <linux-kernel-owner+w=401wt.eu-S1763522AbYGOVwc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763522AbYGOVwc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2008 17:52:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762773AbYGOVwR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jul 2008 17:52:17 -0400
Received: from fg-out-1718.google.com ([72.14.220.152]:23117 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762416AbYGOVwQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2008 17:52:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=uANPUSyJpMpxXR9CBvfEmlF3zCO73P2XtAtiX1jf8ayOVVnbr5SlS72Lr8AguzKU3X
         PiewtuovrsNEuOaDkGoYx4IpieuAjE4Jk8D2weK1Nae5Q/yaT2JBG3KzcM83YsD7XonL
         IfCgVy63vwCF0FvNVYfxYJFBiOoW7drwSDN2Y=
Date: Wed, 16 Jul 2008 01:49:30 +0400
From: Alexey Dobriyan <adobriyan@gmail.com>
To: David Miller <davem@davemloft.net>, mingo@elte.hu
Cc: nhorman@tuxdriver.com, simon@fire.lp0.eu, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, herbert@gondor.apana.org.au
Subject: Re: BUG: unable to handle kernel NULL pointer dereference at
	000000000000000e (reset_prng_context)
Message-ID: <20080715214929.GA18268@martell.zuzino.mipt.ru>
References: <487BE071.80101@simon.arlott.org.uk> <20080715020428.GA27463@hmsendeavour.rdu.redhat.com> <20080715113304.GA30565@elte.hu> <20080715.134407.150543177.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080715.134407.150543177.davem@davemloft.net>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 15, 2008 at 01:44:07PM -0700, David Miller wrote:
> From: Ingo Molnar <mingo@elte.hu>
> 
> > i have just triggered this crash too. Please, when you know about bootup 
> > crashes in your code send a patch to the lkml thread so that people can 
> > apply it and have a working system.
> > 
> > Note that the new crypto/prng.c driver has very bad quality:
> > 
> >   total: 45 errors, 21 warnings, 1 checks, 410 lines checked
> > 
> > It has tons of completely unacceptable code mistakes in it.
> 
> I think we should merge new drivers as aggressively as possible.

Well, I don't have strong opinion about this exact statement, but

	Ingo, COULD YOU PLEASE PERSONALLY FUCKING STOP THIS
	CHECKPATCH.PL-AS-INDICATOR HORSESHIT !

Every damn single warning in this case is about whitespace or 80 column limit.

Every damn single one!

The hacker of your calibre should know the difference between whitespace-bad code
and bug-ridden-bad code.


What are those unacceptable mistakes?

Don't read the code again, what are those mistakes?


I _very_ briefly looked at prng.c and place I find wrong it passing
"int nbytes" to get_prng_bytes(). It should be unsigned at least.

checkpatch.pl says about this? Suuuure, it does...

