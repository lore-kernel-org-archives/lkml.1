Return-Path: <linux-kernel-owner+w=401wt.eu-S1757135AbZD2J3S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757135AbZD2J3S (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Apr 2009 05:29:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756538AbZD2J2p
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Apr 2009 05:28:45 -0400
Received: from ey-out-2122.google.com ([74.125.78.25]:32494 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755541AbZD2J2o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Apr 2009 05:28:44 -0400
Message-ID: <49F81DC8.2070505@monstr.eu>
Date: Wed, 29 Apr 2009 11:28:40 +0200
From: Michal Simek <monstr@monstr.eu>
Reply-To: monstr@monstr.eu
User-Agent: Thunderbird 2.0.0.18 (X11/20081120)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: linux-kernel@vger.kernel.org, john.williams@petalogix.com
Subject: Re: [PATCH 08/30] microblaze_mmu_v1: mmu.h update
References: <1240821139-7247-1-git-send-email-monstr@monstr.eu>	<1240821139-7247-2-git-send-email-monstr@monstr.eu>	<1240821139-7247-3-git-send-email-monstr@monstr.eu>	<1240821139-7247-4-git-send-email-monstr@monstr.eu>	<1240821139-7247-5-git-send-email-monstr@monstr.eu>	<1240821139-7247-6-git-send-email-monstr@monstr.eu>	<1240821139-7247-7-git-send-email-monstr@monstr.eu>	<1240821139-7247-8-git-send-email-monstr@monstr.eu>	<1240821139-7247-9-git-send-email-monstr@monstr.eu> <20090428224431.3cd75346.akpm@linux-foundation.org>
In-Reply-To: <20090428224431.3cd75346.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> On Mon, 27 Apr 2009 10:31:57 +0200 monstr@monstr.eu wrote:
> 
>> +extern PTE *Hash, *Hash_end;
>> +extern unsigned long Hash_size, Hash_mask;
> 
> These are global symbols?

NO. I removed them.

Thanks,
Michal
> 
> There's some namespace collision risk here. `microblaze_mmu_hash' or
> whatever would be a safer change.


-- 
Michal Simek, Ing. (M.Eng)
w: www.monstr.eu p: +42-0-721842854
