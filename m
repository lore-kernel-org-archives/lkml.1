Return-Path: <linux-kernel-owner+w=401wt.eu-S1753380AbZDOGWS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753380AbZDOGWS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Apr 2009 02:22:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751424AbZDOGWF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Apr 2009 02:22:05 -0400
Received: from mail-fx0-f158.google.com ([209.85.220.158]:43047 "EHLO
	mail-fx0-f158.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751408AbZDOGWE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Apr 2009 02:22:04 -0400
Message-ID: <49E57D06.3020500@petalogix.com>
Date: Wed, 15 Apr 2009 08:21:58 +0200
From: Michal Simek <michal.simek@petalogix.com>
Reply-To: michal.simek@petalogix.com
User-Agent: Thunderbird 2.0.0.18 (X11/20081120)
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: Linux Kernel list <linux-kernel@vger.kernel.org>
Subject: Re: struct exception_table_entry
References: <49DE0EC4.4010409@petalogix.com> <200904141636.11676.arnd@arndb.de>
In-Reply-To: <200904141636.11676.arnd@arndb.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arnd Bergmann wrote:
> On Thursday 09 April 2009, Michal Simek wrote:
>
>   
>> I am doing some cleanup things in MB MMU kernel and I looked at
>> exception_table_entry structure.
>> Only alpha use different types among others. Some arch use only
>> different names and types int/long.
>> I think that this structure could be moved to any generic location ->
>> asm-generic/uaccess.h folder.
>>
>> I think that this structure types should be acceptable for every archs?
>>
>> #ifndef exception_table_entry
>> struct exception_table_entry {
>>     unsigned long insn;
>>     unsigned long fixup;
>> };
>> #endif
>>
>> What do you think?
>>     
>
> Yes, sounds good to me. Have you tried using my generic version of
> uaccess.h on microblaze? It already contains a definition like this,
> though most of the header doesn't apply for MMU-based architectures.
>   
I haven't had time to look at it but it is on my list.
> I suppose it can be improved a bit, but should do the basic job.
>   
yes of course. That was just my idea. Use it only for MMU kernels +
#ifndef for structure
doesn't work I think.

Thanks,
Michal
> 	Arnd <><
>   


-- 
Michal Simek, Ing. (M.Eng)
PetaLogix - Linux Solutions for a Reconfigurable World
w: www.petalogix.com p: +61-7-30090663,+42-0-721842854 f: +61-7-30090663

