Return-Path: <linux-kernel-owner+w=401wt.eu-S1757425AbYE0Miz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757425AbYE0Miz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2008 08:38:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755987AbYE0Mio
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 May 2008 08:38:44 -0400
Received: from userg500.nifty.com ([202.248.238.80]:44134 "EHLO
	userg500.nifty.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753034AbYE0Min (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2008 08:38:43 -0400
DomainKey-Signature: a=rsa-sha1; s=userg500; d=nifty.com; c=nofws; q=dns;
	h=date:from:to:cc:subject:message-id:in-reply-to:references:
	x-mailer:mime-version:content-type:content-transfer-encoding;
	b=DxnJwwrOKZWomSfUtjf/IfMLESIiKlmhR99FVw8PwFwWgwN0fV+rf9+IZcTxZ+4ll
	8Y7s/hvsD2s0jMUp+noIg==
X-Nifty-SrcIP: [220.145.30.253]
Date: Tue, 27 May 2008 21:34:24 +0900
From: Komuro <komurojun-mbn@nifty.com>
To: David Miller <davem@davemloft.net>
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PLEASE REVERT] "Add a WARN_ON_ONCE" at
 net/sched/sch_generic.c:
Message-Id: <20080527213424.125e15dc.komurojun-mbn@nifty.com>
In-Reply-To: <20080525.051032.186144643.davem@davemloft.net>
References: <20080525112308.03a5fda7.komurojun-mbn@nifty.com>
	<20080525.051032.186144643.davem@davemloft.net>
X-Mailer: Sylpheed 2.3.1 (GTK+ 2.10.11; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 25 May 2008 05:10:32 -0700 (PDT)
David Miller <davem@davemloft.net> wrote:

> 
> > Please revert the patch "Add a WARN_ON_ONCE() to
> >  the transmit timeout function".
> > 
> > The transmit timeout sometimes happens on normal operation.
> > This message annoys me.
> 
> Sometimes, but not often.
> 
> Most of the time it does indicate a bug and we absolutely cannot
> diagnose it without the backtrace.

I think the transmit timeout indicates 
that the cable is not connected or the irq is conflict.


Best Regards
Komuro

