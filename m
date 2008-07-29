Return-Path: <linux-kernel-owner+w=401wt.eu-S1754003AbYG2Urk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754003AbYG2Urk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2008 16:47:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753053AbYG2UrM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jul 2008 16:47:12 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:52098
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1752479AbYG2UrK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2008 16:47:10 -0400
Date: Tue, 29 Jul 2008 13:47:06 -0700 (PDT)
Message-Id: <20080729.134706.249036102.davem@davemloft.net>
To: arjan@infradead.org
Cc: komurojun-mbn@nifty.com, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org
Subject: Re: NETDEV WATCHDOG: wifi0: transmit timed out
From: David Miller <davem@davemloft.net>
In-Reply-To: <20080729065859.2bcc65ed@infradead.org>
References: <20080525112308.03a5fda7.komurojun-mbn@nifty.com>
	<20080729215315.5a505fe7.komurojun-mbn@nifty.com>
	<20080729065859.2bcc65ed@infradead.org>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arjan van de Ven <arjan@infradead.org>
Date: Tue, 29 Jul 2008 06:58:59 -0700

> On Tue, 29 Jul 2008 21:53:15 +0900
> Komuro <komurojun-mbn@nifty.com> wrote:
> 
> > Hi,
> > 
> > Please try to comment out the "WARN_ON_ONCE"
> > at net/sched/sched_generic.c.
> > 
> 
> "I have a hardware failure so I'll comment out the message that says
> so, and then I won't have a failure". Yeah that'll work well.

Yes, this is indeed a recidulious suggestion, to hide the problem
instead of trying to figure out what it might actually be.

Komuro has a serious problem accepting the fact that this condition is
in fact an abnormal error should should be logged, and he keeps
pushing to get this WARN_ON() removed over and over again.

I'm just ignoring him at this point.
