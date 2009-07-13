Return-Path: <linux-kernel-owner+w=401wt.eu-S1753420AbZGMC7z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753420AbZGMC7z (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Jul 2009 22:59:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753057AbZGMC7x
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 12 Jul 2009 22:59:53 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:34094 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752962AbZGMC7x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Jul 2009 22:59:53 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Mon, 13 Jul 2009 11:58:03 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Shaohua Li <shaohua.li@intel.com>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, mel@csn.ul.ie, akpm@linux-foundation.org
Subject: Re: [PATCH] switch free memory back to MIGRATE_MOVABLE
Message-Id: <20090713115803.b78a4f4f.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20090713113326.624F.A69D9226@jp.fujitsu.com>
References: <20090713023030.GA27269@sli10-desk.sh.intel.com>
	<20090713113326.624F.A69D9226@jp.fujitsu.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 13 Jul 2009 11:47:46 +0900 (JST)
KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com> wrote:

> > When page is back to buddy and its order is bigger than pageblock_order, we can
> > switch its type to MIGRATE_MOVABLE. This can reduce fragmentation. The patch
> > has obvious effect when read a block device and then drop caches.
> > 
> > Signed-off-by: Shaohua Li <shaohua.li@intel.com>
> 
> This patch change hot path, but there is no performance mesurement description.
> Also, I don't like modification buddy core for only drop caches.
> 
Li, does this patch imply fallback of migration type doesn't work well ?
What is the bad case ?

-Kame

