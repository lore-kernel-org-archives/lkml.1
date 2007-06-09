Return-Path: <linux-kernel-owner+w=401wt.eu-S1758792AbXFINRV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758792AbXFINRV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Jun 2007 09:17:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755728AbXFINRP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 Jun 2007 09:17:15 -0400
Received: from relay00.pair.com ([209.68.5.9]:1547 "HELO relay00.pair.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1754621AbXFINRO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Jun 2007 09:17:14 -0400
X-Greylist: delayed 400 seconds by postgrey-1.27 at vger.kernel.org; Sat, 09 Jun 2007 09:17:14 EDT
X-pair-Authenticated: 81.78.79.90
To: linux-kernel@vger.kernel.org
Cc: Ralph Corderoy <ralph@inputplus.co.uk>
subject: How to get an IDE Hard Reset, not a Soft Reset?
Date: Sat, 09 Jun 2007 14:10:31 +0100
From: Ralph Corderoy <ralph@inputplus.co.uk>
Message-Id: <20070609131031.CBB5014A521@blake.inputplus.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Hi,

As I understand it, an IDE hard drive can be reset in three ways.  A
power-on reset, a hard reset caused by pin 1 (RESET-) on the IDE
connector, and a soft reset (bit SRST in the device control register).
RESET- is held low on a power on, but can also be used later to do a
hard reset.

I can see there's an ioctl to do a soft reset, calling ide_do_reset(),
but how, from user space, can I do a hard reset?  If it isn't possible
from user space, is it possible in the kernel?  Pointers welcome.

Hard resets refreshes parts other soft resets cannot reach.  E.g. the
Expire flag (bit 4) of word 128 in the identify device info.

(Please keep me CC'd.)

Cheers,


Ralph.

