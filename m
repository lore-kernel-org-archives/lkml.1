Return-Path: <linux-kernel-owner+w=401wt.eu-S1757563AbYDWTCU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757563AbYDWTCU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2008 15:02:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753361AbYDWTCM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Apr 2008 15:02:12 -0400
Received: from nf-out-0910.google.com ([64.233.182.190]:43826 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753425AbYDWTCK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2008 15:02:10 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:organization:user-agent:mime-version:to:cc:subject:references:in-reply-to:content-type:content-transfer-encoding;
        b=H62lcKGFMFj3KAZP/Os5siseOfE7lbUo4q3IhfcoPzY83t6y5klOG4IpOMF5Wbar0mPyYujLB5HBa66j7PkMF5XGPa56pFp/MxvdHehFt8lmrxF/wNns0PNQMfdaUr0/2EvQsfrQUaad8IdN4om5AfTViB22VvC+k3TGc8Stclk=
Message-ID: <480F87AA.2080707@gmail.com>
Date: Wed, 23 Apr 2008 23:02:02 +0400
From: Dmitri Vorobiev <dmitri.vorobiev@gmail.com>
Organization: DmVo Home
User-Agent: Thunderbird 1.5.0.14ubu (X11/20080306)
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: "H. Peter Anvin" <hpa@zytor.com>, Andi Kleen <andi@firstfloor.org>,
       mingo@elte.hu, tglx@linutronix.de, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/4] x86: remove unused code and data in nexgen.c
References: <1208660074-7324-1-git-send-email-dmitri.vorobiev@gmail.com>	<1208660074-7324-3-git-send-email-dmitri.vorobiev@gmail.com>	<480AC505.1030301@zytor.com>	<877ies9x6b.fsf@basil.nowhere.org>	<480B9856.3040902@gmail.com>	<480B9ADD.9060105@zytor.com> <20080423191952.77b56569@the-village.bc.nu>
In-Reply-To: <20080423191952.77b56569@the-village.bc.nu>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Cox пишет:
> On Sun, 20 Apr 2008 15:34:53 -0400
> "H. Peter Anvin" <hpa@zytor.com> wrote:
> 
>> Dmitri Vorobiev wrote:
>>>> Also NexGen was never shipped anyways, but bought by AMD and became
>>>> the K6. So I assume whatever this file is supposed to do is done
>>>> by amd.c anyways.
>>> IOW, you claim that now it's safe enough to throw away the NexGen
>>> altogether?
>>>
>> If it never shipped, then yes, it should be safe to remove.  We don't 
>> support other vendors that never went to product, e.g. RISE or Montalvo.
> 
> There are/were a few Nexgen boxes out there - strange beast where the
> BIOS code emulated some instructions. So few I doubt killing it off is a
> problem at all.

The patch that kills the NexGen is already in Ingo's x86 tree, therefore
the beast is dead, at least from the kernel viewpoint.

Thanks,
Dmitri

> 
> Alan
> 

