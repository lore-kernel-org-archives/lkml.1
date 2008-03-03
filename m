Return-Path: <linux-kernel-owner+w=401wt.eu-S1755246AbYCCWjS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755246AbYCCWjS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2008 17:39:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752486AbYCCWjB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Mar 2008 17:39:01 -0500
Received: from ns2.g-housing.de ([81.169.133.75]:38280 "EHLO mail.g-house.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752409AbYCCWjA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2008 17:39:00 -0500
Date: Mon, 3 Mar 2008 23:38:55 +0100 (CET)
From: Christian Kujau <lists@nerdbynature.de>
X-X-Sender: evil@sheep.housecafe.de
To: LKML <linux-kernel@vger.kernel.org>
cc: 0x0007@gmail.com, linux-usb@vger.kernel.org
Subject: Re: WARNING: at drivers/usb/host/ehci-hcd.c:287
In-Reply-To: <alpine.DEB.1.00.0803030058280.5974@sheep.housecafe.de>
Message-ID: <alpine.DEB.1.00.0803032330190.5974@sheep.housecafe.de>
References: <alpine.DEB.1.00.0803030058280.5974@sheep.housecafe.de>
User-Agent: Alpine 1.00 (DEB 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 3 Mar 2008, Christian Kujau wrote:
> after upgrading to 2.6.25-rc3, kern.log shows:
>
> [ 1535.884848] ------------[ cut here ]------------
> [ 1535.884855] WARNING: at drivers/usb/host/ehci-hcd.c:287

Hm, after ~24h of uptime, this message appeared 25 times already.
The WLAN USB device was used the whole time, the usb-storage module
was hardly used over the day:

# grep usb /proc/interrupts
  10:   10693403    XT-PIC-XT        ohci_hcd:usb3, eth0
  11:   10270770    XT-PIC-XT        sym53c8xx, ehci_hcd:usb1
  12:         91    XT-PIC-XT        ohci_hcd:usb2

I even tried to trigger the system freeze[0] by using usb-storage
and reading a lot from it, but no freeze, and the message could
not be triggered either - they pop up every now and then, but too often, 
IMHO.

Can anybody shed some light on this?

Thanks,
Christian.

[0] http://lkml.org/lkml/2008/2/13/566
-- 
BOFH excuse #107:

The keyboard isn't plugged in
