Return-Path: <linux-kernel-owner+w=401wt.eu-S1753545AbZHMO36@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753545AbZHMO36 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Aug 2009 10:29:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753505AbZHMO35
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Aug 2009 10:29:57 -0400
Received: from mx2.redhat.com ([66.187.237.31]:37963 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751719AbZHMO35 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Aug 2009 10:29:57 -0400
Date: Thu, 13 Aug 2009 11:29:36 -0300
From: Arnaldo Carvalho de Melo <acme@redhat.com>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       Peter Zijlstra <peterz@infradead.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Mike Galbraith <efault@gmx.de>
Subject: Re: [PATCH 1/2] perf tools: Add a per tracepoint counter attribute
	to get raw sample
Message-ID: <20090813142936.GG3495@ghostprotocols.net>
References: <1250152039-7284-1-git-send-email-fweisbec@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1250152039-7284-1-git-send-email-fweisbec@gmail.com>
X-Url: http://oops.ghostprotocols.net:81/blog
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Thu, Aug 13, 2009 at 10:27:18AM +0200, Frederic Weisbecker escreveu:
> Add a new flag field while opening a tracepoint perf counter:
> 
> 	-e tracepoint_subsystem:tracepoint_name:flags
> 
> This is intended to be generic although for now it only supports the
> r[e[c[o[r[d]]]]] flag:
> 
> 	./perf record -e workqueue:workqueue_insertion:record
> 	./perf record -e workqueue:workqueue_insertion:r
> 
> will have the same effect: enabling the raw samples record for the
> given tracepoint counter.
> 
> In the future, we may want to support further flags, separated by
> commas.

Will you at some point get those commit messages massaged into 'perf
record --help'? :-)

- Arnaldo
