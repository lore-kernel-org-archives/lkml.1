Return-Path: <linux-kernel-owner+w=401wt.eu-S1753527AbYH3Kod@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753527AbYH3Kod (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Aug 2008 06:44:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751210AbYH3KoX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 30 Aug 2008 06:44:23 -0400
Received: from hpsmtp-eml18.kpnxchange.com ([213.75.38.118]:37444 "EHLO
	hpsmtp-eml18.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750978AbYH3KoW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Aug 2008 06:44:22 -0400
From: Frans Pop <elendil@planet.nl>
To: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [regression] usb: sometimes dead keyboard after boot
Date: Sat, 30 Aug 2008 12:44:19 +0200
User-Agent: KMail/1.9.9
Cc: Kernel development list <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       USB list <linux-usb@vger.kernel.org>
References: <Pine.LNX.4.44L0.0808291709400.13185-100000@netrider.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.0808291709400.13185-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200808301244.19968.elendil@planet.nl>
X-OriginalArrivalTime: 30 Aug 2008 10:44:20.0219 (UTC) FILETIME=[5BB784B0:01C90A8D]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 29 August 2008, you wrote:
> Maybe you haven't enabled anything special, but something sure is
> running.  It appears to be probing your USB devices every 5 seconds.
> You might be able to find out what it is by adding
>
> 	printk(KERN_INFO "usbdev open by %s\n", current->comm);
>
> to usbdev_open() in drivers/usb/core/devio.c.

Thanks a lot. That identified the culprit: brltty (which I only have 
installed for some very rare testing with the Debian Installer).

I'll file a bug in the Debian BTS as I know the Debian maintainer has very 
good contacts with the upstream developers.
