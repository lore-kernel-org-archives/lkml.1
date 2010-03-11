Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755548Ab0CKS3p (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Mar 2010 13:29:45 -0500
Received: from fg-out-1718.google.com ([72.14.220.158]:54864 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755483Ab0CKS3g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Mar 2010 13:29:36 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=AtcVz3VID7S4QRYjumj/x+qDC6Qh6wshKpZ33WlkDjmo3ekXmGTELpzMEMu7sPSsVm
         Oly4o8nyAvfJA/XcjgobaFoajlKJksoBWb85bIa16MCaxCCaMQWBt/Jpa1Q/i7/O/9fK
         xafW1P/Z0mmSJ3LkZHdq/vn8cG/t5byU0wjKo=
Date: Thu, 11 Mar 2010 21:29:32 +0300
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Lin Ming <ming.m.lin@intel.com>, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Stephane Eranian <eranian@google.com>,
       Robert Richter <robert.richter@amd.com>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [RFC] x86,perf: Implement minimal P4 PMU driver v14
Message-ID: <20100311182932.GC5129@lenovo>
References: <20100310183102.GC8070@lenovo> <1268274775.4996.16.camel@minggr.sh.intel.com> <20100311165439.GB5129@lenovo> <20100311181646.GA12235@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100311181646.GA12235@elte.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 11, 2010 at 07:16:46PM +0100, Ingo Molnar wrote:
> 
> * Cyrill Gorcunov <gorcunov@openvz.org> wrote:
> 
[...]
> > x86,perf: Implement minimal P4 PMU driver v15
> 
> i also triggered this:
> 
> [  436.224139] PMU: Dep events are not implemented yet
> 

yes, it's expected since it's not implemented yet, but there
is a hope to implement it next week.

> 
> All in one, the P4 PMU perf driver works on this box like a charm and all the 
> common profiling workflows work out of box, without any serious limitations - 
> really nice work! (Obviously some events wont work yet, etc.)
> 

All credits go to Ming, he spent a lot of time to make this code working! :)

> So it's pretty impressive and i've queued up your patch in tip:perf/x86 and 
> will merge it into perf/core after others had a chance to test it too.
> 
> 	Ingo
> 

yeah, wide testing would be great. Thanks!

	-- Cyrill
