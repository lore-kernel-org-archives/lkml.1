Return-Path: <linux-kernel-owner+w=401wt.eu-S1765691AbYEGWmi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765691AbYEGWmi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2008 18:42:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754731AbYEGWmW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 May 2008 18:42:22 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47351 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752518AbYEGWmT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2008 18:42:19 -0400
Date: Wed, 7 May 2008 15:41:55 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Gabriel C <nix.or.die@googlemail.com>
Cc: linux-kernel@vger.kernel.org, "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: CONFIG_PRINTK_TIME broken on git HEAD ?
Message-Id: <20080507154155.2b472bb1.akpm@linux-foundation.org>
In-Reply-To: <48222C7C.2050807@googlemail.com>
References: <48222C7C.2050807@googlemail.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 08 May 2008 00:26:04 +0200
Gabriel C <nix.or.die@googlemail.com> wrote:

> Hi all,
> 
> I've updated today to 2.6.26-rc1-00166-gc0a1811 , running an 64bit kernel at the moment.

Which kernel were you runing previously?

> dmesg shows here :
> 
> ...
> 
> 
> [    0.000000] Allocating PCI resources starting at d0000000 (gap: cf600000:2f800000)
> [    0.000000] SMP: Allowing 4 CPUs, 0 hotplug CPUs
> [    0.000000] PERCPU: Allocating 42756 bytes of per cpu data
> [    0.000000] NR_CPUS: 8, nr_cpu_ids: 4
> [4294014.506571] Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 1010753
> [4294014.506571] Kernel command line: root=/dev/sdb1 ro debug vga=0x317
> [4294014.506571] Initializing CPU#0
> [4294014.506571] Preemptible RCU implementation.
> [4294014.506571] PID hash table entries: 4096 (order: 12, 32768 bytes) 
> 
> ...                                                                                     
> 
> 
> Is this a known issue ?
> 

Not to me.
