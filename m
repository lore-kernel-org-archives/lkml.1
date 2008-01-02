Return-Path: <linux-kernel-owner+w=401wt.eu-S1755427AbYABIEz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755427AbYABIEz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jan 2008 03:04:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752901AbYABIEs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Jan 2008 03:04:48 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:51023
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1752577AbYABIEr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jan 2008 03:04:47 -0500
Date: Wed, 02 Jan 2008 00:04:44 -0800 (PST)
Message-Id: <20080102.000444.18510965.davem@davemloft.net>
To: hch@infradead.org
Cc: bunk@kernel.org, vapier@gentoo.org, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org
Subject: Re: [patch] linux/ufs_fs.h: use __u64 for userspace
From: David Miller <davem@davemloft.net>
In-Reply-To: <20080102075033.GA16267@infradead.org>
References: <200801012051.41474.vapier@gentoo.org>
	<20080102020242.GP27566@does.not.exist>
	<20080102075033.GA16267@infradead.org>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Christoph Hellwig <hch@infradead.org>
Date: Wed, 2 Jan 2008 07:50:33 +0000

> The only non-kernel user of this known to me is silo, which should just
> have it's own header documenting the solaris sparc ufs variant it needs
> to understand, possibly by using a copy of the kernel version at any
> given point of time.

And this is what the current SILO sources do.
