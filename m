Return-Path: <linux-kernel-owner+w=401wt.eu-S1757822AbXFTPxZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757822AbXFTPxZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2007 11:53:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754785AbXFTPxS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Jun 2007 11:53:18 -0400
Received: from bipbip.grupopie.com ([195.23.16.24]:40992 "EHLO
	bipbip.grupopie.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752218AbXFTPxR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2007 11:53:17 -0400
Message-ID: <46794D6B.9050301@grupopie.com>
Date: Wed, 20 Jun 2007 16:53:15 +0100
From: Paulo Marques <pmarques@grupopie.com>
Organization: Grupo PIE
User-Agent: Thunderbird 1.5.0.12 (X11/20070509)
MIME-Version: 1.0
To: Segher Boessenkool <segher@kernel.crashing.org>
CC: Mike Frysinger <vapier@gentoo.org>,
       Satyam Sharma <satyam.sharma@gmail.com>, Andrew Morton <akpm@osdl.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] remove usage of memmem from scripts/kallsyms.c
References: <4678013C.5090402@grupopie.com> <a781481a0706191147x72be6357vf0c83808b13174b8@mail.gmail.com> <200706200033.16708.vapier@gentoo.org> <467915DD.7020906@grupopie.com> <c8d2863984d16e31de2aaed038b7367a@kernel.crashing.org>
In-Reply-To: <c8d2863984d16e31de2aaed038b7367a@kernel.crashing.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Segher Boessenkool wrote:
>>>> So we could remove the "#define _GNU_SOURCE" at the top
>>>> of scripts/kallsyms.c too, presumably? If not (i.e. if there are
>>>> more GNUisms left in that file anyway), then I'm not sure if we
>>>> really gain by the change.
>>> yes, i believe this is true
>>
>> I only tried in on x86 with my toolchain and it works, but I don't 
>> know if it is worth the risk of breaking someone's setup for virtually 
>> no gain...
> 
> With the memmem() removed, the code builds (and works)
> fine on several non-GNU systems.  It should be perfectly
> safe to remove the _GNU_SOURCE. 

You're right. I went back in history and it was me who introduced the 
_GNU_SOURCE when I added the memmem too (shame on me). So, if it worked 
fine before, there is no reason to not work now that memmem is removed.

So I can:

  - send an incremental patch with just that line removed

  - send a replacement patch

  - just leave it for now and wait until I work on kallsyms again to 
silently remove that line together with other changes

Andrew, what would you prefer?

-- 
Paulo Marques - www.grupopie.com

"All I ask is a chance to prove that money can't make me happy."
