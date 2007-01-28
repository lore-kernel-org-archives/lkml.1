Return-Path: <linux-kernel-owner+w=401wt.eu-S932999AbXA1XhL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932999AbXA1XhL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Jan 2007 18:37:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933001AbXA1XhL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Jan 2007 18:37:11 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:35182
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S933000AbXA1XhJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Jan 2007 18:37:09 -0500
Date: Sun, 28 Jan 2007 15:37:07 -0800 (PST)
Message-Id: <20070128.153707.30184351.davem@davemloft.net>
To: ebiederm@xmission.com
Cc: benh@kernel.crashing.org, jeff@garzik.org, greg@kroah.com,
       tony.luck@intel.com, grundler@parisc-linux.org, mingo@elte.hu,
       linux-kernel@vger.kernel.org, kyle@parisc-linux.org,
       linuxppc-dev@ozlabs.org, brice@myri.com, shaohua.li@intel.com,
       linux-pci@atrey.karlin.mff.cuni.cz
Subject: Re: [PATCH 0/6] MSI portability cleanups
From: David Miller <davem@davemloft.net>
In-Reply-To: <m1hcuaohqj.fsf@ebiederm.dsl.xmission.com>
References: <m1bqkiq25v.fsf@ebiederm.dsl.xmission.com>
	<1170022154.26655.63.camel@localhost.localdomain>
	<m1hcuaohqj.fsf@ebiederm.dsl.xmission.com>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: ebiederm@xmission.com (Eric W. Biederman)
Date: Sun, 28 Jan 2007 16:26:44 -0700

> Yes.  In general the mainline linux kernel does not support certain
> classes of stupidity.  TCP offload engines, firmware drivers for
> hardware we care about, a fixed ABI to binary only modules, etc.
> It is the responsibility of the OS to setup MSI so we do it, not
> the firmware so we do it.

I absolutely disagree with you Eric, and I think you're being
rediculious.

If the hypervisor doesn't control the MSI PCI config space
register writes, this allows the device to spam PCI devices
which belong to other domains.

It's a freakin' reasonable design trade off decision, get over
it! :-)

Yes it can be done at the hardware level, and many hypervisor
based systems do that, but it's not the one-and-only true
way to implment inter-domain protection behind a single
PCI host controller.
