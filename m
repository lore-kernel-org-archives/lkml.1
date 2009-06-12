Return-Path: <linux-kernel-owner+w=401wt.eu-S1757700AbZFLMi1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757700AbZFLMi1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jun 2009 08:38:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755671AbZFLMiR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Jun 2009 08:38:17 -0400
Received: from mail.atmel.fr ([81.80.104.162]:41505 "EHLO atmel-es2.atmel.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753587AbZFLMiP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jun 2009 08:38:15 -0400
Message-ID: <4A324C0C.8070302@atmel.com>
Date: Fri, 12 Jun 2009 14:37:32 +0200
From: Nicolas Ferre <nicolas.ferre@atmel.com>
Organization: atmel
User-Agent: Thunderbird 2.0.0.21 (Windows/20090302)
MIME-Version: 1.0
To: Rob Emanuele <poorarm@shoreis.com>
CC: Haavard Skinnemoen <haavard.skinnemoen@atmel.com>,
       Joey Oravec <joravec@drewtech.com>,
       linux-arm-kernel@lists.arm.linux.org.uk, linux-kernel@vger.kernel.org,
       drzeus-mmc@drzeus.cx
Subject: Re: [PATCH][Fix] New Unified AVR32/AT91 MCI Driver that supports
 both 	MCI slots used at the same time
References: <c8284b5b0906101641v586c3487i465263bb6908e3f7@mail.gmail.com>	 <20090611095432.2e3a4067@hskinnemoen-d830> <c8284b5b0906111316p1367a508vdb59ee7c2a8d2ff1@mail.gmail.com>
In-Reply-To: <c8284b5b0906111316p1367a508vdb59ee7c2a8d2ff1@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rob Emanuele :
>>  - The patch seems to do a bit too much all at once. The bug fix which
>>    has already been fixed is one example, another is the clock cap
>>    option -- we used to have a module parameter for the same purpose,
>>    but Pierre (the MMC maintainer, who should probably be added to the
>>    loop) had problems with it. If this feature was in a separate
>>    patch, it could be rejected without blowing away the rest of the
>>    driver.
> 
> Which kernel branch should I generate the patch against to have the
> most recent set of changes?

I think that you can use current (today) linus' git tree with this
additional patch from Haavard in avr32 tree
"Add support for inverted detect pin":
http://git.kernel.org/?p=linux/kernel/git/hskinnemoen/avr32-2.6.git;a=commit;h=1c1452be2e9ae282a7316c3b23987811bd7acda6

Kind regards,
-- 
Nicolas Ferre

