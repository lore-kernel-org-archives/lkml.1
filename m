Return-Path: <linux-kernel-owner+w=401wt.eu-S933193AbZAQXnA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933193AbZAQXnA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Jan 2009 18:43:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763257AbZAQXmv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Jan 2009 18:42:51 -0500
Received: from mtagate7.de.ibm.com ([195.212.29.156]:62566 "EHLO
	mtagate7.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763013AbZAQXmu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Jan 2009 18:42:50 -0500
From: Christian Borntraeger <borntraeger@de.ibm.com>
To: Mike Travis <travis@sgi.com>
Subject: Re: 2.6.29-rc1: [SOLVED] thinkpad problems during resume
Date: Sun, 18 Jan 2009 00:42:40 +0100
User-Agent: KMail/1.9.9
Cc: Pavel Machek <pavel@suse.cz>, Jeff Chua <jeff.chua.linux@gmail.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       kernel list <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>
References: <20090113081316.GA2292@elf.ucw.cz> <200901171648.34155.borntraeger@de.ibm.com> <49723602.4090202@sgi.com>
In-Reply-To: <49723602.4090202@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200901180042.40284.borntraeger@de.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Could you try one more experiment?  With your working system, please cherry
> pick these commits and try it again?
>
> 68564a4... work_on_cpu: don't try to get_online_cpus() in work_on_cpu.
> e1d9ec6... work_on_cpu: Use our own workqueue.
> 6eb714c... cpufreq: use work_on_cpu in acpi-cpufreq.c for drv_read and
> drv_write
>
> From
> git://git.kernel.org/pub/scm/linux/kernel/git/travis/linux-2.6-cpus4096-for
>-ingo.git
>
> If that works, then try and un-revert e39ad415ac and see if it's fixed as
> well?

Yes that works.

29-rc2 + your 3 patches cherry-picked + revert of 
a0d4922da2e4ccb0973095d8d29f36f6b1b5f703( usb problem) can suspend/resume. 
If you like, you can add an
Tested-by: Christian Borntraeger <borntraeger@de.ibm.com>
to your three patches.

Christian

