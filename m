Return-Path: <linux-kernel-owner+w=401wt.eu-S1761560AbXEOHXS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761560AbXEOHXS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 May 2007 03:23:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755428AbXEOHXK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 May 2007 03:23:10 -0400
Received: from cantor2.suse.de ([195.135.220.15]:43535 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755191AbXEOHXJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 May 2007 03:23:09 -0400
From: Andi Kleen <ak@suse.de>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [Bugme-new] [Bug 8479] New: gettimeofday returning 1000000 in tv_usec on core2duo
Date: Tue, 15 May 2007 09:22:47 +0200
User-Agent: KMail/1.9.1
Cc: Eric Dumazet <dada1@cosmosbay.com>, Thomas Gleixner <tglx@linutronix.de>,
       john stultz <johnstul@us.ibm.com>, linux-kernel@vger.kernel.org,
       "bugme-daemon@kernel-bugs.osdl.org" 
	<bugme-daemon@bugzilla.kernel.org>,
       dang@gentoo.org, stable@kernel.org
References: <200705150417.l4F4HlvS013354@fire-2.osdl.org> <46494DFC.6080104@cosmosbay.com> <20070514232301.69e27bbe.akpm@linux-foundation.org>
In-Reply-To: <20070514232301.69e27bbe.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200705150922.47702.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


> >
> > I remember I already hit this and corrected it
> >
> > http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=blobdi
> >ff;f=arch/x86_64/kernel/vsyscall.c;h=dc32cef961950915fbaa185e36ab802d5f7ce
> >a3b;hp=ba330f87067996a17495f7d03466d646c718b52c;hb=c8118c6c07f2edfd697aaa0
> >b93e08c3b65a5a675;hpb=272a3713bb9e302e0455c894c41180a482d2c8a3
>
> Oh, OK.
>
> > Maybe a stable push is necessary ?
>
> yup.  Please always think of -stable when preparing fixes.  I'm sure many
> useful fixes are slipping past simply because those who _are_ looking out
> for backportable fixes are missing things.
>
> Greg, Chris: please consider c8118c6c07f2edfd697aaa0b93e08c3b65a5a675
> for -stable, if it isn't already there.

The full patch is overkill because 99% of it is an totally unrelated 
optimization. Only the > -> >= change should be backported

-Andi

