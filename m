Return-Path: <linux-kernel-owner+w=401wt.eu-S1758495AbXIBVNn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758495AbXIBVNn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Sep 2007 17:13:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752078AbXIBVNe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Sep 2007 17:13:34 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:35705 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750928AbXIBVNd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Sep 2007 17:13:33 -0400
Date: Mon, 3 Sep 2007 02:56:39 +0530 (IST)
From: Satyam Sharma <satyam@infradead.org>
X-X-Sender: satyam@enigma.security.iitk.ac.in
To: Alessandro Suardi <alessandro.suardi@gmail.com>
cc: charles gagalac <charles.gagalac@gmail.com>,
       daryll q <daryll_26m@yahoo.com.ph>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew <andrew@nelless.net>
Subject: Re: Hang in 2.6.23-rc5
In-Reply-To: <5a4c581d0709021338s1e9e0dc0md490a032781b60e8@mail.gmail.com>
Message-ID: <alpine.LFD.0.999.0709030242060.29617@enigma.security.iitk.ac.in>
References: <994260.18490.qm@web57301.mail.re1.yahoo.com> 
 <6cf66ee10709021205u7d57b93fv777f414dbba4373f@mail.gmail.com>
 <5a4c581d0709021338s1e9e0dc0md490a032781b60e8@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Sun, 2 Sep 2007, Alessandro Suardi wrote:
> 
> On 9/2/07, charles gagalac <charles.gagalac@gmail.com> wrote:
> > On 9/2/07, daryll q wrote:
> > > Upgraded my kernel from 2.6.23-rc2 to 2.6.23-rc5.
> > >
> > >  System hangs (caps lock and scroll lock leds are both flashing).
> > >
> > >  It *randomly* happens but most of the time during after login to KDE.
> > >
> > >  I have not investigated it yet because I have not tried doing it  before.
> > >
> > >  Also the system is really not responding so I can't do much.. Just
> > >  hope it blue screen so I can send the error code easily :)
> >
> > i experienced hangs, with the flashing caps and scroll locks as you've
> > described, in a few of my later pulls prior to rc5.  i couldn't
> > reproduce the hangs and my logs didn't show evidence of a problem.  my
> > system under rc5, so far, hasn't hung on me.
> 
> Oh, I thought I was the only one. I also had a single hang+flashing
>  Caps & Scroll Lock with -rc5, but haven't had one since.

Looks like a full-blown panic to me. Didn't any of you guys manage to
catch anything in /var/log/messages? Else, please try reproducing this
with a serial console or netconsole at least. netconsole should be easy
to setup, instructions on how to use that here:

(very long URL)
http://git.kernel.org/?p=linux/kernel/git/davem/net-2.6.24.git;a=blob_plain;f=Documentation/networking/netconsole.txt;hb=HEAD
