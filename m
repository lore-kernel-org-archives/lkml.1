Return-Path: <linux-kernel-owner+w=401wt.eu-S1762879AbXKOB1c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762879AbXKOB1c (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2007 20:27:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754892AbXKOB1Y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Nov 2007 20:27:24 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:49383
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1753232AbXKOB1X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2007 20:27:23 -0500
Date: Wed, 14 Nov 2007 17:27:22 -0800 (PST)
Message-Id: <20071114.172722.71465976.davem@davemloft.net>
To: paulus@samba.org
Cc: hch@infradead.org, akpm@linux-foundation.org, gregkh@suse.de,
       mucci@cs.utk.edu, eranian@hpl.hp.com, wcohen@redhat.com,
       robert.richter@amd.com, linux-kernel@vger.kernel.org,
       andi@firstfloor.org
Subject: Re: [perfmon] Re: [perfmon2] perfmon2 merge news
From: David Miller <davem@davemloft.net>
In-Reply-To: <18235.40110.831730.847548@cargo.ozlabs.ibm.com>
References: <18235.32982.439970.359975@cargo.ozlabs.ibm.com>
	<20071114.152134.266510129.davem@davemloft.net>
	<18235.40110.831730.847548@cargo.ozlabs.ibm.com>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Paul Mackerras <paulus@samba.org>
Date: Thu, 15 Nov 2007 12:11:10 +1100

> The third (hard to extend cleanly) is a good point, and is a valid
> criticism of the current set of perfmon2 system calls, I think.
> However, the goal of being able to extend the interface tends to be in
> opposition to the goal of having strong typing of the interface.
> Things like a multiplexed syscall or an ioctl are much easier to
> extend but that is at the expense of losing strong typing.

I disagree.

With netlink we can just add new attributes when a new need arises for
a particular interface.  The attribute code describes the type
precisely, so there is no loss of strong typing at all.
