Return-Path: <linux-kernel-owner+w=401wt.eu-S1758260AbZE2JTM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758260AbZE2JTM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 May 2009 05:19:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756411AbZE2JS6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 May 2009 05:18:58 -0400
Received: from hera.kernel.org ([140.211.167.34]:42661 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754276AbZE2JS5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 May 2009 05:18:57 -0400
Message-ID: <4A1FA856.6050407@kernel.org>
Date: Fri, 29 May 2009 18:18:14 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: "Eric W. Biederman" <ebiederm@xmission.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
       Greg Kroah-Hartman <gregkh@suse.de>, linux-kernel@vger.kernel.org,
       Cornelia Huck <cornelia.huck@de.ibm.com>, linux-fsdevel@vger.kernel.org,
       Kay Sievers <kay.sievers@vrfy.org>, Greg KH <greg@kroah.com>,
       "Eric W. Biederman" <ebiederm@aristanetworks.com>
Subject: Re: [PATCH 24/24] sysfs: In sysfs_add_one fail if the targe directory
 has been removed.
References: <m1zlcwltri.fsf_-_@fess.ebiederm.org> <1243551665-23596-24-git-send-email-ebiederm@xmission.com>
In-Reply-To: <1243551665-23596-24-git-send-email-ebiederm@xmission.com>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Fri, 29 May 2009 09:18:17 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Eric W. Biederman wrote:
> From: Eric W. Biederman <ebiederm@xmission.com>
> 
> If a bug in the upper layers results in someone attempting to add
> to a sysfs directory that has already been removed, warn about it
> and fail.
> 
> I don't believe this has ever happened, and it certainly never should
> happen, but be strict to avoid errors creeping in.
> 
> Acked-by: Kay Sievers <kay.sievers@vrfy.org>
> Signed-off-by: Eric W. Biederman <ebiederm@aristanetworks.com>

Acked-by: Tejun Heo <tj@kernel.org>

-- 
tejun
