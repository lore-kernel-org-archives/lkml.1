Return-Path: <linux-kernel-owner+w=401wt.eu-S1762175AbZAWGf3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762175AbZAWGf3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jan 2009 01:35:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751418AbZAWGfT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Jan 2009 01:35:19 -0500
Received: from hera.kernel.org ([140.211.167.34]:52119 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751402AbZAWGfR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jan 2009 01:35:17 -0500
Message-ID: <497964CC.8070004@kernel.org>
Date: Fri, 23 Jan 2009 15:33:48 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: "Eric W. Biederman" <ebiederm@xmission.com>
CC: Greg Kroah-Hartman <gregkh@suse.de>, linux-kernel@vger.kernel.org,
       Al Viro <viro@ZenIV.linux.org.uk>,
       Cornelia Huck <cornelia.huck@de.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] sysfs: Reference sysfs_dirent from sysfs inodes.
References: <m13afch1sw.fsf@fess.ebiederm.org> <m1k58nffqm.fsf@fess.ebiederm.org>
In-Reply-To: <m1k58nffqm.fsf@fess.ebiederm.org>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Fri, 23 Jan 2009 06:33:43 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Eric W. Biederman wrote:
> The sysfs_dirent serves as both an inode and a directory entry
> for sysfs.  To prevent the sysfs inode numbers from being freed
> prematurely hold a reference to sysfs_dirent from the sysfs inode.
> 
> Signed-off-by: Eric W. Biederman <ebiederm@aristanetworks.com>

Thanks for working on this.  Can you please add a comment explaining
it on top of sysfs_delete_inode()?

-- 
tejun
