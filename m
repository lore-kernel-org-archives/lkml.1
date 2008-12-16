Return-Path: <linux-kernel-owner+akpm=40linux-foundation.org-S1758546AbYLPVzq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758546AbYLPVzq (ORCPT <rfc822;akpm@linux-foundation.org>);
	Tue, 16 Dec 2008 16:55:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752360AbYLPVzf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Dec 2008 16:55:35 -0500
Received: from qw-out-2122.google.com ([74.125.92.24]:57372 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750967AbYLPVzf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2008 16:55:35 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=vnLK5z1VByf2HRq7GTmikjjx7fZSsIVnUXym94SmWooCE3W8K7coZ6Mm8lIpP9+5Sc
         smKvBSaCY9wjgLsD/Pu5D9Y8AsWsakz3BoyUh4jukAQfnKFf8tDRYXZtJEMDwiQQn6SI
         IwZjzDCF3jR8HiB9sNfLsdn2ppaT9IMzS7nI4=
Message-ID: <c62985530812161355l11edbb9cg6dd4e7e4291ab7b@mail.gmail.com>
Date: Tue, 16 Dec 2008 22:55:34 +0100
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

You were right. I've just built a kernel without STACK_TRACER and the
problem disappears...
