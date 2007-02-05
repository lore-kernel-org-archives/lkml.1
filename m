Return-Path: <linux-kernel-owner+w=401wt.eu-S932374AbXBESNq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932374AbXBESNq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Feb 2007 13:13:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932622AbXBESNp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Feb 2007 13:13:45 -0500
Received: from rtr.ca ([64.26.128.89]:4583 "EHLO mail.rtr.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932374AbXBESNo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Feb 2007 13:13:44 -0500
Message-ID: <45C773D6.3010009@rtr.ca>
Date: Mon, 05 Feb 2007 13:13:42 -0500
From: Mark Lord <lkml@rtr.ca>
User-Agent: Thunderbird 1.5.0.9 (X11/20061206)
MIME-Version: 1.0
To: Patrick Ale <patrick.ale@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: hdparm for lib_pata
References: <8d158e1f0702030041xaa34440r125a39a85d498f4c@mail.gmail.com>
In-Reply-To: <8d158e1f0702030041xaa34440r125a39a85d498f4c@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Patrick Ale wrote:
> Hi guys,
> 
> Me again, sorry.
> 
> Is it possible to make hdparm work with libata?

It already works fine with libata.
..
> Anyway, I used to be able to force the drive back with using hdparm
> -X68 -d 1 /dev/sdk

Userspace PIO mode changes are NOT a good idea,
and I doubt that libata would want to support that feature.
The "-d" flag (enable/disable DMA) is currently not implemented
by libata, though there may be a /sys/.. attribute for it (?).

Cheers
