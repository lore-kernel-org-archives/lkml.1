Return-Path: <linux-kernel-owner+w=401wt.eu-S1756381AbXH1Hnw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756381AbXH1Hnw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Aug 2007 03:43:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751998AbXH1Hnn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Aug 2007 03:43:43 -0400
Received: from smtp28.orange.fr ([80.12.242.100]:7927 "EHLO smtp28.orange.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751722AbXH1Hnm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Aug 2007 03:43:42 -0400
X-ME-UUID: 20070828074341182.2C9FC8000055@mwinf2807.orange.fr
Subject: Re: CFS review
From: Xavier Bestel <xavier.bestel@free.fr>
To: Al Boldi <a1426z@gawab.com>
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
       Mike Galbraith <efault@gmx.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org
In-Reply-To: <200708280737.53439.a1426z@gawab.com>
References: <200708111344.42934.a1426z@gawab.com>
	 <200708271746.47685.a1426z@gawab.com> <20070827204116.GA12495@elte.hu>
	 <200708280737.53439.a1426z@gawab.com>
Content-Type: text/plain
Date: Tue, 28 Aug 2007 09:43:35 +0200
Message-Id: <1188287015.1131.232.camel@frg-rhel40-em64t-04>
Mime-Version: 1.0
X-Mailer: Evolution 2.0.2 (2.0.2-27) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-08-28 at 07:37 +0300, Al Boldi wrote:
> start gears like this:
> 
>   # gears & gears & gears &
> 
> Then lay them out side by side to see the periodic stallings for
> ~10sec.

Are you sure they are stalled ? What you may have is simple gears
running at a multiple of your screen refresh rate, so they only appear
stalled.

Plus, as said Linus, you're not really testing the kernel scheduler.
gears is really bad benchmark, it should die.

	Xav


