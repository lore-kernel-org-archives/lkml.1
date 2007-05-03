Return-Path: <linux-kernel-owner+w=401wt.eu-S1753888AbXECL00@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753888AbXECL00 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2007 07:26:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753913AbXECL00
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 May 2007 07:26:26 -0400
Received: from twin.jikos.cz ([213.151.79.26]:56762 "EHLO twin.jikos.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753888AbXECL0Z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2007 07:26:25 -0400
Date: Thu, 3 May 2007 13:26:06 +0200 (CEST)
From: Jiri Kosina <jikos@jikos.cz>
To: Thomas Meyer <thomas@m3y3r.de>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Appletouch is gone!
In-Reply-To: <46398A14.6060801@m3y3r.de>
Message-ID: <Pine.LNX.4.64.0705031321540.16923@twin.jikos.cz>
References: <46398A14.6060801@m3y3r.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 3 May 2007, Thomas Meyer wrote:

> With current git head from linus' tree and LOCALVERSION_AUTO [=y] and 
> USB_APPLETOUCH [=m]
> find /lib/modules/ -name apple*
> /lib/modules/2.6.20/kernel/drivers/usb/input/appletouch.ko
> /lib/modules/2.6.21/kernel/drivers/usb/input/appletouch.ko
> uname -a
> Linux hotzenplotz 2.6.21-gdc87c398

Sorry, I am not able to reproduce it here

$ grep USB_APPLETOUCH .config
CONFIG_USB_APPLETOUCH=m
$ grep LOCALVERSION_AUTO .config
CONFIG_LOCALVERSION_AUTO=y

$ ll /lib/modules/2.6.21-default-gdc87c398-dirty/kernel/drivers/usb/input/appletouch.ko
-rw-r--r-- 1 root root 33482 2007-05-03 11:23 /lib/modules/2.6.21-default-gdc87c398-dirty/kernel/drivers/usb/input/appletouch.ko

Could you please give me your full .config?

-- 
Jiri Kosina
