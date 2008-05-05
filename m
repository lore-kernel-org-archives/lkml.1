Return-Path: <linux-kernel-owner+w=401wt.eu-S1756653AbYEEGcU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756653AbYEEGcU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2008 02:32:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753858AbYEEGcK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 May 2008 02:32:10 -0400
Received: from smtp1.wifiinternet.cz ([89.31.47.1]:56671 "EHLO
	bor.wifiinternet.cz" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753775AbYEEGcI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2008 02:32:08 -0400
Message-ID: <481EAA2F.7060101@seznam.cz>
Date: Mon, 05 May 2008 08:33:19 +0200
From: Michal Simek <monstr@seznam.cz>
Reply-To: monstr@seznam.cz
User-Agent: Thunderbird 2.0.0.14 (Windows/20080421)
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: paulus@samba.org, linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org
Subject: Re: [PATCH 1/2] OF: Fix coding style violation in of_device.c and
 of_platform.c
References: <monstr@seznam.cz> <200805032304.58709.arnd@arndb.de> <481D71D3.7060703@seznam.cz> <200805042142.45872.arnd@arndb.de>
In-Reply-To: <200805042142.45872.arnd@arndb.de>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Arnd,

>> this is question to powerpc guys not to me. I haven't tried to compiled but I
>> think dcr.h is important header for powerpc.
>> I only fixed problem for Microblaze because we don't have these headers.
> 
> A google search on "microblaze DCR" shows a number of results, leading me to
> the conclusion that microblaze actually does have DCR registers. In that
> case, the best option should be to just implement a dcr.h based on 
> asm-powerpc/dcr-native.h.

You are right. Google can find a lot of things. :-)

Microblaze doesn't have any DCR instruction. If you want to use DCR you will
have to add bridge to design but I think 99,5% of designs don't have it. (Maybe
older from EDK 6 had).

Michal

