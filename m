Return-Path: <linux-kernel-owner+w=401wt.eu-S1751639AbZL0WBO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751639AbZL0WBO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Dec 2009 17:01:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751330AbZL0WBN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Dec 2009 17:01:13 -0500
Received: from moutng.kundenserver.de ([212.227.17.10]:52881 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751271AbZL0WBM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Dec 2009 17:01:12 -0500
Date: Sun, 27 Dec 2009 14:01:07 -0800 (PST)
From: Christian Kujau <lists@nerdbynature.de>
To: Dave Chinner <david@fromorbit.com>
cc: xfs@oss.sgi.com, LKML <linux-kernel@vger.kernel.org>
Subject: Re: lockdep: inconsistent lock state
In-Reply-To: <20091227212700.GA7613@discord.disaster>
Message-ID: <alpine.DEB.2.01.0912271355550.3483@bogon.housecafe.de>
References: <alpine.DEB.2.01.0912261255380.3483@bogon.housecafe.de> <20091227212700.GA7613@discord.disaster>
User-Agent: Alpine 2.01 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Provags-ID: V01U2FsdGVkX1/PW+CB3uyg4rmazs5BUA0gUzkS/yVXDhMZlU0
 GL9ljWzv3dGUT6mlGE4sDfdb3ERb3dVDC7ruXvqvfzpVC7d8dr
 B91NOvynQVz8CgicQLjMA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 28 Dec 2009 at 08:27, Dave Chinner wrote:
> from kswapd inverts lock ordering and so we get this report. This
> case has never been a deadlock case because an inode in reclaim
> cannot be referenced by any other path, so once again it is a
> false positive....

OK, thanks for confirming this. I've only seen this during
bonnie++ tests so far, and it's always reproducible there, but
I've not seen it during "normal use". It's still scary though. Just 
checked, opensuse and fedora have CONFIG_LOCKDEP_SUPPORT=y but no 
related DEBUG options set, so it probably won't ever show up for
the general public.

Christian.
-- 
BOFH excuse #278:

The Dilithium Crystals need to be rotated.
