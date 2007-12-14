Return-Path: <linux-kernel-owner+w=401wt.eu-S932101AbXLNVIl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932101AbXLNVIl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Dec 2007 16:08:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756192AbXLNVIc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Dec 2007 16:08:32 -0500
Received: from madara.hpl.hp.com ([192.6.19.124]:60049 "EHLO madara.hpl.hp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755424AbXLNVIb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Dec 2007 16:08:31 -0500
Date: Fri, 14 Dec 2007 13:07:09 -0800
From: Stephane Eranian <eranian@hpl.hp.com>
To: "Frank Ch. Eigler" <fche@redhat.com>
Cc: linux-kernel@vger.kernel.org, davem@davemloft.net, paulus@samba.org,
       akpm@linux-foundation.org, gregkh@suse.de, mucci@cs.utk.edu,
       wcohen@redhat.com, robert.richter@amd.com, andi@firstfloor.org,
       eranian@gmail.com, roland@redhat.com
Subject: Re: [perfmon2] perfmon2 merge news
Message-ID: <20071214210709.GE9577@frankl.hpl.hp.com>
Reply-To: eranian@hpl.hp.com
References: <20071119.050843.48408777.davem@davemloft.net> <18242.900.101842.261763@cargo.ozlabs.ibm.com> <20071119224845.GA27766@frankl.hpl.hp.com> <20071119.165313.163834190.davem@davemloft.net> <20071213160004.GC6740@frankl.hpl.hp.com> <y0mzlwdum3y.fsf@ton.toronto.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <y0mzlwdum3y.fsf@ton.toronto.redhat.com>
User-Agent: Mutt/1.4.1i
Organisation: HP Labs Palo Alto
Address: HP Labs, 1U-17, 1501 Page Mill road, Palo Alto, CA 94304, USA.
E-mail: eranian@hpl.hp.com
X-HPL-MailScanner: Found to be clean
X-HPL-MailScanner-From: eranian@hpl.hp.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Charles,

On Fri, Dec 14, 2007 at 02:12:17PM -0500, Frank Ch. Eigler wrote:
> 
> Stephane Eranian <eranian@hpl.hp.com> writes:
> 
> > [...]  AFAIK, there is no single call to stop T1 and wait until it
> > is completely off the CPU, unless we go through the (internal)
> > ptrace interface.
> 
> The utrace code supports this style of thread manipulation better
> than ptrace.

Afre you saying that utrace provides a utrace_thread_stop(tid) call
that returns only when the thread tid is off the CPU. And then there
is a utrace_thread_resume(tid) call. If that's the case then that is
what I need.

How are we with regards to utrace integration?

Thanks.

-- 
-Stephane
