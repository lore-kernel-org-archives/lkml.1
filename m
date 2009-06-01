Return-Path: <linux-kernel-owner+w=401wt.eu-S1753713AbZFAAgU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753713AbZFAAgU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 May 2009 20:36:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752850AbZFAAgG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 31 May 2009 20:36:06 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45168 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752782AbZFAAgF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 May 2009 20:36:05 -0400
Date: Sun, 31 May 2009 17:36:04 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Hisashi Hifumi <hifumi.hisashi@oss.ntt.co.jp>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [RESEND] [PATCH] readahead:add blk_run_backing_dev
Message-Id: <20090531173604.8cbad7f2.akpm@linux-foundation.org>
In-Reply-To: <6.0.0.20.2.20090529142527.071669e0@172.19.0.2>
References: <6.0.0.20.2.20090529142527.071669e0@172.19.0.2>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 29 May 2009 14:35:55 +0900 Hisashi Hifumi <hifumi.hisashi@oss.ntt.co.jp> wrote:

> I added blk_run_backing_dev on page_cache_async_readahead
> so readahead I/O is unpluged to improve throughput on 
> especially RAID environment. 

I skipped the last version of this because KOSAKI Motohiro
<kosaki.motohiro@jp.fujitsu.com> said "Please attach blktrace analysis ;)".

I'm not sure why he asked for that, but he's a smart chap and
presumably had his reasons.

If you think that such an analysis is unneeded, or isn't worth the time
to generate then please tell us that.  But please don't just ignore the
request!

Thanks.

