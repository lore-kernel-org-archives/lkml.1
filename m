Return-Path: <linux-kernel-owner+w=401wt.eu-S932379AbXA2E6z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932379AbXA2E6z (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Jan 2007 23:58:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933115AbXA2E6z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Jan 2007 23:58:55 -0500
Received: from sandeen.net ([209.173.210.139]:24800 "EHLO sandeen.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932379AbXA2E6y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Jan 2007 23:58:54 -0500
Message-ID: <45BD7F0A.1000004@sandeen.net>
Date: Sun, 28 Jan 2007 22:58:50 -0600
From: Eric Sandeen <sandeen@sandeen.net>
User-Agent: Thunderbird 1.5.0.9 (Macintosh/20061207)
MIME-Version: 1.0
To: xfs-masters@oss.sgi.com
CC: Linux kernel mailing list <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@osdl.org>, dgc@sgi.com
Subject: Re: [xfs-masters] [PATCH} XFS: Remove placeholders for unimplemented
 functionality.
References: <Pine.LNX.4.64.0701281557410.11046@CPE00045a9c397f-CM001225dbafb6>
In-Reply-To: <Pine.LNX.4.64.0701281557410.11046@CPE00045a9c397f-CM001225dbafb6>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Robert P. J. Day wrote:
>   Remove a couple kernel config variables (FS_POSIX_CAP and
> FS_POSIX_MAC) that represent placeholders for unimplemented
> functionality.
> 
> Signed-off-by: Robert P. J. Day <rpjday@mindspring.com>
> 
> ---

...

> diff --git a/fs/xfs/xfs_cap.h b/fs/xfs/xfs_cap.h
> index 7a0e482..cfedfd1 100644
> --- a/fs/xfs/xfs_cap.h
> +++ b/fs/xfs/xfs_cap.h

...

> -#else
>  #define xfs_cap_vset(v,p,sz)	(-EOPNOTSUPP)
>  #define xfs_cap_vget(v,p,sz)	(-EOPNOTSUPP)
>  #define xfs_cap_vremove(v)	(-EOPNOTSUPP)
>  #define _CAP_EXISTS		(NULL)
> -#endif
> 
>  #endif	/* __KERNEL__ */

By the time you do this, probably may as well remove the whole file; the 
leftover 4 definitions never seem to be used.

The same may go for xfs_mac.h.

-Eric
