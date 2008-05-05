Return-Path: <linux-kernel-owner+w=401wt.eu-S1759346AbYEEOH4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759346AbYEEOH4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2008 10:07:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758202AbYEEOHW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 May 2008 10:07:22 -0400
Received: from smtp1.wifiinternet.cz ([89.31.47.1]:50339 "EHLO
	bor.wifiinternet.cz" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1759451AbYEEOHU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2008 10:07:20 -0400
Message-ID: <481F14D7.50908@seznam.cz>
Date: Mon, 05 May 2008 16:08:23 +0200
From: Michal Simek <monstr@seznam.cz>
Reply-To: monstr@seznam.cz
User-Agent: Thunderbird 2.0.0.14 (Windows/20080421)
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
       stephen.neuendorffer@xilinx.com, John.Linn@xilinx.com,
       john.williams@petalogix.com, matthew@wil.cx, will.newton@gmail.com,
       drepper@redhat.com, microblaze-uclinux@itee.uq.edu.au,
       grant.likely@secretlab.ca, Michal Simek <monstr@monstr.eu>
Subject: Re: [PATCH 52/56] microblaze_v2: pci headers
References: <1209901305-6404-1-git-send-email-monstr@seznam.cz> <affa82887bee64b05420fdd5f723cca920acad90.1209897267.git.monstr@monstr.eu> <c709de3e3767d1be8b23ce73255389c525737c36.1209897267.git.monstr@monstr.eu> <200805050045.29614.arnd@arndb.de>
In-Reply-To: <200805050045.29614.arnd@arndb.de>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


FIXED

>> +
>> +#ifdef __KERNEL__
>> +#include <asm/io.h>
>> +#endif
> 
> You don't export asm/pci.h to userspace, so the #ifdef __KERNEL__ is
> not needed.
> 
> 	Arnd <><
> 
> 
