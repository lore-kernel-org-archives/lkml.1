Return-Path: <linux-kernel-owner+w=401wt.eu-S1753941AbYFFJTa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753941AbYFFJTa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2008 05:19:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752178AbYFFJTU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Jun 2008 05:19:20 -0400
Received: from brick.kernel.dk ([87.55.233.238]:1033 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752136AbYFFJTU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2008 05:19:20 -0400
Date: Fri, 6 Jun 2008 11:19:17 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Jan Engelhardt <jengelh@medozas.de>
Cc: Fausto Richetti Blanco <fausto.blanco@gmail.com>,
       linux-kernel@vger.kernel.org, miquels@cistron.nl, riel@redhat.com
Subject: Re: Pipe buffers' limit of 16 * 4K
Message-ID: <20080606091916.GM5757@kernel.dk>
References: <d8d698ae0805231255i4d0da724p68cb2b9376134797@mail.gmail.com> <d8d698ae0805231719g4202edf2k947bba4128385ab6@mail.gmail.com> <20080523205630.444fe2b9@bree.surriel.com> <d8d698ae0805261043u125b653ve73d067cd92caa16@mail.gmail.com> <d8d698ae0805290600s782e16b4pe70d725f55826cf0@mail.gmail.com> <1212067164.8621.3.camel@localhost.localdomain> <alpine.LNX.1.10.0805291633000.19264@fbirervta.pbzchgretzou.qr> <d8d698ae0805290846w7cd2b14j99db2e1e2a9ec7ed@mail.gmail.com> <20080530103531.GT25504@kernel.dk> <alpine.LNX.1.10.0806051155070.29055@fbirervta.pbzchgretzou.qr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LNX.1.10.0806051155070.29055@fbirervta.pbzchgretzou.qr>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 05 2008, Jan Engelhardt wrote:
> 
> On Friday 2008-05-30 12:35, Jens Axboe wrote:
> >
> >I have an old patch that does that, I just looked it up and it was last
> >updated for 2.6.23. It uses fcntl() with F_SETPIPE_SZ for getting and
> >setting the pipe size.
> >
> >Patch updated, the below is the current Linus kernel.
> 
> Can you merge it?

I could, but I think two key things are missing:

- Is fcntl() the interface we want for changing the pipe size?
- So far, no real problems or performance increases have been
  demonstrated.

I'd rather not attempt to push this until the two things have been
addressed/discussed.

-- 
Jens Axboe

