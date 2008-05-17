Return-Path: <linux-kernel-owner+w=401wt.eu-S1756827AbYEQA2y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756827AbYEQA2y (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2008 20:28:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754220AbYEQA2m
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 May 2008 20:28:42 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:53361
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1760802AbYEQA2l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2008 20:28:41 -0400
Date: Fri, 16 May 2008 17:28:35 -0700 (PDT)
Message-Id: <20080516.172835.260358594.davem@davemloft.net>
To: torvalds@linux-foundation.org
Cc: tglx@linutronix.de, linux-kernel@vger.kernel.org, mingo@elte.hu,
       hpa@zytor.com
Subject: Re: [GIT pull] x86 fixes for 2.6.26
From: David Miller <davem@davemloft.net>
In-Reply-To: <alpine.LFD.1.10.0805161658450.3020@woody.linux-foundation.org>
References: <alpine.LFD.1.10.0805161544080.3020@woody.linux-foundation.org>
	<alpine.LFD.1.10.0805170116490.3255@apollo.tec.linutronix.de>
	<alpine.LFD.1.10.0805161658450.3020@woody.linux-foundation.org>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Fri, 16 May 2008 17:03:37 -0700 (PDT)

> See the difference? You literally merged four times in two days. That's 
> not "keeping reasonably up-to-date", that's just messy and OCD.

Have a look at my networking tree if you want to see an example of how
to handle things Thomas.

I think I merged from Linus's tree only 3 or 4 times maximum since I
created that tree way back when the 2.6.26 merge window opened up.

If users, or even you, want to get a bug fix from Linus's tree or check
if there will be merge conflicts, just create a test branch and play
with such things there.

The topic branch or topic tree should just keep developing,
essentially living in it's own world oblivious to what is going on
upstream.  And it should stay this way until an unavoidable merge
conflict needs to be resolved or things become uncomfortably out of
sync.
