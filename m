Return-Path: <linux-kernel-owner+w=401wt.eu-S934199AbZGQHxm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934199AbZGQHxm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jul 2009 03:53:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934179AbZGQHxl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Jul 2009 03:53:41 -0400
Received: from hera.kernel.org ([140.211.167.34]:48047 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934174AbZGQHxk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jul 2009 03:53:40 -0400
Message-ID: <4A602DF1.4060409@kernel.org>
Date: Fri, 17 Jul 2009 16:53:21 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Danny Feng <dfeng@redhat.com>
CC: axboe@kernel.dk, linux-kernel@vger.kernel.org
Subject: Re: [PATCH V2] block: sysfs fix mismatched queue_var_{store,show}
 in 64bit kernel
References: <1247572618-24073-1-git-send-email-dfeng@redhat.com> <1247580906-24762-1-git-send-email-dfeng@redhat.com> <4A601ED2.50800@kernel.org> <4A602AA1.70908@redhat.com>
In-Reply-To: <4A602AA1.70908@redhat.com>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Fri, 17 Jul 2009 07:53:25 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

Danny Feng wrote:
>     Thank you very much for the review, I've attached v3 patch follow
> your advices, please help me review.

Thanks.  I queued the patch on the following temp block tree.

  git://git.kernel.org/pub/scm/linux/kernel/git/tj/misc.git tj-block-for-linus

>     Another thing on block sysfs is that we can echo some invalid value
> (e.g 123abc), should sysfs return -EINVAL for those?

sysfs nodes are only accessible from root and it's customary to not
invest too much into safe guarding the input.  So, leaving as it is
should be fine, I think.

-- 
tejun
