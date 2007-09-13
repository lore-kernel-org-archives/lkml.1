Return-Path: <linux-kernel-owner+w=401wt.eu-S1752481AbXIMJgb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752481AbXIMJgb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Sep 2007 05:36:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750766AbXIMJgV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Sep 2007 05:36:21 -0400
Received: from wa-out-1112.google.com ([209.85.146.180]:56001 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750836AbXIMJgU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Sep 2007 05:36:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=DjrCLPnADcXFq3YynAmSAtdkASmyy0gQn9RZK1cEqc3yDysxj64uNUNZaHLAM+Khc1l9bI0mx/9dIJ+Y5lOU/EwIL3AYKDxmUYBXK4g7H35Q2DcTL23KiXoAxxmjF658B1DsAm7oqevLeOSs3z08zWqPxQyNGFiFSI3+igwaK88=
Message-ID: <6b8cef970709130236o48e4d923ofe4ad862c749f2da@mail.gmail.com>
Date: Thu, 13 Sep 2007 05:36:18 -0400
From: "Rob Hussey" <robjhussey@gmail.com>
To: "Ingo Molnar" <mingo@elte.hu>
Subject: Re: [announce] CFS-devel, performance improvements
Cc: linux-kernel@vger.kernel.org, "Peter Zijlstra" <a.p.zijlstra@chello.nl>,
       "Mike Galbraith" <efault@gmx.de>,
       "Roman Zippel" <zippel@linux-m68k.org>
In-Reply-To: <20070913093137.GA31923@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070911200459.GA6974@elte.hu>
	 <6b8cef970709111816l2e421bf3s55e63274e87fd5e1@mail.gmail.com>
	 <6b8cef970709130142h7be591f7ja5ffd8976faef09c@mail.gmail.com>
	 <20070913090655.GA28505@elte.hu>
	 <6b8cef970709130224t2f8d28d4mdfbf22ba10b42497@mail.gmail.com>
	 <20070913093137.GA31923@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 9/13/07, Ingo Molnar <mingo@elte.hu> wrote:
>
> * Rob Hussey <robjhussey@gmail.com> wrote:
>
> > On 9/13/07, Ingo Molnar <mingo@elte.hu> wrote:
> > >
> > > thanks for the numbers! Could you please also post the .config you used?
> >
> > Sure, .config for 2.6.23-rc1 and 2.6.23-rc6 attached.
>
> thx! If you've got some time, could you perhaps re-measure with these
> disabled:
>
>   CONFIG_SCHED_DEBUG=y

Well, I was going over my config myself after you asked for me to post
it, and I thought to do the same thing. Except, disabling sched_debug
caused the same error as before:
In file included from kernel/sched.c:794:
kernel/sched_fair.c: In function 'task_new_fair':
kernel/sched_fair.c:857: error: 'sysctl_sched_child_runs_first'
undeclared (first use in this function)
kernel/sched_fair.c:857: error: (Each undeclared identifier is
reported only once
kernel/sched_fair.c:857: error: for each function it appears in.)
make[1]: *** [kernel/sched.o] Error 1
make: *** [kernel] Error 2

It only happens with sched_debug=y. I take it back, it wasn't my fault :)

As for everything else, I'd be happy to.
