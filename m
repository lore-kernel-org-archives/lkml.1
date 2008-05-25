Return-Path: <linux-kernel-owner+w=401wt.eu-S1759339AbYEYLgu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759339AbYEYLgu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 May 2008 07:36:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754866AbYEYLgn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 May 2008 07:36:43 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:63485 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754863AbYEYLgm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 May 2008 07:36:42 -0400
Date: Sun, 25 May 2008 07:36:39 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: trem <tremyfr@yahoo.fr>
cc: linux-rt-users@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: 2.6.24.7-rt10
In-Reply-To: <g1adb2$217$1@ger.gmane.org>
Message-ID: <Pine.LNX.4.58.0805250735410.3977@gandalf.stny.rr.com>
References: <1211608265.14697.105.camel@localhost.localdomain>
 <g1adb2$217$1@ger.gmane.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Sun, 25 May 2008, trem wrote:
>
> I've got a problem with the compilation when compiling kernel/rcupreempt_trace.o :
>
> kernel/rcupreempt_trace.c: In function ?rcupreempt_trace_init?:
> kernel/rcupreempt_trace.c:539: erreur: implicit declaration of function ?marker_arm?
> kernel/rcupreempt_trace.c: In function ?rcupreempt_trace_cleanup?:
> kernel/rcupreempt_trace.c:577: erreur: too few arguments to function ?marker_probe_unregister?
> kernel/rcupreempt_trace.c:583: erreur: too few arguments to function ?marker_probe_unregister?
> make[1]: *** [kernel/rcupreempt_trace.o] Erreur 1
>
>
> I think that markers-upstream.patch can't be used with rcu-preempt-trace-markers-1.patch and
> rcu-preempt-trace-markers-2.patch.
>

Or more correctly, the rcu-preempt-markers patches can't be used with
markers-upstream.patch ;-)

I'll port that over, since it will need to be ported anyway.

-- Steve

