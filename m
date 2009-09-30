Return-Path: <linux-kernel-owner+w=401wt.eu-S1753928AbZI3IEm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753928AbZI3IEm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Sep 2009 04:04:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752277AbZI3IEl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Sep 2009 04:04:41 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:38654 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751120AbZI3IEk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Sep 2009 04:04:40 -0400
Subject: Re: 2.6.31.1 boot crash, compiled with ftrace
From: Steven Rostedt <rostedt@goodmis.org>
To: Dick Hollenbeck <dick@softplc.com>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>
In-Reply-To: <4AC22613.4090803@softplc.com>
References: <4AC22613.4090803@softplc.com>
Content-Type: text/plain
Date: Wed, 30 Sep 2009 04:03:24 -0400
Message-Id: <1254297804.2963.14.camel@frodo>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 (2.26.3-1.fc11) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-09-29 at 10:21 -0500, Dick Hollenbeck wrote:
> Please help with a kernel boot crash.  This is happening with ftrace 
> enabled.   (I have yet to try without ftrace.)  This same box runs 
> kernel 2.6.26 fine.
> 
> While running 'make oldconfig' coming up from 2.6.26, the three most 
> significant changes were:
> 
> 1) changed CPU from 486 to Pentium-Classic
> 
> 2) Added "High Memory Support" 4 GB
> 
> 3) Enabled various ftrace options, because I am on the hunt for some 
> insane latency problems.
> 

Hi Dick,

Thanks for reporting this. Peter and I have been taking some look at it.
We are not sure that it is ftrace related. have you tried booting the
kernel without adding ftrace?

Thanks,

-- Steve


