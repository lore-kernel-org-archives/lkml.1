Return-Path: <linux-kernel-owner+w=401wt.eu-S1751605AbXDAJtF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751605AbXDAJtF (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Apr 2007 05:49:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751623AbXDAJtE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Apr 2007 05:49:04 -0400
Received: from nat-132.atmel.no ([80.232.32.132]:50018 "EHLO relay.atmel.no"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751527AbXDAJtD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Apr 2007 05:49:03 -0400
Message-ID: <51006.172.21.0.12.1175420843.squirrel@pat.norway.atmel.com>
In-Reply-To: <20070331131522.GA15148@lst.de>
References: <20070331131522.GA15148@lst.de>
Date: Sun, 1 Apr 2007 11:47:23 +0200 (CEST)
Subject: Re: missing kretprobes support on avr32 and sparc64
From: =?iso-8859-1?Q?H=E5vard_Skinnemoen?= <hskinnemoen@atmel.com>
To: "Christoph Hellwig" <hch@lst.de>
Cc: hskinnemoen@atmel.com, davem@davemloft.net, linux-arch@vger.kernel.org,
       linux-kernel@vger.kernel.org
User-Agent: SquirrelMail/1.4.5
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Priority: 3 (Normal)
Importance: Normal
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, March 31, 2007 15:15, Christoph Hellwig wrote:
> Currently all avr32 and sparc64 don't support kretprobes unlike all
> other kprobes supporting architectures.  This is not nice from the
> user interface point of view and from the ugly ifdefs point of view.
> Is there a reason these ports can't support kretprobes or was this
> simply an oversight / lazyness?

Lazyness on my part, I guess. It shouldn't be too hard to implement on
avr32; It looks like the generic code sets a breakpoint on function entry,
so all I have to do is to set a breakpoint on the return address. And
handle the breakpoint somehow. I'll try to implement it when I get back to
work in about a week.

Haavard

