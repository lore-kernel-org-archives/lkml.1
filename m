Return-Path: <linux-kernel-owner+w=401wt.eu-S1755464AbZHYRhm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755464AbZHYRhm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Aug 2009 13:37:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755424AbZHYRhl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Aug 2009 13:37:41 -0400
Received: from relais.videotron.ca ([24.201.245.36]:54016 "EHLO
	relais.videotron.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755401AbZHYRhl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Aug 2009 13:37:41 -0400
Date: Tue, 25 Aug 2009 13:37:37 -0400 (EDT)
From: Nicolas Pitre <nico@cam.org>
Subject: Re: ARM + jprobes/kretprobes SEGV/hangs/OOPS in 2.6.29 kernel
In-reply-to: <6d53329e0908250342g2cfb73f6v90f73c283c0d391c@mail.gmail.com>
X-X-Sender: nico@xanadu.home
To: venki kaps <venkiece2005@gmail.com>
Cc: "sagar.abhishek@gmail.com" <sagar.abhishek@gmail.com>,
       "jkenisto@us.ibm.com" <jkenisto@us.ibm.com>,
       "rmk+kernel@arm.linux.org.uk" <rmk+kernel@arm.linux.org.uk>,
       "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
       "linux-arm@vger.kernel.org" <linux-arm@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "prasanna@in.ibm.com" <prasanna@in.ibm.com>
Message-id: <alpine.LFD.2.00.0908251333410.6044@xanadu.home>
MIME-version: 1.0
Content-type: TEXT/PLAIN; charset=US-ASCII
Content-transfer-encoding: 7BIT
References: <6d53329e0908250342g2cfb73f6v90f73c283c0d391c@mail.gmail.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 25 Aug 2009, venki kaps wrote:

> Hi,
> 
> I have been tracing kernel system call information using
> the Kprobes/jprobes/kretprobes implementation in the 2.6.29 kernel on
> ARM architecture.
> Although the mainline kprobe/jprobe/kretprobe examples are working
> fine (do_fork),
> I have been facing some issues while running my own jprobe/kretprobe tests.
> 
[...]
> 
> Query:
> =====
> 	- Are there any limitations for jptobes/kretporbes in mainline kernel for ARM?

No limitation in particular that I know of.

> 	- Why it works for only do_fork and why not for others
> (do_execve/sys_open/sys_close/sys_read/sys_write)?

I don't know.  Will try to have a look.

> 	- Is it required any additional setup to achieve this?

Not supposed to need anything special.


Nicolas
