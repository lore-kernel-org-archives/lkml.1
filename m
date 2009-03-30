Return-Path: <linux-kernel-owner+w=401wt.eu-S1758880AbZC3VMU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758880AbZC3VMU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Mar 2009 17:12:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753836AbZC3VMJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Mar 2009 17:12:09 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:39953
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1755293AbZC3VMI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Mar 2009 17:12:08 -0400
Date: Mon, 30 Mar 2009 14:11:56 -0700 (PDT)
Message-Id: <20090330.141156.62568451.davem@davemloft.net>
To: arnd@arndb.de
Cc: geert.uytterhoeven@gmail.com, michal.simek@petalogix.com,
       linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
       linux-api@vger.kernel.org
Subject: Re: Removing __kernel_old_uid_t, git_t, dev_t
From: David Miller <davem@davemloft.net>
In-Reply-To: <200903301717.57184.arnd@arndb.de>
References: <200903301558.10598.arnd@arndb.de>
	<10f740e80903300741h387e6342veba0ccceea6714e9@mail.gmail.com>
	<200903301717.57184.arnd@arndb.de>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>
Date: Mon, 30 Mar 2009 17:17:56 +0200

> dma_addr_t is a big mess that was traditionally defined per
> architecture, in lots of wrong ways, including the misconception
> of dma64_addr_t. Sparc64 still uses a 32 bit dma_addr_t, possibly
> because it always uses an IOMMU (?). It can save some space in
> scatterlists, but might come back to bite us if someone tries
> to build a sparc64 system with actual 64-bit DMA.

There is no reason to use anything larger than a 32-bit DMA address
type on sparc64, and using 32-bit saves lots of space in many
data structures so I am unlikely to ever change this. :-)
