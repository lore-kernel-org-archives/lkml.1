Return-Path: <linux-kernel-owner+w=401wt.eu-S1765717AbXGPWL0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765717AbXGPWL0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jul 2007 18:11:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761412AbXGPWK7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Jul 2007 18:10:59 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:35562
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1760834AbXGPWK6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jul 2007 18:10:58 -0400
Date: Mon, 16 Jul 2007 15:08:25 -0700 (PDT)
Message-Id: <20070716.150825.66176632.davem@davemloft.net>
To: torvalds@linux-foundation.org
Cc: mingo@elte.hu, linux-kernel@vger.kernel.org, olaf.kirch@oracle.com
Subject: Re: [patch] revert: [NET]: Fix races in net_rx_action vs netpoll
From: David Miller <davem@davemloft.net>
In-Reply-To: <alpine.LFD.0.999.0707161425361.20061@woody.linux-foundation.org>
References: <20070716091236.GA10718@elte.hu>
	<20070716.042640.18306462.davem@davemloft.net>
	<alpine.LFD.0.999.0707161425361.20061@woody.linux-foundation.org>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Mon, 16 Jul 2007 14:40:38 -0700 (PDT)

> If we don't know what caused a problem in the first place, or if the fix 
> is known to be required for something else and reverting it would cause 
> *another* regression, it would be another issue. But as it is, reverting 
> it would seem to unquestionably get rid of a regression, and is thus a 
> no-brainer.
> 
> No?

Sure, but I thought it would be nice to give Olaf a day or two to
figure out what's going on rather than have the knee-jerk reaction to
just revert.

Ingo is the only person hitting and reporting this and last time I
checked he is competent enough to revert the thing locally in his own
trees, right? :-)
