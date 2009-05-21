Return-Path: <linux-kernel-owner+w=401wt.eu-S1754525AbZEUJmq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754525AbZEUJmq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 May 2009 05:42:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752771AbZEUJmi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 May 2009 05:42:38 -0400
Received: from hera.kernel.org ([140.211.167.34]:43754 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752457AbZEUJmi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 May 2009 05:42:38 -0400
Message-ID: <4A1521F6.2050205@kernel.org>
Date: Thu, 21 May 2009 18:42:14 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: "Eric W. Biederman" <ebiederm@xmission.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
       Greg Kroah-Hartman <gregkh@suse.de>, linux-kernel@vger.kernel.org,
       Cornelia Huck <cornelia.huck@de.ibm.com>, linux-fsdevel@vger.kernel.org,
       "Eric W. Biederman" <ebiederm@aristanetworks.com>
Subject: Re: [PATCH 17/20] sysfs: Merge sysfs_rename_dir and sysfs_move_dir
References: <m1bppofm9k.fsf@fess.ebiederm.org> <1242865694-2100-2-git-send-email-ebiederm@xmission.com> <1242865694-2100-3-git-send-email-ebiederm@xmission.com> <1242865694-2100-4-git-send-email-ebiederm@xmission.com> <1242865694-2100-5-git-send-email-ebiederm@xmission.com> <1242865694-2100-6-git-send-email-ebiederm@xmission.com> <1242865694-2100-7-git-send-email-ebiederm@xmission.com> <1242865694-2100-8-git-send-email-ebiederm@xmission.com> <1242865694-2100-9-git-send-email-ebiederm@xmission.com> <1242865694-2100-10-git-send-email-ebiederm@xmission.com> <1242865694-2100-11-git-send-email-ebiederm@xmission.com> <1242865694-2100-12-git-send-email-ebiederm@xmission.com> <1242865694-2100-13-git-send-email-ebiederm@xmission.com> <1242865694-2100-14-git-send-email-ebiederm@xmission.com> <1242865694-2100-15-git-send-email-ebiederm@xmission.com> <1242865694-2100-16-git-send-email-ebiederm@xmission.com> <1242865694-2100-17-git-send-email-ebiederm@xmission.com>
In-Reply-To: <1242865694-2100-17-git-send-email-ebiederm@xmission.com>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Thu, 21 May 2009 09:42:17 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Eric W. Biederman wrote:
> From: Eric W. Biederman <ebiederm@xmission.com>
> 
> These two functions do 90% of the same work and it doesn't significantly
> obfuscate the function to allow both the parent dir and the name to change
> at the same time.  So merge them together to simplify maintenance, and
> increase testing.
> 
> Signed-off-by: Eric W. Biederman <ebiederm@aristanetworks.com>

Acked-by: Tejun Heo <tj@kernel.org>

-- 
tejun
