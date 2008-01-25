Return-Path: <linux-kernel-owner+w=401wt.eu-S1758606AbYAYPhT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758606AbYAYPhT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2008 10:37:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755519AbYAYPhE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jan 2008 10:37:04 -0500
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:56102 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758030AbYAYPhA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2008 10:37:00 -0500
Date: Fri, 25 Jan 2008 16:32:40 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Valdis.Kletnieks@vt.edu
Cc: Jan Engelhardt <jengelh@computergmbh.de>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Andrew Morton <akpm@linux-foundation.org>,
       "Frank Ch. Eigler" <fche@redhat.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Christoph Hellwig <hch@infradead.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Jon Masters <jcm@redhat.com>
Subject: Re: [PATCH] Linux Kernel Markers Support for Proprierary Modules
Message-ID: <20080125163240.7d68cb24@core>
In-Reply-To: <15663.1201248183@turing-police.cc.vt.edu>
References: <1201029235.18144.62.camel@perihelion>
	<y0modbdnt4e.fsf@ton.toronto.redhat.com>
	<20080123031005.GA16766@Krystal>
	<1201061860.25284.28.camel@perihelion>
	<20080123131442.GA6562@redhat.com>
	<20080123144811.GA12296@Krystal>
	<27267.1201152358@turing-police.cc.vt.edu>
	<1201155569.25284.88.camel@perihelion>
	<20080124124703.GB32559@Krystal>
	<Pine.LNX.4.64.0801250840340.12676@fbirervta.pbzchgretzou.qr>
	<15663.1201248183@turing-police.cc.vt.edu>
X-Mailer: Claws Mail 3.2.0 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 25 Jan 2008 03:03:03 -0500
Valdis.Kletnieks@vt.edu wrote:

> On Fri, 25 Jan 2008 08:56:09 +0100, Jan Engelhardt said:
> > So what is needed is an Oops with an explaining message
> > if (kernel_tainted) "blame that proprietary module first",
> > and make sure the user sees that oops even if in X.
> 
> The person who solves the "even if in X" problem will probably be nominated
> for sainthood by the Linux community.  "It just hung with flashing LED's" is
> just too common an event....

I've been poking at it a bit but it will need X server help, or
eventually the kernel mode switch code.

Alan
