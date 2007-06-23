Return-Path: <linux-kernel-owner+w=401wt.eu-S1755700AbXFWJno@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755700AbXFWJno (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Jun 2007 05:43:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753374AbXFWJng
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 Jun 2007 05:43:36 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:36291 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753107AbXFWJnf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Jun 2007 05:43:35 -0400
Date: Sat, 23 Jun 2007 10:49:05 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Christoph Hellwig <hch@infradead.org>
Cc: Christoph Hellwig <hch@infradead.org>, David Smith <dsmith@redhat.com>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [patch 03/10] Allow userspace applications to use marker.h to
 parse the markers section in the kernel binary.
Message-ID: <20070623104905.20ae2929@the-village.bc.nu>
In-Reply-To: <20070623093209.GB30849@infradead.org>
References: <20070510015555.973107048@polymtl.ca>
	<20070510020915.900170085@polymtl.ca>
	<20070510065137.GA7943@infradead.org>
	<46439941.4010909@redhat.com>
	<20070623080953.GA29241@infradead.org>
	<20070623102515.3a1fc583@the-village.bc.nu>
	<20070623093209.GB30849@infradead.org>
X-Mailer: Claws Mail 2.9.1 (GTK+ 2.10.8; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 23 Jun 2007 10:32:09 +0100
Christoph Hellwig <hch@infradead.org> wrote:

> On Sat, Jun 23, 2007 at 10:25:15AM +0100, Alan Cox wrote:
> > Getting the marker exports right is what is needed to avoid having an
> > unreliable parser and ending up with a reliable one.
> > 
> > Or would you rather someone loaded a JVM into kernel space so it was
> > "shipped with the kernel"
> 
> You're totall missing the point here.  We're talking about kernel internal
> interface, and the point for them has always been not to care about out
> of tree users.  There is no relation to anything involving a JVM here.

Of course there is Christoph.

If you have a system which generates and loads modules then they can't be
in tree (as they don't exist except transiently). On the other hand if it
outputs java byte codes then a JVM to process them can be in tree. It
would be a stupid solution to the problem but you appear to be objecting
to sane ones.

The system to create the dynamic modules could certainly be in-tree but to
argue that code dynamically created should be "in tree" already is a
bit silly really isn't it ?

A second way of point out your argument is totally and utterly bogus
would be the MODULE_ interface. The modutils are clearly out of tree
users.

So whats the difference between modutils and markers ? Would it suddenely
change if modutils developed modinfo --dump-markers ? 

Alan
