Return-Path: <linux-kernel-owner+w=401wt.eu-S1753550AbXCPPjM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753550AbXCPPjM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Mar 2007 11:39:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753551AbXCPPjM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Mar 2007 11:39:12 -0400
Received: from hermes.domdv.de ([193.102.202.1]:2501 "EHLO hermes.domdv.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753548AbXCPPjL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Mar 2007 11:39:11 -0400
Message-ID: <45FABA1F.80002@domdv.de>
Date: Fri, 16 Mar 2007 16:39:11 +0100
From: Andreas Steinmetz <ast@domdv.de>
User-Agent: Mail/News 1.5.0.7 (X11/20060915)
MIME-Version: 1.0
To: Mariusz Kozlowski <m.kozlowski@tuxland.pl>
CC: Linux Kernel Mailinglist <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.20.3: kswapd page allocation failure
References: <45FA77D1.2060306@domdv.de> <200703161633.59984.m.kozlowski@tuxland.pl>
In-Reply-To: <200703161633.59984.m.kozlowski@tuxland.pl>
X-Enigmail-Version: 0.94.1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Mariusz Kozlowski wrote:
> Hello, 
> 
>> Got the following from dmesg of one of my servers last night (happened
>> during nightly backup over network):
>>
>> kswapd0: page allocation failure. order:3, mode:0x20
> 
> 	Take a look at this:
> 
> http://lkml.org/lkml/2007/3/15/90
> 
> Regards,
> 
> 	Mariusz Kozlowski

Thanks, I'll test "echo 16384 > /proc/sys/vm/min_free_kbytes" and see
what happens.
-- 
Andreas Steinmetz                       SPAMmers use robotrap@domdv.de
