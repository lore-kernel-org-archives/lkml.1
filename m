Return-Path: <linux-kernel-owner+w=401wt.eu-S1757407AbZDOMJa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757407AbZDOMJa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Apr 2009 08:09:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752486AbZDOMJT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Apr 2009 08:09:19 -0400
Received: from mx2.redhat.com ([66.187.237.31]:50544 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751016AbZDOMJT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Apr 2009 08:09:19 -0400
Date: Wed, 15 Apr 2009 14:05:27 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Zhaolei <zhaolei@cn.fujitsu.com>, Steven Rostedt <rostedt@goodmis.org>,
       Tom Zanussi <tzanussi@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 2/4] ftrace: introduce workqueue_handler_exit
	tracepoint and rename workqueue_execution to workqueue_handler_entry
Message-ID: <20090415120527.GA6960@redhat.com>
References: <20090413125653.6E01.A69D9226@jp.fujitsu.com> <20090413145105.6E07.A69D9226@jp.fujitsu.com> <20090413145159.6E0A.A69D9226@jp.fujitsu.com> <20090413162534.GI5977@nowhere> <20090415102257.GA2617@redhat.com> <20090415110937.GA27727@elte.hu> <20090415113359.GA5118@redhat.com> <20090415114549.GA17775@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090415114549.GA17775@elte.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/15, Ingo Molnar wrote:
>
> The patches try to map and instrument the life cycle of a worklet,
> and the main actions that occur in the workqueue subsystem in
> general.
>
> The purpose is instrumentation: for debugging purposes, for
> improving kernel code and for just understanding how the system
> functions and what its dynamic actions are.
>
> In that sense the worklet 'key' possibly getting reallocated and
> reused before the 'completed' action was traced is probably not a
> big deal - but tools have to be aware of it possibly happening (and
> most not hard-code any assumption to the contrary).
>
> Plus the exit handler must not dereference the worklet either.
> Safest would be to make this sure in the prototype already: pass in
> a void * key, not a work structure.

Yes, I think you are right.

And thanks for your explanations!

Oleg.

