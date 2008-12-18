Return-Path: <linux-kernel-owner+akpm=40linux-foundation.org-S1752880AbYLRJzb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752880AbYLRJzb (ORCPT <rfc822;akpm@linux-foundation.org>);
	Thu, 18 Dec 2008 04:55:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751834AbYLRJzT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Dec 2008 04:55:19 -0500
Received: from qb-out-0506.google.com ([72.14.204.230]:64426 "EHLO
	qb-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751347AbYLRJzS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Dec 2008 04:55:18 -0500
Message-ID: <494A1DE3.5090203@ankitjain.org>
Date: Thu, 18 Dec 2008 15:24:43 +0530
From: Ankit Jain <me@ankitjain.org>
User-Agent: Thunderbird 2.0.0.18 (X11/20081112)
MIME-Version: 1.0
To: Felix Blyakher <felixb@sgi.com>
CC: Al Viro <viro@zeniv.linux.org.uk>, Christoph Hellwig <hch@infradead.org>,
        linux-fsdevel@vger.kernel.org, mfasheh@suse.com,
        joel.becker@oracle.com, ocfs2-devel@oss.oracle.com,
        linux-kernel@vger.kernel.org, xfs-masters@oss.sgi.com, xfs@oss.sgi.com
Subject: Re: [PATCH][RFC] fs: Add new pre-allocation ioctls to vfs for compatibility
 with legacy xfs ioctls
References: <49460F88.2080408@ankitjain.org> <9D2593C9-08EB-486C-AAF5-E83A1EAEE9B9@sgi.com>
In-Reply-To: <9D2593C9-08EB-486C-AAF5-E83A1EAEE9B9@sgi.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Felix Blyakher wrote:
> 
>> This patch adds ioctls to vfs for compatibility with legacy XFS
>> pre-allocation ioctls (XFS_IOC_*RESVP*). The implementation
>> effectively invokes sys_fallocate for the new ioctls.
> 
> I don't think we can use sys_fallocate for XFS_IOC_UNRESVSP*
> commands, which suppose to release currently allocated file
> blocks.
> See more comments below.

My bad :( I'll drop the *UNRESV* completely from the new ioctl and
post an updated patch.

-Ankit
