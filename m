Return-Path: <linux-kernel-owner+w=401wt.eu-S1754265AbZD2ImT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754265AbZD2ImT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Apr 2009 04:42:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750795AbZD2ImJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Apr 2009 04:42:09 -0400
Received: from mail-ew0-f176.google.com ([209.85.219.176]:43246 "EHLO
	mail-ew0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750724AbZD2ImI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Apr 2009 04:42:08 -0400
Message-ID: <49F812DB.4030102@monstr.eu>
Date: Wed, 29 Apr 2009 10:42:03 +0200
From: Michal Simek <monstr@monstr.eu>
Reply-To: monstr@monstr.eu
User-Agent: Thunderbird 2.0.0.18 (X11/20081120)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: linux-kernel@vger.kernel.org, john.williams@petalogix.com
Subject: Re: [PATCH 07/30] microblaze_mmu_v1: MMU initialization
References: <1240821139-7247-1-git-send-email-monstr@monstr.eu>	<1240821139-7247-2-git-send-email-monstr@monstr.eu>	<1240821139-7247-3-git-send-email-monstr@monstr.eu>	<1240821139-7247-4-git-send-email-monstr@monstr.eu>	<1240821139-7247-5-git-send-email-monstr@monstr.eu>	<1240821139-7247-6-git-send-email-monstr@monstr.eu>	<1240821139-7247-7-git-send-email-monstr@monstr.eu>	<1240821139-7247-8-git-send-email-monstr@monstr.eu> <20090428224247.888c3076.akpm@linux-foundation.org>
In-Reply-To: <20090428224247.888c3076.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> On Mon, 27 Apr 2009 10:31:56 +0200 monstr@monstr.eu wrote:
> 
>> +	/* Check for nobats option (used in mapin_ram). */
>> +	if (strstr(cmd_line, "nobats"))
>> +		__map_without_bats = 1;
> 
> Sometime you could go through the architecture and document all of its
> kernel command-line parameters in Documentation/kernel-parameters.txt.
> 
> Or maybe document them in a separate microblaze documentation file,
> which gives you a bit more freedom to expound upon what they do.
> 

I fixed it -> it will be in next version.

Thanks,
Michal

-- 
Michal Simek, Ing. (M.Eng)
w: www.monstr.eu p: +42-0-721842854
