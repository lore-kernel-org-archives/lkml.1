Return-Path: <linux-kernel-owner+w=401wt.eu-S1762105AbYCDF1G@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762105AbYCDF1G (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2008 00:27:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752324AbYCDF0v
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Mar 2008 00:26:51 -0500
Received: from smtp-out.google.com ([216.239.45.13]:37915 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755658AbYCDF0u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2008 00:26:50 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:message-id:date:from:to:subject:cc:in-reply-to:
	mime-version:content-type:content-transfer-encoding:
	content-disposition:references;
	b=J2vAkJugeM30nvnDGL7EF1Y8rXr3MhgIyBxOqEkprYHE+IqNZ6EV3unzglnsb4qmP
	5+RRY6KreLF5MLlyIq34A==
Message-ID: <6599ad830803032126m39935eaeu1df67d6263e8e123@mail.gmail.com>
Date: Mon, 3 Mar 2008 21:26:42 -0800
From: "Paul Menage" <menage@google.com>
To: "Paul Jackson" <pj@sgi.com>
Subject: Re: [RFC/PATCH] cpuset: cpuset irq affinities
Cc: a.p.zijlstra@chello.nl, maxk@qualcomm.com, mingo@elte.hu,
       tglx@linutronix.de, oleg@tv-sign.ru, rostedt@goodmis.org,
       linux-kernel@vger.kernel.org, rientjes@google.com
In-Reply-To: <20080303125253.5d2d580c.pj@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080227222103.673194000@chello.nl>
	 <47C87084.3090208@qualcomm.com> <1204318980.6243.133.camel@lappy>
	 <47C8771C.1070001@qualcomm.com> <1204545445.11412.6.camel@twins>
	 <20080303113621.1dfdda87.pj@sgi.com> <1204567052.6241.4.camel@lappy>
	 <20080303121033.c8c9651c.pj@sgi.com>
	 <6599ad830803031041r6c635141n6520a915f2e1d08@mail.gmail.com>
	 <20080303125253.5d2d580c.pj@sgi.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 3, 2008 at 10:52 AM, Paul Jackson <pj@sgi.com> wrote:
> Paul M wrote:
>  > It ... would allow memory and CPU assignments to be controlled
>  > independently.
>
>  Could you motivate this suggestion -- who needs it, or why
>  would is it needed?

My impression was that Peter wanted to be able to control the
assignments of CPUs to IRQs in a way that could result in overlapping.
One of the arguments that you posted against his proposal was that
this would break due to the memory overlap requirements of
mem_exclusive cpusets. So this appeared to be a case where the fact
that memory and cpu masks are combined in the same cgroups subsystem
is a drawback. (But maybe I'm misunderstanding the discussion).

I'm sure if cpusets were being developed today on top of cgroups,
rather than being its inspiration, there would be no good reason to
have the memory mask assignment and the cpu mask assignment be part of
the same subsystem - they're only together now because there was no
general grouping mechanism in the kernel when cpusets was written.

Paul
