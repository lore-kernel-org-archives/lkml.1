Return-Path: <linux-kernel-owner+w=401wt.eu-S1755660AbXLFWhk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755660AbXLFWhk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Dec 2007 17:37:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752726AbXLFWhc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Dec 2007 17:37:32 -0500
Received: from gate.crashing.org ([63.228.1.57]:55456 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752704AbXLFWhb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Dec 2007 17:37:31 -0500
Subject: Re: [PATCH] pci: Fix bus resource assignment on 32 bits with 64b
	resources
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Reply-To: benh@kernel.crashing.org
To: Matthew Wilcox <matthew@wil.cx>
Cc: Greg KH <greg@kroah.com>, linux-pci@atrey.karlin.mff.cuni.cz,
       linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org
In-Reply-To: <20071206081628.GA15868@parisc-linux.org>
References: <20071205064116.D849BDE10A@ozlabs.org>
	 <1196911347.7033.15.camel@pasglop> <20071206063940.GA16474@kroah.com>
	 <1196927934.7033.39.camel@pasglop>
	 <20071206081628.GA15868@parisc-linux.org>
Content-Type: text/plain
Date: Fri, 07 Dec 2007 09:37:05 +1100
Message-Id: <1196980625.6599.3.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> It's been discussed before.  Some of the solutions discussed:
> 
>  - Add something like PRI_RES which can be concatenated into a printk.
>    Ugly.
>  - Patch gcc to allow user-definable types.  I think OpenBSD has a patch
>    for this.  Then we have to get that patch propagated to all the
>    people who compile the kernel.  Unappetising.
>  - Disable gcc's printk checking, teach sparse to typecheck printk.
>    Most people don't run sparse yet.

So you seem to dislike all 3, which one do you dislike the less ?

Cheers,
Ben.


