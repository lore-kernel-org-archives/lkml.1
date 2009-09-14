Return-Path: <linux-kernel-owner+w=401wt.eu-S933265AbZINTVI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933265AbZINTVI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Sep 2009 15:21:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754908AbZINTVH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Sep 2009 15:21:07 -0400
Received: from mail-yx0-f171.google.com ([209.85.210.171]:33619 "EHLO
	mail-yx0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754891AbZINTVG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Sep 2009 15:21:06 -0400
X-Greylist: delayed 393 seconds by postgrey-1.27 at vger.kernel.org; Mon, 14 Sep 2009 15:21:06 EDT
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=Pl1IOC4a91J09sZKD7v0l/YfFveJDgws9DerndJ/h06OWUaTDNjbFJ6UX2QRYH1KXC
         8spBrUlzhuTwVwRhgeTPmBn1yacn5ork9gRsNtSgigLAoNVOa0bw3H3sShZ42/IoOoty
         et8OPldBi48QupVwDgG7ihamOCU3BQuhFhqPs=
MIME-Version: 1.0
In-Reply-To: <1252942335.12986.58.camel@marge.simson.net>
References: <20090906205952.GA6516@elte.hu> <4AAE10E6.2050403@arcor.de>
	 <1252928133.22740.37.camel@marge.simson.net>
	 <f42384a10909140727k463ff460q3859892dcb79bcc5@mail.gmail.com>
	 <1252942335.12986.58.camel@marge.simson.net>
Date: Mon, 14 Sep 2009 21:14:35 +0200
Message-ID: <f42384a10909141214w1b3e7719j1a82363f7cb6fd3e@mail.gmail.com>
Subject: Re: Phoronix CFS vs BFS bencharks
From: Marcin Letyns <mletyns@gmail.com>
To: Mike Galbraith <efault@gmx.de>
Cc: Nikos Chantziaras <realnc@arcor.de>, Ingo Molnar <mingo@elte.hu>,
       Con Kolivas <kernel@kolivas.org>, linux-kernel@vger.kernel.org,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/9/14 Mike Galbraith <efault@gmx.de>
>
> On Mon, 2009-09-14 at 16:27 +0200, Marcin Letyns wrote:
> > Hello,
> >
> > Disabling NEW_FAIR_SLEEPERS makes a lot of difference here in the
> > Apache benchmark:
> >
> > 2.6.30.6-bfs: 7311.05
> >
> > 2.6.30.6-cfs-fair_sl_disabled: 8249.17
> >
> > 2.6.30.6-cfs-fair_sl_enabled: 4894.99
>
> Wow.
>
> Some loads like wakeup preemption (mysql+oltp), and some hate it.  This
> load appears to REALLY hate it (as does volanomark, but that thing is
> extremely overloaded).  How many threads does that benchmark run
> concurrently?

>From the benchmark description:

This is a test of ab, which is the Apache Benchmark program. This test
profile measures how many requests per second a given system can
sustain when carrying out 500,000 requests with 100 requests being
carried out concurrently.
