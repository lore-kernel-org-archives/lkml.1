Return-Path: <linux-kernel-owner+w=401wt.eu-S1758588AbXK0AV5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758588AbXK0AV5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2007 19:21:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755808AbXK0AVu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Nov 2007 19:21:50 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.31.123]:52894 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754916AbXK0AVt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2007 19:21:49 -0500
Date: Tue, 27 Nov 2007 01:21:45 +0100
From: Pavel Machek <pavel@ucw.cz>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: pm list <linux-pm@lists.linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 3/6] Suspend: Use common prefix in messages
Message-ID: <20071127002145.GD9759@elf.ucw.cz>
References: <200711270025.08128.rjw@sisk.pl> <200711270030.10561.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200711270030.10561.rjw@sisk.pl>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> From: Rafael J. Wysocki <rjw@sisk.pl>
> 
> Make suspend messages start with one common prefix "PM: ".
> 
> Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>

I do not think I like the PREFIX idea (see other message).


> @@ -344,11 +344,12 @@ static int enter_state(suspend_state_t s
>  	if (!mutex_trylock(&pm_mutex))
>  		return -EBUSY;
>  
> -	printk("Syncing filesystems ... ");
> +	printk(KERN_INFO PREFIX "Syncing filesystems ... ");
>  	sys_sync();
> -	printk("done.\n");
> +	printk(KERN_INFO "done.\n");


Plus this is wrong.
									Pavel

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
