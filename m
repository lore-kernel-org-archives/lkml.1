Return-Path: <linux-kernel-owner+w=401wt.eu-S1751860AbYFDEri@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751860AbYFDEri (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2008 00:47:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756547AbYFDEr1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Jun 2008 00:47:27 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:43054 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756529AbYFDEr0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2008 00:47:26 -0400
Date: Tue, 3 Jun 2008 23:47:12 -0500
From: Paul Jackson <pj@sgi.com>
To: Max Krasnyansky <maxk@qualcomm.com>
Cc: ioe-lkml@rameria.de, sivanich@sgi.com, a.p.zijlstra@chello.nl,
       linux-kernel@vger.kernel.org, kernel@kolivas.org, dfults@sgi.com,
       devik@cdi.cz, dino@in.ibm.com, emmanuel.pacaud@univ-poitiers.fr,
       deweerdt@free.fr, mingo@elte.hu, colpatch@us.ibm.com,
       nickpiggin@yahoo.com.au, rostedt@goodmis.org, oleg@tv-sign.ru,
       paulmck@us.ibm.com, menage@google.com, rddunlap@osdl.org,
       suresh.b.siddha@intel.com, tglx@linutronix.de
Subject: Re: Inquiry: Should we remove "isolcpus= kernel boot option? (may
 have realtime uses)
Message-Id: <20080603234712.ffb6708c.pj@sgi.com>
In-Reply-To: <48461ADA.8020303@qualcomm.com>
References: <20080601213019.14ea8ef8.pj@sgi.com>
	<1212446707.6269.26.camel@lappy.programming.kicks-ass.net>
	<48447C75.8040203@qualcomm.com>
	<200806030156.00155.ioe-lkml@rameria.de>
	<4844BB41.7000605@qualcomm.com>
	<4845D825.6000403@qualcomm.com>
	<20080603194148.56dfebe1.pj@sgi.com>
	<48461ADA.8020303@qualcomm.com>
Organization: SGI
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.12.0; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Max wrote:
> Ingo's case is a bad example.

Could be ... I wasn't paying close attention to the details.

If so, a good product marketing manager would first upsell the customer
to the better product, and then let falling sales guide the removal
of the old product.

That is, if you can guide most of the users of "isolcpus=" to a better
solution, in -their- view, so that they voluntary choose to migrate
to the other solution, then you get to deprecate and then remove the
old mechanism.

To the extent that you can show that the old mechanism is costing us
(maintenance, reliability, performance, impeding progress, ...) then
you get to accelerate the deprecation period, even to the point of
an immediate removal of the old feature, if it's of sufficiently little
use and great pain.

We do have one problem with letting "falling sales" guide feature
removal.  Unlike Walmart, where they know what has sold where before
the customer has even left the store, we can't easily track usage of
kernel features.  Occassionally, we can stir the pot and get some
feedback, as I've done on this thread, if we have a narrow target
audience that we have good reason is especially interested.  But that
only works occassionally.

-- 
                  I won't rest till it's the best ...
                  Programmer, Linux Scalability
                  Paul Jackson <pj@sgi.com> 1.940.382.4214
