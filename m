Return-Path: <linux-kernel-owner+w=401wt.eu-S1754687AbZHYJjc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754687AbZHYJjc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Aug 2009 05:39:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751238AbZHYJj3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Aug 2009 05:39:29 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:34126 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750811AbZHYJj2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Aug 2009 05:39:28 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Tue, 25 Aug 2009 18:37:34 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Hugh Dickins <hugh.dickins@tiscali.co.uk>
Cc: Hiroaki Wakabayashi <primulaelatior@gmail.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Minchan Kim <minchan.kim@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, linux-mm@kvack.org,
       Paul Menage <menage@google.com>, Ying Han <yinghan@google.com>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       Lee Schermerhorn <lee.schermerhorn@hp.com>
Subject: Re: [PATCH] mm: make munlock fast when mlock is canceled by sigkill
Message-Id: <20090825183734.1b2d0559.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <Pine.LNX.4.64.0908250947400.2872@sister.anvils>
References: <82e12e5f0908220954p7019fb3dg15f9b99bb7e55a8c@mail.gmail.com>
	<28c262360908231844o3df95b14v15b2d4424465f033@mail.gmail.com>
	<20090824105139.c2ab8403.kamezawa.hiroyu@jp.fujitsu.com>
	<2f11576a0908232113w71676aatf22eb6d431501fd0@mail.gmail.com>
	<82e12e5f0908242146uad0f314hcbb02fcc999a1d32@mail.gmail.com>
	<Pine.LNX.4.64.0908250947400.2872@sister.anvils>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 25 Aug 2009 10:03:30 +0100 (BST)
Hugh Dickins <hugh.dickins@tiscali.co.uk> wrote:
> My advice (but I sure hate giving advice before I've tried it myself)
> is to put __mlock_vma_pages_range() back to handling just the mlock
> case, and do your own follow_page() loop in munlock_vma_pages_range().
> 

I have no objections to make use of follow_page().

Thanks,
-Kame

