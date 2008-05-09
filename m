Return-Path: <linux-kernel-owner+w=401wt.eu-S1760163AbYEIL0T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760163AbYEIL0T (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 May 2008 07:26:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753631AbYEIL0J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 May 2008 07:26:09 -0400
Received: from relay2.sgi.com ([192.48.171.30]:34828 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752875AbYEIL0I (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 May 2008 07:26:08 -0400
Date: Fri, 9 May 2008 06:26:05 -0500
From: Paul Jackson <pj@sgi.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: maxk@qualcomm.com, a.p.zijlstra@chello.nl, akpm@linux-foundation.org,
       menage@google.com, seto.hidetoshi@jp.fujitsu.com,
       linux-kernel@vger.kernel.org, tglx@linutronix.de, oleg@tv-sign.ru,
       rostedt@goodmis.org, rientjes@google.com
Subject: Re: Reverting per-cpuset "system" (IRQ affinity) patch
Message-Id: <20080509062605.d911ba53.pj@sgi.com>
In-Reply-To: <20080509102237.GE19617@elte.hu>
References: <48210101.1070205@google.com>
	<20080506183138.546f42d9.akpm@linux-foundation.org>
	<20080506204054.564fff32.pj@sgi.com>
	<20080506223859.0b4fa876.pj@sgi.com>
	<20080506204444.f4c38d0a.akpm@linux-foundation.org>
	<20080506225228.d42630cf.pj@sgi.com>
	<1210142681.13978.166.camel@twins>
	<48233EEB.1010807@qualcomm.com>
	<20080509102237.GE19617@elte.hu>
Organization: SGI
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.12.0; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo wrote:
> none of this is upstream yet (nor is any of this even near to being 
> ready for upstream), so there's nothing to revert.

I thought one of the earlier patches (Max's, perhaps) that we considered
in this discussion back in Feb or March -did- end up close to traveling
upstream, via the sched-devel tree going into linux-next, or some such.

However I can't claim to understand what (almost) went down there as
well as Andrew or Stephen hopefully do.


> Paul/Peter/Max, what's the current agreed-upon approach

Well ... we don't have an agreed on approach yet ;)


> to merge these physical resource isolation features into cpusets
> intelligently while still keeping the whole thing as usable and
> practical to down-to-earth sysadmins as possible? That is the issue
> that is blocking this whole topic from progressing.

Well, yeah, everyone wants "simple".  But that tends to degrade into
each of us insisting that whatever we don't appreciate need for in the
other guys proposal be removed.  That way lies not progress.

-- 
                  I won't rest till it's the best ...
                  Programmer, Linux Scalability
                  Paul Jackson <pj@sgi.com> 1.940.382.4214
