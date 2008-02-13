Return-Path: <linux-kernel-owner+w=401wt.eu-S933248AbYBMWvY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933248AbYBMWvY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2008 17:51:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755750AbYBMWvM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Feb 2008 17:51:12 -0500
Received: from gate.crashing.org ([63.228.1.57]:39833 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752596AbYBMWvL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2008 17:51:11 -0500
Subject: Re: [RFC/PATCH] [POWERPC] Make lmb support large physical
	addressing
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Reply-To: benh@kernel.crashing.org
To: Becky Bruce <bgill@freescale.com>
Cc: linuxppc-dev@ozlabs.org, sparclinux@vger.kernel.org, davem@davemloft.net,
       linux-kernel@vger.kernel.org
In-Reply-To: <Pine.LNX.4.64.0802131639200.24317@monty.am.freescale.net>
References: <Pine.LNX.4.64.0802131639200.24317@monty.am.freescale.net>
Content-Type: text/plain
Date: Thu, 14 Feb 2008 09:50:42 +1100
Message-Id: <1202943042.7296.48.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Wed, 2008-02-13 at 16:43 -0600, Becky Bruce wrote:
> Convert the lmb code to use phys_addr_t instead of unsigned long for
> physical addresses and sizes.  This is needed to support large amounts
> of RAM on 32-bit systems that support 36-bit physical addressing.
> 
> Built/booted on mpc8641; build tested on pasemi and 44x.
> 
> Signed-off-by: Becky Bruce <becky.bruce@freescale.com>
> ---
> Folks,
> 
> This has been sitting in my tree for a few days, and now it looks like
> David M. has submitted a patch that changes the lmb code to be shared
> between sparc and powerpc.  Sparc has no notion of a phys_addr_t.
> Should we just use u64 everywhere in this code instead?  Thoughts?

An option would be to use resource_size_t, though it's a bit yucky...

Dave, what do you prefer ?

Ben.


