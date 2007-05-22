Return-Path: <linux-kernel-owner+w=401wt.eu-S1765401AbXEVKz6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765401AbXEVKz6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2007 06:55:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756833AbXEVKzv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 May 2007 06:55:51 -0400
Received: from mail01.syd.optusnet.com.au ([211.29.132.182]:40501 "EHLO
	mail01.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755116AbXEVKzu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2007 06:55:50 -0400
From: Con Kolivas <kernel@kolivas.org>
To: Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH] mm: swap prefetch improvements
Date: Tue, 22 May 2007 20:54:46 +1000
User-Agent: KMail/1.9.5
Cc: Antonino Ingargiola <tritemio@gmail.com>,
       Nick Piggin <nickpiggin@yahoo.com.au>, Ray Lee <ray-lk@madrabbit.org>,
       ck list <ck@vds.kolivas.org>, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org
References: <20070430162007.ad46e153.akpm@linux-foundation.org> <200705222037.54741.kernel@kolivas.org> <20070522104648.GA10622@elte.hu>
In-Reply-To: <20070522104648.GA10622@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200705222054.46488.kernel@kolivas.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 22 May 2007 20:46, Ingo Molnar wrote:
> It clearly should not consider 'itself' as IO activity. This suggests
> some bug in the 'detect activity' mechanism, agreed? I'm wondering
> whether you are seeing the same problem, or is all swap-prefetch IO on
> your system continuous until it's done [or some other IO comes
> inbetween]?

When nothing else is happening anywhere on the system it reads in bursts and 
goes to sleep during journal writeout.
 
-- 
-ck
