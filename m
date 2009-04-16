Return-Path: <linux-kernel-owner+w=401wt.eu-S1753014AbZDPCpv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753014AbZDPCpv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Apr 2009 22:45:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750992AbZDPCpl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Apr 2009 22:45:41 -0400
Received: from gw.goop.org ([64.81.55.164]:60463 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750924AbZDPCpl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Apr 2009 22:45:41 -0400
Message-ID: <49E69BD2.9060509@goop.org>
Date: Wed, 15 Apr 2009 19:45:38 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
CC: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Problem with CREATE_TRACE_POINTS and recursion safety
References: <49E67D1D.8020704@goop.org> <alpine.DEB.2.00.0904152042350.4459@gandalf.stny.rr.com> <49E6847B.9000003@goop.org> <alpine.DEB.2.00.0904152201390.4459@gandalf.stny.rr.com>
In-Reply-To: <alpine.DEB.2.00.0904152201390.4459@gandalf.stny.rr.com>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Steven Rostedt wrote:
> Have you tried:
>
> #ifdef CREATE_PVOPS_TRACE_POINTS
> #define CREATE_TRACE_POINTS
> #include <trace/define_trace.h>
> #undef CREATE_TRACE_POINTS
> #endif
>
> And in your C file do:
>
> #define CREATE_PVOPS_TRACE_POINTS
> #include <trace/pvops.h>
>   

Yes, that's precisely what I do.

    J
