Return-Path: <linux-kernel-owner+w=401wt.eu-S1761495AbYBPAVk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761495AbYBPAVk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2008 19:21:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758397AbYBPAVc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Feb 2008 19:21:32 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:37941 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757808AbYBPAVa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2008 19:21:30 -0500
Date: Fri, 15 Feb 2008 16:21:21 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Russell King <rmk+lkml@arm.linux.org.uk>
Cc: sfr@canb.auug.org.au, linux-kernel@vger.kernel.org,
       linux-next@vger.kernel.org, linux-arch@vger.kernel.org,
       torvalds@linux-foundation.org
Subject: Re: Announce: Linux-next (Or Andrew's dream  :-))
Message-Id: <20080215162121.317c7c1c.akpm@linux-foundation.org>
In-Reply-To: <20080216000943.GD31474@flint.arm.linux.org.uk>
References: <20080212120208.f7168a91.sfr@canb.auug.org.au>
	<20080216000943.GD31474@flint.arm.linux.org.uk>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 16 Feb 2008 00:09:43 +0000
Russell King <rmk+lkml@arm.linux.org.uk> wrote:

> For reference, even _I_ don't build test the entire set of ARM defconfigs -
> at about 7 minutes a build, 75 defconfigs, that's about 9 hours...  I
> just build those which are important to myself, hope that the others are
> fine, and rely on kautobuild finding any breakage.
> 

you need a better box ;)

cerfcube_defconfig:				35 seconds
carmeva_defconfig:				23 seconds
spitz_defconfig (one of the biggest):		45 seconds

so would a stupid `for i in arch/arm/configs/*' script be sufficient
coverage?
