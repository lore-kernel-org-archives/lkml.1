Return-Path: <linux-kernel-owner+w=401wt.eu-S1758609AbZKETCH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758609AbZKETCH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Nov 2009 14:02:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756975AbZKETCH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Nov 2009 14:02:07 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:57071 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756179AbZKETCG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Nov 2009 14:02:06 -0500
Date: Thu, 5 Nov 2009 20:02:03 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Andrea Arcangeli <aarcange@redhat.com>
Cc: Hugh Dickins <hugh.dickins@tiscali.co.uk>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Minchan Kim <minchan.kim@gmail.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       vedran.furac@gmail.com, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       rientjes@google.com
Subject: Re: [RFC][PATCH] oom_kill: avoid depends on total_vm and use real
	RSS/swap value for oom_score (Re: Memory overcommit
Message-ID: <20091105190203.GA1392@ucw.cz>
References: <20091026105509.f08eb6a3.kamezawa.hiroyu@jp.fujitsu.com> <4AE5CB4E.4090504@gmail.com> <20091027122213.f3d582b2.kamezawa.hiroyu@jp.fujitsu.com> <2f11576a0910262310g7aea23c0n9bfc84c900879d45@mail.gmail.com> <20091027153429.b36866c4.minchan.kim@barrios-desktop> <20091027153626.c5a4b5be.kamezawa.hiroyu@jp.fujitsu.com> <28c262360910262355p3cac5c1bla4de9d42ea67fb4e@mail.gmail.com> <20091027164526.da6a23cb.kamezawa.hiroyu@jp.fujitsu.com> <Pine.LNX.4.64.0910271821130.11372@sister.anvils> <20091027184743.GD5753@random.random>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091027184743.GD5753@random.random>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> Agreed it's not obvious. Intuitively I think only including RSS and no
> swap is best, but clearly I can't be entirely against including swap
> too as there may be scenarios where including swap provides for a
> better choice.
> 
> My argument for not including swap is that we kill tasks to free RAM
> (we don't really care to free swap, system needs RAM at oom time).

System should be out of _virtual_ memory at that point, so yes,
freeing swap should help, too.

									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
