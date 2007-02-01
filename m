Return-Path: <linux-kernel-owner+w=401wt.eu-S1751882AbXBAQDm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751882AbXBAQDm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Feb 2007 11:03:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751877AbXBAQDl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Feb 2007 11:03:41 -0500
Received: from main.gmane.org ([80.91.229.2]:48766 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751882AbXBAQDk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Feb 2007 11:03:40 -0500
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Oleg Verych <olecom@flower.upol.cz>
Subject: Re: PROBLEM: Crash on device_shutdown
Date: Thu, 1 Feb 2007 16:03:12 +0000 (UTC)
Organization: Palacky University in Olomouc, experimental physics department.
Message-ID: <slrnes44am.m64.olecom@flower.upol.cz>
References: <200701290003.50918.julien.rf@no-log.org>
X-Complaints-To: usenet@sea.gmane.org
X-Gmane-NNTP-Posting-Host: flower.upol.cz
Mail-Followup-To: LKML <linux-kernel@vger.kernel.org>, Oleg Verych <olecom@flower.upol.cz>, Julien RF <julien.rf@no-log.org>
User-Agent: slrn/0.9.8.1pl1 (Debian)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> From: Julien RF
> Newsgroups: gmane.linux.kernel
> Subject: PROBLEM: Crash on device_shutdown
> Date: Mon, 29 Jan 2007 00:03:49 +0100
> Archived-At: <http://permalink.gmane.org/gmane.linux.kernel/487140>

Hallo, Julien.

Do you have such problem with more recent kernels, or mm one?

Also, if would be good to have at least some of the stack trace.

You can set up serial console for purpose of logging all information
to remote host.

> One line summary of the problem:
> Crash on device_shutdown
>
>
> Full description of the problem/report:
> When I shut down the system, I get a crash on the device_shutdown function 
> (called by kernel_shutdown_prepare).
> Since the bug happens when the system is almost shutted down, I can't get the 
> log...
> I partially copied it by hand, ask me if you need further details :
> Will now halt.
> BUG: unable to handle kernel NULL pointer dereference at virtual adress 
> 00000128
> ...
> EIP is at device_shutdown + 0x49/0x6c
> ...
> Process halt
> ...
> /etc/rc0.d/S90halt: line 21: 11198 Segmentation fault halt -d -f $shutdown 
> $poweroff $hddown
>
> Julien Richard-Foy

p.s. Please, care to honor "Mail-Followup-To" header information. Thanks.
____

