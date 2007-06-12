Return-Path: <linux-kernel-owner+w=401wt.eu-S1756021AbXFLIvx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756021AbXFLIvx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jun 2007 04:51:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753657AbXFLIvq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Jun 2007 04:51:46 -0400
Received: from an-out-0708.google.com ([209.85.132.249]:55189 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753086AbXFLIvp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jun 2007 04:51:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=tNIR2u5nCb48LyaasNVijWo0sWJFhiA3InlEqQGZRXraZjm9xOnAJbp8Ss2D/hFdmrE5hBf8ksvxeHWvyFacsueaXDX5WCeutQEsF9WrKKC+BxUy9i5pCc9e+VIrc1S6l8QEU6xRxmZPvKa9h6kUw9TycH6OuoULvjn74ZDrUuU=
Message-ID: <ea7e82ce0706120151q6c69ec65rbf21dc209255d040@mail.gmail.com>
Date: Tue, 12 Jun 2007 20:51:45 +1200
From: "Tobias Gerschner" <tobias.gerschner@gmail.com>
To: "Ingo Molnar" <mingo@elte.hu>
Subject: Re: call for more SD versus CFS comparisons (was: Re: [ck] Mainline plans)
Cc: "Miguel Figueiredo" <elmig@debianpt.org>,
       "linux kernel mailing list" <linux-kernel@vger.kernel.org>,
       ck@vds.kolivas.org
In-Reply-To: <20070612083620.GA10557@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <466DE921.9030709@debianpt.org>
	 <ea7e82ce0706120039n675a361emc214b2ecca964b75@mail.gmail.com>
	 <20070612083620.GA10557@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

2007/6/12, Ingo Molnar <mingo@elte.hu>:
>
> * Tobias Gerschner <tobias.gerschner@gmail.com> wrote:
>
> > I did run massive_intr.c for 60 secs with increasing nproc (
> > 10,20,30,40,50,60) waiting for effects.
> >
> > Below a small table of the results
> >
> > 2.6.21.1-cfs-v16
> >
> > nproc ,  usability result
> >
> > 10 , serious frame drops , Firefox  hardly recognizes clicked links,
> > but still usable
> > 20 - 30, usability loss ( somehow under cfs firefox never finished
> > user requests like displaying web pages or opening new pages , no
> > feedback anymore, sudden changes on the desktop )
>
> ouch! The expected load-testing result under CFS should be something
> like this:
>
>    http://bhhdoa.org.au/pipermail/ck/2007-June/007817.html
>
> could you send me the output of /proc/sched_debug? (while say a
> "massive_intr 20" is running?)
>
> Roughly what hardware do you have? (could you send me your lspci -v
> output and dmesg output?)
>
>         Ingo
>

Hi,

it's a peacock freeliner xp II. Close to 5 year old Laptop with an
Athlon XP 2600+ using 1 GB of RAM / no swap enabled.

The other information will be sent as soon as I am back at work .

regards

-- 
Tobias Gerschner
Member of Board of Yoper Linux Ltd. NZ

Knowing is not enough; we must apply. Willing is not enough; we must do.
