Return-Path: <linux-kernel-owner+w=401wt.eu-S1761544AbXEPHCg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761544AbXEPHCg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2007 03:02:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755407AbXEPHCa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 May 2007 03:02:30 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:51160
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1753569AbXEPHC3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2007 03:02:29 -0400
Date: Wed, 16 May 2007 00:02:36 -0700 (PDT)
Message-Id: <20070516.000236.71091606.davem@davemloft.net>
To: Geert.Uytterhoeven@sonycom.com
Cc: clameter@sgi.com, akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, linuxppc-dev@ozlabs.org
Subject: Re: Slab allocators: Define common size limitations
From: David Miller <davem@davemloft.net>
In-Reply-To: <Pine.LNX.4.62.0705160855470.24080@pademelon.sonytel.be>
References: <Pine.LNX.4.64.0705152313490.5832@schroedinger.engr.sgi.com>
	<Pine.LNX.4.62.0705160855470.24080@pademelon.sonytel.be>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
Date: Wed, 16 May 2007 08:58:39 +0200 (CEST)

> E.g. for one of the PS3 drivers I need a physically contiguous 256
> KiB-aligned block of 256 KiB. Currently I'm using __alloc_bootmem()
> for that, but maybe kmalloc() becomes a suitable alternative now?

I'm allocating up to 1MB for per-process TLB hash tables
on sparc64.  But I can gracefully handle failures and it's
just a performance tweak to use such large sized tables.
