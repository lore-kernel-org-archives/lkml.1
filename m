Return-Path: <linux-kernel-owner+w=401wt.eu-S1759834AbXHFB3E@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759834AbXHFB3E (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Aug 2007 21:29:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752731AbXHFB2x
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 5 Aug 2007 21:28:53 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:60270 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752024AbXHFB2x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Aug 2007 21:28:53 -0400
Date: Sun, 5 Aug 2007 18:28:11 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Dimitrios Apostolou <jimis@gmx.net>
Cc: linux-kernel@vger.kernel.org
Subject: Re: high system cpu load during intense disk i/o
Message-Id: <20070805182811.a8992126.akpm@linux-foundation.org>
In-Reply-To: <200708051903.12414.jimis@gmx.net>
References: <200708031903.10063.jimis@gmx.net>
	<200708051903.12414.jimis@gmx.net>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 5 Aug 2007 19:03:12 +0300 Dimitrios Apostolou <jimis@gmx.net> wrote:

> was my report so complicated?

We're bad.

Seems that your context switch rate when running two instances of
badblocks against two different disks went batshit insane.  It doesn't
happen here.

Please capture the `vmstat 1' output while running the problematic
workload.

The oom-killing could have been unrelated to the CPU load problem.  iirc
badblocks uses a lot of memory, so it might have been genuine.  Keep an eye
on the /proc/meminfo output and send the kernel dmesg output from the
oom-killing event.
