Return-Path: <linux-kernel-owner+w=401wt.eu-S1753368AbZG2JJX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753368AbZG2JJX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jul 2009 05:09:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753070AbZG2JJW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Jul 2009 05:09:22 -0400
Received: from viefep17-int.chello.at ([62.179.121.37]:7972 "EHLO
	viefep17-int.chello.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753129AbZG2JJV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jul 2009 05:09:21 -0400
X-SourceIP: 213.93.53.227
Subject: Re: perf_counter: hook up the tracepoint events
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Jeff Garzik <jeff@garzik.org>
Cc: mingo@redhat.com, hpa@zytor.com, tglx@linutronix.de, mingo@elte.hu,
       paulus@samba.org, linux-kernel@vger.kernel.org, rostedt@goodmis.org,
       linux-tip-commits <linux-tip-commits@vger.kernel.org>
In-Reply-To: <4A700F8A.6000505@garzik.org>
References: <20090319194233.744044174@chello.nl>
	 <tip-ee78a855ff4d8d3d77b46696994dca393228bb8a@git.kernel.org>
	 <4A6F9F51.4010107@garzik.org> <1248856508.6987.3041.camel@twins>
	 <4A700F8A.6000505@garzik.org>
Content-Type: text/plain
Date: Wed, 29 Jul 2009 11:12:08 +0200
Message-Id: <1248858728.6987.3055.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-07-29 at 04:59 -0400, Jeff Garzik wrote:

> > @@ -957,6 +957,12 @@ config EVENT_PROFILE
> >  	bool "Tracepoint profile sources"
> >  	depends on PERF_COUNTERS && EVENT_TRACING
> >  	default y
> > +	help
> > +	 Allow the use of tracepoints as software performance counters.
> > +
> > +	 When this is enabled, you can create perf counters based on
> > +	 tracepoints using PERF_TYPE_TRACEPOINT and the tracepoint ID
> > +	 found in debugfs://tracing/events/*/*/id.
> 
> Thanks.  Is this feature useful w/out debugfs?

Not really, but I was assuming (/me goes check) that EVENT_TRACING would
mandate debugfs being there.

Hmm kernel/trace/Kconfig seems a little select heavy, but I think it'll
work out and select DEBUG_FS too.

I'll queue up the patch and push it Linus wards this cycle.

Thanks!

