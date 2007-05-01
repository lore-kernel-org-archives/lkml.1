Return-Path: <linux-kernel-owner+w=401wt.eu-S1030468AbXEAXCf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030468AbXEAXCf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 May 2007 19:02:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030572AbXEAXCf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 May 2007 19:02:35 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:44823 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1030468AbXEAXCe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 May 2007 19:02:34 -0400
Date: Wed, 2 May 2007 00:04:58 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Bill Irwin <bill.irwin@oracle.com>
Cc: Theodore Tso <tytso@mit.edu>, Ulrich Drepper <drepper@gmail.com>,
       Bill Irwin <bill.irwin@oracle.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Eric Dumazet <dada1@cosmosbay.com>, linux-kernel@vger.kernel.org,
       wli@holomorphy.com
Subject: Re: per-thread rusage
Message-ID: <20070502000458.2a7885d9@the-village.bc.nu>
In-Reply-To: <20070501223440.GT26598@holomorphy.com>
References: <20070404172931.GM2986@holomorphy.com>
	<20070404194829.1a93d8fd.dada1@cosmosbay.com>
	<20070404181050.GN2986@holomorphy.com>
	<20070409165315.4704021f.akpm@linux-foundation.org>
	<20070410004201.GA2986@holomorphy.com>
	<20070501172937.GQ26598@holomorphy.com>
	<a36005b50705011139p361dbc46ube0da5e42955f8b0@mail.gmail.com>
	<20070501202456.GR26598@holomorphy.com>
	<a36005b50705011510k4cd7873dr3fb8206c0f107169@mail.gmail.com>
	<20070501222724.GG26093@thunk.org>
	<20070501223440.GT26598@holomorphy.com>
X-Mailer: Claws Mail 2.9.1 (GTK+ 2.10.8; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> I just so happen to think we should implement a variety of CPU resource
> limits beyond what we now do, so this, too, interests me.

Agreed - and make them all 64bit while doing the cleanup. One thing
several Unixen have we don't for 32bi boxes is a proper set of 64bit
resource handling for memory/file etc.

We could also start using the CPU facilities to enforce some of
the really interesting real time process ones (like main memory
bandwidth) that at the moment we have no control over and can lead to
very unfair behaviour.

Alan
