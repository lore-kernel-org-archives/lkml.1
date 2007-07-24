Return-Path: <linux-kernel-owner+w=401wt.eu-S1761948AbXGXXN6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761948AbXGXXN6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jul 2007 19:13:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756660AbXGXXNv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Jul 2007 19:13:51 -0400
Received: from deine-taler.de ([217.160.107.63]:54947 "EHLO deine-taler.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754757AbXGXXNu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jul 2007 19:13:50 -0400
Date: Wed, 25 Jul 2007 01:13:49 +0200
From: Ulrich Kunitz <kune@deine-taler.de>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Chuck Ebbert <cebbert@redhat.com>, linux-kernel@vger.kernel.org,
       honza@jikos.cz, jkosina@suse.cz
Subject: Re: Is PIE randomization breaking klibc binaries?
Message-ID: <20070724231349.GA20720@deine-taler.de>
References: <20070720211300.GA21644@deine-taler.de> <46A131BF.4080404@zytor.com> <46A6624E.60003@redhat.com> <46A667BD.5080106@redhat.com> <20070724220053.GA20531@deine-taler.de> <46A68003.6060901@redhat.com> <46A68118.9080902@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46A68118.9080902@zytor.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 07-07-24 15:45 H. Peter Anvin wrote:

> Chuck Ebbert wrote:
> >
> >Okay, I tested with Fedora on x86_64 and it worked there too.
> >(Not that that proves much.)
> >
> >Did you capture any of the error messages, like the address
> >of the segfault?
> >
> 
> FWIW, on x86-64, this should show up in dmesg.
> 
> 	-hpa

Guys, this is at boot time and most of the binaries don't work.
However at the end busybox is called and then there is a shell,
where I can call the binaries and force the segmentation
violation. Pencil and paper work usually. But right now I don't
have the broken kernel anymore and it's 1 am here. Wait for
tomorrow.

-- 
Uli Kunitz
