Return-Path: <linux-kernel-owner+w=401wt.eu-S1759318AbYAYQBh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759318AbYAYQBh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2008 11:01:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758260AbYAYQBR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jan 2008 11:01:17 -0500
Received: from sovereign.computergmbh.de ([85.214.69.204]:57052 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757327AbYAYQBR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2008 11:01:17 -0500
Date: Fri, 25 Jan 2008 17:01:15 +0100 (CET)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: Jon Masters <jcm@redhat.com>
cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Andrew Morton <akpm@linux-foundation.org>, Valdis.Kletnieks@vt.edu,
       "Frank Ch. Eigler" <fche@redhat.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Christoph Hellwig <hch@infradead.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH] Linux Kernel Markers Support for Proprierary Modules
In-Reply-To: <1201275090.25284.281.camel@perihelion>
Message-ID: <Pine.LNX.4.64.0801251700070.15243@fbirervta.pbzchgretzou.qr>
References: <1201029235.18144.62.camel@perihelion>  <y0modbdnt4e.fsf@ton.toronto.redhat.com>
 <20080123031005.GA16766@Krystal>  <1201061860.25284.28.camel@perihelion>
 <20080123131442.GA6562@redhat.com>  <20080123144811.GA12296@Krystal>
 <27267.1201152358@turing-police.cc.vt.edu>  <1201155569.25284.88.camel@perihelion>
 <20080124124703.GB32559@Krystal>  <Pine.LNX.4.64.0801250840340.12676@fbirervta.pbzchgretzou.qr>
 <1201275090.25284.281.camel@perihelion>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Jan 25 2008 10:31, Jon Masters wrote:
>On Fri, 2008-01-25 at 08:56 +0100, Jan Engelhardt wrote:
>
>> So what is needed is an Oops with an explaining message
>> if (kernel_tainted) "blame that proprietary module first",
>> and make sure the user sees that oops even if in X.
>
>The former is actually trivially doable with the module->taints bits. We
>could have the equivalent of a neon flashing "blame this module" sign.
>
>I also agree, we should stop force loading. Incompatible struct module,
>etc. are really bad things to have mapped into a running kernel.

Forceloading should be reserved for developers who know
when a symversion change is safe (which is rare in itself,
but still).
