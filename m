Return-Path: <linux-kernel-owner+w=401wt.eu-S1756167AbYFXRqY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756167AbYFXRqY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2008 13:46:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753100AbYFXRqR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Jun 2008 13:46:17 -0400
Received: from tomts5.bellnexxia.net ([209.226.175.25]:52104 "EHLO
	tomts5-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753189AbYFXRqQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2008 13:46:16 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApsEAE/MYEhMQWVt/2dsb2JhbACBW7F/
Date: Tue, 24 Jun 2008 13:46:13 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Masami Hiramatsu <mhiramat@redhat.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Takashi Nishiie <t-nishiie@np.css.fujitsu.com>,
       "'Alexey Dobriyan'" <adobriyan@gmail.com>,
       "'Peter Zijlstra'" <peterz@infradead.org>,
       "'Steven Rostedt'" <rostedt@goodmis.org>,
       "'Frank Ch. Eigler'" <fche@redhat.com>, "'Ingo Molnar'" <mingo@elte.hu>,
       "'LKML'" <linux-kernel@vger.kernel.org>,
       "'systemtap-ml'" <systemtap@sources.redhat.com>,
       "'Hideo AOKI'" <haoki@redhat.com>
Subject: Re: [RFC] Tracepoint proposal
Message-ID: <20080624174613.GA12432@Krystal>
References: <007601c8d5ca$18fa0e10$4aee2a30$@css.fujitsu.com> <48611B03.1000003@redhat.com> <20080625011951.D83E.KOSAKI.MOTOHIRO@jp.fujitsu.com> <48612879.5090809@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <48612879.5090809@redhat.com>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 13:42:12 up 19 days, 22:23,  3 users,  load average: 0.81, 0.94,
	1.09
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Masami Hiramatsu (mhiramat@redhat.com) wrote:
> KOSAKI Motohiro wrote:
> >> Tracepoint
> >>  - stored in a section
> >>  - dynamic activation
> >>  - no message
> >>  - export kernel structure
> >>  - arguments depending on points
> >>  - high frequently called
> >>  - no module support (kernel use only)
> > 
> > Why Shouldn't kernel module use tracepoint?
> > technical problem? or any plicy exist?
> 
> Good question, I think we don't want to export so much
> kernel internal structures. Since tracepoint tend to export
> raw kernel structure to user module, I thought it might be
> better not to export its interface to modules.
> 
> However, I thought that again, and knew what Peter worried was
> about marker which exports marker list to user space.
> So, the issue is exporting internal structures to user space,
> not to modules. Thus, I think it can support modules also.
> 

Agreed. It could be good to someday merge these tracepoint probes with
the mainline kernel so they can easily be adapted to tracepoint changes.
It seems correct to me for tracepoint probes to be either in the core
kernel or in modules, but I expect that they will be easier to maintain
within the tree.

Mathieu

> Thank you,
> 
> -- 
> Masami Hiramatsu
> 
> Software Engineer
> Hitachi Computer Products (America) Inc.
> Software Solutions Division
> 
> e-mail: mhiramat@redhat.com
> 

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
