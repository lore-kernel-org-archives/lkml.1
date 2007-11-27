Return-Path: <linux-kernel-owner+w=401wt.eu-S1758576AbXK0AXT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758576AbXK0AXT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2007 19:23:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755897AbXK0AXI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Nov 2007 19:23:08 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.31.123]:52962 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755808AbXK0AXG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2007 19:23:06 -0500
Date: Tue, 27 Nov 2007 01:23:39 +0100
From: Pavel Machek <pavel@ucw.cz>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: pm list <linux-pm@lists.linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 6/6] Hibernation: Move extern definition to header file
Message-ID: <20071127002339.GE9759@elf.ucw.cz>
References: <200711270025.08128.rjw@sisk.pl> <200711270033.04999.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200711270033.04999.rjw@sisk.pl>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> From: Rafael J. Wysocki <rjw@sisk.pl>
> 
> Move the extern definition of resume_file[] from kernel/power/swap.c
> to kernel/power/power.h .
> 
> Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>

can we just get rid of extern? It does not seem to be used. (at least
in very quick grep over 2.6.24-rc3):

pavel@amd:/data/l/linux/kernel/power$ grep resume_file *.c
disk.c:char resume_file[256] = CONFIG_PM_STD_PARTITION;
disk.c:         if (!strlen(resume_file)) {
disk.c:         swsusp_resume_device = name_to_dev_t(resume_file);
disk.c:         pr_debug("swsusp: Resume From Partition %s\n",
resume_file);
disk.c: strncpy( resume_file, str, 255 );
swap.c:extern char resume_file[];
pavel@amd:/data/l/linux/kernel/power$

								Pavel

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
