Return-Path: <linux-kernel-owner+w=401wt.eu-S1754668AbZHCLQH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754668AbZHCLQH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Aug 2009 07:16:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754557AbZHCLQG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Aug 2009 07:16:06 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:60285 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754532AbZHCLQF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Aug 2009 07:16:05 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Mon, 3 Aug 2009 20:14:18 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Mike Smith <scgtrp@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       bugzilla-daemon@bugzilla.kernel.org, bugme-daemon@bugzilla.kernel.org,
       Amerigo Wang <xiyou.wangcong@gmail.com>, linux-kernel@vger.kernel.org
Subject: [BUGFIX][PATCH 0/3] kcore: avoid access to holes in vmalloc v3 (Was
 Re: [Bugme-new] [Bug 13850] New: reading /proc/kcore causes oops
Message-Id: <20090803201418.040bb3ee.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <525c5a6c0907281946t249ef288v77ee94edd16f054@mail.gmail.com>
References: <bug-13850-10286@http.bugzilla.kernel.org/>
	<20090728160527.1da52682.akpm@linux-foundation.org>
	<20090729084825.1363c880.kamezawa.hiroyu@jp.fujitsu.com>
	<525c5a6c0907281946t249ef288v77ee94edd16f054@mail.gmail.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 28 Jul 2009 22:46:56 -0400
Mike Smith <scgtrp@gmail.com> wrote:

> > What's layout of memory does your server have ?
> The log I gave was from my desktop, so I'll assume you wanted that
> instead of the server:
> [mike: mike in ~]$ grep "System RAM" /proc/iomem
> 00010000-0009efff : System RAM
> 00100000-1dedffff : System RAM
> 

This is v3. updated against 2.6.31-rc5 and several fixes in addition
to type fixes. patches are reordered again but nochanges in concept.


Thanks,
-Kame

