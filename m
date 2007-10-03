Return-Path: <linux-kernel-owner+w=401wt.eu-S1758463AbXJCSlH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758463AbXJCSlH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Oct 2007 14:41:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752711AbXJCSk4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Oct 2007 14:40:56 -0400
Received: from anchor-post-33.mail.demon.net ([194.217.242.91]:4262 "EHLO
	anchor-post-33.mail.demon.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751831AbXJCSkz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Oct 2007 14:40:55 -0400
Message-ID: <4703E287.3070705@romig.demon.co.uk>
Date: Wed, 03 Oct 2007 19:42:15 +0100
From: Neil Romig <neil@romig.demon.co.uk>
User-Agent: Thunderbird 1.5 (X11/20051201)
MIME-Version: 1.0
To: Pekka Enberg <penberg@cs.helsinki.fi>
CC: linux-kernel@vger.kernel.org, hyoshiok@miraclelinux.com
Subject: Re: File corruption when using kernels 2.6.18+
References: <46FFC371.9040805@romig.demon.co.uk>	 <84144f020709300929t6aafd98at23d810d4460e898a@mail.gmail.com>	 <4702B28F.5050404@romig.demon.co.uk> <84144f020710022218x147ffc74y477c0a1be3e60d66@mail.gmail.com>
In-Reply-To: <84144f020710022218x147ffc74y477c0a1be3e60d66@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Pekka Enberg wrote:
> Hi Neil,
> 
> On 10/3/07, Neil Romig <neil@romig.demon.co.uk> wrote:
>> Thanks for your help on this. I have narrowed it down to commit
>> "c22ce143d15eb288543fe9873e1c5ac1c01b69a1 x86: cache pollution aware
>> __copy_from_user_ll()". This fits with the errors I'm getting, so now I need
>> to find out if I can safely ignore this patch, or does it have to be modified?
>> This is my first Linux bug in many years of simply using it, so I'm a little
>> nervous!
> 
> Just to make sure, if you disable CONFIG_X86_INTEL_USERCOPY, the
> corruption goes away?
> 
It took some fiddling to disable (edit arch/i386/Kconfig.cpu) but that has fixed it. Many thanks!

Does this need to be reported as a bug? Or should the kernel config scripts be changed to enable this option to be easily turned off?

Neil.
