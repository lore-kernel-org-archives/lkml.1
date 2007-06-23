Return-Path: <linux-kernel-owner+w=401wt.eu-S1760040AbXFWOts@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760040AbXFWOts (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Jun 2007 10:49:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757807AbXFWOtl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 Jun 2007 10:49:41 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:41643 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757662AbXFWOtk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Jun 2007 10:49:40 -0400
Date: Sat, 23 Jun 2007 15:55:05 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Christoph Hellwig <hch@infradead.org>
Cc: Christoph Hellwig <hch@infradead.org>, David Smith <dsmith@redhat.com>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [patch 03/10] Allow userspace applications to use marker.h to
 parse the markers section in the kernel binary.
Message-ID: <20070623155505.7485d43e@the-village.bc.nu>
In-Reply-To: <20070623100600.GA31638@infradead.org>
References: <20070510015555.973107048@polymtl.ca>
	<20070510020915.900170085@polymtl.ca>
	<20070510065137.GA7943@infradead.org>
	<46439941.4010909@redhat.com>
	<20070623080953.GA29241@infradead.org>
	<20070623102515.3a1fc583@the-village.bc.nu>
	<20070623093209.GB30849@infradead.org>
	<20070623104905.20ae2929@the-village.bc.nu>
	<20070623100600.GA31638@infradead.org>
X-Mailer: Claws Mail 2.9.1 (GTK+ 2.10.8; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 23 Jun 2007 11:06:00 +0100
Christoph Hellwig <hch@infradead.org> wrote:

> On Sat, Jun 23, 2007 at 10:49:05AM +0100, Alan Cox wrote:
> > The system to create the dynamic modules could certainly be in-tree but to
> > argue that code dynamically created should be "in tree" already is a
> > bit silly really isn't it ?
> 
> I never argued that.  Creating them intree is equivalent to having the
> generated modules in tree for all purposes related to interface stability.

So if all the applications using markers are shoved into the kernel
source tree you are happy, and if they are distributed elsewhere you are
not ?

Or do you want a single controlled 'with the kernel' tool for doing the
outputting which alone has close links with the kernel (ie modinfo
--dump-markers) or similar ?
