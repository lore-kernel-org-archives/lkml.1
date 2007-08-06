Return-Path: <linux-kernel-owner+w=401wt.eu-S1759766AbXHFHIR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759766AbXHFHIR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2007 03:08:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754416AbXHFHH6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Aug 2007 03:07:58 -0400
Received: from wa-out-1112.google.com ([209.85.146.176]:39020 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753926AbXHFHH4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2007 03:07:56 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=NN+5rBvOj0WvvkkPlo4QWyIYTIv/AxDXcYOSXoA09sj7fyAQYjuk/FVDwPQC8f72URScR2iE3/0Yz7vhA8wppyEsc+N+SEh+3kQ1AP+cMHuye/Wie9wpIK6Y6XxpX5Jdr/XmicOd7iVHRdeLOHfXt2YNrtUblJv/1sz0RtJMQMU=
Message-ID: <4bacf17f0708060007t7c849ff1p5dbb07c614789617@mail.gmail.com>
Date: Mon, 6 Aug 2007 09:07:55 +0200
From: "=?ISO-8859-2?Q?Marcin_=A6lusarz?=" <marcin.slusarz@gmail.com>
To: "Ingo Molnar" <mingo@elte.hu>
Subject: Re: [patch (take 2)] genirq: fix simple and fasteoi irq handlers
Cc: "Jarek Poplawski" <jarkao2@o2.pl>, "Gabriel C" <nix.or.die@googlemail.com>,
       "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Thomas Gleixner" <tglx@linutronix.de>,
       "Jean-Baptiste Vignaud" <vignaud@xandmail.fr>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       shemminger <shemminger@linux-foundation.org>,
       linux-net <linux-net@vger.kernel.org>, netdev <netdev@vger.kernel.org>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Alan Cox" <alan@lxorguk.ukuu.org.uk>
In-Reply-To: <20070806061459.GA26046@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070726081326.GA3197@ff.dom.local>
	 <20070726083120.GA26910@elte.hu> <20070726085523.GA3423@ff.dom.local>
	 <20070726091254.GA8063@elte.hu>
	 <4bacf17f0707300029g5116e70bq4808059dc8b069f1@mail.gmail.com>
	 <20070731155843.GA7033@elte.hu> <46B20E47.6020403@googlemail.com>
	 <20070802201126.GA27000@elte.hu> <20070806060723.GA981@ff.dom.local>
	 <20070806061459.GA26046@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

2007/8/6, Ingo Molnar <mingo@elte.hu>:
>
> * Jarek Poplawski <jarkao2@o2.pl> wrote:
>
> > Subject: genirq: fix simple and fasteoi irq handlers
> >
> > After the "genirq: do not mask interrupts by default" patch interrupts
> > should be disabled not immediately upon request, but after they
> > happen. But, handle_simple_irq() and handle_fasteoi_irq() can skip
> > this once or more if an irq is just serviced (IRQ_INPROGRESS),
> > possibly disrupting a driver's work.
>
> nice fix. I think this is exactly the type of bug we were hoping to be
> able to identify and fix, and it could explain the regression in its
> entirety. The big question - does it fix Marcin's regression?
I'll try this patch tomorrow.

Marcin
