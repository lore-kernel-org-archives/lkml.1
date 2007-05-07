Return-Path: <linux-kernel-owner+w=401wt.eu-S1754015AbXEGFZN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754015AbXEGFZN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 May 2007 01:25:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754032AbXEGFZN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 May 2007 01:25:13 -0400
Received: from mailout.stusta.mhn.de ([141.84.69.5]:40280 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754015AbXEGFZK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 May 2007 01:25:10 -0400
Date: Mon, 7 May 2007 07:25:10 +0200
From: Adrian Bunk <bunk@stusta.de>
To: CIJOML <cijoml@volny.cz>
Cc: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>,
       linux-kernel@vger.kernel.org, marcel@holtmann.de,
       bluez-users@lists.sourceforge.net
Subject: Re: OOPS when swsusp/resume when connected to the internet via BT
	and GPRS
Message-ID: <20070507052510.GA4226@stusta.de>
References: <200705070005.33834.cijoml@volny.cz> <6bffcb0e0705061534l4cdd2496w8e2e2a0606f17f2e@mail.gmail.com> <200705070704.30361.cijoml@volny.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <200705070704.30361.cijoml@volny.cz>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 07, 2007 at 07:04:29AM +0200, CIJOML wrote:
> Hi Michal,
> 
> my kernel is tainted with madwifi opensource driver :). Only binary part is 
> ath_hal module, which doesn't have anythink to do with this part of kernel.

Any module can change any part of the kernel, e.g. a part of the code 
executed when loading the ath_hal module could accidentally corrupt a 
kernel data structure.

> Ath_hal is doing RF part of card to protect others tune/transmit in other 
> frequency than 2.5/5.8GHz (Wifi 802.11a/b/g).
> 
> My kernel is 100% opensource :)

That's wrong, the binary-only blob from ath_hal loaded into your kernel 
is not opensource.

> And BTW this happens also with madwifi kernel modules unloaded.

An Oops without any external module ever loaded since booting is 
strongly preferred.

> Best regards
> 
> Michal

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

