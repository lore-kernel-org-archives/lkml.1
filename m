Return-Path: <linux-kernel-owner+w=401wt.eu-S1758015AbZCPBQN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758015AbZCPBQN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Mar 2009 21:16:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755653AbZCPBP5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Mar 2009 21:15:57 -0400
Received: from hera.kernel.org ([140.211.167.34]:52408 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755617AbZCPBP4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Mar 2009 21:15:56 -0400
Message-ID: <49BDA842.1090208@kernel.org>
Date: Mon, 16 Mar 2009 10:15:46 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Jens Axboe <jens.axboe@oracle.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: [GIT PATCH] block: cleanup patches
References: <1236920578-2179-1-git-send-email-tj@kernel.org> <49BB0FB7.2070109@kernel.org> <20090315164526.GD27476@kernel.dk>
In-Reply-To: <20090315164526.GD27476@kernel.dk>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Mon, 16 Mar 2009 01:15:51 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jens Axboe wrote:
> On Sat, Mar 14 2009, Tejun Heo wrote:
>> Tejun Heo wrote:
>>> Hello,
>>>
>>> This patchset is available in the following git tree.
>>>
>>>  git://git.kernel.org/pub/scm/linux/kernel/git/tj/misc.git block-cleanup
>>>
>>> This patchset contains the following 14 cleanup patches.
>> Jens, once you're okay with the rest of the changes, I'll remove IDE
>> related stuff and repost the patchset.
> 
> I only gave it a quick glance, looks mostly OK. Though I don't like
> putting elv_ prefixed stuff in blk-core. I agree it belongs there
> though, it's really block layer functionality and not io scheduler
> interfacing. So rename it blk_ instead and put compatability names in
> the header file instead.

Yeap, that exactly is what's planned (the peek/fetch patches :-).

> I'll give it a more thorough review and integration test tomorrow.

Thanks.

-- 
tejun
