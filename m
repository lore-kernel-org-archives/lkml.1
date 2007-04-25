Return-Path: <linux-kernel-owner+w=401wt.eu-S1753349AbXDYPBe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753349AbXDYPBe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2007 11:01:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754116AbXDYPBe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Apr 2007 11:01:34 -0400
Received: from 85-126-107-146.static.sdsl-line.inode.at ([85.126.107.146]:1788
	"EHLO mail.contec.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753349AbXDYPBd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2007 11:01:33 -0400
From: Manfred Gruber <m.gruber@tirol.com>
To: linux-kernel@vger.kernel.org
Subject: Re: preempt_rt bug or warn on arm v4t
Date: Wed, 25 Apr 2007 17:02:09 +0200
User-Agent: KMail/1.6.2
References: <200704201306.08066.m.gruber@tirol.com> <1177074102.3636.49.camel@localhost.localdomain> <200704201526.40785.m.gruber@tirol.com>
In-Reply-To: <200704201526.40785.m.gruber@tirol.com>
Cc: tglx@linutronix.de, Jan Altenberg <jan.altenberg@linutronix.de>,
       Ingo Molnar <mingo@elte.hu>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Message-Id: <200704251702.09125.m.gruber@tirol.com>
X-OriginalArrivalTime: 25 Apr 2007 15:01:28.0812 (UTC) FILETIME=[9A393AC0:01C7874A]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi !

Gerrit Binnenmars pointed out that others have the same problem:
http://linux.omap.com/pipermail/linux-omap-open-source/2007-April/009535.html:
http://article.gmane.org/gmane.linux.distributions.gumstix.general/21376/match=gumstix+realtime+bug+sched+c

Jan Altenberg showed me that in include/asm-arm/system.h I should comment out 
this line:
#define __ARCH_WANT_INTERRUPTS_ON_CTXSW

Without this line, irqs are disabled on context switches. But this is only a 
change that the WARN dose not more occure. Is this now a hack or the 
sollution? Hopfully some RT hacker can look deeper, and find what is wrong.

thanks
regards manfred

Am Freitag, 20. April 2007 15:26 schrieben Sie:
> hi jan !
>
> Am Freitag, 20. April 2007 15:01 schrieben Sie:
> > > I am using 2.6.21-rc7 with Preempt_rt Patch 2.6.20-rc6-rt0 on ep93xx.
> >
> > Do you mean 2.6.21-rc6-rt0?
>
> sorry yes 2.6.21-rc6-rt0.
>
> > > This oops does not trigger in preempt_rt patch is applied.
> >
> > It does only appear, when the preempt_rt patch is applied. Did I get you
> > right?
>
> correct
>
> regards manfred
> -
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/


