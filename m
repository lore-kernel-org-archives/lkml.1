Return-Path: <linux-kernel-owner+akpm=40linux-foundation.org-S1752485AbYLQVQM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752485AbYLQVQM (ORCPT <rfc822;akpm@linux-foundation.org>);
	Wed, 17 Dec 2008 16:16:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751237AbYLQVPw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Dec 2008 16:15:52 -0500
Received: from mx1.suse.de ([195.135.220.2]:56754 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751214AbYLQVPv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Dec 2008 16:15:51 -0500
Date: Wed, 17 Dec 2008 13:15:50 -0800
From: Mark Fasheh <mfasheh@suse.com>
To: Eric Sandeen <sandeen@sandeen.net>
Cc: Ankit Jain <me@ankitjain.org>, linux-kernel@vger.kernel.org,
        joel.becker@oracle.com, Christoph Hellwig <hch@infradead.org>,
        xfs-masters@oss.sgi.com, Al Viro <viro@zeniv.linux.org.uk>,
        linux-fsdevel@vger.kernel.org, xfs@oss.sgi.com,
        ocfs2-devel@oss.oracle.com
Subject: Re: [xfs-masters] [PATCH][RFC] fs: Add new pre-allocation ioctls to vfs for compatibility with legacy xfs ioctls
Message-ID: <20081217211550.GF8791@wotan.suse.de>
Reply-To: Mark Fasheh <mfasheh@suse.com>
References: <49460F88.2080408@ankitjain.org> <20081217202815.GE8791@wotan.suse.de> <494969C6.4090500@sandeen.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <494969C6.4090500@sandeen.net>
Organization: SUSE Labs, Novell, Inc
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 17, 2008 at 03:06:14PM -0600, Eric Sandeen wrote:
> >> There are some things that I'm not sure about:
> >> 1. Should the struct space_resv be exposed to user-space? If not,
> >> then what would be the right place to put it? And the ioctl
> >> definitions?
> > 
> > Yes. As far as where to put it, I'm not sure. Maybe falloc.h?
> 
> I'd sort of rather not; why should that legacy struct space_resv be
> available in a header... I thought this was for people already using the
> xfs ioctl, in which case they are already using the xfs header... and if
> they want preallocation in any new work, they should use fallocate()
> instead, yes?

Actually, yeah agreed - I take that back. Old users are already getting them
from file system headers, new ones should use fallocate. So there's no need
to expose the ioctls to userspace, at least not if all we're talking about
is the RESVP ioctls.
	--Mark

--
Mark Fasheh
