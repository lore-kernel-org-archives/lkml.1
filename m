Return-Path: <linux-kernel-owner+w=401wt.eu-S1759430AbZEMKhd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759430AbZEMKhd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 May 2009 06:37:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755248AbZEMKhY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 May 2009 06:37:24 -0400
Received: from casper.infradead.org ([85.118.1.10]:38096 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753310AbZEMKhX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 May 2009 06:37:23 -0400
Subject: Re: [PATCH] Kconfig: CONFIG_UNEVICTABLE_LRU move into EMBEDDED
 submenu
From: David Woodhouse <dwmw2@infradead.org>
To: Minchan Kim <minchan.kim@gmail.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Lee Schermerhorn <Lee.Schermerhorn@hp.com>,
       Matt Mackall <mpm@selenic.com>
In-Reply-To: <20090513191221.674bc543.minchan.kim@barrios-desktop>
References: <20090513172904.7234.A69D9226@jp.fujitsu.com>
	 <20090513175152.1590c117.minchan.kim@barrios-desktop>
	 <20090513175539.723A.A69D9226@jp.fujitsu.com>
	 <20090513191221.674bc543.minchan.kim@barrios-desktop>
Content-Type: text/plain
Date: Wed, 13 May 2009 11:37:17 +0100
Message-Id: <1242211037.24436.552.camel@macbook.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 (2.26.1-2.fc11) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-05-13 at 19:12 +0900, Minchan Kim wrote:
> > No.
> > As far as I know, many embedded guys use this configuration.
> > they hate unexpected latency by reclaim. !UNEVICTABLE_LRU increase
> > unexpectability largely.
> 
> As I said previous(http://lkml.org/lkml/2009/3/16/209), Many embedded
> environment have a small ram. It doesn't have a big impact in such
> case. 
> 
> Let CCed embedded matainers. 
> I won't have a objection if embedded maintainers ack this. 

I probably wouldn't be cheerleading for it if you wanted to make it
optional when it wasn't before -- but I suppose we might as well
preserve the option under CONFIG_EMBEDDED if the alternative is to lose
it completely.

Acked-by: David Woodhouse <David.Woodhouse@intel.com>

-- 
David Woodhouse                            Open Source Technology Centre
David.Woodhouse@intel.com                              Intel Corporation

