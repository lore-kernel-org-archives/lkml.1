Return-Path: <linux-kernel-owner+w=401wt.eu-S1758233AbYDJT7S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758233AbYDJT7S (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Apr 2008 15:59:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754605AbYDJT7I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Apr 2008 15:59:08 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:49777 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754159AbYDJT7H (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Apr 2008 15:59:07 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Ingo Molnar <mingo@elte.hu>
Subject: x86 git tree broken
Date: Thu, 10 Apr 2008 21:59:13 +0200
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, Pavel Machek <pavel@ucw.cz>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Anvin" <hpa@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200804102159.14563.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

The x86 git tree, as of HEAD commit

commit a9efd1225e6e0e78ceeaecc04cec1d428eb8173f
Author: Mike Travis <travis@sgi.com>
Date:   Fri Apr 4 18:30:16 2008 -0700

    x86: modify Kconfig to allow up to 4096 cpus

doesn't want to work on one of my testboxes (x86-64 desktop,
AMD-based).

First, the X server doesn't want to start (it says it couldn't mmap the
framebuffer).

Second, if I try to suspend the box to RAM, it enters a state it cannot
leave until power is physically cut from it (using the power button to power
off / power on the box doesn't help).

At the same time, 2.6.25-rc8-mm1 works just fine on this box.

Any ideas what to revert?

Thanks,
Rafael
