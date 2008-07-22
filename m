Return-Path: <linux-kernel-owner+w=401wt.eu-S1755735AbYGVLf6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755735AbYGVLf6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2008 07:35:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753714AbYGVLfs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jul 2008 07:35:48 -0400
Received: from gate.crashing.org ([63.228.1.57]:55027 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752819AbYGVLfr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2008 07:35:47 -0400
Subject: Re: [PATCH] Make u64 long long on all architectures (was: the
	printk problem)
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Reply-To: benh@kernel.crashing.org
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Matthew Wilcox <matthew@wil.cx>, linux-arch@vger.kernel.org,
       linux-ia64@vger.kernel.org, linux-kernel@vger.kernel.org,
       linuxppc-dev@ozlabs.org, Peter Anvin <hpa@zytor.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       "David S. Miller" <davem@davemloft.net>
In-Reply-To: <20080722030506.206a2cc2.akpm@linux-foundation.org>
References: <20080625131101.GA6205@digi.com>
	 <20080704104634.GA31634@digi.com>
	 <20080704111540.ddffd241.akpm@linux-foundation.org>
	 <alpine.LFD.1.10.0807041147450.2815@woody.linux-foundation.org>
	 <alpine.LFD.1.10.0807041250220.2815@woody.linux-foundation.org>
	 <20080704132716.f1e12554.akpm@linux-foundation.org>
	 <20080704204252.GM14894@parisc-linux.org>
	 <20080704150100.1f7b8a65.akpm@linux-foundation.org>
	 <20080705020350.GN14894@parisc-linux.org>
	 <20080722030506.206a2cc2.akpm@linux-foundation.org>
Content-Type: text/plain
Date: Tue, 22 Jul 2008 21:35:30 +1000
Message-Id: <1216726530.11027.205.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> 
> This is (IMO) a desirable change and will prevent a heck of a lot of
> goofing around, and will permit a lot of prior goofing around to
> be removed.
> 
> But I bet there are lots of instalces of printk("%l", some_u64) down in
> arch code where the type of u64 _is_ known which will now spew warnings.

Well, I'm about to call a big "warning fixing day" on the powerpc list,
I saw a few today when building a couple of configs and that hurts my
eyes so we may as well fold that in :-)

Cheers,
Ben.
 

