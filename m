Return-Path: <linux-kernel-owner+w=401wt.eu-S1757275AbZCBTQv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757275AbZCBTQv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Mar 2009 14:16:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752559AbZCBTQm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Mar 2009 14:16:42 -0500
Received: from fg-out-1718.google.com ([72.14.220.159]:30599 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750910AbZCBTQl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Mar 2009 14:16:41 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding
         :content-disposition:message-id;
        b=YXufGISfy7itXDAoC+vpJSPYrvwKVhygxGBACH4t8R2XTDubz/WN9It9E0ooUBvYmm
         bMFJHNbSTYS+n2RM9/8HZxsoVq9jeYp8QwEgLyY8DcyjYQ+fOsx4QFefPSWDth1pHbcI
         xUKvlvLLPmb8IfIHfnKh7UuJXBZYvUdOSPDLE=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [RFC][PATCH] irq: remove IRQF_DISABLED
Date: Mon, 2 Mar 2009 20:18:03 +0100
User-Agent: KMail/1.11.0 (Linux/2.6.29-rc6-next-20090227; KDE/4.2.0; i686; ; )
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
       lkml <linux-kernel@vger.kernel.org>,
       "linux-arch" <linux-arch@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
References: <1235996477.5330.174.camel@laptop> <200903021948.51500.bzolnier@gmail.com> <alpine.LFD.2.00.0903021101460.3111@localhost.localdomain>
In-Reply-To: <alpine.LFD.2.00.0903021101460.3111@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200903022018.03736.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 02 March 2009, Linus Torvalds wrote:
> 
> On Mon, 2 Mar 2009, Bartlomiej Zolnierkiewicz wrote:
> >
> > Hmm, I said nothing about how it is implemented in the IDE code itself. :)
> 
> Bart, you're missing the point. I'm _also_ not at all interested in how 
> it's implemented in the IDE code.
> 
> The whole - and only - point is that there are drivers that are _known_ to 
> require non-IRQF_DISABLED semantics. IDE is one such one.
> 
> > Fixing this is on long-term TODO (there was just a ton of more high-prio
> > stuff to take care of first).
> 
> Even if you can fix IDE to do everything using softirq's or other tricks 
> (threads, whatever), nothing really changes. It just means that now there 
> is one less driver that may need the non-IRQF_DISABLED semantics.

I didn't meant non-IRQF_DISABLED semantics (I see absolutely no point in
changing it) but IDE's internal "disable IRQs just to enable them" issue.  

[ Sorry for poorly explaining things. ]

Thanks,
Bart
