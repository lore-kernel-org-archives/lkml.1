Return-Path: <linux-kernel-owner+w=401wt.eu-S1758198AbYCCJyO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758198AbYCCJyO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2008 04:54:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754084AbYCCJx7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Mar 2008 04:53:59 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:52363 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753900AbYCCJx6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2008 04:53:58 -0500
Date: Mon, 3 Mar 2008 18:58:25 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       "KOSAKI Motohiro" <m-kosaki@ceres.dti.ne.jp>,
       "Rick van Rein" <rick@vanrein.org>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2.6.24] mm: BadRAM support for broken memory
Message-Id: <20080303185825.9634f762.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <200803031835.03082.nickpiggin@yahoo.com.au>
References: <2f11576a0803020901n715fda8esbfc0172f5a15ae3c@mail.gmail.com>
	<200803031632.47888.nickpiggin@yahoo.com.au>
	<20080303161025.1E7E.KOSAKI.MOTOHIRO@jp.fujitsu.com>
	<200803031835.03082.nickpiggin@yahoo.com.au>
Organization: Fujitsu
X-Mailer: Sylpheed 2.4.2 (GTK+ 2.10.11; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 3 Mar 2008 18:35:02 +1100
Nick Piggin <nickpiggin@yahoo.com.au> wrote:

> On Monday 03 March 2008 18:14, KOSAKI Motohiro wrote:
> > > > some architecture use PG_reserved for treat bad memory.
> > > > Why do you want introduce new page flag?
> > > > for show_mem() improvement?
> > >
> > > I'd like to get rid of PG_reserved at some point. So I'd
> > > rather not overload it with more meanings ;)
> >
> > really?
> >
> > as far as I know, IA64 already use PG_reserved for bad memory.
> > please see arch/ia64/kernel/mcs_drv.c#mca_page_isolate.
> >
> > Doesn't it works on ia64 if your patch introduce?
> 
> It doesn't really need to use PG_reserved there, no. It could
> use PG_bad for that instead.
> 
Hmm, it seems that it's necessary to rewrite ia64/mca code after PG_bad
patch is merged.

Thanks,
-Kame

