Return-Path: <linux-kernel-owner+w=401wt.eu-S1756904AbZCSATp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756904AbZCSATp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Mar 2009 20:19:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752376AbZCSATe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Mar 2009 20:19:34 -0400
Received: from hera.kernel.org ([140.211.167.34]:59768 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752272AbZCSATd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Mar 2009 20:19:33 -0400
Message-ID: <49C18F8B.8090306@kernel.org>
Date: Thu, 19 Mar 2009 09:19:23 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
CC: axboe@kernel.dk, linux-kernel@vger.kernel.org
Subject: Re: [GIT PATCH] block: cleanup patches, take#2
References: <1237170540-19130-1-git-send-email-tj@kernel.org> <200903161853.14268.bzolnier@gmail.com> <49BEEA64.6060607@kernel.org> <200903181817.11456.bzolnier@gmail.com>
In-Reply-To: <200903181817.11456.bzolnier@gmail.com>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Thu, 19 Mar 2009 00:19:27 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

Bartlomiej Zolnierkiewicz wrote:
>> Heh... for some reason, I think Stephen wouldn't have much problem
>> merging those conflicts.
> 
> Well, you can just ask Stephen if he is fine with fixing merge conflicts
> for a week or so.  If he agrees fine with me.  I just wouldn't like to see
> the _whole_ tree dropped from linux-next because of the last moment block
> _cleanup_ patches.

Okay, let's postpone them to .31 window.

>> I understand that you're constrained time and resource-wise and will
>> be happy to make things easier on your side but options are severely
>> limited if you don't want to take any changes other than from
>> upstream.  It would be best if you can maintain IDE changes in a git
>> tree.  All that you lose are petty controls over change history.  The
>> tree might look less tidy but it makes things much easier when
>> multiple trees are involved.  I'll be happy to provide merge commits
> 
> I have been planning on quilt -> git conversion of pata-2.6 tree for some
> time now but these merge conflicts happen very seldom (once in 6-12 months)
> while the transition period would require quite a lot of time and work...
> 
> Anyway point taken.

Ah... that sounds great.  Yeah, conversion does take time and effort
to get accustomed to, but I think it will be well worth the while.

>> between blk and ide at sync points, so that you can pull from them and
>> don't have to worry about conflicts.  I don't really think it will add
>> a lot to your workload.
>>
>> That said, let's postpone this patchset post -rc1 window and see how
>> things can be worked out then.  Hmmm... I'll move the IDE patches on
>> top of linux-next/pata-2.6 with other IDE patches.
> 
> Please do and thanks for understanding.
> 
> I think that we can deal with the rest of patches without a problem in the
> second week of the merge window so everything will be nicely sorted out by
> the time of -rc1.

Thanks.  Much appreciated.  I'll send IDE patchset in a few days.

-- 
tejun
