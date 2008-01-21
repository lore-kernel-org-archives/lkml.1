Return-Path: <linux-kernel-owner+w=401wt.eu-S1752781AbYAUROa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752781AbYAUROa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2008 12:14:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751380AbYAUROW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Jan 2008 12:14:22 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:57283 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751163AbYAUROV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2008 12:14:21 -0500
Subject: Re: Known prob: MAX_LOCK_DEPTH too low?
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Linda Walsh <lkml@tlinx.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Linux-Xfs <linux-xfs@oss.sgi.com>,
       Ingo Molnar <mingo@elte.hu>
In-Reply-To: <4794C7C0.8030207@tlinx.org>
References: <47914FA7.1000807@tlinx.org> <1200918448.6341.5.camel@lappy>
	 <4794C7C0.8030207@tlinx.org>
Content-Type: text/plain
Date: Mon, 21 Jan 2008 18:13:49 +0100
Message-Id: <1200935629.6341.9.camel@lappy>
Mime-Version: 1.0
X-Mailer: Evolution 2.21.5 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Mon, 2008-01-21 at 08:26 -0800, Linda Walsh wrote:
> Peter Zijlstra wrote:
> > On Fri, 2008-01-18 at 17:17 -0800, Linda Walsh wrote:
> >   
> >> On my x86_64 machine, I got the following message
> >> in log (kern = 2.6.23.14)
> >>
> >> Jan 16 04:08:38 Astara kernel: BUG: MAX_LOCK_DEPTH too low!
> >> Jan 16 04:08:38 Astara kernel: turning off the locking correctness 
> >> validator.
> >>
> >> Have no idea what caused it as I found the message on my console
> >> somewhat after the fact.  The system had been up over 24 hours and
> >> is still running.  System still seems 'fine' (been up 3 days now),
> >> so you can treat this as a "data point".
> >>     
> >
> > Are you perhaps an XFS user?
> >
> >   
> ----
>     Funny you should mention that...  yes.  However, there were no
> other messages that seem to indicate that the message had anything
> to do with XFS.  Nice shot in the dark.

:-), know issue, I guess I'll up the MAX_LOCK_DEPTH for the next
release. I looked at dynamically allocating that stuff, but that gets
awfully painful.


