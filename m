Return-Path: <linux-kernel-owner+w=401wt.eu-S1761134AbZLOV3O@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761134AbZLOV3O (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Dec 2009 16:29:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761116AbZLOV3N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Dec 2009 16:29:13 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46512 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761106AbZLOV3M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Dec 2009 16:29:12 -0500
Date: Tue, 15 Dec 2009 13:28:03 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: h-shimamoto@ct.jp.nec.com, joe@perches.com, mingo@elte.hu,
       nooiwa@miraclelinux.com, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [folded]
 kernelh-add-printk_ratelimited-and-pr_level_rl-rename.patch removed from
 -mm tree
Message-Id: <20091215132803.2e5ee7bc.akpm@linux-foundation.org>
In-Reply-To: <1260872882.4165.353.camel@twins>
References: <200912150108.nBF18TNx015047@imap1.linux-foundation.org>
	<1260872882.4165.353.camel@twins>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 15 Dec 2009 11:28:02 +0100
Peter Zijlstra <peterz@infradead.org> wrote:

> On Mon, 2009-12-14 at 17:08 -0800, akpm@linux-foundation.org wrote:
> > s/_rl/_ratelimited/g
> 
> do we feel this pr_* wankery is worth the hassle? I'd as soon send a
> patch removing all this crap.

I thought it was just me.  No, I find it a net negative, but I don't
work on drivers all day.

otoh, every second driver seems to find it necessary to invent its own
handy printk wrappers, so being able to point people at standardized
ones does offer some improvement over that.

