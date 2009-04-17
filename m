Return-Path: <linux-kernel-owner+w=401wt.eu-S1761598AbZDQP0W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761598AbZDQP0W (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Apr 2009 11:26:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758521AbZDQP0L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Apr 2009 11:26:11 -0400
Received: from tomts5-srv.bellnexxia.net ([209.226.175.25]:41924 "EHLO
	tomts5-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752741AbZDQP0K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Apr 2009 11:26:10 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AlAFAOQ86ElMQW1W/2dsb2JhbACBTs5gg30G
Date: Fri, 17 Apr 2009 11:21:08 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Christoph Hellwig <hch@infradead.org>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>,
       Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Subject: Re: [PATCH 3/4] tracing: pass proto and args to DEFINE_TRACE
Message-ID: <20090417152108.GC13842@Krystal>
References: <1239950139-1119-1-git-send-email-jeremy@goop.org> <1239950139-1119-4-git-send-email-jeremy@goop.org> <20090417064820.GA20685@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <20090417064820.GA20685@infradead.org>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 11:20:32 up 48 days, 11:46,  3 users,  load average: 0.60, 0.59,
	0.52
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Christoph Hellwig (hch@infradead.org) wrote:
> On Thu, Apr 16, 2009 at 11:35:38PM -0700, Jeremy Fitzhardinge wrote:
> > -DEFINE_TRACE(power_mark);
> > +DEFINE_TRACE(power_mark,
> > +	TP_PROTO(struct power_trace *it, unsigned int type, unsigned int state),
> > +	      TP_ARGS(it, type, state));
> 
> Wrong indentation, the TP_ARGS should have the same level of indentation
> (one) as the TP_PROTO.  Also true for all others.
> 

Ingo actually proposed to add a supplementary indentation before TP_ARGS
in trace/sched.h to ease readability.

Mathieu

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
