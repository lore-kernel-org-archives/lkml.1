Return-Path: <linux-kernel-owner+w=401wt.eu-S1754032AbZGANNp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754032AbZGANNp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jul 2009 09:13:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751807AbZGANNh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Jul 2009 09:13:37 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:33517 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751054AbZGANNh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jul 2009 09:13:37 -0400
Date: Wed, 1 Jul 2009 15:13:26 +0200
From: Ingo Molnar <mingo@elte.hu>
To: David Howells <dhowells@redhat.com>
Cc: Paul Mackerras <paulus@samba.org>, Arnd Bergmann <arnd@arndb.de>,
       torvalds@osdl.org, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] FRV: Wire up new syscalls
Message-ID: <20090701131326.GB13524@elte.hu>
References: <19019.22629.720187.794661@cargo.ozlabs.ibm.com> <20090701115425.GJ15958@elte.hu> <20090630215437.GB22851@elte.hu> <20090630212454.19294.75622.stgit@warthog.procyon.org.uk> <20090630213406.GB17492@elte.hu> <200906302341.58582.arnd@arndb.de> <22582.1246447691@redhat.com> <32551.1246450797@redhat.com> <32707.1246452087@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <32707.1246452087@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* David Howells <dhowells@redhat.com> wrote:

> Paul Mackerras <paulus@samba.org> wrote:
> 
> > I did a generic implementation using irq disable on UP and 
> > hashed spin-locks on SMP.  See 09d4e0ed for the implementation
> 
> I can do better than that on FRV.  FRV has load/store-double 
> instructions that I can use to atomically load/store 64-bit memory 
> locations by using paired registers for the data.

Yeah - still i'd suggest to just go with the generic code initially, 
as then 'perf' output itself can be used to verify whether the FRV 
atomic64_t implementation is correct.

	Ingo
