Return-Path: <linux-kernel-owner+w=401wt.eu-S965549AbXC1Lvp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965549AbXC1Lvp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Mar 2007 07:51:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965547AbXC1Lvp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Mar 2007 07:51:45 -0400
Received: from mail.gmx.net ([213.165.64.20]:48997 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S965549AbXC1Lvo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Mar 2007 07:51:44 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX18mQ00/Oowmp6YTM4vCctj5D/TlclG9aRiPv/5RAL
	ZZCHL0ufSGrlgC
Subject: Re: [BUG] scheduler: strange behavor with massive interactive
	processes
From: Mike Galbraith <efault@gmx.de>
To: Ingo Molnar <mingo@elte.hu>
Cc: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>,
       Linux Kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <20070328114540.GA7942@elte.hu>
References: <87r6rb1nbm.wl%takeuchi_satoru@jp.fujitsu.com>
	 <1174971852.16403.35.camel@Homer.simpson.net>
	 <1175071091.29829.58.camel@Homer.simpson.net>
	 <20070328114540.GA7942@elte.hu>
Content-Type: text/plain
Date: Wed, 28 Mar 2007 13:51:42 +0200
Message-Id: <1175082702.564.28.camel@Homer.simpson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

(oops, wrong button, went without CCs.  sorry for duplicate)

On Wed, 2007-03-28 at 13:45 +0200, Ingo Molnar wrote:
> * Mike Galbraith <efault@gmx.de> wrote:
> 
> > +	struct task_struct *p = NULL; 
> 
> (small nit: extra space at the end of line.)
> 
> > +				rq->best_expired_prio = MAX_PRIO;
> > +#if 0
> > +				rq->switch_timestamp = jiffies;
> > +#endif
> 
> remove this chunk? (i dont think we want to touch switch_timestamp here)

I'll clean it up, and see if I can do better.

	-Mike

