Return-Path: <linux-kernel-owner+w=401wt.eu-S1756836AbZIRMN3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756836AbZIRMN3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Sep 2009 08:13:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756733AbZIRMN2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Sep 2009 08:13:28 -0400
Received: from tomts22.bellnexxia.net ([209.226.175.184]:58795 "EHLO
	tomts22-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756623AbZIRMN2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Sep 2009 08:13:28 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AtYEAN4Ts0pMROOX/2dsb2JhbACBUswehBwF
Date: Fri, 18 Sep 2009 08:13:29 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Ingo Molnar <mingo@elte.hu>
Cc: Christoph Hellwig <hch@lst.de>, Steven Rostedt <rostedt@goodmis.org>,
       =?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] kill markers
Message-ID: <20090918121329.GA1173@Krystal>
References: <20090917173527.GA1699@lst.de> <20090918102334.GA24638@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <20090918102334.GA24638@elte.hu>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.27.31-grsec (i686)
X-Uptime: 08:12:28 up 30 days, 23:01,  2 users,  load average: 0.15, 0.20,
	0.22
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Ingo Molnar (mingo@elte.hu) wrote:
> 
> * Christoph Hellwig <hch@lst.de> wrote:
> 
> > Now that the last users of markers have migrated to the event tracer 
> > we can kill off the support code.
> 
> Applied, thanks Christoph!
> 
> Btw., there's some more marker related bits in the kernel, such as 
> scripts/mod/modpost.c - mostly the effects of:
> 
>   b2e3e65: Linux Kernel Markers: create modpost file
> 
> I think we want to keep those bits, for those who want to use new 
> modpost with an older kernel - but mark them for deprecation.
> 

Just to confirm: this means having a printk-style infrastructure to
prototype tracepoints is not considered useful ?

Mathieu


> Thanks,
> 
> 	Ingo

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
