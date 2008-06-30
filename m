Return-Path: <linux-kernel-owner+w=401wt.eu-S1755357AbYF3ACa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755357AbYF3ACa (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jun 2008 20:02:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752787AbYF3ACQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Jun 2008 20:02:16 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42713 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752064AbYF3ACP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jun 2008 20:02:15 -0400
Date: Sun, 29 Jun 2008 17:01:52 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Takashi Sato" <t-sato@yk.jp.nec.com>
Cc: <viro@ZenIV.linux.org.uk>, <linux-ext4@vger.kernel.org>, <xfs@oss.sgi.com>,
       <dm-devel@redhat.com>, <linux-fsdevel@vger.kernel.org>,
       <linux-kernel@vger.kernel.org>, <axboe@kernel.dk>,
       <mtk.manpages@googlemail.com>
Subject: Re: [PATCH 3/3] Add timeout feature
Message-Id: <20080629170152.aa769918.akpm@linux-foundation.org>
In-Reply-To: <C2E97AF9310E467696FA7F4C62C88AC5@nsl.ad.nec.co.jp>
References: <20080624160056t-sato@mail.jp.nec.com>
	<20080624150925.765155f0.akpm@linux-foundation.org>
	<7B349EFCD35842D4ADAEB402D2BDCA4E@nsl.ad.nec.co.jp>
	<20080627115727.149dcb2e.akpm@linux-foundation.org>
	<C2E97AF9310E467696FA7F4C62C88AC5@nsl.ad.nec.co.jp>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 30 Jun 2008 08:13:07 +0900 "Takashi Sato" <t-sato@yk.jp.nec.com> wrote:

> > It's much better to use NULL here rather than literal zero because the
> > reader of this code can then say "ah-hah, we're passing in a pointer". 
> > Whereas plain old "0" could be a pointer or a scalar.
> 
> The second argument's type of freeze_bdev() is "long", not pointer as below.
> struct super_block *freeze_bdev(struct block_device *, long timeout_msec);

oh, ok, I goofed, sorry.

> So "0" is reasonable, isn't it?

yup.
