Return-Path: <linux-kernel-owner+w=401wt.eu-S1760861AbXGRWZe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760861AbXGRWZe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2007 18:25:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756078AbXGRWZX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Jul 2007 18:25:23 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:43606
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1753470AbXGRWZW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2007 18:25:22 -0400
Date: Wed, 18 Jul 2007 15:25:21 -0700 (PDT)
Message-Id: <20070718.152521.132927068.davem@davemloft.net>
To: mark@mtfhpc.demon.co.uk
Cc: sfr@canb.auug.org.au, wli@holomorphy.com, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, sparclinux@vger.kernel.org
Subject: Re: [PATCH] Mark sparc and sparc64 as not having virt_to_bus
From: David Miller <davem@davemloft.net>
In-Reply-To: <Pine.LNX.4.61.0707181458390.2120@mtfhpc.demon.co.uk>
References: <20070718144140.3b4fd82e.sfr@canb.auug.org.au>
	<Pine.LNX.4.61.0707181458390.2120@mtfhpc.demon.co.uk>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mark Fortescue <mark@mtfhpc.demon.co.uk>
Date: Wed, 18 Jul 2007 15:09:41 +0100 (BST)

> Currently, sun4c (and sun4m) do NOT support the FDC driver as a module.
> I did look at it but decided there were better issues to resolve at the 
> time.

The easiest thing to do is to make it so that the floppy driver
won't be set modular in drivers/block/Kconfig for SPARC.

