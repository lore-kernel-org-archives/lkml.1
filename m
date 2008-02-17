Return-Path: <linux-kernel-owner+w=401wt.eu-S1756690AbYBQEoZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756690AbYBQEoZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Feb 2008 23:44:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753675AbYBQEoS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 Feb 2008 23:44:18 -0500
Received: from terminus.zytor.com ([198.137.202.10]:55318 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752890AbYBQEoR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Feb 2008 23:44:17 -0500
Message-ID: <47B7B9AF.2030006@zytor.com>
Date: Sat, 16 Feb 2008 20:35:59 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Randy Dunlap <randy.dunlap@oracle.com>
CC: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       pavel@suse.cz, Len Brown <lenb@kernel.org>, sam@ravnborg.org
Subject: Re: [PATCH v2] Re: 2.6.25-rc2-mm1 (wakeup)
References: <20080216002522.9c4bd0fb.akpm@linux-foundation.org>	<20080216094844.3e5224f0.randy.dunlap@oracle.com>	<200802170218.08770.rjw@sisk.pl>	<47B78C6C.6040905@zytor.com>	<20080216181918.3f2a1665.randy.dunlap@oracle.com>	<47B7B0CE.7000701@zytor.com> <20080216203832.dc34ce5f.randy.dunlap@oracle.com>
In-Reply-To: <20080216203832.dc34ce5f.randy.dunlap@oracle.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Randy Dunlap wrote:
> On Sat, 16 Feb 2008 19:58:06 -0800 H. Peter Anvin wrote:
> 
>> Randy Dunlap wrote:
>>> Yes, adding -m32 to the X86_32 config ccflags (as is done for the
>>> X86_64 case) makes it build for me.  (like patch below)
>>>
>> It's wrong, though, because you can't assume a 32-bit compiler knows 
>> about -m32.
>>
>> You need $(call cc-option,-m32).
> 
> -cflags-$(CONFIG_X86_32) :=
> +cflags-$(CONFIG_X86_32) := $(call cc-option, -m32)
>  cflags-$(CONFIG_X86_64) := -m32

I think this works for both; that's what we do for arch/x86/boot.

	-hpa

