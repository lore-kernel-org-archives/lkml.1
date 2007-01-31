Return-Path: <linux-kernel-owner+w=401wt.eu-S932663AbXAaHCc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932663AbXAaHCc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jan 2007 02:02:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752196AbXAaHCc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Jan 2007 02:02:32 -0500
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:52041 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752183AbXAaHCb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jan 2007 02:02:31 -0500
Date: Wed, 31 Jan 2007 08:02:37 +0100
From: Adrian Bunk <bunk@stusta.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Mark Lord <lkml@rtr.ca>, Bron Gondwana <brong@fastmail.fm>,
       Mike Houston <mikeserv@bmts.com>, Chuck Ebbert <cebbert@redhat.com>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Steve French <smfltc@us.ibm.com>,
       Dave Kleikamp <shaggy@linux.vnet.ibm.com>,
       Daniel Drake <dsd@gentoo.org>, samba-technical@lists.samba.org,
       Vladimir Saveliev <vs@namesys.com>, reiserfs-dev@namesys.com,
       David Chinner <dgc@sgi.com>, xfs-masters@oss.sgi.com
Subject: Re: How many people are using 2.6.16?
Message-ID: <20070131070237.GT3754@stusta.de>
References: <45BE5948.6060403@redhat.com> <20070129160448.65fc63f3.mikeserv@bmts.com> <20070129221300.GC19422@brong.net> <20070130203933.GJ3754@stusta.de> <45BFF1F4.3060401@rtr.ca> <Pine.LNX.4.64.0701301748230.3611@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0701301748230.3611@woody.linux-foundation.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 30, 2007 at 06:36:48PM -0800, Linus Torvalds wrote:
> 
> 
> On Tue, 30 Jan 2007, Mark Lord wrote:
> > 
> > I believe our featherless leader said he though it was an ancient bug,
> > exasperated by something that went into 2.6.19.
> > 
> > If Linus's opinion is correct (still?), then the bug exists in all
> > kernels since somewhere back in the 2.4.xx days.
> 
> The issue was somewhat confused by people certainly *reporting* it for 
> older kernels. Also, as part of the dirty bit cleanups and sanity 
> checkingwe did actually seem to fix a long-standing CIFS corruption (and 
> apparently reisertfs/XFS problems too).
> 
> But the *common* case was actually introduced with 2.6.19, and 2.6.16 
> wouldn't be affected. 

Thanks for the clarifications.

Regarding the longstanding CIFS/reiserfs/XFS problems, it seems the 
status is:

CIFS:
commit cb876f451455b6187a7d69de2c112c45ec4b7f99
  Fix up CIFS for "test_clear_page_dirty()" removal
queued for 2.6.19.3
applies and compiles against 2.6.16

reiserfs:
commit de14569f94513279e3d44d9571a421e9da1759ae
  [PATCH] resierfs: avoid tail packing if an inode was ever mmapped
backport to 2.6.16 required

XFS:
fix not yet in your tree

> 			Linus

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

