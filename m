Return-Path: <linux-kernel-owner+w=401wt.eu-S1753103AbXDKPsE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753103AbXDKPsE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2007 11:48:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753109AbXDKPsE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Apr 2007 11:48:04 -0400
Received: from tmailer.gwdg.de ([134.76.10.23]:42949 "EHLO tmailer.gwdg.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753103AbXDKPsB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2007 11:48:01 -0400
Date: Wed, 11 Apr 2007 17:47:45 +0200 (MEST)
From: Jan Engelhardt <jengelh@linux01.gwdg.de>
To: Tom Strader <tom.strader@xilinx.com>
cc: linux-kernel@vger.kernel.org
Subject: Re: kernel space to user space /bin/sh startup
In-Reply-To: <20070410182240.3AFAF590046@mail41-cpk.bigfish.com>
Message-ID: <Pine.LNX.4.61.0704111747140.32056@yvahk01.tjqt.qr>
References: <20070410182240.3AFAF590046@mail41-cpk.bigfish.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Spam-Report: Content analysis: 0.0 points, 6.0 required
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Apr 10 2007 11:22, Tom Strader wrote:

>console::sysinit:/etc/init.d/rcS
>console::respawn:/sbin/getty -L 115200 /dev/ttyS0 vt100

>Now I can type on the console and characters are echoed back, pressing
>ctrl-c echoes: "uart_flush_buffer(0) called" so the code is still
>running, but I am not sure where I am or why I see no login prompt or
>shell command line.
>I never see the "mounting filesystems..." echoed to the screen, but the
>code does not stall and no errors are reported by the kernel.  Any help
>during the transition from init/main.c in kernel space to user space
>would be appreciated, so I could debug this further.
>I have looked around and have not seen a solution for my problem, most
>likely due to the fact that I am not entirely sure what the problem is.

Perhaps your terminal program is set to 9600 bps?



Jan
-- 
