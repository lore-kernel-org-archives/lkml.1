Return-Path: <linux-kernel-owner+w=401wt.eu-S1757975AbYDZWSY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757975AbYDZWSY (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Apr 2008 18:18:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755328AbYDZWSS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Apr 2008 18:18:18 -0400
Received: from smtp-out04.alice-dsl.net ([88.44.63.6]:9965 "EHLO
	smtp-out04.alice-dsl.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755287AbYDZWSR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Apr 2008 18:18:17 -0400
To: Ingo Molnar <mingo@elte.hu>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Yinghai Lu <yinghai.lu@sun.com>, Yinghai Lu <yhlu.kernel@gmail.com>,
       jbarnes@virtuousgeek.org
Subject: Re: [RFC git pull] "big box" x86 changes
From: Andi Kleen <andi@firstfloor.org>
References: <20080426185516.GA32364@elte.hu>
Date: Sun, 27 Apr 2008 00:17:32 +0200
In-Reply-To: <20080426185516.GA32364@elte.hu> (Ingo Molnar's message of "Sat, 26 Apr 2008 20:55:16 +0200")
Message-ID: <87bq3ww9ab.fsf@basil.nowhere.org>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/21.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 26 Apr 2008 22:10:41.0506 (UTC) FILETIME=[5DA0BC20:01C8A7EA]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar <mingo@elte.hu> writes:
>
> Most of the work has been done by Yinghai Lu who has gone through a 
> heroic effort to fix all the big-box bugs that he encountered on the 
> vanilla Linux kernel on his various up to 256 GB RAM test-systems. Also 
> work is included from Ying Huang for those insane SGI UV boxes.

Just to make things clear for the list readers, x86-64 worked fine for years 
on 256GB systems.

Many of the problems fixed in this tree are either relatively recent
regressions or have nothing to do with large boxes or 256GB (like the mmconfig
changes)

-Andi
