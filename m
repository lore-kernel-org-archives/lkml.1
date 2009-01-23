Return-Path: <linux-kernel-owner+w=401wt.eu-S1764247AbZAWGcv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764247AbZAWGcv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jan 2009 01:32:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761898AbZAWG2u
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Jan 2009 01:28:50 -0500
Received: from hera.kernel.org ([140.211.167.34]:33974 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1764404AbZAWG2t (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jan 2009 01:28:49 -0500
Message-ID: <4979637E.4070706@kernel.org>
Date: Fri, 23 Jan 2009 15:28:14 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: "Eric W. Biederman" <ebiederm@xmission.com>
CC: Greg Kroah-Hartman <gregkh@suse.de>, linux-kernel@vger.kernel.org,
       Al Viro <viro@ZenIV.linux.org.uk>,
       Cornelia Huck <cornelia.huck@de.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] sysfs: Take sysfs_mutex when fetching the root inode.
References: <m13afch1sw.fsf@fess.ebiederm.org>
In-Reply-To: <m13afch1sw.fsf@fess.ebiederm.org>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Fri, 23 Jan 2009 06:28:11 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Eric W. Biederman wrote:
> sysfs_get_inode ultimately calls sysfs_count_nlink when the a
> directory inode is fectched.  sysfs_count_nlink needs to be
> called under the sysfs_mutex to guard against the unlikely
> but possible scenario that the root directory is changing
> as we are counting the number entries in it, and just in
> general to be consistent.
> 
> Signed-off-by: Eric W. Biederman <ebiederm@aristanetworks.com>

Acked-by: Tejun Heo <tj@kernel.org>

Thanks.

-- 
tejun
