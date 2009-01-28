Return-Path: <linux-kernel-owner+w=401wt.eu-S1753336AbZA1OaA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753336AbZA1OaA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2009 09:30:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751136AbZA1O3v
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Jan 2009 09:29:51 -0500
Received: from mx2.redhat.com ([66.187.237.31]:53584 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750951AbZA1O3v (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2009 09:29:51 -0500
Date: Wed, 28 Jan 2009 12:29:28 -0200
From: Arnaldo Carvalho de Melo <acme@redhat.com>
To: =?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>
Cc: "Frank Ch. Eigler" <fche@redhat.com>,
       "Kok, Auke" <auke-jan.h.kok@intel.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       powertop ml <power@bughost.org>,
       Arjan van de Ven <arjan@linux.intel.com>, Ingo Molnar <mingo@elte.hu>,
       srostedt@redhat.com, Neil Horman <nhorman@tuxdriver.com>,
       utrace-devel@redhat.com
Subject: Re: [PATCH] tracer for sys_open() - sreadahead
Message-ID: <20090128142928.GF15877@ghostprotocols.net>
Mail-Followup-To: Arnaldo Carvalho de Melo <acme@redhat.com>,
	=?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>,
	"Frank Ch. Eigler" <fche@redhat.com>,
	"Kok, Auke" <auke-jan.h.kok@intel.com>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	powertop ml <power@bughost.org>,
	Arjan van de Ven <arjan@linux.intel.com>,
	Ingo Molnar <mingo@elte.hu>, srostedt@redhat.com,
	Neil Horman <nhorman@tuxdriver.com>, utrace-devel@redhat.com
References: <497F69A4.2070007@intel.com> <20090127224303.GB5850@nowhere> <y0mtz7ks1jf.fsf@ton.toronto.redhat.com> <c62985530901280558o7b7572efl8afeebb33b463e2b@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <c62985530901280558o7b7572efl8afeebb33b463e2b@mail.gmail.com>
X-Url: http://oops.ghostprotocols.net:81/blog
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Wed, Jan 28, 2009 at 02:58:28PM +0100, Frédéric Weisbecker escreveu:
> 2009/1/28 Frank Ch. Eigler <fche@redhat.com>:
> > Frederic Weisbecker <fweisbec@gmail.com> writes:
> >
> >> [...]
> >> Speaking about a global syscall tracer, I made a patch to trace only the syscalls
> >> with the function-graph-tracer.
> >> http://lkml.org/lkml/2008/12/30/267 This low-level part can easily
> >> be used by all tracers that would like to inspect syscalls.
> >> [...]
> >> Just a change is needed: Steven requested that the part inside
> >> syscall_trace_enter become a tracepoint, making it totally shareable
> >> between tracers and easy to turn on and off.
> >
> > Alternately, you could just rely on utrace's hooks.  They were thought
> > out more fully with respect to parameter access, manipulation, and
> > programmatic control befitting even a debugger.
> >
> >
> > - FChE
> >
> 
> I don't know much it. But I will soon have some time to look at your
> patch which uses ftrace from utrace.
> Anyway, are there some plans about utrace to be merged? Unless I
> couldn't be able to use
> it...

Well, one of the reasons for utrace not to be merged, IIRC, was that
there would be no users in-kernel. With Frank's ftrace plugin that is
not true anymore.

- Arnaldo
