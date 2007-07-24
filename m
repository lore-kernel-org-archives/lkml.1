Return-Path: <linux-kernel-owner+w=401wt.eu-S1759820AbXGXXtD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759820AbXGXXtD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jul 2007 19:49:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756935AbXGXXsx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Jul 2007 19:48:53 -0400
Received: from gate.crashing.org ([63.228.1.57]:32824 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756227AbXGXXsw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jul 2007 19:48:52 -0400
Subject: Re: Power Management framework proposal
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: david@lang.hm
Cc: Arjan van de Ven <arjan@infradead.org>,
       LKML <linux-kernel@vger.kernel.org>,
       linux-pm <linux-pm@lists.linux-foundation.org>
In-Reply-To: <Pine.LNX.4.64.0707241556140.6590@asgard.lang.hm>
References: <Pine.LNX.4.64.0707212339550.6350@asgard.lang.hm>
	 <1185125189.2714.13.camel@laptopd505.fenrus.org>
	 <1185229405.5439.148.camel@localhost.localdomain>
	 <Pine.LNX.4.64.0707241313580.6590@asgard.lang.hm>
	 <1185313138.5439.285.camel@localhost.localdomain>
	 <Pine.LNX.4.64.0707241556140.6590@asgard.lang.hm>
Content-Type: text/plain
Date: Wed, 25 Jul 2007 09:47:57 +1000
Message-Id: <1185320877.5439.300.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-07-24 at 16:02 -0700, david@lang.hm wrote:
> 
> what requirements are needed? (I'm sure that there are others, but 
> hopefully it's possible to avoid requirements like 'the clock speed
> for 
> device A must be >X to allow device B to operate in mode Y') 

I had an idea a while ago, might still be in the pm list archives, of
exposing constraints as opaque bitmaps. The bits have defined meaning
for a given bus, but are opaque to the core.

The devices however, provide tables indicating to the core their list of
power states (with names) and their requirements in term of parent
states (using such bitmasks).

Thus, the core can resolve the dependency requirements without having to
know about the actual meaning of the states of the various busses.

Ben.


