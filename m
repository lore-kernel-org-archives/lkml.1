Return-Path: <linux-kernel-owner+w=401wt.eu-S1423343AbXBIW3P@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423343AbXBIW3P (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Feb 2007 17:29:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423348AbXBIW3P
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Feb 2007 17:29:15 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:50700
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1423343AbXBIW3O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Feb 2007 17:29:14 -0500
Date: Fri, 09 Feb 2007 14:29:12 -0800 (PST)
Message-Id: <20070209.142912.38710040.davem@davemloft.net>
To: ak@muc.de
Cc: virtualization@lists.osdl.org, zach@vmware.com, rusty@rustcorp.com.au,
       paulus@samba.org, sfr@canb.auug.org.au, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 6/10] lguest code: the little linux hypervisor.
From: David Miller <davem@davemloft.net>
In-Reply-To: <200702091250.06482.ak@muc.de>
References: <1171018812.2718.66.camel@localhost.localdomain>
	<45CC5771.1070309@vmware.com>
	<200702091250.06482.ak@muc.de>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@muc.de>
Date: Fri, 9 Feb 2007 12:50:06 +0100

> 
> > Yes, it is a bit, umm, innovative.  If it is going to be kept, even if 
> > just for devel logging, you should disable interrupts around it.  
> > Changing segments is not a normal thing to do.
> 
> Actually that wouldn't be needed because interrupts are not allowed to do any 
> user accesses. And contrary to the name it doesn't actually change
> the segment registers, only state used by *_user.

That's right and we use this construct all throughout the
syscall compatibility layer for 64-bit platforms.
