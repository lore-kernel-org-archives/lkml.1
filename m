Return-Path: <linux-kernel-owner+w=401wt.eu-S1752296AbZHBIQK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752296AbZHBIQK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Aug 2009 04:16:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752265AbZHBIQJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Aug 2009 04:16:09 -0400
Received: from 124x34x33x190.ap124.ftth.ucom.ne.jp ([124.34.33.190]:38339 "EHLO
	master.linux-sh.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752228AbZHBIQE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Aug 2009 04:16:04 -0400
Date: Sun, 2 Aug 2009 17:16:02 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Matt Fleming <matt@console-pimps.org>, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH -tip] ftrace: Correctly calculate the first function in the .text section
Message-ID: <20090802081602.GB5011@linux-sh.org>
Mail-Followup-To: Paul Mundt <lethal@linux-sh.org>,
	Steven Rostedt <rostedt@goodmis.org>,
	Matt Fleming <matt@console-pimps.org>, Ingo Molnar <mingo@elte.hu>,
	LKML <linux-kernel@vger.kernel.org>,
	Thomas Gleixner <tglx@linutronix.de>
References: <1248342703-15758-1-git-send-email-matt@console-pimps.org> <alpine.DEB.2.00.0907231043330.20997@gandalf.stny.rr.com> <alpine.DEB.2.00.0907231052010.20997@gandalf.stny.rr.com> <20090727222935.GA22208@linux-sh.org> <alpine.DEB.2.00.0907271941360.30108@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.0907271941360.30108@gandalf.stny.rr.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 27, 2009 at 07:45:46PM -0400, Steven Rostedt wrote:
> 
> On Tue, 28 Jul 2009, Paul Mundt wrote:
> 
> > On Thu, Jul 23, 2009 at 10:52:47AM -0400, Steven Rostedt wrote:
> > > 
> > > On Thu, 23 Jul 2009, Steven Rostedt wrote:
> > > > 
> > > > > 
> > > > > 	if (!defined($ref_func) || !defined($weak{$text})) {
> > > > > to
> > > > > 	if (!defined($ref_func) && !defined($weak{$text})) {
> > > > > 
> > > > > This now matches the comment above the conditional.
> > > > 
> > > > This is the true bug. But the previous is not.
> > > 
> > > Could you resend the patch with this fix only. Then I can send it out as 
> > > an ugent fix.
> > > 
> > Is anything happening with these patches? Without them, a lot of SH
> > configurations are completely broken.
> 
> Thomas,
> 
> Could you push these off to Linus? My git pull request had:
> 
> Message-ID: <20090723210047.294710482@goodmis.org>
> 
This is still outstanding. Should I just merge it in to my tree and send
it to Linus instead?
