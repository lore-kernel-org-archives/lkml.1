Return-Path: <linux-kernel-owner+w=401wt.eu-S1161152AbXDTE5P@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161152AbXDTE5P (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Apr 2007 00:57:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161155AbXDTE5P
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Apr 2007 00:57:15 -0400
Received: from gw.goop.org ([64.81.55.164]:60464 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161152AbXDTE5O (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Apr 2007 00:57:14 -0400
Message-ID: <4628482B.6040804@goop.org>
Date: Thu, 19 Apr 2007 21:57:15 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Adrian Bunk <bunk@stusta.de>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, pavel@suse.cz,
       linux-pm@lists.osdl.org, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@elte.hu>, Dave Jones <davej@redhat.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, gregkh@suse.de
Subject: Re: [2/2] 2.6.21-rc7: known regressions
References: <Pine.LNX.4.64.0704151659570.5473@woody.linux-foundation.org> <20070416003723.GM3691@stusta.de>
In-Reply-To: <20070416003723.GM3691@stusta.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Adrian Bunk wrote:
> Subject    : ThinkPad X60: resume no longer works  (PCI related?)
>              workaround: booting with "hpet=disable"
> References : http://lkml.org/lkml/2007/3/13/3
> Submitter  : Dave Jones <davej@redhat.com>
>              Jeremy Fitzhardinge <jeremy@goop.org>
> Caused-By  : PCI merge
>              commit 78149df6d565c36675463352d0bfe0000b02b7a7
> Handled-By : Eric W. Biederman <ebiederm@xmission.com>
>              Rafael J. Wysocki <rjw@sisk.pl>
> Status     : unknown
>   

OK. 2.6.21-rc7 suspend/resume works perfectly for me.  It's the first
kernel version in a long time.  I have no workarounds or special boot
options.  It's using hpet as the clocksource.

    J
