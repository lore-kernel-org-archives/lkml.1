Return-Path: <linux-kernel-owner+w=401wt.eu-S1758534AbZD2JaX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758534AbZD2JaX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Apr 2009 05:30:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753358AbZD2JaI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Apr 2009 05:30:08 -0400
Received: from mail-ew0-f176.google.com ([209.85.219.176]:47950 "EHLO
	mail-ew0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751061AbZD2JaG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Apr 2009 05:30:06 -0400
Message-ID: <49F81E1B.4080908@monstr.eu>
Date: Wed, 29 Apr 2009 11:30:03 +0200
From: Michal Simek <monstr@monstr.eu>
Reply-To: monstr@monstr.eu
User-Agent: Thunderbird 2.0.0.18 (X11/20081120)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: linux-kernel@vger.kernel.org, john.williams@petalogix.com
Subject: Re: [PATCH 09/30] microblaze_mmu_v1: Page fault handling high level
 - fault.c
References: <1240821139-7247-1-git-send-email-monstr@monstr.eu>	<1240821139-7247-2-git-send-email-monstr@monstr.eu>	<1240821139-7247-3-git-send-email-monstr@monstr.eu>	<1240821139-7247-4-git-send-email-monstr@monstr.eu>	<1240821139-7247-5-git-send-email-monstr@monstr.eu>	<1240821139-7247-6-git-send-email-monstr@monstr.eu>	<1240821139-7247-7-git-send-email-monstr@monstr.eu>	<1240821139-7247-8-git-send-email-monstr@monstr.eu>	<1240821139-7247-9-git-send-email-monstr@monstr.eu>	<1240821139-7247-10-git-send-email-monstr@monstr.eu> <20090428224625.b94c7787.akpm@linux-foundation.org>
In-Reply-To: <20090428224625.b94c7787.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> On Mon, 27 Apr 2009 10:31:58 +0200 monstr@monstr.eu wrote:
> 
>> +#if defined(CONFIG_XMON) || defined(CONFIG_KGDB)
> 
> Only powerpc can define CONFIG_XMON.  Confused.

This was there because someone in past just copy MMU function from PPC
and XMON reference was there. Microblaze use the similar MMU unit as
Xilinx ppc.

I removed all references.

Thanks,
Michal

-- 
Michal Simek, Ing. (M.Eng)
w: www.monstr.eu p: +42-0-721842854
