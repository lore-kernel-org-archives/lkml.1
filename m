Return-Path: <linux-kernel-owner+w=401wt.eu-S1752178AbZLTIWZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752178AbZLTIWZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Dec 2009 03:22:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752010AbZLTIWZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Dec 2009 03:22:25 -0500
Received: from mo-p00-ob.rzone.de ([81.169.146.161]:65347 "EHLO
	mo-p00-ob.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751775AbZLTIWY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Dec 2009 03:22:24 -0500
X-RZG-AUTH: :I2ANY0W6W/eA95XfH/xfO6gOxLxTty/udEMngcJ/VAKW226lDNJVyuUPIzI/Orkx
X-RZG-CLASS-ID: mo00
Message-ID: <4B2DDEC2.9080708@hartkopp.net>
Date: Sun, 20 Dec 2009 09:22:26 +0100
From: Oliver Hartkopp <oliver@hartkopp.net>
User-Agent: Mozilla-Thunderbird 2.0.0.22 (X11/20090706)
MIME-Version: 1.0
To: Steven King <sfking@fdwdc.com>, johnstul@us.ibm.com,
       Michael Guntsche <mike@it-loops.com>, Sam Ravnborg <sam@ravnborg.org>
CC: linux-kernel <linux-kernel@vger.kernel.org>
Subject: bzImage build 'fix' for x86 broke 2.6.33-rc1 boot - was: Re: Also
 on x86 - was: 2.6.33-rc1: hrtimers and tickless broken on m68knommu.
References: <4B2D27B6.3000707@hartkopp.net> <4B2D45F8.7090008@hartkopp.net>
In-Reply-To: <4B2D45F8.7090008@hartkopp.net>
X-Enigmail-Version: 0.96.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sorry for always answering myself. But to get this issue closed for the readers.

This problem tracked down by Michael Guntsche was also my problem:

http://lkml.org/lkml/2009/12/19/124

By reverting ("kbuild: fix bzImage build for x86")

http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commitdiff;h=4a2ff67c88211026afcbdbc190c13f705dae1b59

i was able to boot my first 2.6.33-rc1 ...

I'm running a Debian stable/testing here.

Tnx Michael!

Best regards,
Oliver



Oliver Hartkopp wrote:
> Oliver Hartkopp wrote:
>> Hi,
>>
>> i'm currently checking in LKML why my Dell 830 Laptop is not booting at all
>> with 2.6.33-rc1 - and i found your thread:
>>
>> http://lkml.org/lkml/2009/12/18/494
>>
>> I also use a setup with tickless & hrtimers enabled - but on a x86.
>>
>> Same behaviour as on your m68knommu box: Just nothing to see ...
> 
> I tried to dig a little deeper:
> 
> After disabling
> 
> - TICKLESS
> - HRTIMER
> - HPET
> - SMP
> 
> step by step I did not get any improvement on my Laptop :-(
> 
> So it's probably not a timer issue on my box.
> 
> The latest net-2.6 of Dave Miller is still running well ...
> 
> Regards,
> Oliver
> 
> 

