Return-Path: <linux-kernel-owner+w=401wt.eu-S1753543AbYKTDFm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753543AbYKTDFm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2008 22:05:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751920AbYKTDFe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Nov 2008 22:05:34 -0500
Received: from mx1.redhat.com ([66.187.233.31]:44471 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751818AbYKTDFe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2008 22:05:34 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: ebiederm@xmission.com (Eric W. Biederman)
X-Fcc: ~/Mail/linus
Cc: Oleg Nesterov <oleg@redhat.com>, Andrew Morton <akpm@linux-foundation.org>,
       Pavel Emelyanov <xemul@openvz.org>,
       "Serge E. Hallyn" <serue@us.ibm.com>,
       Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] protect /sbin/init from unwanted signals more
In-Reply-To: Eric W. Biederman's message of  Wednesday, 19 November 2008 18:00:12 -0800 <m1skpncg2b.fsf@frodo.ebiederm.org>
References: <20081118175901.GA17134@redhat.com>
	<20081119185148.DC1D31544EB@magilla.localdomain>
	<m1skpncg2b.fsf@frodo.ebiederm.org>
X-Windows: a terminal disease.
Message-Id: <20081120030449.864B515423A@magilla.localdomain>
Date: Wed, 19 Nov 2008 19:04:49 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> inits today don't do anything with blocked signals.  They explicitly ignore all signals,
> they don't want to deal with an enable those they do.

I don't think we should constrain them this way.  
Future init versions might want to use blocked signals and sigwait.

> Which reminds me.  I need to retest, but I had a case where I had a
> trivial init that set all signal handlers to SIG_IGN so it could ignore
> SIGCHLD.  And not all of it's children were getting reaped automagically.
> Do we have a bug in the reparenting/reaping logic?

We have had bugs along those lines in the past.
AFAIK we've licked them all now.  Re-testing is in order.


Thanks,
Roland
