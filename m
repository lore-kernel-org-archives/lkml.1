Return-Path: <linux-kernel-owner+w=401wt.eu-S1751009AbZKCF10@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751009AbZKCF10 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Nov 2009 00:27:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750812AbZKCF1Z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Nov 2009 00:27:25 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:59341
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750741AbZKCF1Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Nov 2009 00:27:25 -0500
Date: Mon, 02 Nov 2009 21:27:49 -0800 (PST)
Message-Id: <20091102.212749.254220676.davem@davemloft.net>
To: tglx@linutronix.de
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org, mingo@elte.hu,
       peterz@infradead.org, fweisbec@gmail.com, vince@simtec.co.uk,
       jkacur@redhat.com, corbet@lwn.net, hch@infradead.org
Subject: Re: [patch 16/28] sparc: Remove BKL from apc
From: David Miller <davem@davemloft.net>
In-Reply-To: <20091010153349.723047498@linutronix.de>
References: <20091010153314.827301943@linutronix.de>
	<20091010153349.723047498@linutronix.de>
X-Mailer: Mew version 6.2.51 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Thomas Gleixner <tglx@linutronix.de>
Date: Sat, 10 Oct 2009 15:36:39 -0000

> commit ab772027 (sparc: arch/sparc/kernel/apc.c to unlocked_ioctl)
> added lock/unlock_kernel() to the apc ioctl code.
> 
> The code needs no serialization at all. Neither put/get_user nor the
> read/write access to the sbus devices require it. Remove BKL.
> 
> cycle_kernel_lock() was added during the big BKL pushdown. It should
> ensure the serializiation against driver init code. In this case there
> is nothing to serialize. Remove it as well.
> 
> Signed-off-by: Thomas Gleixner <tglx@linutronix.de>

Sorry, forgot to explicitly say I applied this to sparc-next-2.6, thanks.
