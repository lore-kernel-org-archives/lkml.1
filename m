Return-Path: <linux-kernel-owner+w=401wt.eu-S1758657AbXLaBPm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758657AbXLaBPm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Dec 2007 20:15:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751803AbXLaBPd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 30 Dec 2007 20:15:33 -0500
Received: from slackadelic.com ([65.196.224.53]:42182 "EHLO
	mail.slackadelic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751441AbXLaBPc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Dec 2007 20:15:32 -0500
From: Carlos Corbacho <carlos@strangeworlds.co.uk>
To: Alex Dubov <oakad@yahoo.com>
Subject: Re: [PATCH] [MEMSTICK] Initial commit for Sony MemoryStick support
Date: Mon, 31 Dec 2007 01:15:24 +0000
User-Agent: KMail/1.9.7
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org, drzeus@drzeus.cx
References: <250570.28220.qm@web36706.mail.mud.yahoo.com>
In-Reply-To: <250570.28220.qm@web36706.mail.mud.yahoo.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200712310115.25455.carlos@strangeworlds.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 31 December 2007 01:01:08 Alex Dubov wrote:
> This is exactly the same as with tifm_sd module if you noticed.

Unfortunately not, I've really never used tifm_sd as I don't have any MMC/ SD 
cards.

> Second, it is impossible to guess in advance, which type of card is put
> into slot (Pro, legacy or IO of either sort).

I imagined this to be the case.

> Same as mmc_block, actually. 
> The only way to get it autoloaded, is, again, with appropriate udev rule
> (uevent is emitted when card type is detected).

So do we require changes to the userspace udev rules here, or just some use of 
modalias in the drivers?

-Carlos
-- 
E-Mail: carlos@strangeworlds.co.uk
Web: strangeworlds.co.uk
GPG Key ID: 0x23EE722D
