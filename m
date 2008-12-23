Return-Path: <linux-kernel-owner+w=401wt.eu-S1752892AbYLWXzG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752892AbYLWXzG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Dec 2008 18:55:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751252AbYLWXyy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Dec 2008 18:54:54 -0500
Received: from rere.qmqm.pl ([89.167.52.164]:40798 "EHLO rere.qmqm.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751192AbYLWXyx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Dec 2008 18:54:53 -0500
Date: Wed, 24 Dec 2008 00:54:51 +0100
From: =?iso-8859-2?Q?Micha=B3_Miros=B3aw?= <mirq-linux@rere.qmqm.pl>
To: Robert Hancock <hancockr@shaw.ca>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>, linux-kernel@vger.kernel.org,
       linux-pci@vger.kernel.org, bluesmoke-devel@lists.sourceforge.net
Subject: Re: [PATCH] pci-quirks: Unhide 'Overflow' device on i828{6,7}5P/PE chipsets
Message-ID: <20081223235451.GA1796@rere.qmqm.pl>
References: <20081223215030.GA32525@rere.qmqm.pl> <495175B2.60307@shaw.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-2
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <495175B2.60307@shaw.ca>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 23, 2008 at 05:35:14PM -0600, Robert Hancock wrote:
> Micha³ Miros³aw wrote:
> >As I found out from EDAC driver sources for i82875P some BIOSes for
> >i82875P/PE hide 'overflow' device 6. The same thing happens for
> >i82865P/PE chipsets.
> >
> >After testing this patch for couple of days on my laptop (i82856P)
> >it looks like something is resetting device 0 (MCH) config register
> >0xF4 to zero and effectively disabling the device again. The delay
> >looks random to me. I can easily update the register using
> >'hexedit /sys/bus/pci/devices/0000\:00\:00.0/config' and see
> >correct values in lspci output afterwards.
> Could be the BIOS is using the device in SMI code or something (and 
> that's what disables it), therefore it may be unsafe to unhide this device.

I'm going to dig into this deeper in my spare time. Googling around
for 'System Management Mode' gave interesting pointers...

Best Regards,
Micha³ Miros³aw

