Return-Path: <linux-kernel-owner+w=401wt.eu-S1762179AbXK2Kny@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762179AbXK2Kny (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2007 05:43:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752678AbXK2Kno
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Nov 2007 05:43:44 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:40087 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751175AbXK2Knn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2007 05:43:43 -0500
Date: Thu, 29 Nov 2007 11:43:25 +0100
From: Ingo Molnar <mingo@elte.hu>
To: "Metzger, Markus T" <markus.t.metzger@intel.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, tglx@linutronix.de,
       ak@suse.de, "Siddha, Suresh B" <suresh.b.siddha@intel.com>,
       akpm@linux-foundation.org
Subject: Re: [patch 1/2] x86, ptrace: support for branch trace store(BTS)
Message-ID: <20071129104325.GF10577@elte.hu>
References: <029E5BE7F699594398CA44E3DDF5544401024076@swsmsx413.ger.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <029E5BE7F699594398CA44E3DDF5544401024076@swsmsx413.ger.corp.intel.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Metzger, Markus T <markus.t.metzger@intel.com> wrote:

> Changes to previous version(s):
> - moved task arrives/departs notifications to __switch_to_xtra()
> - added _TIF_BTS_TRACE and _TIF_BTS_TRACE_TS to _TIF_WORK_CTXSW_*
> - split _TIF_WORK_CTXSW into ~_PREV and ~_NEXT for x86_64
> - ptrace_bts_init_intel() function called from init_intel()
> - removed PTRACE_BTS_INIT ptrace command
> - cache DEBUGCTRL MSR
> - replace struct declarations and operations struct with
>   configuration struct defining offset/size pairs and
>   generic operations
> - added a patch for the ptrace.2 man page for discussing the API
>   in this forum

i tried to apply your patches to x86.git, but your patches were 
linewrapped and had strange artifacts in them:

| @@ -610,6 +612,32 @@
|                                         (struct user_desc __user *)
| data);
|                 break;
| =20
| +       case PTRACE_BTS_ALLOCATE_BUFFER:
| +

could you please resend with this fixed (preferably against x86.git, 
which has Roland's ptrace cleanups?).

	Ingo
