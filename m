Return-Path: <linux-kernel-owner+w=401wt.eu-S1759231AbYAJM7p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759231AbYAJM7p (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2008 07:59:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754170AbYAJM7i
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jan 2008 07:59:38 -0500
Received: from wr-out-0506.google.com ([64.233.184.238]:22340 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753510AbYAJM7h convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2008 07:59:37 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=igRCW7i5rZbey/Dg0USJg5FMDda4FzCZlYGyBvrgfQaelEQWesoAHvq8v8qnmePNG1EP1zf+RQGASrh7bsK/e5EUtZM9QGhisr2HetMrDCq5P8QiQwgoLCc9O0PQRQVVbpbEsBzHLoqCg24lkGanA9CPqjA3uKGYLBDQg9mivqc=
Message-ID: <e85b9d30801100459t499bf874xab359dc9f1497845@mail.gmail.com>
Date: Thu, 10 Jan 2008 13:59:35 +0100
From: Matthew <jackdachef@gmail.com>
To: "Ingo Molnar" <mingo@elte.hu>
Subject: Re: Fwd: Fwd: laptop / computer hardlocks during execution of 32bit applications(binaries) on 64bit system (Gentoo)
Cc: "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org,
       "Thomas Gleixner" <tglx@linutronix.de>
In-Reply-To: <20080110124810.GA20579@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
References: <e85b9d30712291157v113f5e73yd830ae3c3429092d@mail.gmail.com>
	 <200712300128.35476.mboton@gmail.com> <20080102084002.GA13636@elte.hu>
	 <e85b9d30801080333y3d6668ccgf20f9666d0326884@mail.gmail.com>
	 <e85b9d30801080340y43fbd4c0sa9b6c9811c7391a1@mail.gmail.com>
	 <47841C41.4060401@zytor.com>
	 <e85b9d30801100105s60ad675ey1ba939491d01a649@mail.gmail.com>
	 <20080110094219.GC17808@elte.hu>
	 <e85b9d30801100443s50ab2b69wbf1a7b4dbd09f002@mail.gmail.com>
	 <20080110124810.GA20579@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>
> > this also happens with rc7-based kernels, btw
>
> hm, exactly what rc7 based kernel? Vanilla 2.6.24-rc7, built by you? Or
> any patches ontop of it? (x86.git perhaps?)

see first post / mail (there are a few additional patches / trees
included:  badram, wireless, alsa, tuxonice, madwifi, reiser4,
sched-devel, realtime-lsm, powertop, mactel)

>since yesterday my laptop kept on hard-locking when launching 32bit
>binaries / apps
>I didn't know what to do but

>miguel botón was the one pointing me in the right direction, namely bisect :)

>kudos to him & the others involved in his zen-sources project:
>http://repo.or.cz/w/linux-2.6/zen-sources.git

>bisect said the following is the causer:

so I guess I need to counter-check it against your realtime-tree:
is it the following ?
http://git.eu.kernel.org/?p=linux/kernel/git/cloos/rt-2.6.git;a=summary
(it's currently at rc5 ?)

or is hardirq / softirq also included in your sched-devel tree ?
http://git.eu.kernel.org/?p=linux/kernel/git/mingo/linux-2.6-sched-devel.git;a=summary

>         Ingo

Mat
