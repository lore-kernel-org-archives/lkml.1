Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757417Ab0BDE7z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Feb 2010 23:59:55 -0500
Received: from ironport2-out.teksavvy.com ([206.248.154.181]:32992 "EHLO
	ironport2-out.pppoe.ca" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756899Ab0BDE7x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Feb 2010 23:59:53 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AlsBAB7jaUtLd/sX/2dsb2JhbAAIgyvEdpAUgS6CPloE
X-IronPort-AV: E=Sophos;i="4.49,402,1262581200"; 
   d="scan'208";a="55291225"
Message-ID: <4B6A5443.6090804@teksavvy.com>
Date: Wed, 03 Feb 2010 23:59:47 -0500
From: Mark Lord <kernel@teksavvy.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Joe Perches <joe@perches.com>
CC: linux-kernel@vger.kernel.org, Jeff Garzik <jgarzik@pobox.com>,
       linux-ide@vger.kernel.org
Subject: Re: [PATCH 02/10] drivers/ata: Fix continuation line formats
References: <cover.1265095093.git.joe@perches.com>	 <12d39ac4f14bfe82a02b4ee246d183b48988fe12.1265095094.git.joe@perches.com>	 <4B69B0A0.2040701@teksavvy.com> <1265224535.24887.16.camel@Joe-Laptop.home>
In-Reply-To: <1265224535.24887.16.camel@Joe-Laptop.home>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Joe Perches wrote:
> On Wed, 2010-02-03 at 12:21 -0500, Mark Lord wrote:
>> Joe Perches wrote:
>>> String constants that are continued on subsequent lines with \
>>> are not good.
> []
>>> -		dev_warn(ap->dev, "Failed to compute ATA timing %d, \
>>> -				set PIO_0 timing\n", ret);
>>> +		dev_warn(ap->dev, "Failed to compute ATA timing %d, set PIO_0 timing\n",
>>> +			 ret);
>> NAK.  Just stick the ret); part onto the same line and be done with it.
> 
> :resend that I mistakenly sent only to Mark, with a couple more comments
> 
> I disagree.
> 
> Look at the long line wrapping style of the rest of the file
> and most of the kernel source.  No additional arguments to
> functions are generally used after column 80.
> 
> If it's ever agreed that all lines > 80 cols are OK or
> new args after column 80 are OK, then sure.  Until then,
> if you want it, you should do it.
..

You are the code nanny trying to get this patch in.  Not me.

-ml
