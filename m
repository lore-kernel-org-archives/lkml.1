Return-Path: <linux-kernel-owner+w=401wt.eu-S1759508AbZAODU2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759508AbZAODU2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2009 22:20:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754135AbZAODUS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Jan 2009 22:20:18 -0500
Received: from tomts25.bellnexxia.net ([209.226.175.188]:53419 "EHLO
	tomts25-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754050AbZAODUR convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2009 22:20:17 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AicFAPg1bklMQWt2/2dsb2JhbACBbM0khW6ENg
Date: Wed, 14 Jan 2009 22:20:14 -0500
From: Mathieu Desnoyers <compudj@krystal.dyndns.org>
To: Theodore Tso <tytso@mit.edu>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Ext4 Developers List <linux-ext4@vger.kernel.org>,
       ltt-dev@lists.casi.polymtl.ca, linux-kernel@vger.kernel.org
Subject: Re: [ltt-dev] LTTng 0.74 for Linux 2.6.28 (ext4 tracepoints)
	(fixed in LTTng 0.78)
Message-ID: <20090115032014.GA10229@Krystal>
References: <20090109235449.GA21999@Krystal> <20090110161137.GA20526@Krystal> <2f11576a0901131433h31056e34n82588a9c643224de@mail.gmail.com> <20090113225827.GA5791@Krystal> <20090114001346.GB14730@mit.edu> <20090115014521.GG7458@Krystal>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
In-Reply-To: <20090115014521.GG7458@Krystal>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 22:19:07 up 14 days,  3:17,  2 users,  load average: 0.74, 0.40,
	0.30
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Mathieu Desnoyers (compudj@krystal.dyndns.org) wrote:
> * Theodore Tso (tytso@mit.edu) wrote:
> > On Tue, Jan 13, 2009 at 05:58:27PM -0500, Mathieu Desnoyers wrote:
> > > > 
> > > > -ECANTBUILD
> > > > 
> > > Thanks for the report. This should be fixed in LTTng 0.78 now.
> > 
> > Out of curiosity, do you maintain a branch of LTTNG versus any of the
> > -rc kernels, or do you only track the stable kernels?  I tried pulling
> > LTTNG 0.78 against the most recent Linus mainline and got a whole pile
> > of conflicts.
> > 
> > I then tried building LTTng 0.78 and got build failures:
> > 
> >   CC      arch/x86/kernel/init_task.o
> > distcc[27501] ERROR: compile /var/cache/ccache/init_task.tmp.closure.27497.i on localhost failed
> > /usr/projects/linux/ext4/arch/x86/kernel/init_task.c:35: error: unknown field ‘user_markers_mutex’ specified in initializer
> > /usr/projects/linux/ext4/arch/x86/kernel/init_task.c:35: warning: braces around scalar initializer
> > /usr/projects/linux/ext4/arch/x86/kernel/init_task.c:35: warning: (near initialization for ‘init_task.latency_record_count’)
> > /usr/projects/linux/ext4/arch/x86/kernel/init_task.c:35: error: field name not in record or union initializer
> > /usr/projects/linux/ext4/arch/x86/kernel/init_task.c:35: error: (near initialization for ‘init_task.latency_record_count’)
> > 
> > Looks like CONFIG_MARKERS_USERSPAC is busted....
> > 
> 
> Hi Ted,
> 
> I'm currently integrating Lai's work to the 2.6.28 lttng branch (ascii
> output !) :) and the next step will be to move to 2.6.29-rc1. I'll keep
> you posted. Note that you can just leave the 
> 
> #New revamped userspace markers
> 
> markers-userspace.patch
> markers-userspace-x86.patch
> markers-userspace-x86_64.patch
> sparc64-support-userspace-tracing.patch
> 
> Out of the patchset and it should not hurt the kernel tracing part at
> all. Note that these 4 patches are planned to be heavily reworked before
> lkml submission.
>

Actually, the x86_32 2.6.28 build was broken because of a bad patch
hunk which caused this problem. I fixed it in lttng 0.81. The port to
2.6.29-rc1 should some in a few days.

Thanks for the report,

Mathieu

> Mathieu
> 
> > 						- Ted
> > 
> 
> -- 
> Mathieu Desnoyers
> OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
> 
> _______________________________________________
> ltt-dev mailing list
> ltt-dev@lists.casi.polymtl.ca
> http://lists.casi.polymtl.ca/cgi-bin/mailman/listinfo/ltt-dev

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
