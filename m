Return-Path: <linux-kernel-owner+w=401wt.eu-S1754934AbYAZFMN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754934AbYAZFMN (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jan 2008 00:12:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751553AbYAZFL6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Jan 2008 00:11:58 -0500
Received: from ms-smtp-01.nyroc.rr.com ([24.24.2.55]:46149 "EHLO
	ms-smtp-01.nyroc.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750728AbYAZFL5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jan 2008 00:11:57 -0500
Date: Sat, 26 Jan 2008 00:11:23 -0500 (EST)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: LKML <linux-kernel@vger.kernel.org>, RT <linux-rt-users@vger.kernel.org>
cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: 2.6.24-rt1
In-Reply-To: <1201299433.318.21.camel@localhost.localdomain>
Message-ID: <Pine.LNX.4.58.0801260008510.22141@gandalf.stny.rr.com>
References: <1201299433.318.21.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Fri, 25 Jan 2008, Steven Rostedt wrote:
>
> *** NOTICE ***
>
> This still has the old version of the latency tracer. I'll try to
> release a -rt2 soon that has the new version. This way we can see what
> kind of regressions the new version might give.
>

This is taking longer than expected. Removing the old latency tracer has
caused a bit to be broken. The latency tracer has been in the RT kernel
for so long that it has hooks in lots of unrelated patches. It's taking a
bit of surgury to remove all the bits without killing the rest.

I will not be working on this over the weekend. I'll start back up on
Monday.

-- Steve

