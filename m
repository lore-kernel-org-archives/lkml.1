Return-Path: <linux-kernel-owner+w=401wt.eu-S1760918AbYFDR1Q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760918AbYFDR1Q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2008 13:27:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754305AbYFDR1A
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Jun 2008 13:27:00 -0400
Received: from relay1.sgi.com ([192.48.171.29]:56046 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753079AbYFDR1A (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2008 13:27:00 -0400
Date: Wed, 4 Jun 2008 12:26:44 -0500
From: Paul Jackson <pj@sgi.com>
To: Mark Hounschell <dmarkh@cfl.rr.com>
Cc: nickpiggin@yahoo.com.au, a.p.zijlstra@chello.nl, ioe-lkml@rameria.de,
       linux-kernel@vger.kernel.org, kernel@kolivas.org, dfults@sgi.com,
       devik@cdi.cz, sivanich@sgi.com, dino@in.ibm.com,
       emmanuel.pacaud@univ-poitiers.fr, deweerdt@free.fr, mingo@elte.hu,
       colpatch@us.ibm.com, maxk@qualcomm.com, rostedt@goodmis.org,
       oleg@tv-sign.ru, paulmck@us.ibm.com, menage@google.com,
       rddunlap@osdl.org, suresh.b.siddha@intel.com, tglx@linutronix.de
Subject: Re: Inquiry: Should we remove "isolcpus= kernel boot option? (may
 have realtime uses)
Message-Id: <20080604122644.cd73bfb9.pj@sgi.com>
In-Reply-To: <48466745.5050802@cfl.rr.com>
References: <20080601213019.14ea8ef8.pj@sgi.com>
	<200806030035.58387.ioe-lkml@rameria.de>
	<1212446707.6269.26.camel@lappy.programming.kicks-ass.net>
	<200806031603.40731.nickpiggin@yahoo.com.au>
	<48466745.5050802@cfl.rr.com>
Organization: SGI
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.12.0; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mark wrote:
> What is an abonination, is that cpusets are equired for this type of 
> isolation to begin with, even on a 2 processor machine.

Just to be sure I'm following you here, you stating that you
want to be able to manipulate the isolated cpu map at runtime,
not just with the boot option isolcpus, right?  Where this
isolated cpu map works just fine even on systems which do
not have cpusets configured, right?

-- 
                  I won't rest till it's the best ...
                  Programmer, Linux Scalability
                  Paul Jackson <pj@sgi.com> 1.940.382.4214
