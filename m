Return-Path: <linux-kernel-owner+w=401wt.eu-S1766880AbXDSRGo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1766880AbXDSRGo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Apr 2007 13:06:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161505AbXDSRGo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Apr 2007 13:06:44 -0400
Received: from mailout.stusta.mhn.de ([141.84.69.5]:55870 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1161504AbXDSRGn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Apr 2007 13:06:43 -0400
Date: Thu, 19 Apr 2007 19:06:50 +0200
From: Adrian Bunk <bunk@stusta.de>
To: Andi Kleen <ak@suse.de>
Cc: discuss@x86-64.org, linux-kernel@vger.kernel.org,
       Arjan van de Ven <arjan@linux.intel.com>
Subject: Re: Dropping CONFIG_REORDER on x86-64 for 2.6.22
Message-ID: <20070419170650.GI10338@stusta.de>
References: <200704191354.52985.ak@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <200704191354.52985.ak@suse.de>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 19, 2007 at 01:54:52PM +0200, Andi Kleen wrote:
> 
> Hallo,
> 
> I'm thinking about dropping the x86-64 CONFIG_REORDER for 2.6.22. 
> The function enabled -ffunction-sections and then tries to reorder
> the executable
> 
> While that's in theory a worthy goal to save TLB/icache, in practice it 
> didn't really work out.
> 
> Rationale:
>...
> So I'm planning to drop the option and arch/x86_64/kernel/functionlist
> 
> Comments?

Have there been any benchmarks showing performance improvements 
with -ffunction-sections?

> -Andi

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

