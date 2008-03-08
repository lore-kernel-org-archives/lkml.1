Return-Path: <linux-kernel-owner+w=401wt.eu-S1757426AbYCHUXQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757426AbYCHUXQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Mar 2008 15:23:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751336AbYCHUXE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 8 Mar 2008 15:23:04 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38887 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752397AbYCHUXD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Mar 2008 15:23:03 -0500
Date: Sat, 8 Mar 2008 12:22:32 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Anders Eriksson <aeriksson@fastmail.fm>
cc: Jens Axboe <jens.axboe@oracle.com>,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: Linux 2.6.25-rc4 
In-Reply-To: <20080307220432.D47E02DC047@tippex.mynet.homeunix.org>
Message-ID: <alpine.LFD.1.00.0803081217250.2911@woody.linux-foundation.org>
References: <alpine.LFD.1.00.0803042044460.12253@woody.linux-foundation.org> <200803061438.22205.bzolnier@gmail.com> <20080306133347.GA23495@elte.hu> <200803061506.19449.bzolnier@gmail.com> <20080306135532.GG17940@kernel.dk> <20080306211726.2DA8C93C881@tippex.mynet.homeunix.org>
 <20080307084818.GK17940@kernel.dk> <20080307220432.D47E02DC047@tippex.mynet.homeunix.org>
User-Agent: Alpine 1.00 (LFD 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 7 Mar 2008, Anders Eriksson wrote:
> 
> jens.axboe@oracle.com said:
> > Can you try with noop or deadline as the default, to see if it reproduces
> > with them? 
> 
> Fails in the same way using noop, deadline and cfq on -rc4

I think we do want the bisect run here.

My worry is that this is likely very timing-sensitive, so when it starts 
failing it might not be because of the commit that actually introduces the 
bug, but because some other timing changed, but with some luck that won't 
be the case.

			Linus
