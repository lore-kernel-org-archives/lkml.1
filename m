Return-Path: <linux-kernel-owner+w=401wt.eu-S1758636AbYAXXKh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758636AbYAXXKh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2008 18:10:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753905AbYAXXK3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Jan 2008 18:10:29 -0500
Received: from zakalwe.fi ([80.83.5.154]:56383 "EHLO zakalwe.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755843AbYAXXK2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2008 18:10:28 -0500
X-Greylist: delayed 1196 seconds by postgrey-1.27 at vger.kernel.org; Thu, 24 Jan 2008 18:10:28 EST
Date: Fri, 25 Jan 2008 00:50:31 +0200
From: Heikki Orsila <shdl@zakalwe.fi>
To: Dmitri Vorobiev <dmitri.vorobiev@gmail.com>
Cc: trivial@kernel.org, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, tigran@aivazian.fsnet.co.uk
Subject: Re: [PATCH 5/9] bfs: move function prototype to the proper header file
Message-ID: <20080124225031.GC12172@zakalwe.fi>
References: <1201213928-18183-1-git-send-email-dmitri.vorobiev@gmail.com> <1201213928-18183-6-git-send-email-dmitri.vorobiev@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <1201213928-18183-6-git-send-email-dmitri.vorobiev@gmail.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 25, 2008 at 01:32:04AM +0300, Dmitri Vorobiev wrote:
> diff --git a/fs/bfs/bfs.h b/fs/bfs/bfs.h
> index 090b96e..ecc74bb 100644
> --- a/fs/bfs/bfs.h
> +++ b/fs/bfs/bfs.h
...
> +/* inode.c */
> +extern void dump_imap(const char *, struct super_block *);
> +

Functions should not be externed, remove extern keyword.

-- 
Heikki Orsila			Barbie's law:
heikki.orsila@iki.fi		"Math is hard, let's go shopping!"
http://www.iki.fi/shd
