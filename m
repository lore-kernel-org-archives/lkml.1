Return-Path: <linux-kernel-owner+w=401wt.eu-S964791AbXDAT2w@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964791AbXDAT2w (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Apr 2007 15:28:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964793AbXDAT2w
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Apr 2007 15:28:52 -0400
Received: from tmailer.gwdg.de ([134.76.10.23]:39431 "EHLO tmailer.gwdg.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964791AbXDAT2v (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Apr 2007 15:28:51 -0400
Date: Sun, 1 Apr 2007 21:28:03 +0200 (MEST)
From: Jan Engelhardt <jengelh@linux01.gwdg.de>
To: Dave Jones <davej@redhat.com>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@osdl.org>
Subject: Re: [PATCH 11/16] samba-eintr-fix.diff
In-Reply-To: <20070401190938.GA20060@redhat.com>
Message-ID: <Pine.LNX.4.61.0704012111000.16977@yvahk01.tjqt.qr>
References: <Pine.LNX.4.61.0704011900470.8018@yvahk01.tjqt.qr>
 <Pine.LNX.4.61.0704012009230.12316@yvahk01.tjqt.qr> <20070401190938.GA20060@redhat.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Spam-Report: Content analysis: 0.0 points, 6.0 required
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Apr 1 2007 15:09, Dave Jones wrote:
>On Sun, Apr 01, 2007 at 08:16:22PM +0200, Jan Engelhardt wrote:

> > From: Dave Jones
> > Already posted at http://lkml.org/lkml/2005/7/7/255
>
>I had to stop and think if this was an April 1st :)

Read the mail entitled "[PATCH 0/16] Assorted patches".

>As to whether the patch is worthwhile/correct..
>I really don't know.  I posted it back then in the hopes
>that someone smbfs-savvy would pop up and review it.
>As you can see from the archive, no-one did.

It seems to have been resent once, 7 days after you:
	http://lkml.org/lkml/2005/7/15/231

At that time, I had experienced strange copy failures ("No such file or 
directory") while the directory being copied was not modified. With the 
patch, I at least got EINTR instead of ENOENT, which I think made cp 
think once more to retry.


Jan
-- 
