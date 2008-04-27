Return-Path: <linux-kernel-owner+w=401wt.eu-S1764119AbYD0U05@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764119AbYD0U05 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Apr 2008 16:26:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750832AbYD0U0t
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Apr 2008 16:26:49 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53982 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750738AbYD0U0s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Apr 2008 16:26:48 -0400
Date: Sun, 27 Apr 2008 13:26:34 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Harvey Harrison <harvey.harrison@gmail.com>
cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] bitops: simplify generic bit finding functions
In-Reply-To: <1209327591.14173.74.camel@brick>
Message-ID: <alpine.LFD.1.10.0804271325350.3119@woody.linux-foundation.org>
References: <1209327591.14173.74.camel@brick>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Sun, 27 Apr 2008, Harvey Harrison wrote:
>
> No need for a sentinal if we explicitly catch the no bits/all bits set
> cases, make it clear they are special cases returning size/BITS_PER_LONG.

These things need to be re-done anyway. David already complained that the 
thing inlines to something much much too big.

Let's just make it not be an inline at all.

		Linus
