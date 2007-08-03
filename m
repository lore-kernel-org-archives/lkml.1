Return-Path: <linux-kernel-owner+w=401wt.eu-S1761808AbXHCDJT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761808AbXHCDJT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Aug 2007 23:09:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755044AbXHCDJM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Aug 2007 23:09:12 -0400
Received: from rv-out-0910.google.com ([209.85.198.186]:22142 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753525AbXHCDJL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Aug 2007 23:09:11 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=hVlVOKN2G3r7GBcBDSkt4BKW9OYx93nHNOv3aibZn2KUyv4MXh4AOKi9bvgc14atrjXZR0RP9g0s9aRwfMmKyZLmtaRW0HQjuRUzwYqA5OvxT/75F8LL6M2dFxlxmMpPrG25nH0vqjUDbefXsQjX8hjRPIwpq3fNrgd43ll8/5s=
Message-ID: <a8e1da0708022009u6ee22840m6a260bb98481ddb7@mail.gmail.com>
Date: Fri, 3 Aug 2007 03:09:10 +0000
From: "Dave Young" <hidave.darkstar@gmail.com>
To: "Wim Van Sebroeck" <wim@iguana.be>
Subject: Re: eurotechwdt will cause reboot
Cc: LKML <linux-kernel@vger.kernel.org>,
       "Andrew Morton" <akpm@linux-foundation.org>
In-Reply-To: <a8e1da0708021853y1eab0ee1v859ffdb9b35762a2@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <a8e1da0707312003s6000b02s95c90b5971dbbd51@mail.gmail.com>
	 <20070801055845.GA2648@infomag.infomag.iguana.be>
	 <a8e1da0707312322g4559a546xc357505b591f9e65@mail.gmail.com>
	 <a8e1da0708021853y1eab0ee1v859ffdb9b35762a2@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

>On 8/3/07, Dave Young <hidave.darkstar@gmail.com> wrote:
> >On 8/1/07, Dave Young <hidave.darkstar@gmail.com> wrote:
> > >On 8/1/07, Wim Van Sebroeck <wim@iguana.be> wrote:
> > > Hi Dave,
> > >
> > > > config eurotechwdt to yes will cause system silent reboot. Is it right
> > > > behaviour or a bug?
> > >
> > > I think this might be a bug. I'll look at the code and will ask you to do some
> > > tests for me (if that is ok for you).
> > >
> > I'm ok for me. BTW, the rebooting is too quick that I have to set he
> > boot_delay command line parameter to see it.
> >
>
> Hi,
> News: 2.6.23-rc1-mm1 will reboot with eurotechwdt, but 2.6.23-rc1-mm2
> will not. do you need the config files?
>
> I will concentrate on this problem as well. Any hints how to debug?

under 2.6.23-rc1-mm1, modprobe eurotechwdt kernel will print:

[ 4268.950385] timeout WDT timeout
[ 4268.950443] Initiating system reboot.
[ 4268.950472] eurwdt (IRQ 10) handled a spurious interrupt
