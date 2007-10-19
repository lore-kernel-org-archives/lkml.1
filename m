Return-Path: <linux-kernel-owner+w=401wt.eu-S936284AbXJSXzd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936284AbXJSXzd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Oct 2007 19:55:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764836AbXJSXzZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Oct 2007 19:55:25 -0400
Received: from ug-out-1314.google.com ([66.249.92.173]:64907 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758773AbXJSXzX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Oct 2007 19:55:23 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:content-type:content-transfer-encoding;
        b=sOJmUrkCB1xMs5W9kyiEnhVzHW149f9eUsE+Us2xdmLTsuOlm+uKbQTu8CiEw9aMtbTEMOvzeSlz7jx/xvRuRMFtQmueUsskDgndNGR3ZkoOYYYX3oVuVig4gG58hDbvuwkzQV1A3oSI3fteSVidDTRePvSCK0YrxJ8x7SFN02s=
Message-ID: <47194132.7070905@googlemail.com>
Date: Sat, 20 Oct 2007 01:43:46 +0200
From: Gabriel C <nix.or.die@googlemail.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20071004)
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: Jiri Kosina <jikos@jikos.cz>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Gabriel C <crazy@pimpmylinux.org>
Subject: Re: some kernel headers broken in current git ?
References: <4719174A.7020004@googlemail.com> <Pine.LNX.4.64.0710192307320.18815@twin.jikos.cz> <47191F6C.2040801@googlemail.com> <47192E7D.7080409@googlemail.com> <alpine.LFD.0.9999.0710200048290.22770@localhost.localdomain>
In-Reply-To: <alpine.LFD.0.9999.0710200048290.22770@localhost.localdomain>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Thomas Gleixner wrote:
> On Sat, 20 Oct 2007, Gabriel C wrote:
>> Gabriel C wrote:
>>> Jiri Kosina wrote: 
>>>> Trying 'make mrproper' first has high chances of fixing this I'd guess.
>>> Is what I did before latest pull. 
>>>
>>> Maybe this whole tree got broken. I'll try a fresh one and report back.
>>>
>>
>> I get the same on fresh cloned git tree
>>
>> #-- git rev-parse --verify HEAD
>> c4ec20717313daafba59225f812db89595952b83
> 
> Hmm. The kernel itself compiles fine ?

Yes kernel is fine.

> 
> What external thing breaks ?

Actually I try to get VirtualBox-1.5.2_OSE to compile but I get a lot errors from 
include/asm-generic/atomic.h and other headers.

and looks like some are missing ?

...

/lib/modules/2.6.23-rc0/build/include/asm/irq_32.h:15:25: error: irq_vectors.h: No such file or directory
/lib/modules/2.6.23-rc0/build/include/asm/smp_32.h:154:26: error: mach_apicdef.h: No such file or directory

...

this is fresh cloned tree and pulled once to get your x86 updates:

#-- git rev-parse --verify HEAD
60812a4a99b796d894d2522dc63cb0fafc3be25e


Full error log can found there : -> http://194.231.229.228/current-git/errors.txt

> 
>      tglx
> 


Gabriel
