Return-Path: <linux-kernel-owner+w=401wt.eu-S1754756AbXFUIN7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754756AbXFUIN7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jun 2007 04:13:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753342AbXFUINp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Jun 2007 04:13:45 -0400
Received: from ug-out-1314.google.com ([66.249.92.173]:7922 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753370AbXFUINo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jun 2007 04:13:44 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=Nt+ohFuS68a0MC4ljlVy6pjDGlP85r9QlmKtwhG2BcfGtRHfnvRoDgc+raBANyxmDl0194q7rb18tw9pN6CoVmIRo0tWbfoojPQkBtkAtUHAnOksS0wcRJqxaK+X+dtoQAkFm4U+5QEbX3hCUL1vubA33y0iQDqU4AslxGVgQW0=
Message-ID: <665527d90706210113o14ae9c5ene46b5fcb1655bb9b@mail.gmail.com>
Date: Thu, 21 Jun 2007 10:13:42 +0200
From: "Mark Hannessen" <markhannessen@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: Via Rhine II Network Card Failure
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi list,

I have some trouble getting my network card to run.
when I run dmesg I can clearly see it being detected

eth0: VIA Rhine II at 0xee006000, 00:e0:c5:54:88:a8, IRQ 11.
eth0: MII PHY found at address 1, status 0x786d advertising 05e1 Link 45e1.

but when I try ifconfig eth0 up it fails with a no device error.

SIOCSIFADDR: No such device eth0:
ERROR while getting interface flags: No such device

I tried adding pci=routeirq too, but that didn't work either.

I know there is nothing wrong with the card itself because it works on
the linux distro that came with it.

does anyone have any hints as to what might get it up and running?

Thanks!
Mark

I attached a complete dmesg output just in case..
