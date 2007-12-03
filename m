Return-Path: <linux-kernel-owner+w=401wt.eu-S1753782AbXLCQiu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753782AbXLCQiu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Dec 2007 11:38:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750763AbXLCQik
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Dec 2007 11:38:40 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:36871 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753402AbXLCQij (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Dec 2007 11:38:39 -0500
Date: Mon, 3 Dec 2007 08:37:40 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Oleg Nesterov <oleg@tv-sign.ru>
cc: Andrew Morton <akpm@linux-foundation.org>,
       Davide Libenzi <davidel@xmailserver.org>, Ingo Molnar <mingo@elte.hu>,
       Roland McGrath <roland@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/2] fix the long standing exec vs kill race
In-Reply-To: <20071202151454.GA13180@tv-sign.ru>
Message-ID: <alpine.LFD.0.9999.0712030829240.8458@woody.linux-foundation.org>
References: <20071202151454.GA13180@tv-sign.ru>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Sun, 2 Dec 2007, Oleg Nesterov wrote:
>
> Depends on
> 	[PATCH] __group_complete_signal: fix coredump with group stop race
> 	http://marc.info/?l=linux-kernel&m=119653436116036
> 
> Needs review and testing.
> 
> Please comment, I think at least the idea is promising.

It looks clean and sane to me, but I'm currently more worried about 
2.6.24, and even the first patch this depends on (coredump/stop race) 
makes me a bit nervous since all these things tend to have some rather 
subtle interactions with other parts that depended on the exact semantics 
of all the signal issues.

So my gut feel - considering that none of the problems involved here are 
exactly new - is that this is good material for early in the 2.6.25 cycle.

But I think the whole series looks ok, and if people press me and convince 
me it's (a) well tested and (b) needed early, then I guess it can be 
pushed into 2.6.24.

Anybody?

		Linus
