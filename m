Return-Path: <linux-kernel-owner+w=401wt.eu-S1752686AbXGSEoO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752686AbXGSEoO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2007 00:44:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750836AbXGSEoE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jul 2007 00:44:04 -0400
Received: from 1wt.eu ([62.212.114.60]:3565 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750792AbXGSEoC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2007 00:44:02 -0400
Date: Thu, 19 Jul 2007 06:43:58 +0200
From: Willy Tarreau <w@1wt.eu>
To: Tony Borras <tonyb@sysdev.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Linux 2.4.35 tree abandoned/delayed?
Message-ID: <20070719044358.GA30890@1wt.eu>
References: <8HOJx-2nt-21@gated-at.bofh.it> <8HOJx-2nt-23@gated-at.bofh.it> <8HOJx-2nt-25@gated-at.bofh.it> <8HPFA-3Pn-17@gated-at.bofh.it> <8I29I-6CE-21@gated-at.bofh.it> <20070718160309.530d2ca7.tonyb@sysdev.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070718160309.530d2ca7.tonyb@sysdev.org>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 18, 2007 at 04:03:09PM -0800, Tony Borras wrote:
> On Tue, 17 Jul 2007 22:50:10 +0200
> Willy Tarreau <w@1wt.eu> wrote:
> 
> > Hi Tony,
> > 
> > [ first, please always keep people in CC on LKML since it's
> > very easy to
> >   miss a thread ]
> > 
> > On Mon, Jul 16, 2007 at 11:23:57PM -0800, Tony Borras wrote:
> > > On Tue, 17 Jul 2007 07:20:06 +0200
> > > Willy Tarreau <w@1wt.eu> wrote:
> > > 
> > > > could you please report what the problem was, in case it's
> > > > not fixed yet ?
> > > 
> > > Ok, reproduced error at ./net/ipv4/fib_semantics.c
> > >   line 436 changed label:
> > >                    errout -> err_inval
> > 
> > I don't know where you downloaded 2.4.35-pre5 from, but I've
> > checked the sources and could not find any reference to
> > "errout" here in any version!
> > 
> > Or what is possible is that your 2.4.34 kernel got corrupted
> > on your disk after applying any patch. Sometimes, some shell
> > scripts providede with some
> 
> Negatory on that, Willy!
> 
> Here is what I have verified:
>   At kernel.org:/pub/linux/v2.4
> 
> file: patch-2.4.34.3.bz2 has the corruption at line 213:
>   goto errout
> 
> That is where that came from, when I patched my 2.4.34 to arrive
> at 2.4.34.5,

So your 2.4.34.5 tree is wrong, you forgot to apply 2.4.34.4 to it,
which only fixes this goto. You should rebuild your 2.4.34.X tree
from scratch.

> before applying the 2.4.35.rc5 patch!

No, once again, you should not apply any 2.4.35-preX to 2.4.34.X.
You should apply it to plain 2.4.34.

If you don't have it anymore, I suggest that you revert the 2.4.34.X
patches with "patch -R".

Also, I think you got a lot of rejects when applying 2.4.35 on top of
2.4.34.X since most changes are the sames.

Regards,
Willy

