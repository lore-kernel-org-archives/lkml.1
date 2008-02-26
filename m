Return-Path: <linux-kernel-owner+w=401wt.eu-S1754951AbYBZPFq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754951AbYBZPFq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2008 10:05:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752114AbYBZPFi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Feb 2008 10:05:38 -0500
Received: from styx.suse.cz ([82.119.242.94]:39551 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751872AbYBZPFh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2008 10:05:37 -0500
Date: Tue, 26 Feb 2008 16:05:36 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: Lennart Sorensen <lsorense@csclub.uwaterloo.ca>
cc: Chris Holvenstot <cholvenstot@comcast.net>, elendil@planet.nl,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
       Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [2.6.25-rc1] jerky mouse cursor and randoooom key repeats
In-Reply-To: <20080226145832.GA1289@csclub.uwaterloo.ca>
Message-ID: <Pine.LNX.4.64.0802261602030.30955@jikos.suse.cz>
References: <1203123219.6176.36.camel@popeye> <Pine.LNX.4.64.0802161202430.7699@twin.jikos.cz>
 <1203163503.6124.5.camel@popeye> <Pine.LNX.4.64.0802161907200.30955@jikos.suse.cz>
 <1203221372.6124.29.camel@popeye> <Pine.LNX.4.64.0802211036580.30955@jikos.suse.cz>
 <1203587101.27355.4.camel@popeye> <20080226145832.GA1289@csclub.uwaterloo.ca>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 26 Feb 2008, Lennart Sorensen wrote:

> Hmm, I have been seeing repeated keys a lot under X on my athlon 700, 
> but mainly when I have firefox running (which is of course quite a load 
> on the poor old thing).  This has been going on for probably the last 
> year or so.  I thought it was just the machine getting weird, although 
> whenever it wasn't running firefox or other memory/cpu heavy loads it 
> seemed fine.

This could be caused by the fact that as far as I know, X are not using 
kernel-autorepeat, but they are handling it themselves, right? So if their 
sense of time (probably due to some change of kernel timekeeping) gets 
wrong, the autorepeat in X might also get wrong.

It would be nice to know if when you hit the situation when autorepeat 
goes strange in X, if it is still OK in console.

-- 
Jiri Kosina
SUSE Labs
