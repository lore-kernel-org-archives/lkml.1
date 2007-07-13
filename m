Return-Path: <linux-kernel-owner+w=401wt.eu-S937851AbXGMW4t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937851AbXGMW4t (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jul 2007 18:56:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757514AbXGMW4k
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Jul 2007 18:56:40 -0400
Received: from terminus.zytor.com ([198.137.202.10]:60201 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754123AbXGMW4k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jul 2007 18:56:40 -0400
Message-ID: <46980232.4080500@zytor.com>
Date: Fri, 13 Jul 2007 15:52:34 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: Ingo Freund <linux-kernel-news@e-dict.net>
CC: linux-kernel@vger.kernel.org
Subject: Re: howto create partitions bigger than 2TB
References: <4697760E.4070803@e-dict.net>
In-Reply-To: <4697760E.4070803@e-dict.net>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Freund wrote:
> Hi
> 
> I've got a RAID5 (driver aacraid for an ICP9047MA) with four
> 750GB hdds which provides a 2.25TB sized device.
> None of the until now used tools will work with that device.
> fdisk complains about missing cylinder count.
> cfdisk misses the device size.
> parted shows the right device size but only creates a partion
> with 51GB.
> What am I supposed to do to work with this device?
> Which fs can handle it?
> (CONFIG LARGE BLOCK is on)
> We are talking about a 32Bit machine with vanilla kernel 2.6.21.5.
> 

You have to use GPT partitions instead of DOS partitions (although you
may have to leave your /boot as an DOS partitions, this is supposed to
be possible as the two partitioning schemes are designed to coexist, but
I don't think parted has support for it yet.)

	-hpa
