Return-Path: <linux-kernel-owner+w=401wt.eu-S1754841AbYGKSb6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754841AbYGKSb6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2008 14:31:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752704AbYGKSbu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Jul 2008 14:31:50 -0400
Received: from tomts43.bellnexxia.net ([209.226.175.110]:51410 "EHLO
	tomts43-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752289AbYGKSbt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2008 14:31:49 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AlIGACQ+d0hMRKxB/2dsb2JhbACBW64c
Date: Fri, 11 Jul 2008 14:31:46 -0400
From: Mathieu Desnoyers <compudj@krystal.dyndns.org>
To: ltt-dev@lists.casi.polymtl.ca
Cc: linux-kernel@vger.kernel.org
Subject: Re: [ltt-dev] LTTng 0.10-pre58 for linux 2.6.26-rc9 (with
	userspace tracing for x86)
Message-ID: <20080711183145.GA23053@Krystal>
References: <20080711151905.GA13558@Krystal>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <20080711151905.GA13558@Krystal>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 14:31:17 up 36 days, 23:12,  5 users,  load average: 0.62, 0.66,
	1.02
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

LTTng 0.10-pre58 fixes tracepoint probe build in some configurations and
x86 arch-specific irq instrumentation.

Mathieu

* Mathieu Desnoyers (compudj@krystal.dyndns.org) wrote:
> Hi,
> 
> Here is a new release of LTTng for the 2.6.26-rc9 kernel, which
> introduces :
> 
> - The tracepoints infrastructure.
> - Architecture independent markers converted to tracepoints.
> - Re-introduction of userspace tracing, only for x86 for now. Allows to
>   do boot-time tracing (such as tracing the init process). Adds 2 system
>   calls : sys_marker (marker registration) and sys_trace (tracing per
>   se). The type support is currently limited : strings are formatted in
>   userspace and sent to the kernel for logging under the event
>   "userspace_string". I am doing this simple implementation to get the
>   feature in until I have time to think more carefully about namespacing
>   issues, typing and 32/64 bits processes in 64 bits architectures.
> 
> Please consider this last feature experimental. Review and testing is
> welcome. The userspace linker script and library needed to perform
> userspace tracing, as well as some sample code and Makefile, are
> available in the svn repository at
> 
> http://ltt.polymtl.ca/svn/markers-userspace/
> 
> Ports of the linker script, kernel-api.h (which should be
> per-architecture) and of markers-userspace-x86.patch to other
> architectures are welcome.
> 
> As always, please follow the compatibility list and the quickstart guide
> located at :
> 
> http://ltt.polymtl.ca/svn/ltt/branches/poly/doc/developer/lttng-lttv-compatibility.html
> 
> http://ltt.polymtl.ca/svn/ltt/branches/poly/QUICKSTART
> 
> Mathieu
> 
> -- 
> Mathieu Desnoyers
> OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
> 
> _______________________________________________
> ltt-dev mailing list
> ltt-dev@lists.casi.polymtl.ca
> http://lists.casi.polymtl.ca/cgi-bin/mailman/listinfo/ltt-dev
> 

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
