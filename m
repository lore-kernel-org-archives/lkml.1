Return-Path: <linux-kernel-owner+w=401wt.eu-S1757224AbYGJPFf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757224AbYGJPFf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2008 11:05:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758379AbYGJPEG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jul 2008 11:04:06 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:44432 "EHLO
	gprs189-60.eurotel.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758313AbYGJPEE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2008 11:04:04 -0400
Date: Thu, 10 Jul 2008 13:36:44 +0200
From: Pavel Machek <pavel@suse.cz>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>,
       pm list <linux-pm@lists.linux-foundation.org>,
       Zhang Rui <rui.zhang@intel.com>, Rus <harbour@sfinx.od.ua>
Subject: Re: [PATCH -mm 6/8] Schedule sysrq poweroff on boot cpu
Message-ID: <20080710113643.GF15412@elf.ucw.cz>
References: <200807100152.17755.rjw@sisk.pl> <200807100204.25010.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200807100204.25010.rjw@sisk.pl>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu 2008-07-10 02:04:24, Rafael J. Wysocki wrote:
> From: Zhang Rui <rui.zhang@intel.com>
> Subject: Schedule sysrq poweroff on boot cpu
> 
> schedule sysrq poweroff on boot cpu.
> 
> sysrq poweroff needs to disable nonboot cpus, and we need to run this
> on boot cpu to avoid any recursion.
> http://bugzilla.kernel.org/show_bug.cgi?id=10897
> 
> Signed-off-by: Zhang Rui <rui.zhang@intel.com>
> tested-by: Rus <harbour@sfinx.od.ua>
> Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>

ACK.

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
