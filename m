Return-Path: <linux-kernel-owner+w=401wt.eu-S1761626AbZFJVBz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761626AbZFJVBz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jun 2009 17:01:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760189AbZFJVBs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Jun 2009 17:01:48 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:46151 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758826AbZFJVBs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jun 2009 17:01:48 -0400
Date: Wed, 10 Jun 2009 23:01:44 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Denis Karpov <ext-denis.2.karpov@nokia.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/5] FAT errors, userspace notifications
Message-ID: <20090610210144.GB1381@ucw.cz>
References: <1243866891-18713-1-git-send-email-ext-denis.2.karpov@nokia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1243866891-18713-1-git-send-email-ext-denis.2.karpov@nokia.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> 2. Generic mechanism for notifications of user space about file system's 
>    errors/inconsistency on a particular partition using:
> 
>      - sysfs entry /sys/block/<bdev>/<part>/fs_unclean
>      - uevent KOBJ_CHANGE, uevent's environment variable FS_UNCLEAN=[0:1]
> 
>    Userspace might want to monitor these notifications (poll2() on sysfs file
>    or udevd's rule for uevent) and fix the fs damage.
>    Filesystem can be marked clean again by writing '0' to the corresponding 
>    'fs_unclean' sysfs file.

I see a race between userspace writing 0 and new error being detected.

Plus I don't think we have support for online fsck, not even on FAT...
       	     	      	   	       	      	    	     	Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
