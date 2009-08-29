Return-Path: <linux-kernel-owner+w=401wt.eu-S1751324AbZH2BPh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751324AbZH2BPh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Aug 2009 21:15:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751127AbZH2BPh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Aug 2009 21:15:37 -0400
Received: from mail2.shareable.org ([80.68.89.115]:55411 "EHLO
	mail2.shareable.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751090AbZH2BPg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Aug 2009 21:15:36 -0400
Date: Sat, 29 Aug 2009 02:15:17 +0100
From: Jamie Lokier <jamie@shareable.org>
To: Alan Cox <alan@linux.intel.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>, kvm@vger.kernel.org,
       linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org, miltonm@bga.com,
       qemu-devel@nongnu.org, borntraeger@de.ibm.com,
       brueckner@linux.vnet.ibm.com, Amit Shah <amit.shah@redhat.com>,
       virtualization@lists.linux-foundation.org
Subject: Re: [Qemu-devel] Re: Extending virtio_console to support multiple ports
Message-ID: <20090829011517.GG8036@shareable.org>
References: <1251181044-3696-1-git-send-email-amit.shah@redhat.com> <20090826112718.GA11117@amit-x200.redhat.com> <20090826154552.GA31910@amit-x200.redhat.com> <1251346023.20467.21.camel@pasglop> <20090827100809.5f0aa0a7@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090827100809.5f0aa0a7@linux.intel.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Cox wrote:
> >  - Then, are we certain that there's no case where the tty layer will
> > call us with some lock held or in an atomic context ? To be honest,
> > I've totally lost track of the locking rules in tty land lately so it
> > might well be ok, but something to verify.
> 
> Some of the less well behaved line disciplines do this and always have
> done.

I had a backtrace in my kernel log recently which looked like that,
while doing PPP over Bluetooth RFCOMM.  Resulted in AppArmor
complaining that it's hook was being called in irq context.

-- Jamie
