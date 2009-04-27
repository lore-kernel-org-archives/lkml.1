Return-Path: <linux-kernel-owner+w=401wt.eu-S1756604AbZD0Msy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756604AbZD0Msy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Apr 2009 08:48:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754618AbZD0Mso
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Apr 2009 08:48:44 -0400
Received: from mail-ew0-f176.google.com ([209.85.219.176]:61564 "EHLO
	mail-ew0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754390AbZD0Msn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Apr 2009 08:48:43 -0400
Message-ID: <49F5A9A8.8010306@monstr.eu>
Date: Mon, 27 Apr 2009 14:48:40 +0200
From: Michal Simek <monstr@monstr.eu>
Reply-To: monstr@monstr.eu
User-Agent: Thunderbird 2.0.0.18 (X11/20081120)
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: Christoph Hellwig <hch@infradead.org>, linux-kernel@vger.kernel.org,
       john.williams@petalogix.com
Subject: Re: [PATCH 29/30] microblaze_mmu_v1: stat.h MMU update
References: <1240821139-7247-23-git-send-email-monstr@monstr.eu> <200904271442.24870.arnd@arndb.de> <49F5A8AB.4040707@monstr.eu> <200904271447.40984.arnd@arndb.de>
In-Reply-To: <200904271447.40984.arnd@arndb.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arnd Bergmann wrote:
> On Monday 27 April 2009, Michal Simek wrote:
>>> st_size represents an off_t in user space, which is signed.
>>> Just over half the existing architectures use signed types
>>> for st_size, but for this (like Sam's suggestion for __u64),
>>> I don't think it matters either way.
>> OK. Is it mean that your structure is perfect? If yes,
>> I'll recompile toolchain and do some more tests. 
> 
> Please wait for my full patches, which I am about to
> post. I hope to get to the stage where literally none
> of the ABI is defined in your own header files but
> it all gets into the generic parts. I hope to get this
> out within a few hours.

OK.

Michal
> 
> 	Arnd <><


-- 
Michal Simek, Ing. (M.Eng)
w: www.monstr.eu p: +42-0-721842854
