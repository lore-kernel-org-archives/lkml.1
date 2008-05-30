Return-Path: <linux-kernel-owner+w=401wt.eu-S1757584AbYE3B24@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757584AbYE3B24 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2008 21:28:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752707AbYE3B2s
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 May 2008 21:28:48 -0400
Received: from gate.crashing.org ([63.228.1.57]:60928 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753240AbYE3B2r (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2008 21:28:47 -0400
Subject: Re: [Ksummit-2008-discuss] RFC: Moving firmware blobs out of the
	kernel.
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Reply-To: benh@kernel.crashing.org
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Jeff Garzik <jeff@garzik.org>, David Woodhouse <dwmw2@infradead.org>,
       ksummit-2008-discuss@lists.linux-foundation.org,
       linux-kernel@vger.kernel.org, James.Bottomley@hansenpartnership.com,
       David Miller <davem@davemloft.net>
In-Reply-To: <1212095864.24826.2.camel@lappy.programming.kicks-ass.net>
References: <1211995212.3445.52.camel@localhost.localdomain>
	 <20080528.225826.40264516.davem@davemloft.net>
	 <1212041839.8888.38.camel@pasglop> <20080529124548.GC8065@mit.edu>
	 <1212077700.26088.83.camel@shinybook.infradead.org>
	 <483F002E.5060002@garzik.org>
	 <1212095864.24826.2.camel@lappy.programming.kicks-ass.net>
Content-Type: text/plain
Date: Fri, 30 May 2008 11:27:50 +1000
Message-Id: <1212110870.15633.17.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2008-05-29 at 23:17 +0200, Peter Zijlstra wrote:
> > If the firmware has a compatible license and is required for critical 
> > operations like booting the machine, built-in firmware should remain an 
> > option.  For certain embedded cases, I could certainly see that 
> > in-kernel firmware being the best method for firmware distribution, for 
> > both $Platform's users and $Platform's developers.
> 
> I certainly agree, pushing more and more into initrd just annoys the
> hell out of me.
> 
> I'd argue to include everything needed to build (and esp cross build) an
> initrd into the kernel - up until that point initrds are useless.

Us kernel hackers tend to like self-contained netbootable kernels
that have everything needed to boot a machine all the way to a shell
prompt :-)

David's proposal however do provides for storing the firmwares in
the kernel image, so I have no objection there.

Ben.


