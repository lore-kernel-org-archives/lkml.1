Return-Path: <linux-kernel-owner+w=401wt.eu-S1760887AbXEKAsg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760887AbXEKAsg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2007 20:48:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756840AbXEKAs3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 May 2007 20:48:29 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:56452 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754275AbXEKAs3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2007 20:48:29 -0400
Date: Fri, 11 May 2007 09:49:18 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Christoph Lameter <clameter@sgi.com>
Cc: y-goto@jp.fujitsu.com, linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       akpm@osdl.org, mel@csn.ul.ie
Subject: Re: [RFC] memory hotremove patch take 2 [02/10] (make page unused)
Message-Id: <20070511094918.aba0b4e2.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <Pine.LNX.4.64.0705101101460.10002@schroedinger.engr.sgi.com>
References: <20070509115506.B904.Y-GOTO@jp.fujitsu.com>
	<20070509120248.B908.Y-GOTO@jp.fujitsu.com>
	<Pine.LNX.4.64.0705101101460.10002@schroedinger.engr.sgi.com>
Organization: Fujitsu
X-Mailer: Sylpheed version 2.2.0 (GTK+ 2.6.10; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 10 May 2007 11:04:37 -0700 (PDT)
Christoph Lameter <clameter@sgi.com> wrote:

> On Wed, 9 May 2007, Yasunori Goto wrote:
> 
> > This patch is for supporting making page unused.
> > 
> > Isolate pages by capturing freed pages before inserting free_area[],
> > buddy allocator.
> > If you have an idea for avoiding spin_lock(), please advise me.
> 
> Using the zone lock instead may avoid to introduce another lock? Or is the 
> new lock here for performance reasons?
> 
> Isnt it possible to just add another flavor of pages like what Mel has 
> been doing with reclaimable and movable? I.e. add another category of free 
> pages to Mel's scheme called isolated and use Mel's function to move stuff 
> over there?
> 
Mel-san's idea seems good. So we'll rewrite the whole this patch.

Thank you.
-Kame

