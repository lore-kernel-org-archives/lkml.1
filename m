Return-Path: <linux-kernel-owner+w=401wt.eu-S1752703AbZIYHkN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752703AbZIYHkN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Sep 2009 03:40:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752325AbZIYHkN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Sep 2009 03:40:13 -0400
Received: from tomts36-srv.bellnexxia.net ([209.226.175.93]:37022 "EHLO
	tomts36-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751983AbZIYHkL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Sep 2009 03:40:11 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ArcEAEcPvEpMROOX/2dsb2JhbACBUtUNhBwFgVg
Date: Fri, 25 Sep 2009 03:35:13 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Arjan van de Ven <arjan@infradead.org>
Cc: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
       Jason Baron <jbaron@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
       Steven Rostedt <rostedt@goodmis.org>, Andi Kleen <ak@suse.de>,
       linux-kernel@vger.kernel.org, Masami Hiramatsu <mhiramat@redhat.com>,
       Prasanna S Panchamukhi <prasanna@in.ibm.com>,
       Rusty Lynch <rusty.lynch@intel.com>, Jim Keniston <jkenisto@us.ibm.com>,
       Vamsi Krishna S <vamsi_krishna@in.ibm.com>,
       Suparna Bhattacharya <suparna@in.ibm.com>,
       Nathan Sidwell <nathan@codesourcery.com>,
       Dominique Toupin <dominique.toupin@ericsson.com>,
       Anton Massoud <anton.massoud@ericsson.com>,
       Richard J Moore <richardj_moore@uk.ibm.com>
Subject: Re: Immediate values
Message-ID: <20090925073512.GA10346@Krystal>
References: <20090924191642.GA19225@elte.hu> <20090924193422.GB2533@elte.hu> <20090925085119.2b77ea04@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <20090925085119.2b77ea04@infradead.org>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.27.31-grsec (i686)
X-Uptime: 03:16:52 up 37 days, 18:06,  2 users,  load average: 0.07, 0.11,
	0.16
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Arjan van de Ven (arjan@infradead.org) wrote:
> On Thu, 24 Sep 2009 21:34:22 +0200
> Ingo Molnar <mingo@elte.hu> wrote:
> 
[context for people CCed: see
http://lkml.org/lkml/2009/9/24/262]

> > 
> > * H. Peter Anvin <hpa@zytor.com> wrote:
> > 
> > > I would like to get an official ACK or NAK for this patching
> > > technique from inside Intel, and preferrably from AMD as well.  If
> > > it does work as described it would provide a very clean way to do
> > > one-shot alternative functions, which probably would be higher
> > > value than immediate data values.
> > 
> > Sounds tempting. Things like the CONFIG_SECURITY hookery could use it?
> > 
> > But ... since it's patched under stopmachine, is there any reason why 
> > this wouldnt work?
> > 
> 
> stopmachine is fine.
> 
> more aggressive tricks are rather dicey.
> 
> (cross modifying code that's being executed in ring 0 is ... not
> something CPU designers had in mind)
> 

Then, following your advice, kprobes should be re-designed to do a
stop_machine around the int3 breakpoint insertion ? And gdb
should be stopping all threads of a target process before inserting a
breakpoint. Therefore, I do not seem to be the only one confused about
Intel statement on this issue.

Mathieu

> -- 
> Arjan van de Ven 	Intel Open Source Technology Centre
> For development, discussion and tips for power savings, 
> visit http://www.lesswatts.org

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
