Return-Path: <linux-kernel-owner+w=401wt.eu-S1752902AbZIIJTS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752902AbZIIJTS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Sep 2009 05:19:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751979AbZIIJTR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Sep 2009 05:19:17 -0400
Received: from mail-yw0-f173.google.com ([209.85.211.173]:41812 "EHLO
	mail-yw0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751845AbZIIJTR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Sep 2009 05:19:17 -0400
Message-ID: <4AA771C2.2080602@petalogix.com>
Date: Wed, 09 Sep 2009 11:13:38 +0200
From: Michal Simek <michal.simek@petalogix.com>
Reply-To: michal.simek@petalogix.com
User-Agent: Thunderbird 2.0.0.18 (X11/20081120)
MIME-Version: 1.0
To: Robin Getz <rgetz@blackfin.uclinux.org>
CC: Arnd Bergmann <arnd@arndb.de>, Mike Frysinger <vapier.adi@gmail.com>,
       linux-kernel@vger.kernel.org
Subject: Re: asm-generic update candidates?
References: <200909031729.52538.rgetz@blackfin.uclinux.org> <200909041539.28384.rgetz@blackfin.uclinux.org> <200909081455.45576.arnd@arndb.de> <200909081258.50345.rgetz@blackfin.uclinux.org>
In-Reply-To: <200909081258.50345.rgetz@blackfin.uclinux.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Robin Getz wrote:
> On Tue 8 Sep 2009 08:55, Arnd Bergmann pondered:
>   
>> On Friday 04 September 2009, Robin Getz wrote:
>>     
>>> I also noticed in Linus's latest (last commit 
>>> 37d0892c5a94e208cf863e3b7bac014edee4346d):
>>>
>>> cat arch/microblaze/include/asm/ipc.h
>>> #include <asm-generic/ipc.h>
>>>
>>> but: ls include/asm-generic/ipc.h
>>> ls: cannot access include/asm-generic/ipc.h: No such file or directory
>>>       
>> Adrian Bunk killed that file in asm/ back in 2007, he probably crossed
>> patches with the microblaze architecture.
>>     
>
> Ok - that got me doing a quick look:
>
> asm-generic/compat_signal.h doesn't exist?
> arch/parisc/include/asm/compat_signal.h:#include <asm-generic/compat_signal.h>
>
> asm-generic/cpumask.h doesn't exist?
> arch/frv/include/asm/cpumask.h:#include <asm-generic/cpumask.h>
> arch/xtensa/include/asm/cpumask.h:#include <asm-generic/cpumask.h>
>
> asm-generic/ipc.h doesn't exist?
> arch/microblaze/include/asm/ipc.h:#include <asm-generic/ipc.h>
>   
Thanks for pointing. You can remove it from include/asm/ipc.h or I can
do it instead of you - just let me know.

Regards,
Michal

> arch/mn10300/include/asm/ipc.h:#include <asm-generic/ipc.h>
>
> asm-generic/rmap.h doesn't exist?
> arch/xtensa/include/asm/rmap.h:#include <asm-generic/rmap.h>
>
>
> Maybe checkpatch (or something else?) needs something to make sure all 
> referenced files are actually in the tree or in the patch?
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>   


-- 
Michal Simek, Ing. (M.Eng)
PetaLogix - Linux Solutions for a Reconfigurable World
w: www.petalogix.com p: +61-7-30090663,+42-0-721842854 f: +61-7-30090663

