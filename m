Return-Path: <linux-kernel-owner+w=401wt.eu-S936705AbXGSADE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936705AbXGSADE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2007 20:03:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S936259AbXGSACR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Jul 2007 20:02:17 -0400
Received: from 69-12-177-67.dsl.static.sonic.net ([69.12.177.67]:39610 "EHLO
	orion.sysdev.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S936642AbXGSACP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2007 20:02:15 -0400
Date: Wed, 18 Jul 2007 16:03:09 -0800
From: Tony Borras <tonyb@sysdev.org>
To: linux-kernel@vger.kernel.org
Subject: Re: Linux 2.4.35 tree abandoned/delayed?
Message-Id: <20070718160309.530d2ca7.tonyb@sysdev.org>
In-Reply-To: <8I29I-6CE-21@gated-at.bofh.it>
References: <8HOJx-2nt-21@gated-at.bofh.it>
	<8HOJx-2nt-23@gated-at.bofh.it>
	<8HOJx-2nt-25@gated-at.bofh.it>
	<8HPFA-3Pn-17@gated-at.bofh.it>
	<8I29I-6CE-21@gated-at.bofh.it>
Organization: SysDev Inc.
X-Mailer: Sylpheed version 1.0.6 (GTK+ 1.2.10; i686-pc-linux-gnu)
X-Operating-System: Linux-2.6.27-SMP64
X-SlakBoot: SlakbootIBS v11.0.2
User-Agent: Sylpheed/1.0.6
X-Sylpheed-Rules: You Bet
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 17 Jul 2007 22:50:10 +0200
Willy Tarreau <w@1wt.eu> wrote:

> Hi Tony,
> 
> [ first, please always keep people in CC on LKML since it's
> very easy to
>   miss a thread ]
> 
> On Mon, Jul 16, 2007 at 11:23:57PM -0800, Tony Borras wrote:
> > On Tue, 17 Jul 2007 07:20:06 +0200
> > Willy Tarreau <w@1wt.eu> wrote:
> > 
> > > could you please report what the problem was, in case it's
> > > not fixed yet ?
> > 
> > Ok, reproduced error at ./net/ipv4/fib_semantics.c
> >   line 436 changed label:
> >                    errout -> err_inval
> 
> I don't know where you downloaded 2.4.35-pre5 from, but I've
> checked the sources and could not find any reference to
> "errout" here in any version!
> 
> Or what is possible is that your 2.4.34 kernel got corrupted
> on your disk after applying any patch. Sometimes, some shell
> scripts providede with some

Negatory on that, Willy!

Here is what I have verified:
  At kernel.org:/pub/linux/v2.4

file: patch-2.4.34.3.bz2 has the corruption at line 213:
  goto errout

That is where that came from, when I patched my 2.4.34 to arrive
at 2.4.34.5, before applying the 2.4.35.rc5 patch!

Hope that helps, maybe you can fix, because I cant post to
kernel.org v2.4 tree, that I know of.

TonyB


There are 10 types of people in this world, those that read
binary and those who don't!

--
  __      __  _     I N C.               http://www.sysdev.org
/ __|\\// __||  \  __   __          /         tonyb@sysdev.org
\__ \ \/\__ \||)|/ O_)\/ /        \/  System Tools / Utilities
|___/ || ___/|_ /\___|\_/        WIntel / Linux Device Drivers

