Return-Path: <linux-kernel-owner+w=401wt.eu-S1754479AbZIHLFf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754479AbZIHLFf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Sep 2009 07:05:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754440AbZIHLFe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Sep 2009 07:05:34 -0400
Received: from brick.kernel.dk ([93.163.65.50]:46831 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754416AbZIHLFe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Sep 2009 07:05:34 -0400
Date: Tue, 8 Sep 2009 13:05:36 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Artem Bityutskiy <dedekind1@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       chris.mason@oracle.com, david@fromorbit.com, hch@infradead.org,
       akpm@linux-foundation.org, jack@suse.cz
Subject: Re: [PATCH 1/8] writeback: get rid of generic_sync_sb_inodes()
	export
Message-ID: <20090908110536.GV18599@kernel.dk>
References: <1252401791-22463-1-git-send-email-jens.axboe@oracle.com> <1252401791-22463-2-git-send-email-jens.axboe@oracle.com> <4AA631AA.6000803@gmail.com> <20090908104111.GS18599@kernel.dk> <1252407150.5060.51.camel@localhost> <20090908105728.GU18599@kernel.dk> <4AA63992.7040200@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4AA63992.7040200@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 08 2009, Artem Bityutskiy wrote:
> On 09/08/2009 01:57 PM, Jens Axboe wrote:
>>> But well, if you do not want to carry my patch, then I'll have to
>>> re-base my tree later, fix stuff, and send a pull request. I mean,
>>> your stuff will for sure be merged first, because I send pull requests
>>> late, just because UBIFS is a minor thing in the kernel.
>>
>> You don't have to rebase, if my work is merged first then you just merge
>> Linus' tree into yours and fixup the conflict before asking Linus to
>> pull.
>
> I thought Linus asked to avoid merge commits in pull requests at some
> point, no? So I thought that I'd re-base then, which Linus also
> dislikes :-)

Pointless merges are discouraged, but this one isn't pointless since it
resolves a conflict. If you rebase, Linus will flame your ass to a
crisp, I know from personal experience :-)

>> It's a trivial conflict, I don't understand what the fuzz is about.
>
> Well, I was just thinking how to avoid merge commits. But I guess I can
> do what you suggest.

Just don't worry about it, things are fine as-is. When the conflict
happens with the mainline tree, fix it up. If it was a more involved
depdency chain, we could do something more about it. But for this, I'd
say it's a lot more work to attempt to "fix" something that is a 10s
merge issue at pull time.

-- 
Jens Axboe

