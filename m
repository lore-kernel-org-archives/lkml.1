Return-Path: <linux-kernel-owner+w=401wt.eu-S1757436AbYAYPcU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757436AbYAYPcU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2008 10:32:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753509AbYAYPcF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jan 2008 10:32:05 -0500
Received: from mx1.redhat.com ([66.187.233.31]:39620 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753542AbYAYPcD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2008 10:32:03 -0500
Subject: Re: [PATCH] Linux Kernel Markers Support for Proprierary Modules
From: Jon Masters <jcm@redhat.com>
To: Jan Engelhardt <jengelh@computergmbh.de>
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Andrew Morton <akpm@linux-foundation.org>, Valdis.Kletnieks@vt.edu,
       "Frank Ch. Eigler" <fche@redhat.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Christoph Hellwig <hch@infradead.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
In-Reply-To: <Pine.LNX.4.64.0801250840340.12676@fbirervta.pbzchgretzou.qr>
References: <1201029235.18144.62.camel@perihelion>
	 <y0modbdnt4e.fsf@ton.toronto.redhat.com> <20080123031005.GA16766@Krystal>
	 <1201061860.25284.28.camel@perihelion> <20080123131442.GA6562@redhat.com>
	 <20080123144811.GA12296@Krystal> <27267.1201152358@turing-police.cc.vt.edu>
	 <1201155569.25284.88.camel@perihelion> <20080124124703.GB32559@Krystal>
	 <Pine.LNX.4.64.0801250840340.12676@fbirervta.pbzchgretzou.qr>
Content-Type: text/plain
Organization: Red Hat, Inc.
Date: Fri, 25 Jan 2008 10:31:30 -0500
Message-Id: <1201275090.25284.281.camel@perihelion>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.2 (2.12.2-2.fc8) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2008-01-25 at 08:56 +0100, Jan Engelhardt wrote:

> So what is needed is an Oops with an explaining message
> if (kernel_tainted) "blame that proprietary module first",
> and make sure the user sees that oops even if in X.

The former is actually trivially doable with the module->taints bits. We
could have the equivalent of a neon flashing "blame this module" sign.

I also agree, we should stop force loading. Incompatible struct module,
etc. are really bad things to have mapped into a running kernel.

Jon.


