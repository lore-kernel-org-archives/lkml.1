Return-Path: <linux-kernel-owner+w=401wt.eu-S1758778AbZKYMMb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758778AbZKYMMb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Nov 2009 07:12:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753142AbZKYMMa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Nov 2009 07:12:30 -0500
Received: from ey-out-2122.google.com ([74.125.78.25]:22919 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758195AbZKYMM3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Nov 2009 07:12:29 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=UuKO2e/Astx6hFMdsf5C7vrtVqMwtCXf19i1rENUF7ag8mkxkKFwUn22FwlvX08P8F
         dNJ7zga4f4MaZ2LmXtlMt53fxp2rGRv+UfjFhJlmB87w0Twrgo9c4rk/eZeMvAyKEZu1
         oxZQQ9am/ZD1vnaIidGfa+Hkkzw+HSmVsQWTY=
Date: Wed, 25 Nov 2009 13:12:33 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 0/3] [GIT PULL] tracing: rebase of TRACE_EVENT_TEMPLATE
Message-ID: <20091125121226.GA5010@nowhere>
References: <20091125043811.603607335@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091125043811.603607335@goodmis.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 24, 2009 at 11:38:11PM -0500, Steven Rostedt wrote:
> 
> Ingo,
> 
> This is the rebase to resolve the conflicts with perf.
> 
> Please pull the latest tip/perf/core tree, which can be found at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-2.6-trace.git
> tip/perf/core
> 
> 
> Steven Rostedt (3):
>       tracing: Create new TRACE_EVENT_TEMPLATE
>       tracing: Create new DEFINE_EVENT_PRINT
>       tracing: Convert some sched trace events to DEFINE_EVENT and _PRINT



Nice :)


 
> ----
>  include/linux/tracepoint.h   |    6 +
>  include/trace/define_trace.h |   11 ++
>  include/trace/events/sched.h |  170 ++++++++-------------------
>  include/trace/ftrace.h       |  266 +++++++++++++++++++++++++++++++++++-------
>  4 files changed, 292 insertions(+), 161 deletions(-)
> 

