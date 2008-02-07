Return-Path: <linux-kernel-owner+w=401wt.eu-S932599AbYBGTUx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932599AbYBGTUx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2008 14:20:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753627AbYBGTUl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Feb 2008 14:20:41 -0500
Received: from phunq.net ([64.81.85.152]:56022 "EHLO moonbase.phunq.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752750AbYBGTUk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2008 14:20:40 -0500
From: Daniel Phillips <phillips@phunq.net>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [git pull] x86 arch updates for v2.6.25
Date: Thu, 7 Feb 2008 11:20:26 -0800
User-Agent: KMail/1.9.5
Cc: Maxim Levitsky <maximlevitsky@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>
References: <20080130011550.GA31853@elte.hu> <200802050436.31070.maximlevitsky@gmail.com> <alpine.LFD.1.00.0802041922300.3237@woody.linux-foundation.org>
In-Reply-To: <alpine.LFD.1.00.0802041922300.3237@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200802071120.27395.phillips@phunq.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 04 February 2008 19:27, Linus Torvalds wrote:
> On Tue, 5 Feb 2008, Maxim Levitsky wrote:
> > The x86 tree was merged several times, but I don't see kgdb
> > included in latest mainline -git.
> >
> > So just one question, will it be included or no?
>
> I won't even consider pulling it unless it's offered as a separate
> tree, not mixed up with other things. At that point I can give a
> look.
>
> That said, I explained to Ingo why I'm not particularly interested in
> it. I don't think that "developer-centric" debugging is really even
> remotely our problem, and that I'm personally a lot more interested
> in infrastructure that helps normal users give better bug-reports.
> And kgdb isn't even _remotely_ it.
>
> So I'd merge a patch that puts oops information (or the whole console
> printout) in the Intel management stuff in a heartbeat. That code is
> likely much grottier than any kgdb thing will ever be (Intel really
> screwed up the interface and made it some insane XML thing), but it's
> also fundamentally more important - if it means that normal users can
> give oops reports after they happened in X (or, these days, probably
> more commonly during suspend/resume) and the machine just died.
>
> kgdb? Not so interesting. We have many more hard problems happening
> at user sites, not in developer hands.

Hi Linus,

If you listen carefully you can hear dozens of Linux kernel developers 
collectively holding their breath and thinking "Maybe Linus will 
finally merge kgdb".  Yes, user bug reports are important.  Developer 
efficiency is important too.

Regards,

Daniel
