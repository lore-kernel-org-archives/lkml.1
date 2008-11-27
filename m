Return-Path: <linux-kernel-owner+w=401wt.eu-S1754482AbYK0LIp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754482AbYK0LIp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2008 06:08:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752301AbYK0LIg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Nov 2008 06:08:36 -0500
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:59265 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752256AbYK0LIf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2008 06:08:35 -0500
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [RFC v1][PATCH]page_fault retry with NOPAGE_RETRY
Cc: kosaki.motohiro@jp.fujitsu.com, Mike Waychison <mikew@google.com>,
       Nick Piggin <npiggin@suse.de>, Ying Han <yinghan@google.com>,
       Ingo Molnar <mingo@elte.hu>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org, akpm <akpm@linux-foundation.org>,
       David Rientjes <rientjes@google.com>, Rohit Seth <rohitseth@google.com>,
       Hugh Dickins <hugh@veritas.com>, "H. Peter Anvin" <hpa@zytor.com>,
       edwintorok@gmail.com
In-Reply-To: <1227780007.4454.1344.camel@twins>
References: <492E6849.6090205@google.com> <1227780007.4454.1344.camel@twins>
Message-Id: <20081127200501.3CF9.KOSAKI.MOTOHIRO@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.42 [ja]
Date: Thu, 27 Nov 2008 20:08:29 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Furthermore, /proc code usually isn't written with performance in mind,
> so its usually simple and robust code. Adding it to a 'hot'-path like
> you're doing doesn't seem advisable.
> 
> Also, releasing and re-acquiring mmap_sem can significantly add to the
> cacheline bouncing that thing already has.

Interesting.

I tryed to demonstration /proc slowness.

1. make many process
	$ nice ./hackbench 120 process 10000

2. read /proc
	$ time ps -ef

	0.16s user 0.57s system 1% cpu 46.859 total


HAHAHA!
That is really slow over my expected.



