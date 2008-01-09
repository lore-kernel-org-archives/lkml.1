Return-Path: <linux-kernel-owner+w=401wt.eu-S1756718AbYAIWFZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756718AbYAIWFZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2008 17:05:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753068AbYAIWFN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Jan 2008 17:05:13 -0500
Received: from ozlabs.org ([203.10.76.45]:59234 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752564AbYAIWFL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2008 17:05:11 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: Zach Brown <zach.brown@oracle.com>
Subject: Re: [PATCH 5/6] syslets: add generic syslets infrastructure
Date: Thu, 10 Jan 2008 09:04:45 +1100
User-Agent: KMail/1.9.6 (enterprise 0.20070907.709405)
Cc: linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, Ulrich Drepper <drepper@redhat.com>,
       Arjan van de Ven <arjan@infradead.org>, Andrew Morton <akpm@zip.com.au>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Evgeniy Polyakov <johnpol@2ka.mipt.ru>,
       "David S. Miller" <davem@davemloft.net>,
       Suparna Bhattacharya <suparna@in.ibm.com>,
       Davide Libenzi <davidel@xmailserver.org>,
       Jens Axboe <jens.axboe@oracle.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Dan Williams <dan.j.williams@gmail.com>, Jeff Moyer <jmoyer@redhat.com>,
       Simon Holm Thogersen <odie@cs.aau.dk>, suresh.b.siddha@intel.com
References: <1196983219534-git-send-email-zach.brown@oracle.com> <200801091448.46241.rusty@rustcorp.com.au> <47850F99.5020001@oracle.com>
In-Reply-To: <47850F99.5020001@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200801100904.46842.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 10 January 2008 05:16:57 Zach Brown wrote:
> > The latter.  A ring is optimal for processing a huge number of requests,
> > but if you're really going to be firing off syslet threads all over the
> > place you're not going to be optimal anyway.  And being able to point the
> > return value to the stack or into some datastructure is way nicer to code
> > (zero setup == easy to understand and easy to convert).
>
> One of Linus' rhetorical requirements for the syslets work is that we be
> able to wait for the result without spending overhead building up state
> in some completion context.  The userland rings in the current syslet
> patches achieve that and don't seem outrageously complicated.

I'd have to read his original statement, but eventfd doesn't build up state, 
so I think it qualifies.

YA incompatible userspace notification system just doesn't excite me though.

Cheers,
Rusty.
