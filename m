Return-Path: <linux-kernel-owner+w=401wt.eu-S1752864AbZIGXvt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752864AbZIGXvt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Sep 2009 19:51:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752793AbZIGXvs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Sep 2009 19:51:48 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55939 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752789AbZIGXvs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Sep 2009 19:51:48 -0400
Date: Mon, 7 Sep 2009 16:51:26 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Hugh Dickins <hugh.dickins@tiscali.co.uk>
cc: Andrew Morton <akpm@linux-foundation.org>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Nick Piggin <npiggin@suse.de>, Rik van Riel <riel@redhat.com>,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH 0/8] mm: around get_user_pages flags
In-Reply-To: <Pine.LNX.4.64.0909072222070.15424@sister.anvils>
Message-ID: <alpine.LFD.2.01.0909071648560.7458@localhost.localdomain>
References: <Pine.LNX.4.64.0909072222070.15424@sister.anvils>
User-Agent: Alpine 2.01 (LFD 1184 2008-12-16)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 7 Sep 2009, Hugh Dickins wrote:
>
> Here's a series of mm mods against current mmotm: mostly cleanup
> of get_user_pages flags, but fixing munlock's OOM, sorting out the
> "FOLL_ANON optimization", and reinstating ZERO_PAGE along the way.

Ack on the whole series as far as I'm concerned. All looks very 
straightforward and sane.

		Linus
