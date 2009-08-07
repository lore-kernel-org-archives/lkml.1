Return-Path: <linux-kernel-owner+w=401wt.eu-S933694AbZHGUWG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933694AbZHGUWG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Aug 2009 16:22:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933654AbZHGUWF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Aug 2009 16:22:05 -0400
Received: from fg-out-1718.google.com ([72.14.220.158]:60183 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933631AbZHGUWD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Aug 2009 16:22:03 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        b=gI9BvJG6P9R7LUO+/E2cZHCM0en6UjjmpA80gH7PKBlLNKP2GCi+1j+v/QSMU5l8fL
         xng0rnR+01cIr71CugK/BkB9mpc/ZTHkCAQOBZ8s44g2nJ1XU2j9nl9m5bLo8H4R9KaP
         BJShOWZzIvE8zJYX6MFFpFlEiWHkRT1P/bQgc=
Date: Fri, 7 Aug 2009 22:22:01 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: mingo@redhat.com, hpa@zytor.com, acme@redhat.com, paulus@samba.org,
       linux-kernel@vger.kernel.org, tzanussi@gmail.com, lizf@cn.fujitsu.com,
       a.p.zijlstra@chello.nl, penberg@cs.helsinki.fi, efault@gmx.de,
       eduard.munteanu@linux360.ro, rostedt@goodmis.org, tglx@linutronix.de,
       laijs@cn.fujitsu.com, linux-tip-commits@vger.kernel.org
Subject: Re: [tip:perfcounters/tracing] perf_counter: Support for ftrace
	event records sampling
Message-ID: <20090807202159.GC4999@nowhere>
References: <1249601154-5597-1-git-send-email-fweisbec@gmail.com> <tip-24cb4fabe71f1d896b504cec82277ad7426a3d6d@git.kernel.org> <20090807101136.GA20896@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20090807101136.GA20896@elte.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 07, 2009 at 12:11:36PM +0200, Ingo Molnar wrote:
> 
> * tip-bot for Frederic Weisbecker <fweisbec@gmail.com> wrote:
> 
> > Commit-ID:  24cb4fabe71f1d896b504cec82277ad7426a3d6d
> > Gitweb:     http://git.kernel.org/tip/24cb4fabe71f1d896b504cec82277ad7426a3d6d
> > Author:     Frederic Weisbecker <fweisbec@gmail.com>
> > AuthorDate: Fri, 7 Aug 2009 01:25:54 +0200
> > Committer:  Ingo Molnar <mingo@elte.hu>
> > CommitDate: Fri, 7 Aug 2009 09:30:33 +0200
> > 
> > perf_counter: Support for ftrace event records sampling
> 
> this commit triggers a new build warning:
> 
> kernel/perf_counter.c: In function ‘perf_counter_output’:
> kernel/perf_counter.c:2650: warning: ‘tp’ may be used uninitialized in this function
> 
> 	Ingo


Ok, I'll fix it, thanks.

