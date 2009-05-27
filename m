Return-Path: <linux-kernel-owner+w=401wt.eu-S1762816AbZE0Sgn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762816AbZE0Sgn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 May 2009 14:36:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760927AbZE0Sgc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 May 2009 14:36:32 -0400
Received: from mx2.redhat.com ([66.187.237.31]:34575 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761413AbZE0Sgb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 May 2009 14:36:31 -0400
Date: Wed, 27 May 2009 20:32:09 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Zhaolei <zhaolei@cn.fujitsu.com>, Steven Rostedt <rostedt@goodmis.org>,
       Ingo Molnar <mingo@elte.hu>, Tom Zanussi <tzanussi@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2] tracing/workqueue: Get rid of searching last
	executed worklet in probe_worklet_complete()
Message-ID: <20090527183209.GB30574@redhat.com>
References: <4A153345.3040905@cn.fujitsu.com> <4A1610B6.7010203@cn.fujitsu.com> <20090522183739.GA26234@redhat.com> <20090526202306.GE5969@nowhere>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090526202306.GE5969@nowhere>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/26, Frederic Weisbecker wrote:
>
> On Fri, May 22, 2009 at 08:37:39PM +0200, Oleg Nesterov wrote:
> > On 05/22, Zhaolei wrote:
> > >
> > > We don't need search workqueue's worklet list for worklet which was latest
> > > executed, instead, we can use a pointer in cpu_workqueue_stats to remember
> > > which worklet was just executed.
> >
> > Thanks Zhao, I think this is correct.
> >
> > Oleg.
>
> May I add your Acked-by then?

Yes, please feel free. Or reviewed-by, whatever you think more right.

Oleg.

