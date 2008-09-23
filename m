Return-Path: <linux-kernel-owner+w=401wt.eu-S1753944AbYIWBWd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753944AbYIWBWd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2008 21:22:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754713AbYIWBWV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Sep 2008 21:22:21 -0400
Received: from tomts10.bellnexxia.net ([209.226.175.54]:40882 "EHLO
	tomts10-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753861AbYIWBWV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2008 21:22:21 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AqEEANvd10hMQWq+/2dsb2JhbACBXbUZgWY
Date: Mon, 22 Sep 2008 21:22:19 -0400
From: Mathieu Desnoyers <compudj@krystal.dyndns.org>
To: "Frank Ch. Eigler" <fche@redhat.com>
Cc: Paul Mundt <lethal@linux-sh.org>, linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Roland McGrath <roland@redhat.com>
Subject: Re: [PATCH] [RFC] tracehook: Hook in syscall tracing markers.
Message-ID: <20080923012219.GB24937@Krystal>
References: <20080921021630.GA6443@linux-sh.org> <20080922012841.GA6199@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <20080922012841.GA6199@redhat.com>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 21:20:41 up 110 days,  6:01,  7 users,  load average: 0.67, 0.47,
	0.31
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Frank Ch. Eigler (fche@redhat.com) wrote:
> Hi -
> 
> > At kernel summit, the idea that syscall tracing was generally desirable
> > for tracing was mentioned several times, as was the argument that kernel
> > developers aren't placing markers in meaningful locations. This is a
> > simple patch to try and do that for the syscall case.[...]
> 
> One problem with this is that a separate mechanism would be needed to
> activate these tracehook_report_* calls in the first place: the
> management of the per-task TIF_SYSCALL_TRACE flag.  This is one of the
> things the utrace API makes straightforward, in which case its own
> native syscall reporting callbacks can be used directly.
> 
> - FChE
> 

There is already a series of patches in the -lttng tree which adds
TIF_KERNEL_TRACE to every architecture. It basically enables syscall
tracing for every threads running on the system.

It't the best way I found to do system-wide syscall tracing without
changing anything of the assembly code except adding one flag to the
tested flags.

Mathieu


-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
