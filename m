Return-Path: <linux-kernel-owner+w=401wt.eu-S1757997AbXGASHp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757997AbXGASHp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Jul 2007 14:07:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757370AbXGASHf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Jul 2007 14:07:35 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:44497 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757175AbXGASHc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Jul 2007 14:07:32 -0400
Date: Sun, 1 Jul 2007 11:07:21 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Stephen Hemminger <shemminger@linux-foundation.org>
cc: Andrew Morton <akpm@linux-foundation.org>, Andi Kleen <ak@suse.de>,
       linux-kernel@vger.kernel.org
Subject: Re: blink driver power saving
In-Reply-To: <20070701125035.3f54d8b0@oldman>
Message-ID: <alpine.LFD.0.98.0707011106030.1172@woody.linux-foundation.org>
References: <20070701125035.3f54d8b0@oldman>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Sun, 1 Jul 2007, Stephen Hemminger wrote:
>
> The blink driver wakes up every jiffies which wastes power unnecessarily.
> Using a notifier gives same effect. Also add ability to unload module.

I really get the feeling this thing should be removed entirely. Wasting 
power is the _least_ of its problems.

I'll apply the patch, but I wonder if I should also just mark it BROKEN in 
the config file to make sure nobody enables it without realizing how bad 
it is to do so.

		Linus
