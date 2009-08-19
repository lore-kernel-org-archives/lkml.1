Return-Path: <linux-kernel-owner+w=401wt.eu-S1751550AbZHSLXc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751550AbZHSLXc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Aug 2009 07:23:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751314AbZHSLXc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Aug 2009 07:23:32 -0400
Received: from casper.infradead.org ([85.118.1.10]:41690 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751266AbZHSLXb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Aug 2009 07:23:31 -0400
Subject: Re: spin_is_locked() broken for uniprocessor?
From: Peter Zijlstra <peterz@infradead.org>
To: Leon Woestenberg <leon.woestenberg@gmail.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, David Howells <dhowells@redhat.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Kumar Gala <galak@kernel.crashing.org>,
       Linux-Kernel List <linux-kernel@vger.kernel.org>,
       Steven Rostedt <rostedt@goodmis.org>,
       linuxppc-dev list <linuxppc-dev@ozlabs.org>,
       Ingo Molnar <mingo@elte.hu>
In-Reply-To: <c384c5ea0908190416r4e0b5508x4765381888516484@mail.gmail.com>
References: <alpine.LFD.2.00.0908190022570.3361@localhost.localdomain>
	 <DE9C9034-D2CE-4D21-93D9-A10FE2580920@kernel.crashing.org>
	 <7099.1250674686@redhat.com> <20090819115301.563be6da@lxorguk.ukuu.org.uk>
	 <c384c5ea0908190416r4e0b5508x4765381888516484@mail.gmail.com>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Wed, 19 Aug 2009 13:23:13 +0200
Message-Id: <1250680993.7583.350.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-08-19 at 13:16 +0200, Leon Woestenberg wrote:
> Hello,
> 
> On Wed, Aug 19, 2009 at 12:53 PM, Alan Cox<alan@lxorguk.ukuu.org.uk> wrote:
> > On Wed, 19 Aug 2009 10:38:06 +0100
> >
> > in drivers because there is driver code that uses spin_is_locked() in
> > fairly sensible fashion when dealing with locking.
> >
> One use is to measure lock contention hits on a particular spin lock.
> 
> 
> However I wonder if there are tracing capabilities to measure lock
> contention on a particular lock?

lock_stat no good for you?
