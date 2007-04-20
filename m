Return-Path: <linux-kernel-owner+w=401wt.eu-S1767057AbXDTKpV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767057AbXDTKpV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Apr 2007 06:45:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1767056AbXDTKpU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Apr 2007 06:45:20 -0400
Received: from mx1.redhat.com ([66.187.233.31]:55175 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1767053AbXDTKpT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Apr 2007 06:45:19 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
	Directors: Michael Cunningham (USA), Charlie Peters (USA) and
	David Owens (Ireland)
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20070420111727.fc69d671.dada1@cosmosbay.com> 
References: <20070420111727.fc69d671.dada1@cosmosbay.com>  <6d6a94c50704200139vb9b24f6y77a6d23544c8f7b9@mail.gmail.com> <200704091146.32346.rgetz@blackfin.uclinux.org> <1176112223.17975.8.camel@roc-desktop> <9561.1176209728@redhat.com> <200704101952.05380.rgetz@blackfin.uclinux.org> <6d6a94c50704170336l62fc9ael1e58197e6c3853ba@mail.gmail.com> <2817.1176910411@redhat.com> <6d6a94c50704192146k5bbe2aefr31fa5726bf1c1e54@mail.gmail.com> <1016.1177055893@redhat.com> <2181.1177059532@redhat.com> 
To: Eric Dumazet <dada1@cosmosbay.com>
Cc: "Aubrey Li" <aubreylee@gmail.com>,
       "Robin Getz" <rgetz@blackfin.uclinux.org>, uaca@alumni.uv.es,
       bryan.wu@analog.com, "Alan Cox" <alan@lxorguk.ukuu.org.uk>,
       waltje@uwalt.nl.mugnet.org, netdev@vger.kernel.org,
       "Andrew Morton" <akpm@osdl.org>,
       "Linux Kernel" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] CONFIG_PACKET_MMAP should depend on MMU 
X-Mailer: MH-E 8.0; nmh 1.1; GNU Emacs 22.0.50
Date: Fri, 20 Apr 2007 11:43:47 +0100
Message-ID: <4759.1177065827@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Eric Dumazet <dada1@cosmosbay.com> wrote:

> Is it really possible to allocate an order-10 page, then release part of it
> (say an order-8 subpage) ?

Yes.

David
