Return-Path: <linux-kernel-owner+akpm=40linux-foundation.org-S1756732AbYLPVn6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756732AbYLPVn6 (ORCPT <rfc822;akpm@linux-foundation.org>);
	Tue, 16 Dec 2008 16:43:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752423AbYLPVns
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Dec 2008 16:43:48 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:52388 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751406AbYLPVnr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2008 16:43:47 -0500
Date: Tue, 16 Dec 2008 16:43:44 -0500 (EST)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: =?ISO-8859-15?Q?Fr=E9d=E9ric_Weisbecker?= <fweisbec@gmail.com>
cc: Ingo Molnar <mingo@elte.hu>, Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] tracing/ftrace: use preempt_enable_no_resched_notrace
 in ring_buffer_time_stamp()
In-Reply-To: <c62985530812161339p6296f032rdc3c74650331f3d8@mail.gmail.com>
Message-ID: <alpine.DEB.1.10.0812161642530.25356@gandalf.stny.rr.com>
References: <494818EA.7080807@gmail.com> <20081216212028.GP14787@elte.hu> <c62985530812161339p6296f032rdc3c74650331f3d8@mail.gmail.com>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 16 Dec 2008, Fr?d?ric Weisbecker wrote:
> 
> The hard reboots I've seen are related to x86-64 while
> disabling/reenabling a CPU through /sys/device/system/cpu
> No tracer was enabled at these times (the problem still remains with
> latest updates on -tip for half an hour).

Do you have STACK_TRACER enabled?

-- Steve
