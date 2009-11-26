Return-Path: <linux-kernel-owner+w=401wt.eu-S1751332AbZKZBfU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751332AbZKZBfU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Nov 2009 20:35:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750793AbZKZBfT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Nov 2009 20:35:19 -0500
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:45270 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750778AbZKZBfS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Nov 2009 20:35:18 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Thu, 26 Nov 2009 10:32:34 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: vedran.furac@gmail.com
Cc: Andrea Arcangeli <aarcange@redhat.com>,
       David Rientjes <rientjes@google.com>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Hugh Dickins <hugh.dickins@tiscali.co.uk>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Subject: Re: [PATCH] oom_kill: use rss value instead of vm size for badness
Message-Id: <20091126103234.806a4982.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <4B0DC764.8040205@gmail.com>
References: <20091028175846.49a1d29c.kamezawa.hiroyu@jp.fujitsu.com>
	<alpine.DEB.2.00.0910280206430.7122@chino.kir.corp.google.com>
	<abbed627532b26d8d96990e2f95c02fc.squirrel@webmail-b.css.fujitsu.com>
	<20091029100042.973328d3.kamezawa.hiroyu@jp.fujitsu.com>
	<alpine.DEB.2.00.0910290125390.11476@chino.kir.corp.google.com>
	<20091125124433.GB27615@random.random>
	<4B0DC764.8040205@gmail.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 26 Nov 2009 01:10:12 +0100
Vedran Furač <vedran.furac@gmail.com> wrote:

> Andrea Arcangeli wrote:
> 
> > Hello,
> 
> Hi all!
> 
> > lengthy discussion on something I think is quite obviously better and
> > I tried to change a couple of years back already (rss instead of
> > total_vm).
> 
> Now that 2.6.32 is almost out, is it possible to get OOMK fixed in
> 2.6.33 so that I could turn overcommit on (overcommit_memory=0) again
> without fear of loosing my work?
> 
I'll try fork-bomb detector again. That will finally help your X.org.
But It may lose 2.6.33.

Adding new counter to mm_struct is now rejected because of scalability, so
total work will need more time (than expected).
I'm sorry I can't get enough time in these weeks.

Thanks,
-Kame

