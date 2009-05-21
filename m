Return-Path: <linux-kernel-owner+w=401wt.eu-S1753207AbZEUJPi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753207AbZEUJPi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 May 2009 05:15:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751427AbZEUJPa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 May 2009 05:15:30 -0400
Received: from hera.kernel.org ([140.211.167.34]:33912 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751003AbZEUJP3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 May 2009 05:15:29 -0400
Message-ID: <4A151B88.7090300@kernel.org>
Date: Thu, 21 May 2009 18:14:48 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: "Eric W. Biederman" <ebiederm@xmission.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
       Greg Kroah-Hartman <gregkh@suse.de>, linux-kernel@vger.kernel.org,
       Cornelia Huck <cornelia.huck@de.ibm.com>, linux-fsdevel@vger.kernel.org,
       "Eric W. Biederman" <ebiederm@aristanetworks.com>
Subject: Re: [PATCH 13/20] sysfs: Implement sysfs_getattr & sysfs_permission
References: <m1bppofm9k.fsf@fess.ebiederm.org> <1242865694-2100-1-git-send-email-ebiederm@xmission.com> <1242865694-2100-2-git-send-email-ebiederm@xmission.com> <1242865694-2100-3-git-send-email-ebiederm@xmission.com> <1242865694-2100-4-git-send-email-ebiederm@xmission.com> <1242865694-2100-5-git-send-email-ebiederm@xmission.com> <1242865694-2100-6-git-send-email-ebiederm@xmission.com> <1242865694-2100-7-git-send-email-ebiederm@xmission.com> <1242865694-2100-8-git-send-email-ebiederm@xmission.com> <1242865694-2100-9-git-send-email-ebiederm@xmission.com> <1242865694-2100-10-git-send-email-ebiederm@xmission.com> <1242865694-2100-11-git-send-email-ebiederm@xmission.com> <1242865694-2100-12-git-send-email-ebiederm@xmission.com> <1242865694-2100-13-git-send-email-ebiederm@xmission.com>
In-Reply-To: <1242865694-2100-13-git-send-email-ebiederm@xmission.com>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Thu, 21 May 2009 09:14:51 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Eric W. Biederman wrote:
> From: Eric W. Biederman <ebiederm@xmission.com>
> 
> With the implementation of sysfs_getattr and sysfs_permission
> sysfs becomes able to lazily propogate inode attribute changes
> from the sysfs_dirents to the vfs inodes.   This paves the way
> for deleting significant chunks of now unnecessary code.
> 
> Signed-off-by: Eric W. Biederman <ebiederm@aristanetworks.com>

Acked-by: Tejun Heo <tj@kernel.org>

-- 
tejun
