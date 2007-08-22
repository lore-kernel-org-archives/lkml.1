Return-Path: <linux-kernel-owner+w=401wt.eu-S1756205AbXHVDEw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756205AbXHVDEw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2007 23:04:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754069AbXHVDEo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Aug 2007 23:04:44 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:45911 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754034AbXHVDEo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2007 23:04:44 -0400
Date: Wed, 22 Aug 2007 12:06:43 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Shaohua Li <shaohua.li@intel.com>
Cc: lkml <linux-kernel@vger.kernel.org>, clameter@sgi.com
Subject: Re: bug in migrate page
Message-Id: <20070822120643.961ce19b.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <1187751053.17976.2.camel@sli10-conroe.sh.intel.com>
References: <1187748489.8474.21.camel@sli10-conroe.sh.intel.com>
	<20070822115258.7d59aaa1.kamezawa.hiroyu@jp.fujitsu.com>
	<1187751053.17976.2.camel@sli10-conroe.sh.intel.com>
Organization: Fujitsu
X-Mailer: Sylpheed 2.4.2 (GTK+ 2.10.11; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 22 Aug 2007 10:50:53 +0800
Shaohua Li <shaohua.li@intel.com> wrote:

> > At quick glance, above path has no writepage() ops.
> > just replace swap's radix tree entry.
> I missed swap has .migratepage and thought fallback_migrate_page is
> used, then I thought doing rcu lock in PageAnon case is ok.
> 
Thank you, I'll write a patch.

Regards,
-Kame

