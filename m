Return-Path: <linux-kernel-owner+w=401wt.eu-S1756867AbYD0IZI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756867AbYD0IZI (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Apr 2008 04:25:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752946AbYD0IYu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Apr 2008 04:24:50 -0400
Received: from one.firstfloor.org ([213.235.205.2]:33465 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752486AbYD0IYt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Apr 2008 04:24:49 -0400
Date: Sun, 27 Apr 2008 10:30:51 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Yinghai Lu <yhlu.kernel@gmail.com>
Cc: Andi Kleen <andi@firstfloor.org>, Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       jbarnes@virtuousgeek.org
Subject: Re: [RFC git pull] "big box" x86 changes
Message-ID: <20080427083051.GH17905@one.firstfloor.org>
References: <20080426185516.GA32364@elte.hu> <87bq3ww9ab.fsf@basil.nowhere.org> <86802c440804262014p36c77fe1x54b64e8e44be6b8@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <86802c440804262014p36c77fe1x54b64e8e44be6b8@mail.gmail.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Are you sure? I don't know who had 256g ram with x86-64 that earlier.

IBM Summit. We tested that a couple of years ago.

I think the worst regressions you had to fix came from the vmemmap merge
BTW. It pretty much reintroduced some mistakes in memory placing that
the original code had too and which were fixed back then.

-Andi
