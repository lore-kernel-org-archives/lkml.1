Return-Path: <linux-kernel-owner+w=401wt.eu-S932476AbXJLKAp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932476AbXJLKAp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Oct 2007 06:00:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759145AbXJLKAg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Oct 2007 06:00:36 -0400
Received: from mail.gmx.net ([213.165.64.20]:59251 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1756861AbXJLKAf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Oct 2007 06:00:35 -0400
X-Authenticated: #5039886
X-Provags-ID: V01U2FsdGVkX19H33xQVDVHq7rflWqxzhWY5YTHbXXQbcAacODUA9
	6ghyJlNzdQygnW
Date: Fri, 12 Oct 2007 12:00:43 +0200
From: =?iso-8859-1?Q?Bj=F6rn?= Steinbrink <B.Steinbrink@gmx.de>
To: John Sigler <linux.kernel@free.fr>
Cc: linux-kernel@vger.kernel.org, linux-rt-users@vger.kernel.org
Subject: Re: NMI watchdog
Message-ID: <20071012100043.GA28777@atjola.homenet>
References: <470F3BE0.4050807@free.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <470F3BE0.4050807@free.fr>
User-Agent: Mutt/1.5.16 (2007-06-11)
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 2007.10.12 11:18:24 +0200, John Sigler wrote:
> Hello,
>
> I'm experiencing a full system lockup. I'm using an out-of-tree driver 
> which I suspect is responsible. I'm trying to enable the NMI watchdog.
>
> # cat /proc/version
> Linux version 2.6.22.1-rt9 (gcc version 3.4.6) #1 PREEMPT RT Tue Oct 9 
> 12:25:47 CEST 2007
>
> # cat /proc/cmdline
> ro root=/dev/hdc1 console=ttyS0,57600n8 console=tty0 panic=3 apic=debug 
> nmi_watchdog=2
>
> However, after boot, the NMI count does not change.
>
> # cat /proc/interrupts ; sleep 10 ; cat /proc/interrupts

Try running some cpu hog in the background. The performance counters get
increased only when the CPU is actually doing something. On a mostly
idle system, it can take quite a while for the next NMI to show up.

Björn
