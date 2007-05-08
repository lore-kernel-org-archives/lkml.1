Return-Path: <linux-kernel-owner+w=401wt.eu-S968081AbXEHOGb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S968081AbXEHOGb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2007 10:06:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S967873AbXEHOG3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 May 2007 10:06:29 -0400
Received: from mx10.go2.pl ([193.17.41.74]:56438 "EHLO poczta.o2.pl"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S968078AbXEHOG2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2007 10:06:28 -0400
Date: Tue, 8 May 2007 16:12:46 +0200
From: Jarek Poplawski <jarkao2@o2.pl>
To: Oleg Nesterov <oleg@tv-sign.ru>
Cc: Andrew Morton <akpm@linux-foundation.org>, David Chinner <dgc@sgi.com>,
       David Howells <dhowells@redhat.com>, Gautham Shenoy <ego@in.ibm.com>,
       Ingo Molnar <mingo@elte.hu>, Srivatsa Vaddagiri <vatsa@in.ibm.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] make cancel_rearming_delayed_work() reliable
Message-ID: <20070508141246.GA967@ff.dom.local>
References: <20070503204226.GA212@tv-sign.ru> <20070508071544.GA1772@ff.dom.local> <20070508123102.GB968@tv-sign.ru> <20070508135648.GG1772@ff.dom.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070508135648.GG1772@ff.dom.local>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 08, 2007 at 03:56:48PM +0200, Jarek Poplawski wrote:
> > So, we should either return 0, or add BUG_ON(!cwq).
> 
> ...And you prefer endless loop. Seems brave!

Sorry! (Maybe you're not so brave?) Seems clear _PENDING should
save us here - I hope.

Bye, bye,
Jarek P.
