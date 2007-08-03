Return-Path: <linux-kernel-owner+w=401wt.eu-S1761702AbXHCL5Q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761702AbXHCL5Q (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Aug 2007 07:57:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760875AbXHCL5E
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Aug 2007 07:57:04 -0400
Received: from rv-out-0910.google.com ([209.85.198.184]:39474 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760872AbXHCL5B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Aug 2007 07:57:01 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=RYkjtzpLngEdL/Fu/jI+o578om0Tqc2ZqAPMS/mUpuVCum/UpPW980gumAbsUoA5ni/ddy3foZGXtisUUY8H4MPBsBjdtehuuprCEnOEFlLp4FqzDShAiETcWWfTrWynqxPbFSA4fAcTC/M9e7J+ureXGRcWQnWoJ4Vy+A7B6Qg=
Message-ID: <4bacf17f0708030457i8d5c32xcd1ec4a0640f3822@mail.gmail.com>
Date: Fri, 3 Aug 2007 13:57:00 +0200
From: "=?ISO-8859-2?Q?Marcin_=A6lusarz?=" <marcin.slusarz@gmail.com>
To: "Jarek Poplawski" <jarkao2@o2.pl>
Subject: Re: [patch] genirq: fix simple and fasteoi irq handlers
Cc: "Ingo Molnar" <mingo@elte.hu>, "Gabriel C" <nix.or.die@googlemail.com>,
       "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Thomas Gleixner" <tglx@linutronix.de>,
       "Jean-Baptiste Vignaud" <vignaud@xandmail.fr>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       shemminger <shemminger@linux-foundation.org>,
       linux-net <linux-net@vger.kernel.org>, netdev <netdev@vger.kernel.org>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Alan Cox" <alan@lxorguk.ukuu.org.uk>
In-Reply-To: <20070803091008.GC1582@ff.dom.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1185437431.3227.21.camel@chaos>
	 <20070726085523.GA3423@ff.dom.local> <20070726091254.GA8063@elte.hu>
	 <4bacf17f0707300029g5116e70bq4808059dc8b069f1@mail.gmail.com>
	 <20070731155843.GA7033@elte.hu> <46B20E47.6020403@googlemail.com>
	 <20070802201126.GA27000@elte.hu> <20070803060733.GA1582@ff.dom.local>
	 <20070803080408.GA12222@elte.hu> <20070803091008.GC1582@ff.dom.local>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

2007/8/3, Jarek Poplawski <jarkao2@o2.pl>:
> On Fri, Aug 03, 2007 at 10:04:08AM +0200, Ingo Molnar wrote:
> >
> > * Jarek Poplawski <jarkao2@o2.pl> wrote:
> >
> > > I can't guarantee this is all needed to fix this bug, but I think this
> > > patch is necessary here.
> >
> > hmmm ... very interesting! Now _this_ is something we'd like to see
> > tested. Could you send a patch to Marcin that also undoes the workaround
> > we have in place now, so that he could check whether ne2k-pci works fine
> > with your fix alone?
>
> I'm not sure this is needed... Marcin got this patch, I hope, and I
> don't have another possibility to contact with him. Since he managed
> with this bisection and all the previous patches I don't think there
> could be any problems, so:
>
> Marcin! I'd be very glad if you could test this patch alone; this
> should apply without any problems to 2.6.21 (with some offset) and
> later "vanilla" versions (or try to revert Ingo's last patch with
> patch -p1 -R). Please, contact me on any problems (alas not during
> the weekend...).

I'll test this patch tomorrow (and confirm that the last one from Ingo
works fine) and report results on monday (sorry, no internet at home
since I moved out of city :|).

Marcin
