Return-Path: <linux-kernel-owner+w=401wt.eu-S1755059AbXJYSah@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755059AbXJYSah (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2007 14:30:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753246AbXJYSa3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Oct 2007 14:30:29 -0400
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:40514 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753215AbXJYSa2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2007 14:30:28 -0400
Date: Thu, 25 Oct 2007 20:30:55 +0200
From: Adrian Bunk <bunk@kernel.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Glauber de Oliveira Costa <gcosta@redhat.com>,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       Jeremy Fitzhardinge <jeremy@goop.org>, glommer@gmail.com
Subject: Re: [PATCH] Wipe out traditional opt from x86_64 Makefile
Message-ID: <20071025183055.GN30533@stusta.de>
References: <11933164723812-git-send-email-gcosta@redhat.com> <20071025173605.GM30533@stusta.de> <4720D8EA.1090501@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <4720D8EA.1090501@zytor.com>
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 25, 2007 at 10:56:58AM -0700, H. Peter Anvin wrote:
> Adrian Bunk wrote:
>> On Thu, Oct 25, 2007 at 09:47:52AM -0300, Glauber de Oliveira Costa wrote:
>>> Among other things, using -traditional as a gcc option stops us from
>>> using macro token pasting, which is a feature we heavily rely on.
>>>
>>> There was still a use of -traditional in arch/x86/kernel/Makefile_64,
>>> which this patch removes.
>>>
>>> I don't see any problems building kernels in my x86_64 box without
>>> -traditional.
>>> ...
>> Does it also work with gcc 3.2 ?
>
> It wouldn't be a gcc version issue, it would be a binutils (ld) version 
> issue.

Sorry for the dumb question, but how does or did the gcc -traditional 
option affect ld?

> 	-hpa

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

