Return-Path: <linux-kernel-owner+w=401wt.eu-S964821AbXDATnG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964821AbXDATnG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Apr 2007 15:43:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964804AbXDATnG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Apr 2007 15:43:06 -0400
Received: from mx1.redhat.com ([66.187.233.31]:42839 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964828AbXDATnE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Apr 2007 15:43:04 -0400
Date: Sun, 1 Apr 2007 15:42:50 -0400
From: Dave Jones <davej@redhat.com>
To: Jan Engelhardt <jengelh@linux01.gwdg.de>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@osdl.org>
Subject: Re: [PATCH 11/16] samba-eintr-fix.diff
Message-ID: <20070401194250.GB20060@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Jan Engelhardt <jengelh@linux01.gwdg.de>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Andrew Morton <akpm@osdl.org>
References: <Pine.LNX.4.61.0704011900470.8018@yvahk01.tjqt.qr> <Pine.LNX.4.61.0704012009230.12316@yvahk01.tjqt.qr> <20070401190938.GA20060@redhat.com> <Pine.LNX.4.61.0704012111000.16977@yvahk01.tjqt.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.61.0704012111000.16977@yvahk01.tjqt.qr>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Apr 01, 2007 at 09:28:03PM +0200, Jan Engelhardt wrote:
 > 
 > On Apr 1 2007 15:09, Dave Jones wrote:
 > >On Sun, Apr 01, 2007 at 08:16:22PM +0200, Jan Engelhardt wrote:
 > 
 > > > From: Dave Jones
 > > > Already posted at http://lkml.org/lkml/2005/7/7/255
 > >
 > >I had to stop and think if this was an April 1st :)
 > 
 > Read the mail entitled "[PATCH 0/16] Assorted patches".

That's what happens when you read inbox before mailing list folders :)

 > >As to whether the patch is worthwhile/correct..
 > >I really don't know.  I posted it back then in the hopes
 > >that someone smbfs-savvy would pop up and review it.
 > >As you can see from the archive, no-one did.
 > 
 > It seems to have been resent once, 7 days after you:
 > 	http://lkml.org/lkml/2005/7/15/231

Hmm, with no changelog. I wonder if JA was hitting that bug
and independantly came up with that patch, or was just
resubmitting on my behalf.

 > At that time, I had experienced strange copy failures ("No such file or 
 > directory") while the directory being copied was not modified. With the 
 > patch, I at least got EINTR instead of ENOENT, which I think made cp 
 > think once more to retry.

I suppose we could throw it in -mm and see if anyone screams. Andrew?

	Dave

-- 
http://www.codemonkey.org.uk
