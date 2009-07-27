Return-Path: <linux-kernel-owner+w=401wt.eu-S1755401AbZG0W3i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755401AbZG0W3i (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jul 2009 18:29:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755045AbZG0W3h
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Jul 2009 18:29:37 -0400
Received: from 124x34x33x190.ap124.ftth.ucom.ne.jp ([124.34.33.190]:52324 "EHLO
	master.linux-sh.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755017AbZG0W3g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jul 2009 18:29:36 -0400
Date: Tue, 28 Jul 2009 07:29:35 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Matt Fleming <matt@console-pimps.org>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH -tip] ftrace: Correctly calculate the first function in the .text section
Message-ID: <20090727222935.GA22208@linux-sh.org>
Mail-Followup-To: Paul Mundt <lethal@linux-sh.org>,
	Steven Rostedt <rostedt@goodmis.org>,
	Matt Fleming <matt@console-pimps.org>, Ingo Molnar <mingo@elte.hu>,
	linux-kernel@vger.kernel.org
References: <1248342703-15758-1-git-send-email-matt@console-pimps.org> <alpine.DEB.2.00.0907231043330.20997@gandalf.stny.rr.com> <alpine.DEB.2.00.0907231052010.20997@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.0907231052010.20997@gandalf.stny.rr.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 23, 2009 at 10:52:47AM -0400, Steven Rostedt wrote:
> 
> On Thu, 23 Jul 2009, Steven Rostedt wrote:
> > 
> > > 
> > > 	if (!defined($ref_func) || !defined($weak{$text})) {
> > > to
> > > 	if (!defined($ref_func) && !defined($weak{$text})) {
> > > 
> > > This now matches the comment above the conditional.
> > 
> > This is the true bug. But the previous is not.
> 
> Could you resend the patch with this fix only. Then I can send it out as 
> an ugent fix.
> 
Is anything happening with these patches? Without them, a lot of SH
configurations are completely broken.
