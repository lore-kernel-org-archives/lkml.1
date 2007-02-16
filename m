Return-Path: <linux-kernel-owner+w=401wt.eu-S932359AbXBPOPi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932359AbXBPOPi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Feb 2007 09:15:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932365AbXBPOPi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Feb 2007 09:15:38 -0500
Received: from nommos.sslcatacombnetworking.com ([67.18.224.114]:12512 "EHLO
	nommos.sslcatacombnetworking.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932359AbXBPOPh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Feb 2007 09:15:37 -0500
In-Reply-To: <Pine.LNX.4.64.0702161121540.14458@scrub.home>
References: <930B9C2E-DCE3-4E9E-AA6B-2C58E16736B2@kernel.crashing.org> <Pine.LNX.4.64.0702161121540.14458@scrub.home>
Mime-Version: 1.0 (Apple Message framework v752.2)
Content-Type: text/plain; charset=US-ASCII; delsp=yes; format=flowed
Message-Id: <9AF725F4-FE65-4357-B7EB-CC03808C105D@kernel.crashing.org>
Cc: Sam Ravnborg <sam@ravnborg.org>,
       Linux Kernel list <linux-kernel@vger.kernel.org>
Content-Transfer-Encoding: 7bit
From: Kumar Gala <galak@kernel.crashing.org>
Subject: Re: kbuild question
Date: Fri, 16 Feb 2007 08:14:40 -0600
To: Roman Zippel <zippel@linux-m68k.org>
X-Mailer: Apple Mail (2.752.2)
X-PopBeforeSMTPSenders: kumar-chaos@kgala.com,kumar-statements@kgala.com,kumar@kgala.com
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - nommos.sslcatacombnetworking.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [0 0] / [47 12]
X-AntiAbuse: Sender Address Domain - kernel.crashing.org
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Feb 16, 2007, at 4:23 AM, Roman Zippel wrote:

> Hi,
>
> On Thu, 15 Feb 2007, Kumar Gala wrote:
>
>> I was wondering if there was some way to make a Kconfig menu  
>> either be just a
>> menu or a choice depending on another bool being set or not.
>>
>> What I'm trying to accomplish is if CONFIG_ONLY_HAVE_ONE is set I  
>> want it so
>> you can only select on option, however if CONFIG_ONLY_HAVE_ONE is  
>> not set you
>> should be able to select multiple options.
>
> Could you please be more specific about the problem you're trying to
> solve, instead of how you're trying to solve it?
> A real example would help a lot to understand the actual problem.

Sure, on powerpc for some of the embedded sub-architectures you can  
only select a single board to build for.  For a lot of people this is  
sufficient, however we are moving towards a world where you can  
easily build in support for multiple boards into a single kernel.

I'd like to have it such that if I'm only building support for one  
board (CONFIG_ONLY_HAVE_ONE, not going to call it that, but for this  
discussion its sufficient), you get a choice menu from Kconfig  
enforcing the ability to only select one board.  However if ! 
CONFIG_ONLY_HAVE_ONE than you can select multiple boards to build  
into your kernel.

if CONFIG_ONLY_HAVE_ONE is set we can optimize out the runtime checks  
that get added for handling the multiple board case.

Hopefully that's clear.

- k
