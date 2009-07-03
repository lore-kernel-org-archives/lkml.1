Return-Path: <linux-kernel-owner+w=401wt.eu-S1756413AbZGCHBt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756413AbZGCHBt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jul 2009 03:01:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752456AbZGCHBm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Jul 2009 03:01:42 -0400
Received: from qw-out-2122.google.com ([74.125.92.27]:17570 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752691AbZGCHBl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jul 2009 03:01:41 -0400
MIME-Version: 1.0
In-Reply-To: <20090618142610.GC10629@pengutronix.de>
References: <20090618025030.12363.69402.stgit@localhost.localdomain> 
	<20090618065814.GA12942@pengutronix.de> <fa686aa40906180635g45724119x99cd4d1e4ede59f9@mail.gmail.com> 
	<20090618142610.GC10629@pengutronix.de>
From: Grant Likely <grant.likely@secretlab.ca>
Date: Fri, 3 Jul 2009 01:01:24 -0600
Message-ID: <fa686aa40907030001r731d3d29h3873803d588cdf15@mail.gmail.com>
Subject: Re: [spi-devel-general] [PATCH v4] powerpc/5200: Add mpc5200-spi 
	(non-PSC) device driver
To: Wolfram Sang <w.sang@pengutronix.de>
Cc: linuxppc-dev@ozlabs.org, David Brownell <dbrownell@users.sourceforge.net>,
       spi-devel-general@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       jonsmirl@gmail.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 18, 2009 at 8:26 AM, Wolfram Sang<w.sang@pengutronix.de> wrote:
>> There used to be a sysfs interface for dumping these, but it was an
>> ugly misuse.  I'd like to leave these in.  I still have the sysfs bits
>> in a private patch and I'm going to rework them for debugfs.
>
> Okay. Maybe a comment stating the future use will be nice.

okay

>> > But I wonder more about the usage of the SS pin and if this chipsel is needed
>> > at all (sadly I cannot test as I don't have any board with SPI connected to
>> > that device). You define the SS-pin as output, but do not set the SSOE-bit.
>> > More, you use the MODF-feature, so the SS-pin should be defined as input?
>> > According to Table 17.3 in the PM, you have that pin defined as generic purpose
>> > output.
>>
>> That's right.  The SS handling by the SPI device is completely
>> useless, so this driver uses it as a GPIO and asserts it manually.
>
> That definately needs a comment :D (perhaps with some more details if you know them).
>
>> The MODF irq is probably irrelevant, but I'd like to leave it in for
>> completeness.
>
> But it won't work if the pin is set to output, no?

yes

> Are you sure there are no side-effects?

I'm sure.

-- 
Grant Likely, B.Sc., P.Eng.
Secret Lab Technologies Ltd.
