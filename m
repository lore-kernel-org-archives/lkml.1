Return-Path: <linux-kernel-owner+w=401wt.eu-S1754115AbZG0Xpt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754115AbZG0Xpt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jul 2009 19:45:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752173AbZG0Xps
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Jul 2009 19:45:48 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:59761 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752127AbZG0Xps (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jul 2009 19:45:48 -0400
Date: Mon, 27 Jul 2009 19:45:46 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Paul Mundt <lethal@linux-sh.org>
cc: Matt Fleming <matt@console-pimps.org>, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH -tip] ftrace: Correctly calculate the first function in
 the .text section
In-Reply-To: <20090727222935.GA22208@linux-sh.org>
Message-ID: <alpine.DEB.2.00.0907271941360.30108@gandalf.stny.rr.com>
References: <1248342703-15758-1-git-send-email-matt@console-pimps.org> <alpine.DEB.2.00.0907231043330.20997@gandalf.stny.rr.com> <alpine.DEB.2.00.0907231052010.20997@gandalf.stny.rr.com> <20090727222935.GA22208@linux-sh.org>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Tue, 28 Jul 2009, Paul Mundt wrote:

> On Thu, Jul 23, 2009 at 10:52:47AM -0400, Steven Rostedt wrote:
> > 
> > On Thu, 23 Jul 2009, Steven Rostedt wrote:
> > > 
> > > > 
> > > > 	if (!defined($ref_func) || !defined($weak{$text})) {
> > > > to
> > > > 	if (!defined($ref_func) && !defined($weak{$text})) {
> > > > 
> > > > This now matches the comment above the conditional.
> > > 
> > > This is the true bug. But the previous is not.
> > 
> > Could you resend the patch with this fix only. Then I can send it out as 
> > an ugent fix.
> > 
> Is anything happening with these patches? Without them, a lot of SH
> configurations are completely broken.

Thomas,

Could you push these off to Linus? My git pull request had:

Message-ID: <20090723210047.294710482@goodmis.org>

Thanks,

-- Steve

