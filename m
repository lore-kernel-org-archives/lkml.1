Return-Path: <linux-kernel-owner+w=401wt.eu-S1757283AbZCSOD5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757283AbZCSOD5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Mar 2009 10:03:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755506AbZCSODr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Mar 2009 10:03:47 -0400
Received: from tomts36.bellnexxia.net ([209.226.175.93]:53045 "EHLO
	tomts36-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754647AbZCSODq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Mar 2009 10:03:46 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Au4EAJTrwUlMQW1W/2dsb2JhbACBT9FFg3wG
Date: Thu, 19 Mar 2009 10:03:39 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Ingo Molnar <mingo@elte.hu>, Lai Jiangshan <laijs@cn.fujitsu.com>,
       Jaswinder Singh Rajput <jaswinder@kernel.org>,
       =?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       x86 maintainers <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: oops in tracepoint_update_probe_range()
Message-ID: <20090319140339.GB21513@Krystal>
References: <1237393396.3322.6.camel@localhost.localdomain> <20090318163531.GE21331@elte.hu> <49C1F1DF.2020105@cn.fujitsu.com> <20090319074616.GA17144@elte.hu> <20090319132248.GA20200@Krystal> <alpine.DEB.2.00.0903190933440.16987@gandalf.stny.rr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.0903190933440.16987@gandalf.stny.rr.com>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 10:00:47 up 19 days, 10:27,  1 user,  load average: 0.84, 0.64,
	0.56
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Steven Rostedt (rostedt@goodmis.org) wrote:
> 
> On Thu, 19 Mar 2009, Mathieu Desnoyers wrote:
> > 
> > Jaswinder : maybe you have old modules in your /lib/modules/`uname -r`
> > directory which have the correct version, but the wrong module.h header ?
> 
> Isn't there a module versioning that prevents such things?
> 
> -- Steve

I think it's only enabled when CONFIG_MODVERSIONS is on, which is not
the case for his config :

# CONFIG_MODVERSIONS is not set

So I might be wrong, but I suspect the compatibility check in this case
would only be based on kernel version.

Mathieu

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
