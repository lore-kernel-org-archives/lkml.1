Return-Path: <linux-kernel-owner+w=401wt.eu-S1760288AbZE3Ksq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760288AbZE3Ksq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 May 2009 06:48:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757581AbZE3Ksh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 30 May 2009 06:48:37 -0400
Received: from hera.kernel.org ([140.211.167.34]:57032 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755276AbZE3Ksg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 May 2009 06:48:36 -0400
Message-ID: <4A210EFA.5080103@kernel.org>
Date: Sat, 30 May 2009 19:48:26 +0900
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
References: <m1zlcwltri.fsf_-_@fess.ebiederm.org>	<1243551665-23596-22-git-send-email-ebiederm@xmission.com>	<4A1FA7F4.9000708@kernel.org> <m1iqjjbzh8.fsf@fess.ebiederm.org>
In-Reply-To: <m1iqjjbzh8.fsf@fess.ebiederm.org>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Sat, 30 May 2009 10:48:29 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Eric W. Biederman wrote:
> Tejun Heo <tj@kernel.org> writes:
> 
>> Eric W. Biederman wrote:
>>> From: Eric W. Biederman <ebiederm@xmission.com>
>>>
>>> Use the existing sysfs_rename to make sysfs_rename_link an atomic
>>> operation that does less work.  While I am at add additional sanity
>>> checking to ensure it is a symlink I am renaming.
>>>
>>> Acked-by: Kay Sievers <kay.sievers@vrfy.org>
>>> Signed-off-by: Eric W. Biederman <ebiederm@aristanetworks.com>
>> It would be really nice to merge or group this together with the first
>> three patches.  Other than that,
> 
> Perfection is the enemy of the good on that one.  That just convolutes
> things unnecessarily, makes the patches harder to review, and requires
> additional testing.
>
> I much prefer to work in a tree without rewinding.

Everything is a matter of degree and I don't think my bar here was too
high.  Unless patches are in some exported tree and when the content
of the patchset changes (you're changing the behavior of the same code
two times), reordering patches is what's usually done.  When the end
results stay the same, reshuffling isn't that much of work, is it?

Well, I'm not the maintainer and things like this are mostly upto the
maintainer, so let's leave it to be decided by Greg.

Thanks.

-- 
tejun
