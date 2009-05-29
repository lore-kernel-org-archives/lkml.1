Return-Path: <linux-kernel-owner+w=401wt.eu-S1757365AbZE2JSF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757365AbZE2JSF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 May 2009 05:18:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756058AbZE2JRy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 May 2009 05:17:54 -0400
Received: from hera.kernel.org ([140.211.167.34]:42635 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754276AbZE2JRy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 May 2009 05:17:54 -0400
Message-ID: <4A1FA7F4.9000708@kernel.org>
Date: Fri, 29 May 2009 18:16:36 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: "Eric W. Biederman" <ebiederm@xmission.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
       Greg Kroah-Hartman <gregkh@suse.de>, linux-kernel@vger.kernel.org,
       Cornelia Huck <cornelia.huck@de.ibm.com>, linux-fsdevel@vger.kernel.org,
       Kay Sievers <kay.sievers@vrfy.org>, Greg KH <greg@kroah.com>,
       "Eric W. Biederman" <ebiederm@aristanetworks.com>
Subject: Re: [PATCH 22/24] sysfs: Make sysfs_rename_link atomic
References: <m1zlcwltri.fsf_-_@fess.ebiederm.org> <1243551665-23596-22-git-send-email-ebiederm@xmission.com>
In-Reply-To: <1243551665-23596-22-git-send-email-ebiederm@xmission.com>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Fri, 29 May 2009 09:16:38 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Eric W. Biederman wrote:
> From: Eric W. Biederman <ebiederm@xmission.com>
> 
> Use the existing sysfs_rename to make sysfs_rename_link an atomic
> operation that does less work.  While I am at add additional sanity
> checking to ensure it is a symlink I am renaming.
> 
> Acked-by: Kay Sievers <kay.sievers@vrfy.org>
> Signed-off-by: Eric W. Biederman <ebiederm@aristanetworks.com>

It would be really nice to merge or group this together with the first
three patches.  Other than that,

Acked-by: Tejun Heo <tj@kernel.org>

-- 
tejun
