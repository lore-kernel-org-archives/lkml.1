Return-Path: <linux-kernel-owner+w=401wt.eu-S1756055AbYEaWdA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756055AbYEaWdA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 May 2008 18:33:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754509AbYEaWcv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 31 May 2008 18:32:51 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46782 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754381AbYEaWcu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 May 2008 18:32:50 -0400
Date: Sat, 31 May 2008 15:32:01 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Ulrich Drepper <drepper@redhat.com>
cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       mtk.manpages@gmail.com
Subject: Re: [PATCH 0/3] 64-bit futexes: Intro
In-Reply-To: <alpine.LFD.1.10.0805311438080.3141@woody.linux-foundation.org>
Message-ID: <alpine.LFD.1.10.0805311530010.3141@woody.linux-foundation.org>
References: <200805310127.m4V1RLR4013808@devserv.devel.redhat.com> <alpine.LFD.1.10.0805301846530.3141@woody.linux-foundation.org> <4840C29B.6030507@redhat.com> <alpine.LFD.1.10.0805302044310.3141@woody.linux-foundation.org> <4840CE51.9060109@redhat.com>
 <alpine.LFD.1.10.0805302109370.3141@woody.linux-foundation.org> <alpine.LFD.1.10.0805302116440.3141@woody.linux-foundation.org> <4840D63F.2090407@redhat.com> <alpine.LFD.1.10.0805311438080.3141@woody.linux-foundation.org>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Sat, 31 May 2008, Linus Torvalds wrote:
>
> 	 * Note that we don't need to update the high bits if we
> 	 * succeed (because the writer count is the _pending_ writer
> 	 * count, not the holding one)

Btw, that comment is bogus, ignore it. It comes from an earlier algorithm 
I tried that also explained the contention case, but got unnecessarily 
complex. Separating out the queuing behaviour from the actual 
non-contended behaviour made things much simpler to explain, so I stopped 
even bothering with a "both" case.

Too much cut-and-paste, IOW.

		Linus
