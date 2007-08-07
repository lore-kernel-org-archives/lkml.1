Return-Path: <linux-kernel-owner+w=401wt.eu-S1765688AbXHGN5t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765688AbXHGN5t (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2007 09:57:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755293AbXHGN5l
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Aug 2007 09:57:41 -0400
Received: from mx1.suse.de ([195.135.220.2]:39589 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753881AbXHGN5k (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2007 09:57:40 -0400
Date: Tue, 7 Aug 2007 15:57:39 +0200 (CEST)
From: Michael Matz <matz@suse.de>
To: Mike Frysinger <vapier.adi@gmail.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Olaf Hering <olh@suse.de>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] remove strict ansi check from __u64 in asm/types.h
In-Reply-To: <8bd0f97a0708061713y75651621u8b2e57b1be5a61c8@mail.gmail.com>
Message-ID: <Pine.LNX.4.64.0708071556000.23011@wotan.suse.de>
References: <20070806172331.GA8102@suse.de> <46B75D3B.6080101@zytor.com>
 <8bd0f97a0708061713y75651621u8b2e57b1be5a61c8@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Mon, 6 Aug 2007, Mike Frysinger wrote:

> On 8/6/07, H. Peter Anvin <hpa@zytor.com> wrote:
> > Olaf Hering wrote:
> > >
> > > Remove the __STRICT_ANSI__ check from the __u64/__s64 declaration on
> > > 32bit targets.
> > >
> > > Here is the reason why we think the check should be relaxed:
> >
> > I think the fact that "long long" was made official C in C99 is good
> > enough.  Flagging them as __extension__ is okay, I guess, but something
> > like this should definitely go in.
> 
> the patch we (Gentoo) tried posting a while ago never saw any response:
> http://sources.gentoo.org/viewcvs.py/*checkout*/gentoo/src/patchsets/gentoo-headers/2.6.22/35_all_c99-types.patch?rev=1.2

That would still make it not work with programs compiled with just -ansi 
or -std=c90 (both being equivalent) with -pedantic added.  There still are 
such.  Only for that case is the __extension__ prefix necessary.


Ciao,
Michael.
