Return-Path: <linux-kernel-owner+w=401wt.eu-S936023AbXFFVkX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936023AbXFFVkX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2007 17:40:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935040AbXFFVkJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jun 2007 17:40:09 -0400
Received: from mx1.redhat.com ([66.187.233.31]:40597 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934915AbXFFVkI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2007 17:40:08 -0400
Message-ID: <466728D6.30200@sandeen.net>
Date: Wed, 06 Jun 2007 16:36:22 -0500
From: Eric Sandeen <sandeen@sandeen.net>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Chris Wright <chrisw@sous-sol.org>
CC: gregkh@suse.de, akpm@linux-foundation.org, htejun@gmail.com,
       linux-kernel@vger.kernel.org, maneesh@in.ibm.com, sandeen@redhat.com,
       stable@kernel.org
Subject: Re: [stable] patch	sysfs-store-sysfs-inode-nrs-in-s_ino-to-avoid-readdir-oopses.patch
 queued to -stable tree
References: <46525648.8050807@sandeen.net> <20070606194950.D357EE83785@imap.suse.de> <20070606213543.GS3723@sequoia.sous-sol.org>
In-Reply-To: <20070606213543.GS3723@sequoia.sous-sol.org>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Chris Wright wrote:
> * gregkh@suse.de (gregkh@suse.de) wrote:
>> From: Eric Sandeen <sandeen@sandeen.net>
>> Subject: sysfs: store sysfs inode nrs in s_ino to avoid readdir oopses
>>
>> Backport of
>> ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.22-rc1/2.6.22-rc1-mm1/broken-out/gregkh-driver-sysfs-allocate-inode-number-using-ida.patch
>>
> 
> I didn't put this into -stable queue because the ida version is not
> upstream yet, so I don't think it's appropriate to backport it at this
> point in time.

Well, my backport of Tejun's patch explicitly doesn't use ida for just
that reason...

It uses a simple counter instead (which may give dup inode numbers, but
I think we have that today, and at least this shouldn't oops...)

*shrug*

-Eric

> thanks,
> -chris
> 

