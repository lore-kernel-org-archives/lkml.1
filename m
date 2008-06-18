Return-Path: <linux-kernel-owner+w=401wt.eu-S1760603AbYFRCmb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760603AbYFRCmb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2008 22:42:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759626AbYFRCmX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Jun 2008 22:42:23 -0400
Received: from TYO201.gate.nec.co.jp ([202.32.8.193]:60714 "EHLO
	tyo201.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759527AbYFRCmW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2008 22:42:22 -0400
Date: Wed, 18 Jun 2008 11:40:57 +0900
From: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
To: Lee Schermerhorn <Lee.Schermerhorn@hp.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Rik van Riel <riel@redhat.com>,
       Kosaki Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Nick Piggin <npiggin@suse.de>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org, kernel-testers@vger.kernel.org
Subject: Re: [Bad page] trying to free locked page? (Re: [PATCH][RFC] fix
 kernel BUG at mm/migrate.c:719! in 2.6.26-rc5-mm3)
Message-Id: <20080618114057.564564a0.nishimura@mxp.nes.nec.co.jp>
In-Reply-To: <1213727385.8707.53.camel@lts-notebook>
References: <20080611225945.4da7bb7f.akpm@linux-foundation.org>
	<20080617163501.7cf411ee.nishimura@mxp.nes.nec.co.jp>
	<20080617164709.de4db070.nishimura@mxp.nes.nec.co.jp>
	<20080617180314.2d1b0efa.kamezawa.hiroyu@jp.fujitsu.com>
	<20080617181527.5bcbbccc.nishimura@mxp.nes.nec.co.jp>
	<1213727385.8707.53.camel@lts-notebook>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > > > 
> > > Good catch, and I think your investigation in the last e-mail was correct.
> > > I'd like to dig this...but it seems some kind of big fix is necessary.
> > > Did this happen under page-migraion by cpuset-task-move test ?
> > > 
> > Yes.
> > 
> > I made 2 cpuset directories, run some processes in each cpusets,
> > and run a script like below infinitely to move tasks and migrate pages.
> 
> What processes/tests do you run in each cpuset?
> 

Please see the mail I've just sended to Kosaki-san :)


Thanks,
Daisuke Nishimura.
