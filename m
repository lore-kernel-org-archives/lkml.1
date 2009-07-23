Return-Path: <linux-kernel-owner+w=401wt.eu-S1753731AbZGWOws@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753731AbZGWOws (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jul 2009 10:52:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752701AbZGWOws
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Jul 2009 10:52:48 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:32802 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752168AbZGWOwr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jul 2009 10:52:47 -0400
Date: Thu, 23 Jul 2009 10:52:47 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Matt Fleming <matt@console-pimps.org>
cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH -tip] ftrace: Correctly calculate the first function in
 the .text section
In-Reply-To: <alpine.DEB.2.00.0907231043330.20997@gandalf.stny.rr.com>
Message-ID: <alpine.DEB.2.00.0907231052010.20997@gandalf.stny.rr.com>
References: <1248342703-15758-1-git-send-email-matt@console-pimps.org> <alpine.DEB.2.00.0907231043330.20997@gandalf.stny.rr.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Thu, 23 Jul 2009, Steven Rostedt wrote:
> 
> > 
> > 	if (!defined($ref_func) || !defined($weak{$text})) {
> > to
> > 	if (!defined($ref_func) && !defined($weak{$text})) {
> > 
> > This now matches the comment above the conditional.
> 
> This is the true bug. But the previous is not.

Could you resend the patch with this fix only. Then I can send it out as 
an ugent fix.

Thanks!

-- Steve
