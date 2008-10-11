Return-Path: <linux-kernel-owner+w=401wt.eu-S1755979AbYJKDoi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755979AbYJKDoi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Oct 2008 23:44:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751849AbYJKDoa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Oct 2008 23:44:30 -0400
Received: from smtp107.mail.mud.yahoo.com ([209.191.85.217]:45939 "HELO
	smtp107.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751788AbYJKDoa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Oct 2008 23:44:30 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=GdCu6YSt2EONBgYoLAVQRPxdtLuVWZl9MBRRaIHl4ybge2txnfmAHWYAkG1iZz76OkLHghzG7PUF1SwvbABaNG3AcNwhDdFOqhumdTKwbkZMTSvrhpyhD+DlURu/iMBXU7WntMTBhsqqms4YEbc0Ia5O+D1T26dXGFZRFg/DerY=  ;
X-YMail-OSG: LPVOQtEVM1mlwZcSXPWuaD6gsjlOHBCMgILEuygnDiEoBpotVRG9q5Kth5ktuqI_mrE2Ob2OjLk7gn3euy4QKS49clBoPC4TjOa1jYhxYYaxTBCP4BIPpZ_VKOUdak6xiGxFOaL.VexR.yX1fyDOOB3w7nmNN2sTXLp1rTYrII0TuoHVKKMyw40gtuy9
X-Yahoo-Newman-Property: ymail-3
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Ingo Molnar <mingo@elte.hu>
Subject: Re: [git pull] x86 updates for v2.6.28, phase #6, misc
Date: Sat, 11 Oct 2008 14:44:16 +1100
User-Agent: KMail/1.9.5
Cc: Jeremy Fitzhardinge <jeremy@goop.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>
References: <20081010000817.GA9266@elte.hu> <48EED78F.9040608@goop.org> <20081010082612.GA25959@elte.hu>
In-Reply-To: <20081010082612.GA25959@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200810111444.16804.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 10 October 2008 19:26, Ingo Molnar wrote:
> * Jeremy Fitzhardinge <jeremy@goop.org> wrote:
> > Nick Piggin wrote:
> >> On Friday 10 October 2008 11:08, Ingo Molnar wrote:
> >>> out-of-topic modifications in x86-v28-for-linus-phase6:
> >>> -------------------------------------------------------
> >>> include/linux/kernel.h             # d974ae3: generic, memparse():
> >>> constify arg include/linux/mm.h                 # f7d0b92: mm: define
> >>> USE_SPLIT_PTLOCKS rath # 59ea746: MM: virtual address debug
> >>> include/linux/mm_types.h           # f7d0b92: mm: define
> >>> USE_SPLIT_PTLOCKS rath include/linux/mmdebug.h            # 7aa413d:
> >>> x86, MM: virtual address debug, c # 59ea746: MM: virtual address debug
> >>> lib/cmdline.c
> >>>           # d974ae3: generic, memparse(): constify arg mm/vmalloc.c
> >>>                    # 7aa413d: x86, MM: virtual address debug, c #
> >>> 59ea746: MM:
> >>> virtual address debug
> >>
> >> How come these kinds of things go into the x86 tree? Can't they
> >> be sent to other maintainer first (probably Andrew, in the case
> >> of random -mm stuff).
> >>
> >> OK, it's pretty trivial stuff, but just on principle I can't see
> >> an advantage, and only disadvantages to doing this (and also I
> >> see the vmalloc change clashed with the vmalloc rewrite in -mm).
> >
> > The memparse and split ptlocks changes went past Andrew.  They ended
> > up in Ingo's tree because 1) they're pretty trivial, and 2) there's
> > x86-specific stuff which depends on them.  Don't know about the
> > vmalloc change.
>
> yeah, correct, as Jeremy already noted they had dependencies with PAT
> and other ioremap relevant changes in the x86 tree so it had to be
> layered.

OK fair enough. I thought the virtual address debug stuff was a
bit more significant touching common code.
