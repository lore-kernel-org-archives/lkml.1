Return-Path: <linux-kernel-owner+w=401wt.eu-S932697AbXHFTke@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932697AbXHFTke (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2007 15:40:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932756AbXHFTja
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Aug 2007 15:39:30 -0400
Received: from victor.provo.novell.com ([137.65.250.26]:39361 "EHLO
	victor.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761828AbXHFTj3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2007 15:39:29 -0400
Subject: Re: [PATCH] RT: Add priority-queuing and priority-inheritance to
	workqueue infrastructure
From: Gregory Haskins <ghaskins@novell.com>
To: Oleg Nesterov <oleg@tv-sign.ru>
Cc: Daniel Walker <dwalker@mvista.com>, Peter Zijlstra <peterz@infradead.org>,
       Ingo Molnar <mingo@elte.hu>, linux-rt-users@vger.kernel.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <20070806193314.GB101@tv-sign.ru>
References: <1185992994.2636.142.camel@imap.mvista.com>
	 <20070801201802.GA225@tv-sign.ru>
	 <1186000468.2636.168.camel@imap.mvista.com>
	 <20070801205053.GA263@tv-sign.ru>
	 <1186002783.9513.228.camel@ghaskins-t60p.haskins.net>
	 <20070801213422.GA280@tv-sign.ru>
	 <1186005598.9513.261.camel@ghaskins-t60p.haskins.net>
	 <20070801222201.GA316@tv-sign.ru>
	 <1186012439.9513.321.camel@ghaskins-t60p.haskins.net>
	 <20070802195049.GA361@tv-sign.ru>  <20070806193314.GB101@tv-sign.ru>
Content-Type: text/plain
Date: Mon, 06 Aug 2007 15:37:42 -0400
Message-Id: <1186429062.21381.139.camel@ghaskins-t60p.haskins.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-08-06 at 23:33 +0400, Oleg Nesterov wrote:

> OK. I have to take my words back. I completely misunderstood why you
> are doing this and which problems you are trying to solve, my bad.

No problem man.  You found some legitimate problems too so your input is
very much appreciated.

> 
> Perhaps, I am also wrong on the "work_struct's could be re-ordered"
> issue. Yes, we can break the code which is currently correct, that
> was my point. But I must admit, I can't imagine the "good" code mich
> may suffer. Perhaps we can just document the change in behaviour, and
> "deprecate" such a code.
> 
> The only objection (and you seem to agree) is that the "regular"
> queue_work() should not always take the callers's priority as the
> priority of work_struct.

Agreed.  I think that is the right direction (assuming we can resolve
the other problems, like the double queue+queue problem you brought up).

Regards,
-Greg

