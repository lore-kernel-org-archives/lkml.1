Return-Path: <linux-kernel-owner+w=401wt.eu-S933006AbXA1Xoz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933006AbXA1Xoz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Jan 2007 18:44:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933007AbXA1Xoz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Jan 2007 18:44:55 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:42260
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S933006AbXA1Xoy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Jan 2007 18:44:54 -0500
Date: Sun, 28 Jan 2007 15:44:53 -0800 (PST)
Message-Id: <20070128.154453.112622887.davem@davemloft.net>
To: ebiederm@xmission.com
Cc: jeff@garzik.org, benh@kernel.crashing.org, greg@kroah.com,
       tony.luck@intel.com, grundler@parisc-linux.org, mingo@elte.hu,
       linux-kernel@vger.kernel.org, kyle@parisc-linux.org,
       linuxppc-dev@ozlabs.org, brice@myri.com, shaohua.li@intel.com,
       linux-pci@atrey.karlin.mff.cuni.cz
Subject: Re: [PATCH 0/6] MSI portability cleanups
From: David Miller <davem@davemloft.net>
In-Reply-To: <m1bqkiq25v.fsf@ebiederm.dsl.xmission.com>
References: <1170015805.26655.15.camel@localhost.localdomain>
	<45BD0BDC.40205@garzik.org>
	<m1bqkiq25v.fsf@ebiederm.dsl.xmission.com>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: ebiederm@xmission.com (Eric W. Biederman)
Date: Sun, 28 Jan 2007 14:20:12 -0700

> I see people pushing ridiculous interfaces like the RTAS hypervisor
> interface at me, and saying we must support running firmware drivers
> in the msi code.

This is not what's going on.

The hypervisor does the PCI config space programming on the
device to setup the MSI so that it can be done in a controlled
manner and such that the device cannot ever be configured by
one domain to shoot MSI packets over at devices which belong
to another domain.

It's that simple.

That's absolutely reasonable, and is I believe what you'll see the
sparc64 hypervisor(s) all needing as well.
