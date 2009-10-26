Return-Path: <linux-kernel-owner+w=401wt.eu-S1752497AbZJZOZU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752497AbZJZOZU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Oct 2009 10:25:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752393AbZJZOZU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Oct 2009 10:25:20 -0400
Received: from mail-px0-f179.google.com ([209.85.216.179]:49315 "EHLO
	mail-px0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752094AbZJZOZT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Oct 2009 10:25:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:reply-to:to:cc:in-reply-to:references:content-type
         :organization:date:message-id:mime-version:x-mailer
         :content-transfer-encoding;
        b=KrWKvOSQmFaHcCt43nTBIItf69z9IiPjUJm5WjfaJklUPozsYgk7v1pbvtXBmG1nwX
         WxkohomDfpfUWbA1VmRtEIaACeASb7X4pRCLiEaBtS441ugf8Q4OEVKpgRYmLtg5x+Zh
         xJR8tMQEbyTbOG2UOEIgmp8qtncIvPmcgJA+w=
Subject: Re: [PATCH -v5 02/11] MIPS: add mips_timecounter_read() to get
 high precision timestamp
From: Wu Zhangjin <wuzhangjin@gmail.com>
Reply-To: wuzhangjin@gmail.com
To: rostedt@goodmis.org
Cc: linux-mips@linux-mips.org, linux-kernel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>,
       Ralf Baechle <ralf@linux-mips.org>,
       Nicholas Mc Guire <der.herr@hofr.at>,
       Richard Sandiford <rdsandiford@googlemail.com>,
       David Daney <ddaney@caviumnetworks.com>,
       Adam Nemet <anemet@caviumnetworks.com>,
       Patrik Kluba <kpajko79@gmail.com>,
       Frederic Weisbecker <fweisbec@gmail.com>
In-Reply-To: <1256565667.26028.257.camel@gandalf.stny.rr.com>
References: <cover.1256482555.git.wuzhangjin@gmail.com>
	 <028867b99ec532b84963a35e7d552becc783cafc.1256483735.git.wuzhangjin@gmail.com>
	 <2f73eae542c47ac5bbb9f7280e6c0271d193e90d.1256483735.git.wuzhangjin@gmail.com>
	 <1256565667.26028.257.camel@gandalf.stny.rr.com>
Content-Type: text/plain
Organization: DSLab, Lanzhou University, China
Date: Mon, 26 Oct 2009 22:25:08 +0800
Message-Id: <1256567108.5642.165.camel@falcon>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Mon, 2009-10-26 at 10:01 -0400, Steven Rostedt wrote:
[...]
> Some patches touch core tracing code, and some are arch specific. Now
> the question is how do we go. I prefer that we go the path of the
> tracing tree (easier for me to test).

Just coped with the feedbacks from Frederic Weisbecker.

I will rebase the whole patches to your git repo(the following one?) and
send them out as the -v6 revision:

git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-2.6-trace.git tip/tracing/core

>  But every patch that touches MIPS
> arch, needs an Acked-by from the MIPS maintainer. Which I see is Ralf
> (on the Cc of this patch set.)
> 

Looking forward to the feedback from Ralf, Seems he is a little busy.
and also looking forward to the testing result from the other MIPS
developers, so, we can ensure ftrace for MIPS really function!

Welcome to clone this branch and test it:

git://dev.lemote.com/rt4ls.git  linux-mips/dev/ftrace-upstream

And this document will tell you how to play with it:
Documentation/trace/ftrace.txt

Thanks & Regards,
	Wu Zhangjin

