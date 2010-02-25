Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759476Ab0BYRHw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Feb 2010 12:07:52 -0500
Received: from perec.tyrell.hu ([66.197.149.104]:58828 "EHLO perec.tyrell.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759465Ab0BYRHu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Feb 2010 12:07:50 -0500
Message-ID: <4B86AE61.3080701@maroy.hu>
Date: Thu, 25 Feb 2010 18:07:45 +0100
From: =?ISO-8859-1?Q?=C1kos_Mar=F3y?= <akos@maroy.hu>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Alan Stern <stern@rowland.harvard.edu>
CC: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Kernel development list <linux-kernel@vger.kernel.org>,
       Greg KH <gregkh@suse.de>, USB list <linux-usb@vger.kernel.org>
Subject: Re: pm_op(): usb_dev_suspend+0x0/0x10 returns -2 on USB device 8087:0020
References: <Pine.LNX.4.44L0.1002251020100.1686-100000@iolanthe.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.1002251020100.1686-100000@iolanthe.rowland.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alan,

> By the way, I noticed above that you have xhci-hcd installed.  As far 
> as I know, that driver does not yet support system suspend.  You should 
> try unloading xhci-hcd before doing the suspend (both with and without 
> CONFIG_USB_DEBUG).

as I added xhci among the SUSPEND_MODULES for pm, I tried pm-hibernate
after a successful pm-suspend. but this doesn't work, the machine just
goes blank, and it doesn't power off. doing a power cycle boots it 'as
usual'.

how can one debug the hibernation process?


Akos

