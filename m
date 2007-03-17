Return-Path: <linux-kernel-owner+w=401wt.eu-S965580AbXCQO2D@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965580AbXCQO2D (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Mar 2007 10:28:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965583AbXCQO2D
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Mar 2007 10:28:03 -0400
Received: from nf-out-0910.google.com ([64.233.182.187]:50203 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965580AbXCQO2B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Mar 2007 10:28:01 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:x-x-sender:reply-to:to:cc:subject:in-reply-to:message-id:references:mime-version:content-type;
        b=urQF4CjSXHGuTZ8MiOlnV4pHM+WTmPGAawEiROO4g6bgmir5eUP3TlRq51LTE6OO8SUttI18vFEiHDqAbqU1Ae2XmcfBTcEwMO93VUfPVWMtChztmcecunauu9WsPKE3/fDPbx3YmZhvsD0J8VCCojPjk/9rAyzknK1Y1nx3OjM=
Date: Sat, 17 Mar 2007 16:27:51 +0200 (EET)
From: Szonyi Calin <caszonyi@gmail.com>
X-X-Sender: sony@grinch.ro
Reply-To: Calin Szonyi <caszonyi@gmail.com>
To: Con Kolivas <kernel@kolivas.org>
cc: linux kernel mailing list <linux-kernel@vger.kernel.org>,
       ck list <ck@vds.kolivas.org>
Subject: Re: RSDL v0.30 cpu scheduler for mainline kernels
In-Reply-To: <200703121058.11966.kernel@kolivas.org>
Message-ID: <Pine.LNX.4.64.0703171530520.1796@grinch.ro>
References: <200703121058.11966.kernel@kolivas.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 12 Mar 2007, Con Kolivas wrote:

> There are updated patches for 2.6.20, 2.6.20.2, 2.6.21-rc3 and 2.6.21-rc3-mm2
> to bring RSDL up to version 0.30 for download here:
>
> Full patches:
>
> http://ck.kolivas.org/patches/staircase-deadline/2.6.20-sched-rsdl-0.30.patch
> http://ck.kolivas.org/patches/staircase-deadline/2.6.20.2-rsdl-0.30.patch
> http://ck.kolivas.org/patches/staircase-deadline/2.6.21-rc3-sched-rsdl-0.30.patch
> http://ck.kolivas.org/patches/staircase-deadline/2.6.21-rc3-mm2-rsdl-0.30.patch
>

Works fine here. Better than mainline. I can listen music from a video dvd 
while browsing with opera and amule running. In mainline (CFQ scheduler) i 
cannot do this because the sound skips badly. With RSDL there are very few 
skips, they are shorter and related on a particular event - in this case 
clicking a link in Opera browser.

Now system info:
CPU:  AMD Duron 700 MHz, MB chipset VIAKT133 (UDMA 66), memory 384172 kB 
(reported by /proc/meminfo).

Kernel is 2.6.21-rc3 #3 PREEMPT with RSDL 0.30 patches.

Thanks

Bye
Calin


P.S. As a side note: in mainline the cpu was distributed almost equally 
between different tasks which favoured the big cpu hogs (amule and opera). 
Now, in RSDL the mplayer gets a bigger stake

--

"frate, trezeste-te, aici nu-i razboiul stelelor"
 				Radu R. pe offtopic at lug.ro

