Return-Path: <linux-kernel-owner+w=401wt.eu-S1753849AbZKDEnA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753849AbZKDEnA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Nov 2009 23:43:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751282AbZKDEm7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Nov 2009 23:42:59 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:40493 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751169AbZKDEm7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Nov 2009 23:42:59 -0500
Subject: Re: [PATCH 2/3] ftrace: Return EINVAL when writing invalid val to
 set_ftrace_filter
From: Steven Rostedt <rostedt@goodmis.org>
Reply-To: rostedt@goodmis.org
To: Li Zefan <lizf@cn.fujitsu.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <4AF0EDDA.7080704@cn.fujitsu.com>
References: <4AEF7F8A.3080300@cn.fujitsu.com>
	 <4AEF7FBC.2050802@cn.fujitsu.com> <20091104014435.GB5092@nowhere>
	 <4AF0EDDA.7080704@cn.fujitsu.com>
Content-Type: text/plain
Organization: Kihon Technologies Inc.
Date: Tue, 03 Nov 2009 23:43:02 -0500
Message-Id: <1257309782.26028.3829.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-11-04 at 10:58 +0800, Li Zefan wrote:
> Frederic Weisbecker wrote:
> > On Tue, Nov 03, 2009 at 08:56:28AM +0800, Li Zefan wrote:
> >> Currently it doesn't warn user on invald value:
> >>
> >>  # echo nonexist_symbol > set_ftrace_filter
> >>
> >> Better make it return failure.
> >>
> >> Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
> >> ---
> > 
> > 
> > Acked-by: Frederic Weisbecker <fweisbec@gmail.com>
> > 
> > But shouldn't we have the same kind of check from
> > ftrace_match_module_records() if we haven't matched
> > anything with the regex?
> > 
> 
> Right, I overlooked it.
> 

Only the first patch is urgent. I'll get that out and wait for you to
update these other two (or just this one).

Thanks,

-- Steve


