Return-Path: <linux-kernel-owner+w=401wt.eu-S933020AbXHASly@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933020AbXHASly (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Aug 2007 14:41:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757499AbXHASlq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Aug 2007 14:41:46 -0400
Received: from gateway-1237.mvista.com ([63.81.120.158]:63905 "EHLO
	gateway-1237.mvista.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760587AbXHASlp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Aug 2007 14:41:45 -0400
Subject: Re: [PATCH] RT: Add priority-queuing and priority-inheritance to
	workqueue infrastructure
From: Daniel Walker <dwalker@mvista.com>
To: Oleg Nesterov <oleg@tv-sign.ru>
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       Gregory Haskins <ghaskins@novell.com>, linux-rt-users@vger.kernel.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <20070801182658.GB90@tv-sign.ru>
References: <20070801002407.4973.54778.stgit@novell1.haskins.net>
	 <1185940340.2636.97.camel@imap.mvista.com>
	 <1185987663.12034.99.camel@twins>
	 <1185988243.2636.126.camel@imap.mvista.com>
	 <20070801182658.GB90@tv-sign.ru>
Content-Type: text/plain
Date: Wed, 01 Aug 2007 11:39:59 -0700
Message-Id: <1185993599.2636.150.camel@imap.mvista.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.3 (2.10.3-1.fc7) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-08-01 at 22:26 +0400, Oleg Nesterov wrote:

> No, the "tail" option has nothing to do with prioritize, we can't remove
> it. Please look at the code.

So you insert a work struct that executes last which wakes the flushing
thread?

> Also, flush_workqueue() must not be delayed by the new incoming work_struct's,
> the change like this breaks this assumption.

True ..

Daniel

