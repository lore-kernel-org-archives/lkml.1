Return-Path: <linux-kernel-owner+w=401wt.eu-S1765770AbYBZWCQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765770AbYBZWCQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2008 17:02:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763288AbYBZWB5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Feb 2008 17:01:57 -0500
Received: from styx.suse.cz ([82.119.242.94]:52199 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1763275AbYBZWB4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2008 17:01:56 -0500
Date: Tue, 26 Feb 2008 23:01:55 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: Lennart Sorensen <lsorense@csclub.uwaterloo.ca>
cc: Chris Holvenstot <cholvenstot@comcast.net>, elendil@planet.nl,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
       Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [2.6.25-rc1] jerky mouse cursor and randoooom key repeats
In-Reply-To: <20080226215812.GX1287@csclub.uwaterloo.ca>
Message-ID: <Pine.LNX.4.64.0802262300000.30955@jikos.suse.cz>
References: <1203123219.6176.36.camel@popeye> <Pine.LNX.4.64.0802161202430.7699@twin.jikos.cz>
 <1203163503.6124.5.camel@popeye> <Pine.LNX.4.64.0802161907200.30955@jikos.suse.cz>
 <1203221372.6124.29.camel@popeye> <Pine.LNX.4.64.0802211036580.30955@jikos.suse.cz>
 <1203587101.27355.4.camel@popeye> <20080226145832.GA1289@csclub.uwaterloo.ca>
 <Pine.LNX.4.64.0802261602030.30955@jikos.suse.cz> <20080226215812.GX1287@csclub.uwaterloo.ca>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 26 Feb 2008, Lennart Sorensen wrote:

> > This could be caused by the fact that as far as I know, X are not using 
> > kernel-autorepeat, but they are handling it themselves, right? So if their 
> > sense of time (probably due to some change of kernel timekeeping) gets 
> > wrong, the autorepeat in X might also get wrong.
> > It would be nice to know if when you hit the situation when autorepeat 
> > goes strange in X, if it is still OK in console.
> Yes console is always fine.

OK, so what very probably happened is that CONFIG_GROUP_SCHED somehow 
schedules X server in a way which confuses its sense of time, and 
therefore makes autorepeat buggy ... ?

-- 
Jiri Kosina
SUSE Labs
