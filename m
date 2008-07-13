Return-Path: <linux-kernel-owner+w=401wt.eu-S1756062AbYGMTr1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756062AbYGMTr1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Jul 2008 15:47:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754551AbYGMTrT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Jul 2008 15:47:19 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53538 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753542AbYGMTrS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Jul 2008 15:47:18 -0400
Date: Sun, 13 Jul 2008 12:47:05 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Adrian Bunk <bunk@kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Natalie Protasevich <protasnb@gmail.com>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Alan Stern <stern@rowland.harvard.edu>, Greg KH <greg@kroah.com>
Subject: Re: 2.6.26-rc9-git12: Reported regressions from 2.6.25
In-Reply-To: <Y1jK9GMA8kJ.A.qOH.7GleIB@albercik>
Message-ID: <alpine.LFD.1.10.0807131230130.2959@woody.linux-foundation.org>
References: <Y1jK9GMA8kJ.A.qOH.7GleIB@albercik>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Sun, 13 Jul 2008, Rafael J. Wysocki wrote:
> 
> Regressions with patches
> ------------------------
> 
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11072
> Subject		: scsi-layer crash after usb storage device unplug
> Submitter	: Johannes Berg <johannes@sipsolutions.net>
> Date		: 2008-07-12 01:50 (2 days old)
> Handled-By	: Alan Stern <stern@rowland.harvard.edu>
> Patch		: http://bugzilla.kernel.org/show_bug.cgi?id=11072#c3

Alan, Greg?

> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11057
> Subject		: vbetest fails on 2.6.26-rc9
> Submitter	: PaX Team <pageexec@freemail.hu>
> Date		: 2008-07-08 19:46 (6 days old)
> Handled-By	: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
> Patch		: http://bugzilla.kernel.org/attachment.cgi?id=16792&action=view

Merged as commit a361ee5cb8011763ece7b4add393e206439db8b3.

> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11024
> Subject		: 2.6.25 to 2.6.26-rc8 regression (related to ahci and acpi _GTF)
> Submitter	: Mathieu Bérard <Mathieu.Berard@crans.org>
> Date		: 2008-07-01 9:39 (13 days old)
> References	: http://marc.info/?t=121490593600001&r=1&w=4
> Handled-By	: Tejun Heo <htejun@gmail.com>
> Patch		: http://marc.info/?l=linux-kernel&m=121514631317343&w=4

Merged as commit b344991ace21896a83694c86d132b8494a29f3be.

> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10957
> Subject		: pata_pcmcia with Sandisk Extreme III 8GB
> Submitter	: Komuro <komurojun-mbn@nifty.com>
> Date		: 2008-06-07 13:37 (37 days old)
> References	: http://marc.info/?l=linux-kernel&m=121284627119861&w=4
> Handled-By	: Tejun Heo <htejun@gmail.com>
> 		  Dominik Brodowski <linux@dominikbrodowski.net>
> 		  Komuro <komurojun-mbn@nifty.com>
> Patch		: http://marc.info/?l=linux-kernel&m=121530861605673&w=4

This patch is disputed. See the rest of the thread. Maybe some subtle 
timing detail?

> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10862
> Subject		: forcedeth: lockdep warning on ethtool -s
> Submitter	: Tobias Diedrich <ranma+kernel@tdiedrich.de>
> Date		: 2008-06-01 8:37 (43 days old)
> References	: http://marc.info/?l=linux-kernel&m=121230964032247&w=4
> Handled-By	: Tobias Diedrich <ranma+kernel@tdiedrich.de>
> Patch		: http://lkml.org/lkml/2008/6/15/120

Commit 97bff0953dd45a633fa69e1a650d612f5610a60b.

> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10725
> Subject		: USB Mass storage mount fails: Write protect on
> Submitter	: Maciej Rutecki <maciej.rutecki@gmail.com>
> Date		: 2008-05-16 14:55 (59 days old)
> References	: http://marc.info/?l=linux-kernel&m=121095168003572&w=4
> Handled-By	: Alan Stern <stern@rowland.harvard.edu>
> Patch		: http://marc.info/?l=linux-scsi&m=121433068314568&w=2

Commit bdb2b8cab4392ce41ddfbd6773a3da3334daf836.

			Linus
