Return-Path: <linux-kernel-owner+w=401wt.eu-S1752697AbZA1Tmd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752697AbZA1Tmd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2009 14:42:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753373AbZA1TmJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Jan 2009 14:42:09 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:36171 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753346AbZA1TmI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2009 14:42:08 -0500
Date: Wed, 28 Jan 2009 19:41:56 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Hiroshi DOYU <Hiroshi.DOYU@nokia.com>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.arm.linux.org.uk,
       linux-omap@vger.kernel.org
Subject: Re: [PATCH 05/10] omap mailbox: fix empty struct device for omap1
Message-ID: <20090128194156.GH23301@n2100.arm.linux.org.uk>
References: <20090128144955.GA23089@n2100.arm.linux.org.uk> <20090128.172951.193700554.Hiroshi.DOYU@nokia.com> <20090128175043.GB23301@n2100.arm.linux.org.uk> <20090128.212122.193700100.Hiroshi.DOYU@nokia.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090128.212122.193700100.Hiroshi.DOYU@nokia.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 28, 2009 at 09:21:22PM +0200, Hiroshi DOYU wrote:
> It seems that I misunderstood your comment in the following mail.
> 
> http://lkml.indiana.edu/hypermail/linux/kernel/0901.2/00610.html

Ah, that comment was more about that specific include in that specific
file - I couldn't see anything in there which required it.

The general rule is: if both asm/xxx.h and linux/xxx.h exists, then use
the linux/xxx.h version.  I stress _general_ rule - there are exceptions.
For example, linux/irq.h and linux/memory.h.  A clue would be if linux/xxx.h
doesn't include asm/xxx.h, then the rule above probably doesn't apply.

> Reverted both header file changes. Update attached patches.

Much better, thanks.  This I'm happy with.
