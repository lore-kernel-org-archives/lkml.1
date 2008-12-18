Return-Path: <linux-kernel-owner+akpm=40linux-foundation.org-S1752757AbYLRJvV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752757AbYLRJvV (ORCPT <rfc822;akpm@linux-foundation.org>);
	Thu, 18 Dec 2008 04:51:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751690AbYLRJvF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Dec 2008 04:51:05 -0500
Received: from qb-out-0506.google.com ([72.14.204.237]:65464 "EHLO
	qb-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751575AbYLRJvC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Dec 2008 04:51:02 -0500
Message-ID: <494A1CE5.8020007@ankitjain.org>
Date: Thu, 18 Dec 2008 15:20:29 +0530
From: Ankit Jain <me@ankitjain.org>
User-Agent: Thunderbird 2.0.0.18 (X11/20081112)
MIME-Version: 1.0
To: Mark Fasheh <mfasheh@suse.com>
CC: Eric Sandeen <sandeen@sandeen.net>, linux-kernel@vger.kernel.org,
        joel.becker@oracle.com, Christoph Hellwig <hch@infradead.org>,
        xfs-masters@oss.sgi.com, Al Viro <viro@zeniv.linux.org.uk>,
        linux-fsdevel@vger.kernel.org, xfs@oss.sgi.com,
        ocfs2-devel@oss.oracle.com
Subject: Re: [xfs-masters] [PATCH][RFC] fs: Add new pre-allocation ioctls
 to vfs for compatibility with legacy xfs ioctls
References: <49460F88.2080408@ankitjain.org> <20081217202815.GE8791@wotan.suse.de> <494969C6.4090500@sandeen.net> <20081217211550.GF8791@wotan.suse.de>
In-Reply-To: <20081217211550.GF8791@wotan.suse.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mark Fasheh wrote:
> On Wed, Dec 17, 2008 at 03:06:14PM -0600, Eric Sandeen wrote:
> 
> Actually, yeah agreed - I take that back. Old users are already getting them
> from file system headers, new ones should use fallocate. So there's no need
> to expose the ioctls to userspace, at least not if all we're talking about
> is the RESVP ioctls.

Makes sense. So I can just keep them in falloc.h in a #ifdef __KERNEL__ ? Or
should this be in a new ioctl.h ?

-Ankit

> 	--Mark
> 
> --
> Mark Fasheh

