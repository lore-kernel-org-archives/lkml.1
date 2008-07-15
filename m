Return-Path: <linux-kernel-owner+w=401wt.eu-S1757074AbYGOFUd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757074AbYGOFUd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2008 01:20:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755985AbYGOFUI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jul 2008 01:20:08 -0400
Received: from gate.crashing.org ([63.228.1.57]:34752 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755352AbYGOFUG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2008 01:20:06 -0400
Subject: Re: [GIT *] Allow request_firmware() to be satisfied from
	in-kernel, use it in more drivers.
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Reply-To: benh@kernel.crashing.org
To: David Miller <davem@davemloft.net>
Cc: rene.herman@keyaccess.nl, david@lang.hm, torvalds@linux-foundation.org,
       arjan@infradead.org, akpm@linux-foundation.org, dwmw2@infradead.org,
       alan@lxorguk.ukuu.org.uk, linux-kernel@vger.kernel.org
In-Reply-To: <20080714.192425.241878700.davem@davemloft.net>
References: <alpine.DEB.1.10.0807141750290.14223@asgard.lang.hm>
	 <20080714.185207.203328391.davem@davemloft.net>
	 <487C0A12.9060906@keyaccess.nl>
	 <20080714.192425.241878700.davem@davemloft.net>
Content-Type: text/plain
Date: Tue, 15 Jul 2008 15:15:39 +1000
Message-Id: <1216098939.7740.57.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> 
> Thanks for proving something I tried to establish for weeks
> but which Alan Cox, David W., and others vehemently denied.
> 
> They states that it was being done on a technical basis rather
> than being predominantly a legal one.

Despite the risk of going against the current here, I do like David
patches for one major reason: I love my kernels with everything
built-in, that's how I can netboot them etc... without having to bother
with installing modules.

David's patches allow me to do that with drivers that would have
-required- disk based firmwares beforehand. It allows things like
rooting off a block device that needs a firmware without an initrd,
etc....

As long as the firmwares are shipped with the kernel tree, I'm happpy,
and I don't care much about building the firmware inside the .ko's. Now,
if somebody care, I suppose it's a feature that can be added fairly
transparently.

Cheers,
Ben.


