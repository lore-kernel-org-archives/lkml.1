Return-Path: <linux-kernel-owner+w=401wt.eu-S1754464AbYKFNNS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754464AbYKFNNS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2008 08:13:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753777AbYKFNNI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Nov 2008 08:13:08 -0500
Received: from tomts5.bellnexxia.net ([209.226.175.25]:63838 "EHLO
	tomts5-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753569AbYKFNNH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2008 08:13:07 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AtMEAMN6EklMQWxa/2dsb2JhbACBdcdig1U
Date: Thu, 6 Nov 2008 08:13:05 -0500
From: Mathieu Desnoyers <compudj@krystal.dyndns.org>
To: ltt-dev@lists.casi.polymtl.ca
Cc: linux-kernel@vger.kernel.org
Subject: Re: [ltt-dev] LTTng 0.51, improved timestamping
Message-ID: <20081106131305.GA29924@Krystal>
References: <20081106074543.GA18558@Krystal> <20081106131034.GA29679@Krystal>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <20081106131034.GA29679@Krystal>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 08:11:41 up 154 days, 17:52,  5 users,  load average: 1.77, 0.79,
	0.64
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Please ignore this last message. As some of you may have noticed, this
is actually the result of a brainstorming while being half-asleep. Those
things will be carefully looked at this morning. ;)

Mathieu

* Mathieu Desnoyers (compudj@krystal.dyndns.org) wrote:
> disable tsc synth when ! trace clock ?
> tsc synth get/put ?
> 
> amd64 :
> - single cpu -> tsc_is_sync : no force on unstable tsc ?
> - hotplug out all cpus, recheck
> 
> 
> 
> * Mathieu Desnoyers (compudj@krystal.dyndns.org) wrote:
> > Hi,
> > 
> > LTTng 0.51 for 2.6.27.4 does the following :
> > 
> > It improves timestamping on architectures with non-synchronized TSCs in
> > LTTng 0.51. I also now use per-cpu timers to do some time-related stuff
> > I previously used IPIs for. It involves being more closely tied to the
> > CPU hotplug callbacks.
> > 
> > I also replaced x86 tsc_sync.c test by LTTng architecture independent
> > test. (this will be posted separately on LKML for 2.6.28-rc3 tomorrow
> > along with the "tracer clock" patchset).
> > 
> > The event trap_entry, syscall_entry, irq_entry, softirq entry, exit and
> > raise now use smaller fields (2 bytes), which should be enough to encode
> > the IDs for all architectures. This will principally make a difference
> > with non-aligned tracing for most of those events.
> > 
> > Mathieu
> > 
> > -- 
> > Mathieu Desnoyers
> > OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
> > 
> > _______________________________________________
> > ltt-dev mailing list
> > ltt-dev@lists.casi.polymtl.ca
> > http://lists.casi.polymtl.ca/cgi-bin/mailman/listinfo/ltt-dev
> > 
> 
> -- 
> Mathieu Desnoyers
> OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
