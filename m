Return-Path: <linux-kernel-owner+w=401wt.eu-S1758867AbXETPgB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758867AbXETPgB (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 May 2007 11:36:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756613AbXETPfx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 May 2007 11:35:53 -0400
Received: from nommos.sslcatacombnetworking.com ([67.18.224.114]:12420 "EHLO
	nommos.sslcatacombnetworking.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756714AbXETPfx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 May 2007 11:35:53 -0400
In-Reply-To: <20070520102132.GB22091@uranus.ravnborg.org>
References: <20070515201914.16944e04.akpm@linux-foundation.org> <200705201212.50810.m.kozlowski@tuxland.pl> <20070520102132.GB22091@uranus.ravnborg.org>
Mime-Version: 1.0 (Apple Message framework v752.2)
Content-Type: text/plain; charset=US-ASCII; delsp=yes; format=flowed
Message-Id: <B8F6C900-F982-42E9-94A5-97A00793EFA8@kernel.crashing.org>
Cc: Mariusz Kozlowski <m.kozlowski@tuxland.pl>, linuxppc-dev@ozlabs.org,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 7bit
From: Kumar Gala <galak@kernel.crashing.org>
Subject: Re: 2.6.22-rc1-mm1
Date: Sun, 20 May 2007 10:33:58 -0500
To: Sam Ravnborg <sam@ravnborg.org>
X-Mailer: Apple Mail (2.752.2)
X-PopBeforeSMTPSenders: kumar-chaos@kgala.com,kumar-statements@kgala.com,kumar@kgala.com
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - nommos.sslcatacombnetworking.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - kernel.crashing.org
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On May 20, 2007, at 5:21 AM, Sam Ravnborg wrote:

> On Sun, May 20, 2007 at 12:12:50PM +0200, Mariusz Kozlowski wrote:
>> Hello,
>>
>> 	I tried it on iMac G3. I got a bunch of warnings
>> and finally it failed to build.
>>
>> WARNING: "fee_restarts" [arch/powerpc/kernel/built-in] is COMMON  
>> symbol
>> WARNING: "ee_restarts" [arch/powerpc/kernel/built-in] is COMMON  
>> symbol
>> WARNING: arch/powerpc/kernel/built-in.o - Section mismatch:  
>> reference to .init.data:.got2 from dt_string_start (offset 0x8)
> ....
>
> Most - but not all of these warnings should be gone when
> Linus pulls kbuild-fix.git.
> When -rc3 is ready can you then please post the result of a build.
> Then I can take a look at the remaining section mismatch warnings.

Also, I've got fixes for the COMMON symbol warnings.

- k
