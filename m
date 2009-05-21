Return-Path: <linux-kernel-owner+w=401wt.eu-S1752771AbZEUGnR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752771AbZEUGnR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 May 2009 02:43:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750880AbZEUGnJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 May 2009 02:43:09 -0400
Received: from hera.kernel.org ([140.211.167.34]:39498 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750836AbZEUGnI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 May 2009 02:43:08 -0400
Message-ID: <4A14F7F2.8010502@kernel.org>
Date: Thu, 21 May 2009 15:42:58 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: "Eric W. Biederman" <ebiederm@xmission.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
       Greg Kroah-Hartman <gregkh@suse.de>, linux-kernel@vger.kernel.org,
       Cornelia Huck <cornelia.huck@de.ibm.com>, linux-fsdevel@vger.kernel.org,
       "Eric W. Biederman" <ebiederm@aristanetworks.com>
Subject: Re: [PATCH 07/20] sysfs: Simplify sysfs_chmod_file semantics
References: <m1bppofm9k.fsf@fess.ebiederm.org> <1242865694-2100-1-git-send-email-ebiederm@xmission.com> <1242865694-2100-2-git-send-email-ebiederm@xmission.com> <1242865694-2100-3-git-send-email-ebiederm@xmission.com> <1242865694-2100-4-git-send-email-ebiederm@xmission.com> <1242865694-2100-5-git-send-email-ebiederm@xmission.com> <1242865694-2100-6-git-send-email-ebiederm@xmission.com> <1242865694-2100-7-git-send-email-ebiederm@xmission.com>
In-Reply-To: <1242865694-2100-7-git-send-email-ebiederm@xmission.com>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Thu, 21 May 2009 06:43:01 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Eric W. Biederman wrote:
> From: Eric W. Biederman <ebiederm@xmission.com>
> 
> Currently every caller of sysfs_chmod_file happens at either
> file creation time to set a non-default mode or in response
> to a specific user requested space change in policy.  Making
> timestamps of when the chmod happens and notification of
> a file changing mode uninteresting.
> 
> Remove the unnecessary time stamp and filesystem change
> notification, and removes the last of the explicit inotify
> and donitfy support from sysfs.
> 
> Signed-off-by: Eric W. Biederman <ebiederm@aristanetworks.com>

If Greg is okay with this,

Acked-by: Tejun Heo <tj@kernel.org>

-- 
tejun
