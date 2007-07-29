Return-Path: <linux-kernel-owner+w=401wt.eu-S935108AbXG2Tee@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935108AbXG2Tee (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jul 2007 15:34:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934983AbXG2TeW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Jul 2007 15:34:22 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:38565 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933354AbXG2TeV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jul 2007 15:34:21 -0400
Date: Sun, 29 Jul 2007 20:34:01 +0100
From: Russell King <rmk+lkml@arm.linux.org.uk>
To: Linux Kernel List <linux-kernel@vger.kernel.org>, Greg KH <greg@kroah.com>
Subject: [BUG] undefined reference to `kobject_actions'
Message-ID: <20070729193401.GA18225@flint.arm.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Many ARM platforms fail to build with the following:

drivers/built-in.o: In function `store_uevent':
hid-input.c:(.text+0x19c4c): undefined reference to `kobject_actions'

It appears that if hotplug is disabled, kobject_actions is ifdef'd
away but hid-input still references it.

-- 
Russell King
 Linux kernel    2.6 ARM Linux   - http://www.arm.linux.org.uk/
 maintainer of:
