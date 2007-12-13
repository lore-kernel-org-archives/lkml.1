Return-Path: <linux-kernel-owner+w=401wt.eu-S1755593AbXLMDFZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755593AbXLMDFZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Dec 2007 22:05:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752207AbXLMDFP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Dec 2007 22:05:15 -0500
Received: from gate.crashing.org ([63.228.1.57]:34067 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751229AbXLMDFN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Dec 2007 22:05:13 -0500
Subject: Re: Possible issue with dangling PCI BARs
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Reply-To: benh@kernel.crashing.org
To: linux-pci@atrey.karlin.mff.cuni.cz
Cc: Linux Kernel list <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
In-Reply-To: <1197514804.15741.60.camel@pasglop>
References: <1197514804.15741.60.camel@pasglop>
Content-Type: text/plain
Date: Thu, 13 Dec 2007 14:04:58 +1100
Message-Id: <1197515098.15741.64.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Thu, 2007-12-13 at 14:00 +1100, Benjamin Herrenschmidt wrote:

 .../...

(oops, sent too fast)

> So not only we can have a dangling BAR, but nothing prevent us to
> actually go turn IO or MEM decoding on in case it wasn't already the
> case on that device.

And I was about to say before I clicked "send".. can't we do something like
writing all ff's into the BAR at the same time as we clear res->start ? Isn't
that supposed to pretty much disable decoding on that BAR ? Or not... Probably
still better than leaving it to whatever dangling value it had no ?

Also, maybe we should disable IO and MEM decoding by default on devices for
which one resource of that type failed to allocate ?

Ben.


