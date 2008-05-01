Return-Path: <linux-kernel-owner+w=401wt.eu-S1756263AbYEABvw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756263AbYEABvw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2008 21:51:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752585AbYEABvo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Apr 2008 21:51:44 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:35094
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1752254AbYEABvn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2008 21:51:43 -0400
Date: Wed, 30 Apr 2008 18:51:42 -0700 (PDT)
Message-Id: <20080430.185142.219463829.davem@davemloft.net>
To: torvalds@linux-foundation.org
Cc: rjw@sisk.pl, w@1wt.eu, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, jirislaby@gmail.com
Subject: Re: Slow DOWN, please!!!
From: David Miller <davem@davemloft.net>
In-Reply-To: <alpine.LFD.1.10.0804301831330.5994@woody.linux-foundation.org>
References: <200805010242.36775.rjw@sisk.pl>
	<alpine.LFD.1.10.0804301811051.5994@woody.linux-foundation.org>
	<alpine.LFD.1.10.0804301831330.5994@woody.linux-foundation.org>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Wed, 30 Apr 2008 18:40:39 -0700 (PDT)

> IOW, I argue that the high speed of merging very much is a big part of 
> what gives us quality in the end. It may result in bugs along the way, but 
> it also results in fixes, and lots of people looking at the result (and 
> looking at it in *context*, not just as a patch flying around).

This is a huge burdon to put on people.

The more broken stuff you merge, the more people are forced to track
these problems down so that they can get their own work done.

It punishes people who do put forth the effort to let new changes cook
properly, before pushing, and thus avoid putting turds into the tree.

You really have to think about the ramifications of this system.
