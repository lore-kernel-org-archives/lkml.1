Return-Path: <linux-kernel-owner+w=401wt.eu-S1754489AbZBJMgG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754489AbZBJMgG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Feb 2009 07:36:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752449AbZBJMfy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Feb 2009 07:35:54 -0500
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:44893 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752068AbZBJMfx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Feb 2009 07:35:53 -0500
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: MinChan Kim <minchan.kim@gmail.com>
Subject: Re: [RFC] vmscan: initialize sc->nr_reclaimed in do_try_to_free_pages()
Cc: kosaki.motohiro@jp.fujitsu.com, Johannes Weiner <hannes@cmpxchg.org>,
       Rik van Riel <riel@redhat.com>,
       William Lee Irwin III <wli@movementarian.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org
In-Reply-To: <28c262360902100431l4a5977e7p9c5152882f09dcf9@mail.gmail.com>
References: <20090210210520.7004.KOSAKI.MOTOHIRO@jp.fujitsu.com> <28c262360902100431l4a5977e7p9c5152882f09dcf9@mail.gmail.com>
Message-Id: <20090210213502.7007.KOSAKI.MOTOHIRO@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.42 [ja]
Date: Tue, 10 Feb 2009 21:35:50 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Hmm.. You're right.
> As Johannes pointed out,
> too many page shrinking can degrade resume performance.
> 
> We need to bale out in shrink_all_memory.
> Other people, thought ?

shrink_all_zones() already have bale-out code ;)


