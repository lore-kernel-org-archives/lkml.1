Return-Path: <linux-kernel-owner+w=401wt.eu-S932359AbXDAFjG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932359AbXDAFjG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Apr 2007 01:39:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932344AbXDAFjF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Apr 2007 01:39:05 -0400
Received: from gw.goop.org ([64.81.55.164]:46961 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932359AbXDAFjE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Apr 2007 01:39:04 -0400
Message-ID: <460F4576.6010904@goop.org>
Date: Sat, 31 Mar 2007 22:39:02 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Adrian Bunk <bunk@stusta.de>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Dave Jones <davej@redhat.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, pavel@suse.cz,
       linux-pm@lists.osdl.org, gregkh@suse.de,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [3/4] 2.6.21-rc5: known regressions (v2)
References: <Pine.LNX.4.64.0703251559560.6730@woody.linux-foundation.org> <20070330213220.GO14134@stusta.de>
In-Reply-To: <20070330213220.GO14134@stusta.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Adrian Bunk wrote:
> Subject    : ThinkPad X60: resume no longer works  (PCI related?)
> References : http://lkml.org/lkml/2007/3/13/3
> Submitter  : Dave Jones <davej@redhat.com>
>              Jeremy Fitzhardinge <jeremy@goop.org>
> Caused-By  : PCI merge
>              commit 78149df6d565c36675463352d0bfe0000b02b7a7
> Handled-By : Eric W. Biederman <ebiederm@xmission.com>
>              Rafael J. Wysocki <rjw@sisk.pl>
> Status     : problem is being debugged
>   

I know this is currently a subject of discussion on lkml, but I wanted
to confirm that booting with "hpet=disable" fixes this, and resume works
for me.  It ends up using acpi_pm as the clocksource.

    J
