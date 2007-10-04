Return-Path: <linux-kernel-owner+w=401wt.eu-S1760270AbXJDUsq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760270AbXJDUsq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Oct 2007 16:48:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757129AbXJDUsg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Oct 2007 16:48:36 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:46871
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1756464AbXJDUsf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Oct 2007 16:48:35 -0400
Date: Thu, 04 Oct 2007 13:48:34 -0700 (PDT)
Message-Id: <20071004.134834.112622292.davem@davemloft.net>
To: arjan@infradead.org
Cc: clameter@sgi.com, willy@linux.intel.com, nickpiggin@yahoo.com.au,
       hch@lst.de, mel@skynet.ie, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org, dgc@sgi.com, jens.axboe@oracle.com
Subject: Re: SLUB performance regression vs SLAB
From: David Miller <davem@davemloft.net>
In-Reply-To: <20071004105046.7b019fe8@laptopd505.fenrus.org>
References: <20071004161621.GO12049@parisc-linux.org>
	<Pine.LNX.4.64.0710041034550.10854@schroedinger.engr.sgi.com>
	<20071004105046.7b019fe8@laptopd505.fenrus.org>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arjan van de Ven <arjan@infradead.org>
Date: Thu, 4 Oct 2007 10:50:46 -0700

> Ok every time something says anything not 100% positive about SLUB you
> come back with "but it's fixed in the next patch set"... *every time*.

I think this is partly Christoph subconsciously venting his
frustration that he's never given a reproducable test case he can use
to fix the problem.

There comes a point where it is the reporter's responsibility to help
the developer come up with a publishable test case the developer can
use to work on fixing the problem and help ensure it stays fixed.

Using an unpublishable benchmark, whose results even cannot be
published, really stretches the limits of "reasonable" don't you
think?

This "SLUB isn't ready yet" bullshit is just a shamans dance which
distracts attention away from the real problem, which is that a
reproducable, publishable test case, is not being provided to the
developer so he can work on fixing the problem.

I can tell you this thing would be fixed overnight if a proper test
case had been provided by now.
