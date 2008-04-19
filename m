Return-Path: <linux-kernel-owner+w=401wt.eu-S1756737AbYDSIX1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756737AbYDSIX1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Apr 2008 04:23:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751549AbYDSIXQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Apr 2008 04:23:16 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:51982 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751153AbYDSIXO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Apr 2008 04:23:14 -0400
Date: Sat, 19 Apr 2008 09:17:13 +0100
From: Russell King <rmk+lkml@arm.linux.org.uk>
To: Jeff Garzik <jeff@garzik.org>
Cc: linux-arm-kernel@lists.arm.linux.org.uk, kernel@wantstofly.org,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 01/15] ARM minor irq handler cleanups
Message-ID: <20080419081712.GA8523@flint.arm.linux.org.uk>
References: <d7afbccda111e535bb14ad8082b208c7a2cd9833.1208559659.git.jgarzik@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d7afbccda111e535bb14ad8082b208c7a2cd9833.1208559659.git.jgarzik@redhat.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 18, 2008 at 07:22:45PM -0400, Jeff Garzik wrote:
> Avoid confusion by /not/ passing an unused pointer to
> arm_rtc_interrupt()
> 
> This change's main purpose is to prepare for the patchset in
> jgarzik/misc-2.6.git#irq-remove, that explores removal of the
> never-used 'irq' argument in each interrupt handler.

I don't see how these two things are connected.  Yes, it's true that
this RTC driver doesn't use 'dev_id' but that's an entirely separate
issue to removing the 'int irq' argument.

As I see it, this change is just unnecessarily adding to your workload
for this patch set.

-- 
Russell King
 Linux kernel    2.6 ARM Linux   - http://www.arm.linux.org.uk/
 maintainer of:
