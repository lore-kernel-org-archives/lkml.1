Return-Path: <linux-kernel-owner+w=401wt.eu-S1758111AbZCaMwT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758111AbZCaMwT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Mar 2009 08:52:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755000AbZCaMwH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Mar 2009 08:52:07 -0400
Received: from mail.atmel.fr ([81.80.104.162]:48300 "EHLO atmel-es2.atmel.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754727AbZCaMwF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Mar 2009 08:52:05 -0400
Message-ID: <49D211E5.7010000@atmel.com>
Date: Tue, 31 Mar 2009 14:51:49 +0200
From: Nicolas Ferre <nicolas.ferre@atmel.com>
Organization: atmel
User-Agent: Thunderbird 2.0.0.21 (Windows/20090302)
MIME-Version: 1.0
To: ARM Linux Mailing List <linux-arm-kernel@lists.arm.linux.org.uk>
CC: Andrew Victor <avictor.za@gmail.com>,
       Linux Kernel list <linux-kernel@vger.kernel.org>,
       David Brownell <david-b@pacbell.net>,
       =?ISO-8859-1?Q?Ville_Syrj=E4l=E4?= <syrjala@sci.fi>
Subject: Re: [PATCH] AT91: manage clock by functionality instead of CPUs
References: <49CB9507.3020705@atmel.com>
In-Reply-To: <49CB9507.3020705@atmel.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Nicolas Ferre :
> In clock.c file the clock management is grouped by cpu with cpu_is_xxx()
> function. This lead to some kind of difficulties to read this file and
> maintainability issues as the number of AT91 cpus & PLLs/clocks is growing.
> 
> In this patch, I try to group clock functionality together and match cpus with
> this functionality set.
> An update to at91_pmc.h is needed to cover some new PMC possibilities (and
> some update in comments).
> 
> Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>
> ---
>  arch/arm/mach-at91/clock.c                 |  151 ++++++++++++++++++++-------
>  arch/arm/mach-at91/include/mach/at91_pmc.h |   26 ++++-
>  2 files changed, 132 insertions(+), 45 deletions(-)

I forget to add in my previous email:

Acked-by: Andrew Victor <avictor.za@gmail.com>

Ok, as we have no more comment, I submit it to the patch system.

Regards,
-- 
Nicolas Ferre

