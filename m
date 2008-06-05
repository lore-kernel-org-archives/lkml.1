Return-Path: <linux-kernel-owner+w=401wt.eu-S1756387AbYFELYu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756387AbYFELYu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2008 07:24:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754627AbYFELYk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Jun 2008 07:24:40 -0400
Received: from mail-out.m-online.net ([212.18.0.9]:48763 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755258AbYFELYj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2008 07:24:39 -0400
Date: Thu, 5 Jun 2008 13:24:36 +0200
From: Olaf Hering <olaf@aepfle.de>
To: Linus Torvalds <torvalds@linux-foundation.org>, linuxppc-dev@ozlabs.org
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.26-rc5
Message-ID: <20080605112436.GA4533@aepfle.de>
References: <alpine.LFD.1.10.0806042018060.3473@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <alpine.LFD.1.10.0806042018060.3473@woody.linux-foundation.org>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 04, Linus Torvalds wrote:

> Another week, another batch of mostly pretty small fixes. Hopefully the 
> regression list is shrinking, and we've fixed at least a couple of the 
> oopses on Arjan's list.

SATA on a dualcore G5 is broken, it happend between
c3b25b32e8bef526cca748e1ba023c6bdd705a99..53c8ba95402be65d412a806cda3430f0e72cd107

irq 18: nobody cared (try booting with the "irqpoll" option)
Disabling IRQ #18


ctrl alt del on the USB keyboard does not trigger a reboot.
Sometimes the cursor stops blinking, sometimes just nothing happens
after ctrl alt del.


Does 53c8ba95402be65d412a806cda3430f0e72cd107 work for others on G5?
