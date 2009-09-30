Return-Path: <linux-kernel-owner+w=401wt.eu-S1754020AbZI3JKg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754020AbZI3JKg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Sep 2009 05:10:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752658AbZI3JKg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Sep 2009 05:10:36 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:44418 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752153AbZI3JKf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Sep 2009 05:10:35 -0400
Subject: Re: 2.6.31.1 boot crash, compiled with ftrace
From: Steven Rostedt <rostedt@goodmis.org>
To: Dick Hollenbeck <dick@softplc.com>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>
In-Reply-To: <1254297804.2963.14.camel@frodo>
References: <4AC22613.4090803@softplc.com>  <1254297804.2963.14.camel@frodo>
Content-Type: text/plain
Date: Wed, 30 Sep 2009 05:09:21 -0400
Message-Id: <1254301761.7286.4.camel@frodo>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 (2.26.3-1.fc11) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-09-30 at 04:03 -0400, Steven Rostedt wrote:
> On Tue, 2009-09-29 at 10:21 -0500, Dick Hollenbeck wrote:
> > Please help with a kernel boot crash.  This is happening with ftrace 
> > enabled.   (I have yet to try without ftrace.)  This same box runs 
> > kernel 2.6.26 fine.
> > 
> > While running 'make oldconfig' coming up from 2.6.26, the three most 
> > significant changes were:
> > 
> > 1) changed CPU from 486 to Pentium-Classic
> > 
> > 2) Added "High Memory Support" 4 GB
> > 
> > 3) Enabled various ftrace options, because I am on the hunt for some 
> > insane latency problems.
> > 
> 
> Hi Dick,
> 
> Thanks for reporting this. Peter and I have been taking some look at it.
> We are not sure that it is ftrace related. have you tried booting the
> kernel without adding ftrace?

Hi,

I just booted your config a couple of times without any issues. How
reproducible is this?

Thanks,

-- Steve

