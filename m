Return-Path: <linux-kernel-owner+w=401wt.eu-S935512AbYDQJ56@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935512AbYDQJ56 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2008 05:57:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763785AbYDQJaF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Apr 2008 05:30:05 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:36805 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934090AbYDQJaB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2008 05:30:01 -0400
Date: Thu, 17 Apr 2008 18:30:11 +0900
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: "Tom May" <tom@tommay.com>
Subject: Re: [PATCH 0/8][for -mm] mem_notify v6
Cc: kosaki.motohiro@jp.fujitsu.com, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <ab3f9b940804141716x755787f5h8e0122c394922a83@mail.gmail.com>
References: <20080402154910.9588.KOSAKI.MOTOHIRO@jp.fujitsu.com> <ab3f9b940804141716x755787f5h8e0122c394922a83@mail.gmail.com>
Message-Id: <20080417182121.A8CA.KOSAKI.MOTOHIRO@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.42 [ja]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Tom

> Here's a test program that allocates memory and frees on notification.
>  It takes an argument which is the number of pages to use; use a
> number considerably higher than the amount of memory in the system.
> I'm running this on a system without swap.  Each time it gets a
> notification, it frees memory and writes out the /proc/meminfo
> contents.  What I see is that Cached gradually decreases, then Mapped
> decreases, and eventually the kernel invokes the oom killer.  It may
> be necessary to tune some of the constants that control the allocation
> and free rates and latency; these values work for my system.

may be...

I think you misunderstand madvise(MADV_DONTNEED).  
madvise(DONTNEED) indicate drop process page table.
it mean become easily swap.

when run on system without swap, madvise(DONTNEED) almost doesn't work
as your expected.

I am sorry for being not able to help you. ;)



