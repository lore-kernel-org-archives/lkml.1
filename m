Return-Path: <linux-kernel-owner+w=401wt.eu-S1753184Ab0AKKWi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753184Ab0AKKWi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jan 2010 05:22:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753144Ab0AKKWi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Jan 2010 05:22:38 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:39452 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753142Ab0AKKWh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jan 2010 05:22:37 -0500
Date: Mon, 11 Jan 2010 10:26:20 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Daniel Goller <morfic@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: staging/et131x Driver Transmits but does not Receive Packets
Message-ID: <20100111102620.732b574f@lxorguk.ukuu.org.uk>
In-Reply-To: <13bb8ce11001102040j37e061fn976ec74595f30232@mail.gmail.com>
References: <13bb8ce11001101156g3cd88a6bn7c6ce657850ab534@mail.gmail.com>
	<20100111001745.21d28340@lxorguk.ukuu.org.uk>
	<13bb8ce11001101730w640f99p72ecb1204e59f139@mail.gmail.com>
	<13bb8ce11001102040j37e061fn976ec74595f30232@mail.gmail.com>
X-Mailer: Claws Mail 3.7.3 (GTK+ 2.18.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I then blacklisted iwlagn and r8169 and rebooted, retrying 2.6.29.6
> and 2.6.30.10 but was no longer able to ping anything. So when it
> works and when not is still intermittent. (And the only interfaces up
> were eth1 and lo, not eth0 (r8169) or wlan0 (iwlagn) in case someone
> wonders)

That looks like an interrupt problem. With iwlagn and r8169 blacklisted
see what interrupt number the et131x gets (cat /proc/interrupts) and see
if it goes up whenever you send/receive stuff.

If not then I don't think its an et131x problem but an IRQ routing
problem (eg a bad BIOS table, or a kernel bug elsewhere)

> I do not think i am yet at a point where git bisect would be useful.

Agreed.
