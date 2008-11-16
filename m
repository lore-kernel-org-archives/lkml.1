Return-Path: <linux-kernel-owner+w=401wt.eu-S1754654AbYKPSQQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754654AbYKPSQQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Nov 2008 13:16:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753545AbYKPSP7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Nov 2008 13:15:59 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44120 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753540AbYKPSP6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Nov 2008 13:15:58 -0500
Date: Sun, 16 Nov 2008 10:15:06 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Andrew Morton <akpm@linux-foundation.org>
cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
       Rik van Riel <riel@redhat.com>, Gene Heskett <gene.heskett@gmail.com>
Subject: Re: [PATCH] mm: evict streaming IO cache first
In-Reply-To: <20081115210039.537f59f5.akpm@linux-foundation.org>
Message-ID: <alpine.LFD.2.00.0811161013270.3468@nehalem.linux-foundation.org>
References: <20081115181748.3410.KOSAKI.MOTOHIRO@jp.fujitsu.com> <20081115210039.537f59f5.akpm@linux-foundation.org>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Sat, 15 Nov 2008, Andrew Morton wrote:
> 
> Really, I think that the old approach of observing the scanner
> behaviour (rather than trying to predict it) was better.

That's generally true. Self-adjusting behaviour rather than a-priori rules 
would be much nicer. However, we apparently need to fix this some way. 
Anybody willing to re-introduce some of the old logic?

		Linus
