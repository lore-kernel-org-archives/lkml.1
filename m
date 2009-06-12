Return-Path: <linux-kernel-owner+w=401wt.eu-S933937AbZFLKzv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933937AbZFLKzv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jun 2009 06:55:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756863AbZFLKzn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Jun 2009 06:55:43 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:56789 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756329AbZFLKzm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jun 2009 06:55:42 -0400
Date: Fri, 12 Jun 2009 12:55:35 +0200
From: Pavel Machek <pavel@ucw.cz>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux PM List <linux-pm@lists.linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Heiko Carstens <heiko.carstens@de.ibm.com>,
       Cornelia Huck <cornelia.huck@de.ibm.com>, Magnus Damm <damm@igel.co.jp>,
       Greg Kroah-Hartman <gregkh@suse.de>,
       Wu Fengguang <fengguang.wu@intel.com>,
       Alan Stern <stern@rowland.harvard.edu>,
       Sergio Luis <sergio@larces.uece.br>,
       Lauro Salmito <laurosalmito@gmail.com>,
       Jaswinder Singh Rajput <jaswinder@kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Nigel Cunningham <nigel@tuxonice.net>
Subject: Re: [PATCH 10/19] PM core: rename suspend and resume functions
Message-ID: <20090612105535.GK18682@elf.ucw.cz>
References: <0615007ad8090a890586d530b5d3bb98da566014.1244752872.git.rjw@sisk.pl> <S4AoGnG.A.mG.jfYMKB@chimera>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <S4AoGnG.A.mG.jfYMKB@chimera>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu 2009-06-11 22:38:06, Rafael J. Wysocki wrote:
> From: Alan Stern <stern@rowland.harvard.edu>
> 
> This patch (as1241) renames a bunch of functions in the PM core.
> Rather than go through a boring list of name changes, suffice it to
> say that in the end we have a bunch of pairs of functions:
> 
> 	device_resume_noirq	dpm_resume_noirq
> 	device_resume		dpm_resume
> 	device_complete		dpm_complete
> 	device_suspend_noirq	dpm_suspend_noirq
> 	device_suspend		dpm_suspend
> 	device_prepare		dpm_prepare
> 
> in which device_X does the X operation on a single device and dpm_X
> invokes device_X for all devices in the dpm_list.
> 
> In addition, the old dpm_power_up and device_resume_noirq have been
> combined into a single function (dpm_resume_noirq).
> 
> Lastly, dpm_suspend_start and dpm_resume_end are the renamed versions
> of the former top-level device_suspend and device_resume routines.
> 
> Signed-off-by: Alan Stern <stern@rowland.harvard.edu>
> Acked-by: Magnus Damm <damm@igel.co.jp>
> Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>

Ack.

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
