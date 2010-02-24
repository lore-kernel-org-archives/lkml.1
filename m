Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758383Ab0BXWWL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Feb 2010 17:22:11 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:36916 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758337Ab0BXWWJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Feb 2010 17:22:09 -0500
X-Authority-Analysis: v=1.0 c=1 a=0-XWFxDPI_sA:10 a=7U3hwN5JcxgA:10 a=Z4Rwk6OoAAAA:8 a=9e_8kkgDhmDViemghRgA:9 a=OGZhcf5DYZqcR-sMUNm_oLhuHqsA:4 a=jbrJJM5MRmoA:10
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.89.75
Subject: Re: + kernelh-printk-panic-string-cleanup.patch added to -mm tree
From: Steven Rostedt <rostedt@goodmis.org>
Reply-To: rostedt@goodmis.org
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: akpm@linux-foundation.org, mm-commits@vger.kernel.org,
       hidave.darkstar@gmail.com, gregkh@suse.de,
       kosaki.motohiro@jp.fujitsu.com, lizf@cn.fujitsu.com, mingo@elte.hu,
       linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>
In-Reply-To: <20100224213406.GA7491@nowhere>
References: <201002242107.o1OL7F6v020376@imap1.linux-foundation.org>
	 <20100224213406.GA7491@nowhere>
Content-Type: text/plain; charset="ISO-8859-15"
Organization: Kihon Technologies Inc.
Date: Wed, 24 Feb 2010 17:21:59 -0500
Message-ID: <1267050119.24271.7820.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-02-24 at 22:34 +0100, Frederic Weisbecker wrote:
> On Wed, Feb 24, 2010 at 01:07:15PM -0800, akpm@linux-foundation.org wrote:
> > 

> That said, it's probably sane to think about a new header to put
> these tracing prototypes, if it's included by kernel.h,
> linux/ftrace.h is already filled with non-general purpose things.
> So may be linux/trace.h ? Yeah this could be confusing, Steve what
> do you think?
> 
> And all in one, it would probably better to split this in three
> patches: one that moves printk helpers out of kernel.h to printk.h,
> another following the same pattern for panic things and another one
> for tracing things.

Yeah, I'm fine with moving the tracing related stuff in kernel.h into a
trace.h file and keep ftrace.h specific to ftrace in general.

But I still find it necessary that trace.h gets included by kernel.h.

I can just imaging Thomas yelling at me more when he adds a
tracing_off() or trace_printk() somewhere and then gets a warning about
it not being declared.

I also gave that patch a NAK, in case that carries any weight.

-- Steve


