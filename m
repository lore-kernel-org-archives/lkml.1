Return-Path: <linux-kernel-owner+w=401wt.eu-S966227AbXDDBQq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966227AbXDDBQq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Apr 2007 21:16:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966230AbXDDBQq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Apr 2007 21:16:46 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:47088
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S966227AbXDDBQp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Apr 2007 21:16:45 -0400
Date: Tue, 03 Apr 2007 18:16:45 -0700 (PDT)
Message-Id: <20070403.181645.68159458.davem@davemloft.net>
To: dwmw2@infradead.org
Cc: flar@allandria.com, paulus@samba.org, linuxppc-dev@ozlabs.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Stop pmac_zilog from abusing 8250's device numbers.
From: David Miller <davem@davemloft.net>
In-Reply-To: <1175648051.10567.61.camel@shinybook.infradead.org>
References: <1175644642.10567.31.camel@shinybook.infradead.org>
	<20070403221002.GA13210@cynthia.pants.nu>
	<1175648051.10567.61.camel@shinybook.infradead.org>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Woodhouse <dwmw2@infradead.org>
Date: Tue, 03 Apr 2007 20:54:10 -0400

> Yes, it would be theoretically possible to come up with a way to share
> minor numbers so we can use 'ttyS0' for the first serial port regardless
> of what type of port it is. We could take the arch-specific hack that
> SPARC has and try to move it to generic code. But what's the point?

The point is that it will work and the user will not be bothered
with what kind of serial port they happen to have.  A major number
per serial chip type is incredibly stupid.

I don't need to know anything about the inanrds of my computer to
bring up the ethernet interface, me caveman me bringup eth0, me on
network, caveman happy.  The same should be true for serial ports.

It's a serial port dammit, don't make it something else!

In the case of multiple instances, ordering is a sperate issue from
naming.  You keep bringing up the ordering issue but it distracts away
from the more important part which is the user having to know what
kind of serial port they have.

It's a serial port, and like a scsi disk or and ethernet interface, we
should give it a consistent name.
