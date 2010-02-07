Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752872Ab0BGIXz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Feb 2010 03:23:55 -0500
Received: from mail.parknet.co.jp ([210.171.160.6]:59593 "EHLO
	mail.parknet.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752561Ab0BGIXx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Feb 2010 03:23:53 -0500
From: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
To: "J. Bruce Fields" <bfields@fieldses.org>
Cc: Neil Brown <neilb@suse.de>, linux-nfs@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: Failure to fallback to nfsd-v3 (?)
References: <87pr4h67rf.fsf@devron.myhome.or.jp>
	<20100207041016.GA16865@fieldses.org>
Date: Sun, 07 Feb 2010 17:23:49 +0900
In-Reply-To: <20100207041016.GA16865@fieldses.org> (J. Bruce Fields's message
	of "Sat, 6 Feb 2010 23:10:16 -0500")
Message-ID: <8763695u96.fsf@devron.myhome.or.jp>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1.92 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"J. Bruce Fields" <bfields@fieldses.org> writes:

>> And the following commit seems to change the behavior.
>> 
>> [nfsd4: fix error return when pseudoroot missing]
>> f39bde24b275ddc45df1ed835725b609e178c7a0
>> 
>> Well, anyway, is this a expected behavior change, or something bug?
>
> It's expected.  I'd recommend turning off nfsv4 on the server (add "-N4"
> to the rpc.nfsd commandline) for now.

This looks like the silent user visible change. So, it would be better
to add more comment at least in changelog.

Well, anyway, thanks. (BTW, I assumed rpc.nfsd is typo of rpc.mountd)
-- 
OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
