Return-Path: <linux-kernel-owner+w=401wt.eu-S933639AbYBMWYV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933639AbYBMWYV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2008 17:24:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751921AbYBMWYD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Feb 2008 17:24:03 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:54352
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751119AbYBMWYA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2008 17:24:00 -0500
Date: Wed, 13 Feb 2008 14:24:32 -0800 (PST)
Message-Id: <20080213.142432.206908646.davem@davemloft.net>
To: galak@kernel.crashing.org
Cc: linuxppc-dev@ozlabs.org, sparclinux@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [GIT]: Make LMB code sharable with sparc64.
From: David Miller <davem@davemloft.net>
In-Reply-To: <D846801F-AA6B-4238-9FA4-A712EABFE800@kernel.crashing.org>
References: <20080213.004120.22092044.davem@davemloft.net>
	<D846801F-AA6B-4238-9FA4-A712EABFE800@kernel.crashing.org>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Kumar Gala <galak@kernel.crashing.org>
Date: Wed, 13 Feb 2008 07:12:26 -0600

> Does sparc have the concept of a phys_addr_t?  We are in the process  
> of expanding the lmb support to deal with 36-bit physical addresses on  
> 32-bit machines.

On sparc64, where I intend to use this, unsigned long's are 64-bit.
If you use some phys_addr_t type instead to help ppc32 along, that
would be perfectly fine with me.
