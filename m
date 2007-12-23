Return-Path: <linux-kernel-owner+w=401wt.eu-S1754058AbXLWV2X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754058AbXLWV2X (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Dec 2007 16:28:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750726AbXLWV2O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Dec 2007 16:28:14 -0500
Received: from vs166246.vserver.de ([62.75.166.246]:36325 "EHLO
	vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750709AbXLWV2O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Dec 2007 16:28:14 -0500
From: Michael Buesch <mb@bu3sch.de>
To: bcm43xx-dev@lists.berlios.de
Subject: Re: Boot time module loading problem
Date: Sun, 23 Dec 2007 22:25:59 +0100
User-Agent: KMail/1.9.6
Cc: Larry Finger <larry.finger@lwfinger.net>,
       LKML <linux-kernel@vger.kernel.org>,
       Johannes Berg <johannes@sipsolutions.net>
References: <476D38F9.4090802@gmail.com> <476E3D6D.1010203@gmail.com> <476EB966.1020304@lwfinger.net>
In-Reply-To: <476EB966.1020304@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200712232226.00194.mb@bu3sch.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 23 December 2007 20:39:18 Larry Finger wrote:
> With 2.6.24-rc5, a b43 user reports a problem at bootup. The b43 module, which should be loaded by
> the ssb module, fails with the following type of message:
> 
> ssb: Sonics Silicon Backplane found on PCI device 0000:0c:00.0
> b43: disagrees about version of symbol ssb_device_is_enabled
> b43: Unknown symbol ssb_device_is_enabled
> b43: disagrees about version of symbol ssb_pcicore_dev_irqvecs_enable
> b43: Unknown symbol ssb_pcicore_dev_irqvecs_enable
> b43: disagrees about version of symbol ssb_bus_may_powerdown
> b43: Unknown symbol ssb_bus_may_powerdown

This is a module versioning warning.
I think it's caused by a b43 compiled against a different
kernel tree than the currently running ssb module.
Different may mean that only a tiny little thing was changed, which
might not affect the API at all. modversion will complain then.

I don't use module versioning, so I can't help you how to fix this.
I'd simply suggest turning off module versioning.

-- 
Greetings Michael.
