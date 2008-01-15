Return-Path: <linux-kernel-owner+w=401wt.eu-S1755246AbYAODU1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755246AbYAODU1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jan 2008 22:20:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753277AbYAODUR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Jan 2008 22:20:17 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:37750 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751597AbYAODUP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jan 2008 22:20:15 -0500
Date: Tue, 15 Jan 2008 12:20:10 +0900
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Rik van Riel <riel@redhat.com>
Subject: Re: [RFC] mmaped copy too slow?
Cc: kosaki.motohiro@jp.fujitsu.com, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20080114211540.284df4fb@bree.surriel.com>
References: <20080115100450.1180.KOSAKI.MOTOHIRO@jp.fujitsu.com> <20080114211540.284df4fb@bree.surriel.com>
Message-Id: <20080115115318.1191.KOSAKI.MOTOHIRO@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.42 [ja]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Rik

> While being able to deal with used-once mappings in page reclaim
> could be a good idea, this would require us to be able to determine
> the difference between a page that was accessed once since it was
> faulted in and a page that got accessed several times.

it makes sense that read ahead hit assume used-once mapping, may be.
I will try it.

(may be, i can repost soon)

> Given that page faults have overhead too, it does not surprise me
> that read+write is faster than mmap+memcpy.
> 
> In threaded applications, page fault overhead will be worse still,
> since the TLBs need to be synchronized between CPUs (at least at
> reclaim time).

sure.
but current is unnecessary large performance difference.
I hope improvement it because copy by mmapd is very common operation.

> Maybe we should just advise people to use read+write, since it is
> faster than mmap+memcpy?

Time is solved to it :)
thanks!


- kosaki



