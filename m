Return-Path: <linux-kernel-owner+w=401wt.eu-S1752967AbZHMFFK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752967AbZHMFFK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Aug 2009 01:05:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752802AbZHMFFJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Aug 2009 01:05:09 -0400
Received: from mailhost11.gawab.com ([66.220.20.11]:35853 "HELO
	info12.gawab.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751702AbZHMFFI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Aug 2009 01:05:08 -0400
X-Trusted: Whitelisted
From: Al Boldi <a1426z@gawab.com>
To: ngupta@vflare.org, Hugh Dickins <hugh.dickins@tiscali.co.uk>
Subject: compcache as a pre-swap area (was: [PATCH] swap: send callback when swap slot is freed)
Date: Thu, 13 Aug 2009 08:05:36 +0300
User-Agent: KMail/1.5
Cc: Matthew Wilcox <willy@linux.intel.com>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org
References: <200908122007.43522.ngupta@vflare.org> <Pine.LNX.4.64.0908122312380.25501@sister.anvils> <4A837D5A.3070407@vflare.org>
In-Reply-To: <4A837D5A.3070407@vflare.org>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200908130805.36787.a1426z@gawab.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Nitin Gupta wrote:
> BTW, last time compcache was not accepted due to lack of performance
> numbers. Now the project has lot more data for various cases:
> http://code.google.com/p/compcache/wiki/Performance
> Still need to collect data for worst-case behaviors and such...

I checked the link, and it looks like you are positioning compcache as a swap 
replacement.  If so, then repositioning it as a compressed pre-swap area 
working together with normal swap-space, if available, may yield a much more 
powerful system.


Thanks!

--
Al

