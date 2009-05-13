Return-Path: <linux-kernel-owner+w=401wt.eu-S1759895AbZEMOfr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759895AbZEMOfr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 May 2009 10:35:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754602AbZEMOfh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 May 2009 10:35:37 -0400
Received: from waste.org ([66.93.16.53]:56838 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753507AbZEMOfg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 May 2009 10:35:36 -0400
Date: Wed, 13 May 2009 09:34:00 -0500
From: Matt Mackall <mpm@selenic.com>
To: David Woodhouse <dwmw2@infradead.org>
Cc: Minchan Kim <minchan.kim@gmail.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Lee Schermerhorn <Lee.Schermerhorn@hp.com>
Subject: Re: [PATCH] Kconfig: CONFIG_UNEVICTABLE_LRU move into EMBEDDED submenu
Message-ID: <20090513143400.GC31071@waste.org>
References: <20090513172904.7234.A69D9226@jp.fujitsu.com> <20090513175152.1590c117.minchan.kim@barrios-desktop> <20090513175539.723A.A69D9226@jp.fujitsu.com> <20090513191221.674bc543.minchan.kim@barrios-desktop> <1242211037.24436.552.camel@macbook.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1242211037.24436.552.camel@macbook.infradead.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 13, 2009 at 11:37:17AM +0100, David Woodhouse wrote:
> On Wed, 2009-05-13 at 19:12 +0900, Minchan Kim wrote:
> > > No.
> > > As far as I know, many embedded guys use this configuration.
> > > they hate unexpected latency by reclaim. !UNEVICTABLE_LRU increase
> > > unexpectability largely.
> > 
> > As I said previous(http://lkml.org/lkml/2009/3/16/209), Many embedded
> > environment have a small ram. It doesn't have a big impact in such
> > case. 
> > 
> > Let CCed embedded matainers. 
> > I won't have a objection if embedded maintainers ack this. 
> 
> I probably wouldn't be cheerleading for it if you wanted to make it
> optional when it wasn't before -- but I suppose we might as well
> preserve the option under CONFIG_EMBEDDED if the alternative is to lose
> it completely.

As the person who introduced CONFIG_EMBEDDED, I've occasionally
thought we should rename it to CONFIG_NONSTANDARD to make the
semantics clearer. It's less about cell phones and more about going
way off the beaten path.

-- 
Mathematics is the supreme nostalgia of our time.
