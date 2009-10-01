Return-Path: <linux-kernel-owner+w=401wt.eu-S1753273AbZJAGVw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753273AbZJAGVw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Oct 2009 02:21:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752104AbZJAGVw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Oct 2009 02:21:52 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:62929 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751956AbZJAGVv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Oct 2009 02:21:51 -0400
Subject: Re: Possible bug in ftrace_profile_enable_event
From: Steven Rostedt <rostedt@goodmis.org>
To: Paul Mackerras <paulus@samba.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org
In-Reply-To: <19140.13582.223629.56214@cargo.ozlabs.ibm.com>
References: <19140.13582.223629.56214@cargo.ozlabs.ibm.com>
Content-Type: text/plain
Date: Thu, 01 Oct 2009 02:20:35 -0400
Message-Id: <1254378035.2194.37.camel@frodo>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 (2.26.3-1.fc11) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-10-01 at 14:50 +1000, Paul Mackerras wrote:

> So we only allocate trace_profile_buf and trace_profile_buf_nmi if
> total_profile_count was zero on entry, but if we get an error returned
> from event->profile_enable(), we free them both unconditionally,
> regardless of the value of total_profile_count.  That seems wrong.  Is
> there a subtle reason why that is the right thing to do?
> 
> (Also, is kfree the appropriate counterpart to alloc_percpu?)

Hi Paul,

I think you have a valid point. Frederic and I are here in Dresden (last
day). I'll make sure he sees this.

Thanks,

-- Steve


