Return-Path: <linux-kernel-owner+w=401wt.eu-S1758925AbYEEOTs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758925AbYEEOTs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2008 10:19:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754901AbYEEOTi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 May 2008 10:19:38 -0400
Received: from smtp1.wifiinternet.cz ([89.31.47.1]:63509 "EHLO
	bor.wifiinternet.cz" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752629AbYEEOTi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2008 10:19:38 -0400
Message-ID: <481F17A8.3000804@seznam.cz>
Date: Mon, 05 May 2008 16:20:24 +0200
From: Michal Simek <monstr@seznam.cz>
Reply-To: monstr@seznam.cz
User-Agent: Thunderbird 2.0.0.14 (Windows/20080421)
MIME-Version: 1.0
To: John Williams <john.williams@petalogix.com>
CC: linux-kernel@vger.kernel.org, arnd@arndb.de, linux-arch@vger.kernel.org,
       stephen.neuendorffer@xilinx.com, John.Linn@xilinx.com, matthew@wil.cx,
       will.newton@gmail.com, drepper@redhat.com,
       microblaze-uclinux@itee.uq.edu.au, grant.likely@secretlab.ca,
       Michal Simek <monstr@monstr.eu>
Subject: Re: [PATCH 08/56] microblaze_v2: Interrupt handling, timer support,
 supported function
References: <1209901305-6404-1-git-send-email-monstr@seznam.cz>	 <a4a778e34c66d126f5c4bf1ca423cf32950ea5ab.1209897266.git.monstr@monstr.eu>	 <c805caeb1dd7f6d1349c4a463cb88a5342a170d2.1209897266.git.monstr@monstr.eu>	 <f120ababf2bade9aab7199bffb3014aa606e5a1c.1209897266.git.monstr@monstr.eu>	 <684c36e5ad3f598e5079e88ec195545c4a7150c2.1209897266.git.monstr@monstr.eu>	 <ed3695121faf485d491cecdd96d5d4dcc498411d.1209897266.git.monstr@monstr.eu>	 <0674b1f7abb9a3d564b68c95bc28adc2c2fe9551.1209897266.git.monstr@monstr.eu>	 <9a7c6646e5dd9724c1cf34767adec181481fa3ef.1209897266.git.monstr@monstr.eu>	 <932956128c9c655a218a940eaf02017a5dd0bdf9.1209897266.git.monstr@monstr.eu> <1209952718.5798.44.camel@localhost>
In-Reply-To: <1209952718.5798.44.camel@localhost>
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

FIXED. Part of Kconfig was in previous email.

M


>>  arch/microblaze/kernel/hack.c  |   82 ++++++++++++++++++
>>  include/asm-microblaze/hack.h  |   24 +++++
> 
> These 'hack' files, functions and CONFIGS should be renamed.
> 
> How about
> 
>  * selfmod.[c|h] (core infrastructure)
>  * CONFIG_SELFMOD  (enables the self modifying API)
>  * CONFIG_SELFMOD_IRQ (use it on IRS)
>  * CONFIG_SELFMOD_TIMER (user it on the timer)
> 
> The last two would be dependent on CONFIG_SELFMOD
> 
> With the recent ksplice stuff it seems self-modifying code is ready for
> the mainline :)
> 
> 
> 
> 
> 
