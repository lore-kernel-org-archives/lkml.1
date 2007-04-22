Return-Path: <linux-kernel-owner+w=401wt.eu-S1754314AbXDVSNZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754314AbXDVSNZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Apr 2007 14:13:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754323AbXDVSNZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Apr 2007 14:13:25 -0400
Received: from smtp103.sbc.mail.mud.yahoo.com ([68.142.198.202]:33758 "HELO
	smtp103.sbc.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754314AbXDVSNX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Apr 2007 14:13:23 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=WxeC9urO0d77x5z6ZRhPqtKwT2NetcxRLo5snWaC0H3qVU9cAeCsXnnuKJgqrSbKUGjzcGQWj+5dKe/v6a1IKVeykVihz4cN5PxQB14MFUmbemEuKSYYSV2N4hEauDWpNqXdRNemKm1xvN/Zk7tUG/tu1r/32GT3qzTw2KSFAFM=  ;
X-YMail-OSG: zCE08SwVM1msb1e.2R.OnSGq._U7UO1CdxaiQkg_LmTsI72C2DVhSibH4L9_4KnyFEhOyu_eCQ--
From: David Brownell <david-b@pacbell.net>
To: linux@bohmer.net
Subject: Re: gtod/clocksource/clockevents documentation
Date: Sun, 22 Apr 2007 11:13:21 -0700
User-Agent: KMail/1.9.6
Cc: "Ingo Molnar" <mingo@elte.hu>, "Thomas Gleixner" <tglx@linutronix.de>,
       linux-kernel@vger.kernel.org
References: <3efb10970704211414q7c66c154m79cc06db61eb76be@mail.gmail.com> <200704211600.02278.david-b@pacbell.net> <3efb10970704220900m53874769ta8f540098ea7d9de@mail.gmail.com>
In-Reply-To: <3efb10970704220900m53874769ta8f540098ea7d9de@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200704221113.21778.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 22 April 2007, Remy Bohmer wrote:
> Hello David,
> 
> Thanks for this patch you sent me. This patch will also increase the
> clock resolution which is good in RT context.

Yeah, a 32768 Hz timer (battery backed) may leave a bit to be desired.


> But, unfortunately, I have some problems with compiling the kernel, as
> this patch does not enable CONFIG_GENERIC_TIME, while the patch you
> published earlier did.

I'm not sure which patch you mean.  I tested only in conjunction with
updates specific to the at91rm9200.


> Is there a special reason why you removed that?

My config didn't need it ... and ISTR that making a system support
it was more than just adding a "select GENERIC_TIME" after

> > +config AT91_TC_CLOCKSOURCE

Like the various arch/arm/kernel/* changes needed.  ISTR
there are several still in Russell's patch queue.

But basically, because I couldn't test such an at91sam926x
configuration.  That would be one of the "tweaks" that I
mentioned you would need to do.

- Dave

