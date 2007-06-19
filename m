Return-Path: <linux-kernel-owner+w=401wt.eu-S1758740AbXFSPQv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758740AbXFSPQv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jun 2007 11:16:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755578AbXFSPQm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Jun 2007 11:16:42 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:3117 "EHLO spitz.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755338AbXFSPQl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jun 2007 11:16:41 -0400
Date: Tue, 19 Jun 2007 15:16:27 +0000
From: Pavel Machek <pavel@ucw.cz>
To: Venki Pallipadi <venkatesh.pallipadi@intel.com>
Cc: Len Brown <lenb@kernel.org>, Adam Belay <abelay@novell.com>,
       Len Brown <len.brown@intel.com>, Thomas Gleixner <tglx@linutronix.de>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@osdl.org>, Shaohua Li <shaohua.li@intel.com>,
       linux-acpi@vger.kernel.org
Subject: Re: [PATCH 8/8] cpuidle: first round of documentation updates
Message-ID: <20070619151626.GA5127@ucw.cz>
References: <20070606205641.GH23906@linux-os.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070606205641.GH23906@linux-os.sc.intel.com>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> Documentation changes based on Pavel's feedback.

Thanks!

> -System global cpuidle information are under
> +System global cpuidle related information and tunables are under
>  /sys/devices/system/cpu/cpuidle
>  
>  The current interfaces in this directory has self-explanatory names:
> +* current_driver_ro
> +* current_governor_ro

Uff, the _ro thing looks ugly to my eyes.

> +With cpuidle_sysfs_switch boot option (meant for developer testing)
> +following objects are visible instead.
>  * available_drivers
>  * available_governors
>  * current_driver
>  * current_governor

...with different files depending on config it is _very_ ugly.


>  More than one governor can be registered at the same time and
> -user can switch between drivers using /sysfs interface.
> +user can switch between drivers using /sysfs interface (when supported).

(when enabled)?

> +More than one governor part is supported for developers to easily experiment
> +with different governors. By default, most optimal governor based on your

delete 'most'?

							Pavel

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
