Return-Path: <linux-kernel-owner+w=401wt.eu-S1754765AbYHJVtJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754765AbYHJVtJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Aug 2008 17:49:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753763AbYHJVs5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 Aug 2008 17:48:57 -0400
Received: from smtpq2.tilbu1.nb.home.nl ([213.51.146.201]:60761 "EHLO
	smtpq2.tilbu1.nb.home.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753701AbYHJVs4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Aug 2008 17:48:56 -0400
Message-ID: <489F6253.3010703@keyaccess.nl>
Date: Sun, 10 Aug 2008 23:49:07 +0200
From: Rene Herman <rene.herman@keyaccess.nl>
User-Agent: Thunderbird 2.0.0.16 (X11/20080707)
MIME-Version: 1.0
To: Frans Pop <elendil@planet.nl>
CC: adaplas@gmail.com, mingo@elte.hu, akpm@osdl.org,
       linux-fbdev-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: Framebuffer drivers that break the boot on systemswithout the
 hardware
References: <489DFACC.6030009@keyaccess.nl> <200808092319.43139.elendil@planet.nl>
In-Reply-To: <200808092319.43139.elendil@planet.nl>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: 1.0 (+)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09-08-08 23:19, Frans Pop wrote:

> Rene Herman wrote:

>> Ingo Molnar posted a list of drivers he found to break the boot during
>> testing of randconfig kernels and among them are a number of FB drivers:
>>
>> FB_VESA
> 
> This one is set to "y" in the kernel configs for the generic Debian 
> kernels for i386 and x86_64 and is used by default for the graphical 
> version of the Debian Installer, so I'd be very surprised if it broke 
> very many systems...
> AFAIK it is only actually enabled if the 'vga=' boot parameter is passed.
> 
> Ingo's mail also lists FRAMEBUFFER_CONSOLE which again is set to "y" in 
> Debian's standard kernel configs for x86 (and probably most other 
> arches).

Okay. MDA_CONSOLE was also in there impying RAM at 0xb0000 which might 
indicate a gun/foot situation here...

>> (and FB_VIRTUAL)
> 
> This one should be fixed with 2.6.27-rc1. The commit that fixes it is:
>   commit b604838ac6d233fd6bffc0e758a818133a01ff22
>   Author: Frans Pop <elendil@planet.nl>
>   Date:   Wed Jul 23 21:31:26 2008 -0700
>     vfb: only enable if explicitly requested when compiled in

Ah, thanks.

Rene.

