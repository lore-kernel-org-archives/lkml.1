Return-Path: <linux-kernel-owner+akpm=40linux-foundation.org-S1756914AbYLPVsT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756914AbYLPVsT (ORCPT <rfc822;akpm@linux-foundation.org>);
	Tue, 16 Dec 2008 16:48:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751700AbYLPVsF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Dec 2008 16:48:05 -0500
Received: from qw-out-2122.google.com ([74.125.92.26]:60949 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751406AbYLPVsD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2008 16:48:03 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=B7uLcSYxrZmV1h2HxMJS3yCEKuRuzFSM2zhjqlM2ifu/O6OC5sQjQ9+n1CNJ1+AGnB
         3H6AOcuZGJTzNZ8EJ0AKMlNRDZowb+YopQ7MxgbPzjdKDqH07YMz+ZVi4UD7yDLv8I5D
         8RW66ohmFtkAPLFh6GWyJAuBqETJ/LDlICIO8=
Message-ID: <c62985530812161348g672dd67fm18d256b6ff4334d6@mail.gmail.com>
Date: Tue, 16 Dec 2008 22:48:01 +0100
From: "=?ISO-8859-1?Q?Fr=E9d=E9ric_Weisbecker?=" <fweisbec@gmail.com>
To: "Steven Rostedt" <rostedt@goodmis.org>
Subject: Re: [PATCH] tracing/ftrace: use preempt_enable_no_resched_notrace in ring_buffer_time_stamp()
Cc: "Ingo Molnar" <mingo@elte.hu>,
        "Linux Kernel" <linux-kernel@vger.kernel.org>
In-Reply-To: <alpine.DEB.1.10.0812161642530.25356@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <494818EA.7080807@gmail.com> <20081216212028.GP14787@elte.hu>
	 <c62985530812161339p6296f032rdc3c74650331f3d8@mail.gmail.com>
	 <alpine.DEB.1.10.0812161642530.25356@gandalf.stny.rr.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2008/12/16 Steven Rostedt <rostedt@goodmis.org>:
>
>
> On Tue, 16 Dec 2008, Fr?d?ric Weisbecker wrote:
>>
>> The hard reboots I've seen are related to x86-64 while
>> disabling/reenabling a CPU through /sys/device/system/cpu
>> No tracer was enabled at these times (the problem still remains with
>> latest updates on -tip for half an hour).
>
> Do you have STACK_TRACER enabled?
>
> -- Steve
>

Yes. Do you think the origin comes from the fact that ftrace is
running with stack tracer?
