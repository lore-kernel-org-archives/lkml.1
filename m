Return-Path: <linux-kernel-owner+w=401wt.eu-S966082AbXDCBHp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966082AbXDCBHp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Apr 2007 21:07:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966138AbXDCBHp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Apr 2007 21:07:45 -0400
Received: from mail09.syd.optusnet.com.au ([211.29.132.190]:34185 "EHLO
	mail09.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S966082AbXDCBHo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Apr 2007 21:07:44 -0400
From: Con Kolivas <kernel@kolivas.org>
To: Ingo Molnar <mingo@elte.hu>
Subject: Re: [test] hackbench.c interactivity results: vanilla versus SD/RSDL
Date: Tue, 3 Apr 2007 11:07:22 +1000
User-Agent: KMail/1.9.5
Cc: linux list <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Mike Galbraith <efault@gmx.de>
References: <20070329112249.GA32665@elte.hu>
In-Reply-To: <20070329112249.GA32665@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200704031107.22642.kernel@kolivas.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 29 March 2007 21:22, Ingo Molnar wrote:
> [ A quick guess: could SD's substandard interactivity in this test be
>   due to the SMP migration logic inconsistencies Mike noticed? This is
>   an SMP system and the hackbench workload is very scheduling intense
>   and tasks are frequently queued from one CPU to another. ]

I assume you put it on and endless loop since hackbench 10 runs for .5 second 
on my machine. Doubtful it's an SMP issue. update_if_moved should maintain 
cross cpu scheduling decisions. The same slowdown would happen on UP and is 
almost certainly due to the fact that hackbench 10 induces a load of _160_ on 
the machine.

-- 
-ck
