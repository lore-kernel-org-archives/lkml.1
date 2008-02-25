Return-Path: <linux-kernel-owner+w=401wt.eu-S1758701AbYBYQce@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758701AbYBYQce (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Feb 2008 11:32:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757957AbYBYQbW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Feb 2008 11:31:22 -0500
Received: from ug-out-1314.google.com ([66.249.92.174]:8232 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756441AbYBYQbT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Feb 2008 11:31:19 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:content-type:content-transfer-encoding;
        b=mN6EX4a9IxK+VheOavhsntcTAbx2iRW/B33VjaIV1BiBNeAE0d1MRNQk/m0Y2gpTgkrsD9943AJ+j3rseUdfdAFITH6fUYeiycSqk2/yG+29gJhATnGX8DoAtalTh/F8xl4IbiLiHOq3sc0mqQArnvWLK3tAcxR0JaTQF9lG0o0=
Message-ID: <47C2ED51.4000105@googlemail.com>
Date: Mon, 25 Feb 2008 17:31:13 +0100
From: Gabriel C <nix.or.die@googlemail.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071204)
MIME-Version: 1.0
To: Arjan van de Ven <arjan@linux.intel.com>
CC: Laurent Riffard <laurent.riffard@free.fr>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Stuart Bennett <sb476@cam.ac.uk>, Len Brown <lenb@kernel.org>
Subject: Re: 2.6.25-rc2-mm1: WARNING at arch/x86/mm/ioremap.c:129
References: <20080216002522.9c4bd0fb.akpm@linux-foundation.org> <47B7553D.5040601@free.fr> <47C0BDE2.4020402@googlemail.com> <47C0DB7D.70407@linux.intel.com>
In-Reply-To: <47C0DB7D.70407@linux.intel.com>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arjan van de Ven wrote:
> Gabriel C wrote:
>> Laurent Riffard wrote:
>>> Le 16.02.2008 09:25, Andrew Morton a écrit :
>>>> ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.25-rc2/2.6.25-rc2-mm1/
> 
>> [..]
>>
>> I'm getting that in mainline now on one of my older laptops also.
> 
> we fixed the cause of the machine you quoted; so I suspect yours is different..
> Can you get me your stacktrace ? Can you try the patch from this thread to show
> what memory the offender tries to access ?

Arjan , sorry for the lag.

With your patch from http://marc.info/?l=linux-kernel&m=120336371506283&w=2 I don't have a warning anymore.

There are the 2 dmesg's , one from 2.6.25-rc3 and other from 2.6.25-rc3+your patch:

http://frugalware.org/~crazy/dmesg/dmesg
http://frugalware.org/~crazy/dmesg/dmesg_with_patch

It seems I'm not alone with that :)

Have a look at http://lkml.org/lkml/2008/2/24/265

Regards,

Gabriel
