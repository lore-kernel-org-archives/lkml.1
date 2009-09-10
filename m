Return-Path: <linux-kernel-owner+w=401wt.eu-S1751201AbZIJEp7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751201AbZIJEp7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Sep 2009 00:45:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750916AbZIJEp7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Sep 2009 00:45:59 -0400
Received: from mail-yw0-f175.google.com ([209.85.211.175]:59418 "EHLO
	mail-yw0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750842AbZIJEp6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Sep 2009 00:45:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=fZQNKeysWQNqCSzkJT2urAZfVO8Qqh0kHN+hflj8DXdXni+WYBXJZ0ZbPEXg/v9y3z
         1y/IP+Zc77Yx1WH9Tg3JH5jFFq6x0CGt1HwOCMOYlnnMSrCKQ3mBO4xYHJjS+oGMhYbn
         tFl0i/YbdCEharLZ0VkjAj2ZjkZ+Z7HtIDGtI=
Subject: Re: [PATCH 4/6] perf_counter: Add PERF_COUNTER_IOC_SET_FILTER ioctl
From: Tom Zanussi <tzanussi@gmail.com>
To: Li Zefan <lizf@cn.fujitsu.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       Steven Rostedt <rostedt@goodmis.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Jason Baron <jbaron@redhat.com>, LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <4AA71080.7030503@cn.fujitsu.com>
References: <4AA4C04D.1050201@cn.fujitsu.com>
	 <4AA4C0B3.3070300@cn.fujitsu.com> <1252341871.7959.37.camel@laptop>
	 <20090907164852.GA6485@elte.hu>  <1252342545.7959.42.camel@laptop>
	 <1252393315.10919.4.camel@tropicana>  <4AA71080.7030503@cn.fujitsu.com>
Content-Type: text/plain
Date: Wed, 09 Sep 2009 23:45:57 -0500
Message-Id: <1252557957.6431.2.camel@tropicana>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-09-09 at 10:18 +0800, Li Zefan wrote:
> >>>> Hrm,.. not at all sure about this.. what are the ABI implications?
> >>> I think the ABI should be fine if it's always a sub-set of C syntax. 
> >>> That would be C expressions initially. Hm?
> >> Right, so I've no clue what filter expressions look like, and the
> >> changelog doesn't help us at all. It doesn't mention its a well
> >> considered decision to henceforth freeze the expression syntax.
> >>
> >> Of course, since filters so far only work with tracepoint things, and
> >> since you can only come by tracepoint things through debugfs, and since
> >> anything debugfs is basically a free-for-all ABI-less world, we might be
> >> good, but then this is a very ill-defined ioctl() indeed.
> >>
> >> So please, consider this well -- there might not be a second chance.
> >>
> > 
> > I've been meaning to write up something about the event filters - here's
> > a first stab that hopefully helps explain them...
> > 
> 
> Great!
> 
> Reviewed-by: Li Zefan <lizf@cn.fujitsu.com>
> 
> Could you add your SOB and send it to Ingo?
> 
> Some nitpicks below:

Sure, I'll send a new version shortly - thanks for the suggestions.

Tom
 


