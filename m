Return-Path: <linux-kernel-owner+w=401wt.eu-S1754593AbYEFGo4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754593AbYEFGo4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2008 02:44:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751195AbYEFGor
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 May 2008 02:44:47 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:38013 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751123AbYEFGoq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2008 02:44:46 -0400
Date: Tue, 06 May 2008 15:43:39 +0900
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: balbir@linux.vnet.ibm.com
Subject: Re: on CONFIG_MM_OWNER=y, kernel panic is possible.
Cc: kosaki.motohiro@jp.fujitsu.com, Lee Schermerhorn <Lee.Schermerhorn@hp.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
       Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <481FFAAB.3030008@linux.vnet.ibm.com>
References: <20080506151510.AC66.KOSAKI.MOTOHIRO@jp.fujitsu.com> <481FFAAB.3030008@linux.vnet.ibm.com>
Message-Id: <20080506153943.AC69.KOSAKI.MOTOHIRO@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.42 [ja]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> >  #ifdef CONFIG_MM_OWNER
> > -       struct task_struct *owner;      /* The thread group leader that */
> > -                                       /* owns the mm_struct.          */
> > +       struct task_struct *owner;      /* point to one of task that owns the mm_struct. */
> >  #endif
> > 
> >  #ifdef CONFIG_PROC_FS
> 
> How about just, the task that owns the mm_struct? One of, implies multiple owners.

Ah, below is better?

/* point to any one of task that related the mm_struct. */


my intention is only remove "thread group leader" word.
other things, I obey your favor. 

Cheers!



