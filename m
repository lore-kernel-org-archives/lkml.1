Return-Path: <linux-kernel-owner+w=401wt.eu-S1756864AbYKTQtP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756864AbYKTQtP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2008 11:49:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753681AbYKTQs7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Nov 2008 11:48:59 -0500
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:58616 "EHLO
	gprs189-60.eurotel.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753529AbYKTQs6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2008 11:48:58 -0500
Date: Thu, 20 Nov 2008 17:50:39 +0100
From: Pavel Machek <pavel@suse.cz>
To: Simon Holm Th?gersen <account@cs.aau.dk>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       linux-pm@lists.linux-foundation.org
Subject: Re: Crash during suspend to disk
Message-ID: <20081120165039.GC23522@elf.ucw.cz>
References: <1227184916.4855.31.camel@odie.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1227184916.4855.31.camel@odie.local>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> I hope this information is sufficient to debug my problem, though it
> unfortunately is somewhat incomplete. I took two pictures of the OOPS
> with my mobile phone, but unfortunately the picture of the upper part is
> so blurred that it is unreadable. Apparently I have to be in a hurry
> getting out of the door for this to happen. Here is what I got from the
> lower part

> 
> Call Trace:
>   __blkdev_put
>   swsusp_write
>   hibernate
>   state_store
>   state_store
>   state_store
>   kobj_attr_store
>   sysfs_write_file
>   sysfs_write_file
>   vfs_write
>   sys_write
>   sysenter_do_call
> Code: ......
> EIP: [<...>] iput
> ---[ end trace ........................... ]---

Hmm, I'm afraid this is not enough, not even if the blanks are filled.

> I believe I've seen the same crash before with a 2.6.27 or earlier
> kernel, but I was in a hurry getting out of the door back then as I was
> here. Circumstances was the same though, with already successful suspend
> to disk and the crash appearing during second or third attempt to
> suspend to disk in quick succession.
> 
> I guess I should be able to reproduce the crash with some efforts, but
> I'd like to hear your thoughts on this before I do that.

If you can reproduce that, we can probably debug it...
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
