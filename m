Return-Path: <linux-kernel-owner+w=401wt.eu-S1762952AbXK2M6k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762952AbXK2M6k (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2007 07:58:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755099AbXK2M6d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Nov 2007 07:58:33 -0500
Received: from astoria.ccjclearline.com ([64.235.106.9]:44770 "EHLO
	astoria.ccjclearline.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754684AbXK2M6c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2007 07:58:32 -0500
Date: Thu, 29 Nov 2007 07:58:29 -0500 (EST)
From: "Robert P. J. Day" <rpjday@crashcourse.ca>
X-X-Sender: rpjday@localhost.localdomain
To: Alexey Dobriyan <adobriyan@gmail.com>
cc: linux-kernel@vger.kernel.org
Subject: Re: does /proc/sys/kernel/modprobe actually do anything?
In-Reply-To: <b6fcc0a0711290207jf82e618uccecf922a22c4f33@mail.gmail.com>
Message-ID: <alpine.LFD.0.9999.0711290756090.29674@localhost.localdomain>
References: <alpine.LFD.0.9999.0711290438060.13461@localhost.localdomain> <b6fcc0a0711290207jf82e618uccecf922a22c4f33@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - astoria.ccjclearline.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - crashcourse.ca
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 29 Nov 2007, Alexey Dobriyan wrote:

> On 11/29/07, Robert P. J. Day <rpjday@crashcourse.ca> wrote:
> > echo '#! /bin/sh' > /tmp/modprobe
> > echo 'echo "$@" >> /tmp/modprobe.log' >> /tmp/modprobe
> > echo 'exec /sbin/modprobe "$@"' >> /tmp/modprobe
> > chmod a+x /tmp/modprobe
> > echo /tmp/modprobe > /proc/sys/kernel/modprobe
> >
> >   i've tried that and i don't see that it does anything whatsoever.  i
> > ran modprobe under "strace" and it doesn't appear to make any effort
> > to check /proc/sys/kernel/modprobe.
>
> Kernel, not modprobe, checks /proc/sys/kernel/modprobe .

actually, ignore that earlier query of mine, i've found the relevant
code under kernel/ in sysctl.c and sysctl_check.c and kmod.c.  but
it's still not clear why what is described in
Documentation/debugging-modules.txt (and shown above) doesn't work, so
i'm still open to suggestions.  thanks.

rday
========================================================================
Robert P. J. Day
Linux Consulting, Training and Annoying Kernel Pedantry
Waterloo, Ontario, CANADA

http://crashcourse.ca
========================================================================
