Return-Path: <linux-kernel-owner+akpm=40linux-foundation.org-S1753416AbYLRVOv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753416AbYLRVOv (ORCPT <rfc822;akpm@linux-foundation.org>);
	Thu, 18 Dec 2008 16:14:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751949AbYLRVOl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Dec 2008 16:14:41 -0500
Received: from mail-gx0-f27.google.com ([209.85.217.27]:59112 "EHLO
	mail-gx0-f27.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751801AbYLRVOl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Dec 2008 16:14:41 -0500
X-Greylist: delayed 777 seconds by postgrey-1.27 at vger.kernel.org; Thu, 18 Dec 2008 16:14:40 EST
Message-ID: <494ABA11.2050205@ankitjain.org>
Date: Fri, 19 Dec 2008 02:31:05 +0530
From: Ankit Jain <me@ankitjain.org>
User-Agent: Thunderbird 2.0.0.18 (X11/20081112)
MIME-Version: 1.0
To: Mark Fasheh <mfasheh@suse.com>
CC: Al Viro <viro@zeniv.linux.org.uk>, Christoph Hellwig <hch@infradead.org>,
        linux-fsdevel@vger.kernel.org, joel.becker@oracle.com,
        ocfs2-devel@oss.oracle.com, linux-kernel@vger.kernel.org,
        xfs-masters@oss.sgi.com, xfs@oss.sgi.com
Subject: Re: [PATCH][RFC] fs: Add new pre-allocation ioctls to vfs for compatibility
 with legacy xfs ioctls
References: <49460F88.2080408@ankitjain.org> <20081217202815.GE8791@wotan.suse.de>
In-Reply-To: <20081217202815.GE8791@wotan.suse.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mark Fasheh wrote:
> On Mon, Dec 15, 2008 at 01:34:24PM +0530, Ankit Jain wrote:
>> 2. Should the corresponding ioctls be removed from ocfs2?
> 
> Well, a small amount of the code in fs/ocfs2/ioctl.c can certainly go away.
> Shouldn't we be talking about doing the same for xfs too?

Reading the code a bit, my understanding is that as compat_ioctl is also
supported and that just delegates to ioctl (ocfs2_ioctl), so we can't
remove the *_RESVSP* handling.
Same goes for xfs also.

Does that sound fair or did I not understand it correctly?

-Ankit
