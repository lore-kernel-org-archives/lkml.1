Return-Path: <linux-kernel-owner+w=401wt.eu-S1754732AbXITKJu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754732AbXITKJu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2007 06:09:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750786AbXITKJn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Sep 2007 06:09:43 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.31.123]:52485 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750718AbXITKJm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2007 06:09:42 -0400
Date: Thu, 20 Sep 2007 12:09:41 +0200
From: Pavel Machek <pavel@ucw.cz>
To: "Huang, Ying" <ying.huang@intel.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>, nigel@nigel.suspend2.net,
       Andrew Morton <akpm@linux-foundation.org>,
       Jeremy Maitin-Shepard <jbms@cmu.edu>, linux-kernel@vger.kernel.org,
       linux-pm@lists.linux-foundation.org,
       Kexec Mailing List <kexec@lists.infradead.org>
Subject: Re: [RFC][PATCH 1/2 -mm] kexec based hibernation -v3: kexec jump
Message-ID: <20070920100941.GA12157@atrey.karlin.mff.cuni.cz>
References: <1190266447.21818.17.camel@caritas-dev.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1190266447.21818.17.camel@caritas-dev.intel.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> This patch implements the functionality of jumping between the kexeced
> kernel and the original kernel.
> 
> A new reboot command named LINUX_REBOOT_CMD_KJUMP is defined to
> trigger the jumping to (executing) the new kernel and jumping back to
> the original kernel.
> 
> To support jumping between two kernels, before jumping to (executing)
> the new kernel and jumping back to the original kernel, the devices
> are put into quiescent state (to be fully implemented), and the state
> of devices and CPU is saved. After jumping back from kexeced kernel
> and jumping to the new kernel, the state of devices and CPU are
> restored accordingly. The devices/CPU state save/restore code of
> software suspend is called to implement corresponding function.
> 
> To support jumping without preserving memory. One shadow backup page
> is allocated for each page used by new (kexeced) kernel. When do
> kexec_load, the image of new kernel is loaded into shadow pages, and
> before executing, the original pages and the shadow pages are swapped,
> so the contents of original pages are backuped. Before jumping to the
> new (kexeced) kernel and after jumping back to the original kernel,
> the original pages and the shadow pages are swapped too.
> 
> A jump back protocol is defined and documented.


> Signed-off-by: Huang Ying <ying.huang@intel.com>

Seems like good enough for -mm to me.

									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
