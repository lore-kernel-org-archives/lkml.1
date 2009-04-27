Return-Path: <linux-kernel-owner+w=401wt.eu-S1756682AbZD0Mos@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756682AbZD0Mos (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Apr 2009 08:44:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756259AbZD0Moc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Apr 2009 08:44:32 -0400
Received: from mail-ew0-f176.google.com ([209.85.219.176]:47943 "EHLO
	mail-ew0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756596AbZD0Mob (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Apr 2009 08:44:31 -0400
Message-ID: <49F5A8AB.4040707@monstr.eu>
Date: Mon, 27 Apr 2009 14:44:27 +0200
From: Michal Simek <monstr@monstr.eu>
Reply-To: monstr@monstr.eu
User-Agent: Thunderbird 2.0.0.18 (X11/20081120)
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: Christoph Hellwig <hch@infradead.org>, linux-kernel@vger.kernel.org,
       john.williams@petalogix.com
Subject: Re: [PATCH 29/30] microblaze_mmu_v1: stat.h MMU update
References: <1240821139-7247-23-git-send-email-monstr@monstr.eu> <200904271357.01681.arnd@arndb.de> <49F5A5B2.7000307@monstr.eu> <200904271442.24870.arnd@arndb.de>
In-Reply-To: <200904271442.24870.arnd@arndb.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arnd Bergmann wrote:
> On Monday 27 April 2009, Michal Simek wrote:
>>>       long            st_size;        /* Size of file, in bytes.  */
>> Maybe unsigned? Make more sense to me that file size is not minus.
>> And for some types below.
> 
> st_size represents an off_t in user space, which is signed.
> Just over half the existing architectures use signed types
> for st_size, but for this (like Sam's suggestion for __u64),
> I don't think it matters either way.

OK. Is it mean that your structure is perfect? If yes, I'll recompile toolchain and do some more tests.

Michal

> 
> 	Arnd <><


-- 
Michal Simek, Ing. (M.Eng)
w: www.monstr.eu p: +42-0-721842854
