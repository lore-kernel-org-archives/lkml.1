Return-Path: <linux-kernel-owner+w=401wt.eu-S1755455AbXFWJT6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755455AbXFWJT6 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Jun 2007 05:19:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753374AbXFWJTu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 Jun 2007 05:19:50 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:33594 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753161AbXFWJTt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Jun 2007 05:19:49 -0400
Date: Sat, 23 Jun 2007 10:25:15 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Christoph Hellwig <hch@infradead.org>
Cc: David Smith <dsmith@redhat.com>, Christoph Hellwig <hch@infradead.org>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [patch 03/10] Allow userspace applications to use marker.h to
 parse the markers section in the kernel binary.
Message-ID: <20070623102515.3a1fc583@the-village.bc.nu>
In-Reply-To: <20070623080953.GA29241@infradead.org>
References: <20070510015555.973107048@polymtl.ca>
	<20070510020915.900170085@polymtl.ca>
	<20070510065137.GA7943@infradead.org>
	<46439941.4010909@redhat.com>
	<20070623080953.GA29241@infradead.org>
X-Mailer: Claws Mail 2.9.1 (GTK+ 2.10.8; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

O> > Out of curiosity, what is the kernel infrastructure you believe I should 
> > be using to get a list of all available markers in a kernel?  Note that 
> > I also have a requirement to get a list of all available markers in a 
> > kernel that isn't the currently running one.
> 
> None.  Modules using markers should ship with the kernel or be written
> on deman and not beeing created by some unreliable parser.

And what do you think should happen in the real world instead of
Christoph fantasy land ?

Getting the marker exports right is what is needed to avoid having an
unreliable parser and ending up with a reliable one.

Or would you rather someone loaded a JVM into kernel space so it was
"shipped with the kernel"

Alan
