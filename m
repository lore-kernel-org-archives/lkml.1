Return-Path: <linux-kernel-owner+w=401wt.eu-S1757660AbZJDSjB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757660AbZJDSjB (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Oct 2009 14:39:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757624AbZJDSjA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Oct 2009 14:39:00 -0400
Received: from brick.kernel.dk ([93.163.65.50]:60686 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757440AbZJDSjA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Oct 2009 14:39:00 -0400
Date: Sun, 4 Oct 2009 20:38:22 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Mike Galbraith <efault@gmx.de>
Cc: Vivek Goyal <vgoyal@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Ulrich Lukas <stellplatz-nr.13a@datenparkplatz.de>,
       linux-kernel@vger.kernel.org, containers@lists.linux-foundation.org,
       dm-devel@redhat.com, nauman@google.com, dpshah@google.com,
       lizf@cn.fujitsu.com, mikew@google.com, fchecconi@gmail.com,
       paolo.valente@unimore.it, ryov@valinux.co.jp, fernando@oss.ntt.co.jp,
       jmoyer@redhat.com, dhaval@linux.vnet.ibm.com, balbir@linux.vnet.ibm.com,
       righi.andrea@gmail.com, m-ikeda@ds.jp.nec.com, agk@redhat.com,
       akpm@linux-foundation.org, peterz@infradead.org, jmarchan@redhat.com,
       riel@redhat.com
Subject: Re: Do not overload dispatch queue (Was: Re: IO scheduler based IO
	controller V10)
Message-ID: <20091004183822.GF26573@kernel.dk>
References: <1254581496.8293.8.camel@marge.simson.net> <20091003151445.GF31616@kernel.dk> <1254585420.7539.2.camel@marge.simson.net> <20091003173532.GG31616@kernel.dk> <1254596864.7153.9.camel@marge.simson.net> <20091003192321.GA26573@kernel.dk> <1254599386.7153.46.camel@marge.simson.net> <1254653434.7237.18.camel@marge.simson.net> <20091004173901.GD26573@kernel.dk> <1254680622.27889.2.camel@marge.simson.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1254680622.27889.2.camel@marge.simson.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 04 2009, Mike Galbraith wrote:
> On Sun, 2009-10-04 at 19:39 +0200, Jens Axboe wrote:
> 
> > So I'll commit a change that doesn't do the delay at all, basically it
> > just offset the current code by one slice.
> 
> Ok, when it hits block-for-linus, I'll take it out for a spin.

It's committed:

http://git.kernel.dk/?p=linux-2.6-block.git;a=commit;h=e00c54c36ac2024c3a8a37432e2e2698ff849594

-- 
Jens Axboe

