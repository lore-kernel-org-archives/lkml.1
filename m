Return-Path: <linux-kernel-owner+w=401wt.eu-S1750849AbZHNECF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750849AbZHNECF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Aug 2009 00:02:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750717AbZHNECF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Aug 2009 00:02:05 -0400
Received: from mailhost3.gawab.com ([66.220.20.3]:48898 "HELO info8.gawab.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1750726AbZHNECE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Aug 2009 00:02:04 -0400
X-Trusted: Whitelisted
From: Al Boldi <a1426z@gawab.com>
To: Nitin Gupta <ngupta@vflare.org>
Subject: Re: compcache as a pre-swap area (was: [PATCH] swap: send callback  when swap slot is freed)
Date: Fri, 14 Aug 2009 07:02:23 +0300
User-Agent: KMail/1.5
Cc: Hugh Dickins <hugh.dickins@tiscali.co.uk>,
       Matthew Wilcox <willy@linux.intel.com>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org
References: <200908122007.43522.ngupta@vflare.org> <200908130805.36787.a1426z@gawab.com> <d760cf2d0908131031i2305f2deqe20d6a96c8d568af@mail.gmail.com>
In-Reply-To: <d760cf2d0908131031i2305f2deqe20d6a96c8d568af@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200908140702.23947.a1426z@gawab.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Nitin Gupta wrote:
> compcache is really not really a swap replacement. Its just another
> swap device that
> compresses data and stores it in memory itself. You can have disk
> based swaps along
> with ramzswap (name of block device).

So once compcache fills up, it will start to age its contents into normal 
swap?


Thanks!

--
Al

