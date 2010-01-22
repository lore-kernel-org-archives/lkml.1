Return-Path: <linux-kernel-owner+w=401wt.eu-S1754456Ab0AVBMF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754456Ab0AVBMF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jan 2010 20:12:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753268Ab0AVBMA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Jan 2010 20:12:00 -0500
Received: from sh.osrg.net ([192.16.179.4]:40542 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751898Ab0AVBL7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jan 2010 20:11:59 -0500
Date: Fri, 22 Jan 2010 10:11:25 +0900
To: monstr@monstr.eu
Cc: linux-kernel@vger.kernel.org, michal.simek@petalogix.com, arnd@arndb.de,
       linux-arch@vger.kernel.org, fujita.tomonori@lab.ntt.co.jp,
       akpm@linux-foundation.org, mingo@elte.hu, joerg.roedel@amd.com
Subject: Re: [PATCH] asm-generic: dma: Add BUG_ON for uninitialized dma_ops
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <1263982111-24123-2-git-send-email-monstr@monstr.eu>
References: <1263982111-24123-1-git-send-email-monstr@monstr.eu>
	<1263982111-24123-2-git-send-email-monstr@monstr.eu>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20100122101039D.fujita.tomonori@lab.ntt.co.jp>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (sh.osrg.net [192.16.179.4]); Fri, 22 Jan 2010 10:11:27 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 20 Jan 2010 11:08:31 +0100
monstr@monstr.eu wrote:

> From: Michal Simek <monstr@monstr.eu>
> 
> Check that dma_ops are initialized correctly. Without this
> checking you get kernel fault and you don't know where the problem is.

Hmm, dma_ops is initialized in early architecture-specific boot-up
code. We don't change it often. I don't think that we need much time
to find where problems are.

The benefit is insufficient to justify the overhead.
