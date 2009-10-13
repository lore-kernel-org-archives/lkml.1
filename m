Return-Path: <linux-kernel-owner+w=401wt.eu-S933722AbZJMImi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933722AbZJMImi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Oct 2009 04:42:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759225AbZJMImi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Oct 2009 04:42:38 -0400
Received: from mx1.redhat.com ([209.132.183.28]:20734 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759223AbZJMImh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Oct 2009 04:42:37 -0400
Date: Tue, 13 Oct 2009 10:41:14 +0200 (CEST)
From: John Kacur <jkacur@redhat.com>
X-X-Sender: jkacur@localhost.localdomain
To: Mike Frysinger <vapier.adi@gmail.com>
cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Vincent Sanders <vince@simtec.co.uk>, Ingo Molnar <mingo@elte.hu>,
       Christoph Hellwig <hch@infradead.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jonathan Corbet <corbet@lwn.net>, David Howells <dhowells@redhat.com>,
       Yoshinori Sato <ysato@users.sourceforge.jp>,
       Roman Zippel <zippel@linux-m68k.org>, Greg Ungerer <gerg@uclinux.org>,
       Koichi Yasutake <yasutake.koichi@jp.panasonic.com>
Subject: Re: [PATCH 1/6 RFC] arch/blackfin/kernel/process.c: Remove the BKL
  from sys_execve
In-Reply-To: <8bd0f97a0910130135s152ee984sc8499766d3c0ef86@mail.gmail.com>
Message-ID: <alpine.LFD.2.00.0910131040340.3781@localhost.localdomain>
References: <alpine.LFD.2.00.0910122350140.3658@localhost.localdomain>  <alpine.LFD.2.00.0910130007240.3658@localhost.localdomain>  <8bd0f97a0910130054v43fd9fbcv5316a5194ced4bfc@mail.gmail.com>  <alpine.LFD.2.00.0910131027090.3781@localhost.localdomain>
 <8bd0f97a0910130135s152ee984sc8499766d3c0ef86@mail.gmail.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 13 Oct 2009, Mike Frysinger wrote:

> On Tue, Oct 13, 2009 at 04:27, John Kacur wrote:
> > On Tue, 13 Oct 2009, Mike Frysinger wrote:
> >> On Mon, Oct 12, 2009 at 18:33, John Kacur wrote:
> >> > This looks like a cut-and-paste job.
> >> > For example, compare this function to sys_execve in
> >> > arch/x86/kernel/process_64.c
> >> >
> >> > and it is almost line by line the same, except the one in x86 nolonger has the
> >> > big kernel lock. All of the functions called between the lock are generic
> >> > and not specific to blackfin - thus, I believe it is safe to remove the
> >> > bkl here.
> >>
> >> and it still boots/runs fine, so np here
> >> Acked-by: Mike Frysinger <vapier@gentoo.org>
> >
> > Cool - are you testing on one of those nifty smp (or smp-like) blackfins?
> 
> no, this was a uniproc.  i could try a SMP Blackfin if you think it'll
> make a difference.
> -mike
> 

Well - hopefully it won't make a difference, but if there are problems, 
then that is where they will show up.

Thanks

