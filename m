Return-Path: <linux-kernel-owner+w=401wt.eu-S1753091AbXLJAUS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753091AbXLJAUS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Dec 2007 19:20:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751527AbXLJAUF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Dec 2007 19:20:05 -0500
Received: from tomts24.bellnexxia.net ([209.226.175.187]:54061 "EHLO
	tomts24-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751322AbXLJAUD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Dec 2007 19:20:03 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Ao8CAMIUXEdFn+Sr/2dsb2JhbACkEA
Date: Sun, 9 Dec 2007 19:19:59 -0500
From: Mike Houston <mikeserv@bmts.com>
To: Jean Delvare <khali@linux-fr.org>
Cc: Elvis Pranskevichus <el@prans.net>, Mike Houston <mikeserv@bmts.com>,
       Adrian Bunk <bunk@stusta.de>, mhoffman@lightlink.com,
       linux-kernel@vger.kernel.org, lm-sensors@lm-sensors.org,
       Bjorn Helgaas <bjorn.helgaas@hp.com>, Adam Belay <ambx1@neo.rr.com>
Subject: Re: [lm-sensors] 2.6.24-rc4 hwmon it87 probe fails
Message-Id: <20071209191959.eba5a41f.mikeserv@bmts.com>
In-Reply-To: <20071209234215.748ed407@hyperion.delvare>
References: <20071204215154.7f26285e.mikeserv@bmts.com>
	<20071209000554.GF20441@stusta.de>
	<20071208212234.e00b74cd.mikeserv@bmts.com>
	<20071209105028.06ed52a6@hyperion.delvare>
	<E1J1TRp-0000ZF-6J@asgard.prans.org>
	<20071209234215.748ed407@hyperion.delvare>
X-Mailer: Sylpheed 2.4.6 (GTK+ 2.10.14; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 9 Dec 2007 23:42:15 +0100
Jean Delvare <khali@linux-fr.org> wrote:

> On Sun, 09 Dec 2007 16:12:25 -0500, Elvis Pranskevichus wrote:

> > This indeed looks like a broken ACPI BIOS since the
> > aforementioned commit touches only the PNP ACPI driver. I'm not
> > sure how to work around this, though. Ideas?
> 
> Complaining to Gigabyte seems to be the best approach.

I just happen to have a Windows Vista installation on this box as
well, and I just thought to check. Sorry, I wish I'd have thought of
it sooner but I don't go there often. You folks might be interested
to know that Windows appears to have the same silly problem with the
i/o resources (from Device Manager):

[000000290 - 000000294]  Motherboard resources
[000000290 - 00000029F]  Motherboard resources

I don't have anything that reads sensors in Windows though, so I
couldn't tell you if it could access that it87 chip or not.

So this pretty much confirms that it's a motherboard/bios issue.

Mike Houston
