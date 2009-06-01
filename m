Return-Path: <linux-kernel-owner+w=401wt.eu-S1755585AbZFAIhz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755585AbZFAIhz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jun 2009 04:37:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751643AbZFAIhs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Jun 2009 04:37:48 -0400
Received: from main.gmane.org ([80.91.229.2]:36531 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750991AbZFAIhr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jun 2009 04:37:47 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>
Subject: Re: [RFC] [PATCH] Device Tree on ARM platform
Date: Mon, 1 Jun 2009 08:37:32 +0000 (UTC)
Message-ID: <h0040c$t63$1@ger.gmane.org>
References: <1243408083.13460.14.camel@debian-nb>
	<20090530112221.GA1395@ucw.cz>
	<f73f7ab80905301829j45723fd6j6e04904c8214e3b9@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Complaints-To: usenet@ger.gmane.org
X-Gmane-NNTP-Posting-Host: iap-pxy-mow1.siemens.ru
User-Agent: Pan/0.132 (Waxed in Black)
Cc: linux-arm-kernel@lists.arm.linux.org.uk
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kyle Moffett wrote:

> On Sat, May 30, 2009 at 7:22 AM, Pavel Machek <pavel@ucw.cz> wrote:
>>> diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig index
>>> f430e15..b0ee851 100644
>>> --- a/arch/arm/Kconfig
>>> +++ b/arch/arm/Kconfig
>>> @@ -158,6 +158,17 @@ config ARCH_MTD_XIP
>>>  config GENERIC_HARDIRQS_NO__DO_IRQ
>>>       def_bool y
>>>
>>> +config OF
>>> +        def_bool y
>>> +
>>> +config PROC_DEVICETREE
>>> +        bool "Support for device tree in /proc"
>>
>> It certainly should not be in /proc.
> 
> There is unfortunately a relatively large legacy base of existing tools

And the keyword is *legacy* IMO. We have had legacy things like /proc/acpi,
/proc/ide etc. for years. However one by one they are being dropped and
replaced with more vivid interfaces. IMO one shouldn't hang around legacy
things for years. Just define and implement the replacement and delcare
that legacy interface will fade out and will be removed in a year or two.



With best wishes
Dmitry


