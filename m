Return-Path: <linux-kernel-owner+w=401wt.eu-S1755571AbZEUJo1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755571AbZEUJo1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 May 2009 05:44:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752228AbZEUJoS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 May 2009 05:44:18 -0400
Received: from hera.kernel.org ([140.211.167.34]:43808 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751635AbZEUJoS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 May 2009 05:44:18 -0400
Message-ID: <4A152255.9060703@kernel.org>
Date: Thu, 21 May 2009 18:43:49 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: "Eric W. Biederman" <ebiederm@xmission.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
       Greg Kroah-Hartman <gregkh@suse.de>, linux-kernel@vger.kernel.org,
       Cornelia Huck <cornelia.huck@de.ibm.com>, linux-fsdevel@vger.kernel.org,
       "Eric W. Biederman" <ebiederm@aristanetworks.com>
Subject: Re: [PATCH 20/20] sysfs: Normalize error handling in sysfs_fill_inode
References: <m1bppofm9k.fsf@fess.ebiederm.org> <1242865694-2100-5-git-send-email-ebiederm@xmission.com> <1242865694-2100-6-git-send-email-ebiederm@xmission.com> <1242865694-2100-7-git-send-email-ebiederm@xmission.com> <1242865694-2100-8-git-send-email-ebiederm@xmission.com> <1242865694-2100-9-git-send-email-ebiederm@xmission.com> <1242865694-2100-10-git-send-email-ebiederm@xmission.com> <1242865694-2100-11-git-send-email-ebiederm@xmission.com> <1242865694-2100-12-git-send-email-ebiederm@xmission.com> <1242865694-2100-13-git-send-email-ebiederm@xmission.com> <1242865694-2100-14-git-send-email-ebiederm@xmission.com> <1242865694-2100-15-git-send-email-ebiederm@xmission.com> <1242865694-2100-16-git-send-email-ebiederm@xmission.com> <1242865694-2100-17-git-send-email-ebiederm@xmission.com> <1242865694-2100-18-git-send-email-ebiederm@xmission.com> <1242865694-2100-19-git-send-email-ebiederm@xmission.com> <1242865694-2100-20-git-send-email-ebiederm@xmission.com>
In-Reply-To: <1242865694-2100-20-git-send-email-ebiederm@xmission.com>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Thu, 21 May 2009 09:43:52 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Eric W. Biederman wrote:
> From: Eric W. Biederman <ebiederm@xmission.com>
> 
> Use a single error exit path instead of doing whatever
> is the required cleanup at each point we find the error.
> Ultimately this should make the code more maintainable.
> 
> Signed-off-by: Eric W. Biederman <ebiederm@aristanetworks.com>

For 0018-0020,

Acked-by: Tejun Heo <tj@kernel.org>

Thanks.

-- 
tejun
