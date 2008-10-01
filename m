Return-Path: <linux-kernel-owner+w=401wt.eu-S1753105AbYJAGGi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753105AbYJAGGi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Oct 2008 02:06:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751953AbYJAGGa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Oct 2008 02:06:30 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:44076 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751864AbYJAGGa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Oct 2008 02:06:30 -0400
Date: Wed, 1 Oct 2008 15:12:49 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: balbir@linux.vnet.ibm.com, "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "nishimura@mxp.nes.nec.co.jp" <nishimura@mxp.nes.nec.co.jp>,
       "xemul@openvz.org" <xemul@openvz.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, Dave Hansen <haveblue@us.ibm.com>,
       ryov@valinux.co.jp
Subject: Re: [PATCH 9/12] memcg allocate all page_cgroup at boot
Message-Id: <20081001151249.b6d697a5.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20081001144150.3faa92ea.kamezawa.hiroyu@jp.fujitsu.com>
References: <20080925151124.25898d22.kamezawa.hiroyu@jp.fujitsu.com>
	<20080925153206.281243dc.kamezawa.hiroyu@jp.fujitsu.com>
	<48E2F6A9.9010607@linux.vnet.ibm.com>
	<20081001140748.637b9831.kamezawa.hiroyu@jp.fujitsu.com>
	<48E30B02.3030506@linux.vnet.ibm.com>
	<20081001144150.3faa92ea.kamezawa.hiroyu@jp.fujitsu.com>
Organization: Fujitsu
X-Mailer: Sylpheed 2.4.2 (GTK+ 2.10.11; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 1 Oct 2008 14:41:50 +0900
KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> wrote:

> > It will be easier to test/debug as well, we'll know if the problem is because of
> > new page_cgroup being outside struct page rather then guessing if it was the
> > atomic ops that caused the problem.
> > 
> 
> atomic_ops patch just rewrite exisiting behavior.
> 
please forgive me to post v6 today, which passed 24h+ tests.
v5 is a week old.
Discussion about patch order is welcome. But please give me hint.

Thanks,
-Kame

