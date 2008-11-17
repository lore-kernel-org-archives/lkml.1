Return-Path: <linux-kernel-owner+w=401wt.eu-S1752700AbYKQTWR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752700AbYKQTWR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2008 14:22:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751835AbYKQTV7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Nov 2008 14:21:59 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:32888
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751737AbYKQTV6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2008 14:21:58 -0500
Date: Mon, 17 Nov 2008 11:21:57 -0800 (PST)
Message-Id: <20081117.112157.146825192.davem@davemloft.net>
To: mingo@elte.hu
Cc: rjw@sisk.pl, linux-kernel@vger.kernel.org, kernel-testers@vger.kernel.org,
       cl@linux-foundation.org, efault@gmx.de, a.p.zijlstra@chello.nl,
       torvalds@linux-foundation.org
Subject: Re: [Bug #11308] tbench regression on each kernel release from
 2.6.22 -&gt; 2.6.28
From: David Miller <davem@davemloft.net>
In-Reply-To: <20081117110119.GL28786@elte.hu>
References: <20081117090648.GG28786@elte.hu>
	<20081117.011403.06989342.davem@davemloft.net>
	<20081117110119.GL28786@elte.hu>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ingo Molnar <mingo@elte.hu>
Date: Mon, 17 Nov 2008 12:01:19 +0100

> The scheduler's overhead barely even registers on a 16-way x86 system 
> i'm running tbench on. Here's the NMI profile during 64 threads tbench 
> on a 16-way x86 box with an v2.6.28-rc5 kernel [config attached]:

Try a non-NMI profile.

It's the whole of the try_to_wake_up() path that's the problem.
