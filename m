Return-Path: <linux-kernel-owner+w=401wt.eu-S1762281AbZAHTQb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762281AbZAHTQb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jan 2009 14:16:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761420AbZAHTQK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Jan 2009 14:16:10 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:33789
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1761112AbZAHTQJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jan 2009 14:16:09 -0500
Date: Thu, 08 Jan 2009 11:16:10 -0800 (PST)
Message-Id: <20090108.111610.132149837.davem@davemloft.net>
To: iws@ovro.caltech.edu
Cc: linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org,
       shemminger@vyatta.com, arnd@arndb.de, netdev@vger.kernel.org
Subject: Re: [PATCH RFC v5] net: add PCINet driver
From: David Miller <davem@davemloft.net>
In-Reply-To: <20090107195052.GA24981@ovro.caltech.edu>
References: <20090107195052.GA24981@ovro.caltech.edu>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ira Snyder <iws@ovro.caltech.edu>
Date: Wed, 7 Jan 2009 11:50:52 -0800

> This adds support to Linux for a virtual ethernet interface which uses the
> PCI bus as its transport mechanism. It creates a simple, familiar, and fast
> method of communication for two devices connected by a PCI interface.

Well, it looks like much more than that to me.

What is this UART thing in here for?

I can only assume it's meant to be used as a console port between the
x86 host and the powerpc nodes.

You haven't even mentioned this UART aspect even indirectly in the
commit message.

This just looks like yet another set of virtualization drivers
to me.  You could have just have easily built this using your
own PCI backplane framework, and using the virtio stuff on top.

And the virtio stuff has all kinds of snazzy optimizations that
will likely improve your throughput, it has console drivers that
distributions already probe for and attach appropriately, etc.

In short I really don't like this conceptually, it can be done
so much better using facilities we already have that are
heavily optimized and userland understands already.
