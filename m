Return-Path: <linux-kernel-owner+w=401wt.eu-S1755315AbZINLff@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755315AbZINLff (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Sep 2009 07:35:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755287AbZINLfe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Sep 2009 07:35:34 -0400
Received: from mail.gmx.net ([213.165.64.20]:55427 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1755260AbZINLfd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Sep 2009 07:35:33 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX19OO3kIUl1On4KuBhz5tqloPziP7C9+o/+t6ygspN
	uCHi/dOY5KueTf
Subject: Re: Phoronix CFS vs BFS bencharks
From: Mike Galbraith <efault@gmx.de>
To: Nikos Chantziaras <realnc@arcor.de>
Cc: Ingo Molnar <mingo@elte.hu>, Con Kolivas <kernel@kolivas.org>,
       linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>
In-Reply-To: <4AAE10E6.2050403@arcor.de>
References: <20090906205952.GA6516@elte.hu>  <4AAE10E6.2050403@arcor.de>
Content-Type: text/plain
Date: Mon, 14 Sep 2009 13:35:33 +0200
Message-Id: <1252928133.22740.37.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1.1 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.57
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-09-14 at 12:46 +0300, Nikos Chantziaras wrote:
> Phoronix has published some benchmarks, including some "non-synthetic" 
> real-life applications:
> 
>    http://www.phoronix.com/vr.php?view=14179
> 
> The benchmarks are:
> 
>   * World of Padman
>   * Timed Apache Compilation
>   * Timed PHP Compilation
>   * 7-Zip Compression
>   * GraphicsMagick
>   * Apache Benchmark
>   * Threaded I/O Tester
>   * PostMark
> 
> The test was performed on an Ubuntu 9.10 daily snapshot from 2009-09-10 
> with the GNOME 2.27.91 desktop, X Server 1.6.3, NVIDIA 190.32 display 
> driver, GCC 4.4.1, and an EXT4 file-system.

Interesting results.

It'd be nice to see what difference the changes since .31 have made to
these comparisons.  In particular, child_runs_first was found to have a
substantial negative impact on parallel compiles, and has been turned
off.  The reduction of sched_latency has a rather large effect on worst
case latency for CPU hogs, so will likely affect some results markedly.

Hohum, back to the grindstone.

	-Mike

