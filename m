Return-Path: <linux-kernel-owner+w=401wt.eu-S1756123AbZCGSV1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756123AbZCGSV1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Mar 2009 13:21:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751438AbZCGSVR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Mar 2009 13:21:17 -0500
Received: from e28smtp04.in.ibm.com ([59.145.155.4]:42248 "EHLO
	e28smtp04.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755750AbZCGSVQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Mar 2009 13:21:16 -0500
Date: Sat, 7 Mar 2009 23:51:06 +0530
From: "K.Prasad" <prasad@linux.vnet.ibm.com>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: mingo@elte.hu, Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Alan Stern <stern@rowland.harvard.edu>,
       Roland McGrath <roland@redhat.com>
Subject: Re: [Patch 11/11] ftrace plugin for kernel symbol tracing using HW
	Breakpoint interfaces - v2
Message-ID: <20090307182106.GA7524@in.ibm.com>
Reply-To: prasad@linux.vnet.ibm.com
References: <20090307045120.039324630@linux.vnet.ibm.com> <20090307050747.GL23959@in.ibm.com> <20090307222955.25A7.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090307222955.25A7.A69D9226@jp.fujitsu.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 07, 2009 at 11:53:46PM +0900, KOSAKI Motohiro wrote:
> Hi
> 
> > This patch adds an ftrace plugin to detect and profile memory access over
> > kernel variables. It uses HW Breakpoint interfaces to 'watch memory
> > addresses.
> > 
> > Signed-off-by: K.Prasad <prasad@linux.vnet.ibm.com> 
> > ---
> >  kernel/trace/Kconfig          |    6 
> >  kernel/trace/Makefile         |    1 
> >  kernel/trace/trace.h          |   16 +
> >  kernel/trace/trace_ksym.c     |  448 ++++++++++++++++++++++++++++++++++++++++++
> >  kernel/trace/trace_selftest.c |   36 +++
> >  5 files changed, 507 insertions(+)
> 
> Could you please update Documentation/ftrace.txt?
> I guess many user interesting this patch. :)
>

Sure. We have plans for a documentation file for the hardware breakpoint
interfaces (something like Documentation/hw_breakpoint.txt). I shall
update the Documentation/ftrace.txt with usage details for the kernel
symbol tracing plugin along with them.

Thanks,
K.Prasad
 
